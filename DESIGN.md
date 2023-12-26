This app purpose is for internal service. it's not supposed to be accessible by end user
Deployment target is Kubernetes.

Reference: https://github.com/jpmcgrath/shortener
https://medium.com/@sandeep4.verma/system-design-scalable-url-shortener-service-like-tinyurl-106f30f23a82
https://systemdesign.one/url-shortening-system-design/

# Core features
1. Shortening URLs
2. Redirecting short URLs
3. Analytics

# Performance needs
Shortening url feature should handle up to 60 requests per minute (RPM) during peak hours.
Redirection feature should handle up to 600 RPM during peak hours.

# Scalability
* Web server: horizontal, auto scaling based on the CPU load and RPM
* DB server: horizontal, auto scaling based on the CPU load
* Redis server: horizontal

# **Security Concerns**
Use rate limiter per API key. Malicious content is out of scope since this is for internal use.

# System Design
- **Architecture**: monolith
- **Database Design**: Any DB supported by ActiveRecord, which are MySQL, MariaDB and PostgreSQL
- **Shortening Algorithm**: 
  * MD5
  * SHA-256
  * CRC32
  * Base62
  * Counter Based approach. The idea is to make use of a counter instead of generating the random number each time. When the server gets a request to convert a long URL to short URL, it first talks to the counter to get a count value, this value is then passed to the base62 algorithm to generate random string. Making use of a counter to get the integer value ensures that the number we get will always be unique by default because after every request the counter increments its value.
  * Counter and hash
  * MongoDB has unique identifier for the primary key, we can do this way when using ActiveRecord. the idea is by use custom primary key, we use Redis increment to generate the hash ID. reference https://www.linqz.io/2018/10/how-to-build-a-tiny-url-service-that-scales-to-billions.html
  * Use nanoid https://github.com/radeno/nanoid.rb

For example, lets assume our counter starts from 1. Upon getting the first request to convert a long URL to short URL, our service will ask counter to provide a unique number, counter returns 1 to our service, it then increments its current value. Next time our service requests the counter for a unique number, it returns 2, for the 3rd request it returns 3 and so on.
Plan an algorithm that is efficient, generates unique identifiers, and can handle scaling. Use Zookeeper to keep the counter.


Algorithm Complexity: The algorithm should generate unique identifiers quickly, even under high load. It should have low time complexity, ideally O(1) or O(log n).
Collision Handling: Efficient handling of collisions (when two URLs hash to the same shortened URL) is crucial. The algorithm should resolve collisions quickly without significant performance degradation.
Predictability: Ensure the algorithm does not become predictable as it scales, which could pose security risks.

Storage Efficiency: The algorithm should generate short links that are compact and storage-efficient.
Database Scalability: Ensure your database schema and indexing strategy support the efficient storage and retrieval of large numbers of URLs.

Memory and CPU Usage: Evaluate the algorithm's memory and CPU usage as the number of requests increases. It should not consume excessive resources.
Profiling: Use profiling tools to identify any bottlenecks or inefficiencies in the algorithm.

Horizontal Scaling: Ensure the algorithm and its implementation are compatible with a horizontally scalable architecture. It should work consistently and efficiently across multiple servers or instances.
Distributed Environment Compatibility: If your system uses a distributed architecture, ensure the algorithm functions correctly in this environment, especially regarding data consistency and synchronization.

Adaptability: The algorithm should be adaptable to accommodate future changes, such as the introduction of new features or an increase in the short link character limit.
Extensibility: Design the algorithm to be extensible so that it can handle new requirements without major rewrites.

We can use some hash functions (like MD5 or SHA256) to hash the URL input value. Then will use some coding functions to display. For example, base36 ([a-z, 0–9]), or base62 ([a-z, A-Z, 0–9]) and base64 ([a-z, A-A, 0–9, -,.]).

The question is, what key length do we use? 6.8 or 10?

If base64 is used for 6 characters, then we have 64 ^ 6 = 68.7B URLs
If using base64 for 8 characters, then we have 64 ^ 8 = 281 trillion URLs

Because our system has 500M URLs generated each month, the system used in 5 years will have a total of:

500M * 12 months * 5 = 30B URLs / 5 years.

So with 68.7B URLs (with 6 characters) is usable for 5 years.

If we use the MD5 algorithm as a hash function, then it will generate a hash value containing 128 bits. Then base64 encodes the hash value, it will generate at least 21 characters (because each base64 character will encode 6 bits of hash value).

Meanwhile, our key space only needs 6 characters. So how can you choose a key? We can choose the first 6 characters. Although there are cases it overlaps. but the probability is only about 1 / (64 ^ 6). It is very small. Should be acceptable.

Solution
There are two approaches that can solve this problem.

* We can use an incremental integer and append to the beginning of each root link. Then it will always make sure our original link is unique, even if there are many people filling out a single link, the shortened link will always be different. And after creating the shortened link, this integer will increase by 1. But there is a problem is that if the number is increased forever, this integer will be overflow. Moreover, this incremental processing also affects the performance of the system.
* Alternatively, we can add the user_id to the beginning of each URL. However, if the user is not logged in and wants to create a shortened link, then we have to ask for another key. And this key must be unique (If the unique non-unique input key will require re-entry, until only unique).


# does mysql support data partitioning and replication?
Range Based Partitioning
Hash Based Partitioning


How long a tiny url would be ? Will it ever expire ?

Assume once a url created it will remain forever in system.

Can a customer create a tiny url of his/her choice or will it always be service generated ? If user is allowed to create customer shortened links, what would be the maximum size of custom url ?

Yes user can create a tiny url of his/her choice. Assume maximum character limit to be 16.

How many url shortening request expected per month ?

Assume 100 million new URL shortenings per month

Do we expect service to provide metrics like most visited links ?

Yes. Service should also aggregate metrics like number of URL redirections per day and other analytics for targeted advertisements.


--
Note : “HTTP 302 Redirect” status is sent back to the browser instead of “HTTP 301 Redirect”. A 301 redirect means that the page has permanently moved to a new location. A 302 redirect means that the move is only temporary. Thus, returning 302 redirect will ensure all requests for redirection reaches to our backend and we can perform analytics (Which is a functional requirement)
--

able to use mongoDB in the future, so we need to have a config to use ActiveRecord or https://github.com/mongodb/mongo-ruby-driver
for ActiveRecord, need a config to choose, use encoding or KGS

maybe cassandra too for later.

strategy:
for AR: use on-demand encoding when the data is low, then move to KGS when the performance is decreasing than normal
for Mongodb: don't know yet

- **API Design**: Define RESTful APIs for creating, retrieving, and managing short URLs.

### 3. Scalability Planning
- **Load Balancing**: Plan for distributing traffic to prevent any single point of failure.
- **Caching**: Identify opportunities for caching (e.g., frequently accessed URLs).
- **Database Scalability**: Consider replication, partitioning, and sharding strategies.

### 4. Reliability and Redundancy
- **High Availability**: Ensure system components have redundancy to handle failures.
- **Backup and Recovery**: Plan for data backup and recovery mechanisms.

### 5. Security Measures
- **Input Validation**: Ensure robust input validation to prevent injections and other attacks.
- **Rate Limiting**: Implement rate limiting to prevent abuse.
- **Secure Data Storage**: Plan for secure handling and storage of data.

### 6. Analytics and Monitoring
- **Logging and Monitoring**: Set up logging for errors, traffic, and performance metrics.
- **Analytics**: Decide on analytics data to be collected and how it will be processed.

### 7. Compliance and Privacy
- **User Data Handling**: Ensure compliance with privacy laws for user data handling and storage.
- **Terms of Service**: Prepare clear terms of service, including acceptable use policy.

### 8. Prototyping
- **Prototype**: Build a minimal viable product (MVP) to validate the core functionality and architecture.
- **Feedback Loop**: Plan for gathering feedback and iterate based on this feedback.

### 9. Deployment Strategy
- **Continuous Integration/Deployment**: Set up CI/CD pipelines for smooth deployment.
- **Environment Planning**: Plan development, testing, staging, and production environments.

### 10. Future Proofing
- **Scalability Path**: Have a clear plan for scaling up as the user base grows.
- **Technology Watch**: Keep an eye on emerging technologies that could enhance the system.

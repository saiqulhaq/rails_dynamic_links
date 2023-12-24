# Rails dynamic links

This Rails app is an alternative to Firebase Dynamic Links.  
We aim to have 100% compatibility with Firebase Dynamic Links.

For the first phase, we will try to have an URL shortener feature.  

For you who have many links registered on Firebase, please download your short links data  
on https://takeout.google.com/takeout/custom/firebase_dynamic_links.

Then import it on `/import` page

This rails app is based on ![Docker Rails Example](https://github.com/nickjj/docker-rails-example?ref=https://github.com/saiqulhaq/rails_dynamic_links) project.

# TODO

## First phase
Goals:
Allow to convert any URL to be short URL

- [x] Create a library to shorten the given URL
- [ ] Create a model to save then shorten link according to [https://firebase.google.com/support/guides/export-dynamic-links](https://firebase.google.com/support/guides/export-dynamic-links) 
- [ ] Have **import** feature to import Firebase Dynamic Links metadata that we can download from [https://takeout.google.com/takeout/custom/firebase_dynamic_links](https://takeout.google.com/takeout/custom/firebase_dynamic_links)
- [ ] Create a controller to shorten long URL

Notes:
* [Explanation on YouTube](https://youtu.be/cL1ByYwAgQk?si=KXzUN5U5_JNXeQPs)
* [Diagram on draw.io](https://drive.google.com/file/d/1KwLzK7rENinnj9Zo6ZK9Y3hG3yJRtr61/view?usp=sharing)

### Back-end

- [PostgreSQL](https://www.postgresql.org/)
- [Redis](https://redis.io/)
- [Sidekiq](https://github.com/mperham/sidekiq)
- [Action Cable](https://guides.rubyonrails.org/action_cable_overview.html)
- [ERB](https://guides.rubyonrails.org/layouts_and_rendering.html)

### Front-end

- [esbuild](https://esbuild.github.io/)
- [Hotwire Turbo](https://hotwired.dev/)
- [StimulusJS](https://stimulus.hotwired.dev/)
- [TailwindCSS](https://tailwindcss.com/)
- [Heroicons](https://heroicons.com/)


#### Setup the initial database:

```sh
# You can run this from a 2nd terminal.
./run rails db:setup
```

*We'll go over that `./run` script in a bit!*

#### Check it out in a browser:

Visit <http://localhost:8000> in your favorite browser.

#### Running the test suite:

```sh
# You can run this from the same terminal as before.
./run test
```

You can also run `./run test -b` with does the same thing but builds your JS
and CSS bundles. This could come in handy in fresh environments such as CI
where your assets haven't changed and you haven't visited the page in a
browser.

#### Stopping everything:

```sh
# Stop the containers and remove a few Docker related resources associated to this project.
docker compose down
```

You can start things up again with `docker compose up` and unlike the first
time it should only take seconds.

### `.env`

This file is ignored from version control so it will never be commit. There's a
number of environment variables defined here that control certain options and
behavior of the application. Everything is documented there.

Feel free to add new variables as needed. This is where you should put all of
your secrets as well as configuration that might change depending on your
environment (specific dev boxes, CI, production, etc.).

### `run`

You can run `./run` to get a list of commands and each command has
documentation in the `run` file itself.

It's a shell script that has a number of functions defined to help you interact
with this project. It's basically a `Makefile` except with [less
limitations](https://nickjanetakis.com/blog/replacing-make-with-a-shell-script-for-running-your-projects-tasks).
For example as a shell script it allows us to pass any arguments to another
program.

This comes in handy to run various Docker commands because sometimes these
commands can be a bit long to type. Feel free to add as many convenience
functions as you want. This file's purpose is to make your experience better!

*If you get tired of typing `./run` you can always create a shell alias with
`alias run=./run` in your `~/.bash_aliases` or equivalent file. Then you'll be
able to run `run` instead of `./run`.*

## Start and setup the project:

### If you don't use Docker

Copy `.env.example` to `.env`, then execute `source .env`.  
Then run any rails command as usual, we can run the test `rails test` or the server `rails server`

### If you use Docker

Copy `.env.example` file to `.env` then run following command

```sh
docker compose up --build

# Then in a 2nd terminal once it's up and ready.
./run rails db:setup

./run test # to run the test
./run bundle:install # to install the dependencies
./run bundle:update # to update the dependencies
```

*If you get an error upping the project related to `RuntimeError: invalid
bytecode` then you have old `tmp/` files sitting around related to the old
project name, you can run `./run clean` to clear all temporary files and fix
the error.*

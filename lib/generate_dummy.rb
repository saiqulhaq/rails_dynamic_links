# Run with: rails runner lib/generate_dummy.rb
NUMBER_OF_CLIENTS = 100
URLS_PER_CLIENT = 5_000_000..10_000_000
BASE_URL = "https://example.com/"

clients = NUMBER_OF_CLIENTS.times.map do |i|
  DynamicLinks::Client.find_or_create_by!(name: "Client_#{i}", api_key: SecureRandom.hex,
                                         hostname: "client#{i}.example.com")
end

clients.find_each do |client|
  rand(URLS_PER_CLIENT).times do |n|
    original_url = BASE_URL + SecureRandom.hex
    DynamicLinks.shorten_url(original_url, client)
    puts "Client #{client.name}, URL #{n}: Shortened #{original_url}"
  end
end

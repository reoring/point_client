require 'point_client'

endpoint = 'https://api.minut.com/draft1'

user          = ENV['POINT_USER']
password      = ENV['POINT_PASSWORD']
client_id     = ENV['POINT_CLIENT_ID']
client_secret = ENV['POINT_CLIENT_SECRET']

client = PointClient.create(endpoint, user, password, client_id, client_secret)

client.peak('<YOUR_DEVICE_ID>').each do |x|
  p x[:value]
end


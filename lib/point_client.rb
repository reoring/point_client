require "point_client/version"
require "point_client/Client"

require "faraday"
require "faraday_middleware"

module PointClient
  def self.create(endpoint, username, password, client_id, client_secret)
    @endpoint = endpoint

    conn = Faraday::Connection.new(:url => endpoint) do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      builder.use FaradayMiddleware::Instrumentation
    end
    conn.response :json

    result = conn.get '/draft1/auth/token?client_id=%s&client_secret=%s&grant_type=password&username=%s&password=%s' % [client_id, client_secret, username, password]

    @token = result.body['access_token']

    PointClient::Client.new
  end

  def self.baseConnection
    conn = Faraday::Connection.new(:url => @endpoint) do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
      builder.use FaradayMiddleware::EncodeJson
      builder.use FaradayMiddleware::Instrumentation
    end

    conn.authorization :Bearer, @token

    return conn
  end

  def self.jsonConnection
    conn = Faraday::Connection.new(:url => @endpoint) do |builder|
      builder.use Faraday::Request::UrlEncoded  # リクエストパラメータを URL エンコードする
      builder.use Faraday::Response::Logger     # リクエストを標準出力に出力する
      builder.use Faraday::Adapter::NetHttp     # Net/HTTP をアダプターに使う
      builder.use FaradayMiddleware::EncodeJson

      builder.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      builder.use FaradayMiddleware::Instrumentation
    end

    conn.authorization :Bearer, @token

    conn.response :json
    conn.request :json

    return conn
  end
end

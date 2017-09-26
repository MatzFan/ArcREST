require 'net/http'
require 'open-uri'
require 'json'

module ArcREST
  # adds metadata method
  class Server
    REGEX = %r{^\/arcgis\/rest\/services}i
    BAD_ENDPOINT = 'Invalid ArcGIS endpoint'.freeze

    attr_reader :url, :json, :version

    def initialize(url)
      @url = url
      @uri = uri
      @server_uri = server_uri
      @json = json_
      @version = version_
    end

    protected

    def json_
      parse_json @uri
    end

    def version_
      parse_json(server_uri)['currentVersion'] # subclasses use server uri
    end

    def parse_json(uri, options = {})
      JSON.parse get(uri, options)
    end

    def uri
      raise ArgumentError, BAD_ENDPOINT if (URI(@url).path =~ REGEX) != 0
      URI @url
    end

    def server_uri
      URI::HTTP.build(host: @uri.host, path: '/arcgis/rest/services')
    end

    def add_json_param_to(hash)
      { f: 'pjson' }.merge(hash) # 'pjson' guarantees id's unique
    end

    def get(uri, options = {})
      uri.query = URI.encode_www_form(add_json_param_to(options))
      open(uri).read # net/http doesn't follow redirects..
    end
  end
end

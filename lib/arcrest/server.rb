require 'net/http'
require 'json'

module ArcREST
  # adds metadata method
  class Server
    REGEX = /^\/arcgis\/rest\/services/i
    BAD_ENDPOINT = 'Invalid ArcGIS endpoint'.freeze

    attr_reader :url, :json, :version

    def initialize(url)
      @url = url
      @uri = uri
      @server_uri = server_uri
      @json = json(@uri)
      @version = version
    end

    def json(uri, options = {})
      JSON.parse get(uri, options)
    end

    def version
      json(server_uri)['currentVersion'] # subclasses use server uri
    end

    protected # sub-classes only

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
      Net::HTTP.get uri
    end
  end
end

require 'net/http'
require 'json'

module ArcREST
  # a catalog of services
  class Catalog
    attr_reader :metadata
    PATH = '/arcgis/rest/services'.freeze

    def initialize(host)
      @host = host
      @uri = uri
      json_param
      @metadata = metadata
    end

    def uri
      raise ArgumentError, 'Invalid url' if URI(@host).path.casecmp(PATH) != 0
      URI @host
    end

    def json_param
      @uri.query = URI.encode_www_form(f: 'json')
    end

    def metadata
      JSON.parse get
    end

    def get
      Net::HTTP.get @uri
    end
  end
end

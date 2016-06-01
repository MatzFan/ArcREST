require 'net/http'
require 'json'

module ArcREST
  # adds metadata method
  class Server
    REGEX = /^\/arcgis\/rest\/services/i
    BAD_ENDPOINT = 'Invalid ArcGIS endpoint'.freeze

    attr_reader :metadata, :version

    def initialize(url)
      @url = url
      @uri = uri
      @metadata = metadata(@uri)
      @version = version
    end

    def metadata(uri)
      JSON.parse get(uri)
    end

    def version
      @metadata['currentVersion']
    end

    protected # sub-classes only

    def uri
      raise ArgumentError, BAD_ENDPOINT if (URI(@url).path =~ REGEX) != 0
      URI @url
    end

    def get(uri)
      uri.query = URI.encode_www_form(f: 'pjson') # note 'pjson'
      Net::HTTP.get uri
    end
  end
end

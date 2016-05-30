module ArcREST
  # a catalog of services
  class Catalog
    include ArcREST::Base

    attr_reader :meta, :version, :services

    PATH = '/arcgis/rest/services'.freeze
    BAD_ENDPOINT = 'Invalid endpoint'.freeze

    def initialize(url)
      @url = url
      @uri = uri
      @metadata = metadata(@uri)
      @version = version
      @services = services
    end

    def version
      @metadata['currentVersion']
    end

    def services
      @metadata['services']
    end

    private

    def uri
      raise ArgumentError, BAD_ENDPOINT if URI(@url).path.casecmp(PATH) != 0
      URI @url
    end
  end
end

module ArcREST
  # a catalog of services
  class Catalog < Server
    attr_reader :folders, :services

    def initialize(url)
      super
      @services = services
    end

    def folders
      @json['folders']
    end

    def services
      @json['services']
    end
  end
end

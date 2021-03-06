module ArcREST
  # a catalog of services
  class Catalog < Server
    attr_reader :folders, :services

    def initialize(url)
      super
      @folders = folders_
      @services = services_
    end

    private

    def folders_
      @json['folders']
    end

    def services_
      @json['services']
    end
  end
end

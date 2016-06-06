module ArcREST
  # a layer
  class Layer < Server
    DEFAULT_PARAMS = { where: '1=1', outFields: '*' }.freeze

    attr_reader :id, :name, :type

    def initialize(url)
      super
      @id = id
      @name = name
      @type = type
    end

    def id
      @json['id']
    end

    def name
      @json['name']
    end

    def type
      @json['type']
    end

    def drawing_info
      @json['drawingInfo']
    end

    def fields
      @json['fields']
    end

    def query(options = {})
      json(build_uri, DEFAULT_PARAMS.merge(options))
    end

    def count
      @version > 10 ? count_only_true : v10_0_count # returnCountOnly from v10.1
    end

    private

    def v10_0_count
      query(returnIdsOnly: true)['objectIds'].size
    end

    def count_only_true
      query(returnCountOnly: true)['count']
    end

    def build_uri
      URI::HTTP.build(host: @uri.host, path: "#{@uri.path}/query")
    end
  end
end

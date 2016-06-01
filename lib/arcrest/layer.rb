module ArcREST
  # a layer
  class Layer < Server
    WHERE_ALL_FIELDS = { where: '1=1', outFields: '*' }.freeze

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
      json(build_uri, WHERE_ALL_FIELDS.merge(options))
    end

    def feature_count
      query(returnCountOnly: true)['count']
    end

    private

    def build_uri
      URI::HTTP.build(host: @uri.host, path: "#{@uri.path}/query")
    end
  end
end

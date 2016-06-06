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

    def count
      @version > 10 ? count_only_true : object_ids.count # returnCountOnly from v10.1
    end

    def object_ids # care - must specify outFields to overide default
      query(outFields: '', returnIdsOnly: true)['objectIds']
    end

    def features(options = {})
      query(options)['features']
    end

    private

    def query(options = {})
      json(build_uri, DEFAULT_PARAMS.merge(options))
    end

    def count_only_true
      query(returnCountOnly: true)['count']
    end

    def build_uri
      URI::HTTP.build(host: @uri.host, path: "#{@uri.path}/query")
    end
  end
end

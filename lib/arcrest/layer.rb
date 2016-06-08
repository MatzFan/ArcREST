module ArcREST
  class InvalidOption < StandardError; end
  class InvalidQuery < StandardError; end
  # a layer
  class Layer < Server
    TRUE = '1=1'.freeze
    ALL = '*'.freeze
    PARAMS = %w(distance geometry geometryType inSR objectIds
                outFields outSR relationParam returnDistinceValues
                returnIdsOnly spatialRel time).freeze
    PARAMS_SP1 = %w(returnCountOnly).freeze
    PARAMS_10_1 = %w(dbVersion geometryPrecision groupByFieldsForStatistics
                     maxAllowableOffset multiPatchOption orderByFields
                     outStatistics returnGeometry returnM returnZ).freeze
    PARAMS_10_3 = %w(returnExtentOnly resultOffset resultRecordCount).freeze

    attr_reader :id, :name, :type, :params

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
      @version > 10 ? count_only_true : object_ids.count # v10.1 onwards
    end

    def object_ids # care - must specify outFields to overide default
      query(options: { outFields: nil, returnIdsOnly: true })['objectIds']
    end

    def features(where: TRUE, options: {})
      query(where: where, options: options)['features']
    end

    def params
      return PARAMS if @version < 10 || @version == 10.0
      return (PARAMS + PARAMS_SP1).sort if @version < 10.1
      return (PARAMS + PARAMS_SP1 + PARAMS_10_1).sort if @version < 10.2
      (PARAMS + PARAMS_SP1 + PARAMS_10_1 + PARAMS_10_3).sort
    end

    private

    def query(where: TRUE, options: {})
      validate(options.keys.map(&:to_s).sort)
      valid_resp(build_uri, { where: where, outFields: ALL }.merge(options))
    end

    def valid_resp(uri, options)
      raise InvalidQuery if (res = response(uri, options)).keys.include? 'error'
      res
    end

    def response(uri, options)
      json(uri, options)
    end

    def validate(keys)
      keys.all? { |k| raise InvalidOption, msg(k) unless params.include? k }
    end

    def msg(key)
      "'#{key}' is an invalid option, valid query options are:\n#{PARAMS}"
    end

    def count_only_true
      query(options: { returnCountOnly: true })['count']
    end

    def build_uri
      URI::HTTP.build(host: @uri.host, path: "#{@uri.path}/query")
    end
  end
end

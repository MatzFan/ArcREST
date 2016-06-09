module ArcREST
  class InvalidOption < StandardError; end
  class BadQuery < StandardError; end
  # a layer
  class Layer < Server
    include Attributable

    E = 'error'.freeze
    ATTRIBUTES = %w(id name type drawing_info fields max_record_count).freeze
    DEFAULT_PARAMS = { where: '1=1', outFields: '*' }.freeze
    PARAMS = %w(distance geometry geometryType inSR objectIds
                outFields outSR relationParam returnDistinceValues
                returnIdsOnly spatialRel time where).freeze
    PARAMS_SP1 = %w(returnCountOnly).freeze
    PARAMS_10_1 = %w(dbVersion geometryPrecision groupByFieldsForStatistics
                     maxAllowableOffset multiPatchOption orderByFields
                     outStatistics returnGeometry returnM returnZ).freeze
    PARAMS_10_3 = %w(returnExtentOnly resultOffset resultRecordCount).freeze

    attr_reader :valid_params # other accessors set in constructor

    def initialize(url)
      super
      generate_attributes # dynamically create & assign values to attributes :)
    end

    def count
      @version > 10 ? count_only_true : object_ids.count # v10.1 onwards
    end

    def object_ids # care - must specify outFields to overide default '*'
      query(outFields: nil, returnIdsOnly: true)['objectIds']
    end

    def features(options = {})
      query(options)['features']
    end

    def valid_opts
      return PARAMS if @version < 10 || @version == 10.0
      return (PARAMS + PARAMS_SP1).sort if @version < 10.1
      return (PARAMS + PARAMS_SP1 + PARAMS_10_1).sort if @version < 10.2
      (PARAMS + PARAMS_SP1 + PARAMS_10_1 + PARAMS_10_3).sort
    end

    private

    def generate_attributes
      ATTRIBUTES.each { |name| set_attr(name, json_value(name)) }
    end

    def json_value(name)
      @json[camelify(name)]
    end

    def camelify(name)
      words = name.split('_')
      words[1..-1].map(&:capitalize).unshift(words.first).join
    end

    def query(options)
      validate(options.keys.map(&:to_s).sort)
      valid_resp(build_uri, DEFAULT_PARAMS.merge(options))
    end

    def valid_resp(uri, opts)
      raise BadQuery, m(opts) if (resp = parse_json(uri, opts)).keys.include? E
      resp
    end

    def m(options)
      "The following query parameters resulted in a 400 response:\n#{options}"
    end

    def validate(keys)
      keys.all? { |k| raise InvalidOption, msg(k) unless valid_opts.include? k }
    end

    def msg(key)
      "'#{key}' is an invalid option, valid query options are:\n#{PARAMS}"
    end

    def count_only_true
      query(returnCountOnly: true)['count']
    end

    def build_uri
      URI::HTTP.build(host: @uri.host, path: "#{@uri.path}/query")
    end
  end
end

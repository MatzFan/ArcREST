module ArcREST
  # a FeatureService or a MapService
  class Service < Server
    attr_reader :max_record_count, :capabilities, :layer_ids, :layer_names

    def initialize(url)
      super
      @max_record_count = max_record_count
      @capabilities = capabilities
      @layers = layers
      @layer_ids = layer_ids
      @layer_names = layer_names
    end

    def max_record_count
      @json['maxRecordCount']
    end

    def capabilities
      @json['capabilities'].split ','
    end

    def layer_ids
      @layers.map { |l| l['id'] }
    end

    def layer_names
      @layers.map { |l| l['name'] }
    end

    private

    def layers
      @json['layers']
    end
  end
end

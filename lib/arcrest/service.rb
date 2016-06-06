module ArcREST
  # a FeatureService or a MapService
  class Service < Server
    attr_reader :max_record_count, :capabilities, :layers

    def initialize(url)
      super
      @max_record_count = max_record_count # may be nil
      @capabilities = capabilities # may be empty
      @layers_hash = layers_hash # :id, :name
      @layers = layers # may be empty
    end

    def max_record_count
      @json['maxRecordCount']
    end

    def capabilities
      @json['capabilities'] ? @json['capabilities'].split(',') : nil
    end

    def layers
      layer_ids.map { |n| Layer.new("#{@url}/#{n.to_s}") }
    end

    private

    def layers_hash
      @json['layers']
    end

    def layer_ids
      @layers_hash.map { |l| l['id'] } if @layers_hash
    end
  end
end

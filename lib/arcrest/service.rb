module ArcREST
  # a FeatureService or a MapService
  class Service < Server
    attr_reader :max_record_count, :capabilities, :layers

    def initialize(url)
      super
      @max_record_count = max_record_count # may be nil
      @capabilities = capabilities # may be empty
      @layers = layers # may be empty
    end

    def max_record_count
      @json['maxRecordCount']
    end

    def capabilities
      @json['capabilities'] ? @json['capabilities'].split(',') : nil
    end

    def layers
      @json['layers']
    end

    private

    def layer_ids
      @layers.map { |l| l['id'] } if @layers
    end
  end
end

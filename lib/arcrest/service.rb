module ArcREST
  # a FeatureService or a MapService
  class Service < Server
    attr_reader :max_record_count, :capabilities, :layers

    def initialize(url)
      super
      @max_record_count = max_record_count_
      @capabilities = capabilities_
      @layers = layers_
    end

    private

    def max_record_count_
      @json['maxRecordCount']
    end

    def capabilities_
      @json['capabilities'] ? @json['capabilities'].split(',') : nil
    end

    def layers_
      @json['layers']
    end
  end
end

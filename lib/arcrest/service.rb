module ArcREST
  # a feature service
  class Service < Server
    attr_reader :max_record_count, :capabilities, :layers

    def initialize(url)
      super
      @max_record_count = max_record_count
      @capabilities = capabilities
      @layers = layers
    end

    def max_record_count
      @metadata['maxRecordCount']
    end

    def capabilities
      @metadata['capabilities'].split ','
    end

    def layers
      @metadata['layers']
    end
  end
end

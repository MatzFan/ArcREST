module ArcREST
  # a layer
  class Layer < Server
    attr_reader :type

    def initialize(url)
      super
      @type = type
    end

    def type
      @metadata['type']
    end

    def drawing_info
      @metadata['drawingInfo']
    end

    def fields
      @metadata['fields']
    end
  end
end

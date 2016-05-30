require 'net/http'
require 'json'

module ArcREST
  # adds metadata method
  module Base
    def metadata(uri)
      JSON.parse get(uri)
    end

    private

    def get(uri)
      uri.query = URI.encode_www_form(f: 'json')
      Net::HTTP.get uri
    end
  end
end

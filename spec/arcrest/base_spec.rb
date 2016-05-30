describe ArcREST::Base do
  # concrete class to test module
  class Includer
    include ArcREST::Base

    def initialize
    end
  end

  let(:uri) { URI 'http://rmgsc.cr.usgs.gov/arcgis/rest/services' }
  let(:includer) { Includer.new }

  context '#metadata' do
    it 'returns a hash of metadata information' do
      expect(includer.metadata(uri).class).to eq Hash
    end
  end
end

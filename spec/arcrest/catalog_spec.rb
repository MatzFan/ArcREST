v10_21_server_endpoint = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services'

describe ArcREST::Catalog do
  let(:catalog) { ArcREST::Catalog.new(v10_21_server_endpoint) }
  let(:bad_url) { ArcREST::Catalog.new('bad_url') }

  context '#new(url)' do
    context 'with a valid endpoint url address' do
      it 'creates an instance of the class' do
        expect(catalog.class).to eq ArcREST::Catalog
      end
    end

    context 'with an invalid endpoint address' do
      it 'raises ArgumentError "Invalid endpoint address"' do
        expect(-> { bad_url }).to raise_error(ArgumentError, 'Invalid endpoint')
      end
    end
  end

  context '#version' do
    it 'returns the server version number' do
      expect(catalog.version).to eq 10.21
    end
  end

  context '#services' do
    it 'returns a list of services available' do
      expect(catalog.services.class).to eq Array
    end

    it "returns a list of hashes whose keys are: 'name', 'type'" do
      expect(catalog.services.all? { |s| s.keys == %w(name type) }).to be true
    end
  end
end

v10_21_server_endpoint = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services'

describe ArcREST do
  let(:catalog) { ArcREST::Catalog.new(v10_21_server_endpoint) }
  let(:bad_url) { ArcREST::Catalog.new('bad_url') }

  context '#new(endpoint)' do
    context 'with a valid endpoint address' do
      it 'creates an instance of the class' do
        expect(catalog.class).to eq ArcREST::Catalog
      end
    end

    context 'with an invalid endpoint address' do
      it 'raises ArgumentError "Invalid endpoint address"' do
        expect(-> { bad_url }).to raise_error(ArgumentError, 'Invalid url')
      end
    end
  end

  context '#metadata' do
    it 'returns a hash of metadata' do
      expect(catalog.metadata.class).to eq Hash
    end

    context 'whose keys' do
      it 'are ' do
        expect(catalog.metadata.keys).to include('currentVersion', 'services')
      end
    end
  end
end

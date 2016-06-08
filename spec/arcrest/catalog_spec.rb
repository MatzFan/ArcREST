v10_21_catalog_url = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services'

describe ArcREST::Catalog do
  let(:catalog) { ArcREST::Catalog.new(v10_21_catalog_url) }

  context '#new(url)' do
    it 'can be instantiated with a url string' do
      expect(-> { catalog }).not_to raise_error
    end
  end

  context '#folders' do
    it 'returns a list of sub-folder names' do
      expect(catalog.folders).to eq %w(Utilities)
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

endpoint = 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/' #v10.21
feature_service = endpoint + 'geomac_fires/FeatureServer'
map_service = endpoint + 'ecosys_US/MapServer'

describe ArcREST::Service do
  let(:fs) { ArcREST::Service.new(feature_service) }
  let(:ms) { ArcREST::Service.new(map_service) }

  context '#new(url)' do
    context 'with a valid url address' do
      it 'creates an instance of the class' do
        expect(ms.class).to eq ArcREST::Service
      end
    end
  end

  context '#layers' do
    it 'returns a list of layers indexable by ["id"]' do
      expect(ms.layers.all? { |l| l.keys.include? 'id'}).to be true
    end

    it 'returns a list of layers indexable by ["name"]' do
      expect(ms.layers.all? { |l| l.keys.include? 'name'}).to be true
    end
  end

  context '#max_record_count' do
    it 'returns the call-limit on record queries' do
      expect(ms.max_record_count).to eq 1000
    end
  end

  context '#capabilities' do
    it 'returns a list of FeatureService capabilities' do
      expect(fs.capabilities).to eq %w(Query)
    end

    it 'returns a list of MapService capabilities' do
      expect(ms.capabilities).to eq %w(Map Query Data)
    end
  end
end

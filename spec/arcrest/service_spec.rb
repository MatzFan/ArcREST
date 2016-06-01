endpoint = 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/' #v10.21
feature_service = endpoint + 'geomac_fires/FeatureServer'
map_service = endpoint + 'ecosys_US/MapServer'

describe ArcREST::Service do
  let(:fs) { ArcREST::Service.new(feature_service) }
  let(:ms) { ArcREST::Service.new(map_service) }
  let(:layer_names) { ['Ecosystems', 'Bioclimates', 'Land Surface Forms',
                        'Surficial Lithology', 'Topographic Position'] }

  context '#new(url)' do
    context 'with a valid url address' do
      it 'creates an instance of the class' do
        expect(ms.class).to eq ArcREST::Service
      end
    end
  end

  context '#layer_ids' do
    it 'returns a list of layer ids' do
      expect(ms.layer_ids).to eq [0, 1, 2, 3, 4]
    end
  end

   context '#layer_names' do
    it 'returns a list of layer names' do
      expect(ms.layer_names).to eq layer_names
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

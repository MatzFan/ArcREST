endpoint = 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/' #v10.21
feature_service = endpoint + 'geomac_fires/FeatureServer'
map_service = endpoint + 'ecosys_US/MapServer'

v10_0 = 'http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/'
v10_0_url = v10_0 + 'Earthquakes/EarthquakesFromLastSevenDays/FeatureServer'

describe ArcREST::Service do
  let(:fs) { ArcREST::Service.new(feature_service) }
  let(:ms) { ArcREST::Service.new(map_service) }

  let(:v10_0_fs) { ArcREST::Service.new(v10_0_url) }
  let(:layer_names) { ['Ecosystems', 'Bioclimates', 'Land Surface Forms',
                        'Surficial Lithology', 'Topographic Position'] }

  context '#new' do
    it 'can be instantaited with the url argument' do
      expect(-> { ArcREST::Service.new(feature_service) }).not_to raise_error
    end
  end

  context '#layers' do
    it 'returns a list of ArcREST::Layer objects' do
      expect(ms.layers.all? { |l| l.class == ArcREST::Layer }).to eq true
    end
  end

  context '#max_record_count' do
    it 'returns the maxRecordCount (API feature query limit)' do
      expect(ms.max_record_count).to eq 1000
    end

    it 'returns nil if maxRecordCount is not published' do
      expect(v10_0_fs.max_record_count).to be_nil
    end
  end

  context '#capabilities' do
    it 'returns a list of capabilities for a FeatureServer' do
      expect(fs.capabilities).to eq %w(Query)
    end

    it 'returns a list of capabilities for a MapServer' do
      expect(ms.capabilities).to eq %w(Map Query Data)
    end

    it 'returns nil if there are no capabilities' do
      expect(v10_0_fs.capabilities).to be_nil
    end
  end
end

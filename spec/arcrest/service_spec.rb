endpoint = 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/' # v10.31
feature_service = endpoint + 'geomac_fires/FeatureServer'
map_service = endpoint + 'gmeelevation/MapServer'

v_10_0_root = 'http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/'
v_10_0_url = v_10_0_root + 'Earthquakes/EarthquakesFromLastSevenDays/FeatureServer'

describe ArcREST::Service do
  let(:fs) { ArcREST::Service.new(feature_service) }
  let(:ms) { ArcREST::Service.new(map_service) }

  let(:v_10_0_fs) { ArcREST::Service.new(v_10_0_url) }

  context '#new(url)' do
    it 'can be instantiated with a url string' do
      expect(-> { ArcREST::Service.new(feature_service) }).not_to raise_error
    end
  end

  context '#layers' do
    it 'returns a list of layers hashes which include "id" and "name" keys' do
      ms.layers.map(&:keys).each do |keys|
        expect(%w[id name].all? { |k| keys.include? k }).to eq true
      end
    end
  end

  context '#max_record_count' do
    it 'returns the maxRecordCount (API feature query limit)' do
      expect(ms.max_record_count).to eq 1000
    end

    it 'returns nil if maxRecordCount is not published' do
      expect(v_10_0_fs.max_record_count).to be_nil
    end
  end

  context '#capabilities' do
    it 'returns a list of capabilities for a FeatureServer' do
      expect(fs.capabilities).to eq %w[Query]
    end

    it 'returns a list of capabilities for a MapServer' do
      expect(ms.capabilities).to eq %w[Map Query Data]
    end

    it 'returns nil if there are no capabilities' do
      expect(v_10_0_fs.capabilities).to be_nil
    end
  end
end

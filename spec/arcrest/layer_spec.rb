endpoint = 'https://www.geomac.gov/arcgis/rest/services/' # v10.31
feature_layer_url = endpoint + 'geomac_fires/FeatureServer/2'
raster_layer_url = endpoint + 'gmeelevation/MapServer/0'

v_10_0_root = 'http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/'
v_10_0_url = v_10_0_root + 'Earthquakes/EarthquakesFromLastSevenDays/FeatureServer/0'

describe ArcREST::Layer do
  let(:feature_layer) { ArcREST::Layer.new(feature_layer_url) }
  let(:features) { feature_layer.features(resultRecordCount: 2) } # limit 2
  let(:raster_l) { ArcREST::Layer.new(raster_layer_url) }
  let(:v_10_0_feature_layer) { ArcREST::Layer.new(v_10_0_url) }

  context '#new(url)' do
    it 'can be instantiated with a url string' do
      expect(feature_layer.class).to eq described_class
      expect(raster_l.class).to eq described_class
    end
  end

  context 'meta-methods' do
    context '#id' do
      it 'returns the layer id' do
        expect(feature_layer.id).to eq 2
        expect(raster_l.id).to eq 0
      end
    end

    context '#name' do
      it 'returns the layer name' do
        expect(feature_layer.name).to eq 'Fire Perimeters'
        expect(raster_l.name).to eq 'Elevation'
      end
    end

    context '#type' do
      it 'returns "Feature Layer" or "Raster Layer" - as relevant' do
        expect(feature_layer.type).to eq 'Feature Layer'
        expect(raster_l.type).to eq 'Raster Layer'
      end
    end

    context '#drawing_info' do
      it 'returns a Hash including a "Renderer" key' do
        expect(feature_layer.drawing_info.keys).to include 'renderer'
        expect(raster_l.drawing_info).to be_nil
      end
    end

    context '#fields' do
      it 'returns a list of field hash data' do
        expect(feature_layer.fields.all? { |f| f.class == Hash }).to eq true
        expect(raster_l.fields).to be_nil
      end
    end

    context '#max_record_count' do
      it 'returns the limit on number of features returned from a query' do
        expect(feature_layer.max_record_count).to eq 3000
        expect(raster_l.max_record_count).to be_nil
      end
    end
  end

  context 'for a Feature Layer' do ############################################
    context '#object_ids' do
      it 'returns a list of object Ids' do
        expect(feature_layer.object_ids.all? { |i| i.is_a? Integer }).to eq true
      end
    end

    context '#count' do
      context 'for a v10.31 server' do
        it 'returns the (integer) number of features' do
          expect(feature_layer.count.is_a?(Integer)).to eq true
        end
      end

      context 'for a v10.0 server' do
        it 'returns the (integer) number of features' do
          expect(v_10_0_feature_layer.count.is_a?(Integer)).to eq true
        end
      end
    end

    context '#query(options)' do
      it 'raises InvalidOption error with an invalid option key' do
        lambda = -> { feature_layer.query(invalidOption: true) }
        expect(lambda).to raise_error ArcREST::InvalidOption
      end

      it 'raises InvalidOption with an invalid option for the server version' do
        l = -> { v_10_0_feature_layer.query(returnM: true) }
        expect(l).to raise_error ArcREST::InvalidOption
      end

      it 'raises BadQuery with an invalid where: String' do
        l = -> { v_10_0_feature_layer.query(where: 'invalid SQL') }
        expect(l).to raise_error ArcREST::BadQuery
      end

      it 'returns a list of hashes, whose keys include fields & features' do
        keys = %w[fields features]
        opts = { where: '1=1', resultRecordCount: 1 }
        keys.all? { |k| expect(feature_layer.query(opts).keys).to include k }
      end
    end

    context '#features(options)' do
      it 'returns a list of hashes, whose keys are: "geometry", "attributes"' do
        features.map(&:keys).each do |keys|
          expect(keys).to eq %w[geometry attributes]
        end
      end
    end
  end

  context 'for a Raster Layer' do #############################################
    context '#object_ids' do
      it 'raises BadQuery error' do
        expect(-> { raster_l.object_ids }).to raise_error ArcREST::BadQuery
      end
    end

    context '#count' do
      it 'returns nil' do
        expect(-> { raster_l.count }).to raise_error ArcREST::BadQuery
      end
    end

    context '#features(options)' do
      it 'returns nil' do
        expect(-> { raster_l.features }).to raise_error ArcREST::BadQuery
      end
    end
  end
end

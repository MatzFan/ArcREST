endpoint = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services/' # v10.21
feature_layer_url = endpoint + 'geomac_fires/FeatureServer/2'
raster_layer_url = endpoint + 'ecosys_US/MapServer/0'

v10_0 = 'http://sampleserver3.arcgisonline.com/ArcGIS/rest/services/'
v10_0_url = v10_0 + 'Earthquakes/EarthquakesFromLastSevenDays/FeatureServer/0'

describe ArcREST::Layer do
  let(:feature_layer) { ArcREST::Layer.new(feature_layer_url) }
  let(:raster_l) { ArcREST::Layer.new(raster_layer_url) }
  let(:v10_0_feature_layer) { ArcREST::Layer.new(v10_0_url) }

  context '#new(url)' do
    it 'can be instantiated with a url string' do
      expect(-> { feature_layer }).not_to raise_error
    end
  end

  context '#id' do
    it 'returns the layer id' do
      expect(feature_layer.id).to eq 2
      expect(raster_l.id).to eq 0
    end
  end

  context '#name' do
    it 'returns the layer name' do
      expect(feature_layer.name).to eq 'Fire Perimeters'
      expect(raster_l.name).to eq 'Ecosystems'
    end
  end

  context '#type' do
    it 'returns "Feature Layer" or "Raster Layer" - as relevant' do
      expect(feature_layer.type).to eq 'Feature Layer'
      expect(raster_l.type).to eq 'Raster Layer'
    end
  end

  context '#max_record_count' do
    it 'returns the limit on number of features returned from a query' do
      expect(feature_layer.max_record_count).to eq 1000
      expect(raster_l.max_record_count).to be_nil
    end
  end


  context 'for a Feature Layer' do ############################################
    context '#object_ids' do
      it 'returns a list of object Ids' do
        expect(feature_layer.object_ids.all? { |i| i.is_a? Integer }).to eq true
      end
    end

    context '#fields' do
      it 'returns a list of field hash data' do
        expect(feature_layer.fields.all? { |f| f.class == Hash }).to eq true
      end
    end

    context '#drawing_info' do
      it 'returns a Hash including a "Renderer" key' do
        expect(feature_layer.drawing_info.keys).to include 'renderer'
      end
    end

    context '#count' do
      context 'for a v10.21 server' do
        it 'returns the (integer) number of features' do
          expect(feature_layer.count.is_a?(Integer)).to eq true
        end
      end

      context 'for a v10.0 server' do
        it 'returns the (integer) number of features' do
          expect(v10_0_feature_layer.count.is_a?(Integer)).to eq true
        end
      end
    end

    context '#features(options)' do
      it 'raises InvalidOption error with an invalid option key' do
        lambda = -> { feature_layer.features(invalidOption: true) }
        expect(lambda).to raise_error ArcREST::InvalidOption
      end

      it 'raises InvalidOption with an invalid option for the server version' do
        l = -> { v10_0_feature_layer.features(returnM: true) }
        expect(l).to raise_error ArcREST::InvalidOption
      end

      it 'raises InvalidQuery with an invalid where: String' do
        l = -> { v10_0_feature_layer.features(where: 'invalid SQL') }
        expect(l).to raise_error ArcREST::InvalidQuery
      end

      it 'returns a list of hashes, whose keys are: "geometry", "attributes"' do
        feature_layer.features.map(&:keys).each do |keys|
          expect(keys).to eq %w(geometry attributes)
        end
      end
    end
  end

  context 'for a Raster Layer' do #############################################
    context '#object_ids' do
      it 'raises InvalidQuery error' do
        expect(-> { raster_l.object_ids }).to raise_error ArcREST::InvalidQuery
      end
    end

    context '#fields' do
      it 'returns nil' do
        expect(raster_l.fields).to be_nil
      end
    end

    context '#drawing_info' do
      it 'returns nil' do
        expect(raster_l.drawing_info).to be_nil
      end
    end

    context '#count' do
      it 'returns nil' do
        expect(-> { raster_l.count }).to raise_error ArcREST::InvalidQuery
      end
    end

    context '#features(options)' do
      it 'returns nil' do
        expect(-> { raster_l.features }).to raise_error ArcREST::InvalidQuery
      end
    end
  end
end

endpoint = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services/'
feature_layer_url = endpoint + 'geomac_fires/FeatureServer/1'
raster_layer_url = endpoint + 'ecosys_US/MapServer/0'

describe ArcREST::Layer do
  let(:feature_layer) { ArcREST::Layer.new(feature_layer_url) }
  let(:raster_layer) { ArcREST::Layer.new(raster_layer_url) }

  context 'for a Feature Layer' do
    context '#id' do
      it 'returns the layer id' do
        expect(feature_layer.id).to eq 1

      end
    end

    context '#name' do
      it 'returns the layer name' do
        expect(feature_layer.name).to eq 'Large Fire Points'
      end
    end

    context '#type' do
      it 'returns "Feature Layer"' do
        expect(feature_layer.type).to eq 'Feature Layer'
      end
    end

    context '#fields' do
      it 'returns a list of field hash data' do
        expect(feature_layer.fields.all? { |f| f.class == Hash}).to eq true
      end
    end

    context '#drawing_info' do
      it 'returns a Hash including a "Renderer" key' do
        expect(feature_layer.drawing_info.keys).to include 'renderer'
      end
    end

    context '#feature_count' do
      it 'returns the number of features' do
        expect(feature_layer.feature_count).to eq 14
      end
    end

    context '#query(options)' do
      it 'returns a Hash containing a "features" key' do
        expect(feature_layer.query.keys).to include 'features'
      end
    end
  end

  context 'for a Raster Layer' do
    context '#id' do
      it 'returns the layer id' do
        expect(raster_layer.id).to eq 0
      end
    end

    context '#name' do
      it 'returns the layer name' do
        expect(raster_layer.name).to eq 'Ecosystems'
      end
    end

    context '#type' do
      it 'returns "Raster Layer"' do
        expect(raster_layer.type).to eq 'Raster Layer'
      end
    end

    context '#fields' do
      it 'returns a list of field hash data' do
        expect(raster_layer.fields).to be_nil
      end
    end

    context '#drawing_info' do
      it 'returns a Hash including a "Renderer" key' do
        expect(raster_layer.drawing_info).to be_nil
      end
    end

    context '#feature_count' do
      it 'returns the number of features' do
        expect(raster_layer.feature_count).to be_nil
      end
    end

    context '#query(options)' do
      it 'returns a Hash containing a "features" key' do
        expect(raster_layer.query.keys).to eq ['error']
      end
    end
  end
end

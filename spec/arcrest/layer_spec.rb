endpoint = 'http://rmgsc.cr.usgs.gov/ArcGIS/rest/services/'
feature_layer_url = endpoint + 'geomac_fires/FeatureServer/1'
raster_layer_url = endpoint + 'ecosys_US/MapServer/0'

describe ArcREST::Layer do
  let(:feature_layer) { ArcREST::Layer.new(feature_layer_url) }
  let(:raster_layer) { ArcREST::Layer.new(raster_layer_url) }

  context '#new' do
    it 'returns an instance of the class' do
      expect(feature_layer.class).to eq ArcREST::Layer
    end
  end

  context '#type' do
    context 'for a Feature Layer' do
      it 'returns "Feature Layer"' do
        expect(feature_layer.type).to eq 'Feature Layer'
      end
    end

    context 'for a Raster Layer' do
      it 'returns "Raster Layer"' do
        expect(raster_layer.type).to eq 'Raster Layer'
      end
    end
  end

  context '#fields' do
    context 'for a Feature Layer' do
      it 'returns a list of field hash data' do
        expect(feature_layer.fields.all? { |f| f.class == Hash}).to eq true
      end
    end

    context 'for a Raster Layer' do
      it 'returns nil' do
        expect(raster_layer.fields).to be_nil
      end
    end
  end

  context '#drawing_info' do
    context 'for a Feature Layer' do
      it 'returns a Hash including a "Renderer" key' do
        expect(feature_layer.drawing_info.keys).to include 'renderer'
      end
    end

    context 'for a Raster Layer' do
      it 'returns nil' do
        expect(raster_layer.drawing_info).to be_nil
      end
    end
  end
end

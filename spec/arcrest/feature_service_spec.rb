v10_21_feature_service = 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/geomac_fires/FeatureServer'

describe ArcREST::FeatureService do
  let(:f_service) { ArcREST::FeatureService.new(v10_21_feature_service) }

  context '#new(url)' do
    context 'with a valid url address' do
      it 'creates an instance of the class' do
        expect(f_service.class).to eq ArcREST::FeatureService
      end
    end
  end
end

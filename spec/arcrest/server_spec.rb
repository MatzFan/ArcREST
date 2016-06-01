describe ArcREST::Server do

  error = ArcREST::Server::BAD_ENDPOINT
  let(:url) { 'http://rmgsc.cr.usgs.gov/arcgis/rest/services/' }
  let(:bad_server_url) { ArcREST::Catalog.new('bad_url') }
  let(:server) { ArcREST::Server.new url }

  context '#new(url)' do
    context 'with a valid endpoint url address' do
      it 'returns an instance of the class' do
        expect(server.class).to eq ArcREST::Server
      end
    end

    context 'with an invalid endpoint address' do
      it 'raises ArgumentError "Invalid endpoint address"' do
        expect(-> { bad_server_url }).to raise_error(ArgumentError, error)
      end
    end
  end

  context '#json' do
    it 'returns a hash of server data' do
      expect(server.json(URI(url)).class).to eq Hash
    end
  end

  context '#version' do
    it 'returns the server version number' do
      expect(server.version).to eq 10.21
    end
  end
end

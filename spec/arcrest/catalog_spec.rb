require 'arcrest'

describe ArcREST do
  let(:catalog) { ArcREST::Catalog.new }

  context '#new' do
    it 'creates an instance of the class' do
      expect(catalog.class).to eq ArcREST::Catalog
    end
  end
end

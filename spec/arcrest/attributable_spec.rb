describe Attributable do
  # concrete class to test
  class Includer
    include Attributable
    def initialize; end
  end

  context '#create_method(name)' do
    it 'creates an instance method' do
      includer = Includer.new
      includer.create_method('amethod') {}
      expect(Includer.instance_methods(false)).to eq [:amethod]
    end
  end

  context '#create_setter(method_name)' do
    it 'creates a "method_name=" method on the object' do
      includer = Includer.new
      includer.create_setter('att')
      expect(-> { includer.att = 1 }).not_to raise_error
    end
  end

  context '#create_getter(method_name)' do
    it 'creates a "method_name" method on the object' do
      includer = Includer.new
      includer.create_getter('att')
      expect(-> { includer.att }).not_to raise_error
    end
  end

  context '#set_attr(method_name, value)' do
    it 'create an instance variable "@method_name" and assigns value to it' do
      includer = Includer.new
      includer.set_attr(:m, 1)
      expect(includer.m).to eq 1
    end
  end
end

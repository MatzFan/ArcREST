# adds ability to dynamically set instance attrubutes & accessors
module Attributable
  def create_method(name, &block)
    self.class.send(:define_method, name.to_sym, &block)
  end

  def create_setter(m)
    create_method("#{m}=".to_sym) { |v| instance_variable_set("@#{m}", v) }
  end

  def create_getter(m)
    create_method(m.to_sym) { instance_variable_get("@#{m}") }
  end

  def set_attr(method, value)
    create_setter(method)
    send "#{method}=".to_sym, value
    create_getter(method)
  end
end

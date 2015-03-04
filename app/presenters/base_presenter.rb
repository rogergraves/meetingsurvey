class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

  def h
    @template
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end

  def self.presents(name)
    define_method(name) do
      @object
    end
  end
end
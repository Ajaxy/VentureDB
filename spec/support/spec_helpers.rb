# encoding: utf-8

module SpecHelpers
  def fabricate(klass, options = {})
    klass.new(options).tap { |model| model.save!(validate: false) }
  end
end

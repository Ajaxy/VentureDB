# encoding: utf-8

class SeriesDecorator < ApplicationDecorator
  def amount_string
    dollars(model.amount, format: :short)
  end

  def as_json(*args)
    model.as_json(*args).merge(amount_string: amount_string)
  end

  def for_stage(*args)
    SeriesDecorator.decorate model.for_stage(*args)
  end
end

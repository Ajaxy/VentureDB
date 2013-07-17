# encoding: utf-8

class PlansDecorator < ApplicationDecorator
  #delegate_all

  def title
    upcase super
  end

  def support_mins
    res = object.support_mins
    if res > 0
      return (res / 60).to_i.to_s + ' часов/мес.'
    end
    super
  end

  # Почему-то delegate_all не работает
  def method_missing(m)
    res = object.send m
    if res === true || res === false
      return h.image_tag "promo/#{res ? 'pos' : 'neg'}-icon.png"
    elsif res === -1
      return 'Неограниченно'
    end
    res
  end
end

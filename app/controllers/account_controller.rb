#encoding: utf-8

class AccountController < CabinetController
  before_filter :user

  def user
    @user = current_user.decorate
  end

  def edit
  end

  def index

  end

  def plan
    @plans = []

    (1..4).each do |id|
      @plans[id] = PlansDecorator.decorate(Plans.get(id))
    end
  end

  def plan_order
    @plans = []

    (1..4).each do |id|
      @plans[id] = PlansDecorator.decorate(Plans.get(id))
    end
  end

  def plan_order_update
    if @user.person.update_attributes(permitted_params.person)
      redirect_to [:account, :index], notice: 'Ваша заявка сохранена. На вашу почту была отправлена форма договора.'
    else
      render [:account, :plan_order]
    end
  end
end

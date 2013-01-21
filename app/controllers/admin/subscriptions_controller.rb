# encoding: utf-8

class Admin::SubscriptionsController < Admin::BaseController
  def index
    @subscriptions = PaginatingDecorator.decorate(
      paginate(Subscription.present.order{id.desc}))
  end

  def approve
    @subscription = Subscription.find(params[:id])
    @subscription.approve
    @subscription.archive

    redirect_to [:admin, :subscriptions], notice: "Заявка одобрена."
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.archive
    redirect_to [:admin, :subscriptions], notice: "Заявка удалена."
  end
end

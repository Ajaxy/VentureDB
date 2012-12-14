# encoding: utf-8

class Admin::SubscriptionsController < Admin::BaseController
  def index
    @subscriptions = decorate paginate(Subscription.present.order{id.desc})
  end

  def approve
    @subscription = Subscription.find(params[:id])
    @user         = @subscription.create_user

    if @user.save
      UserMailer.created(@user).deliver
      redirect_to [:admin, :subscriptions], notice: "Заявка одобрена."
      @subscription.archive
    else
      render "admin/users/new"
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.archive
    redirect_to [:admin, :subscriptions], notice: "Заявка удалена."
  end
end

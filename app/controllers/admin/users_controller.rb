# encoding: utf-8

class Admin::UsersController < Admin::BaseController
  before_filter :find_user, only: [:show, :edit, :update, :destroy, :approve]
  respond_to :json, only: :approve

  def index
    @users = PaginatingDecorator.decorate paginate(User.order('created_at DESC'))
  end

  def show
    render :edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(permitted_params.user)

    if @user.save
      UserMailer.created(@user).deliver
      redirect_to [:admin, :users], notice: "Пользователь добавлен."
      subscriptions = Subscription.where(email: @user.email)
      subscriptions.each(&:archive)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(permitted_params.user)
      redirect_to [:admin, :users], notice: "Пользователь сохранен."
    else
      render :edit
    end
  end

  def approve
    @user.approved = true
    if @user.save then
      render json: { status: :ok }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # def destroy
  # end

  private

  def find_user
    @user = User.find(params[:id])
  end
end

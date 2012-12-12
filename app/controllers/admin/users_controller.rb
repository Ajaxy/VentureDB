# encoding: utf-8

class Admin::UsersController < Admin::BaseController
  def index
    @users = paginate(User.order(:email))
  end

  def show
    render :edit
  end

  def new
    @user = User.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end

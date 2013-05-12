# encoding: utf-8

class Admin::InvestmentsController < Admin::BaseController
  def create
    @investment = Investment.new_draft(permitted_params.investment)

    if @investment.save
      render :success
    else
      render :error
    end
  end

  def edit
    @investment = Investment.find(params[:id])
  end

  def update
    @investment = Investment.find(params[:id])

    if @investment.update_attributes(permitted_params.investment)
      render :success
    else
      render :error
    end
  end

  def destroy
    @investment = Investment.find(params[:id])
    if @investment.destroy() 
      render :nothing => true, :status => :ok
    end
  end
end

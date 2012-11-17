# encoding: utf-8

class Admin::CompaniesController < Admin::BaseController
  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(permitted_params.company)
      flash.now[:notice] = "Информация о компании обновлена."
      render :edit
    else
      render :edit
    end
  end
end

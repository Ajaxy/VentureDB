# encoding: utf-8

class Admin::BaseController < ApplicationController
  layout "admin"
  before_filter :require_admin!
end

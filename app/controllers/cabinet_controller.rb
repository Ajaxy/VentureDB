# encoding: utf-8

class CabinetController < ApplicationController
  include CabinetMenuIntegration

  before_filter :authenticate_user!
end

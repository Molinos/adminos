class Admin::BaseController < ApplicationController
  include Adminos::Controllers::AdminExtension

  before_action :authenticate_user!
  check_authorization

  layout 'admin/base'

  before_action :define_breadcrumb_struct

  private

  def define_breadcrumb_struct
    Struct.new('Breadcrumb', :label, :url) unless defined?(Struct::Breadcrumb)
  end
end

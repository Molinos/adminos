class ApplicationController < ActionController::Base
  protect_from_forgery

  respond_to :html

  before_action :reload_routes, :set_paper_trail_whodunnit, :set_pages

  @@routes_version = 0
  @@lock = Mutex.new

  protected

  def user_for_paper_trail
    current_user&.email || 'Public user'
  end

  # Not foget enable cache in development
  def self.update_routes
    @@lock.synchronize do
      version = Rails.cache.fetch(:routes_version) { @@routes_version }
      return if @@routes_version == version

      Rails.logger.warn "NEW ROUTES VERSION: #{version}"
      Rails.application.reload_routes!
      @@routes_version = version
    end
  end

  def reload_routes
    ApplicationController.update_routes
  end

  rescue_from CanCan::AccessDenied do |exception|
    path = current_user ? root_path : new_user_session_path
    session[:previous_url] = request.fullpath
    redirect_to path, alert: exception.message
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || super
  end

  def paper_trail_enabled_for_controller
    ApplicationController.descendants.include? Admin::BaseController
  end

  def set_pages
    @pages ||= Page.navigation.sorted
  end
end

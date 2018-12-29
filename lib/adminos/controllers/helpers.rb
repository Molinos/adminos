module Adminos::Controllers::Helpers
  extend ActiveSupport::Concern

  included do
    helper_method :settings, :top_navigation, :current_page, :title_default
  end

  def settings
    @settings ||= Settings.get
  end

  def top_navigation
    @top_navigation ||= Page.navigation_top
  end

  def current_page
    @current_page ||= Page.published.find params[:page_id] if params[:page_id]
  end

  def title_default
    title ||= settings.index_meta_title
    title.present? ? title : current_page.name rescue nil
  end
end

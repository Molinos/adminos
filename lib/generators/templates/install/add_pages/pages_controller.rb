class PagesController < ApplicationController
  def resource
    @resource ||= current_page
  end
  helper_method :resource
end

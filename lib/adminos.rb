require 'path'
require 'rails'
require 'jquery-fileupload-rails'
require 'dotenv-rails'
require 'babosa'
require 'devise'
require 'cancancan'
require 'pg_search'
require 'searchkick'
require 'cocoon'
require 'simple_form'

module Adminos

  autoload :FormBuilder,              'adminos/form_builder'

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  Helpers      = Module.new
  NestedSet    = Module.new
  Controllers  = Module.new
  StatefulLink = Module.new


  Path.require_tree 'adminos', except: %w[generators operations]

  class Engine < ::Rails::Engine
    initializer 'adminos.view_helpers' do
      ActionView::Base.send :include, Helpers::View
      ActionView::Base.send :include, Helpers::Admin
      ActionView::Base.send :include, Helpers::Bootstrap
    end

    initializer 'adminos.controller_helpers' do
      ActionController::Base.send :include, Controllers::Helpers
      ActionController::Base.send :include, Controllers::Resource
    end

    initializer 'adminos.stateful_link' do
      ActionView::Base.send :include, StatefulLink::Helper
      ActionController::Base.send :include, StatefulLink::ActionAnyOf
    end

    initializer 'adminos.assets' do
      Rails.application.config.assets.precompile += %w(apple-touch-icon.png favicon-32x32.png favicon-16x16.png safari-pinned-tab.svg favicon.ico)
    end
  end
end

require 'rails/generators/active_record'

module Adminos::Generators
  class ProfileGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    desc 'Set up admin profile page'
    source_root File.expand_path '../../templates/profile', __FILE__

    def auto
      directory 'auto', '.', mode: :preserve
    end

    def route
      insert_into_file "config/routes.rb", after: "resource  :settings, only: [:edit, :update]\n" do
        <<~ROUT.indent(6)
          resource  :profile, only: [:edit, :update]
        ROUT
      end
    end

    def sidebar_link
      insert_into_file "app/views/shared/admin/_sidebar.slim", before: "\n        = top_menu_item active: 'admin/settings#' do" do
        <<~SLIM.indent(8)

          = top_menu_item active: 'admin/profiles#' do
            = link_to edit_admin_profile_path, class: 'nav__link' do
              span.link.link--settings
                = t('admin.profile.actions.index.header')
        SLIM
      end
    end
  end
end

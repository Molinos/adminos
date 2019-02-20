require 'rails/generators/active_record'

module Adminos::Generators
  class FeedbackGenerator < Rails::Generators::Base
    include ActiveRecord::Generators::Migration

    desc 'Set up feedbacks'
    source_root File.expand_path '../../templates/feedback', __FILE__

    def auto
      directory 'auto', '.', mode: :preserve
    end

    def route
      insert_into_file "config/routes.rb", after: "namespace :admin do\n" do
        <<~ROUT.indent(4)

          resources :feedbacks, except: :show do
            collection { post :batch_action }
          end

        ROUT
      end
    end

    def migration
      migration_template 'feedbacks_migration.rb', 'db/migrate/create_feedbacks.rb'
    end

    def sidebar_link
      insert_into_file "app/views/shared/admin/_sidebar.slim", before: "\n        = top_menu_item active: 'admin/settings#' do" do
        <<~SLIM.indent(8)
          = top_menu_item active: 'admin/feedbacks#' do
            = link_to t('admin.feedbacks.actions.index.header'), admin_feedbacks_path, class: 'nav__link'
        SLIM
      end
    end
  end
end

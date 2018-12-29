require 'rails/generators/active_record'

module Adminos::Generators
  class AdminosGenerator < ActiveRecord::Generators::Base
    desc 'Creates defined model, migration and adds adminos-structured files'

    source_root File.expand_path '../../templates/adminos', __FILE__

    argument :attributes, type: :array, default: []
    hook_for :orm, required: true, as: :model

    class_option :type, type: :string, enum: Dir["#{source_root}/types/*"].map(&File.method(:basename)), default: 'default', desc: 'Model type'
    class_option :locale, type: :boolean
    class_option :search, type: :string
    class_option :seo, type: :boolean, default: true, desc: 'Include SEO fields in generated model'

    def extend_model
      model = "app/models/#{file_name}.rb"
      if File.exist?(model)
        inject_into_file model, file_content('model_includes.rb', true), after: /ApplicationRecord\n/
        inject_into_file model, erb_file_content('model.rb', true), before: /^\Snd\n/
      end
    end

    def extend_migration
      file = Dir.glob('db/migrate/*.rb').grep(/\d+_create_#{table_name}.rb$/).first

      return unless file
      inject_into_file file, file_content('migration.rb', true), after: /create_table.*\n/

      if drag_type?
        inject_into_file file, "\n\n    add_index :#{table_name}, :parent_id\n    add_index :#{table_name}, :rgt", after: /    end/
      end

      unless options.seo?
        gsub_file(file, /^.+(:meta_description|:meta_title)$/, '')
      end
    end

    def extend_routes
      inject_into_file 'config/routes.rb', route_content, after: 'namespace :admin do'
    end

    def extend_navbar
      inject_into_file 'app/views/shared/admin/_sidebar.slim', erb_file_content('sidebar.slim'), after: /.*nav__group-content--other\n/
    end

    def extend_locale
      locale_path = File.exist?('config/locales/adminos.ru.yml') ? 'config/locales/adminos.ru.yml' : 'config/locales/ru.yml'
      inject_into_file locale_path, erb_file_content('adminos.ru.yml'), before: /.*helps:\n/
    end

    def create_controller
      template "types/#{options.type}/controller.rb.erb", "app/controllers/admin/#{table_name}_controller.rb"
    end

    def copy_views
      template 'fields.slim', "app/views/admin/#{table_name}/_fields.slim"
      directory "types/#{options.type}/views", "app/views/admin/#{table_name}"
    end

    def locale_specific_actions
      return unless options.locale? || attributes.map(&:locale).any?

      template 'locales/locale_fields.slim', "app/views/admin/#{table_name}/_locale_fields.slim"
      template 'locales/general_fields.slim', "app/views/admin/#{table_name}/_general_fields.slim" #unless attributes.map(&:locale).delete_if{|e| e == true}.blank?
      remove_file "app/views/admin/#{table_name}/_fields.slim"

      if File.exist?("app/models/#{file_name}.rb")
        inject_into_file "app/models/#{file_name}.rb", erb_file_content('locales/model.rb.erb'), before: /^\Snd\n/
      end
      comment_lines "app/models/#{file_name}.rb", /validates :name/

      if File.exist?("app/controllers/admin/#{table_name}_controller.rb")
        inject_into_file "app/controllers/admin/#{table_name}_controller.rb", "            filter_by_locale: true,\n", before: /.*find_by_slug.*\n/
      end

      migration_template 'locales/migration.rb.erb', "db/migrate/add_translation_table_to_#{file_name}.rb"

      unless options.seo?
        file = Dir.glob('db/migrate/*.rb').grep(/\d+_add_translation_table_to_#{file_name}.rb$/).first
        gsub_file(file, /.+(meta_description|meta_title).+/, '')
      end
    end

    def sort_specific_actions
      return unless attributes.map(&:sort).any? || table_type?
      inject_into_file "app/views/admin/#{table_name}/index.slim", erb_file_content('sorts/headers.slim'), before: /.*\%th\.icon.*\n/
      inject_into_file "app/views/admin/#{table_name}/index.slim", erb_file_content('sorts/body.slim'), before: /.*\%td= object_link_edit\(object\).*\n/
    end

    def search_specific_actions
      return unless options.search?

      inject_into_file "app/models/#{file_name}.rb", "\n  scoped_search on: #{options.search.split(',').map { |s| s.strip.to_sym }}\n", before: /^\Snd\n/
      inject_into_file "app/views/admin/#{table_name}/index.slim", "\n= render 'shared/admin/search_form'\n", after: /= collection_header\n/
      inject_into_file "app/controllers/admin/#{table_name}_controller.rb", '.search_for(params[:query])', after: /.*\|\|\= collection_orig/
    end

    protected

    def file_content(file, type = nil)
      prefix = type ? 'types/' + target_type + '/' : ''
      IO.read find_in_source_paths prefix + file
    end

    def erb_file_content(file, type = nil)
      ERB.new(file_content(file, type), nil, '-').result(instance_eval('binding'))
    end

    def target_type
      table_type? ? 'default' : options.type
    end

    def table_type?
      options.type == 'table'
    end

    def drag_type?
      %w[section sortable].include? options.type
    end

    def route_content
      spaces = (options.locale? || attributes.map(&:locale).any? ? '      ' : '    ')

      if drag_type?
        <<-eos

#{spaces}resources :#{table_name}, except: :show do
#{spaces}  collection { post :batch_action }
#{spaces}  member { put :drop }
#{spaces}  member { post :duplication }
#{spaces}end
eos
      else
        <<-eos

#{spaces}resources :#{table_name}, except: :show do
#{spaces}  collection { post :batch_action }
#{spaces}  member { post :duplication }
#{spaces}end
eos
      end
    end
  end
end

# Extend rails to add locale instance variable to attribute
module Rails::Generators
  module ExtraAttribute
    attr_accessor :locale, :sort

    def initialize(name, type = nil, index_type = false, attr_options = {})
      @locale = true if index_type == 'locale'
      @sort   = true if index_type == 'sort'

      super
    end
  end

  class GeneratedAttribute
    prepend ExtraAttribute
  end
end

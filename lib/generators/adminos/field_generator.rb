require 'rails/generators/active_record'

module Adminos::Generators
  class FieldGenerator < ActiveRecord::Generators::Base
    desc 'Creates defined model, migration and adds adminos-structured files'

    source_root File.expand_path '../../templates/field', __FILE__

    argument :attributes, type: :array, default: []

    def generated_locale_migration
      return unless attributes.any?(&:locale)
      attrs = attributes.select(&:locale).map(&:name).join('_')
      raise "You should add support for globalize: table: #{table_name} and fields: #{attrs}" if !model_tranlated?

      migration_template 'locales/migration.rb.erb', "db/migrate/add_translation_fields_#{attrs}_to_#{file_name}.rb"
    end

    def generated_migration
      return if attributes.all?(&:locale)

      attrs = attributes.reject(&:locale).map(&:name).join('_')
      attrs_with_type = attributes.reject(&:locale).map { |a| "#{a.name}:#{a.type}" }.join(' ')

      system %( rails generate migration add_#{attrs}_to_#{file_name} #{attrs_with_type} )
    end

    def extend_model
      return unless attributes.any?(&:locale)

      attrs = attributes.select(&:locale).map { |a| ":#{a.name}" }.join(', ')

      if model_tranlated?
        inject_into_file "app/models/#{file_name}.rb", attrs, after: /translates /
      else
        inject_into_file "app/models/#{file_name}.rb", erb_file_content('locales/model.rb.erb'), before: /^\Snd\n/
        comment_lines "app/models/#{file_name}.rb", /validates :name/
      end
    end

    def extend_locale_view
      return unless attributes.any?(&:locale)

      attrs = attributes.select(&:locale).map { |a| "  = f.input :#{a.name}\n" }.compact.join

      locale_fields_path = "app/views/admin/#{table_name}/_locale_fields.slim"

      if File.exist?(locale_fields_path)
        append_file "app/views/admin/#{table_name}/_locale_fields.slim", attrs
      else
        template 'locales/locale_fields.slim', "app/views/admin/#{table_name}/_locale_fields.slim"
      end
    end

    def extend_view
      return if attributes.all?(&:locale)

      attrs = attributes.reject(&:locale).map { |a| "  = f.input :#{a.name}\n" }.compact.join
      append_file "app/views/admin/#{table_name}/_fields.slim", attrs
    end

    def extend_locale_file
      locale_path = File.exist?('config/locales/adminos.ru.yml') ? 'config/locales/adminos.ru.yml' : 'config/locales/ru.yml'
      locale = YAML.load(File.read(locale_path))

      attributes.map(&:name).each do |a|
        if locale['ru']['activerecord']['attributes'][table_name.singularize]
          locale['ru']['activerecord']['attributes'][table_name.singularize][a] = a
        else
          locale['ru']['activerecord']['attributes'].merge!("#{table_name.singularize}" => { a => a })
        end
      end

      File.open(locale_path, 'w') { |f| f.write(YAML.dump(locale)) }
    end

    private

    def file_content(file, type = nil)
      prefix = type ? 'types/' + target_type + '/' : ''
      IO.read find_in_source_paths prefix + file
    end

    def erb_file_content(file, type = nil)
      ERB.new(file_content(file, type), nil, '-').result(instance_eval('binding'))
    end

    def model_tranlated?
      table_name.singularize.classify.constantize.translates?
    end
  end
end

# Extend rails to add locale instance variable to attribute
module Rails::Generators
  class GeneratedAttribute
    attr_accessor :locale

    def initialize_with_attributes(name, type = nil, index_type = false, attr_options = {})
      @locale = true if index_type == 'locale'
      initialize_without_attributes name, type, index_type, attr_options
    end
    alias_method_chain :initialize, :attributes
  end
end

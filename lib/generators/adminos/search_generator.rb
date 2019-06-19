
module Adminos::Generators
  class SearchGenerator < Rails::Generators::NamedBase
    desc 'Helps you setup your search.'

    def configure_model
      inject_into_class model_path, model do
        <<~MODEL.indent(2)
          include Adminos::Searchable

          searchable
        MODEL
      end
    end

    def add_partial
      insert_into_file partial_path, after: /collection_header\n/ do
        <<~SLIM
        = render 'shared/admin/search_form'
        SLIM
      end
    end

    private

    def model_path
      "app/models/#{model.underscore}.rb"
    end

    def partial_path
      "app/views/admin/#{model.underscore.pluralize}/index.slim"
    end

    def model
      "#{file_path.tr('/', '_').singularize.classify}"
    end
  end
end

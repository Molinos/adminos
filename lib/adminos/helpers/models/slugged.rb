module Adminos::Slugged
  extend ActiveSupport::Concern

  module ClassMethods
    def slugged(*args)
      options = args.extract_options!
      sluggable_column = args.first || options.delete(:sluggable_column) || :name
      slug_column      = options.delete(:slug_column) || :slug
      validate = options.fetch(:validates, true)

      before_validation do |object|
        if object.send sluggable_column
          object[slug_column] = object.send(sluggable_column).parameterize
        end
      end

      validates(slug_column, presence: true, format: { with: /\A[a-zA-Z0-9-]+\z/ }) if validate
    end
  end
end

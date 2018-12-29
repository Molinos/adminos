module Adminos::Recognizable
  def self.included(base)
    base.extend ClassMethods
    # base.send(:include, InstanceMethods)
  end

  module ClassMethods
    def acts_as_recognizable(*args)
      extend FriendlyId

      options = args.extract_options!
      sluggable_column = args.first || options.delete(:sluggable_column) || :name
      slug_column = options.delete(:slug_column) || :slug

      friendly_id sluggable_column, slug_column: slug_column, use: :slugged
      validates slug_column, uniqueness: true

      define_method :slug_friendly do
        friendly_id
      end

      # friendly_id slugs transliteration <https://github.com/norman/babosa>.
      define_method :normalize_friendly_id do |input|
        input.to_s.to_slug.normalize(transliterations: :russian).normalize.to_s
      end
    end
  end
end

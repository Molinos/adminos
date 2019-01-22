module Adminos
  module Search
    module Elastic
      extend ActiveSupport::Concern

      included do
        searchkick **searchkick_options

        def search_data
          data = respond_to?(:to_hash) ? to_hash : serializable_hash
          data.delete("id")
          data.delete("_id")
          data.delete("_type")
          data.merge!(actiontext_attributes)

          data
        end

        def actiontext_attributes
          reflect_has_one = self.class.reflect_on_all_associations(:has_one)
          rich_text_attributes = reflect_has_one.map(&:name).map { |name| name if name.to_s.include?('rich_text_') }.compact

          rich_text_attributes.inject({}) do |memo, attr|
            memo[attr] = public_send(attr).to_plain_text
            memo
          end
        end
      end

      class_methods do
        def search_by(q = nil, *args)
          options = args.extract_options!
          options.merge!(load: false)

          result_ids = self.search(q, options).results.map(&:id)

          where(id: result_ids)
        end

        def searchkick_options
          {}
        end
      end
    end
  end
end

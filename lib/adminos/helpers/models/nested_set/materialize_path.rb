module Adminos::NestedSet::MaterializePath
  extend ActiveSupport::Concern

  module ClassMethods
    def materialize_path(*args)
      options = args.extract_options!

      prefix           = options.delete(:prefix) || nil
      delimiter        = options.delete(:delimiter) || '/'
      path_column      = options.delete(:path_column) || 'path'
      segment_accessor = options.delete(:segment_accessor) || 'slug'

      validates segment_accessor, presence: true
      validate :path_column_uniqueness

      define_method :path_column_uniqueness do
        twins = self.class.where('id != ?', self.id).
          where(path_column => self.ancestors.map do |ancestor|
                                  ancestor[segment_accessor]
                                end.push(self[segment_accessor]).join(delimiter))

        errors.add(segment_accessor, :taken) if twins.present?
      end

      after_save do |object|
        # Some scope is being added when turning published on/off
        path_segments = object.class.unscoped do
          object.self_and_ancestors.map { |obj| obj.send(segment_accessor) }
        end
        path_segments.unshift prefix if prefix
        ancestors_path = path_segments.join(delimiter)

        updates = {
          object.id => ancestors_path
        }

        object.descendants.each do |descendant|
          descendant.depth += 1 if prefix
          path_segments[descendant.depth] = descendant.send(segment_accessor)
          updates[descendant.id] = path_segments[0..descendant.depth].join(delimiter)
        end

        # No callbacks for descendatns
        updates.each do |id, path|
          self.class.where(id: id).update_all(path_column => path)
        end
      end
    end
  end
end

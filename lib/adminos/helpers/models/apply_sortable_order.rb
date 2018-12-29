module Adminos::ApplySortableOrder
  extend ActiveSupport::Concern

  module ClassMethods
    def apply_sortable_order(id, *args)
      options = args.extract_options!
      self.where(options.merge(id: id)).order(position: :asc).update_all('position = FIND_IN_SET(id, ?)', id.join(','))
    end
  end
end

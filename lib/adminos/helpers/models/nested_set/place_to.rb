module Adminos::NestedSet::PlaceTo
  extend ActiveSupport::Concern

  def place_to(*args)
    options = args.extract_options!
    parent_id = args.first  || options.delete(:parent_id)
    prev_id   = args.second || options.delete(:prev_id)
    opts = { place_first: true }.merge(options)
    if parent_id.present?
      parent = self.class.find(parent_id)
      self.move_to_child_of(parent)
    else
      self.move_to_root
    end

    if prev_id.present?
      prev = self.class.find(prev_id)
      self.move_to_right_of(prev)
    else
      current_first = self.parent.present? ? self.parent.children.first : self.class.order('lft ASC').first
      if opts[:place_first] && ((self.parent.present? && self.parent.children.count > 1) || !self.parent.present?)
        self.move_to_left_of(current_first)
      end
    end
    self.reload
    run_callbacks(:save)
  end

  def move_children_to_parent!
    self.children.each do |child|
      child.place_to(self.parent, nil)
      child.set_published_off if child.respond_to?(:set_published_off)
    end
  end
end

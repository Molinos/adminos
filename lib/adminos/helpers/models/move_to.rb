module Adminos::MoveTo
  def self.included(base)
    base.class_eval do
      sortable
    end
  end

  def move_to(id)
    if id.blank?
      self.move_to_top!
    else
      to_position = self.class.where(id: id).pluck(:position).first
      to_position += 1 if to_position < self.position
      self.insert_at!(to_position)
    end
  end
end

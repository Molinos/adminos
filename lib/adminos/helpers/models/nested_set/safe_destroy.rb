module Adminos::NestedSet::SafeDestroy
  extend ActiveSupport::Concern

  module ClassMethods
    def safe_destroy
      order('depth DESC').each { |page| page.destroy }
    end
  end

  def safe_destroy
    self.move_children_to_root!
    self.destroy
  end

  def safe_destroy(*args)
    options = args.extract_options!

    case options[:children_to]
    when :parent
      self.move_children_to_parent!
    else
      self.move_children_to_root!
    end

    self.destroy unless options[:without_destroy]
  end

  def move_children_to_root!
    self.children.each do |child|
      child.move_to_root
      child.set_published_off if child.respond_to?(:set_published_off)
    end
  end
end

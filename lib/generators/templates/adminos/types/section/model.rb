  MAX_DEPTH = 3

  has_paper_trail
  materialize_path
  acts_as_nested_set
  acts_as_recognizable :recognizable_name
  slugged :recognizable_name
  flag_attrs :published, :nav_published

  after_save :update_descendants_states

  validates :name, :nav_name, presence: true
  validate :depth_validator

  scope :sorted, -> { order('lft ASC') }
  scope :navigation, -> { where(published: true, nav_published: true) }
  scope :navigation_top, -> { navigation.where(depth: 0) }

  def reasonable_name
    if self.respond_to?(:translations)
      name.presence || translations.detect { |t| t.name.present? }.try(:name)
    else
      name
    end
  end

  def recognizable_name
    slug.present? ? slug : reasonable_name
  end

  def breadcrumbs
    ancestors.navigation
  end

  def absolute_path
    "/#{path}"
  end

  def update_descendants_states
    if saved_change_to_published? && !published?
      self.class.unscoped.where(parent_id: id).set_each_published_off
    end
  end

  alias_method :destroy_orig, :destroy
  def destroy
    safe_destroy(children_to: :parent, without_destroy: true)
    destroy_orig
  end

  def depth_validator
    return true unless self.saved_change_to_parent_id?
    # Итоговый уровень вложенности считается так:
    #   Уровeнь вложенносить родителя + максимальный уровень вложености
    #   детей относителньо самого объекта + 1
    parent = self.parent.try(:depth) || 0
    child  = self.descendants.map(&:depth).max
    child  = child ? child - self.depth : 0
    if (parent + child + 1) > (MAX_DEPTH - 1)
      self.errors.add(:parent, :too_much_nesting, count: MAX_DEPTH)
    end
  end

class Page < ApplicationRecord
  include Adminos::NestedSet::MaterializePath
  include Adminos::NestedSet::PlaceTo
  include Adminos::NestedSet::SafeDestroy
  include Adminos::NestedSet::Duplication
  include Adminos::Slugged
  include Adminos::FlagAttrs

  has_rich_text :content

  MAX_DEPTH = 3
  BEHAVIORS = [
                'pages'
              ]

  # has_paper_trail
  materialize_path
  acts_as_nested_set
  slugged :recognizable_name
  flag_attrs :published, :nav_published

  after_save :update_descendants_states
  after_save :increment_routes

  validates :behavior, presence: true
  validates :name, presence: true
  validate :depth_validator

  scope :sorted, -> { order('lft ASC') }
  scope :for_routes, -> { order('behavior ASC, lft DESC') }
  scope :navigation, -> { where(published: true, nav_published: true).where.not(name: '') }
  scope :navigation_top, -> { navigation.where(depth: 0).sorted }
  scope :reverse_sorted, -> { order('lft DESC') }
  scope :with_behavior, -> { proc { |b| where(behavior: b.to_s) } }

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
      self.class.unscoped.where(parent_id: id).set_each_published_off #FIXME: Unscoped workaround. Descendants method always return empty collection
    end
  end

  alias_method :destroy_orig, :destroy
  def destroy
    safe_destroy(children_to: :parent, without_destroy: true)
    destroy_orig
  end

  def default_behavior?
    behavior == self.class.default_behavior
  end

  def editable_behavior?
    [self.class.default_behavior].include? behavior
  end

  def human_behavior_name
    I18n.t "#{self.class.table_name}.behaviors.#{behavior}"
  end

  def default_route(*actions)
    [behavior, { path: absolute_path, only: actions, page_id: id }]
  end

  class << self
    def sitemap
      navigation.where('behavior != ? OR behavior IS NULL', 'sitemaps').arrange
    end

    def default_behavior
      'pages'
    end

    def human_behavior_name(behavior)
      I18n.t "pages.behaviors.#{behavior}"
    end
  end

  private

  def increment_routes
    Rails.cache.write(:routes_version, (Rails.cache.read(:routes_version) || 0) + 1)
  end

  def depth_validator
    return true unless self.saved_change_to_parent_id?
    # Итоговый уровень вложенности считается так:
    #   Уровeнь вложенносить родителя + максимальный уровень вложености
    #   детей относительно самого объекта + 1
    parent = self.parent.try(:depth) || 0
    child  = self.descendants.map(&:depth).max
    child  = child ? child - self.depth : 0
    if (parent + child + 1) > (MAX_DEPTH - 1)
      self.errors.add(:parent, :too_much_nesting, count: MAX_DEPTH)
    end
  end
end

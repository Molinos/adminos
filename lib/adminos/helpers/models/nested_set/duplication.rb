module Adminos::NestedSet::Duplication
  extend ActiveSupport::Concern

  # Метод клонирует объект. Добавляет в slug -сopy, т.к.  он уникален
  # Далее объект сохранятеся в базе. Если объект в корне, то он туда и помещается
  # Иначе объект помещается в нужного родителя
  # Переопредели generated_slug в модели если хочешь свою логику
  def duplication
    cloned = self.dup
    cloned.slug = generated_slug if cloned.respond_to?('slug=')
    cloned.published = false if cloned.respond_to?('published=')
    cloned.translations = self.translations.map(&:dup) if cloned.respond_to?('translations')

    cloned.save
    self.parent.children << cloned unless self.root?
  end

  private

  def generated_slug
    prefix =
      if self.respond_to?(:translations)
        self.class.with_translated_attribute(:name, reasonable_name, I18n.available_locales).size
      else
        self.class.where(name: reasonable_name).size
      end

    base_slug = self.class.find_by(slug: reasonable_name.parameterize).try(:slug)
    base_slug.present? ? base_slug + prefix.to_s : reasonable_name.parameterize
  end
end

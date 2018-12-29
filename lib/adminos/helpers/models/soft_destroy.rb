module Adminos::SoftDestroy
  extend ActiveSupport::Concern

  module ClassMethods
    def with_soft_destroy(*args)
      options = args.extract_options!
      namespace = options.delete(:states_namespace) || :in_admin
      publish_guard      = options.delete(:publish_guard)      || -> { true }
      unpublish_guard    = options.delete(:unpublish_guard)    || -> { true }
      soft_destroy_guard = options.delete(:soft_destroy_guard) || -> { true }

      attr_accessible :published
      attr_accessor   :published

      before_save do |object|
        if object.published?
          object.send("unpublish_#{namespace}") if object.published == false
        else
          object.send("publish_#{namespace}")   if object.published == true
        end
      end

      state_machine("#{namespace}_state", initial: :unpublished,
                     namespace: namespace) do
        after_transition do |user, transition|
          fail(ActiveRecord::RecordInvalid, user) unless user.valid?
          user.update_attribute("#{namespace}_state_transition_at", Time.zone.now)
        end

        event :publish do
          transition all - [:deleted, :published] => :published, :if => publish_guard
        end

        event :unpublish do
          transition all - [:deleted, :unpublished] => :unpublished, :if => unpublish_guard
        end

        event :soft_destroy do
          transition all - :deleted => :deleted, :if => soft_destroy_guard
        end
      end

      scope :active,      -> { where("#{namespace}_state != 'deleted'") }
      scope :published,   -> { where("#{namespace}_state" => 'published') }
      scope :unpublished, -> { where("#{namespace}_state" => 'unpublished') }
      scope :deleted,     -> { where("#{namespace}_state" => 'deleted') }

      define_method :published? do
        self.send("#{namespace}_published?")
      end

      define_method :active? do
        !self.send("#{namespace}_deleted?")
      end

      define_singleton_method :soft_destroy_each! do
        each { |object| object.send("soft_destroy_#{namespace}!") }
      end
    end
  end
end

module Adminos::FlagAttrs
  extend ActiveSupport::Concern

  module ClassMethods
    def flag_attrs(*args)
      options = args.extract_options!

      on = args.delete(:on) || true
      off = args.delete(:off) || false

      args.each do |name|
        define_method :"set_#{name}_on" do
          update_attribute(name, on)
        end

        define_method :"set_#{name}_off" do
          update_attribute(name, off)
        end

        (class << self; self; end).class_eval do
          define_method :"set_#{name}_on" do
            update_all(name => on)
          end

          define_method :"set_each_#{name}_on" do
            all.each { |object| object.update_attribute(name, on) }
          end

          define_method :"set_#{name}_off" do
            update_all(name => off)
          end

          define_method :"set_each_#{name}_off" do
            all.each { |object| object.update_attribute(name, off) }
          end
        end

        scope :"#{name}", -> { where(name => true) }
        scope :"not_#{name}", -> { where(name => false) }
      end
    end
  end
end

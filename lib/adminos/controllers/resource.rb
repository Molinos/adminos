module Adminos::Controllers::Resource
  extend ActiveSupport::Concern

  module ClassMethods
    protected

      def resource(klass, *args)
        options = args.extract_options!
        finder           = options.delete(:finder)           || :find_by_id!
        location         = options.delete(:location)         || proc { nil }
        collection_scope = options.delete(:collection_scope) || :all
        resource_scope   = options.delete(:resource_scope)   || :all
        filter_by_locale = options.delete(:filter_by_locale) || false
        parent_resource_klass = options.delete(:parent_resource)
        resource_instance        = options.delete(:resource_instance)
        parent_resource_instance = options.delete(:parent_resource_instance)
        with_parent_resource = parent_resource_klass.present? || parent_resource_instance.present?
        namespace = options.delete(:namespace)
        with_move_to = options.delete(:with_move_to)
        with_apply_sortable_order = options.delete(:with_apply_sortable_order)

        helper_method :resource, :collection, :resource_class, :resource_params
        helper_method(:parent_resource) if with_parent_resource

        define_method :create do
          if resource.save
            respond_with(resource, location: self.instance_eval(&location))
          else
            render :new
          end
        end

        define_method :update do
          resource.update_attributes(parameters)
          respond_with(resource, location: self.instance_eval(&location))
        end

        protected

        define_method(:resource_class) { klass }

        define_method(:resource_params) { klass.name.pathalize }

        if with_parent_resource
          define_method :resource_as_association do
            self.resource_params.pluralize
          end

          define_method :parent_resource_params do
            parent_resource_klass.name.pathalize
          end
        end

        define_method :resource do
          return @resource if @resource.present?
          return(@resource = get_instance(resource_instance)) if resource_instance.present?

          @resource =
            if %w(new create).include?(action_name)
              self.build_resource
            else
              self.find_resource
            end
        end

        if with_parent_resource
          define_method :parent_resource do
            return @parent_resource if @parent_resource.present?
            return(@parent_resource = get_instance(parent_resource_instance)) if parent_resource_instance.present?

            @parent_resource = parent_resource_klass.
              find(params["#{parent_resource_params}_id"])
          end
        end

        define_method :collection do
          return @collection if @collection.present?

          collection =
            if with_parent_resource
              parent_resource.send(self.resource_as_association)
            elsif filter_by_locale
              resource_class.with_translations(I18n.locale)
            else
              resource_class
            end

          @collection =
            if collection_scope.is_a?(Array)
              collection_scope.inject(collection) do |collection, method|
                collection.send(method)
              end
            else
              collection.send(collection_scope)
            end
        end

        define_method :build_resource do
          self.resource_class_scope.new(parameters)
        end

        define_method :parameters do
          if action_name == ('create') || action_name == ('update')
            strong_params
          else
            params[resource_params]
          end
        end

        define_method :strong_params do

          ids_attributes = resource_class.reflections.values.select do |ref|
            [
              ActiveRecord::Reflection::HasManyReflection,
              ActiveRecord::Reflection::HasAndBelongsToManyReflection
            ].include? ref.class
          end.map(&:plural_name).map(&:singularize).map { |val| { "#{val}_ids".to_sym => [] } }

          reflect_has_one = resource_class.reflect_on_all_associations(:has_one)
          rich_text_attributes = reflect_has_one.map(&:name).map { |name| name.to_s.gsub('rich_text_', '') }.compact

          _attribute_names = self.resource_class_scope.attribute_names + ids_attributes + rich_text_attributes

          if params[resource_params][:translations_attributes]
            _translated_attributes = resource_class.translated_attribute_names
            attrs = _attribute_names + _translated_attributes
            attrs.push(translations_attributes: _translated_attributes + [:id, :locale]) unless _translated_attributes.blank?

            result = params.require(resource_params).permit(attrs)
          else
            result = params.require(resource_params).permit(*_attribute_names)
          end

          result
        end

        define_method :find_resource do
          if resource_scope.is_a?(Array)
            resource_scope.inject(resource_class_scope) do |resource_class_scope, method|
              resource_class_scope.send(method)
            end
          else
            resource_class_scope.send(resource_scope)
          end.send(finder, params[:id])
        end

        define_method :resource_class_scope do
          return parent_resource.send(self.resource_as_association) if with_parent_resource
          resource_class
        end

        define_method(:get_instance) { |instance| self.instance_eval(&instance) }

        if with_move_to || with_apply_sortable_order
          define_method :sort do
            if with_move_to
              resource.move_to(params[:to])
            elsif with_apply_sortable_order
              resource_class.apply_sortable_order(params[:id])
            end

            respond_to do |format|
              format.js { head :ok }
            end
          end
        end
      end
  end
end

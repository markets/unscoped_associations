module UnscopedAssociations

  def self.included(base)
    base.extend ClassMethods
    (class << base; self; end).instance_eval do
      alias_method_chain :belongs_to, :unscoped
      alias_method_chain :has_many, :unscoped
      alias_method_chain :has_one, :unscoped
    end
  end

  module ClassMethods

    def belongs_to_with_unscoped(name, options = {})
      if unscoped_attribute = options.delete(:unscoped)
        add_unscoped_belongs_to(name, options)
      end
      belongs_to_without_unscoped(name, options)
    end

    def has_many_with_unscoped(name, options = {})
      if unscoped_attribute = options.delete(:unscoped)
        add_unscoped_has_many(name, options)
      end
      has_many_without_unscoped(name, options)
    end

    def has_one_with_unscoped(name, options = {})
      if unscoped_attribute = options.delete(:unscoped)
        add_unscoped_has_one(name, options)
      end
      has_one_without_unscoped(name, options)
    end

    private

    def add_unscoped_belongs_to(association_name, options)
      define_singular_association(association_name, options)
    end

    def add_unscoped_has_many(association_name, options)
      define_collection_association(association_name, options)      
    end

    def add_unscoped_has_one(association_name, options)
      define_singular_association(association_name, options)
    end

    def define_singular_association(association_name, options)
      define_method(association_name) do
        klass_name = options[:class_name] || association_name.to_s.camelize
        instance = "@unscoped_#{association_name}"
        instance_variable_get(instance) ||
          instance_variable_set(instance, klass_name.constantize.unscoped { super(association_name) })
      end
    end

    def define_collection_association(association_name, options)
      define_method(association_name) do
        klass_name = options[:class_name] || association_name.to_s.camelize.singularize
        instances = "@unscoped_#{association_name}"
        instance_variable_get(instances) ||
          instance_variable_set(instances, klass_name.constantize.unscoped { super(association_name) })
      end
    end

  end
end

ActiveRecord::Base.instance_eval { include UnscopedAssociations }
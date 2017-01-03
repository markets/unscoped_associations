require 'unscoped_associations/version'

module UnscopedAssociations
  def self.included(base)
    base.extend ClassMethods
    class << base
      alias_method_chain :belongs_to, :unscoped
      alias_method_chain :has_many, :unscoped
      alias_method_chain :has_one, :unscoped
    end
  end

  module ClassMethods
    def belongs_to_with_unscoped(name, scope = nil, options = {})
      build_unscoped(:belongs_to, name, scope, options)
    end

    def has_many_with_unscoped(name, scope = nil, options = {}, &extension)
      build_unscoped(:has_many, name, scope, options, &extension)
    end

    def has_one_with_unscoped(name, scope = nil, options = {})
      build_unscoped(:has_one, name, scope, options)
    end

    private

    def build_unscoped(assoc_type, assoc_name, scope = nil, options = {}, &extension)
      if scope.is_a?(Hash)
        options = scope
        scope   = nil
      end

      if options.delete(:unscoped)
        add_unscoped_association(assoc_name)
      end

      if scope
        send("#{assoc_type}_without_unscoped", assoc_name, scope, options, &extension)
      else
        send("#{assoc_type}_without_unscoped", assoc_name, options, &extension)
      end
    end

    def add_unscoped_association(association_name)
      define_method(association_name) do
        association(association_name).klass.unscoped do
          super(association_name)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, UnscopedAssociations)

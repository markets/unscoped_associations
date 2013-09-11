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

    def belongs_to_with_unscoped(name, scope = nil, options = {})
      build_unscoped(:belongs_to, name, scope, options)
    end

    def has_many_with_unscoped(name, scope = nil, options = {})
      build_unscoped(:has_many, name, scope, options)
    end

    def has_one_with_unscoped(name, scope = nil, options = {})
      build_unscoped(:has_one, name, scope, options)
    end

    private

    def build_unscoped(assoc_type, assoc_name, scope = nil, options = {})
      if scope.is_a?(Hash)
        options = scope
        scope   = nil
      end

      if options.delete(:unscoped)
        add_unscoped_association(assoc_name)
      end

      if scope
        self.send("#{assoc_type}_without_unscoped", assoc_name, scope, options)
      else
        self.send("#{assoc_type}_without_unscoped", assoc_name, options)
      end
    end

    def add_unscoped_association(association_name)
      define_method(association_name) do
        self.class.reflect_on_association(association_name).klass.unscoped do
          super(association_name)
        end
      end
    end
  end
end

ActiveRecord::Base.instance_eval { include UnscopedAssociations }
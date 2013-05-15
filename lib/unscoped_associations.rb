module UnscopedAssociations

  def self.included(base)
    base.extend ClassMethods
    (class << base; self; end).instance_eval do
      alias_method_chain :belongs_to, :unscoped
      alias_method_chain :has_many, :unscoped
    end
  end

  module ClassMethods

    def belongs_to_with_unscoped(name, options = {})
      if unscoped_attribute = options.delete(:unscoped)
        add_unscoped_belongs_to(name)
      end
      belongs_to_without_unscoped(name, options)
    end

    def has_many_with_unscoped(name, options = {})
      if unscoped_attribute = options.delete(:unscoped)
        add_unscoped_has_many(name)
      end
      has_many_without_unscoped(name, options)
    end

    private

    def add_unscoped_belongs_to(association_name)
      define_method(association_name) do
        @association_name ||= association_name.to_s.camelize.constantize.unscoped { super(association_name) } 
      end
    end

    def add_unscoped_has_many(association_name)
      define_method(association_name) do
        association_name.to_s.camelize.singularize.constantize.unscoped { super(association_name) } 
      end
    end

  end
end

ActiveRecord::Base.instance_eval { include UnscopedAssociations }
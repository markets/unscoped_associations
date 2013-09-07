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
      if options.delete(:unscoped)
        add_unscoped_association(name)
      end
      belongs_to_without_unscoped(name, options)
    end

    def has_many_with_unscoped(name, options = {})
      if options.delete(:unscoped)
        add_unscoped_association(name)
      end
      has_many_without_unscoped(name, options)
    end

    def has_one_with_unscoped(name, options = {})
      if options.delete(:unscoped)
        add_unscoped_association(name)
      end
      has_one_without_unscoped(name, options)
    end

    private

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
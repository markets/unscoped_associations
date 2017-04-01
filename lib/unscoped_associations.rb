require 'unscoped_associations/version'

module UnscopedAssociations
  def self.included(base)
    class << base
        prepend ClassMethods    
    end
  end

  module ClassMethods
    def belongs_to(name, scope = nil, options = {})
      build_unscoped(Proc.new {|*args| super(*args) }, name, scope, options)
    end

    def has_many(name, scope = nil, options = {}, &extension)
      build_unscoped(Proc.new {|*args| super(*args) }, name, scope, options, &extension)
    end

    def has_one(name, scope = nil, options = {})
      build_unscoped(Proc.new {|*args| super(*args) }, name, scope, options)
    end

    private

    def build_unscoped(assoc_super, assoc_name, scope = nil, options = {}, &extension)
      if scope.is_a?(Hash)
        options = scope
        scope   = nil
      end

      if options.delete(:unscoped)
        add_unscoped_association(assoc_name)
      end

      if scope
        assoc_super.call(assoc_name, scope, options, &extension)
      else
        assoc_super.call(assoc_name, options, &extension)
      end
    end

    def add_unscoped_association(association_name)
      define_method(association_name) do |*args|
        force_reload = args[0]
        if !force_reload && instance_variable_get("@_cache_#{association_name}")
          instance_variable_get("@_cache_#{association_name}")
        else
          instance_variable_set("@_cache_#{association_name}",
            association(association_name).klass.unscoped { super(true) }
          )
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, UnscopedAssociations)

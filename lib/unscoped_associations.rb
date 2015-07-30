require 'unscoped_associations/version'

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

      unscoped_option = options.delete(:unscoped)

      if unscoped_option.present?
        add_unscoped_association(assoc_name, unscoped_option)
      end

      if scope
        self.send("#{assoc_type}_without_unscoped", assoc_name, scope, options, &extension)
      else
        self.send("#{assoc_type}_without_unscoped", assoc_name, options, &extension)
      end
    end

    def unscoped_option_to_class_name(option)
      case option
        when String
          option.camelize
        when Symbol
          option.to_s.camelize
        when Class
          option.name
      end
    end

    def add_unscoped_association(association_name, unscoped_option)
      if [Class, Symbol, String].include? unscoped_option.class
        src = <<-END_SRC
          def #{association_name}
            #{unscoped_option_to_class_name unscoped_option}.unscoped do
              super
            end
          end
        END_SRC
        class_eval src, __FILE__, __LINE__
      elsif unscoped_option.is_a? Array
        src = <<-END_SRC
          def #{association_name}
            #{unscoped_option.inject('super') do |result, option|
              "#{unscoped_option_to_class_name option}.unscoped { #{result} }"
            end}
          end
        END_SRC
        class_eval src, __FILE__, __LINE__
      else
        define_method(association_name) do
          if self.class.reflect_on_association(association_name).options.key?(:polymorphic)
            self.association(association_name).klass.unscoped do
              super(association_name)
            end
          else
            self.class.reflect_on_association(association_name).klass.unscoped do
              super(association_name)
            end
          end
        end
      end
    end
  end
end

ActiveRecord::Base.instance_eval { include UnscopedAssociations }

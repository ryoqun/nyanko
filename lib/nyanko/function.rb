module Nyanko
  class Function
    attr_reader :block, :unit, :label

    class << self
      def units
        @units ||= []
      end

      def current_unit
        units.last
      end
    end

    def initialize(unit, label, &block)
      @unit  = unit
      @label = label
      @block = block
    end

    def invoke(context, options = {})
      with_unit_stack(context) do
        with_unit_view_path(context) do
          context.instance_eval(&block)
        end
      end
    end

    def css_classes
      if Config.compatible_css_class
        %W[
          extension
          ext_#{unit.name.underscore}
          ext_#{unit.name.underscore}-#{label}
        ]
      else
        %W[
          unit
          unit__#{unit.name.underscore}
          unit__#{unit.name.underscore}__#{label}
        ]
      end
    end

    private

    def with_unit_stack(context)
      context.units << @unit
      self.class.units << @unit
      yield
    ensure
      self.class.units.pop
      context.units.pop
    end

    def with_unit_view_path(context)
      if context.view?
        context.view_paths.unshift unit.view_path
      end
      yield
    ensure
      context.view_paths.paths.unshift if context.view?
    end
  end
end

module Nyanko
  module Controller
    extend ActiveSupport::Concern

    module ClassMethods
      private

      def unit_action(unit_name, *function_names, &block)
        options = function_names.extract_options!
        block ||= Proc.new { head 400 }
        Array.wrap(function_names).each do |function_name|
          define_method(function_name) do
            invoke(unit_name, function_name, options, &block)
          end
        end
      end
      alias_method :ext_action, :unit_action
    end
  end
end

require "nyanko/unit/scope_finder"

module Nyanko
  module Unit
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :current_scope

      def scope(identifier)
        self.current_scope = ScopeFinder.find(identifier)
        scopes[current_scope] ||= {}
        yield
      ensure
        self.current_scope = nil
      end

      def function(label, &block)
        scopes[current_scope][label] = block
      end

      def shared(label, &block)
        shared_methods[label] = block
      end

      def helpers(&block)
        Helper.define(name, &block)
      end

      def functions
        scopes[current_scope]
      end

      def scopes
        @scopes ||= {}
      end

      def shared_methods
        @shared_methods ||= {}
      end
    end
  end
end

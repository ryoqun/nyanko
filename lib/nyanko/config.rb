module Nyanko
  module Config
    class << self
      attr_accessor(
        :eager_load,
        :backtrace_limit,
        :compatible_css_class,
        :enable_logger,
        :proxy_method_name,
        :raise_error,
        :units_directory_path
      )

      def reset
        self.backtrace_limit      = 10
        self.compatible_css_class = false
        self.eager_load           = Rails.env.production?
        self.enable_logger        = true
        self.proxy_method_name    = :unit
        self.raise_error          = Rails.env.development?
        self.units_directory_path = "app/units"
      end
    end

    reset
  end
end

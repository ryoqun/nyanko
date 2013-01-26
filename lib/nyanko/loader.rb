require "pathname"

module Nyanko
  class Loader
    class << self
      def load(unit_name)
        new(unit_name).load
      end

      def cache
        @cache ||= {}
      end
    end

    def initialize(name)
      @name = name
    end

    def load
      load_from_cache || load_from_file
    end

    def load_from_cache
      cache[@name]
    end

    def load_from_file
      require_unit_files
      cache[@name] = constantize
    end

    def require_unit_files
      paths.each {|path| require path }
    end

    def paths
      Pathname.glob("#{directory_path}/#@name/#@name.rb").sort
    end

    def directory_path
      Config.units_directory_path
    end

    def constantize
      @name.to_s.camelize.constantize
    rescue NameError
    end

    def cache
      self.class.cache
    end
  end
end

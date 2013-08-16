require "language_pack/shell_helpers"

module LanguagePack
  class RubyVersion
    include LanguagePack::ShellHelpers

    DOT_RV_FILE     = ".ruby-version"
    DEFAULT_VERSION = "ruby-2.0.0"
    LEGACY_VERSION  = "ruby-1.9.2"

    attr_reader :set, :version_without_patchlevel, :engine

    def initialize(bundler_path, app = {})
      @set          = nil
      @bundler_path = bundler_path
      @app          = app
      version

      @version_without_patchlevel = @version.sub(/-p[\d]+/, '')
      @engine                     = engine
    end

    def gemfile
      old_system_path = "/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
      run_stdout("env PATH=#{@bundler_path}/bin:#{old_system_path} GEM_PATH=#{@bundler_path} bundle platform --ruby").chomp
    end

    def env_var
      ENV['RUBY_VERSION']
    end

    def ruby_version_file
      rv = File.read(DOT_RV_FILE).chomp
      if rv.match(/^\d/)
        "ruby-#{rv}"
      else
        rv
      end
    end

    def none
      if @app[:new]
        DEFAULT_VERSION
      elsif @app[:last_version]
        @app[:last_version]
      else
        LEGACY_VERSION
      end
    end

    def version
      return @version if @version

      if File.exists?(DOT_RV_FILE)
        @set     = :ruby_version
        @version = ruby_version_file
      else
        bundler_output = gemfile
        if bundler_output == "No ruby version specified" && env_var
          # for backwards compatibility.
          # this will go away in the future
          @set     = :env_var
          @version = env_var
        elsif bundler_output == "No ruby version specified"
          @set     = false
          @version = none
        else
          @set     = :gemfile
          @version = bundler_output.sub('(', '').sub(')', '').split.join('-')
        end
      end
    end

    def engine
      return @engine unless @engine
      if version.match(/-jruby-/)
        :jruby
      elsif version.match(/-rbx-/)
        :rbx
      else
        :ruby
      end
    end

    # determine if we're using jruby
    # @return [Boolean] true if we are and false if we aren't
    def jruby?
      engine == :jruby
    end

    # determine if we're using rbx
    # @return [Boolean] true if we are and false if we aren't
    def rbx?
      engine == :rbx
    end
  end
end

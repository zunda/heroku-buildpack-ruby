module LanguagePack
  module BundlerLockfile

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # checks if the Gemfile and Gemfile.lock exist
      def gemfile_lock?
        File.exist?('Gemfile') && File.exist?('Gemfile.lock')
      end

      def bundle
        @bundle ||= parse_bundle
      end

      def bundler_path
        @bundler_path ||= File.join(VENDOR_PATH, "gems/bundler")
      end

      def parse_bundle
        instrument 'parse_bundle' do
          $: << "#{bundler_path}/lib"
          require "bundler"
          Bundler::LockfileParser.new(File.read("Gemfile.lock"))
        end
      end
    end

    def bundle
      self.class.bundle
    end

    def bundler_path
      self.class.bundler_path
    end
  end
end

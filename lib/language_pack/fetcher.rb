require "yaml"
require "language_pack/shell_helpers"

module LanguagePack
  class Fetcher
    include ShellHelpers

    def initialize(host_url)
      @config   = load_config
      @host_url = fetch_cdn(host_url)
    end

    def fetch(path)
      run("curl --fail --retry 3 --retry-delay 1 --connect-timeout 3 --max-time 20 --silent -O #{@host_url}/#{path}")
    end

    def fetch_untar(path)
      run("set -o pipefail; curl --fail --retry 3 --retry-delay 1 --connect-timeout 3 --max-time 20 --silent #{@host_url}/#{path} -s -o - | tar zxf -")
    end

    private
    def load_config
      YAML.load_file(File.expand_path("../../../config/cdn.yml", __FILE__))
    end

    def fetch_cdn(url)
      cdn = @config[url]
      cdn.nil? ? url : cdn
    end
  end
end

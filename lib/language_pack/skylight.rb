def skylight
  ENV['SK_ENABLE_TRACE_LOGS'] = 'true'
  vendor_folder = File.expand_path("../../../vendor/skylight/gems/", __FILE__)
  Dir["#{vendor_folder}/*"].each {|dir| $:.unshift "#{dir}/lib" }
  require 'skylight'

  config = Skylight::Config.load(File.expand_path("../../../config/skylight.yml", __FILE__))
  Skylight::Instrumenter.start!(config)
  yield
  Skylight::Instrumenter.stop!
end

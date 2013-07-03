require 'benchmark'
require 'language_pack/shell_helpers'

module Skylight
  def self.bench_msg(message, level = 0)
    Kernel.puts "#{'==' * level}> #{message}"
    $stdout.flush
  end

  def self.instrument(cat, title = "", *args)
    ret = nil
    time = Benchmark.realtime do
      yield_with_block_depth do
        ret = yield
      end
    end
    bench_msg("#{cat} : #{time}", block_depth)

    return ret
  end

  def self.trace(name, *args)
    ret         = nil
    block_depth = 0

    time = Benchmark.realtime do
      yield_with_block_depth do
        ret = yield
      end
    end
    bench_msg "#{name} : #{time}", block_depth

    return ret
  end

  def self.yield_with_block_depth
    self.block_depth += 1
    yield
  ensure
    self.block_depth -= 1
  end

  def self.block_depth
    Thread.current[:block_depth] || 0
  end

  def self.block_depth=(value)
    Thread.current[:block_depth] = value
  end
end

def skylight
#  vendor_folder = File.expand_path("../../../vendor/skylight/gems/", __FILE__)
#  Dir["#{vendor_folder}/*"].each {|dir| $:.unshift "#{dir}/lib" }
#  require 'skylight'

#  config = Skylight::Config.load(File.expand_path("../../../config/skylight.yml", __FILE__))
#  Skylight::Instrumenter.start!(config)
  yield
#  Skylight::Instrumenter.stop!
end

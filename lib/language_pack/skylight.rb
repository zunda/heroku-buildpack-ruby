require 'benchmark'
require 'language_pack/shell_helpers'

module Skylight
  def self.bench_msg(message, level = 0, start_time, end_time, duration, request_id)
    Kernel.puts "#{'==' * level}> name=#{message}, start=#{start_time}, end=#{start_time}, duration=#{duration}, level=#{level}, request_id=#{request_id}"
    $stdout.flush
  end

  def self.instrument(cat, title = "", *args)
    ret        = nil
    start_time = Time.now.to_f
    duration = Benchmark.realtime do
      yield_with_block_depth do
        ret = yield
      end
    end
    end_time   = Time.now.to_f
    bench_msg(cat, block_depth, start_time, end_time, duration, request_id)

    ret
  end

  def self.trace(name, *args, &blk)
    ret         = nil
    block_depth = 0

    instrument(name) { blk.call }
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

  def self.request_id
    ENV['REQUEST_ID']
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

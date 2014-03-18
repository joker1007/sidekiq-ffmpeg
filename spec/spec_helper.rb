$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sidekiq/ffmpeg'

require 'tapp'

$spec_dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |config|
  config.order = :random

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end

  # config.before(:suite) do
    # puts "Starting redis for testing at localhost:9736..."
    # `redis-server #{$spec_dir}/redis-test.conf`
    # Sidekiq.configure_server do |sidekiq_config|
      # sidekiq_config.redis = { url: "redis://localhost:9736", namespace: "sidekiq-ffmpeg" }
    # end
    # Sidekiq.configure_client do |sidekiq_config|
      # sidekiq_config.redis = { url: "redis://localhost:9736", namespace: "sidekiq-ffmpeg" }
    # end
  # end

  # config.after(:suite) do
    # processes = `ps -A -o pid,command | grep [r]edis-test`.split($/)
    # pids = processes.map { |process| process.split(" ")[0] }
    # puts "Killing test redis server..."
    # pids.each { |pid| Process.kill("TERM", pid.to_i) }
    # system("rm -f #{$dir}/dump.rdb #{$dir}/dump-cluster.rdb")
  # end
end

def sample_dir
  File.expand_path("../samples", __FILE__)
end

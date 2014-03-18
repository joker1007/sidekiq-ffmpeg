$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sidekiq/ffmpeg'

require 'tapp'

$spec_dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |config|
  config.order = :random

  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end

def sample_dir
  File.expand_path("../samples", __FILE__)
end

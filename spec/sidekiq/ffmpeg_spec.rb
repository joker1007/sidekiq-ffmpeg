require 'spec_helper'

describe Sidekiq::Ffmpeg do
  it 'should have a version number' do
    expect(Sidekiq::Ffmpeg::VERSION).not_to be nil
  end

  it 'should do something useful' do
    expect(false).to eq(true)
  end
end

# Sidekiq::Ffmpeg
[![Gem Version](https://badge.fury.io/rb/sidekiq-ffmpeg.svg)](http://badge.fury.io/rb/sidekiq-ffmpeg)
[![Build Status](https://travis-ci.org/joker1007/sidekiq-ffmpeg.svg?branch=master)](https://travis-ci.org/joker1007/sidekiq-ffmpeg)
[![Coverage Status](https://coveralls.io/repos/joker1007/sidekiq-ffmpeg/badge.png)](https://coveralls.io/r/joker1007/sidekiq-ffmpeg)

Sidekiq job definition for ffmpeg.

## Installation

Add this line to your application's Gemfile:

    gem 'sidekiq-ffmpeg', github: "joker1007/sidekiq-ffmpeg"

And then execute:

    $ bundle

## Usage

```ruby
class EncodeJob < Sidekiq::Ffmpeg::BaseJob

  def on_progress(progress, extra_data = {})
    p progress
  end

  def on_complete(encoder, extra_data = {})
    puts "complete"
  end
end

EncodeJob.perform_async(input_filename, output_filename, extra_data, :mp4)
```

Implemented Encoder class is following:

- mp4
- WebM

## Contributing

1. Fork it ( https://github.com/[my-github-username]/sidekiq-ffmpeg/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

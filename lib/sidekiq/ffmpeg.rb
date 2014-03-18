require "sidekiq/ffmpeg/version"

require "sidekiq"

module Sidekiq
  module Ffmpeg

    autoload :BaseJob, "#{File.dirname(__FILE__)}/ffmpeg/base_job"

    module Encoder
      autoload :Base, "#{File.dirname(__FILE__)}/ffmpeg/encoder/base"
      autoload :MP4, "#{File.dirname(__FILE__)}/ffmpeg/encoder/mp4"
      autoload :WebM, "#{File.dirname(__FILE__)}/ffmpeg/encoder/webm"
    end

    class << self
      def logger
        @logger ||= Logger.new($stdout)
      end

      def logger=(logger)
        @logger = logger
      end

      def ffmpeg_cmd
        ENV["FFMPEG"] || "ffmpeg"
      end

      def get_aspect(filename)
        return nil unless filename

        aspect = nil
        ffmpeg = IO.popen("#{ffmpeg_cmd} -i #{filename.shellescape} 2>&1")
        ffmpeg.each("\r") do |line|
          if line =~ /Stream.*Video.*, (\d+)x(\d+)[,\s]/
            aspect = "#{$1}/#{$2}".to_r
          end
        end
        aspect
      end
    end
  end
end

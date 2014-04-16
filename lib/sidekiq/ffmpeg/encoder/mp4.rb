module Sidekiq
  module Ffmpeg
    module Encoder
      class MP4 < Base
        def initialize(options = {})
          super
          @acodec = options[:acodec] || acodec_select
        end

        def preset_options
          {
            :size              => "640x480",
            :video_bitrate     => "600k",
            :audio_bitrate     => "128k",
            :audio_sample_rate => 44100,
            :other_options     => "-partitions all -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -maxrate 1000 -level 30 -async 2#{acodec_select == "libfdk_aac" ? " -cutoff 18000" : ""}"
          }
        end

        def vcodec
          "libx264"
        end

        def acodec
          @acodec
        end

        def format
          "mp4"
        end

        private

        def acodec_select
          return @acodec if @acodec
          @acodec = case `#{Ffmpeg.ffmpeg_cmd} -v quiet -codecs | grep aac`
                    when /libfdk_aac/
                      "libfdk_aac"
                    when /libfaac/
                      "libfaac"
                    when /aac/
                      "aac"
                    when /libvo_aacenc/
                      "libvo_aacenc"
                    end
        end
      end
    end
  end
end

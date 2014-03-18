module Sidekiq
  module Ffmpeg
    module Encoder
      class MP4 < Base
        def preset_options
          {
            :size              => "640x480",
            :video_bitrate     => "600k",
            :audio_bitrate     => "128k",
            :audio_sample_rate => 44100,
            :other_options     => "-partitions all -me_method hex -subq 6 -me_range 16 -g 250 -keyint_min 25 -sc_threshold 40 -i_qfactor 0.71 -b_strategy 1 -qcomp 0.6 -qmin 10 -qmax 51 -qdiff 4 -maxrate 1000 -level 30 -async 2"
          }
        end

        def vcodec
          "libx264"
        end

        def acodec
          "libfaac"
        end

        def format
          "mp4"
        end
      end
    end
  end
end

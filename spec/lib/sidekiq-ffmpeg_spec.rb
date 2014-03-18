require "spec_helper"
require "sidekiq/testing"

Sidekiq::Testing.fake!

describe Sidekiq::Ffmpeg do
  describe ".get_aspect" do
    subject { Sidekiq::Ffmpeg.get_aspect("#{sample_dir}/sample_16_9.mp4") }

    it { should eq "16/9".to_r }
  end

  describe "#do_encode" do
    context "MP4" do
      subject(:encoder) { Sidekiq::Ffmpeg::Encoder::MP4.new }

      describe "on_progress callback" do
        before do
          encoder.on_progress = Proc.new {|progress| true }
        end

        it "on_progress receive call" do
          encoder.on_progress.should_receive(:call).with(an_instance_of(Float)).at_least(:once)
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end
      end

      describe "on_complete callback" do
        before do
          encoder.on_complete = Proc.new {|encoder| true }
        end

        it "on_complete receive call" do
          encoder.on_complete.should_receive(:call).with(encoder).once
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end
      end

      describe "debug log" do
        before do
          ENV["DEBUG"] = "1"
          Sidekiq::Ffmpeg.logger.should be_a(Logger)
        end

        after do
          ENV["DEBUG"] = nil
        end

        it "should call logger.debug" do
          Sidekiq::Ffmpeg.logger.should_receive(:debug)
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.mp4")
        end
      end
    end

    context "WebM" do
      subject(:encoder) { Sidekiq::Ffmpeg::Encoder::WebM.new }

      describe "on_progress callback" do
        before do
          encoder.on_progress = Proc.new {|progress| true }
        end

        it "on_progress receive call" do
          encoder.on_progress.should_receive(:call).with(an_instance_of(Float)).at_least(:once)
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.webm")
        end
      end

      describe "on_complete callback" do
        before do
          encoder.on_complete = Proc.new {|encoder| true }
        end

        it "on_complete receive call" do
          encoder.on_complete.should_receive(:call).with(encoder).once
          encoder.do_encode("#{sample_dir}/sample.mp4", "#{sample_dir}/output.webm")
        end
      end
    end
  end
end

describe Sidekiq::Ffmpeg::BaseJob do
  context "When job is performed" do
    class ::TestJob < Sidekiq::Ffmpeg::BaseJob
    end

    it "should receive do_encode" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      Sidekiq::Ffmpeg::Encoder::MP4.any_instance.should_receive(:do_encode).with(input_filename, output_filename).once
      TestJob.perform_async(input_filename, output_filename)
      TestJob.drain
    end
  end

  context "Job class has on_progress method" do
    class ::ProgressJob < Sidekiq::Ffmpeg::BaseJob

      def self.on_progress(progress, extra_data = {})
        true
      end
    end

    it "should receive on_progress" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      ::ProgressJob.should_receive(:on_progress).with(an_instance_of(Float), {}).at_least(:once)
      ProgressJob.perform_async(input_filename, output_filename)
      ProgressJob.drain
    end
  end

  context "Job class has on_complete method" do
    class ::CompleteJob < Sidekiq::Ffmpeg::BaseJob

      def self.on_complete(encoder, extra_data = {})
        true
      end
    end

    it "should receive on_complete" do
      input_filename = "#{sample_dir}/sample.mp4"
      output_filename = "#{sample_dir}/output.mp4"
      ::CompleteJob.should_receive(:on_complete).with(an_instance_of(Sidekiq::Ffmpeg::Encoder::MP4), {}).once
      CompleteJob.perform_async(input_filename, output_filename)
      CompleteJob.drain
    end
  end
end


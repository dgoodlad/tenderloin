module Tenderloin
  module Util
    def self.included(base)
      base.extend Tenderloin::Util
    end

    def wrap_output
      puts "====================================================================="
      yield
      puts "====================================================================="
    end

    def error_and_exit(error)
      abort <<-error
=====================================================================
Tenderloin experienced an error!

#{error.chomp}
=====================================================================
error
    end

    def logger
      Logger.singleton_logger
    end
  end

  class Logger < ::Logger
    @@singleton_logger = nil

    class << self
      def singleton_logger
        # TODO: Buffer messages until config is loaded, then output them?
        if Tenderloin.config.loaded?
          @@singleton_logger ||= Tenderloin::Logger.new(Tenderloin.config.tenderloin.log_output)
        else
          Tenderloin::Logger.new(nil)
        end
      end

      def reset_logger!
        @@singleton_logger = nil
      end
    end

    def format_message(level, time, progname, msg)
      "[#{level} #{time.strftime('%m-%d-%Y %X')}] Tenderloin: #{msg}\n"
    end
  end
end


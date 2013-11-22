require 'rrod/test_server'

module Rrod
  class TestServer
    class Runner

      include Singleton

      def self.run
        instance.run
      end

      def self.signal_queue
        @signal_queue ||= []
      end

      def run
        define_signal_traps

        Rrod::TestServer.tap { |server|
          puts "starting rrod test server"
          server.config[:root].tap { |root| FileUtils.rm_rf root if Dir.exists? root }
          server.create unless server.exist?
          server.start  unless server.started?
          begin puts "waiting for search..." end until server.search_started?
          puts "started."
        }

        setup_run_loop
      end

      private

      def setup_run_loop
        loop do
          case self.class.signal_queue.shift
          when nil
            sleep 1 # not really sure what to do here
          when :INT, :TERM, :QUIT
            puts
            puts "shutting down rrod test server"
            Rrod::TestServer.stop
            break
          end
        end
      end

      def define_signal_traps
        [:INT, :TERM, :QUIT].each do |signal|
          Signal.trap(signal) { self.class.signal_queue << signal }
        end
      end

    end
  end
end

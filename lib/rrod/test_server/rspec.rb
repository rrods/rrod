require 'rrod/test_server'

module Rrod
  module TestServer
    module RSpec

      def self.enable!
        test_server = Rrod::TestServer.test_server
        Rrod.configure do |config|
          config.pb_port = test_server.pb_port
        end

        # Rrod::Model.client.pb_port = Rrod::TestServer.test_server.pb_port

        ::RSpec.configure do |config|
          # config.include TestServerSupport, :integration => true

          config.before(:each, :integration => true) do
            test_server_fatal = Rrod::TestServer.test_server_fatal
            test_server       = Rrod::TestServer.test_server

            fail "Test server not working: #{test_server_fatal}" if test_server_fatal
            if example.metadata[:test_server] == false
              test_server.stop
            else
              test_server.create unless test_server.exist?
              test_server.start
            end
          end

          config.after(:each, :integration => true) do
            test_server_fatal = Rrod::TestServer.test_server_fatal
            test_server       = Rrod::TestServer.test_server

            # what on earth is happening in here???
            if test_server && 
              !test_server_fatal && 
              test_server.started? && 
              example.metadata[:test_server] != false
              test_server.drop
            end
          end

          config.after(:suite) do
            $test_server.stop if $test_server
          end
        end

      end

    end
  end
end


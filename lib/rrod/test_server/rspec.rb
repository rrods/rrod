require 'rrod/test_server'

module Rrod
  class TestServer
    module RSpec

      def self.enable!
        Rrod.configure do |config|
          config.pb_port = Rrod::TestServer.pb_port
        end

        ::RSpec.configure do |config|
          config.before(:each, :integration => true) do
            if Rrod::TestServer.fatal
              fail "Test server not working: #{Rrod::TestServer.fatal}" 
            end

            if example.metadata[:test_server] == false
              Rrod::TestServer.stop
            else
              Rrod::TestServer.create unless Rrod::TestServer.exist?
              Rrod::TestServer.start
            end
          end

          config.after(:each, :integration => true) do
            # what on earth is happening in here???
            if !Rrod::TestServer.fatal && 
              Rrod::TestServer.started? && 
              example.metadata[:test_server] != false
              Rrod::TestServer.drop
            end
          end

          config.after(:suite) do
            Rrod::TestServer.stop if Rrod::TestServer.started?
          end
        end

      end

    end
  end
end


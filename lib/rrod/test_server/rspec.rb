require 'rrod/test_server'

module Rrod
  class TestServer
    module RSpec

      def self.enable!
        Rrod.configure do |config|
          # We have to use http to set bucket props (to enable search index)
          # https://github.com/basho/riak-ruby-client/blob/v1.4.2/lib/riak/client.rb#L500
          config.http_port = Rrod::TestServer.http_port
          config.pb_port   = Rrod::TestServer.pb_port
        end

        ::RSpec.configure do |config|
          config.before(:each, :integration => true) do |example|
            if Rrod::TestServer.fatal
              fail "Test server not working: #{Rrod::TestServer.fatal}" 
            end

            if example.metadata[:test_server] == false
              Rrod::TestServer.stop
            else
              Rrod::TestServer.create unless Rrod::TestServer.exist?
              unless Rrod::TestServer.started?
                @rspec_started = true
                Rrod::TestServer.start
                Rrod::TestServer.wait_for_search
              end
            end
          end

          config.after(:each, :integration => true) do |example|
            # i really don't understand this...
            # well the 'example' needs to be accessed another way, Rspec.current_example.
            if !Rrod::TestServer.fatal && 
              Rrod::TestServer.started? && 
              example.metadata[:test_server] != false
              Rrod::TestServer.drop
            end
          end

          config.after(:suite) do
            Rrod::TestServer.stop if @rspec_started && Rrod::TestServer.started?
          end
        end
      end

    end
  end
end

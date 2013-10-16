# The test server was copied directly out of 
# riak-ruby-client/spec/support/test_server.rb 
# and broken into several modules, then refactored.
#
# A significant amount of this code appears to make
# very little sense at first glance and needs to be
# cleaned up.

require 'riak/test_server'

module Rrod
  module TestServer
    extend self

    def config
      {'root'   => '/tmp/rrod-riak-server', 
       'source' => '/Users/adamhunter/Downloads/riak-1.4.2/bin'}
    end

    def test_server

      unless $test_server
        begin
          # require 'yaml'
          # config = YAML.load_file(File.expand_path("../test_server.yml", __FILE__))
          $test_server = Riak::TestServer.create(:root => config['root'],
                                                 :source => config['source'],
                                                 :min_port => config['min_port'] || 15000)
        rescue SocketError => e
          warn "Couldn't connect to Riak TestServer! #{$test_server.inspect}"
          warn "Skipping remaining integration tests."
          warn_crash_log
          $test_server_fatal = e
        rescue => e
          warn "Can't run integration specs without the test server. Please create/verify spec/support/test_server.yml."
          warn "Skipping remaining integration tests."
          warn e.inspect
          warn_crash_log
          $test_server_fatal = e
        end
      end
      $test_server
    end

    def test_server_fatal
      $test_server_fatal
    end

    def warn_crash_log
      if $test_server && crash_log = $test_server.log + 'crash.log'
        warn crash_log.read if crash_log.exist?
      end
    end
  end
end


# The test server was copied directly out of 
# riak-ruby-client/spec/support/test_server.rb 
# and broken into several modules, then refactored.

require 'yaml'
require 'riak/test_server'

module Rrod
  class TestServer
    attr_reader :fatal
    
    extend Forwardable
    include Singleton

    DELEGATES = %w[start stop create drop pb_port started? exist?]

    class << self
      extend Forwardable
      def_delegators(:instance, * [:fatal] + DELEGATES)
    end

    def_delegators(:server, *DELEGATES)

    def config
      loaded = YAML.load_file(Rrod.configuration.test_server_yml)
      { min_port: 15_000 }.merge loaded.symbolize_keys
    rescue Errno::ENOENT => e
      message = "Cannot find Rrod::TestServer configuration. #{e.message}"
      raise MissingConfigurationError.new(message)
    end

    def server
      @server ||= try_creating_riak_test_server!
    end

    def warn_crash_log
      if @server && crash_log = @server.log + 'crash.log'
        warn crash_log.read if crash_log.exist?
      end
    end

    protected 

    attr_writer :fatal

    private

    # TODO refactor warnings
    def try_creating_riak_test_server!
      Riak::TestServer.create(config)
    rescue SocketError => e
      warn "Couldn't connect to Riak TestServer!"
      warn "Skipping remaining integration tests."
      warn_crash_log
      self.fatal = e
    rescue => e
      warn "Can't run integration specs without the test server. Please create/verify spec/support/test_server.yml."
      warn "Skipping remaining integration tests."
      warn e.inspect
      warn_crash_log
      self.fatal = e
    end

    MissingConfigurationError = Class.new(StandardError)
  end
end

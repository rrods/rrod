module Rrod
  module Config
    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  extend Config

  class Configuration
    attr_accessor :client, :http_port, :pb_port, :protocol, 
      :test_server_yml, :test_server_search_startup_timeout

    def initialize
      @protocol        = 'pbc'
      @test_server_yml = File.expand_path('../../../spec/support/test_server.yml', __FILE__)
      @test_server_search_startup_timeout = 40 # because it's a test
    end

    def client
      @client ||= Riak::Client.new(client_options)
    end

    private

    def client_options
      attributes = %w[http_port pb_port protocol]
      Hash[
        attributes.map { |method| 
          value = public_send(method)
          next if value.nil?
          [method.to_sym, value] 
        }.compact
      ]
    end
  end
end

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
    attr_accessor :client, :pb_port, :test_server_yml

    def initialize
      @test_server_yml = File.expand_path('../../../spec/support/test_server.yml', __FILE__)
    end

    def client
      @client ||= Riak::Client.new(client_options)
    end

    private

    def client_options
      attributes = %w[pb_port]
      attributes.inject({}) { |acc, k| acc.tap { |h| h[k.to_sym] = public_send(k) } }
    end
  end
end

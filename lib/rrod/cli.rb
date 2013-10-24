require 'thor'
require 'rrod'

module Rrod
  class Cli < Thor
    package_name "Rrod"
  
    map "-i" => :pry
    map "-t" => :test

    desc "pry", "start an interactive ruby session with Rrod loaded"
    def pry
      require 'pry'
      TOPLEVEL_BINDING.pry
    end

    desc "test", "start the Rrod::TestServer"
    def test
      require 'rrod/test_server/runner'
      Rrod::TestServer::Runner.run
    end
  end
end

require 'thor'
require 'rrod'

module Rrod
  class Cli < Thor
    package_name "Rrod"
  
    map "-i" => :pry

    desc "pry", "start an interactive ruby session with Rrod loaded"
    def pry
      require 'pry'
      TOPLEVEL_BINDING.pry
    end
  end
end

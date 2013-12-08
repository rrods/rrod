module Rrod
  class Query
    attr_reader :options

    def initialize(options)
      self.options = options
    end

    def id
      options[:id]
    end

    def using_id?
      id.present?
    end

    def to_s
      options.map { |key, value| "#{key}:#{value}" }.join(" AND ")
    end

    def options=(options)
      @options = options.with_indifferent_access
      raise ArgumentError.new("no search options") if options.blank?
      raise ArgumentError.new("cannot mix id with other options") if using_id? and options.keys.count > 1
    rescue => e
      @options.clear and raise e
    end

  end
end

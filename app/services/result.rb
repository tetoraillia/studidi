class Result
    attr_reader :data, :errors

    def initialize(success, data = nil, errors = nil)
        @success = success
        @data = data
        @errors = errors
    end

    def success?
        @success
    end

    def failure?
        !@success
    end

    def self.success(data = nil)
        new(true, data)
    end

    def self.failure(errors = nil)
        new(false, nil, errors)
    end
end

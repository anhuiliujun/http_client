module HttpClient
  class Response
    def initialize(subject)
      @subject = subject
    end

    def status
      @subject.status
    end

    def body
      @subject.body
    end
  end

  class ErrorResponse
    def initialize(options)
      @status = options.fetch(:status, 500)
      @body = options.fetch(:body, {errors: {message: "Something went wrong!"}})
    end

    def status
      @status
    end

    def body
      @body
    end

  end
end

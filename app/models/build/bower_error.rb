module Build
  # Encapsulate Bower errors
  # parsed from Bower JSON output
  class BowerError < BuildError
    attr_reader :path, :command, :details, :code, :stacktrace

    ENOTFOUND = 'ENOTFOUND'.freeze
    EINVALID = 'EINVALID'.freeze

    def initialize(message, details, path = nil, command = nil, code = nil, stacktrace = nil)
      @details = details
      @path = path
      @command = command
      @code = code
      @stacktrace = stacktrace
      super(message)
    end

    def not_found?
      @code == ENOTFOUND
    end

    def invalid?
      @code == EINVALID
    end

    def self.from_shell_error(e)
      parsed_json = JSON.parse(e.message)
      error = parsed_json.find { |h| h['level'] == 'error' }
      BowerError.new(error['message'],
                     error['details'],
                     e.path,
                     e.command,
                     error['code'],
                     error['stacktrace'])
    end
  end
end

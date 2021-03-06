module Csjparser
  class Reader
    def self.read(filepath)
      validate(filepath)

      # Read-only to keep consistency.
      File.open(filepath, 'r') do |file|
        yield file
      end
    end

    def self.validate(filepath)
      errors = []
      errors << "File #{filepath} does not exists." unless File.exist?(filepath)
      errors << "File #{filepath} is executable. Why?" if File.executable?(filepath)
      errors << "File #{filepath} is not readable." unless File.readable?(filepath)
      raise(StandardError, errors.join("\n")) unless errors.empty?
    end
  end
end

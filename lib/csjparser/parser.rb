# rubocop:disable Style/DoubleNegation

module Csjparser
  class Parser
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
    end

    def parse_document
      parsed_document = []
      Reader.read(filepath) do |file|
        keys = file.gets.gsub(/("|'|\s)/, '').chomp.split(',')

        file.each_line do |line|
          parsed_values = process_line(line)

          parsed_document << build_hash(keys, parsed_values)
        end
      end

      parsed_document
    end

    def process_line(line)
      values = line.gsub(', ', ',').chomp

      # Identify arrays before splitting a file and replace commas with {array} strings.
      values = values.gsub(/(?:\[|(?!^)\G){1}[^,\]]*\K,/, '{array}').split(',')

      values.map do |value|
        # Trim first and last double quotes.
        parse(value.gsub(/(^"|"$)/, ''))
      end
    end
    private :process_line

    def build_hash(keys, parsed_values)
      {}.tap do |memo|
        keys.each_with_index do |key, index|
          memo[key.to_sym] = parsed_values[index]
        end
      end
    end
    private :build_hash

    def parse(value)
      object = Csjparser::ValueChecker.new(value)

      case
      when object.nil?
        nil
      when object.bool?
        !!(value =~ /^(true|yes)/i)
      when object.integer?
        value.to_i
      when object.float?
        Float(value)
      when object.date?
        Date.parse(value)
      when object.array?
        parse_array(value)
      else
        value
      end
    end
    private :parse

    def parse_array(value)
      array_values = value.gsub(/(^\[|\]$)/, '').split('{array}')

      array_values.map do |element|
        raise 'nested arrays not supported' if Csjparser::ValueChecker.new(element).array?
        parse(element.gsub(/(^"|"$)/, ''))
      end
    end
    private :parse_array
  end
end

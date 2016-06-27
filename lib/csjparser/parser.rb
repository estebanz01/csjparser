# We want to avoid the use of truthy values while guessing the type.
# rubocop:disable Style/DoubleNegation

module Csjparser
  class Parser
    attr_reader :filepath
    attr_accessor :keys

    def initialize(filepath)
      @filepath = filepath
    end

    def parse_document
      final_element = []
      Reader.read(filepath) do |file|
        keys = file.gets.gsub(/("|'|\s)/, '').chomp.split(',')

        file.each_line do |line|
          values = line.gsub(', ', ',').chomp
          values = values.gsub(/(?:\[|(?!^)\G){1}[^,\]]*\K,/, '{array}').split(',')

          parsed_values = values.map do |value|
            # Trim first and last double quotes.
            parse(value.gsub(/(^"|"$)/, ''))
          end

          final_element << {}.tap do |memo|
            keys.each_with_index do |key, index|
              memo[key.to_sym] = parsed_values[index]
            end
          end
        end
      end

      final_element
    end

    def bool?(value)
      !!(value =~ /^(true|yes)$/i || value =~ /^(false|no)$/i)
    end

    def integer?(value)
      !!(!value.empty? && value !~ /\D/)
    end

    def float?(value)
      !!Float(value)
    rescue
      false
    end

    def date?(value)
      !!Date.parse(value)
    rescue
      false
    end

    def nil?(value)
      value == 'null'
    end

    def array?(value)
      !!(value =~ /(^\[|\]$)/)
    end

    def parse(value)
      if nil?(value)
        nil
      elsif bool?(value)
        !!(value =~ /^(true|yes)/i)
      elsif integer?(value)
        value.to_i
      elsif float?(value)
        Float(value)
      elsif date?(value)
        Date.parse(value)
      elsif array?(value)
        parse_array(value)
      else
        value
      end
    end
    private :parse

    def parse_array(value)
      array_values = value.gsub(/(^\[|\]$)/, '').split('{array}')

      array_values.map do |element|
        raise 'nested arrays not supported' if array?(element)
        parse(element.gsub(/(^"|"$)/, ''))
      end
    end
    private :parse_array
  end
end

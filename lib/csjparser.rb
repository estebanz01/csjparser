require "csjparser/version"
require 'date'

module Csjparser
  class Reader
    def self.read(filepath)
      raise "File #{filepath} cannot be read it by Ruby." unless File.readable?(filepath)

      # Read-only to keep consistency.
      File.open(filepath, 'r') do |file|
        yield file
      end
    end
  end

  class Parser
    attr_reader :filepath
    attr_accessor :keys

    def initialize(filepath)
      @filepath = filepath
    end

    def parse_document
      final_element = []
      Reader.read(filepath) do |file|
        keys = file.gets.gsub(/("|'|\s)/,'').chomp.split(',')

        file.each_line do |line|
          values = line.gsub(', ', ',').chomp
          values = values.gsub(/(?:\[|(?!^)\G){1}[^,\]]*\K,/,'{array}').split(',')

          parsed_values = values.map do |value|
            # Trim first and last double quotes.
            parse(value.gsub(/(^"|"$)/,''))
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
      !!(Float(value) rescue false)
    end

    def date?(value)
      !!(Date.parse(value) rescue false)
    end

    def is_nil?(value)
      value == 'null'
    end

    def array?(value)
      !!(value =~ /(^\[|\]$)/)
    end

    def parse(value)
      case
      when is_nil?(value)
        nil
      when bool?(value)
        !!(value =~ /^(true|yes)/i)
      when integer?(value)
        value.to_i
      when float?(value)
        Float(value)
      when date?(value)
        Date.parse(value)
      when array?(value)
        parse_array(value)
      else
        value
      end
    end
    private :parse

    def parse_array(value)
      array_values = value.gsub(/(^\[|\]$)/,'').split('{array}')

      array_values.map do |value|
        raise 'nested arrays not supported' if array?(value)
        parse(value.gsub(/(^"|"$)/,''))
      end
    end
    private :parse_array
  end
end

# References
# http://stackoverflow.com/questions/5661466/test-if-string-is-a-number-in-ruby-on-rails
# http://stackoverflow.com/a/21815132
# http://stackoverflow.com/a/1034499
# http://zaiste.net/2012/07/string_to_boolean_in_ruby/
# http://rorbservations.com/post/136975265334/each-with-object-vs-tap-plus-each
# http://stackoverflow.com/a/32896689

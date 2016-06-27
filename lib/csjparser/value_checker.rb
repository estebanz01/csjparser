# We want to avoid the use of truthy values while guessing the type.
# rubocop:disable Style/DoubleNegation

module Csjparser
  class ValueChecker
    def self.bool?(value)
      !!(value =~ /^(true|yes)$/i || value =~ /^(false|no)$/i)
    end

    def self.integer?(value)
      !!(!value.empty? && value !~ /\D/)
    end

    def self.float?(value)
      !!Float(value)
    rescue
      false
    end

    def self.date?(value)
      !!Date.parse(value)
    rescue
      false
    end

    def self.nil?(value)
      value == 'null'
    end

    def self.array?(value)
      !!(value =~ /(^\[|\]$)/)
    end
  end
end

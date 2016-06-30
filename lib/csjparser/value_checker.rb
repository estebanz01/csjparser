# We want to avoid the use of truthy values while guessing the type.
# rubocop:disable Style/DoubleNegation

module Csjparser
  class ValueChecker
    attr_reader :object

    def initialize(object)
      @object = object
    end

    def bool?
      !!(object =~ /^(true|yes)$/i || object =~ /^(false|no)$/i)
    end

    def integer?
      !!(!object.empty? && object !~ /\D/)
    end

    def float?
      !!Float(object)
    rescue
      false
    end

    def date?
      !!Date.parse(object)
    rescue
      false
    end

    def nil?
      object == 'null'
    end

    def array?
      !!(object =~ /(^\[|\]$)/)
    end
  end
end

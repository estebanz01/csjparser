require 'spec_helper'

describe Csjparser::ValueChecker do
  describe '.nil?' do
    it 'returns true if the string is the null string' do
      expect(described_class.nil?('null')).to be true
    end

    it 'returns false if the string is not the null string' do
      expect(described_class.nil?('false')).to be false
      expect(described_class.nil?('nil')).to be false
    end
  end

  describe '.integer?' do
    it 'returns true if the string is a valid integer' do
      expect(described_class.integer?('124')).to be true
    end

    it 'returns false if the string is not a valid integer' do
      expect(described_class.integer?('1568.568')).to be false
    end
  end

  describe '.float' do
    it 'returns true if the string is a valid float' do
      expect(described_class.float?('124.35')).to be true
      expect(described_class.float?('124e3')).to be true
      expect(described_class.float?('124E-3')).to be true
    end

    it 'returns false if the string is not a valid float' do
      expect(described_class.float?('not_valid_134')).to be false
    end
  end

  describe '.date?' do
    it 'returns true if the string is a valid date' do
      expect(described_class.date?('2015-06-03')).to be true
      expect(described_class.date?('2015-03-06')).to be true
      expect(described_class.date?('2015/06/03')).to be true
      expect(described_class.date?('2016-06-11 08:54:12.895416+00')).to be true
    end

    it 'returns false if the string is not a valid date' do
      expect(described_class.date?('not_valid_date')).to be false
    end
  end

  describe '.bool?' do
    it 'returns true if the string is a valid boolean' do
      expect(described_class.bool?('true')).to be true
      expect(described_class.bool?('TRUE')).to be true
      expect(described_class.bool?('yes')).to be true
      expect(described_class.bool?('false')).to be true
      expect(described_class.bool?('FALSE')).to be true
      expect(described_class.bool?('no')).to be true
    end

    it 'returns false if the string is not a valid boolean' do
      expect(described_class.bool?('not_valid_134')).to be false
      expect(described_class.bool?('1')).to be false
      expect(described_class.bool?('0')).to be false
    end
  end

  describe 'array?' do
    it 'returns true if the string is a valid array' do
      expect(described_class.array?('[1,2,"sd",4]')).to be true
    end

    it 'returns false if the string is not a valid array' do
      expect(described_class.array?('1,2,3,4,5')).to be false
    end
  end
end

require 'spec_helper'

describe Csjparser::ValueChecker do
  describe 'nil?' do
    it 'returns true if the string is the null string' do
      expect(described_class.new('null')).to be_nil
    end

    it 'returns false if the string is not the null string' do
      expect(described_class.new('false')).not_to be_nil
      expect(described_class.new('nil')).not_to be_nil
    end
  end

  describe '#integer?' do
    it 'returns true if the string is a valid integer' do
      expect(described_class.new('124')).to be_integer
    end

    it 'returns false if the string is not a valid integer' do
      expect(described_class.new('1568.568')).not_to be_integer
    end
  end

  describe '#float' do
    it 'returns true if the string is a valid float' do
      expect(described_class.new('124.35')).to be_float
      expect(described_class.new('124e3')).to be_float
      expect(described_class.new('124E-3')).to be_float
    end

    it 'returns false if the string is not a valid float' do
      expect(described_class.new('not_valid_134')).not_to be_float
    end
  end

  describe '#date?' do
    it 'returns true if the string is a valid date' do
      expect(described_class.new('2015-06-03')).to be_date
      expect(described_class.new('2015-03-06')).to be_date
      expect(described_class.new('2015/06/03')).to be_date
      expect(described_class.new('2016-06-11 08:54:12.895416+00')).to be_date
    end

    it 'returns false if the string is not a valid date' do
      expect(described_class.new('not_valid_date')).not_to be_date
    end
  end

  describe '.bool?' do
    it 'returns true if the string is a valid boolean' do
      expect(described_class.new('true')).to be_bool
      expect(described_class.new('TRUE')).to be_bool
      expect(described_class.new('yes')).to be_bool
      expect(described_class.new('false')).to be_bool
      expect(described_class.new('FALSE')).to be_bool
      expect(described_class.new('no')).to be_bool
    end

    it 'returns false if the string is not a valid boolean' do
      expect(described_class.new('not_valid_134')).not_to be_bool
      expect(described_class.new('1')).not_to be_bool
      expect(described_class.new('0')).not_to be_bool
    end
  end

  describe 'array?' do
    it 'returns true if the string is a valid array' do
      expect(described_class.new('[1,2,"sd",4]')).to be_array
    end

    it 'returns false if the string is not a valid array' do
      expect(described_class.new('1,2,3,4,5')).not_to be_array
    end
  end
end

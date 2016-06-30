require 'spec_helper'

describe Csjparser::Parser do
  describe '#process_document' do
    it 'returns an array of hash elements built from a csj document' do
      filepath = File.expand_path(File.join(__dir__, '../../fixtures/text.csj'))

      results = described_class.new(filepath).parse_document
      expect(results).to be_instance_of Array

      results.each do |result|
        expect(result).to be_instance_of Hash
        expect(result).not_to be_empty
      end
    end
  end
end

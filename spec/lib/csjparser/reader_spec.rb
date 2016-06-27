require 'spec_helper'

describe Csjparser::Reader do
  describe '.read' do
    context 'when filepath provided points to a valid file' do
      it 'loads the file' do
        filepath = '/path/to/file'
        allow(File).to receive(:readable?).and_return(true)
        allow(File).to receive(:exist?).and_return(true)
        allow(File).to receive(:executable?).and_return(false)

        expect(File).to receive(:open).with(filepath, 'r')

        described_class.read(filepath)
      end
    end
  end

  describe '.validate' do
    it 'validates the file using the specified filepath' do

    end
  end
end

require 'spec_helper'

describe Csjparser::Reader do
  let(:filepath) { '/path/to/file' }

  describe '.read' do
    context 'when filepath provided points to a valid file' do
      it 'loads the file' do
        allow(described_class).to receive(:validate).with(filepath)
        expect(File).to receive(:open).with(filepath, 'r')

        described_class.read(filepath)
      end
    end
  end

  describe '.validate' do
    it 'raises an error if the filepath does not exists' do
      allow(File).to receive_messages(readable?: true, executable?: false)

      expect do
        described_class.validate(filepath)
      end.to raise_error "File #{filepath} does not exists."
    end

    it 'raises an error if the filepath is an executable' do
      allow(File).to receive(:executable?).with(filepath).and_return(true)
      allow(File).to receive_messages(readable?: true, exist?: true)

      expect do
        described_class.validate(filepath)
      end.to raise_error "File #{filepath} is executable. Why?"
    end

    it 'raises an error if the filepath is not readable' do
      allow(File).to receive_messages(executable?: false, exist?: true)

      expect do
        described_class.validate(filepath)
      end.to raise_error "File #{filepath} is not readable."
    end

    it 'merges multiple error messages if they exists' do
      error_messages = ["File #{filepath} does not exists.",
                        "File #{filepath} is executable. Why?",
                        "File #{filepath} is not readable."]

      allow(File).to receive(:executable?).with(filepath).and_return(true)

      expect { described_class.validate(filepath) }.to raise_error do |error|
        expect(error.message.split("\n")).to eq error_messages
      end
    end
  end
end

require 'spec_helper'

describe Tikarb do
  let(:file_path) { 'spec/data/test.html' }
  before { Tikarb.path = 'bin/tika-app.jar' }

  it 'has a version number' do
    expect(Tikarb::VERSION).not_to be nil
  end

  it 'detects media type' do
    type = Tikarb.detect(file_path)
    expect(type).to eq('text/html')

    type = Tikarb.detect(File.open(file_path))
    expect(type).to eq('text/html')
  end

  it 'parses file' do
    text, metadata = Tikarb.parse(file_path)
    expect(text).to include('test')
    expect(metadata).not_to be_nil

    text, metadata = Tikarb.parse(File.open(file_path))
    expect(text).to include('test')
    expect(metadata).not_to be_nil
  end

  it 'parses cli options' do
    xml = Tikarb.cli('--xml', file_path)
    expect(xml).to include('xml')
    expect(xml).to include('test')
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventBanner, type: :model do
  subject { build(:event_banner) }

  it 'inherits from Attachment' do
    expect(EventBanner.superclass).to eq(Attachment)
  end

  it 'ensures uploaded file is an image' do
    File.open(test_files.join('poem.txt')) do |f|
      subject.file.attach(
        io: f, filename: File.basename(f.path), content_type: 'text/plain'
      )
    end

    expect(subject.valid?).to eq(false)
    expect(subject.errors[:file]).to include('must be an image')
  end

  it 'renders an optimized variant' do
    transformations = subject.file_to_render.variation.transformations

    # optimization from https://stackoverflow.com/a/7262050
    expect(transformations[:strip]).to eq(true)
    expect(transformations[:interlace]).to eq('Plane')
    expect(transformations[:gaussian_blur]).to eq(0.05)
    expect(transformations[:quality]).to eq('85%')

    # for width of cards
    expect(transformations[:resize]).to eq('750x')

    # successfully processes
    expect(subject.file_to_render.processed.service_url).to_not be(nil)
  end
end

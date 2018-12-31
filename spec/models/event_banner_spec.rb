# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventBanner, type: :model do
  include Rails.application.routes.url_helpers

  subject { build(:event_banner) }

  it 'inherits from Attachment' do
    expect(EventBanner.superclass).to eq(Attachment)
  end

  it 'ensures uploaded file is an image' do
    attach_file(subject.file, test_files.join('poem.txt'))

    expect(subject.valid?).to eq(false)
    expect(subject.errors[:file]).to include('must be an image')
  end

  it 'renders an optimized variant' do
    transformations = subject.file_to_render.variation.transformations

    # optimization from https://stackoverflow.com/a/7262050
    expect(transformations[:strip]).to eq(true)
    expect(transformations[:interlace]).to eq('Plane')
    expect(transformations[:gaussian_blur]).to eq(0.05)
    expect(transformations[:define]).to eq('jpeg:dct-method=float')
    expect(transformations[:sampling_factor]).to eq('4:2:0')
    expect(transformations[:quality]).to eq('85%')

    # for width of cards
    expect(transformations[:resize]).to eq('500x')

    # successfully processes
    expect(
      rails_representation_path(subject.file_to_render.processed)
    ).to_not be(nil)
  end
end

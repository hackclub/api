# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventLogo, type: :model do
  subject { build(:event_logo) }

  it 'inherits from Attachment' do
    expect(EventLogo.superclass).to eq(Attachment)
  end

  it 'ensures uploaded file is an image' do
    attach_file(subject.file, test_files.join('poem.txt'))

    expect(subject.valid?).to eq(false)
    expect(subject.errors[:file]).to include('must be an image')
  end

  it 'renders an appropriate variant' do
    transformations = subject.file_to_render.variation.transformations

    expect(transformations[:resize]).to eq('x150')
    expect(transformations[:trim]).to eq(true)
  end
end

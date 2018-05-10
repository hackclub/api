# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventPhoto, type: :model do
  subject { build(:event_photo) }

  it 'inherits from Attachment' do
    expect(EventPhoto.superclass).to eq(Attachment)
  end

  it 'ensures uploaded file is a jpeg or png' do
    expect(subject.valid?).to eq(true)

    attach_file(subject.file, test_files.join('poem.txt'))
    expect(subject.valid?).to eq(false)
    expect(subject.errors[:file]).to include('must be a jpeg or png image')

    attach_file(subject.file, test_files.join('dinosaur.svg'))
    expect(subject.valid?).to eq(false)

    attach_file(subject.file, test_files.join('event_photo.jpg'))
    expect(subject.valid?).to eq(true)

    attach_file(subject.file, test_files.join('event_logo.png'))
    expect(subject.valid?).to eq(true)
  end

  it 'renders original image' do
    expect(subject.file_to_render.class).to eq(ActiveStorage::Attached::One)
  end

  describe '#preview' do
    it 'successfully renders a variant for jpegs' do
      expect(subject.file.content_type).to eq('image/jpeg') # from factory
      expect(subject.preview.processed.service_url).to_not be(nil)
    end

    it 'successfully renders a variant for pngs' do
      attach_file(subject.file, test_files.join('event_logo.png'))
      expect(subject.preview.processed.service_url).to_not be(nil)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  before do
    File.open(test_files.join('event_logo.png')) do |f|
      subject.file.attach(
        io: f, filename: 'event_logo.png', content_type: 'image/png'
      )
    end
  end

  ## db columns ##

  it { should have_db_column :created_at }
  it { should have_db_column :updated_at }
  it { should have_db_column :type }
  it { should have_db_column :attachable_id }
  it { should have_db_column :attachable_type }

  ## associations ##

  it { should belong_to(:attachable) }

  ## model specific stuff ##

  it 'should have an ActiveStorage file' do
    # this calls the #filename method of the file attribute to attempt to test
    # for activestorage inclusion - because that method is defined by
    # activestorage
    expect(subject.file.filename).to eq('event_logo.png')
  end

  it 'should require presence of #file' do
    expect(subject.file.attached?).to eq(true)
    expect(subject.valid?).to eq(true)

    subject.file.purge # clear existing file

    expect(subject.file.attached?).to eq(false)
    expect(subject.valid?).to eq(false)
  end

  example '#file_path returns path to file' do
    path = subject.file_path

    # path ends w/ event_logo.png - it's not the greatest proxy to ensure the
    # file is actually the one we passed, but it's easier to test than actually
    # spinning up the entire rails framework to be able to send code through the
    # routes
    expect(path.split('/').last).to eq('event_logo.png')
  end
end

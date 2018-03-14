# frozen_string_literal: true

# to make acccessing supporting files easier. usage:
# test_files.join('event_logo.png')
def test_files
  Rails.root.join('spec', 'support', 'files')
end

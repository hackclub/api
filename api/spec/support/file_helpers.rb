# frozen_string_literal: true

# to make acccessing supporting files easier. usage:
# test_files.join('event_logo.png')
def test_files
  Rails.root.join('spec', 'support', 'files')
end

# to make attaching files to models easier. usage:
#
#   attach_file(event_photo.file, test_files.join('event_photo.jpg')
#
def attach_file(obj, path)
  File.open(path) do |f|
    filename = File.basename(path)

    # detect content type based on extension, don't do this in production - see
    # https://stackoverflow.com/a/7537309.
    #
    # i opted for doing this instead of installing a gem that will actually read
    # the file's contents so we don't have to add an extra test dependency.
    content_type = MIME::Types.type_for(filename).first.content_type

    obj.attach(
      io: f,
      filename: filename,
      content_type: content_type
    )
  end
end

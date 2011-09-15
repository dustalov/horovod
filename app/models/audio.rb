# encoding: utf-8

class Audio < Post
  has_attached_file :attachment, :url => '/things/:id.:extension'

  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment,
    :content_type => [ 'audio/mpeg', 'audio/x-mp3', 'audio/mp3' ]

  before_post_process :normalize_file_name
  def normalize_file_name
    crc32 = Zlib.crc32(attachment_file_name)
    extension = File.extname(attachment_file_name).
                     gsub(/^\.+/, '').
                     downcase
    filename = [ crc32, extension ].join('.')
    self.attachment.instance_write(:file_name, filename)
  end
end

# encoding: utf-8

class Photo < Post
  require 'zlib'

  has_attached_file :attachment, :url => '/things/:id-:style.:extension',
    :styles => { :thumb => '320x260', :lightbox => '570x471' }

  validates_attachment_presence :attachment
  validates_attachment_content_type :attachment,
    :content_type => [ 'image/png', 'image/x-png', 'image/gif',
      'image/pjpeg', 'image/jpeg' ]

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

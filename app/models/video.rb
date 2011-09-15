# encoding: utf-8

class Video < Post
  include ActiveModel::Validations

  after_create do |post|
    oe = OhEmbedr::OhEmbedr.new(:url => post.video_url).gets
    return false unless oe['type'] && oe['type'].downcase == 'video'

    metadata = {
      :provider_name => oe['provider_name'],
      :title => oe['title'],
      :author_name => oe['author_name'],
      :thumbnail_url => oe['thumbnail_url'],
      :thumbnail_width => oe['thumbnail_width'],
      :thumbnail_height => oe['thumbnail_height']
    }

    post.create_metadata(metadata)
  end

  has_one :metadata, :class_name => 'VideoMetadata',
    :dependent => :destroy, :inverse_of => :video

  accepts_nested_attributes_for :metadata,
    :allow_destroy => true

  delegate :thumbnail_url, :to => :metadata
  delegate :title, :to => :metadata

  validates :video_url, :presence => true
  validates_with VideoValidator
end

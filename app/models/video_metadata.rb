# encoding: utf-8

class VideoMetadata < ActiveRecord::Base
  set_table_name 'video_metadatas'

  belongs_to :video, :inverse_of => :metadata

  #validates :video, :presence => true, :associated => true,
  #  :uniqueness => true
  validates :thumbnail_url, :presence => true
end

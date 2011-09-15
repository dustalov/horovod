# encoding: utf-8

class VideoValidator < ActiveModel::Validator
  def validate(record)
    raise TypeError unless record.is_a? Video
    begin
      OhEmbedr::OhEmbedr.new(:url => record.video_url).gets
    rescue OhEmbedr::UnsupportedError => ex
      puts ex.backtrace
      record.errors[:video_url] << I18n.t('errors.video_not_exists')
    end
  end
end

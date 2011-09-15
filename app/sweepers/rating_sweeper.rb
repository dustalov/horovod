# encoding: utf-8

class RatingSweeper < ActionController::Caching::Sweeper
  observe Post, Rating

  def after_save(record)
    post = record.is_a?(Post) ? record : record.post
    Rails.cache.delete(Rating.max_cache_key)
  end
end

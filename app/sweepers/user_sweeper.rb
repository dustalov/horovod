# encoding: utf-8

class UserSweeper < ActionController::Caching::Sweeper
  observe Rating

  def after_save(record)
    user = record.post.user
    Rails.cache.delete(Rating.max_cache_key)
  end
end

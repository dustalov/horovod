# encoding: utf-8

class Rating < ActiveRecord::Base
  extend ActiveModel::Translation
  include ActiveModel::Validations

  belongs_to :user, :inverse_of => :ratings
  belongs_to :post, :inverse_of => :ratings

  scope :for, lambda { |post, user|
    where(:post_id => post).
    where(:user_id => user).
    order('created_at DESC')
  }

  scope :score, lambda { |post|
    where(:post_id => post).
    order('created_at DESC')
  }

  class << self
    def max_cache_key
      [ 'rating', 'max' ].join '/'
    end

    def max
      Rails.cache.fetch(max_cache_key) do
        scores = {}
        Rating.find_each do |rating|
          scores[rating.post_id] ||= 0
          scores[rating.post_id] += 1
        end
        scores.sort do |a, b|
          a.last <=> b.last
        end.last
      end.last
    end
  end

  validates :user, :presence => true
  validates_with AllowanceValidator

  delegate :to_s, :to => :post
end

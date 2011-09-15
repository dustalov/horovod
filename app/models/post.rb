# encoding: utf-8

class Post < ActiveRecord::Base
  extend ActiveModel::Translation

  belongs_to :user, :inverse_of => :posts
  has_many :ratings, :inverse_of => :post,
    :dependent => :destroy

  def self.ratings
    all.sort do |a, b|
      score_diff = Rating.score(a).count <=> Rating.score(b).count
      if score_diff == 0
        b.created_at <=> a.created_at
      else
        score_diff
      end
    end.reverse
  end

  def self.per_page
    5
  end

  default_scope order('posts.created_at DESC')

  delegate :surname, :name, :prefix => 'user', :to => :user
  delegate :squad, :to => :user

  validates :user, :presence => true, :associated => true

  def author
    self.user.to_s
  end

  def to_s
    self.body
  end

  def score
    return 0.0 if self.new_record?
    score = Rating.score(self).count.to_f / Rating.max
    score.finite? ? score : 0.0
  end

  def rateable?(current_user = nil)
    recent = Rating.for(self, current_user).limit(1).first
    return true unless recent

    Time.now >= (recent.created_at + 24.hours)
  end
end

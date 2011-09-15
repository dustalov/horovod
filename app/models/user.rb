# encoding: utf-8

class User < ActiveRecord::Base
  extend ActiveModel::Translation

  has_many :posts, :inverse_of => :user,
    :dependent => :destroy
  has_many :ratings, :inverse_of => :user,
    :dependent => :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :surname, :name, :squad, :email,
    :password, :password_confirmation, :remember_me

  validates :surname, :presence => true
  validates :name, :presence => true
  validates :squad, :presence => true,
    :format => /[А-Яа-я]{1,3}-\d{5,6}/ui
  validates_uniqueness_of :squad,
    :scope => [ :surname, :name, :squad ]

  def to_s
    [ self.surname, self.name ].join ' '
  end

  def score_cache_key
    [ 'user_score', self.id ].join '/'
  end

  def score
    score = 0
    return score if self.new_record?
    Rails.cache.fetch(score_cache_key) do
      self.posts.each do |post|
        score += post.score
      end
      score
    end
  end
end

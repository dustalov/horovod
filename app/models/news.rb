# encoding: utf-8

class News < ActiveRecord::Base
  default_scope order('created_at DESC')

  belongs_to :user

  validates :body, :presence => true, :uniqueness => true

  def to_s
    self.body
  end
end

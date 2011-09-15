# encoding: utf-8

class Text < Post
  validates :body, :presence => true
end

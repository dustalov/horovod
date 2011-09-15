# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    @recent = News.limit(3)
  end
end

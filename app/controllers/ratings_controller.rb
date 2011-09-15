# encoding: utf-8

class RatingsController < ApplicationController
  before_filter :authenticate_user!
  layout 'summary'
  respond_to :html

  def index
    @posts = Post.ratings
    respond_with @ratings
  end
end

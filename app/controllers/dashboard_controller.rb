# encoding: utf-8

class DashboardController < ApplicationController
  respond_to :html, :atom

  def recent
    @posts = Post.paginate(
      :page => params[:page],
      :include => [ :ratings, :user ]
    )
    respond_with @posts
  end

  def thebest
    @posts = Post.ratings.slice(0...15)
    respond_with @posts
  end
end

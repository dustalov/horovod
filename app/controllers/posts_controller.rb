# encoding: utf-8

class PostsController < ApplicationController
  before_filter :authenticate_user!, :except => [ :index, :show ]

  respond_to :html, :xml
  cache_sweeper :rating_sweeper
  cache_sweeper :user_sweeper

  def index
    @posts = Post.all(:include => [ :ratings, :user ])
    respond_with @posts
  end

  def new
    @type = params[:type].to_s
    @post = @type.camelize.constantize.new
    respond_with @post
  end

  def create
    params[:post].merge! :user => current_user
    @type = params[:type].to_s
    @post = @type.camelize.constantize.new(params[:post])
    if @post.save
      flash[:notice] = t('flash.congratulated')
      respond_to do |format|
        format.html { redirect_to root_url }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      end
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @post = Post.find(params[:id])
    respond_with @post
  end

  def edit
    @post = Post.find(params[:id])
    @type = @post.class.name.underscore
  end

  def rate
    @post = Post.find(params[:id])
    @rating = @post.ratings.build(:user => current_user)
    p @rating.errors unless @rating.save
    redirect_to post_path(@post)
  end

  def update
    @post = Post.find(params[:id])
    @type = @post.class.name.underscore
    if @post.update_attributes(params[:post])
      flash[:notice] = 'Post updated.'
    end
    respond_with @post
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = 'Post removed.'
    redirect_to root_url
  end
end

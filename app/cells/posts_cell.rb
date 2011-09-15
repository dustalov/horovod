# encoding: utf-8

class PostsCell < Cell::Rails
  helper RightRails::Helpers::Rails
  helper RightRails::Helpers::Basic
  helper RightRails::Helpers::Forms

  def summary
    @posts = options[:posts]
    @user = options[:user]
    render
  end

  def single
    @post = options[:post]
    @user = options[:user]
    view = @post.class.name.underscore.to_sym
    render :view => view
  end
end

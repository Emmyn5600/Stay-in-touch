class PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Post was not created.'
    end
  end

  private

  def timeline_posts
    @timeline_posts ||= Post.where(user: (current_user.friends.to_a << current_user))

    @timeline_posts = @timeline_posts.sort_by { |post| -post.created_at.to_i }
    @timeline_posts.compact
  end

  def post_params
    params.require(:post).permit(:content)
  end
end

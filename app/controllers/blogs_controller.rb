class BlogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @blogs = current_user.blogs
  end

  def create
    blog = Blog.new(content: blog_params[:content], user: User.first)
    blog.save
    redirect_to root_path
  end

  def show
    @blog = current_user.blogs.find_by(id: params[:id])
  end

  private
  def blog_params
    params.require(:blog).permit(:content)
  end
end

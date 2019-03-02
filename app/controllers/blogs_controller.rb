class BlogsController < ApplicationController
  def create
    blog = Blog.new(content: blog_params[:content], user: User.first)
    blog.save
    redirect_to root_path
  end

  private
  def blog_params
    params.require(:blog).permit(:content)
  end
end

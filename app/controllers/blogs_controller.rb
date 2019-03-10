class BlogsController < ApplicationController
  before_action :authenticate_user!

  def index
    @blogs = current_user.blogs
  end

  def new
    @blog = Blog.new
  end

  def create
    status = if Blog.statuses.include? params[:status]
               params[:status]
             else
               'draft'
             end
    blog = Blog.new(
      content: blog_params[:content], user: current_user, status: status
    )
    blog.save
    if status == 'draft'
      redirect_to edit_blog_path(id: blog.id)
    else
      redirect_to new_blog_path
    end
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def update
  end

  def show
    @blog = current_user.blogs.find_by(id: params[:id])
  end

  private
  def blog_params
    params.require(:blog).permit(:content)
  end
end

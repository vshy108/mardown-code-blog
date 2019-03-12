# frozen_string_literal: true

class BlogsController < ApplicationController
  before_action :authenticate_user!

  def index
    blogs = if params[:search].present?
              blogs = current_user.blogs
              blogs.where(
                'title ilike :q', q: "%#{params[:search]}%"
              ).or(
                blogs.where('tags @> ARRAY[?]::varchar[]', [params[:search]])
              ).order(updated_at: :desc)
            else
              current_user.blogs.order(updated_at: :desc)
            end
    @draft = blogs.draft
    @published = blogs.published
  end

  def new
    @blog = Blog.new
  end

  def create
    status = 'draft'
    status = 'published' if params[:status] == 'Publish'
    @blog = Blog.new(
      content: blog_params[:content],
      title: blog_params[:title],
      user: current_user,
      status: status,
      tags: blog_params[:tags].reject!(&:empty?) # remove empty string
    )
    if @blog.save
      if status == 'draft'
        flash[:success] = 'Success create draft.'
        redirect_to edit_blog_path(id: @blog.id)
      else
        flash[:success] = 'Success publish.'
        redirect_to new_blog_path
      end
    else
      render :new
    end
  end

  def edit
    @blog = Blog.find(params[:id])
    # NOTE: Dirty cheat to let select2 display the current tags
    @tags = @blog.tags.map { |value| [value, value] }
  end

  def update
    @blog = Blog.find(params[:id])
    status = 'draft'
    status = 'published' if params[:status] == 'Publish'
    clone_blog_params = blog_params
    clone_blog_params[:tags] = blog_params[:tags].reject!(&:empty?)
    clone_blog_params[:status] = status
    if @blog.update(clone_blog_params)
      flash[:success] = if status == 'draft'
                          'Success save draft.'
                        else
                          'Success publish.'
                        end
      redirect_to blogs_path
    else
      @tags = @blog.tags.map { |value| [value, value] }
      render :edit
    end
  end

  def show
    @blog = current_user.blogs.find_by(id: params[:id])
  end

  def destroy
    @blog = current_user.blogs.find_by(id: params[:id])
    @blog.destroy
    flash[:success] = 'Success delete.'
    redirect_to blogs_path
  end

  private

  def blog_params
    params.require(:blog).permit(:content, :title, :search, tags: [])
  end
end

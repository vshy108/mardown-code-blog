# frozen_string_literal: true

class BlogsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!

  def index
    blogs = if params[:search].present?
              blogs = current_user.blogs
              sanitize_params = ActiveRecord::Base.send(:sanitize_sql_like, params[:search])
              blogs.where(
                'title ilike :q', q: "%#{sanitize_params}%"
              ).or(
                blogs.where('tags @> ARRAY[?]::varchar[]', [sanitize_params])
              ).or(
                blogs.where('content ilike ?', "%#{sanitize_params}%")
              ).order(updated_at: :desc)
            else
              current_user.blogs.order(updated_at: :desc)
            end
    @pagy_draft, @draft = pagy(blogs.draft)
    @pagy_published, @published = pagy(blogs.published, page_param: :page_published)
  end

  def new
    @blog = Blog.new
  end

  def create
    status = 'draft'
    status = 'published' if params[:status] == 'Publish'
    @blog = current_user.blogs.new(
      content: blog_params[:content],
      title: blog_params[:title],
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
    @blog = current_user.blogs.find(params[:id])
    # NOTE: Dirty cheat to let select2 display the current tags
    @tags = @blog.tags.map { |value| [value, value] }
  end

  def update
    @blog = current_user.blogs.find(params[:id])
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
    @blog = Blog.find_by(id: params[:id])
    @is_my_blog = @blog.user == current_user
  end

  def destroy
    @blog = current_user.blogs.find_by(id: params[:id])
    @blog.destroy
    flash[:success] = 'Success delete.'
    redirect_to blogs_path
  end

  def others_blogs
    others = Blog.where.not(user: current_user).published.includes(:user)
    @pagy, @others = pagy(others)
  end

  private

  def blog_params
    params.require(:blog).permit(:content, :title, :search, tags: [])
  end
end

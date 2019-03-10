json.extract! blog, :id, :created_at, :updated_at, :content, :title
json.url blog_url(blog, format: :json)

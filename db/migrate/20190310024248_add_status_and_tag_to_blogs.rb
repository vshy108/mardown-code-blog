class AddStatusAndTagToBlogs < ActiveRecord::Migration[5.2]
  def change
    add_column :blogs, :status, :string
    add_column :blogs, :tags, :string, array: true, default: '{}'

    add_index  :blogs, :tags, using: 'gin'
  end
end

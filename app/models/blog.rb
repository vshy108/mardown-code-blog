class Blog < ApplicationRecord
  belongs_to :user

  enum status: { draft: 'draft', published: 'published' }
end

class Blog < ApplicationRecord
  belongs_to :user
  validates :title, presence: true

  enum status: { draft: 'draft', published: 'published' }
end

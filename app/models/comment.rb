class Comment < ApplicationRecord
  # comment belongs to "virtual" model of Commentable
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }
end

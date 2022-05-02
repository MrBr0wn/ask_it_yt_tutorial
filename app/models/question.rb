class Question < ApplicationRecord
  include Commentable

  has_many :answers, dependent: :destroy

  # relationship Questions to User
  belongs_to :user

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }
end

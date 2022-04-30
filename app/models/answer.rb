class Answer < ApplicationRecord
  belongs_to :question

  # relationship Answers to User
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
end

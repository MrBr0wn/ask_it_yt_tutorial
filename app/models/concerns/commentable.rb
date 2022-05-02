module Commentable
  extend ActiveSupport::Concern

  included do
    # this module give opportunity to have comment for any model
    has_many :comments, as: :commentable, dependent: :destroy
  end
end

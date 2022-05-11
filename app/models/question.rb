class Question < ApplicationRecord
  include Commentable

  # relationship Question to Answers
  has_many :answers, dependent: :destroy

  # relationship Questions to Tags through QuestionTags
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # relationship Questions to User
  belongs_to :user

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # Различия между scope и методом класса все же есть, хоть и незначительные
  # на первый взгляд. Это то что scope всегда возвращает relation,
  # а класс может вернуть nil, поэтому для метода класса приходится делать
  # лишние проверки или использовать & (либо rescue nil) в результатах.
  # Насколько я понял scope удобный, наглядный  инструмент,
  # но реализация скрыта под капотом что может привести к неожиданным проблемам,
  # при использовании со сложной логикой. ПОэтому, как советуют,
  # при простой логике - scope, при сложной - метод класса.
  # Хотя недавно узнал что scope тоже может содержать сложную логику,
  # поскольку могут быть расширяемыми модулями scope.extended
  # https://www.youtube.com/watch?v=hKJKTcc7P9g&list=PLWlFXymvoaJ_IY53-NQKwLCkR-KkZ_44-&index=16&ab_channel=IlyaKrukowski

  # equal as "def self.all_by_tags... end"
  # return Questions by tags or all Questions
  scope :all_by_tags, lambda { |tag_ids|
    # for optimizations by Bullet requirements
    questions = includes(:user)

    # if tag_ids exist, then select all Questions
    # with 'tag_ids' tags
    questions = if tag_ids
                  questions.joins(:tags).where(tags: tag_ids).preload(:tags)
                else
                  questions.includes(:question_tags, :tags)
                end

    # else just return all Questions
    questions.order(created_at: :desc)
  }
end

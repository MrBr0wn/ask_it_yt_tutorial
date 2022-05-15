class RemoveDefaultUserIdFromQuestionsAnswers < ActiveRecord::Migration[7.0]
  def up
    change_column_default :questions, :user_id, from: 1, to: nil
    change_column_default :answers, :user_id, from: 1, to: nil
  end

  def down
    change_column_default :questions, :user_id, from: nil, to: 1
    change_column_default :answers, :user_id, from: nil, to: 1
  end
end

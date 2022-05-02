class CommentsController < ApplicationController
  include QuestionsAnswers

  # setting reference to concrete model from params.
  before_action :set_commentable!

  # setting Question
  before_action :set_question

  def create
    @comment = @commentable.comments.build(comment_params)

    # saving and redirect to Question
    # else rerender question#show
    if @comment.save
      flash[:success] = t('.success')
      # e.g. as alternative cases: question_path(@commentable) or question_path(@question.answers)
      # or redirect_to @commentable
      redirect_to question_path(@question)
    else
      @comment = @comment.decorate
      load_question_answers(do_render: true)
    end
  end

  def destroy
    # find comment for concrete @commentable(Question || Answer)
    comment = @commentable.comments.find(params[:id])
    # destroy it
    comment.destroy
    flash[:success] = t('.success')
    # redirect to comment question
    redirect_to question_path(@question), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(user: current_user)
  end

  def set_commentable!
    # finding attr [question_id || answer_id] inside params
    klass = [Question, Answer].detect { |c| params["#{c.name.underscore}_id"] }

    # generate exception if Question or Answer not found in params
    raise ActiveRecord::RecordNotFound if klass.blank?

    # klass equal Question.find or Answer.find
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  # if @commentable is not Question, then it is Answer
  # else (it's Answer) getting cocrete comment
  def set_question
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end
end

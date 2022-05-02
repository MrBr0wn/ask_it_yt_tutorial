class QuestionsController < ApplicationController
  include QuestionsAnswers
  before_action :set_question!, only: %i[show edit update destroy]

  def index
    @pagy, @questions = pagy(Question.includes(:user).order(created_at: :desc))
    @questions = @questions.decorate
  end

  def show
    load_question_answers
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = 'Question created!'
      redirect_to questions_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    # i18n lazy-translate
    flash[:success] = t('.success')
    redirect_to questions_path, status: :see_other
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question!
    @question = Question.find(params[:id])
  end
end

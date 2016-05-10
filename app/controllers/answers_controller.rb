class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :find_question, only: [:show, :create, :new, :edit, :update, :destroy]
  before_filter :require_permission, only: [:new, :create]

  def new
    @answer= @question.answers.new
  end

  def create
    @answer= @question.answers.new(post_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, notice: 'Answer was successfully created.' }
        format.json { render :show, status: :created, location: @question}
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @answer.update(post_params)
      redirect_to @question, notice: 'Answer was successfully updated.'
    else
      render :edit
    end
  end

  def edit

  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @question, notice: 'Answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def index
    @answers = Answer.all
  end

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_post
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:answer).permit(:answer)
  end

  def require_permission
    unless current_user.answers.where(question_id: @question).first.blank?
      respond_to do |format|
        format.html { redirect_to @question,notice: 'You are not allowed to create the answer' }
      end
    end
  end

end

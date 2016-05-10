class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :require_permission, only: [:edit, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(post_params)
    #@question.user = current_user

    respond_to do |format|
      if @question.save
        format.html { redirect_to questions_path, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: questions_path}
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end
  def update
    if @question.update(post_params)
      redirect_to questions_path, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
#end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:question).permit(:quesbox)
    end

    def require_permission
    if current_user != @question.user
      respond_to do |format|
      format.html { redirect_to questions_path,notice: 'You are not allowed to access this questions' }
    end
      end
    end


end

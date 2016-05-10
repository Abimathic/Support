class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :find_question, only: [:show, :create, :edit, :update, :new, :destroy]



  def new
    commentable= find_commentable
    @commentable= commentable.comments.new
  end

  def index
    @comments = Comment.all
  end

  def create
    commentable= find_commentable
    @commentable= commentable.comments.new(post_params)
    @commentable.user = current_user
    #@question.user = current_user

    respond_to do |format|
    if @commentable.save
      if(@commentable.commentable_type == "Question")
        #redirect_to question_path, notice: "The interaction has been successfully created"
        format.html { redirect_to @question, notice: 'Comment was successfully created.' }

      else
        #redirect_to question_answer_path, notice: "The interaction has been successfully created"
        format.html { redirect_to @question, notice: 'Comment Answer was successfully created.' }
      end
    else
      format.html { render :new }
    end
  end

  end

  def update
    @commentable.update(post_params)
    if (@commentable.commentable_type == "Question")
      redirect_to @question, notice: 'Comment was successfully updated.'
    else
      redirect_to @question, notice: 'Comment Answer was successfully updated.'
    end
  end

  def edit
  end

  def destroy
    @commentable.destroy
    if (@commentable.commentable_type == "Question")
      redirect_to @question, notice: 'Comment was successfully destroyed.'
    else
      redirect_to @question, notice: 'Comment Answer was successfully destroyed.'
    end
  end

  def show
  end
  private
    # Use callbacks to share common setup or constraints between actions.

  def find_commentable
    if params[:question_id] && params[:answer_id]
      klass = "answers"
      id = params[:answer_id]
    else
      klass = "questions"
       id = params[:question_id]
  end
    return "#{klass}".singularize.classify.constantize.find(id)
  end
  #def find_commentable
    #if params[:question_id]
      #id = params[:question_id]
      #Question.find(params[:question_id])
    #else
      #id = params[:id]
      #Answer.find(params[:id])
    #end
  #end

  #def context_url(find_commentable)
    #if Question === find_commentable
      #question_path(find_commentable)
    #else
      #question_answer_path(find_commentable)
    #end
  #end


  def set_post
    @commentable = Comment.find(params[:id])
  end

  #def set_answer
      #@answer = Answer.find(params[:answer_id])
  #end


  def find_question
    @question = Question.find(params[:question_id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:comment).permit(:comment)
  end




end

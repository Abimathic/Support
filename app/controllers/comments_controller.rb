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
    #@commentable.update(post_params)

    commentable = find_commentable
    if @commentable.check_history?
     params = post_params.merge(history_id: @commentable.id)
     @commentable = commentable.comments.new(params)
     @commentable.user = current_user
     @commentable.save
   else
     params = post_params.merge(history_id: @commentable.history_id)
     @commentable = commentable.comments.new(params)
     @commentable.user = current_user
     @commentable.save
    end

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

  def comment_history
   @comment_history = Comment.list_comment_history(params[:history_id], params[:dont_show])
   # Comment.where("history_id IS NULL AND id =? XOR history_id =? AND id != ?", 143,143, 143).order("id DESC").first
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

  def set_post
    @commentable = Comment.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:comment).permit(:comment)
  end

end

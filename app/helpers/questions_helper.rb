module QuestionsHelper
  def ques_error_messages
    return '' if @question.errors.empty?
    flash.now[:error] = @question.errors.full_messages.map { |msg| "#{msg}." }[0]
  end
end


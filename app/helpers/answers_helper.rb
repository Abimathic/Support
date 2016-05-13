module AnswersHelper
  def ans_error_messages
    return '' if @answer.errors.empty?
    flash.now[:error] = @answer.errors.full_messages.map { |msg| "#{msg}." }[0]
  end
end

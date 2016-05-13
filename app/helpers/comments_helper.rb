module CommentsHelper
  def com_error_messages
    return '' if @commentable.errors.empty?
    flash.now[:error] = @commentable.errors.full_messages.map { |msg| "#{msg}." }[0]
  end
end

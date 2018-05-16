# frozen_string_literal: true

class ChallengePostCommentMailer < ApplicationMailer
  def notify_post_creator
    @comment = params[:comment]
    @post = @comment.challenge_post
    @creator = @post.creator

    mail to: @creator.email, subject: "[HC Challenge] Re: #{@post.name}"
  end
end

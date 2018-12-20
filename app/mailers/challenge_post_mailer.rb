# frozen_string_literal: true

class ChallengePostMailer < ApplicationMailer
  def notify_creator
    @post = params[:post]
    @creator = @post.creator

    mail to: @creator.email, subject: '[HC Challenge] Next steps'
  end
end

# frozen_string_literal: true

module V1
  class ChallengePostCommentsController < ApiController
    USER_AUTH = { except: [:index] }.freeze
    include UserAuth

    def index
      render_success ChallengePost
        .find(params[:post_id])
        .comments
        .where(parent: nil)
    end

    def create
      comment = ChallengePostComment.new(comment_params)

      if comment.save
        render_success comment, 201
      else
        render_field_errors comment.errors
      end
    end

    private

    def comment_params
      params.permit(
        :user_id,
        :challenge_post_id,
        :parent_id,
        :body
      )
    end
  end
end

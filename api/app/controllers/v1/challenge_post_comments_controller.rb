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
      post = ChallengePost.find(params[:post_id])

      comment = ChallengePostComment.new(comment_params)
      comment.user = current_user
      comment.challenge_post = post

      if comment.save
        render_success comment, 201
      else
        render_field_errors comment.errors
      end
    end

    def update
      comment = ChallengePostComment.find(params[:id])
      authorize comment

      if comment.update_attributes(comment_params)
        render_success comment
      else
        render_field_errors comment.errors
      end
    end

    def destroy
      comment = ChallengePostComment.find(params[:id])
      authorize comment

      comment.destroy

      render_success comment
    end

    private

    def comment_params
      params.permit(
        :parent_id,
        :body
      )
    end
  end
end

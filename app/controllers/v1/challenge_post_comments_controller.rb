# frozen_string_literal: true

module V1
  class ChallengePostCommentsController < ApiController
    USER_AUTH = { except: [:index] }.freeze
    include UserAuth

    def index
      authenticate_user if request.headers.include? 'Authorization'
      return if performed? # make sure we don't double render if auth failed

      post = ChallengePost.find(params[:post_id])

      comments = if current_user&.shadow_banned?
                   post.comments.select do |c|
                     c.user.shadow_banned? == false || c.user == current_user
                   end
                 else
                   post.comments.select do |c|
                     c.user.shadow_banned? == false
                   end
                 end

      render_success comments
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

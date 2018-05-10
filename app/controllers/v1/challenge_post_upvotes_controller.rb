# frozen_string_literal: true

module V1
  class ChallengePostUpvotesController < ApiController
    include UserAuth

    def create
      upvote = ChallengePostUpvote.new(
        user: current_user,
        challenge_post: ChallengePost.find(params[:post_id])
      )

      if upvote.save
        render_success upvote, 201
      else
        render_field_errors upvote.errors
      end
    end

    def destroy
      upvote = ChallengePostUpvote.find(params[:id])
      authorize upvote

      upvote.destroy

      render_success upvote
    end
  end
end

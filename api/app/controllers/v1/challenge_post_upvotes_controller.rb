# frozen_string_literal: true

module V1
  class ChallengePostUpvotesController < ApiController
    include UserAuth

    def create
      upvote = ChallengePostUpvote.create(
        user: current_user,
        challenge_post: ChallengePost.find(params[:post_id])
      )

      render_success upvote, 201
    end

    def destroy
      upvote = ChallengePostUpvote.find(params[:id])
      authorize upvote

      upvote.destroy

      render_success upvote
    end
  end
end

# frozen_string_literal: true

module V1
  class ChallengePostClicksController < ApiController
    USER_AUTH = { only: [] }.freeze # we want to manually make the auth call
    include UserAuth

    def create
      authenticate_user if request.headers.include? 'Authorization'

      post = ChallengePost.find(params[:post_id])

      ChallengePostClick.create(
        challenge_post: post,
        user: current_user,
        ip_address: request.ip,
        user_agent: request.user_agent
      )

      redirect_to post.url
    end
  end
end

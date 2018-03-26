# frozen_string_literal: true

module V1
  class ChallengePostsController < ApiController
    USER_AUTH = { except: %i[index] }.freeze
    include UserAuth

    def index
      challenge = Challenge.find(params[:challenge_id])
      render_success challenge.posts
    end

    def create
      post = ChallengePost.new(post_params)
      post.challenge = Challenge.find(params[:challenge_id])
      post.creator = current_user

      if post.save
        render_success post, 201
      else
        render_field_errors post.errors
      end
    end

    private

    def post_params
      params.permit(:name, :url, :description)
    end
  end
end

class V1::LeadersController < ApplicationController
  def intake
    leader = Leader.new(leader_params)

    if leader.save
      render json: leader, status: 201
    else
      render json: { errors: leader.errors }, status: 422
    end
  end

  protected

  def leader_params
    params.permit(
      :name, :email, :gender, :year, :phone_number, :slack_username,
      :github_username, :twitter_username, :address
    )
  end
end

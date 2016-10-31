class V1::LeadersController < ApplicationController
  def intake
    leader = Leader.new(leader_params)
    club = Club.find_by(id: params[:club_id])

    if leader.save && club != nil
      leader.clubs << club
      render json: leader, status: 201
    else
      errors = leader.errors
      errors.add(:club_id, "doesn't exist") if club == nil
      render json: { errors: errors }, status: 422
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

class V1::LeadersController < ApplicationController
  def intake
    if params[:club_id] == nil
      return render json: { errors: { club_id: ["can't be blank"] } }, status: 422
    end

    leader = Leader.new(leader_params.merge(club_ids: [ params[:club_id] ]))

    if leader.save
      Letter.create!(
        name: leader.name,
        letter_type: "9002", # This is the type for club leaders
        what_to_send: "9005", # This is the type for welcome letter + 3oz of stickers
        address: leader.address
      )

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

# frozen_string_literal: true

class LeaderSerializer < ActiveModel::Serializer
  attributes :name, :email, :gender, :year, :phone_number, :slack_username,
             :github_username, :twitter_username, :address, :latitude,
             :longitude

  has_many :clubs
end

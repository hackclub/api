# frozen_string_literal: true

class LeadershipPositionInviteSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :accepted_at,
             :rejected_at

  belongs_to :sender
  belongs_to :user
  belongs_to :new_club

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :username
  end

  class NewClubSerializer < ActiveModel::Serializer
    attributes :id, :high_school_name
  end
end

# frozen_string_literal: true

class WorkshopProjectClickSerializer < ActiveModel::Serializer
  attributes :id, :ip_address, :referrer, :user_agent, :type_of
  has_one :workshop_project
  has_one :user
end

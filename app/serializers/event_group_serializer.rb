# frozen_string_literal: true

class EventGroupSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :name,
             :location

  has_one :logo
  has_one :banner
end

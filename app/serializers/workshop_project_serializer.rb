# frozen_string_literal: true

class WorkshopProjectSerializer < ActiveModel::Serializer
  attributes :id,
             :created_at,
             :updated_at,
             :live_url,
             :code_url

  has_one :screenshot
end

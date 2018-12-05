# frozen_string_literal: true

class WorkshopProjectSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :created_at,
             :updated_at,
             :live_url,
             :code_url,
             :destination_live_url,
             :destination_code_url,
             :click_count

  has_one :screenshot
  has_one :user
  has_many :workshop_project_clicks

  def click_count
    object.click_count
  end

  def code_url
    v1_project_redirect_url(project_id: object.id, type_of: 'code')
  end

  def live_url
    v1_project_redirect_url(project_id: object.id, type_of: 'live')
  end

  def destination_code_url
    object.code_url
  end

  def destination_live_url
    object.live_url
  end

  class UserSerializer < ActiveModel::Serializer
    attributes :username
  end
end

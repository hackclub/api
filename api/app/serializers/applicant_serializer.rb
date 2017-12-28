class ApplicantSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :email
end

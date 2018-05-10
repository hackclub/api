# frozen_string_literal: true

FactoryBot.define do
  factory :athul_club do
    club { build(:club) }
    leader { build(:leader_with_address) }
  end
end

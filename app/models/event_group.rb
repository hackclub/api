# frozen_string_literal: true

# EventGroups are grouped collections of events, usually for a distributed
# event across multiple locations that can be thought of as many distinct
# events, like MLH's Local Hack Day or CodeDay.
class EventGroup < ApplicationRecord
  validates :name, :location, presence: true

  has_one :logo, as: :attachable, class_name: 'EventLogo'
  has_one :banner, as: :attachable, class_name: 'EventBanner'
end

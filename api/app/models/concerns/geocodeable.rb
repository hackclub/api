module Geocodeable
  extend ActiveSupport::Concern

  module ClassMethods
    attr_reader :geocodeable_address_attr,
                :geocodeable_attr_mappings

    private

    # rubocop:disable Metrics/AbcSize
    def geocode_attrs(attrs = {})
      address = @geocodeable_address_attr = attrs[:address]
      attr_mappings = @geocodeable_attr_mappings = {
        latitude: attrs[:latitude],
        longitude: attrs[:longitude],
        address: attrs[:res_address],
        city: attrs[:city],
        state: attrs[:state],
        state_code: attrs[:state_code],
        postal_code: attrs[:postal_code],
        country: attrs[:country],
        country_code: attrs[:country_code]
      }

      geocoded_by address do |obj, results|
        geo = results.first

        if geo
          attr_mappings.each do |k, v|
            geo_val = geo.send(k)

            obj.send("#{v}=", geo_val)
          end
        end
      end

      before_validation :geocode, if: (lambda do |obj|
        obj.send(address).present? && obj.send("#{address}_changed?")
      end)
    end
    # rubocop:enable Metrics/AbcSize
  end
end

require 'rails_helper'

RSpec.shared_examples 'Geocodeable' do
  let(:model) { described_class }

  let(:address_attr) { model.geocodeable_address_attr }
  let(:latitude_attr) { model.geocodeable_lat_attr }
  let(:longitude_attr) { model.geocodeable_lng_attr }

  def address(obj, attr = address_attr)
    obj.send(attr)
  end

  def set_address(obj, new_address, attr = address_attr)
    obj.send("#{attr}=", new_address)
  end

  def latitude(obj, attr = latitude_attr)
    obj.send(attr)
  end

  def longitude(obj, attr = longitude_attr)
    obj.send(attr)
  end

  describe 'geocoding' do
    let!(:obj) { create(described_class.to_s.underscore.to_sym) }
    let!(:original_address) { address(obj) }

    before do
      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            'latitude' => 42.42,
            'longitude' => -42.42
          }
        ]
      )
    end

    after { Geocoder::Lookup::Test.reset }

    context 'when address changes' do
      it 'saves the new latitude' do
        expect do
          set_address(obj, 'NEW ADDRESS')
          obj.save
        end.to change { latitude(obj.reload) }
      end

      it 'saves the new longitude' do
        expect do
          set_address(obj, 'NEW ADDRESS')
          obj.save
        end.to change { longitude(obj.reload) }
      end
    end

    context "when address doesn't change" do
      it "doesn't geocode" do
        expect(obj).to_not receive(:geocode)
        obj.save
      end
    end
  end
end

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => Faker::Address.latitude,
      'longitude'    => Faker::Address.longitude,
      'address'      => HCFaker::Address.full_address,
      'state'        => Faker::Address.state,
      'state_code'   => Faker::Address.state_abbr,
      'country'      => Faker::Address.country,
      'country_code' => Faker::Address.country_code
    }
  ]
)

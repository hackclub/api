require 'rails_helper'

RSpec.describe TechDomainRedemption, type: :model do
  it { should have_db_column :name }
  it { should have_db_column :email }
  it { should have_db_column :requested_domain }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :requested_domain }

  it 'ensures that only valid emails are accepted' do
    redemption = build(:tech_domain_redemption)
    redemption.email = 'bad_email'

    expect(redemption).to be_invalid
    expect(redemption.errors[:email]).to include('is not an email')
  end
end

# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TechDomainRedemption, type: :model do
  it { should have_db_column :name }
  it { should have_db_column :email }
  it { should have_db_column :requested_domain }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :requested_domain }

  it { should validate_email_format_of :email }
end

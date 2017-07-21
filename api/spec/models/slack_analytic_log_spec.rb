require 'rails_helper'

RSpec.describe SlackAnalyticLog, type: :model do
  it { should have_db_column :data }

  it { should validate_presence_of :data }
end

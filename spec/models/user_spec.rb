require 'rails_helper'

describe User, type: :model do
  it { is_expected.to respond_to :reviewed_restaurants }
end

require 'spec_helper'

describe Restaurant, type: :model do
  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).to(have(1).error_on(:name))
    expect(restaurant).not_to(be_valid)
  end

  it 'is not valid unless is has a unique name' do
    User.create(email: 'test@test.com', password: '123456')
    Restaurant.create(name: "Moe's Tavern", user_id: User.first.id)
    restaurant = Restaurant.new(name: "Moe's Tavern", user_id: User.first.id)
    expect(restaurant).to(have(1).error_on(:name))
  end

end

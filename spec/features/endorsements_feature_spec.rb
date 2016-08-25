require 'rails_helper'

feature 'endorsing reviews' do
  before do
    User.create(email: "test@test.com", password: "123456")
    kfc = Restaurant.create(name: "KFC", user_id: User.first.id)
    kfc.reviews.create(rating: 3, thoughts: "It was an abomination", user_id: User.first.id)
  end

  scenario 'a user can endorse a review, which increments the review endorsement count', js: true do
    sign_up
    click_link("Endorse Review")
    expect(page).to(have_content("1 endorsement"))
  end

end

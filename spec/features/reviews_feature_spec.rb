require 'rails_helper'

feature 'reviewing' do
  before do
    User.create(email: "test@test.com", password: "123456")
    Restaurant.create(name: 'KFC', user_id: User.first.id)

  end

  scenario 'allows users to leave a review using a form' do
    sign_up
    click_link 'Review KFC'
    fill_in "Thoughts", with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end



  scenario 'displays an average rating for all reviews' do
    sign_up("test1@test.com", 123456)
    leave_review('So so', 3)
    click_link "Sign out"
    sign_up("test2@test.com", 123456)
    leave_review('Great', 5)
    expect(page).to(have_content('Average Rating: 4'))
  end

end

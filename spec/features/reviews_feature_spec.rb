require 'rails_helper'

feature 'reviewing' do
  before do
    User.create(email: "test@test.com", password: "123456")
    Restaurant.create(name: 'KFC', user_id: User.first.id)
    sign_up
  end

  scenario 'allows users to leave a review using a form' do
    click_link 'Review KFC'
    fill_in "Thoughts", with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

end

require 'rails_helper'

feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to(have_content("No restaurants yet"))
      expect(page).to(have_link("Add a restaurant"))
    end
  end

  context 'restaurants have been added' do
    before do
      User.create(email: "test@test.com", password: "123456")
      Restaurant.create(name: 'KFC', description: "Terrible, never go here", user_id: User.first.id)
    end
    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to(have_content("KFC"))
      expect(page).not_to(have_content("No restaurants yet"))
    end

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to(have_content('KFC'))
      expect(page).to(have_content('Terrible, never go here'))
      expect(current_path).to(eq("/restaurants/#{Restaurant.last.id}"))
    end

  end

  context "user is not logged in" do

    before do
      User.create(email: "test@test.com", password: "123456")
      Restaurant.create(name: 'KFC', description: "Terrible, never go here", user_id: User.first.id)
    end

    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to(have_content('Log in'))
      end
    end

    context 'editing restaurants' do
      scenario 'do not let a user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        expect(page).to(have_content('Log in'))
      end
    end

    context 'deleting restaurants' do
      scenario 'user cannot delete a restaurant when not logged in' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).to(have_content('Log in'))
      end
    end

  end


  context "user is logged in" do

    before do
      sign_up
    end

    context 'creating restaurants' do
      scenario 'prompts user to fill out a form, then displays the new restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: 'Terrible, never go here'
        click_button 'Create Restaurant'
        expect(page).to(have_content('KFC'))
        expect(current_path).to(eq('/restaurants'))
      end

      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit '/restaurants'
          click_link 'Add a restaurant'
          fill_in 'Name', with: 'kf'
          click_button 'Create Restaurant'
          expect(page).not_to(have_css('h2', text: 'kf'))
          expect(page).to(have_content('error'))
        end
      end
    end

    context 'editing restaurants' do

      context 'editing a restaurant the user has created' do
        before do
        click_link('Add a restaurant')
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: "Amazing, love this place"
        click_button 'Create Restaurant'
        end

        scenario 'let a user edit a restaurant' do
          visit '/restaurants'
          click_link 'Edit KFC'
          fill_in 'Name', with: 'Kentucky Fried Chicken'
          fill_in 'Description', with: 'Awful, just terrible'
          click_button 'Update Restaurant'
          expect(page).to(have_content('Kentucky Fried Chicken'))
          expect(page).not_to(have_content('KFC'))
          expect(current_path).to(eq('/restaurants'))
        end
      end

      context 'editing a restaurant not created by the user' do
        before do
          User.create(email: "test@test.com", password: "123456")
          Restaurant.create(name: 'KFC', description: "Terrible, never go here", user_id: User.first.id)
        end

        scenario 'a user cannot edit a restaurant they have not created' do
          visit '/restaurants'
          expect(page).not_to(have_link('Edit KFC'))
        end
      end

    end

    context 'deleting restaurants' do

      context 'deleting a restaurant the user has created' do
        before do
        click_link('Add a restaurant')
        fill_in 'Name', with: 'KFC'
        fill_in 'Description', with: "Amazing, love this place"
        click_button 'Create Restaurant'
        end

        scenario 'let a user delete a restaurant' do
          visit '/restaurants'
          click_link 'Delete KFC'
          expect(page).not_to(have_content('KFC'))
          expect(page).to(have_content('Restaurant deleted successfully'))
        end

      end

      context 'a user cannot delete a restaurant they did not create' do
        before do
          User.create(email: "test@test.com", password: "123456")
          Restaurant.create(name: 'KFC', description: "Terrible, never go here", user_id: User.first.id)
        end

        scenario 'removes a restaurant when a user clicks delete' do
          visit '/restaurants'
          expect(page).not_to(have_link('Delete KFC'))
        end

      end

    end

  end



end

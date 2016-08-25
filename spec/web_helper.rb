def sign_up(email = "0test@test.com", password = "123456" )
  visit("/")
  click_link("Sign up")
  fill_in("Email", with: email)
  fill_in("Password", with: password)
  fill_in("Password confirmation", with: password)
  click_button("Sign up")
end

def leave_review(thoughts, rating)
  click_link 'Review KFC'
  fill_in "Thoughts", with: thoughts
  select rating, from: 'Rating'
  click_button('Leave Review')
end

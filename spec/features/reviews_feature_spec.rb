require 'rails_helper'

feature 'reviewing' do
  
  before { Restaurant.create name: 'KFC' }

  def sign_up(email = "test@test.com")
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: email)
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  def leave_review(thoughts, rating)
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'allows users to leave a review using a form' do
    sign_up
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'allows users to delete a review' do
    sign_up
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete Review'
    expect(page).not_to have_content('so so')
  end

  scenario 'displays an average rating for all reviews' do
    sign_up
    leave_review('So so', '3')
    click_link('Sign out')
    sign_up("test2@test.com")
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

  scenario 'displays an average rating for all reviews' do
    sign_up
    leave_review('so so', '3')
    click_link('Sign out')
    sign_up("test2@test.com")
    leave_review('Great!', '5')
    expect(page).to have_content('Average rating ★★★★☆')
  end
end

require 'rails_helper'

context "user not signed in and on the homepage" do
  it "should see a 'sign in' link and a 'sign up' link" do
    visit('/')
    expect(page).to have_link('Sign in')
    expect(page).to have_link('Sign up')
  end

  it "should not see 'sign out' link" do
    visit('/')
    expect(page).not_to have_link('Sign out')
  end

  it "should not be able to make a restaurant" do
    visit('/')
    click_link('Add a restaurant')
    expect(current_path).to eq('/users/sign_in')
    expect(page).to have_content('Log in')
  end
end

context "user signed in on the homepage" do
  def sign_up
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  it "should see 'sign out' link" do
    sign_up
    visit('/')
    expect(page).to have_link('Sign out')
  end

  it "should not see a 'sign in' link and a 'sign up' link" do
    sign_up
    visit('/')
    expect(page).not_to have_link('Sign in')
    expect(page).not_to have_link('Sign up')
  end

  it "can't delete restaurants other than those they created" do
    sign_up
    Restaurant.create name: 'KFC'
    visit('/')
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'Burgers'
    click_button 'Create Restaurant'
    click_link 'Delete Burgers'
    expect(page).not_to have_content 'Burgers'
    click_link 'Delete KFC'
    expect(page).to have_content("You can only delete stuff you made")
  end

  it "can't edit restaurants other than those they created" do
    sign_up
    Restaurant.create name: 'KFC'
    visit('/')
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'Burgers'
    click_button 'Create Restaurant'
    click_link 'Edit Burgers'
    fill_in 'Name', with: 'Burger King'
    click_button 'Update Restaurant'
    expect(page).to have_content 'Burger King'
    click_link 'Edit KFC'
    expect(page).to have_content("You can only edit stuff you made")
  end

  it "can only leave one review per restaurant" do
    sign_up
    Restaurant.create name: 'KFC'
    visit('/')
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'Meh'
    select '2', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'Meh'
    select '2', from: 'Rating'
    click_button 'Leave Review'
    expect(page).to have_content('You have already reviewed this restaurant')
  end

  it "can only delete it's own reviews" do
    sign_up
    Restaurant.create name: 'KFC'
    visit('/')
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'Meh'
    select '2', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    click_link('Sign up')
    fill_in('Email', with: 'george@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    click_link 'Delete Review'
    expect(page).to have_content('You can only delete reviews you have made')
  end
end

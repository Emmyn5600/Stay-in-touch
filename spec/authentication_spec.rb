require 'rails_helper'

RSpec.describe 'Siging Up', type: :feature do
  scenario 'Sign up with valid inputs' do
    visit new_user_registration_path
    fill_in 'Name', with: 'emmy'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    sleep(3)
    visit root_path
    expect(page).to have_content('emmy')
  end

  scenario 'Sign up with invalid inputs' do
    visit new_user_registration_path
    fill_in 'Name', with: 'emmy'
    fill_in 'Email', with: 'test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '111000'
    click_on 'Sign up'
    sleep(3)
    visit root_path
    expect(page).to_not have_content('emmy')
  end
end

RSpec.describe 'Loggin In', type: :feature do
  let(:user) { User.create(name: 'emmy', email: 'test@test.com', password: '12345678') }
  scenario 'Log in with valid inputs' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
    sleep(3)
    expect(page).to have_content('emmy')
  end

  scenario 'Log in with invalid inputs' do
    visit new_user_session_path
    fill_in 'Email', with: 'cool@gmail.com'
    fill_in 'Password', with: user.password
    click_on 'Log in'
    sleep(3)
    expect(page).to_not have_content('cool')
  end
end

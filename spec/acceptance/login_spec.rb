require 'rails_helper'
require 'capybara/rails'
require 'support/pages/home'
require 'support/with_user'

RSpec.describe 'login/logout/signup', type: :feature do
  with_auth_mock

  let(:page) { Pages::Home.new }
  before { page.open }

  it 'signs up' do
    page.sign_up
    expect(page).to have_logged_in('John McFoo')
    expect(page).to have_signup_message
  end

  it 'logs out' do
    page.sign_up
    page.logout
    expect(page).to be_logged_out
  end

  it 'logs in' do
    page.sign_up
    page.logout
    page.login
    expect(page).to have_logged_in('John McFoo')
    expect(page).to have_login_message
  end
end

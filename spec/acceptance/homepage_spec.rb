require 'rails_helper'
require 'capybara/rails'
require 'support/pages/home'

RSpec.describe 'homepage', type: :feature do
  it 'shows the application name' do
    page = Pages::Home.new
    page.open
    expect(page).to have_app_name
  end
end

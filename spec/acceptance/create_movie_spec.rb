require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_new'
require 'support/with_user'

RSpec.describe 'submit movie', type: :feature do

  let(:page) { Pages::MovieNew.new }

  context 'when logged in' do
    with_logged_in_user
    before { page.open }

    it 'succeeds' do
      page.submit(
        title:       'Bridge over river Kwai',
        description: 'Boom!',
        date:        '1957-10-02')
      expect(page).to have_movie_creation_message
    end

    it 'fails without a date' do
      page.submit(
        title:       'Bridge over river Kwai',
        description: 'Boom!',
        date:        nil)
      expect(page).to have_error_message
    end
  end
end

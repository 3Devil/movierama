require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'filter movie list', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid:  'null|12345',
      name: 'Bob'
    )
    @m_empire = Movie.create(
      title:        'Empire strikes back',
      description:  "Who's scruffy-looking?",
      date:         '1980-05-21',
      user:         author
    )
    @m_turtles = Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  "Technically, we're turtles.",
      date:         '2014-10-17',
      user:         author
    )
    @titles = [@m_empire, @m_turtles].map(&:title)
  end

  before { page.open }

  context 'when logged out' do
    it 'cannot filter all' do
      page.open
      expect {
        page.button_click('All movies')
      }.to raise_error(Capybara::ElementNotFound)
    end

    it 'cannot filter likes' do
      page.open
      expect {
        page.button_click('Liked movies')
      }.to raise_error(Capybara::ElementNotFound)
    end

    it 'cannot filter hates' do
      page.open
      expect {
        page.button_click('Hated movies')
      }.to raise_error(Capybara::ElementNotFound)
    end

  end

  context 'when logged in' do
    with_logged_in_user

    before do
      page.like(@m_empire.title)
      page.hate(@m_turtles.title)
    end

    it 'shows all movies' do
      page.button_click('Liked movies')
      page.button_click('All movies')
      expect(page.movie_titles).to eq(@titles)
    end

    it 'can filter by liked movies' do
      page.button_click('Liked movies')
      expect(page.movie_titles).to eq([@m_empire.title])
    end

    it 'can filter by hated movies' do
      page.button_click('Hated movies')
      expect(page.movie_titles).to eq([@m_turtles.title])
    end
  end
end

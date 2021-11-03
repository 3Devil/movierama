require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/pages/movie_new'
require 'support/with_user'

RSpec.describe 'vote on movies', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid:  'null|12345',
      name: 'Bob'
    )
    Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         author
    )
  end

  context 'when logged out' do
    it 'cannot vote' do
      page.open
      expect {
        page.like('Empire strikes back')
      }.to raise_error(Capybara::ElementNotFound)
    end
  end

  context 'when logged in' do
    with_logged_in_user

    before { page.open }

    it 'can like' do
      page.like('Empire strikes back')
      expect(page).to have_vote_message
    end

    it 'can hate' do
      page.hate('Empire strikes back')
      expect(page).to have_vote_message
    end

    it 'can unlike' do
      page.like('Empire strikes back')
      page.unlike('Empire strikes back')
      expect(page).to have_unvote_message
    end

    it 'can unhate' do
      page.hate('Empire strikes back')
      page.unhate('Empire strikes back')
      expect(page).to have_unvote_message
    end

    it 'cannot like twice' do
      expect {
        2.times { page.like('Empire strikes back') }
      }.to raise_error(Capybara::ElementNotFound)
    end

    it 'cannot like own movies' do
      Pages::MovieNew.new.open.submit(
        title:       'The Party',
        date:        '1969-08-13',
        description: 'Birdy nom nom')
      page.open
      expect {
        page.like('The Party')
      }.to raise_error(Capybara::ElementNotFound)
    end

    it 'can show last two likers of own movies' do
      user = User.create(
        uid:  'null|23456',
        name: 'John Smith'
      )
      user2 = User.create(
        uid:  'null|34567',
        name: 'John Smith2'
      )
      user3 = User.create(
        uid:  'null|45678',
        name: 'John Smith3'
      )

      Pages::MovieNew.new.open.submit(
        title:       'The Party',
        date:        '1969-08-13',
        description: 'Birdy nom nom')

      movie = Movie.find(title: 'The Party').to_a.first
      VotingBooth.new(user, movie).vote(:like)
      VotingBooth.new(user2, movie).vote(:like)
      VotingBooth.new(user3, movie).vote(:like)
      movie = Movie.find(title: 'Empire strikes back').to_a.first
      VotingBooth.new(user, movie).vote(:like)
      VotingBooth.new(user2, movie).vote(:like)
      VotingBooth.new(user3, movie).vote(:like)

      page.open
      expect(page.movie_liked_by('The Party')).to eq("#{user3.name}, #{user2.name}")
      expect(page.movie_liked_by('Empire strikes back')).to be_nil
    end
  end

end

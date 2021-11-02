require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'

RSpec.describe 'show a submitters movie list', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    @alice = User.create(
      uid:  'null|12345',
      name: 'Alice'
    )
    @bob = User.create(
      uid:  'null|67890',
      name: 'Bob'
    )
    @m_empire = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      user:         @alice,
      liker_count:  50,
      hater_count:  2
    )
    @m_turtles = Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      user:         @bob,
      liker_count:  1,
      hater_count:  237
    )
  end

  before { page.open }

  it "shows the submitter's movies" do
    page.click_on 'Alice'
    expect(page.movie_titles).to include(@m_empire.title)
  end
  
  it "hides others' movies" do
    page.click_on 'Bob'
    expect(page.movie_titles).not_to include(@m_empire.title)
  end
end




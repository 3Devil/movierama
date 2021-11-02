require 'rails_helper'
require 'capybara/rails'
require 'support/pages/movie_list'
require 'support/with_user'

RSpec.describe 'sort movie list', type: :feature do

  let(:page) { Pages::MovieList.new }

  before do
    author = User.create(
      uid:  'null|12345',
      name: 'Bob'
    )
    @m_empire = Movie.create(
      title:        'Empire strikes back',
      description:  'Who\'s scruffy-looking?',
      date:         '1980-05-21',
      created_at:   Time.parse('2014-10-01 10:30 UTC').to_i,
      user:         author,
      liker_count:  50,
      hater_count:  2
    )
    @m_turtles = Movie.create(
      title:        'Teenage mutant nija turtles',
      description:  'Technically, we\'re turtles.',
      date:         '2014-10-17',
      created_at:   Time.parse('2014-10-01 10:35 UTC').to_i,
      user:         author,
      liker_count:  1,
      hater_count:  237
    )
    @titles = [@m_empire, @m_turtles].map(&:title)
  end

  before { page.open }

  it 'sorts by likers by default' do
    expect(page.movie_titles).to eq(@titles)
  end

  it 'can sort by likers' do
    page.sort_by('likers')
    expect(page.movie_titles).to eq(@titles)
  end

  it 'can sort by haters' do
    page.sort_by('haters')
    expect(page.movie_titles).to eq(@titles.reverse)
  end

  it 'can sort by date' do
    page.sort_by('date')
    expect(page.movie_titles).to eq(@titles.reverse)
  end
end




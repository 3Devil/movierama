require 'capybara/rspec'

module Pages
  class MovieList
    include Capybara::DSL

    def open(params = {})
      visit("/?#{params.to_param}")
    end

    def like(title)
      within(_movie_node(title)) do
        click_on 'Like'
      end
    end

    def unlike(title)
      within(_movie_node(title)) do
        click_on 'Unlike'
      end
    end

    def hate(title)
      within(_movie_node(title)) do
        click_on 'Hate'
      end
    end

    def unhate(title)
      within(_movie_node(title)) do
        click_on 'Unhate'
      end
    end

    def sort_by(attr)
      within(page.find('.mr-sorter')) do
        click_on(attr)
      end
    end

    def movie_titles
      page.all('.mr-movie-title').map(&:text)
    end

    def has_vote_message?
      page.has_content?('Vote cast')
    end

    def has_unvote_message?
      page.has_content?('Vote withdrawn')
    end

    private

    def _movie_node(title)
      page.all('.mr-movie').find { |n| n.has_content?(title) }
    end
  end
end


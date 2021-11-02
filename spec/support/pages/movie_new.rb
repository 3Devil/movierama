require 'capybara/rspec'

module Pages
  class MovieNew
    include Capybara::DSL

    def open
      visit('/movies/new')
      self
    end

    def submit(title:, description:, date:)
      fill_in 'title',       with: title
      fill_in 'description', with: description
      fill_in 'date',        with: date
      click_on 'Add movie'
      self
    end

    def has_movie_creation_message?
      page.has_content?('Movie added')
    end

    def has_error_message?
      page.has_content?('Errors were detected')
    end
  end
end



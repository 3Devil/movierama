require 'capybara/rspec'
require 'support/pages/shared'

module Pages
  class Home
    include Capybara::DSL
    include Pages::Login

    def open
      visit('/')
    end

    def has_app_name?
      page.has_content?('MovieRama')
    end
  end
end


require 'capybara/rspec'

module Pages
  module Login
    def sign_up
      click_on('Sign up')
    end
    
    def login
      click_on('Log in')
    end

    def logout
      click_on('Log out')
    end

    def has_logged_in?(username)
      has_selector?('#username') or return false
      find('#username').has_content?(username)
    end

    def logged_out?
      !has_selector?('#username')
    end

    def has_login_message?
      has_content?('Welcome back')
    end

    def has_signup_message?
      has_content?('Account created')
    end
  end
end



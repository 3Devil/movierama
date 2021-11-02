require 'support/pages/home'

module RspecSupportWithUser
  def with_auth_mock
    before do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(
        :github,
        uid: '12345',
        info: {
          name: 'John McFoo'
        }
      )
    end

    after do
      OmniAuth.config.test_mode = false
    end
  end

  def with_logged_in_user
    with_auth_mock

    before do
      Pages::Home.new.tap do |page|
        page.open
        page.login
      end
    end
  end
end

RSpec.configure { |c| c.extend RspecSupportWithUser }

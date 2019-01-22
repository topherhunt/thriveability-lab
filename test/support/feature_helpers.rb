class Capybara::Rails::TestCase
  Capybara.javascript_driver = :poltergeist
  # TODO: Configure Poltergeist to block unknown URLs.
  # See https://github.com/teampoltergeist/poltergeist#customization

  #
  # Actions
  #

  def sign_in(user)
    visit force_login_path(user.id, password: ENV["FORCE_LOGIN_PASSWORD"])
  end

  def sign_out
    visit "/logout"
  end

  def fill_fields(hash)
    hash.each do |field, value|
      page.find("#" + field.to_s, visible: false).set(value)
    end
  end

  # Use Jquery to force display a hidden element. Useful for getting at links
  # that are dynamically displayed: js_show("#hidden-div")
  def js_show(selector)
    page.execute_script(" $('#{selector}').show().css('visibility', 'visible'); ")
  end

  def js_hide(selector)
    page.execute_script(" $('#{selector}').hide(); ")
  end

  # See https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until page.evaluate_script('jQuery.active').zero?
    end
  end

  #
  # Assertions
  #

  def assert_html(text_or_html)
    if page.body.include?(text_or_html)
      assert true
    else
      assert false, "Expected page html to include this text, but it wasn't found.\n" +
        response_comparison(text_or_html)
    end
  end

  def assert_no_html(text_or_html)
    if page.body.include?(text_or_html)
      assert false, "Expected page html NOT to include this text, but it was found.\n" +
        response_comparison(text_or_html)
    else
      assert true
    end
  end

  def response_comparison(text_or_html)
    "The expected text:\n"\
    "  \"#{text_or_html}\"\n"\
    "The full response body:\n"\
    "  #{page.body.gsub("\n", "")}"
  end

  def assert_path(path)
    10.times do
      if path.is_a? Regexp
        return if current_path =~ path
      else
        return if current_path == path
      end
      sleep 0.2
    end
    raise "Expected current_path to match \"#{path}\", but was \"#{current_path}\"!"
  end
end

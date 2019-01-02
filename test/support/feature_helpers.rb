class Capybara::Rails::TestCase
  Capybara.javascript_driver = :webkit
  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end

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

  def sign_in(user)
    visit force_login_path(user.id, password: ENV["FORCE_LOGIN_PASSWORD"])
  end

  def sign_out
    visit "/logout"
  end

  def page!
    save_and_open_page
  end

  def image! # Only works when using webkit!
    Capybara::Screenshot.screenshot_and_open_image
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

  def expect_attributes(object, hash)
    hash.each do |k, v|
      assert_equals v, object.send(k)
    end
  end

  def fill_fields(hash)
    hash.each do |k, v|
      fill_in k, with: v
    end
  end

  def assert_users_cant_access_pages(opts)
    opts.fetch(:users).each do |user|
      logout
      sign_in user
      opts.fetch(:pages).each do |path|
        visit path
        assert_text "not authorized"
        assert_not_equal path, current_path
      end
    end
  end

  def using_webkit(&block)
    begin
      Capybara.current_driver = :webkit
      yield
    ensure
      Capybara.use_default_driver
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
end

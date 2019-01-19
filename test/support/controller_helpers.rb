class ActionController::TestCase
  include ActionView::Helpers::SanitizeHelper

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def assert_text(text)
    if response.body.include?(text)
      assert true
    else
      assert false, "Expected response to include text, but it wasn't found.\n" +
        compare_response_text(text)
    end
  end

  def assert_no_text(text)
    if response.body.include?(text)
      assert false, "Expected response NOT to include text, but it was found.\n" +
        compare_response_text(text)
    else
      assert true
    end
  end

  def compare_response_text(text)
    "The expected text:\n"\
    "  \"#{text}\"\n"\
    "The full response text:\n"\
    "  #{full_response_text}"
  end

  def full_response_text
    sanitize(response.body, tags: [])
      .gsub(/\n+/, "   ")
  end

  def assert_404_response
    assert_equals 404, response.status
    assert_text "The page you were looking for doesn't exist"
  end

  def assert_notified(notify_user, event)
    actor, action, target = event
    expected_notification = ["User #{actor.id}", action.to_s, target.class.to_s, target.id]
    received_notifications = Notification.where(notify_user: notify_user).map do |n|
      e = n.event
      ["User #{e.actor.id}", e.action.to_s, e.target_type, e.target_id]
    end
    assert received_notifications.include?(expected_notification),
      "Expected User #{notify_user.id} to receive notification about event #{expected_notification}, but they didn't. \nThey did receive the following notifications: #{received_notifications}"
  end
end

class ActionController::TestCase
  # TODO: Write new user session signin & signout helpers:
  # - sign_in(user)
  # - sign_out(user)

  def assert_content(text_or_html)
    if response.body.include?(text_or_html)
      assert true
    else
      assert false, "Expected response to include text, but it wasn't found.\n" +
        response_comparison(text_or_html)
    end
  end

  def assert_no_content(text_or_html)
    if response.body.include?(text_or_html)
      assert false, "Expected response NOT to include text, but it was found.\n" +
        response_comparison(text_or_html)
    else
      assert true
    end
  end

  def response_comparison(text_or_html)
    "The expected text:\n"\
    "  \"#{text_or_html}\"\n"\
    "The full response body:\n"\
    "  #{response.body.gsub("\n", "")}"
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

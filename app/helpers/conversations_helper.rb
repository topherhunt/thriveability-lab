module ConversationsHelper
  def new_conversation_tips(n)
    [
      "Focus on your purpose in starting this conversation. Where do you want to go?",
      "Every conversation is an act of collective intelligence. How can you invite for clarity, wisdom, and inspiration to surface?",
      "Clarify where you’re coming from. What experience, history, or assumptions do you draw on that would help others to know about?",
      "Invite others in! Asking thoughtful, open-ended questions keeps conversations meaningful and engaging.",
      "An awesome conversation is not about right or wrong, but about exploring emergent possibilities together.",
      "What we focus on co-creates our reality. Words have power, so choose them wisely!"
    ].shuffle.take(n)
  end

  def new_comment_tips(n)
    [
      "Every conversation is an act of collective intelligence. What can you contribute that will help surface clarity, wisdom, and inspiration?",
      "Clarify where you’re coming from. What experience, history, or assumptions do you draw on that would help others to know about?",
      "We don’t all have to agree! Listen for the piece of truth that each person brings to the table.",
      "When you have strong reactions, take a few breaths before responding.",
      "An awesome conversation is not about right or wrong, but about exploring emergent possibilities together.",
      "Speak your truth, yet be kind. Be kind, yet speak your truth."
    ].shuffle.take(n)
  end
end

module ConversationsHelper
  def random_conversation_tips(n)
    [
      "Focus on your purpose in being part of this conversation. Where do you want to go?",
      "Every conversation is an act of collective intelligence. What can you contribute that will help to surface clarity, wisdom, and inspiration?",
      "Clarify where you’re coming from. What experience, history, and assumptions are you drawing on that would be helpful for others to know about?",
      "Invite others in! Asking thoughtful, open-ended questions can help open up a conversation and keep it engaging.",
      "We don’t all have to agree in order to each be playing an important part in the conversation. Listen for the piece of truth that each person brings to the table.",
      "When you have strong reactions, take a few breaths before responding.",
      "An awesome conversation is not about right or wrong, but about exploring emergent possibilities together.",
      "What we focus on co-creates our reality. Words have power, so choose them wisely!",
      "Speak your truth, yet be kind. Be kind, yet speak your truth."
    ].shuffle.take(n)
  end
end

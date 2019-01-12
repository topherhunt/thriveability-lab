module ConversationsHelper
  def random_conversation_tips(n)
    [
      "Meaningful conversations allow us to 'think together', engaging our collective intelligence for better solutions. They surface shared clarity and foster ownership and responsibility. Actions that come out of such clarity are wise and sustainable.",
      "Clarify where you're coming from: what experience(s) led to your position? Is there a personal historyor guiding assumption others should know about?",
      "Invite others in! Asking the right question is the most effective way of opening up a conversation and keeping it engaging.",
      "A powerful question is simple and clear; open-ended; and thought provoking. It focuses on what is important, triggers curiosity, and opens up possibilities.",
      "Listen attentively, really seeking to understand what is being said. Actively look for the truth, wisdom, or beauty in how others are seeing an issue.",
      "Suspend rather than defend! Choose to suspend judgments and assumptions, instead of reactively defending them.",
      "Great conversation is not about being right or wrong, but about exploring together and allowing what we do not know or see yet to emerge.",
      "Accept that divergent opinions are okay. We do not always need to reach consensus. Innovation comes from bringing different perspectives together.",
      "What we focus on (co-)creates our reality. Words have power, so choose them well. Be aware of your impact on the conversation!",
      "Move beyond what you already know and listen for insights and deeper patterns or questions. Connect ideas to surface what do not know yet.",
      "Play, doodle, draw, and have fun! What if enjoying ourselves is the key to improving our learning, conversation, and collaboration?",
      "When things get tense: Slow down, take a deep breath, smile. Maybe take a break. Always speak your truth in the kindest way you can think of.",
      "\"Collective clarity of purpose is the invisible leader.\" - Mary Parker Follett",
      "\"Scientists have discovered that the small, brave act of cooperating with another person, of choosing trust over cynicism, generosity over selfishness, makes the brain light up with quiet joy.\" - Natalie Angier, Pulitzer Prize-winning New York Times reporter"
    ].shuffle.take(n)
  end
end

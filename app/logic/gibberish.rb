module Gibberish
  extend self

  def post_title
    verbs = ["enacting", "manifesting", "co-creating", "distributing", "support", "reimagining", "founding", "empowering", "catalyze", "thrive"]
    adjectives = ["global", "foundational", "more effective", "integral", "holistic", "the future of", "our", "values-driven", "local", "visionary", "historic", "bleeding-edge", "scientific", "dignified", "contemporary", "individual", "interdisciplinary", "planetary", "intricate", "all-quadrant"]
    nouns = ["future", "metatheory", "initiative", "approach", "emergence", "impact", "society", "philanthropy", "economics", "politics", "ecology", "legal framework", "collective sphere", "cosmos", "complexity"]
    [verbs.shuffle.first, adjectives.shuffle.first, nouns.shuffle.first].join(" ").capitalize
  end

  def random_paragraph
    Faker::Lorem.sentences(rand(2..15)).join(" ")
  end
end

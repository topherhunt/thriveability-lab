class IntentionType
  def self.find(short_name)
    all.select{ |it| it.short == short_name }.first
  end

  def self.all
    [ new(short: "share news", long: "share an update about world events"),
      new(short: "share facts", long: "share facts / research / objective knowledge"),
      new(short: "share perspective", long: "share a personal experience or perspective on an issue"),
      new(short: "raise awareness", long: "raise awareness of a problem"),
      new(short: "seek perspectives", long: "learn about others' perspectives"),
      new(short: "seek advice", long: "seek advice"),
      new(short: "critique", long: "critique a perspective"),
      new(short: "other", long: "[other]") ]
  end

  def initialize(hash)
    @short = hash.fetch(:short)
    @long = hash.fetch(:long)
  end

  def short
    @short
  end

  def long
    @long
  end
end

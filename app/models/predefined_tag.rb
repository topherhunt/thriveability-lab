class PredefinedTag < ActiveRecord::Base
  PRESETS = ["personal development & psychology", "organizational development", "community development", "culture & worldviews", "climate change", "education", "energy & resource management", "deforestation", "pollution", "politics", "activism", "science & research", "philosophy & metatheory", "spirituality"]

  def self.repopulate
    self.delete_all
    PRESETS.each do |name|
      self.create!(name: name)
    end
  end

  validates :name, presence: true
end

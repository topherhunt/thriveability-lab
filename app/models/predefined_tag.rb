class PredefinedTag < ActiveRecord::Base

  def self.repopulate
    self.delete_all
    [
      "personal development & psychology", "organizational development", "community development", "culture & worldviews", "climate change", "education", "energy & resource management", "deforestation", "pollution", "politics", "activism", "science & research", "philosophy & metatheory", "spirituality"
    ].each do |name|
      self.create!(name: name)
    end
  end

  validates :name, presence: true
end

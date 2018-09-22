class PredefinedTag < ActiveRecord::Base
  PRESETS = ["water / nature / agriculture", "mobility & energy", "food & drink", "health / lifestyle / wellbeing", "education & knowledge generation", "psychology & inner development", "culture & worldviews", "sharing & social movements", "business & organizational change", "politics & institutions", "law & order", "economy & jobs", "minorities & empowerment"]

  def self.repopulate
    self.delete_all
    PRESETS.each do |name|
      self.create!(name: name)
    end
  end

  validates :name, presence: true, length: {maximum: 50}
end

class ConsolidateUserBioFields < ActiveRecord::Migration
  def up
    add_column :users, :bio_interior, :text
    add_column :users, :bio_exterior, :text

    User.find_each do |user|
      user.bio_interior = interior_bio_for(user)
      user.bio_exterior = exterior_bio_for(user)
      user.save!
    end

    remove_column :users, :self_dreams
    remove_column :users, :self_passions
    remove_column :users, :self_proud_traits
    remove_column :users, :self_weaknesses
    remove_column :users, :self_evolve
    remove_column :users, :self_skills
    remove_column :users, :self_looking_for
    remove_column :users, :self_work_at
    remove_column :users, :self_professional_goals
    remove_column :users, :self_fields_of_expertise
  end

  def down
    puts "WARNING: User bio data is being PERMANENTLY LOST. Sorry about that."
    remove_column :users, :bio_interior
    remove_column :users, :bio_exterior
    add_column :users, :self_dreams, :text
    add_column :users, :self_passions, :text
    add_column :users, :self_proud_traits, :text
    add_column :users, :self_weaknesses, :text
    add_column :users, :self_evolve, :text
    add_column :users, :self_skills, :text
    add_column :users, :self_looking_for, :text
    add_column :users, :self_work_at, :text
    add_column :users, :self_professional_goals, :text
    add_column :users, :self_fields_of_expertise, :text
  end

  private

  def interior_bio_for(user)
    {
      self_dreams: "I dream of a future where",
      self_passions: "I'm passionate about",
      self_proud_traits: "I'm proud of these traits:",
      self_weaknesses: "The weakness(es) I'm currently trying to overcome are:",
      self_evolve: "I would like to evolve towards"
    }.map { |field_name, sentence_stem|
      if user.send(field_name).present?
        sentence = "#{sentence_stem} #{user.send(field_name)}"
        sentence = sentence + "." unless sentence[-1].in?([".", "!", "?"])
        sentence
      end
    }.compact.join(" ")
  end

  def exterior_bio_for(user)
    {
      self_skills: "I'm good at",
      self_looking_for: "I'm part of Integral Climate because I'm looking for",
      self_work_at: "I currently work at/as",
      self_professional_goals: "My professional goal is",
      self_fields_of_expertise: "I have expertise / experience in"
    }.map { |field_name, sentence_stem|
      if user.send(field_name).present?
        sentence = "#{sentence_stem} #{user.send(field_name)}"
        sentence = sentence + "." unless sentence[-1].in?([".", "!", "?"])
        sentence
      end
    }.compact.join(" ")
  end
end

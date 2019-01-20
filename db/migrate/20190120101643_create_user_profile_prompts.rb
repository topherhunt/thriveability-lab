class CreateUserProfilePrompts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_profile_prompts do |t|
      t.references :user
      t.string :stem
      t.text :response
      t.timestamps
    end
  end
end

class CreateConverastionParticipantJoins < ActiveRecord::Migration
  def change
    create_table :conversation_participant_joins do |t|
      t.integer :conversation_id, null: false
      t.integer :participant_id, null: false
      t.string :intention, null: false
      t.timestamps
    end

    add_foreign_key :conversation_participant_joins, :conversations
    add_foreign_key :conversation_participant_joins, :users, column: :participant_id
    add_index :conversation_participant_joins, :conversation_id
    add_index :conversation_participant_joins, :participant_id
  end
end

class AddIndexesToStayInformedAndGetInvolvedFlags < ActiveRecord::Migration
  def change
    add_index :get_involved_flags, [:target_type, :target_id]
    add_index :get_involved_flags, :user_id

    add_index :stay_informed_flags, [:target_type, :target_id]
    add_index :stay_informed_flags, :user_id

    add_index :projects, :owner_id
    add_index :resources, :creator_id
  end
end

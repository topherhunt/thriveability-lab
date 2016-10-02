class CreateStayInformedFlags < ActiveRecord::Migration
  def change
    create_table :stay_informed_flags do |t|
      t.integer :user_id
      t.string :target_type
      t.integer :target_id
      t.timestamps
    end
  end
end

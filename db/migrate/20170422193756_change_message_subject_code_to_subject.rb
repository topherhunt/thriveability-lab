class ChangeMessageSubjectCodeToSubject < ActiveRecord::Migration
  def change
    rename_column :messages, :subject_code, :subject
  end
end

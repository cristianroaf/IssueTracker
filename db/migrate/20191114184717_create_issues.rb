class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :Title
      t.string :Description
      t.string :Type
      t.string :Priority
      t.string :Status
      t.string :user_id
      t.string :asignee_id
      t.integer :Votes
      t.integer :Watchers
      t.string :at_name
      t.string :at_format
      t.integer :at_size
      t.datetime :at_updated_at

      t.timestamps
    end
  end
end

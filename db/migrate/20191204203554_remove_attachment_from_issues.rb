class RemoveAttachmentFromIssues < ActiveRecord::Migration[6.0]
  def change

    remove_column :issues, :at_name, :string

    remove_column :issues, :at_format, :string

    remove_column :issues, :at_size, :integer

    remove_column :issues, :at_updated_at, :datetime
  end
end

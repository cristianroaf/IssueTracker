class RemoveAttachmentFromComments < ActiveRecord::Migration[6.0]
  def change

    remove_column :comments, :attachment_file_name, :string

    remove_column :comments, :attachment_content_type, :string

    remove_column :comments, :attachment_file_size, :integer

    remove_column :comments, :attachment_updated_at, :datetime
  end
end

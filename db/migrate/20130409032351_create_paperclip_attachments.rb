class CreatePaperclipAttachments < ActiveRecord::Migration
  def change
    create_table :paperclip_attachments do |t|
      t.references :attacheable, :polymorphic => true
      t.attachment :attachment
      t.string :attachment_type

      t.timestamps
    end
    add_index :paperclip_attachments, [:attacheable_id, :attacheable_type], :name => "index_paperclip_attachments_on_attacheable_fields"
  end
end

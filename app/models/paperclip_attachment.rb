class PaperclipAttachment < ActiveRecord::Base
  belongs_to :attacheable, :polymorphic => true
  attr_accessible :attachment

  has_attached_file :attachment, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end

class PaperclipAttachment < ActiveRecord::Base
  belongs_to :attacheable, :polymorphic => true
  attr_accessible :attachment
end

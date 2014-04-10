class CommentsImage < Attachment
  belongs_to :user

  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_presence_of :user

  validates_attachment :file, :presence => true, :content_type => {
    :content_type => ['image/gif', 'image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате gif, jpeg, jpg или png' }
end

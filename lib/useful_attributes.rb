module UsefulAttributes
  def useful_attributes
    self.attributes.keys.delete_if { |key| key =~ /(id|created_at|updated_at|vfs_path)/ }
  end
end

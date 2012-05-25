class PathInterpolator
  # NOTE: может в будущем измениться
  def self.path(request)
    request.params['vfs_path']
  end
end

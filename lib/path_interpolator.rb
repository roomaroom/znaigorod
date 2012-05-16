class PathInterpolator
  # NOTE: может в будущем измениться
  def self.path(request)
    "/affiches/#{Date.today.to_s}"
  end
end

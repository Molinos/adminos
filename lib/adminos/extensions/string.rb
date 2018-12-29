class String
  def pathalize
    self.underscore.gsub '/', '_'
  end
end

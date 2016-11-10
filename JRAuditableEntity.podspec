Pod::Spec.new do |s|
  s.name         = "JRAuditableEntity"
  s.version      = "0.0.1"
  s.summary      = "A short description of JRAuditableEntity."
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                   DESC

  # s.homepage     = "http://EXAMPLE/JRAuditableEntity"
  s.license       = "MIT (example)"
  s.author        = { "Joshua L. Rasmussen" => "xlr8runner@gmail.com" }
  s.source        = { :git => "http://github.com/xlr8runner/JRAuditableEntity.git", :tag => "0.0.1" }
  s.source_files  = "JRAuditableEntity/**/*.{h,m}"
end

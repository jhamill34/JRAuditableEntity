Pod::Spec.new do |s|
  s.name          = "JRAuditableEntity"
  s.version       = "1.0.0"
  s.summary       = "Creates opprotunities to fix entities that may not be in a proper state."
  s.description   = "Entities may implement the Fixable protocol to return a list of properties that have failed
  validation. Entities may implement the Diffable protocol to be able to compose a collection of properties that are
  different."
  s.homepage      = "https://github.com/xlr8runner/JRAuditableEntity"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Joshua L. Rasmussen" => "xlr8runner@gmail.com" }
  s.source        = { :git => "https://github.com/xlr8runner/JRAuditableEntity.git", :tag => "1.0.0" }
  s.source_files  = "JRAuditableEntity/**/*.{h,m}"
  s.platform = :ios, '9.0'
end

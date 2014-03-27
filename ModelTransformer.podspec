Pod::Spec.new do |s|
  s.name         = "ModelTransformer"
  s.version      = "1.0.0-alpha-3"
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.source_files  = 'ModelTransformer/ModelTransformer/*.{h,m}'
  s.framework  = 'CoreData'
  s.requires_arc = true
end

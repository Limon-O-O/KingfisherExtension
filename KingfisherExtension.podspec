Pod::Spec.new do |s|

  s.name        = "KingfisherExtension"
  s.version     = "0.1"
  s.summary     = "Kingfisher Extension"

  s.description = <<-DESC
                  KingfisherExtension base on Kingfisher. Remake image before caching by style.
                  DESC

  s.homepage    = "https://github.com/Limon-O-O/KingfisherExtension"

  s.license     = { :type => "MIT", :file => "LICENSE" }

  s.authors           = { "Limon" => "fengninglong@gmail.com" }
  s.social_media_url  = "https://twitter.com/Limon______"

  s.ios.deployment_target   = "8.0"

  s.source          = { :git => "https://github.com/Limon-O-O/KingfisherExtension.git", :tag => s.version }
  s.source_files    = "KingfisherExtension/*.swift"
  s.requires_arc    = true

  s.dependency 'Kingfisher'

end

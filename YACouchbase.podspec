Pod::Spec.new do |s|
  s.name         = "YACouchbase"
  s.version      = "0.0.2-beta"
  s.summary      = "Wrapper for Couchbase Lite on iOS"
  s.homepage     = "https://github.com/Yalantis/YACouchbase.git"
  s.license		 = "MIT"
  s.author       = { "Maxim Letushov" => "maximletushov@gmail.com" }
  s.source       = {
     :git => "git@github.com:Yalantis/YACouchbase.git",
     :tag => "0.0.2-beta"
  }
  s.platform     = :ios, '7.0'
  s.source_files = 'YACouchbase/Code/**/*.{h,m}'
  s.public_header_files = 'YACouchbase/Code/**/*.{h,m}'
  s.frameworks = 'SystemConfiguration'
  s.vendored_frameworks = 'Frameworks/CouchbaseLite.framework'
  s.libraries = 'sqlite3', 'z'
  s.requires_arc = true
end

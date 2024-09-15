Pod::Spec.new do |s|
  s.name         = 'BoringSSL-GRPC'
  s.version      = '1.68.0-dev'
  s.summary      = 'BoringSSL for gRPC'
  s.description  = <<-DESC
                    BoringSSL for gRPC.
                    DESC
  s.homepage     = 'https://github.com/grpc/grpc'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author       = { 'gRPC' => 'grpc-io@google.com' }
  s.source       = { :git => 'https://github.com/grpc/grpc.git', :tag => s.version.to_s }
  s.source_files  = 'src/core/**/*.h', 'src/core/**/*.cc'
  s.requires_arc = true
  s.dependency 'gRPC-RxLibrary', '~> 1.66.1'
end

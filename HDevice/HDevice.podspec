Pod::Spec.new do |s|
  s.name             = "HDevice"
  s.version          = "0.3.10"

  s.summary          = "HDevice is iOS Common Libraries about Mobile Device"


  s.homepage         = "http://www.camera360.com"


  s.license          = 'Copyright 2010-2015 Pinguo Inc.'

  s.license = { :type => 'Copyright', :text =>
       <<-LICENSE
       Copyright 2010-2015 Pinguo Inc.
       LICENSE
   }

  s.author           = { "lyj" => "liyanjun@camera360.com" }
  s.source           = { :git => "git@192.168.1.33:HDevice.git",:tag => s.version.to_s}

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.subspec 'Header' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.ios.source_files = 'Classes/HDeviceHeader.h'
  end

  s.subspec 'Base' do |ss|
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.ios.source_files = 'Classes/HDevice/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HAppInfo' do |ss|
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'CoreMotion'
    ss.ios.source_files = 'Classes/HAppInfo/*.{h,m,mm,cpp,c}'
  end

   s.subspec 'HSystem' do |ss|
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.ios.source_files = 'Classes/HSystem/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HDevice+Camera' do |ss|
    ss.dependency 'HDevice/Base'
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'AssetsLibrary'
  ss.weak_framework = 'Photos'
    ss.ios.source_files = 'Classes/HDevice+Camera/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HDevice+Location' do |ss|
    ss.dependency 'HDevice/Base'
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'CoreLocation'
    ss.ios.source_files = 'Classes/HDevice+Location/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HDevice+Network' do |ss|
    ss.dependency 'HDevice/Base'
    ss.dependency 'Reachability'
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'CoreTelephony'
    ss.ios.source_files = 'Classes/HDevice+Network/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HDevice+Sound' do |ss|
    ss.dependency 'HDevice/Base'
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'AVFoundation','MediaPlayer'
    ss.ios.source_files = 'Classes/HDevice+Sound/*.{h,m,mm,cpp,c}'
  end

  s.subspec 'HDevice+Motion' do |ss|
    ss.dependency 'HDevice/Base'
    ss.dependency 'HDevice/Header'
    ss.ios.deployment_target = '7.0'
    ss.framework = 'CoreMotion','AVFoundation'
    ss.ios.source_files = 'Classes/HDevice+Motion/*.{h,m,mm,cpp,c}'
  end

end

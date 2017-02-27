# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Smart Lock'
  app.device_family = [:iphone]
  app.info_plist['NSAppTransportSecurity'] = { 'NSAllowsArbitraryLoads' => true }
  app.identifier = 'smartlock.enduraproducts.com'
  app.codesign_certificate = 'iPhone Distribution: Endura Products, Inc'
  app.provisioning_profile = '~/Library/MobileDevice/Provisioning Profiles/42955cf1-ffd9-4308-88bd-adf0680a992f.mobileprovision'
  app.entitlements['get-task-allow'] = false
  app.archs["iphoneSimulator"] = ["i386"]
  app.archs["iPhoneOS"] = ["armv7"]
end

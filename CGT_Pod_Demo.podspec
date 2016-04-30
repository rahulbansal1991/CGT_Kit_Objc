Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "CGT_Pod_Demo"
  s.version      = "1.0"
  s.summary      = "CGT_Pod_Demo for Testing purpose"
  s.description  = <<-DESC
* An extensive blocks-based Objective C wrapper.
                   DESC
  s.homepage     = "http://www.cgt.co.in"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Rahul Bansal" => "rahul.bansal@cgt.co.in" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/rahulbansal1991/CGT_Kit_Objc.git", :tag => "1.0" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "NetworkManager/*.{h,m}"
#  s.exclude_files = "Classes/Exclude"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.5'
  s.dependency 'MBProgressHUD'
  s.dependency 'Reachability'

end

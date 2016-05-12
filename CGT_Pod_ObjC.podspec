Pod::Spec.new do |s|

# ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.name         = "CGT_Pod_ObjC"
s.version      = "1.3"
s.summary      = "CGT_Pod_ObjC contains pods of all the basic and necessary libraries"
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
s.source       = { :git => "https://github.com/rahulbansal1991/CGT_Kit_Objc.git", :tag => "1.6" }

# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.source_files  = "NetworkManager/*.{h,m}"
#  s.exclude_files = "Classes/Exclude"

# ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
s.requires_arc = true
s.dependency 'AFNetworking', '~> 2.5'
s.dependency 'MBProgressHUD'
s.dependency 'Reachability'
s.dependency 'Mantle', '~> 2.0'
s.dependency 'SDWebImage', '~> 3.7'
s.dependency 'BFKit'

end
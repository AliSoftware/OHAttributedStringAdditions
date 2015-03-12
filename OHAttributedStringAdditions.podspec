Pod::Spec.new do |s|

  s.name         = "OHAttributedStringAdditions"
  s.version      = "1.3.0"
  s.summary      = "Categories on NSAttributedString to add a lot of very useful convenience methods."

  s.description  = <<-DESC.gsub(/^.*\|/,'')
                   |This pod contains categories on `NSAttributedString` to add a lot of very useful
                   |convenience methods to manipulate attributed strings.
                   |
                   |The includes convenience methods to:
                   | * set attributes on a given range
                   | * get attributes at a given index
                   |
                   |Convenience methods are available for a lot of common attributes, including:
                   | * Fonts
                   | * Text Foreground and Background Colors
                   | * Text Style (bold, italics, underline)
                   | * Links (URLs)
                   | * Baseline offset, subscript, superscript
                   | * Text alignment, linebreak mode, character spacing
                   | * Paragraph Style (text indent, linespacing, …)
                   | * etc.
                   DESC

  s.homepage     = "https://github.com/AliSoftware/OHAttributedStringAdditions"
  s.license      = { :type => "MIT", :file => "LICENSE" }


  s.author             = { "Olivier Halligon" => "olivier@halligon.net" }
  s.social_media_url   = "http://twitter.com/aligatr"

  s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.8"

  s.source       = { :git => "https://github.com/AliSoftware/OHAttributedStringAdditions.git", :tag => s.version.to_s }
  s.requires_arc = true


  ### Subspecs ###
  
  s.subspec 'Common' do |sub|
    # The umbrella header
    sub.source_files  = "Source/#{s.name}.h"
  end
  
  subspecs = {
      'NSAttributedString' => 'NS*AttributedString',
      'UIFont' => 'UIFont',
      'UILabel' => 'UILabel'
  }
  
  subspecs.each do |name, prefix|
    s.subspec name do |sub|
      sub.source_files  = "Source/#{prefix || name}+OHAdditions.{h,m}"
      sub.dependency "#{s.name}/Common"
    end
  end
end

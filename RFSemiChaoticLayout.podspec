Pod::Spec.new do |s|
  s.name     = 'RFSemiChaoticLayout'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = ''
  s.homepage = 'https://github.com/bryceredd/RFSemiChaoticLayout'
  s.author   = { 'bryce' => 'bryce@i.tv' }
  s.source   = { :git => 'https://github.com/bryceredd/RFSemiChaoticLayout.git', :tag => '1.0.3' }
  s.description = 'A subclass of UICollectionViewLayout - places cells in a semi-random position.'
  s.source_files = 'RFSemiChaoticLayout'
  s.platform = :ios, '6.0'
  s.requires_arc = true
end

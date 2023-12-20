rm -rf archives
export PROJECT_NAME="ScanForensicsPlus"
echo $PROJECT_NAME

xcodebuild clean archive \
  -scheme "ScanForensicsPlus" \
  -target "ScanForensicsPlus" \
  -destination "generic/platform=iOS" \
  -archivePath "archives/${PROJECT_NAME}-iOS" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty

 xcodebuild archive \
 -scheme "ScanForensicsPlus" \
 -target "ScanForensicsPlus" \
 -destination "generic/platform=iOS Simulator" \
 -archivePath "archives/${PROJECT_NAME}-Simulator" \
 -sdk iphonesimulator \
 VALID_ARCHS="i386 x86_64" \
 SKIP_INSTALL=NO \
 BUILD_LIBRARY_FOR_DISTRIBUTION=YES | xcpretty

xcodebuild -create-xcframework \
   -framework "archives/${PROJECT_NAME}-iOS.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}.framework" \
   -framework "archives/${PROJECT_NAME}-Simulator.xcarchive/Products/Library/Frameworks/${PROJECT_NAME}.framework" \
   -output "archives/${PROJECT_NAME}.xcframework" | xcpretty



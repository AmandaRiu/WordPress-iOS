#checking if xcpretty is available to use
pretty="xcpretty -c"
command -v xcpretty >/dev/null
if [ $? -eq 1 ]; then
echo >&2 "xcpretty not found don't use it."
pretty="&>";
fi

if [ ! $TRAVIS ]; then
	TRAVIS_XCODE_WORKSPACE=WordPress.xcworkspace
	TRAVIS_XCODE_SCHEME=WordPress
    TRAVIS_XCODE_SDK=iphonesimulator8.1
fi

set -o pipefail && xcodebuild test \
	-destination "platform=iOS Simulator,name=iPhone 4s,OS=8.1" \
	-workspace "$TRAVIS_XCODE_WORKSPACE" \
	-scheme "$TRAVIS_XCODE_SCHEME" \
	-sdk "$TRAVIS_XCODE_SDK" | ${pretty}
	

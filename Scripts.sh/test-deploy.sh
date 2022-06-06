#!/bin/bash

# Build packages
pod install

# Gitclone
git clone https://github.com/phdafoe/InternalPoCSFC.git -b main -v

# Fastlane
export BUNDLE GEMFILE=$BUILD SCRIPTS DIR/Gemfile
bundle install

# Prepare, Build and Deploy
bundle exec /usr/local/Cellar/fastlane/2.206.2/bin/fastlane scan
bundle exec /usr/local/Cellar/fastlane/2.206.2/bin/fastlane gym

# Run Specs (tests) if not confiqured to be skipped
bundle exec /usr/local/Cellar/fastlane/2.206.2/bin/fastlane specs

# Build IPA
bundle exec /usr/local/Cellar/fastlane/2.206.2/bin/fastlane build_ipa

# Upload to APPCENTER
bundle exec /usr/local/Cellar/fastlane/2.206.2/bin/fastlane appcenter_release

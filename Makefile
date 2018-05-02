BUNDLE_DIR ?= .bundle

build:
	puppet module build

changelog:
	github_changelog_generator -u hep-puppet -p htcondor

release: build changelog

verify: bundle_install
	bundle exec rake test

bundle_install:
	bundle install --path $(BUNDLE_DIR)

acceptance: bundle_install
	exit 0
	#bundle exec rake beaker:default

test:
	bundle exec rake lint

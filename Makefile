BUNDLE_DIR ?= .bundle
build:
	puppet module build

changelog:
	github_changelog_generator -u hep-puppet -p htcondor

update_release:
	@python update_release.py
	@echo "Check everything and if OK, execute"
	@echo "git add -u"
	@echo "git commit -m 'tagged version ${RELEASE}'"
	@echo "git push upstream master"
	@echo "git tag v${RELEASE}"
	@echo "git push upstream v${RELEASE}"

release: changelog update_release build

verify: bundle_install
	bundle exec rake test

bundle_install:
	bundle install --path $(BUNDLE_DIR)

acceptance: bundle_install
	exit 0
	#bundle exec rake beaker:default

test:
	bundle exec rake lint

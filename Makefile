ifdef GITHUB_REPOSITORY
tap=$(GITHUB_REPOSITORY)
else
$(error The argument "tap" is required)
endif

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

.DELETE_ON_ERROR:
.SECONDARY:

all: formula.json

setup:
	sudo chown $(USER): $(HOME)
	sudo chown -R $(USER): .
	git remote set-url origin https://$(HOMEBREW_GITHUB_API_TOKEN)@github.com/$(tap)

formula.json:
	brew install jq
	brew tap $(tap)
	brew info --json=v1 `brew --repo $(tap)`/Formula/*.rb | jq >formula.json

deploy: formula.json
	git config --global user.name LinuxbrewTestBot
	git config --global user.email testbot@linuxbrew.sh
	git fetch origin
	git checkout -B gh-pages origin/gh-pages
	git merge origin/master
	mkdir -p api
	cp -a formula.json api/
	git add api/formula.json
	git commit -m 'Update formula.json' api/formula.json
	git push origin gh-pages

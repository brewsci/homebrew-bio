ifdef GITHUB_REPOSITORY
tap=$(GITHUB_REPOSITORY)
else
ifndef tap
$(error The argument "tap" is required)
endif
endif

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

.DELETE_ON_ERROR:
.SECONDARY:

all: api/formula.json

setup:
	sudo chown $(USER): $(HOME)
	sudo chown -R $(USER): .
	git config --global user.name LinuxbrewTestBot
	git config --global user.email testbot@linuxbrew.sh

formula.json:
	brew install jq
	brew tap $(tap)
	brew info --json=v1 `brew --repo $(tap)`/Formula/*.rb | jq >formula.json

api/formula.json: formula.json
	git fetch origin
	git checkout -B gh-pages origin/gh-pages
	git merge --no-edit origin/master
	mkdir -p api
	cp -a formula.json api/
	git add api/formula.json
	-git commit -m 'Update formula.json' api/formula.json

deploy: api/formula.json
	@echo git push "https://***@github.com/$(tap)" gh-pages
	@git push https://$(HOMEBREW_GITHUB_API_TOKEN)@github.com/$(tap) gh-pages

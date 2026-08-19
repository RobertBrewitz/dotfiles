SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help arch-install arch-install-no-devtools arch-devtools arch-new-user symlink

NEW_USER ?= stream
NEW_USER_SHELL ?= /bin/bash
NEW_USER_GROUPS ?= wheel
NEW_USER_DOTFILES_DIR ?= dotfiles

help:
	@echo "Targets:"
	@echo "  make arch-install                     Full Arch install, including dev tools"
	@echo "  make arch-install-no-devtools         Full Arch install, excluding dev tools"
	@echo "  make arch-devtools                    Install per-user dev tools for current user"
	@echo "  make arch-new-user NEW_USER=stream    Create user, set password, copy dotfiles"
	@echo "  make symlink                          Symlink dotfiles for current user"

arch-install:
	./arch.sh

arch-install-no-devtools:
	INSTALL_DEVTOOLS=0 ./arch.sh

arch-devtools:
	./arch_devtools.sh

symlink:
	./symlink_arch.sh

arch-new-user:
	@if id "$(NEW_USER)" >/dev/null 2>&1; then \
		echo "User $(NEW_USER) already exists"; \
	else \
		sudo useradd -m -s "$(NEW_USER_SHELL)" "$(NEW_USER)"; \
	fi
	@sudo passwd "$(NEW_USER)"
	@if [ -n "$(NEW_USER_GROUPS)" ]; then \
		sudo usermod -aG "$(NEW_USER_GROUPS)" "$(NEW_USER)"; \
	fi
	@home="$$(getent passwd "$(NEW_USER)" | cut -d: -f6)"; \
	dest="$$home/$(NEW_USER_DOTFILES_DIR)"; \
	if [ -e "$$dest" ] || [ -L "$$dest" ]; then \
		backup="$$dest.backup.$$(date +%Y%m%d%H%M%S)"; \
		echo "Backing up existing $$dest to $$backup"; \
		sudo mv "$$dest" "$$backup"; \
	fi; \
	echo "Copying dotfiles to $$dest"; \
	sudo cp -a "$(CURDIR)" "$$dest"; \
	sudo chown -R "$(NEW_USER):$(NEW_USER)" "$$dest"; \
	echo "Copied dotfiles to $$dest and changed ownership to $(NEW_USER)"
	@echo "Next: log in as $(NEW_USER), cd ~/$(NEW_USER_DOTFILES_DIR), then run: make symlink"
	@echo "Done."

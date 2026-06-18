PREFIX  ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin
SCRIPT  := $(BIN_DIR)/mmxcode

ROOT     := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
ENV_FILE := $(ROOT)/.env
TEMPLATE := $(ROOT)/bin/mmxcode.template

.PHONY: install uninstall

install: $(SCRIPT) $(ENV_FILE)
	@echo
	@echo "  Installed: $(SCRIPT)"
	@echo "  Env file : $(ENV_FILE)"
	@echo
	@if grep -Eq '^MINIMAX_API_KEY=.+' $(ENV_FILE); then \
		echo "  MINIMAX_API_KEY: set"; \
	else \
		echo "  MINIMAX_API_KEY: NOT SET — edit $(ENV_FILE) before running mmxcode"; \
	fi
	@echo
	@if ! command -v mmxcode >/dev/null 2>&1; then \
		echo "  WARNING: $(BIN_DIR) is not on your PATH."; \
		echo "  Add this to your shell rc:"; \
		echo "    export PATH=\"$(BIN_DIR):\$$PATH\""; \
		echo; \
	fi

$(SCRIPT): $(TEMPLATE) | $(BIN_DIR)
	@sed 's|@@ENV_FILE@@|$(ENV_FILE)|g' $(TEMPLATE) > $@
	@chmod +x $@

$(BIN_DIR):
	@mkdir -p $@

$(ENV_FILE):
	@cp $(ROOT)/.env.example $@
	@chmod 600 $@
	@echo "  Created $@ from .env.example — fill in MINIMAX_API_KEY before running mmxcode."

uninstall:
	@rm -f $(SCRIPT)
	@echo "  Removed $(SCRIPT)"
	@echo "  Note: $(ENV_FILE) is left in place. Delete it manually if no longer needed."

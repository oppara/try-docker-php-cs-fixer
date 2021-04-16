ifneq (,)
.error This Makefile requires GNU Make.
endif

.PHONY: lint fix _lint-pcf _fix-pcf _update-pcf

CURRENT_DIR = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PCF_VERSION = 2

OK='\033[32mOK\033[m'
FAILED='\033[31mFailed\033[m'

PCF_CMD = docker run --rm \
	-v $(CURRENT_DIR):/data \
	cytopia/php-cs-fixer:$(PCF_VERSION) \
	fix --ansi --diff --config=.php_cs.dist

lint:
	@$(MAKE) --no-print-directory _lint-pcf

fix:
	@$(MAKE) --no-print-directory _fix-pcf

_lint-pcf: _update-pcf
	@if $(PCF_CMD) --dry-run . ; then \
		echo $(OK); \
	else \
		echo $(FAILED); \
	fi

_fix-pcf: _update-pcf
	@if $(PCF_CMD) . ; then \
		echo $(OK); \
	else \
		echo $(FAILED); \
	fi

_update-pcf:
	@docker pull -q cytopia/php-cs-fixer:$(PCF_VERSION)

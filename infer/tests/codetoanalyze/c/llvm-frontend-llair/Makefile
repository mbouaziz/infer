# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

# Checks the LLVM-to-LLAIR translation (LlvmSledgeFrontend) on hand-written IR
# by comparing the LLAIR text dump with the expected one.

TESTS_DIR=../../..

INFER_OPTIONS = --frontend-tests --dump-llair-text --project-root $(TESTS_DIR)

SOURCES = $(realpath $(wildcard *.c.ll))

CLEAN_EXTRA = *.test.sil *.test.dot *.llair.text

include $(TESTS_DIR)/base.make

default: test

%.c.llair.text: %.c.ll $(INFER_BIN) $(MAKEFILE_LIST)
	$(QUIET)$(call silent_on_success,Testing the LLVM to LLAIR translation in $(TEST_REL_DIR),\
	  $(INFER_BIN) capture --results-dir infer-out-$(basename $(notdir $*)) $(INFER_OPTIONS) \
	    --llvm-bitcode-file $< --llvm-bitcode-source $*.c )

capture: $(SOURCES:.c.ll=.c.llair.text)

.PHONY: print
print: capture

.PHONY: test
test: capture
	$(QUIET)error=0; for file in $(SOURCES) ; do \
	  base=$${file%.ll}; \
	  diff -u "$$base.llair.exp" "$$base.llair.text" || error=1 ; \
	done ; \
	if [ $$error = 1 ]; then exit 1; fi

.PHONY: replace
replace: capture
	$(QUIET)for file in $(SOURCES) ; do \
	  base=$${file%.ll}; \
	  mv "$$base.llair.text" "$$base.llair.exp" ; \
	done

.PHONY: clean
clean:
	$(REMOVE_DIR) infer-out infer-out-* $(CLEAN_EXTRA)

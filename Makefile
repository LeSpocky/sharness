prefix = $(HOME)

INSTALL_DIR = $(prefix)/share/sharness
DOC_DIR = $(prefix)/share/doc/sharness
EXAMPLE_DIR = $(DOC_DIR)/example
VIM_DIR = $(prefix)/.vim/pack/filetypes/start/sharness

DOC_FILES = API.md CHANGELOG.md COPYING README.git README.md

INSTALL = install
RM = rm -f
SED = sed
TOMDOCSH = tomdoc.sh
CP = cp
D = $(DESTDIR)

scripts = sharness.sh lib-sharness/functions.sh tools/aggregate-results.sh

all:

install: all
	$(INSTALL) -d -m 755 $(D)$(INSTALL_DIR) $(D)$(INSTALL_DIR)/lib-sharness $(D)$(INSTALL_DIR)/tools $(D)$(DOC_DIR) $(D)$(EXAMPLE_DIR)
	$(INSTALL) -m 644 sharness.sh $(D)$(INSTALL_DIR)
	$(INSTALL) -m 644 lib-sharness/functions.sh $(D)$(INSTALL_DIR)/lib-sharness
	$(INSTALL) -m 644 tools/aggregate-results.sh $(D)$(INSTALL_DIR)/tools
	$(INSTALL) -m 644 $(DOC_FILES) $(D)$(DOC_DIR)
	$(INSTALL) -m 644 example/Makefile $(D)$(EXAMPLE_DIR)
	$(SED) -e "s!\. \./sharness.sh!\. $(INSTALL_DIR)/sharness.sh!" example/simple.t > $(D)$(EXAMPLE_DIR)/simple.t
	chmod 755 $(D)$(EXAMPLE_DIR)/simple.t

install-test:
	$(MAKE) -C $(D)$(EXAMPLE_DIR)

install-vim:
	$(INSTALL) -d -m 755 $(D)$(VIM_DIR)
	$(CP) -r vim/* $(D)$(VIM_DIR)

uninstall:
	$(RM) -r $(INSTALL_DIR) $(DOC_DIR) $(EXAMPLE_DIR)

doc: all
	{ printf "# Sharness API\n\n"; \
	  $(TOMDOCSH) -m -a Public $(scripts); \
	  printf "Generated by "; $(TOMDOCSH) --version; } >API.md

lint:
	shellcheck -s sh $(scripts)

test: all
	$(MAKE) -C t

.PHONY: all install uninstall doc lint test

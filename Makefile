.POSIX:

PNAME = repo-template

RTEMPLATE ?= .

all: doc mkFile

doc: docMain

cleanDoc: cleanDocMain

.DEFAULT_GOAL := all

.PHONY: all doc cleanDoc

#---Helper Macros to Remove Files---

RMDIR_IF_EMPTY := sh -c '\
if test -d $$0 && ! ls -1qA $$0 | grep -q . ; then \
	rmdir $$0; \
fi'

RM ?= rm -f

#---Generate Main Documents---

regenDocMain:
	pgot -i ":$(RTEMPLATE)" -o README.md template/README.md.got
	pgot -i ":$(RTEMPLATE)" -o LICENSE $(RTEMPLATE)/LICENSE.src/BSD-2-clause.got

.PHONY: regenDocMain

#---Generate Makefile---

Makefile: template/Makefile.got
	pgot -i ":$(RTEMPLATE)" -o $@ $<

regenMakefile:
	pgot -i ":$(RTEMPLATE)" -o Makefile template/Makefile.got

.PHONY: regenMakefile

#---Lint Helper Target---

lint:
	@find . -path ./.git -prune -or \
		-type f -and -not -name 'Makefile' \
		-exec grep -Hn '<no value>' '{}' ';'

#---TODO Helper Target---

todo:
	@find . -path ./.git -prune -or \
		-type f -and -not -name 'Makefile' \
		-exec grep -Hn TODO '{}' ';'

# vim:set noet tw=80:

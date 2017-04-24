# Name of your emacs binary
EMACS=emacs

BATCH=$(EMACS) --batch --no-init-file					\
  --eval '(require (quote org))'					\
  --eval "(org-babel-do-load-languages 'org-babel-load-languages	\
         '((shell . t)))"   						\
  --eval "(setq org-confirm-babel-evaluate nil)"			\
  --eval '(setq starter-kit-dir default-directory)'			\
  --eval '(org-babel-tangle-file "README.org")'	              		\
  --eval '(org-babel-load-file   "README.org")'

files_org  = $(wildcard resume*.org)
files_pdf  = $(addprefix pub/pdf/,$(files_org:.org=.pdf))
files_html = $(addprefix pub/html/,$(files_org:.org=.html))

all: pdf html

pdf: $(files_pdf)
pub/pdf/%.pdf: %.org
	@$(BATCH) --visit "$<" --funcall org-publish-pdf
	@rm README.el

html: $(files_html)
pub/html/%.html: %.org
	@$(BATCH) --visit "$<" --funcall org-publish-html
	@rm README.el
	@echo "NOTICE: Documentation published to pub/"

publish: html
	@find pub -name *.*~ | xargs rm -f
	@(cd pub/html && tar czvf /tmp/org-cv-publish.tar.gz .)
	@git checkout gh-pages
	@tar xzvf /tmp/org-cv-publish.tar.gz
	@if [ -n "`git status --porcelain`" ]; then git commit -am "update doc" && git push; fi
	@git checkout master
	@echo "NOTICE: HTML documentation published"

clean:
	@rm -f *.elc *.aux *.tex *.pdf *~ *.sty
	@rm -rf pub

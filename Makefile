# Name of your emacs binary
EMACS=emacs

BATCH=$(EMACS) --batch --no-init-file					\
  --eval '(require (quote org))'					\
  --eval "(org-babel-do-load-languages 'org-babel-load-languages	\
         '((sh . t)))"							\
  --eval "(setq org-confirm-babel-evaluate nil)"			\
  --eval '(setq starter-kit-dir default-directory)'			\
  --eval '(org-babel-tangle-file "README.org")'	              		\
  --eval '(org-babel-load-file   "README.org")'

FILES = resume.org

doc: pdf html

pdf: $(FILES)
	@mkdir -p pub/html/stylesheets
	@$(BATCH) --visit "$<" --funcall org-publish-pdf
	@rm README.el

html: $(FILES)
	@mkdir -p pub/html/stylesheets
	@$(BATCH) --visit "$<" --funcall org-publish-html
	@rm README.el
	@echo "NOTICE: Documentation published to pub/"
	@find pub -name *.*~ | xargs rm -f
	@(cd pub/html && tar czvf /tmp/org-cv-publish.tar.gz .)
	@git checkout gh-pages
	@tar xzvf /tmp/org-cv-publish.tar.gz
	@if [ -n "`git status --porcelain`" ]; then git commit -am "update doc" && git push; fi
	@git checkout master
	@echo "NOTICE: HTML documentation done"

clean:
	@rm -f *.elc *.aux *.tex *.pdf *~
	@rm -rf pub

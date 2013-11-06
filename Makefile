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

doc: html pdf

pdf: $(FILES)
	$(BATCH) --visit "$<" --funcall org-publish-pdf

html: $(FILES)
	mkdir -p pub/stylesheets
	$(BATCH) --visit "$<" --funcall org-publish-html
	rm README.el
	echo "NOTICE: Documentation published to pub/"

clean:
	rm -f *.elc *.aux *.tex *.pdf *~
	rm -rf pub

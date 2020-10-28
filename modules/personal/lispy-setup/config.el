;; -*- lexical-binding: t; -*-

(use-package! lispy
  :when (not (featurep! :editor parinfer)))

(use-package! evil-lispy
  :when (not (featurep! :editor parinfer))
  :after lispy
  :hook ((lisp-mode . evil-lispy-mode)
         (emacs-lisp-mode . evil-lispy-mode)
         (scheme-mode . evil-lispy-mode)
         (racket-mode . evil-lispy-mode)
         (hy-mode . evil-lispy-mode)
         (lfe-mode . evil-lispy-mode)
         (dune-mode . evil-lispy-mode)
         (clojure-mode . evil-lispy-mode)))

;; -*- no-byte-compile: t; -*-

(if (featurep! +nix)
    (progn
      (package! lispy :ignore t)
      (package! evil-lispy :ignore t))
  (progn
    (package! lispy)
    (package! evil-lispy)))

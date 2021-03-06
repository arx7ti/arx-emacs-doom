;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ilia Kamyshev"
      user-mail-address "ikdesign2015@yandex.ru")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-font (font-spec :family "monospace" :size 20))
(setq doom-theme 'doom-one)
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; screenshots

;; exwm config
(use-package! exwm-config
  :after exwm
  :init
  (defun switch-system-im ()
    (interactive)
    (start-process-shell-command "xkb-switch" nil "xkb-switch -n"))
  (defun exwm-screenshot ()
    (interactive)
    (start-process-shell-command
     "maim" nil "mkdir -p ~/screenshots/ && maim ~/screenshots/$(date +%s).png")
    (message "screenshot has been taken"))
  :config
  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset)
          ([?\s-w] . exwm-workspace-switch)
          (\,@ (mapcar (lambda (i)
                         `(,(kbd (format "s-%d" i)) .
                           (lambda ()
                             (interactive)
                             (exwm-workspace-switch-create ,i))))
                       (number-sequence 0 9)))
          (,(kbd "s-&") . (lambda (command)
                            (interactive (list (read-shell-command ">> ")))
                            (start-process-shell-command command nil command)))
          (,(kbd "s-h") . evil-window-left)
          (,(kbd "s-l") . evil-window-right)
          (,(kbd "s-j") . evil-window-down)
          (,(kbd "s-k") . evil-window-up)
          (,(kbd "s-'") . +eshell/toggle)
          (,(kbd "s-t") . +vterm/toggle)
          (,(kbd "s-v") . counsel-set-clip)
          (,(kbd "s-a") . switch-system-im)
          (,(kbd "s-/") . exwm-screenshot)))

  (when (featurep! +sim-duplicate)
    (when (featurep! :personal russian)
      (add-to-list 'exwm-input-global-keys
                   `(,(kbd "s-ф") . switch-system-im))))

  (setq exwm-workspace-number 10)
  (setq exwm-workspace-show-all-buffers t)
  (setq exwm-layout-show-all-buffers t)

  (defun exwm-rename-buffer ()
    "Update buffer name with window name."
    (interactive)
    (exwm-workspace-rename-buffer
     (concat exwm-class-name ":"
             (if (<= (length exwm-title) 50) exwm-title
               (concat (substring exwm-title 0 49) "...")))))

  (add-hook 'exwm-update-class-hook 'exwm-rename-buffer)
  (add-hook 'exwm-update-title-hook 'exwm-rename-buffer))

(use-package! exwm-systemtray
  :after exwm
  :config
  (exwm-systemtray-enable))

(use-package! exwm-xim
  :after exwm
  :init
  (when (featurep! :editor evil)
    (evil-set-initial-state 'exwm-mode 'emacs)
    (defvar s-space 8388640
      "Key value for s-SPC.")
    (defvar m-space 134217760
      "Key value for M-SPC.")
    (push ?\C-\\ exwm-input-prefix-keys)
    (push m-space exwm-input-prefix-keys))
  :config
  (exwm-xim-enable))

(use-package! exwm-randr
  :after exwm
  :config
  (setq exwm-randr-workspace-monitor-plist '(0 "DP-2"))
  (add-hook 'exwm-randr-screen-change-hook
            (lambda ()
              (start-process-shell-command
               "xrandr" nil "xrandr --output eDP-1 --left-of HDMI-1 --auto")))
  (exwm-randr-enable))

(use-package! exwm-edit
  :after exwm)

;; (add-hook 'prog-mode-hook #'rainbow-delimeters-mode-enable)

(envrc-global-mode)
(display-time-mode)
(window-divider-mode)
;; (add-to-list 'org-structure-template-alist
;;              '("j" . "src jupyter-python :async yes"))
(add-to-list 'display-buffer-alist
	     '("\\*Async Shell Command\\*.*" display-buffer-no-window))
(setq window-divider-default-right-width 3)
(setq window-divider-default-places 'right-only)
(setq shell-file-name (executable-find "zsh"))
(set-company-backend! '(hy-mode) 'company-hy)
(add-hook 'hy-mode-hook 'rainbow-delimiters-mode)
(after! lsp-haskell
  (setq lsp-haskell-process-path-hie
        (executable-find
         "haskell-language-server-wrapper")))
;;
(add-to-list 'after-make-frame-functions
             #'(lambda (frame)
                 (set-frame-parameter frame
                                      'internal-border-width 5)))


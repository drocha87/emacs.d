;; -*- lexical-binding: t -*-

(use-package leuven-theme
  :ensure t
  :config
  (load-theme 'leuven t))

(setq make-backup-files nil)
(setq backup-inhibited nil) ; Not sure if needed, given `make-backup-files'
(setq create-lockfiles nil) ; locking the file mess with tools like svelte and etc...

(setq tab-always-indent 'complete)
(setq tab-first-completion 'word-or-paren-or-punct) ; Emacs 27
(setq-default tab-width 2
              indent-tabs-mode nil)

;; Make native compilation silent and prune its cache.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent) ; Emacs 28 with native compilation
  (setq native-compile-prune-cache t)) ; Emacs 29

(use-package emacs
  :init
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
      (replace-regexp-in-string
       "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
       crm-separator)
      (car args))
    (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
  '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package dired
  :ensure nil
  :commands (dired)
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t)
  (setq dired-listing-switches
  "-AGFhlv --group-directories-first --time-style=long-iso"))

(use-package dired-x
  :ensure nil
  :after dired
  :bind
  ( :map dired-mode-map
    ("I" . dired-info))
  :config
  (setq dired-clean-up-buffers-too t)
  (setq dired-clean-confirm-killing-deleted-buffers t)
  (setq dired-x-hands-off-my-keys t)    ; easier to show the keys I use
  (setq dired-bind-man nil)
  (setq dired-bind-info nil))

(require 'eglot)
(require 'ui)
(require 'completion)
(require 'packages)
(require 'web)
(require 'duplicate-region)
(require 'drocha)
(require 'keybindings)
(require 'spell)
(require 'dr-treesit)
(require 'javascript)

(put 'upcase-region 'disabled nil)

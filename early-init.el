(setq load-path (cons (concat user-emacs-directory "lisp") load-path))

(require 'ui)

;; disable lock files since it is messing up with my svelte project
(setq create-lockfiles nil)

;; Emacs adds `custom' settings in the init file by default. Run this file
;; without this segment to see what that means.
;; Put those away in "custom.el".
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file :noerror)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(require 'package)
(package-initialize)
(custom-set-variables '(use-package-enable-imenu-support t))
(eval-when-compile (require 'use-package))
;; Initialise installed packages
(setq package-enable-at-startup t)
;; Allow loading from the package cache
(setq package-quickstart t)

(setq native-comp-async-report-warnings-errors 'silent) ; emacs28 with native compilation
(defalias 'yes-or-no-p 'y-or-n-p)

(require 'backup)

(setq load-path (cons (concat user-emacs-directory "lisp") load-path))

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

;; the code below was copied from protesilaos emacs config
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Same idea as above for the `file-name-handler-alist' and the
;; `vc-handled-backends' with regard to startup speed optimisation.
;; Here I am storing the default value with the intent of restoring it
;; via the `emacs-startup-hook'.
(defvar prot-emacs--file-name-handler-alist file-name-handler-alist)
(defvar prot-emacs--vc-handled-backends vc-handled-backends)

(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 1000 1000 8)
                  gc-cons-percentage 0.1
                  file-name-handler-alist prot-emacs--file-name-handler-alist
                  vc-handled-backends prot-emacs--vc-handled-backends)))

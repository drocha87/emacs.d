;; (load-theme 'ef-duo-light t)
;; (load-theme 'ef-elea-dark t)
;; (load-theme 'kanagawa t)
;; (load-theme 'gruber-darker t)
;;(load-theme 'zenburn t)
(use-package leuven-theme
	:ensure t
	:config
	(load-theme 'leuven t))

(setq-default tab-width 2)

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

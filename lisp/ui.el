(setq frame-resize-pixelwise t
			frame-inhibit-implied-resize t
			frame-title-format '("%b")
			ring-bell-function 'ignore
			use-dialog-box t ; only for mouse events, which I seldom use
			use-file-dialog nil
			use-short-answers t
			inhibit-splash-screen t
			inhibit-startup-screen t
			inhibit-x-resources t
			inhibit-startup-echo-area-message user-login-name ; read the docstring
			inhibit-startup-buffer-menu t
			initial-scratch-message nil)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(global-hl-line-mode 1)
(delete-selection-mode 1)

(set-face-attribute 'default nil :font "Ubuntu Mono" :height 150)

(dolist (var '(default-frame-alist initial-frame-alist))
	(add-to-list var '(width . (text-pixels . 1200)))
	(add-to-list var '(height . (text-pixels . 900))))

;;; General window and buffer configurations
(use-package uniquify
	:ensure nil
	:config
	(setq uniquify-buffer-name-style 'forward)
	(setq uniquify-strip-common-suffix t)
	(setq uniquify-after-kill-buffer-p t))

(use-package whitespace
	:ensure nil
	:bind
	(("<f6>" . whitespace-mode)))

;; (global-display-line-numbers-mode 1)
;;; Line numbers on the side of the window
(use-package display-line-numbers
	:ensure nil
	:bind
	("<f7>" . display-line-numbers-mode)
	:config
	(setq-default display-line-numbers-type t)
	;; Those two variables were introduced in Emacs 27.1
	(setq display-line-numbers-major-tick 0)
	(setq display-line-numbers-minor-tick 0)
	;; Use absolute numbers in narrowed buffers
	(setq-default display-line-numbers-widen t))

(provide 'ui)

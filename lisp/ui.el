(custom-set-variables
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(scroll-bar-mode nil)
 '(use-dialog-box nil)
 '(ring-bell-function #'ignore)
 '(global-hl-line-mode t)
 '(delete-selection-mode 1)
 '(tab-bar-show nil))

(set-face-attribute 'default nil :font "Jetbrains Mono" :height 140)

(dolist (var '(default-frame-alist initial-frame-alist))
	(add-to-list var '(width . (text-pixels . 1200)))
	(add-to-list var '(height . (text-pixels . 900))))

(setq frame-resize-pixelwise t
			frame-inhibit-implied-resize t)

(global-display-line-numbers-mode 1)

(provide 'ui)

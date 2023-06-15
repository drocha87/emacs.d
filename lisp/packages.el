(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package crux
  :ensure t
  :config
  (global-set-key [remap move-beginning-of-line] #'crux-move-beginning-of-line)
  (global-set-key (kbd "C-k") #'crux-smart-kill-line)
  (global-set-key [(ctrl return)] #'crux-smart-open-line))

(use-package move-text
  :ensure t
  :config
  (move-text-default-bindings)
  (defun indent-region-advice (&rest ignored)
    (let ((deactivate deactivate-mark))
      (if (region-active-p)
          (indent-region (region-beginning) (region-end))
	(indent-region (line-beginning-position) (line-end-position)))
      (setq deactivate-mark deactivate)))
  (advice-add 'move-text-up :after 'indent-region-advice)
  (advice-add 'move-text-down :after 'indent-region-advice))

(use-package magit
	:ensure t
	:config
	(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

(use-package expand-region
	:ensure t
	:config
	(global-set-key (kbd "C-=") 'er/expand-region))

(provide 'packages)

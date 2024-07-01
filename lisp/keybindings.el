(global-set-key [C-backspace] 'drocha/backward-kill-word)
(global-set-key [C-delete] 'drocha/forward-kill-word)
(global-set-key (kbd "C-j") 'delete-indentation)

(with-eval-after-load 'eglot
	(progn
		(global-set-key (kbd "C-.") 'eglot-code-actions)))

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))
(duplicate-region-default-bindings)

(provide 'keybindings)

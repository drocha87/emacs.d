(use-package emmet-mode
	:ensure t
	:config
	;; don't take c-return from me son of a ...
	(define-key emmet-mode-keymap (kbd "C-<return>") nil)
	(add-hook 'web-mode-hook 'emmet-mode)
	(add-hook 'mhtml-mode-hook 'emmet-mode)
	(add-hook 'sgml-mode-hook 'emmet-mode)
	(add-hook 'css-mode-hook 'emmet-mode))

(defface drocha/web-mode-current-element-highlight-face
    '((t :background "#ccefcf" :foreground "#222222"))
  "Overlay face for element highlight improved by me"
  :group 'web-mode-faces)

(defun drocha/web-mode-current-element-highlight-face-remap ()
	(face-remap-add-relative
	 'web-mode-current-element-highlight-face 
	 'drocha/web-mode-current-element-highlight-face))

(use-package web-mode
	:ensure t
	:config
	(setq web-mode-markup-indent-offset 2)
	(setq web-mode-css-indent-offset 2)
	(setq web-mode-code-indent-offset 2)
	(setq web-mode-comment-style 2)
	;; (setq web-mode-enable-auto-indentation nil)
	(setq web-mode-enable-css-colorization t)
	;; (setq web-mode-enable-block-face t)
	(setq web-mode-enable-comment-keywords t)
	;; (setq web-mode-enable-heredoc-fontification t)
	(setq web-mode-enable-current-element-highlight t)

	(advice-add 'web-mode-make-tag-overlays :after #'drocha/web-mode-current-element-highlight-face-remap)
	(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode)))

(define-derived-mode svelte-mode web-mode "svelte"
	"Major mode used just to spin the svelte language server using eglot")

(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-mode))
(add-to-list 'auto-mode-alist '("\\.ts?\\'" . typescript-ts-mode))

;; don't forget to install the typescript language server with the command:
;; npm install -g typescript-language-server typescript
;; (add-to-list 'eglot-server-programs '(typescript-ts-mode . ("tsserver" "--stdio")))

;; don't forget to install the svelte language server with the command:
;; npm i -g svelte-language-server
(add-to-list 'eglot-server-programs '(svelte-mode . ("svelteserver" "--stdio")))

;; (add-hook 'typescript-ts-mode 'eglot-ensure)
;; (add-hook 'svelte-mode 'eglot-ensure)

;; (use-package mhtml-mode
;; 	:config
;; 	(add-to-list 'auto-mode-alist '("\\.svelte\\'" . mhtml-mode))
;; 	(add-to-list 'auto-mode-alist '("\\.html\\'" . mhtml-mode)))

(provide 'web)

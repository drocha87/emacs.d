;; -*- lexical-binding: t -*-

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
(global-auto-revert-mode 1)
(global-hl-line-mode 1)
(delete-selection-mode 1)

(set-face-attribute 'default nil :font "Ubuntu Mono" :height 150)
;;(set-face-attribute 'default nil :font "Iosevka" :height 160)

(dolist (var '(default-frame-alist initial-frame-alist))
  (add-to-list var '(width . (text-pixels . 1200)))
  (add-to-list var '(height . (text-pixels . 900))))

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; THEMES
(use-package leuven-theme :ensure t)
(use-package ef-themes :ensure t)

(load-theme 'ef-eagle t)

;;; General window and buffer configurations
(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix nil)
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

(defun drocha/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is white space, otherwise remove a word."
  (interactive)
  (if (bolp) ; if beginning of line just join the line with the previous one
      (join-line)
    (let ((s (string (preceding-char))))
      (cond
       ((string-match-p "[[:space:]]" s) (delete-horizontal-space 't))
       ((string-match-p "[[:alnum:]]" s) (backward-kill-word 1))
       (t (backward-delete-char 1))))))

(defun drocha/forward-kill-word ()
  "Remove all white space if the character in front of the cursor is white space, otherwise remove a word."
  (interactive)
  (if (eolp)
      (delete-char 1)
    (let ((s (string (following-char))))
      (cond
       ((string-match-p "[[:space:]]" s) (delete-horizontal-space))
       ((string-match-p "[[:alnum:]]" s) (kill-word 1))
       (t (delete-char 1))))))

(global-set-key [C-backspace] 'drocha/backward-kill-word)
(global-set-key [C-delete] 'drocha/forward-kill-word)
(global-set-key (kbd "C-j") 'delete-indentation)

;; use ESC as C-g as I'm used to esc as cancel
(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(setq treesit-language-source-alist
      '((go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.4" "typescript/src")))

(use-package go-ts-mode
  :ensure nil
  :config
  (setq go-ts-mode-indent-offset 2))

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
  ;; :config
  ;; (apheleia-global-mode +1)
  )

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  (vertico-multiform-mode))

(use-package prescient
  :ensure t)

(use-package vertico-prescient
  :ensure t
  :init
  (vertico-prescient-mode 1)
  (prescient-persist-mode 1)
  (setq prescient-filter-method '(literal initialism prefix regexp)
        prescient-use-char-folding t
        prescient-use-case-folding 'smart
        prescient-sort-full-matches-first t ; Works well with `initialism'.
        prescient-sort-length-enable t)

  ;; Save recency and frequency rankings to disk, which let them become better
  ;; over time.
  (prescient-persist-mode 1))

;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 3. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  ;;;; 4. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 5. No project support
  ;; (setq consult-project-function nil)
)

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                       ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                        ;; Enable auto completion
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary 'separator)   ;; Never quit at completion boundary
  (corfu-preview-current 'insert)       ;; Disable current candidate preview
  (corfu-preselect 'prompt)             ;; Preselect the prompt
  (corfu-on-exact-match nil)            ;; Configure handling of exact matches
  (corfu-scroll-margin 5)               ;; Use scroll margin
  ;; (corfu-separator ?\s)              ;; Orderless field separator
  ;; (corfu-quit-no-match nil)          ;; Never quit, even if there is no match
  :bind (:map corfu-map
              ("M-SPC" . corfu-insert-separator)
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

(use-package corfu-prescient
  :ensure t
  :init
  (corfu-prescient-mode 1))

(add-hook 'js-ts-mode-hook
  (lambda ()
    (setq js-indent-level 2)))

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
  (setq web-mode-script-padding 2)
  ;; (setq web-mode-enable-block-face t)
  (setq web-mode-enable-comment-keywords t)
  ;; (setq web-mode-enable-heredoc-fontification t)
  (setq web-mode-enable-current-element-highlight t)

  (advice-add 'web-mode-make-tag-overlays :after #'drocha/web-mode-current-element-highlight-face-remap)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode)))

(add-to-list 'auto-mode-alist '("\\.ts?\\'" . typescript-ts-mode))

(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'whitespace-cleanup nil 'local)))

;; install enchant libenchant-2-dev
;; to add Spanish and Brazilian Portuguese dictionaries install
;; the packages hunspell-es and  hunspell-pt-br você
(use-package jinx
  :ensure t
  :after vertico
  :bind (("C-;" . jinx-correct)
         ("C-M-$" . jinx-languages))
  :custom
  (jinx-camel-modes '(prog-mode))
  (jinx-delay 0.1)
  :init
  (setq jinx-languages "pt_BR en_US es_CO")
  (global-jinx-mode 1)
  (add-to-list 'vertico-multiform-categories
               '(jinx grid (vertico-grid-annotate . 20))))

(require 'duplicate-region)
(duplicate-region-default-bindings)

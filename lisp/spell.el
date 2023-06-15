;; install enchant libenchant-2-dev
;; to add Spanish and Brazilian Portuguese dictionaries install
;; the packages hunspell-es and  hunspell-pt-br você 

(use-package jinx
	:ensure t
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

(provide 'spell)

(defun drocha/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
	(if (bolp) ; if beggining of line just join the line with the previous one
			(join-line)
		(let ((s (string (preceding-char))))
			(cond
			 ((string-match-p "[[:space:]]" s) (delete-horizontal-space 't)) 
			 ((string-match-p "[[:alnum:]]" s) (backward-kill-word 1))
 			 (t (backward-delete-char 1))))))

(defun drocha/forward-kill-word ()
  "Remove all whitespace if the character in front of the cursor is whitespace, otherwise remove a word."
  (interactive)
	(if (eolp)
			(delete-char 1)
		(let ((s (string (following-char))))
			(cond
			 ((string-match-p "[[:space:]]" s) (delete-horizontal-space))
			 ((string-match-p "[[:alnum:]]" s) (kill-word 1))
			 (t (delete-char 1))))))

(provide 'drocha)

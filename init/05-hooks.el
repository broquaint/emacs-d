(defun my-mkdir-at-before-save ()
  (let ((current-dir (file-name-directory (buffer-file-name))))
    (if (not (file-directory-p current-dir))
        (make-directory current-dir t))))

;; Just make the directory already.
(add-hook 'before-save-hook 'my-mkdir-at-before-save)


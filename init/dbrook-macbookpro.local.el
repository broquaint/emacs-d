;; via http://batsov.com/articles/2012/10/14/emacs-on-osx/
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

; (setq org-directory "~/Dev/org")
; (setq org-default-notes-file (concat org-directory "/ad-hoc-notes.org"))

(defun add-manual-dep-path (dep)
  (add-to-list 'load-path (concat "~/.emacs.d/manual-dependencies/" dep)))

;; via http://stackoverflow.com/questions/3977069/emacs-question-hash-key
;; Allow hash to be entered
(global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

(global-set-key (kbd "M--") '(lambda () (interactive) (insert "–")))
(global-set-key (kbd "M-_") '(lambda () (interactive) (insert "—")))

;; Don't want these on a Mac
(global-unset-key (kbd "C-x C-c")) 
(global-unset-key (kbd "C-x C-z"))
;; Keep hitting this instead of M-b, maybe should have them be the same.
(global-unset-key (kbd "M-v"))
;; If I want to close a frame I'll close the frame manually.
(global-unset-key (kbd "s-w"))
;; If I need to close Emacs I'd prefer to consciously do it through the menu
;; rather than allow a slip of the fingers on Cmd-q.
(global-unset-key (kbd "s-q"))

(require 'calc)
(define-key calc-mode-map (kbd "#") 'calcDigit-start)

;; Fira Code with lovely ligatures:
;; https://github.com/tonsky/FiraCode/wiki/Setting-up-Emacs
(when (window-system)
  (set-default-font "Fira Code"))

;; !!! Can't use this as it can cause Emacs to lock up ;_;
;; ??? Trying out a couple experimentally ...
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               ;; (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               ;; (36 . ".\\(?:>\\)")
               ;; (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               ;; (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               ;; (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               ;; (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               ;; (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               ;; (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               ;; (48 . ".\\(?:x[a-zA-Z]\\)")
               ;; (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               ;; (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               ;; (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               ;; (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               ;; ;; DO NOT UNCOMMENT, causes Emacs to lock up for some reason ;_;
               ;; ; (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               ;; (91 . ".\\(?:]\\)")
               ;; (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               ;; (94 . ".\\(?:=\\)")
               ;; (119 . ".\\(?:ww\\)")
               ;; (123 . ".\\(?:-\\)")
               ;; (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               ;; (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))


(defun sql-beautify-region (beg end)
    "Beautify SQL in region between beg and END.
Dependency:
npm i -g sql-formatter-cli"
    (interactive "r")
    (save-excursion
      (shell-command-on-region beg end "sql-formatter-cli" nil t)))
(defun sql-beautify-buffer ()
  "Beautify SQL in buffer."
  (interactive)
  (sql-beautify-region (point-min) (point-max)))

;; (add-hook 'sql-mode-hook '(lambda ()
;;                             ;; beautify region or buffer
;;                             (local-set-key (kbd "C-c t") 'sql-beautify-region)))

;; Setup for celestial-mode-line
(setq calendar-longitude -0.12)
(setq calendar-latitude  51.49)
(setq calendar-location-name "London")
(require 'celestial-mode-line)
(setq global-mode-string '("" celestial-mode-line-string display-time-string))
(celestial-mode-line-start-timer)

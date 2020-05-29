;; Get access to all the command line juiciness too.
;; And make sure it happens before everything else loads.
;; via https://github.com/purcell/exec-path-from-shell
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; via http://batsov.com/articles/2012/10/14/emacs-on-osx/
(setq mac-command-modifier 'super)
(setq mac-option-modifier 'meta)

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
;; via https://github.com/tonsky/FiraCode/wiki/Emacs-instructions#using-composition-char-table
(when (window-system)
  (set-frame-font "Fira Code"))

;; One of the commented out ligatures sends Emacs into a spin :/
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               ;; Dropping this because it makes the three asterisks from make errors look odd.
;               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               ;; Dropping this because ++ messes with magit diff stat
;               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
;               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
;               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
;               (58 . ".\\(?:::\\|[:=]\\)")
;               (59 . ".\\(?:;;\\|;\\)")
;               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
;               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
;               (91 . ".\\(?:]\\)")
;               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
;               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
;               (123 . ".\\(?:-\\)")
;               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

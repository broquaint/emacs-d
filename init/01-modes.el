;; TODO apply use-packagae in anger
;; https://github.com/jwiegley/use-package

(require 'org)
(setq org-todo-keywords '((sequence "TODO" "DOING" "DONE")))
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; via https://yiufung.net/post/org-mode-hidden-gems-pt1/
(setq org-catch-invisible-edits 'show-and-error)

;; http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; (with-eval-after-load 'lsp-mode
;;   (require 'lsp-intellij)
;;   (add-hook 'java-mode-hook #'lsp-intellij-enable)
;;   (require 'lsp-ui)
;;   (add-hook 'lsp-mode-hook 'lsp-ui-mode))

; (require 'groovy-mode)
; (add-to-list 'auto-mode-alist '("\\.gradle$" . groovy-mode))

;; mode hooks
(require 'cperl-mode)
(defun setup-cperl-mode () 
  (message "Setting up cperl-mode preferences ...")
  (setq cperl-invalid-face nil)
  (setq cperl-pod-here-scan t)
  (setq cperl-pod-here-fontify t)
  (setq cperl-indent-parens-as-block t)
  (setq cperl-close-paren-offset -4)
  (cperl-find-pods-heres)
  (cperl-set-style "K&R")
  (setq cperl-indent-level 4)
  (set (make-local-variable 'eldoc-documentation-function)
       'my-cperl-eldoc-documentation-function)
;  (turn-on-eldoc-mode)

  ;; Useful when searching through files with large functions.
  ;; via http://emacsredux.com/blog/2014/04/05/which-function-mode/
  (which-function-mode)

  (define-key cperl-mode-map (kbd "RET") 'newline-and-indent)

  ;; Why "lightyellow2" molokai, why???
  (set-face-background 'cperl-hash-face  "inherit")
  (set-face-background 'cperl-array-face "inherit")

  (message "Finished setting cperl-mode preferences")
  ;; auto-show flymake help - http://www.emacswiki.org/emacs/FlymakeCursor
  ;; (custom-set-variables
  ;;    '(help-at-pt-timer-delay 0.9)
  ;;    '(help-at-pt-display-when-idle '(flymake-overlay)))
)

(add-hook 'cperl-mode-hook 'setup-cperl-mode)

(add-to-list 'auto-mode-alist '("\\.t$" . cperl-mode))

(defun cperl-perldoc-current-file ()
  (interactive)
  (cperl-perldoc buffer-file-name))

(defun my-perl-deparse ()
  (interactive)
  (shell-command-on-region (region-beginning) (region-end)
                           "perl -MO=Deparse,-p - 2>&1 | grep -v 'syntax OK'" nil t))

(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;; via http://www.emacswiki.org/emacs/CPerlMode#toc10
(defun my-cperl-eldoc-documentation-function ()
      "Return meaningful doc string for `eldoc-mode'."
      (car
       (let ((cperl-message-on-help-error nil))
         (cperl-get-help))))

(defun my-pod-for-current-file ()
  (interactive)
  (cperl-perldoc buffer-file-name))

;; (require 'pod-mode)
;; (add-to-list 'auto-mode-alist '("\\.pod$" . pod-mode))
;; (add-hook 'pod-mode-hook 'font-lock-mode)

;; XXX Disabled for Venda code, enable when it compiles or a workaround is figured out.
;;(add-hook 'cperl-mode-hook
;;	  (lambda () (flymake-mode 1)))

;; via https://github.com/rafl/dotemacs/blob/master/40-cperl-mode.el
;; (defadvice flymake-perl-init (around flymake-eproject-perl5lib)
;;   (let* ((project-root (ignore-errors (eproject-maybe-turn-on)))
;;          (ret ad-do-it)
;;          (args (cadr ret)))
;;     (when project-root
;;       (setcdr ret (list (cons (concat "-I" project-root "lib") args))))
;;     ret))

;; (ad-activate 'flymake-perl-init)

;; (require 'tt-mode)
;; (setq auto-mode-alist
;;   (append '(("\\.tt$" . tt-mode))  auto-mode-alist ))
;; (setq auto-mode-alist
;;   (append '(("\\.tt2$" . tt-mode))  auto-mode-alist ))

;; for ruby-mode-hook
(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
; (require 'rvm)

;; Adds its own ruby-mode-hook callback.
;; (require 'ruby-end)
;; (add-hook 'ruby-mode-hook
;;           #'(lambda()
;;               ; (rvm-use-default) - Fails horribly in the face of non-defaults!
;;               (setq ruby-indent-level 2)
;;               (make-variable-buffer-local 'compilation-error-regexp-alist)
;;               (setq compilation-error-regexp-alist 
;;                     (append compilation-error-regexp-alist 
;;                             (list (list  
;;                                    (concat "\\(.*?\\)\\([0-9A-Za-z_./\:-]+\\.rb\\):\\([0-9]+\\)") 2 3))))
;;               (make-variable-buffer-local 'compile-command)
;;               (setq compile-command (concat "ruby " (buffer-file-name) " "))
;;               ;; Sane post-parent indenting via https://gist.github.com/fujin/5173680
;;               (setq ruby-deep-indent-paren nil)))

;; (defun my-ruby-to-new-hash-style (r-begin r-end)
;;   (interactive "r")
;;   (perform-replace ":\\([a-z]+\\) =>" "\\1:" nil t nil nil nil r-begin r-end)
;;   (align r-begin r-end))

(require 'markdown-mode)
; Why this isn't a default is beyond me.
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

(autoload 'css-mode "css-mode" "Mode for editing CSS files" t)
(setq auto-mode-alist
      (append '(("\\.css$" . css-mode))
              auto-mode-alist))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-hook 'web-mode-hook #'(lambda () 
                             (setq web-mode-markup-indent-offset 2)
                             (setq web-mode-disable-auto-pairing nil)))

(require 'js2-mode)
; This doesn't seem to work.
; (autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; via https://www.emacswiki.org/emacs/Js2Mode#toc4
(add-hook 'js2-post-parse-callbacks
          (lambda ()
            (when (> (buffer-size) 0)
              (let ((btext (replace-regexp-in-string
                            ": *true" " "
                            (replace-regexp-in-string "[\n\t ]+" " " (buffer-substring-no-properties 1 (buffer-size)) t t))))
                (mapc (apply-partially 'add-to-list 'js2-additional-externs)
                      (split-string
                       (if (string-match "/\\* *global *\\(.*?\\) *\\*/" btext) (match-string-no-properties 1 btext) "")
                       " *, *" t))))))

(require 'nodejs-repl)
;; (setq nodejs-repl-command "~/apps/bin/node")

;; (require 'coffee-mode)
;; (setq coffee-tab-width 2)

;; via https://coderwall.com/p/mmr_hw
;; (add-hook 'align-load-hook
;;           (lambda ()
;;             (add-to-list
;;              'align-rules-list
;;              '(symbol-value-alignment
;;                (regexp . ":\\(\\s-*\\)")
;;                (group . 1)
;;                (modes . '(ruby-mode coffee-mode))
;;                (repeat . nil)))))

; (require 'prolog)
; (setq prolog-system 'swi)

(defun my-use-paredit ()
  (paredit-mode +1))
;; via http://emacswiki.org/emacs/ParEdit
(autoload 'paredit-mode "paredit"
   "Minor mode for pseudo-structurally editing Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       'my-use-paredit)
(add-hook 'lisp-mode-hook             'my-use-paredit)
(add-hook 'lisp-interaction-mode-hook 'my-use-paredit)
; (add-hook 'scheme-mode-hook           'my-use-paredit)
(add-hook 'clojure-mode-hook          'my-use-paredit)
; (add-hook 'nrepl-repl-mode-hook       'my-use-paredit)
; (add-hook 'cider-mode-hook            'my-use-paredit)
(add-hook 'ielm-mode-hook             'my-use-paredit)

(autoload 'rainbow-delimiters "rainbow-delimiters")
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Eldoc FTW
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
; (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

; http://www.emacswiki.org/emacs/AnsiColor
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

; (require 'tbemail)

; (require 'textile-minor-mode)
; (add-to-list 'auto-mode-alist '("itsalltext/support.*\\.txt$" . textile-minor-mode))

;; XXX When the .txt file loads everything is fine but if I go to edit
;; ~/.emacs I start seeing errors, no idea why ;_;
; (require 'moinmoin-mode)
;; This colour only availble in GUI mode.
; (set-face-foreground 'moinmoin-url  "royal blue")
; (set-face-foreground 'moinmoin-url-title  "royal blue")
; (add-to-list 'auto-mode-alist '("itsalltext/docs.*\\.txt$" . moinmoin-mode))

; (require 'ack-and-a-half)
;; I often only want to search sub-directories.
;; XXX Should probably extend to make this optional somehow.
; (setq ack-and-a-half-prompt-for-directory t)

;; Installed this by hand, it's only on MELPA which I don't want to go near.
; (require 'git-timemachine)

(require 'tramp)
(setq tramp-default-method "ssh")
(setq tramp-default-user "dbrook")

(require 'projectile)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
; (projectile-global-mode)
;; I don't want all possible files just what git knows about.
(setq projectile-git-command "git ls-files -zc")

(require 'persistent-scratch)
(persistent-scratch-setup-default)
;; This creates a lock and emacs fights itself for the file, it gets
;; very annoying having a forced s/p/q prompt frequently.
(add-hook 'persistent-scratch-autosave-mode-hook 'persistent-scratch--turn-autosave-off)

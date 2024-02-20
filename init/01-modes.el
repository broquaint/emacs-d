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

;; Nice simple modeline. Does what it says on the tin.
;; (require 'simple-modeline)
;; (simple-modeline-mode 1)

(require 'lua-mode)
(add-to-list 'auto-mode-alist '("\\.p8\\'" . lua-mode))

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

;; for ruby-mode-hook
(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))

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
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq-default js2-basic-offset 2)

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

(setq auto-mode-alist
      (append '(("\\.mal$" . clojure-mode))
              auto-mode-alist))

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

;; Go to the end of *Compilation* output.
(setq compilation-scroll-output t)

;; General settings
; (iswitchb-mode t)
(blink-cursor-mode t)
(show-paren-mode t)

;; Have *scatch* be empty
(setq initial-scratch-message nil)

;; A bigger kill ring, 60 is a painfully small default.
(setq kill-ring-max 500)

;; Trust that compile command is correct.
;; XXX TODO - Make this mode depdendent.
(setq compilation-read-command nil)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(setq-default transient-mark-mode t)

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; No tabs please! http://www.emacswiki.org/emacs/NoTabs
(setq-default indent-tabs-mode nil)

;; uniq buffer names.
(require 'uniquify) 
(setq uniquify-buffer-name-style 'forward)

;; Remember where I was when I open previously killed buffers.
(require 'saveplace)

(require 'smooth-scrolling)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)
(menu-bar-mode -1)

;; Save buffer state between emacs session. Useful for reboots and what not.
(desktop-save-mode 1)

;; Make line numbers align a bit nicer.
(setq linum-format "%4d ")

;; via http://twitter.com/emacs_knight/statuses/151214372214157312
(setq echo-keystrokes 0.1)

(load-theme 'molokai t)

(require 'auto-dim-other-buffers)
;; As recommended by the docs.
(add-hook 'after-init-hook (lambda ()
                             (when (fboundp 'auto-dim-other-buffers-mode)
                               (auto-dim-other-buffers-mode t))))

;; TODO - Have this DTRT in server mode.

;; Rough guess as to term vs. GUI mode.
(if window-system
    ; via http://emacs-fu.blogspot.com/2009/12/scrolling.html
    (progn
      (mwheel-install)
      (menu-bar-mode 1)
      (tool-bar-mode -1)
      (set-scroll-bar-mode 'right)
      (setq
        scroll-margin 0
        scroll-conservatively 100000
        scroll-preserve-screen-position 1)
;      (require 'main-line)
      (set-face-attribute 'mode-line nil :box nil)
      (global-unset-key "\C-z")) ; Why would I want Ctrl-z to minimize?
    (progn
      (set-face-background 'region "brightblack")
      (set-face-background 'default "unspecified-bg")
      ;; Deal with the fact that TERM=xterm-256color monkeys with End.
      (define-key global-map [select] 'end-of-line)
      ;; Stop quitting accidentally you fool.
      (global-unset-key "\C-x\C-c")
      (global-set-key "\C-x\C-c\C-c\C-c" 'save-buffers-kill-terminal)))

;; Turn on highlighting globally
(global-font-lock-mode t)

;; column numbering
(column-number-mode t)

;; https://twitter.com/EmacsHaiku/status/373514565222285312
;(inhibit-startup-screen t)
;; via http://www.emacswiki.org/emacs/PopularOptions
(file-name-shadow-mode t)
;; (confirm-kill-emacs t)

(put 'narrow-to-region 'disabled nil)

(defalias 'yes-or-no-p 'y-or-n-p)

;; Clearing out a buffer can be super handy e.g *scratch* type buffers.
(put 'erase-buffer 'disabled nil)

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

; (require 'epa-file)
; (epa-file-enable)

;; https://news.ycombinator.com/item?id=21641255
(setq-default garbage-collection-messages t)

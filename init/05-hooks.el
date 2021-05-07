;; -*- lexical-binding: t -*-

(defun my-mkdir-at-before-save ()
  (let ((current-dir (file-name-directory (buffer-file-name))))
    (if (not (file-directory-p current-dir))
        (make-directory current-dir t))))

;; Just make the directory already.
(add-hook 'before-save-hook 'my-mkdir-at-before-save)

(autoload 'paredit-mode "paredit"
  "Minor mode for pseudo-structurally editing Lisp code." t)

(let ((use-pe (lambda () (paredit-mode +1))))
  (progn
    ;; via http://emacswiki.org/emacs/ParEdit
    (add-hook 'emacs-lisp-mode-hook       use-pe)
    (add-hook 'lisp-mode-hook             use-pe)
    (add-hook 'lisp-interaction-mode-hook use-pe)
    (add-hook 'clojure-mode-hook          use-pe)
    (add-hook 'ielm-mode-hook             use-pe)))

(autoload 'rainbow-delimiters "rainbow-delimiters")
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)

;; Eldoc FTW
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
; (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

; http://www.emacswiki.org/emacs/AnsiColor
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'rust-mode 'electric-pair-mode)

;; via https://endlessparentheses.com/ansi-colors-in-the-compilation-buffer-output.html
(require 'ansi-color)

(let ((colorize-compilation (lambda ()
                              "Colorize from `compilation-filter-start' to `point'."
                              (let ((inhibit-read-only t))
                                (ansi-color-apply-on-region
                                 compilation-filter-start (point))))))
  (progn
    (add-hook 'compilation-filter-hook colorize-compilation)
    (add-hook 'shell-command-with-editor-mode-hook colorize-compilation)))


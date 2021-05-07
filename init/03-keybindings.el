;; 2C (two column) mode is neat but annoying when I fat finger.
; (global-unset-key (kbd "F2 F2"))

(defun my-scroll-up   ()  (interactive) (scroll-up   1))
(defun my-scroll-down ()  (interactive) (scroll-down 1))

;; Scroll the view without moving the cursor's position.
;; XXX This conflicts with LOTS of existing mode key bindings
(global-set-key "\M-n"  'my-scroll-up)
(global-set-key "\M-p"  'my-scroll-down)

;; This was getting *really* annoying
(require 'info)
(define-key Info-mode-map [remap clone-buffer] 'my-scroll-up)
(define-key Info-mode-map (kbd "M-p") 'my-scroll-down)

;; Use hippie-expand instead of dabbrev-expand
(global-set-key (kbd "M-/") 'hippie-expand)

; (require 'ace-jump-mode)
; (global-set-key (kbd "C-c SPC") 'ace-jump-mode)
 
(require 'goto-last-change)
(global-set-key (kbd "C-x C-\\") 'goto-last-change)

;; The slightly fancier ibuffer is nicer than buffer-list
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; https://github.com/nonsequitur/smex/
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; I use magit-status enough that typing it out got tedious.
(global-set-key (kbd "C-c m g") 'magit-status)
(global-set-key (kbd "C-c m b") 'magit-blame-mode)

; Install seems borked :/
; (global-set-key (kbd "C-c g g") 'git-gutter:toggle)

;; Should probably make projectile do this somehow.
(global-set-key (kbd "C-c v g") 'vc-git-grep)
(global-set-key (kbd "C-c g f") 'grep-for-method-calls)

;; Use a prefix as emacs doesn't understand Modifier + arrow in terminals.
;; That can be fixed with more code but this WFM.
(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

;; Elispery
(global-set-key (kbd "C-c e r") 'eval-region)
(global-set-key (kbd "C-c f r") 'revert-buffer)

;; Useful org
(global-set-key (kbd "C-c o s") 'org-store-link)

(defun pipe-region-through-shell (b e command)
  (interactive "r\nsApply command to region: ")
  (shell-command-on-region b e command (current-buffer) t))

;; I do this all the time
(global-set-key (kbd "C-c s s") 'pipe-region-through-shell)

(defun run-perl-on-region (b e code args)
  (let ((perl-cmd (format "perl %s '%s'" args code)))
    (shell-command-on-region b e perl-cmd (current-buffer) t)))
;; TODO Consider prompting for args too.
(defun pipe-region-through-perl-normal (b e code)
  (interactive "r\nsApply perl to whole region: ")
  (run-perl-on-region b e code "-E"))
(defun pipe-region-through-perl-print (b e code)
  (interactive "r\nsApply perl to lines in region: ")
  (run-perl-on-region b e code "-pE"))

;; And this more specifically.
(global-set-key (kbd "C-c s p e") 'pipe-region-through-perl-normal)
(global-set-key (kbd "C-c s p p") 'pipe-region-through-perl-print)

;; I do this pretty regularly, might want to limit to scratch buffers.
(global-set-key (kbd "C-c e b") 'erase-buffer)

;; I don't write mail using Emacs (yet).
(global-unset-key (kbd "C-x m"))

;; Assumes the Compilation buffer has been setup already.
(defun my-quick-rerun ()
  (interactive)
  (progn
    ;; Don't prompt to save the current file, just recompile.
    (setq buffer-save-without-query t)
    (recompile)))
(global-unset-key (kbd "C-\\"))
(global-set-key (kbd "C-\\") 'my-quick-rerun)

(defun join-region (beg end)
  "Apply join-line over region."
  (interactive "r")
  (if mark-active
      (let ((beg (region-beginning))
            (end (copy-marker (region-end))))
        (goto-char beg)
        (while (< (point) end)
          (join-line 1)))))

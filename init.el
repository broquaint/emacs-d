(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Have managed customizations live in a separate file.
;; And have it per system as different places have different customizations.
(setq custom-file (concat "~/.emacs.d/init/custom/" system-name ".el"))
(if (file-exists-p custom-file)
 (load custom-file nil t))

;; Ensure all packages that have been manually installed remain installed.
(mapcar
 (lambda (package)
   (unless (package-installed-p package)
     (package-install package)))
 package-selected-packages)

(load "~/.emacs.d/init/01-modes.el")
(load "~/.emacs.d/init/02-settings.el")
(load "~/.emacs.d/init/03-keybindings.el")
(load "~/.emacs.d/init/05-hooks.el")

;; Tweaks that happen only on this system.
(let ((system-init (concat "~/.emacs.d/init/" system-name ".el")))
 (when (file-exists-p system-init)
   (load system-init)))
(put 'erase-buffer 'disabled nil)

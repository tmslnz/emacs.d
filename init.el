;;; Require Common Lisp
(require 'cl)

;;; Set personal info
(require 'user.el nil 'noerror)

;;; Set custom file path
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;;; Alias 'yes' 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Vendor directory for non-managed packages
(defvar tmslnz/vendor-dir (expand-file-name "vendor" user-emacs-directory))
(add-to-list 'load-path tmslnz/vendor-dir)
;;; Only consider package files starting with 1 or more Word chars
; (dolist (project (directory-files abedra/vendor-dir t "\\w+"))
;     (when (file-directory-p project)
;         (add-to-list 'load-path project)))

;;; Set PATH
(setenv "PATH"
    (mapconcat 'identity
               `( "/usr/local/bin"
                  "/opt/local/bin"
                  "/usr/bin"
                  "/bin"
                  ,(getenv "PATH"))
                ":"))

;;; Backups
(setq make-backup-files nil)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;;; Dialogs and bell
(setq echo-keystrokes 0.1)
(setq use-dialog-box nil)
(setq visible-bell t)

;;; Add package repositories
(load "package")
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archive-enable-alist '(("melpa" deft magit)))

;;; Set Default Packages
(defvar tmslnz/packages '(
					; ac-slime
			  auto-complete ; what it says
			  autopair ; auto-closes parens
					; clojure-mode
					; coffee-mode
			  csharp-mode
					; deft ; Kinda like Notational Velocity
					; erlang
					; feature-mode
			  flycheck
					; gist
					; go-autocomplete
					; go-eldoc
					; go-mode
					; graphviz-dot-mode
					; haml-mode
					; haskell-mode
			  highlight-indent-guides
			  htmlize
					; idris-mode
			  magit
			  markdown-mode
					; marmalade
			  nodejs-repl
					; o-blog
					; org
			  paredit
			  php-mode
			  projectile
					; puppet-mode
			  restclient
					; rvm
					; scala-mode
			  smex
					; sml-mode
			  solarized-theme
			  web-mode
					; writegood-mode
			  yaml-mode
    )
    "Default packages")

(defun tmslnz/installed-packages-p ()
  "Docstring."
  (loop for pkg in tmslnz/packages
        when (not (package-installed-p pkg))
            do (return nil)
        finally (return t)))

;;; Install Default Packages (if needed)
(unless (tmslnz/installed-packages-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg tmslnz/packages)
        (when (not (package-installed-p pkg))
            (package-install pkg))))

;;; Disable splash screen
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;;; Set UI options
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Automatically save and restore sessions
(setq desktop-dirname "~/.emacs.d/desktop/"
      desktop-base-file-name "emacs.desktop"
      desktop-base-lock-name "lock"
      desktop-path (list desktop-dirname)
      desktop-save t
      desktop-files-not-to-save "^$" ;reload tramp paths
      desktop-load-locked-desktop nil)
(desktop-save-mode 1)

;;; Enable theme if windowed
(if window-system
    (load-theme 'solarized-light t)
    (load-theme 'wombat t))

;;; IDO mode settings
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

;;; Projectile mode
(projectile-global-mode t)

;;; Parens
(electric-pair-mode t)
(setq electric-pair-pairs '(
                            (?\" . ?\")
                            (?\{ . ?\})
			    ))
(require 'paren)
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

;;; Autocomplete mode
(require 'auto-complete-config)
(ac-config-default)

;;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;;; Show empty lines
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
    (toggle-indicate-empty-lines))

;;; Deal with troublesome ANSI color codes
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  "Docstring."
  (read-only-mode)
    (ansi-color-apply-on-region (point-min) (point-max))
    (read-only-mode))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;;; Indentation guides
(require 'highlight-indent-guides)
(setq highlight-indent-guides-method 'fill) ; fill column character
(set-face-background 'highlight-indent-guides-odd-face "#E6DFCE")
(set-face-background 'highlight-indent-guides-even-face "#D9D2C2")
(set-face-foreground 'highlight-indent-guides-character-face "green")
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

;;; Flycheck mode (linter-ish)
(global-flycheck-mode)

;;; File / Mode associations
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.gitconfig$" . conf-mode))

;;; Keyboard options
;; (setq mac-option-key-is-meta nil
;;       mac-command-key-is-meta t
;;       mac-command-modifier 'meta
;;       mac-option-modifier 'none)

;;; Interprogram Copy / Paste Utilities on OSX
;; (defun copy-from-osx ()
;;   (shell-command-to-string "pbpaste"))

;; (defun  paste-to-osx (text &optional push)
;;   (let ((process-connection-type nil))
;;     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
;;       (process-send-string proc text)
;;       (process-send-eof proc))))

;; (setq interprogram-cut-function 'paste-to-osx)
;; (setq interprogram-paste-function 'copy-from-osx)

(provide 'init)
;;; init.el ends here

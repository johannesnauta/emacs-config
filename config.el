;; Use the built-in package manager and specify archive
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
;; Initialize built-in package management
(package-initialize)
;; Install use-package if not available
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Load use-package by requiring it, to ensure it has been loaded
(eval-when-compile
  (require 'use-package))

(setq inhibit-startup-message t)  ;; Suppress startup splash screen
(setq ring-bell-function 'ignore) ;; Suppress sound on error or EOF
(menu-bar-mode -1)                ;; Turn off menu bar
(tool-bar-mode -1)                ;; Turn off tool bar
(setq scroll-conservatively 100)  ;; Make scrolling better
(show-paren-mode 1)               ;; Highlight matching parentheses

(global-display-line-numbers-mode 1)	;; Display line numbers in every buffer
(defalias 'yes-or-no-p 'y-or-n-p)     ;; All confirmations to single letters
(delete-selection-mode 1)             ;; Replace highlighted/selected text

(setq-default indent-tabs-mode nil)						;; Spaces instead of tabs
(setq-default tab-width 2)			              ;; Default tab width
(setq-default fill-column 80)                 ;; Default column width
(setq indent-line-function 'insert-tab)       ;; Indent current line(s) according to current major mode
;; Font and font size
(set-face-attribute 'default nil :font "Roboto Mono Medium")
(set-face-attribute 'default nil :height 115)

(global-set-key (kbd "M-o") #'other-window)

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      ;; kept-new-versions 5    ; how many of the newest versions to keep
      ;; kept-old-versions 5    ; and how many of the old
      )

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

(use-package vterm
  :ensure t)

(global-set-key (kbd "C-`") `vterm)

(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

(add-to-list 'display-buffer-alist
             '("\*vterm\*"
               (display-buffer-in-side-window)
               (window-height . 0.275)         ;; Specify fraction of window height
               (side . bottom)
               (slot . 0)))

(setq column-number-mode t)

(setq frame-title-format '("" "[%b] - Emacs " emacs-version))

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :init (savehist-mode))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode))
(use-package yasnippet-snippets
  :after yasnippet
  :ensure t
  :config (yasnippet-snippets-initialize))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

(use-package org-bullets
      :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-ellipsis "⤵")

(setq org-support-shift-select t)

(setq org-src-fontify-natively t)

(setq org-log-done t)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; What does the \C mean in this context? 
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)

(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t))

(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))

(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

(eval-after-load 'tex-mode
  '(define-key LaTeX-mode-map (kbd "C-c l")
     (lambda ()
       "Save the buffer and run `TeX-command-run-all`."
       (interactive)
       (save-buffer)
       (TeX-command-run-all nil))))

(use-package emojify
  :hook (markdown-mode . emojify-mode))

(add-hook 'python-mode-hook
      (lambda ()
        (setq indent-tabs-mode nil)
        (setq tab-width 4)
        (setq python-indent-offset 4)))

(use-package jedi
  :hook (python-mode . jedi:setup)
  (setq jedi:complete-on-dot t))

(use-package ein
      :ensure t
  :config
  (setq ein:completion-backend 'ein:use-ac-jedi-backend))

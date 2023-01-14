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
;; Build a list of recently opened files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

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

;; Emoji: 😄, 🤦, 🏴
(set-fontset-font t 'symbol "Apple Color Emoji")
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
(set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append)
(set-fontset-font t 'symbol "Symbola" nil 'append)

(use-package vterm
  :ensure t
  :init
  (setq vterm-timer-delay 0.01))

(global-set-key (kbd "C-`") `vterm)

(use-package zenburn-theme
  :ensure t
  :config (load-theme 'zenburn t))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
;; Set the title
(setq dashboard-banner-logo-title "Welcome Johannes")
;; Set the banner
(setq dashboard-startup-banner 'logo)
;; Center content
(setq dashboard-center-content t)
;; Customize widgets
(setq dashboard-items '((recents . 5)
                        (bookmarks . 5)))
;; Disable random footnote
(setq dashboard-set-footer nil)

(add-to-list 'display-buffer-alist
             '("\*vterm\*"
               (display-buffer-in-side-window)
               (window-height . 0.275)         ;; Specify fraction of window height
               (side . bottom)
               (slot . 0)))

(setq column-number-mode t)

(use-package diminish
  :ensure t)
(diminish 'eldoc-mode)
(diminish 'visual-line-mode)

(setq frame-title-format '("" "[%b] - Emacs " emacs-version))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :init (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  :diminish which-key-mode)

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package embark
  :ensure t
  :bind
  ("C-." . embark-act)
  :init
  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package yasnippet
  :ensure t
  :diminish yas-global-mode
  :config (yas-global-mode))
(use-package yasnippet-snippets
  :after yasnippet
  :ensure t
  :config (yasnippet-snippets-initialize))

(use-package company
  :ensure t
  :diminish global-company-mode
  :hook (after-init-hook . global-company-mode))

(use-package lsp-mode
  :ensure t  
  :commands (lsp lsp-deferred)
  :init
  ;; Usually the =lsp-keymap-prefix= is bound to "C-c l", but this is already
  ;; bound to the (very useful!) =org-store-link=, which we do not want to
  ;; override. "C-c o" ('o' for option) was empty, so use it here.
  (setq lsp-keymap-prefix "C-c o")
  :config
  (define-key lsp-mode-map (kbd lsp-keymap-prefix) lsp-command-map)
  :hook (;; add modes
         (julia-mode . lsp-deferred)
         (julia-ts-mode . lsp-deferred)
         ;; =lsp-enable-which-key-integration= gives us descriptions of what the keys
         ;; do, which helps us figure out what they do when using =lsp-mode=.
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-julia
  :ensure t
  :config
  (setq lsp-julia-default-environment "~/.julia/environments/v1.8"))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-ellipsis "⤵")

(setq org-support-shift-select t)

(setq org-src-fontify-natively t)

(setq org-log-done t)

(add-hook 'org-mode-hook #'auto-fill-mode)
(add-hook 'org-mode-hook #'visual-line-mode)

(add-to-list 'org-link-frame-setup '(file . find-file))

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(use-package citar
  :custom
  (org-cite-global-bibliography '("~/work/papers/better-bibtex/postdoc.bib"))
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar)
  (citar-bibliography org-cite-global-bibliography)
  ;; optional: (or )rg-cite-insert is also bound to C-c C-x C-@
  :bind
  (:map org-mode-map :package org ("C-c i c" . #'org-cite-insert)))

(use-package citar-embark
  :after citar embar
  :no-require t
  :config (citar-embark-mode))

(setq org-capture-templates
    '(("t" "Todo" entry (file+headline "~/work/tasks/org/todo.org" "Tasks")
       "* TODO %?\n  %i\n  %a")))

(use-package org-roam
  :custom
  (org-roam-directory "~/work/notes/org-roam/")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-C n i" . org-roam-node-insert))
  :config (org-roam-setup))

(use-package tex
  :ensure auctex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil))

(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))

(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

(add-hook 'TeX-after-compilation-finished-functions
          #'TeX-revert-document-buffer)

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

(add-to-list 'load-path "~/.emacs.d/local-packages/julia-ts-mode/")
(require 'julia-ts-mode)
;; (use-package julia-ts-mode
;;   :ensure nil
;;   :load-path "~/.emacs.d/local-packages/julia-ts-mode/"
;;   :hook (julia-ts-mode-hook . lsp-mode))

(use-package julia-repl
  :ensure t
  :hook (julia-ts-mode . julia-repl-mode)

  :config
  ;; Set the terminal backend
  (julia-repl-set-terminal-backend 'vterm)

  ;; Keybindings for quickly sending code to the REPL
  (define-key julia-repl-mode-map (kbd "<M-RET>") 'my/julia-repl-send-cell))

(defun my/julia-repl-send-cell() 
  ;; "Send the current julia cell (delimited by ###) to the julia shell"
  (interactive)
  (save-excursion
    (setq cell-begin (if (re-search-backward "^###" nil t) (point) (point-min))))
  (save-excursion
    (setq cell-end (if (re-search-forward "^###" nil t) (point) (point-max))))
  (set-mark cell-begin)
  (goto-char cell-end)
  (julia-repl-send-region-or-line)
  (next-line))

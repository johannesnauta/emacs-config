;; Packages
(require 'package)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.org/packages/") t)

;; (package-initialize) appears to clash with loading AUCTeX, but not
;; with any other package that is loaded. Why this is specifically I do
;; not know, but it is mentioned in the Quick Start guide of AUCTeX, as
;; apparantly the installation procedure (using ELPA) already cares about
;; loading AUCTeX correctly and (package-initialize) perhaps overwrites this.
;; If it happens to not load other packages, this might be a reason. But
;; loading other packages should be OK if using (require <package>)
;; (package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(server-start)

;; Define the init file where Config will write to
;; This keeps the init.el file clean as it will only include personal configuration
(setq custom-file (expand-file-name "config.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Define the directory where backups will be stored as they otherwise might
;; mess up the Git repositories or directories they are a part of
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  ;; kept-new-versions 5    ; how many of the newest versions to keep
  ;; kept-old-versions 5    ; and how many of the old
)

;; Suppress some defaults
(setq inhibit-startup-message t)  ;; Suppress startup splash screen
(setq ring-bell-function 'ignore) ;; Suppress sound on error or EOF
(menu-bar-mode -1)                ;; Turn off menu bar
(tool-bar-mode -1)                ;; Turn off tool bar

;; Enable some defaults
(global-display-line-numbers-mode 1)    ;; Display line numbers in every buffer
(defalias 'yes-or-no-p 'y-or-n-p)       ;; All confirmations to single letters
(delete-selection-mode 1)               ;; Replace highlighted/selected text

;; Specify some requirements
;; (require 'smartparens-config)

;; Specify some defaults
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
(set-face-attribute 'default nil :height 115)
(global-set-key (kbd "M-o") #'other-window)

;;==========================;;
;; YASnippets configuration ;;
;;==========================;;
(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)
(add-hook 'yas-minor-mode-hook (lambda()
	(yas-activate-extra-mode 'fundamental-mode)))


;;=======================;;
;; Visual configurations ;;
;;=======================;;
;; Select color theme
(use-package zenburn-theme
  :ensure t
  :config
  (load-theme 'zenburn t))
;; Select font
(set-face-attribute 'default nil :font "Roboto Mono Medium")

;; Change how vterm is displayed
(add-to-list 'display-buffer-alist
  '("\*vterm\*"
    (display-buffer-in-side-window)
    (window-height . 0.275)         ;; Specify fraction of window hide
    (side . bottom)
    (slot . 0)))
(global-set-key (kbd "C-`") `vterm) ;; Set C-` to open vterm

(setq frame-title-format '("" "[%b] - Emacs " emacs-version))
(setq column-number-mode t)         ;; Include column no. in mode line
    
;; (setq-default mode-line-format
;;   (list
;;     "%e"
;;     mode-line-front-space
;;     mode-line-mule-info
;;     mode-line-client
;;     mode-line-modified
;;     mode-line-remote
;;     mode-line-frame-identification
;;     mode-line-position
;;     mode-line-buffer-identification
;;     ;; show the current branch and VCS in use, if there is one
;;     (vc-mode vc-mode)
;;     ;; (vc-working-revision (buffer-file-name (current-buffer)))
;;   )
;; )
;; Include absolute path in the mode line
;; (setq-default mode-line-buffer-identification
;;   (list 'buffer-file-name
;;     (propertized-buffer-identification "%12f")
;;     (propertized-buffer-identification "%12b")
;;  ))

;;========================;;
;; Interactive completion ;;
;;========================;;
(use-package vertico
  :ensure t
  :init
  (vertico-mode))
;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; ======================= ;;
;; Org mode configurations ;;
;; ======================= ;;
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
(require 'org)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-src-fontify-natively t)
(setq org-log-done t)
(setq org-ellipsis "⤵")                ;; Change ellipsis (...) to an arrow instead
(setq org-support-shift-select 'always) ;; Shift select blocks of text in Org-mode

;;=========================;;
;; Org-roam configurations ;;
;;=========================;;
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/notes/org/roam")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(setq org-roam-capture-templates
  '(
     ("m" "study math" plain (file "~/notes/org/roam/study/templates/study.org")
     :target (file+head "study/math/${slug}.org"
     "#+title: ${title}\n") :unnarrowed t)
     ("p" "study prog" plain (file "~/notes/org/roam/study/templates/study.org")
     :target (file+head "study/programming/${slug}.org"
     "#+title: ${title}\n") :unnarrowed t)
  )
)

;;=====================;;
;; LaTeX configuration ;;
;;=====================;;
;; AUCTeX
(use-package tex
  :ensure auctex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
;; Use pdf-tools to open PDF files
;;(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;  TeX-source-correlate-start-server t)
;; [Note:]
;; While pdf-tools is nice as it functions within Emacs, and provides useful
;; things like isearch amongst other things, it converts the pdf file to png.
;; This leads to losses in resolution as png is not a vector image. While you
;; can fiddle with dpi settings, it might be better to use a better pdf-viewer
;; Use Evince to open PDF files
(setq TeX-view-program-list '(("Evince" "evince --page-index=%(outpage) %o")))
(setq TeX-view-program-selection '((output-pdf "Evince")))
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-compilation-finished-functions
  #'TeX-revert-document-buffer)

;; Change keybinding of save-render-show (LaTeX-mode-map)
(eval-after-load 'tex-mode
  '(define-key LaTeX-mode-map (kbd "C-c l")
    (lambda ()
      "Save the buffer and run `TeX-command-run-all`."
      (interactive)
      (save-buffer)
      (TeX-command-run-all nil))))

;;===============================;;
;; LaTeX rendering (in Org mode) ;;
;;===============================;;
(plist-put org-format-latex-options :scale 1.5)

(use-package org-fragtog)
(add-hook 'org-mode-hook 'org-fragtog-mode)

;;====================;;
;; Markdown rendering ;;
;;====================;;
(use-package emojify
  :hook (after-init . global-emojify-mode))

;;=======================;;
;; Python configurations ;;
;;=======================;;
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'python-mode-hook 'jedi:setup)
(add-hook 'python-mode-hook
  (lambda()
    (setq tab-width 4)))
(setq jedi:complete-on-dot t)
(put 'upcase-region 'disabled nil)

;; EIN Jupyter IPython Notebook
(require 'ein)
(require 'ein-notebook)
(setq ein:completion-backend 'ein:use-ac-jedi-backend)

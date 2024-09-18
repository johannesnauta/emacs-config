(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Load Org really early to avoid =org-babel-load-file= to use the built-in version
(straight-use-package 'org)
(org-babel-load-file (expand-file-name "config.org" "~/.emacs.d"))

(defun hack-one-local-variable (var val)
  "Set local variable VAR with value VAL.
If VAR is `mode', call `VAL-mode' as a function unless it's
already the major mode."
  (pcase var
    ('mode
     (let ((mode (intern (concat (downcase (symbol-name val))
                                 "-mode"))))
       (set-auto-mode-0 mode t)))
    ('eval
     (pcase val
       (`(add-hook ',hook . ,_) (hack-one-local-variable--obsolete hook)))
     (save-excursion (eval val t)))
    (_
     (hack-one-local-variable--obsolete var)
     ;; Make sure the string has no text properties.
     ;; Some text properties can get evaluated in various ways,
     ;; so it is risky to put them on with a local variable list.
     (if (stringp val)
         (set-text-properties 0 (length val) nil val))
     (set (make-local-variable var) val))))

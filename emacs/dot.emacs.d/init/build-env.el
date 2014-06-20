(defvar user-emacs-directory
  (expand-file-name (concat (getenv "HOME") "/.emacs.d/")))

(defvar package-base-dir
  (concat user-emacs-directory "packages/"))

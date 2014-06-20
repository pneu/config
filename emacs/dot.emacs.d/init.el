 ;; user private
(make-local-variable 'user-private-dir)
(setq user-private-dir (concat user-emacs-directory "private/"))
(load-file (concat user-private-dir "private.el"))

 ;; load init
(make-local-variable 'loaded-dir-init)
(setq loaded-dir-init (concat user-emacs-directory "init/"))
(load-file (concat loaded-dir-init "build-env.el"))
(load-file (concat loaded-dir-init "gui.el"))
(load-file (concat loaded-dir-init "bindings.el"))
(load-file (concat loaded-dir-init "setdirectory.el"))
(load-file (concat loaded-dir-init "locale.el"))

 ;; load packages
(load-file (concat user-emacs-directory "package.el"))

 ;;
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

 ;; react fnotify-s on outside of emacs
(global-auto-revert-mode 1)

 ;;
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

 ;; suppress to add newline at end-of-file
(setq next-line-add-newlines nil)

 ;; show watch on minibuf
(display-time)

 ;; emphasis matched paren
(show-paren-mode t)

 ;; emphasis marked region
(transient-mark-mode t)

 ;;
(setq-default show-trailing-whitespace t)

 ;;
'(partial-completion-mode t)

 ;;
(require 'cl)

(defun package-path-basename (path)
  (file-name-sans-extension (file-name-nondirectory path)))

(defun package-directory (files)
  (concat package-base-dir "/"
          (package-path-basename (car files))))

(defun package-run-shell-command (command)
  (message (format "running...: %s" command))
  (shell-command command))

(defun package-install-from-emacswiki (files)
  (shell-command
   (format "mkdir -p %s" (package-directory files)))
  (package-run-shell-command
   (format "wget --directory-prefix %s %s"
           (package-directory files)
           (mapconcat (lambda (name)
                        (concat "http://www.emacswiki.org/emacs/download/"
                                name))
                      files
                      " "))))

(defun package-install-from-github (files)
  (package-run-shell-command
   (format (concat "git clone https://github.com/%s.git %s")
           (car files)
           (package-directory files))))

(defun package-install-from-repo.or.cz (files)
  (package-run-shell-command
   (format (concat "git clone git://repo.or.cz/%s.git %s")
           (car files)
           (package-directory files))))

(defun package-alist-value (alist key default-value)
  (if (listp alist)
      (let ((alist-item (assoc key alist)))
        (if alist-item
            (cdr alist-item)
          default-value))
    default-value))

(defun package-install (type package-spec require-name &optional force)
  (let ((files (package-alist-value package-spec 'files
                                    (if (listp package-spec)
                                        package-spec
                                      (list package-spec))))
        (base-path (package-alist-value package-spec 'base-path "."))
        (additional-paths (package-alist-value package-spec 'additional-paths
                                               nil))
        (install-proc (case type
                        (emacswiki
                         'package-install-from-emacswiki)
                        (github
                         'package-install-from-github)
                        (repo.or.cz
                         'package-install-from-repo.or.cz)
                        (t
                         (error "unknown package type: <%s>(%s)"
                                type package)))))
    (add-to-list 'load-path
                 (format "%s/%s"
                         (package-directory files)
                         base-path))
    (dolist (additional-path additional-paths)
      (add-to-list 'load-path (format "%s/%s"
                                      (package-directory files)
                                      additional-path)))
    (condition-case err
        (require require-name)
      (error
       (message (format "installing %s..." files))
       (funcall install-proc files)))
    (require require-name)))

 ;; install-lisp
;(require 'install-elisp)
;(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

 ;; Auto-complete
;(package-install 'github "m2ym/auto-complete" 'auto-complete-config)
;;(require 'auto-complete-config)
;(add-to-list 'ac-dictionary-directories "~/.emacs.d/elisp/auto-complete/ac-dict")
;(ac-config-default)
;(setq ac-use-menu-map t)

 ;;
;(require 'tabbar)
;(global-set-key [(control shift tab)] 'tabbar-backward)
;(global-set-key [(control tab)] 'tabbar-forward)
;(tabbar-mode)

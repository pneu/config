 ;; C-z -> undo
(global-set-key "\C-z" 'undo)

 ;; C-r -> redo
(load-file (concat user-emacs-directory "init/lib/redo+.el"))
(global-set-key "\C-r" 'redo)

(global-set-key (kbd "<C-S-r>") 'isearch-backward)

 ;; C-h -> backspace
(global-set-key "\C-h" 'delete-backward-char)

 ;; C-\ -> toggle IME
(global-set-key "\C-\\" 'set-mark-command)
;(global-set-key "\C-o" 'toggle-input-method)

 ;; S-arrow -> traverse windows
(windmove-default-keybindings)
(setq windmove-wrap-around t)

 ;; C-x p -> move other-window
(global-set-key "\C-xp" (lambda () (interactive) (other-window -1)))

 ;; M-g -> goto line
(global-set-key "\M-g" (lambda (x) (interactive "nLine: ") (goto-line x)))

 ;; F12 -> reload current buffer
(global-set-key [f12] 'eval-buffer)

 ;; scroll up/down
;(global-set-key "\C-V" 'scroll-down-line)
;(global-set-key "\M-V" 'scroll-up-line)

;; packages

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; vim emulation mode

(setq evil-overriding-maps nil)
(setq evil-intercept-maps nil)
(setq evil-want-C-u-scroll t)  ; NOTE: this line must precede (require 'evil)
(require 'evil)
(evil-mode t)

;; appearance

(setq inhibit-startup-message t)  ; disable startup message
(menu-bar-mode -1)        ; disable the menu bar
(tool-bar-mode -1)        ; disable toolbar
(scroll-bar-mode -1)      ; disable scrollbar

;; theme

(load-theme 'zenburn t)

;; line numbers
(require 'linum)
(global-linum-mode t)
;; put a space after the line number
(setq linum-format (lambda (line)
		     (let ((width (length (number-to-string (count-lines (point-min) (point-max))))))
		       (propertize (format (format "%%%dd " width) line) 'face 'linum))))

;; editing

(keyboard-translate ?\C-h ?\C-?)  ; map ctrl-h to backspace
(define-key global-map (kbd "RET") 'newline-and-indent) ; autoindent

;; buffers

(require 'helm)
(helm-mode 1)

;; files

(setq make-backup-files nil)

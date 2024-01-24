;; haproxy-mode.el --- major mode for editing haproxy config files

;; Copyright 2024 port19 <port19@port19.xyz>

;; Author: port19 <port19@port19.xyz>
;; Maintainer: port19 <port19@port19.xyz>
;; Created: 24 Jan 2024
;; Version: 0.1.0
;; Keywords: haproxy

;; available from https://github.com/port19x/haproxy-mode

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This is a quick mode for editing HAProxy config files, as no appropiate mode existed before.

;; Many thanks to the author of `nginx-mode.el`, from where this is a direct fork.
;; Most of the code of this package is just adapted from nginx-mode.

;; Put this file into your `load-path` and the following into your `~/.emacs`:
;;   (require 'haproxy-mode)

;;; Code:


;;;;##########################################################################
;;;;  User Options, Variables
;;;;##########################################################################

(defcustom haproxy-indent-level 4
  "*Indentation of haproxy statements."
  :type 'integer :group 'haproxy)

(defcustom haproxy-indent-tabs-mode nil
  "*Indentation can insert tabs in haproxy mode if this is non-nil."
  :type 'boolean :group 'haproxy)

(defvar haproxy-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for `haproxy-mode'.")

;;^\s+\\|
(defvar haproxy-font-lock-keywords
  (list '("\\(^\\)\\(frontend\\|listen\\|backend\\|resolvers\\|defaults\\|global\\|description\\)" . font-lock-keyword-face)
        '("\\(^\s+\\)\\(redirect\\)" . font-lock-builtin-face)
        '("\\(use_backend\\|default-server\\|server\\)" . font-lock-variable-name-face)
        '("\\(block\\|capture\\|stats\\|default_backend\\)" . font-lock-type-face)))


;;;;##########################################################################
;;;;  Code
;;;;##########################################################################

(defvar haproxy-mode-map
  (let
      ((map (make-sparse-keymap)))
    (define-key map "\C-j" 'transient-noop)
    map)
  "Keymap for editing haproxy config files.")

; TODO flycheck & flymake support via haproxy -c shell-command
; TODO significant whitespace... maybe look at python mode (?)

;;;###autoload
(define-derived-mode haproxy-mode prog-mode "Haproxy"
  "Major mode for highlighting haproxy config files.

The variable haproxy-indent-level controls the amount of indentation.
\\{haproxy-mode-map}"
  :syntax-table haproxy-mode-syntax-table

  (use-local-map haproxy-mode-map)

  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#+ *")
  (set (make-local-variable 'comment-end) "")
  (set (make-local-variable 'comment-auto-fill-only-comments) t)
  (set (make-local-variable 'require-final-newline) t)
  (set (make-local-variable 'paragraph-ignore-fill-prefix) t)

  (set (make-local-variable 'font-lock-defaults)
       '(haproxy-font-lock-keywords nil)))

;;;###autoload
(add-to-list 'auto-mode-alist '("haproxy\\.cfg\\'"  . haproxy-mode))

(provide 'haproxy-mode)

;;; haproxy-mode.el ends here

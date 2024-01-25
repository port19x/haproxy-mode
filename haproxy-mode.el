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

; TODO Support level1&2 font-locking. level 1 would be top-level sections and proxy keywords only.
(defvar haproxy-font-lock-keywords
  (list
   ; proxy keywords (https://docs.haproxy.org/2.9/configuration.html#4.1)
   '("\\(^\s+\\)\\(acl\\|backlog\\|balance\\|bind\\|capture cookie\\|capture request header\\|capture response header\\|clitcpka-cnt\\|clitcpka-idle\\|clitcpka-intvl\\|compression\\|cookie\\|declare capture\\|default-server\\|default_backend\\|description\\|disabled\\|dispatch\\|email-alert from\\|email-alert level\\|email-alert mailers\\|email-alert myhostname\\|email-alert to\\|enabled\\|errorfile\\|errorfiles\\|errorloc\\|errorloc302\\|errorloc303\\|error-log-format\\|force-persist\\|filter\\|fullconn\\|hash-type\\|http-after-response\\|http-check comment\\|http-check connect\\|http-check disable-on-404\\|http-check expect\\|http-check send\\|http-check send-state\\|http-check set-var\\|http-check unset-var\\|http-error\\|http-request\\|http-response\\|http-reuse\\|http-send-name-header\\|id\\|ignore-persist\\|load-server-state-from-file\\|log\\|log-format\\|log-format-sd\\|log-tag\\|max-keep-alive-queue\\|max-session-srv-conns\\|maxconn\\|mode\\|monitor fail\\|monitor-uri\\|option abortonclose\\|option accept-invalid-http-request\\|option accept-invalid-http-response\\|option allbackups\\|option checkcache\\|option clitcpka\\|option contstats\\|option disable-h2-upgrade\\|option dontlog-normal\\|option dontlognull\\|option forwardfor\\|option forwarded\\|option h1-case-adjust-bogus-client\\|option h1-case-adjust-bogus-server\\|option http-buffer-request\\|option http-ignore-probes\\|option http-keep-alive\\|option http-no-delay\\|option http-pretend-keepalive\\|option http-restrict-req-hdr-names\\|option http-server-close\\|option http-use-proxy-header\\|option httpchk\\|option httpclose\\|option httplog\\|option httpslog\\|option independent-streams\\|option ldap-check\\|option external-check\\|option log-health-checks\\|option log-separate-errors\\|option logasap\\|option mysql-check\\|option nolinger\\|option originalto\\|option persist\\|option pgsql-check\\|option prefer-last-server\\|option redispatch\\|option redis-check\\|option smtpchk\\|option socket-stats\\|option splice-auto\\|option splice-request\\|option splice-response\\|option spop-check\\|option srvtcpka\\|option ssl-hello-chk\\|option tcp-check\\|option tcp-smart-accept\\|option tcp-smart-connect\\|option tcpka\\|option tcplog\\|option transparent\\|option idle-close-on-response\\|external-check command\\|external-check path\\|persist rdp-cookie\\|rate-limit sessions\\|redirect\\|retries\\|retry-on\\|server\\|server-state-file-name\\|server-template\\|source\\|srvtcpka-cnt\\|srvtcpka-idle\\|srvtcpka-intvl\\|stats admin\\|stats auth\\|stats enable\\|stats hide-version\\|stats http-request\\|stats realm\\|stats refresh\\|stats scope\\|stats show-desc\\|stats show-legends\\|stats show-node\\|stats uri\\|stick match\\|stick on\\|stick store-request\\|stick store-response\\|stick-table\\|tcp-check comment\\|tcp-check connect\\|tcp-check expect\\|tcp-check send\\|tcp-check send-lf\\|tcp-check send-binary\\|tcp-check send-binary-lf\\|tcp-check set-var\\|tcp-check unset-var\\|tcp-request connection\\|tcp-request content\\|tcp-request inspect-delay\\|tcp-request session\\|tcp-response content\\|tcp-response inspect-delay\\|timeout check\\|timeout client\\|timeout client-fin\\|timeout client-hs\\|timeout connect\\|timeout http-keep-alive\\|timeout http-request\\|timeout queue\\|timeout server\\|timeout server-fin\\|timeout tarpit\\|timeout tunnel\\|unique-id-format\\|unique-id-header\\|use_backend\\|use-fcgi-app\\|use-server\\)" . font-lock-variable-name-face)
   ; http codes (https://httpcats.com/)
   '("\\(\s+\\)\\(100\\|101\\|102\\|103\\|200\\|201\\|202\\|203\\|204\\|205\\|206\\|207\\|208\\|226\\|300\\|301\\|302\\|303\\|304\\|305\\|307\\|308\\|400\\|401\\|402\\|403\\|404\\|405\\|406\\|407\\|408\\|409\\|410\\|411\\|412\\|413\\|414\\|415\\|416\\|417\\|418\\|420\\|421\\|422\\|423\\|424\\|425\\|426\\|428\\|429\\|431\\|444\\|450\\|451\\|497\\|498\\|499\\|500\\|501\\|502\\|503\\|504\\|506\\|507\\|508\\|509\\|510\\|511\\|521\\|522\\|523\\|525\\|530\\|599\\|999\\)\\(\s+\\)" . font-lock-constant-face)
   ; top-level sections
   '("\\(^\\)\\(global\\|defaults\\|frontend\\|backend\\|listen\\|resolvers\\)" . font-lock-keyword-face)
   ; ssl is mostly generated anyway (https://ssl-config.mozilla.org/)
   '("\\(^\s+\\)\\(ssl.*\\)" . font-lock-doc-face)
   ; TODO ports, time and paths
   '("\\([a-zA-Z0-9.:*]+\\)?\\(:[0-9]+\\|[0-9]+s$\\)" . font-lock-string-face)
   ; alert to the presence of acls
   '(" if " . font-lock-builtin-face)))


;;;;##########################################################################
;;;;  Code
;;;;##########################################################################

(defvar haproxy-mode-map
  (let
      ((map (make-sparse-keymap)))
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

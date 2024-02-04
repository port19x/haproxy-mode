;;; haproxy-mode.el --- Major mode for editing HAProxy config files -*- lexical-binding: t -*-

;; Copyright (c) 2024 port19

;; Author: port19 <port19@port19.xyz>
;; Version: 0.9.1
;; Package-Requires: ((emacs "24.3"))
;; Keywords: haproxy, languages, tools
;; Homepage: https://github.com/port19x/haproxy-mode
;; URL: https://github.com/port19x/haproxy-mode
;; Created: 24 Jan 2024

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

;; This is a major mode for editing HAProxy config files, as no appropiate mode
;; existed before.

;; Put this file into your `load-path` and the following into your `~/.emacs`:
;;   (require 'haproxy-mode)

;; Users may also be interested in the `httpcode` package.
;; It explains the meaning of an HTTP status code

;;; Code:


;;;;##########################################################################
;;;;  User Options
;;;;##########################################################################

(defcustom haproxy-easteregg t
  "*Activate the port19 easter egg."
  :type 'boolean :group 'haproxy)

;;;;##########################################################################
;;;;  Internal Variables
;;;;##########################################################################

(defvar haproxy-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?# "< b" table)
    (modify-syntax-entry ?\n "> b" table)
    table)
  "Syntax table for `haproxy-mode'.")

(defvar haproxy-font-lock-keywords
  (list
   ;; proxy keywords (https://docs.haproxy.org/2.9/configuration.html#4.1)
   ;; > single word keywords
   `(,(concat "\\(^\s+\\)" (regexp-opt '("acl" "backlog" "balance" "bind" "clitcpka-cnt" "clitcpka-idle" "clitcpka-intvl" "compression" "cookie" "enabled" "errorfile" "errorfiles" "errorloc" "errorloc302" "errorloc303" "error-log-format" "force-persist" "filter" "fullconn" "hash-type" "http-after-response" "default-server" "default_backend" "description" "disabled" "dispatch" "http-error" "http-request" "http-response" "http-reuse" "http-send-name-header" "id" "ignore-persist" "load-server-state-from-file" "log" "log-format" "log-format-sd" "log-tag" "max-keep-alive-queue" "max-session-srv-conns" "maxconn" "mode" "monitor-uri" "redirect" "retries" "retry-on" "server" "server-state-file-name" "server-template" "source" "srvtcpka-cnt" "srvtcpka-idle" "srvtcpka-intvl" "stick-table" "unique-id-format" "unique-id-header" "use_backend" "use-fcgi-app" "use-server"))) . font-lock-variable-name-face)
   ;; > plentiful prefixes
   `(,(concat "\\(^\s+\\)" "\\(email-alert\s+\\)" (regexp-opt '("from" "level" "mailers" "myhostname" "to"))) . font-lock-variable-name-face)
   `(,(concat "\\(^\s+\\)" "\\(http-check\s+\\)" (regexp-opt '("comment" "connect" "disable-on-404" "expect" "send" "send-state" "set-var" "unset-var"))) . font-lock-variable-name-face)
   `(,(concat "\\(^\s+\\)" "\\(option\s+\\)" (regexp-opt '("abortonclose " "accept-invalid-http-request" "accept-invalid-http-response" "allbackups" "checkcache" "clitcpka" "contstats" "disable-h2-upgrade" "dontlog-normal" "dontlognull" "external-check" "forwarded" "forwardfor" "h1-case-adjust-bogus-client" "h1-case-adjust-bogus-server" "http-buffer-request" "http-ignore-probes" "http-keep-alive" "http-no-delay" "http-pretend-keepalive" "http-restrict-req-hdr-names" "http-server-close" "http-use-proxy-header" "httpchk" "httpclose" "httplog" "httpslog" "idle-close-on-response" "independent-streams" "ldap-check" "log-health-checks" "log-separate-errors" "logasap" "mysql-check" "nolinger" "originalto" "persist" "pgsql-check" "prefer-last-server" "redis-check" "redispatch" "smtpchk" "socket-stats" "splice-auto" "splice-request" "splice-response" "spop-check" "srvtcpka" "ssl-hello-chk" "tcp-check" "tcp-smart-accept" "tcp-smart-connect" "tcpka" "tcplog" "transparent"))) . font-lock-variable-name-face)
   `(,(concat "\\(^\s+\\)" "\\(stats\s+\\)" (regexp-opt '("admin" "auth" "enable" "hide-version" "http-request" "realm" "refresh" "scope" "show-desc" "show-legends" "show-node" "uri"))) . font-lock-variable-name-face)
   `(,(concat "\\(^\s+\\)" "\\(tcp-check\s+\\)" (regexp-opt '("comment" "connect" "expect" "send" "send-binary" "send-binary-lf" "send-lf" "set-var" "unset-var"))) . font-lock-variable-name-face)
   `(,(concat "\\(^\s+\\)" "\\(timeout\s+\\)" (regexp-opt '("check" "client" "client-fin" "client-hs" "connect" "http-keep-alive" "http-request" "queue" "server" "server-fin" "tarpit" "tunnel"))) . font-lock-variable-name-face)
   ;; > two s+ keywords or <5 prefix matches
   '("\\(^\s+\\)\\(capture\s+request\s+header\\|capture\s+response\s+header\\|capture\s+cookie\\|declare\s+capture\\|external-check\s+command\\|external-check\s+path\\|persist\s+rdp-cookie\\|rate-limit\s+sessions\\|monitor\s+fail\\|stick\s+match\\|stick\s+on\\|stick\s+store-request\\|stick\s+store-response\\|tcp-request\s+connection\\|tcp-request\s+content\\|tcp-request\s+inspect-delay\\|tcp-request\s+session\\|tcp-response\s+content\\|tcp-response\s+inspect-delay\\)" . font-lock-variable-name-face)

   ;; http codes (https://httpcats.com/)
   `(,(concat
       "\\([\s\t]+\\)"
       (regexp-opt '("100" "101" "102" "103"
                     "200" "201" "202" "203" "204" "205" "206" "207" "208" "226"
                     "300" "301" "302" "303" "304" "305" "307" "308"
                     "400" "401" "402" "403" "404" "405" "406" "407" "408" "409"
                     "410" "411" "412" "413" "414" "415" "416" "417" "418"
                     "420" "421" "422" "423" "424" "425" "426" "428" "429"
                     "431" "444" "450" "451" "497" "498" "499"
                     "500" "501" "502" "503" "504" "506" "507" "508" "509" "510" "511" "521" "522" "523" "525" "530" "599"
                     "999")))
     . font-lock-constant-face)
   ;; top-level sections
   '("\\(^\\)\\(global\\|defaults\\|frontend\\|backend\\|listen\\|resolvers\\)" . font-lock-keyword-face)
   ;; ssl is mostly generated anyway (https://ssl-config.mozilla.org/)
   '("\\(^[\s\t]+\\)\\(ssl.*\\)" . font-lock-doc-face)
   ;; easter egg
   `(,(if haproxy-easteregg "\\(:19\\)\\(\s+\\|$\\)" "") . font-lock-warning-face)
   ;; paths, time, ports
   '("\\(/[/a-z.]+\\)\\(\s+\\|$\\)" . font-lock-string-face)
   '("\\([0-9]+\\)\\([um]?\\)\\([smhd]$\\)" . font-lock-string-face)
   '("\\(:[0-9]+\\)\\(\s+\\|$\\)" . font-lock-string-face)
   ;; alert to the presence of acls
   '(" if " . font-lock-builtin-face)))


;;;;##########################################################################
;;;;  Code
;;;;##########################################################################

; TODO something to check the buffer via haproxy -c

;;;###autoload
(define-derived-mode haproxy-mode prog-mode "HAProxy"
  "Major mode for highlighting haproxy config files.

The variable `haproxy-indent-level' controls the amount of indentation.
\\{haproxy-mode-map}"
  :syntax-table haproxy-mode-syntax-table

  (use-local-map haproxy-mode-map)

  (setq-local comment-start "# "
              comment-start-skip "#+ *"
              comment-end ""
              comment-auto-fill-only-comments t
              require-final-newline t
              paragraph-ignore-fill-prefix t
              outline-regexp "\\(global\\|defaults\\|frontend\\|backend\\|listen\\|resolvers\\)"
              imenu-generic-expression `(("Misc" "^\\(listen\\|resolvers\\)" 0)
                                         ("Backends" "^\\(backend\\)\\([\s\t]+\\)\\(.*\\)" 3)
                                         ("Frontends" "^\\(frontend\\)\\([\s\t]+\\)\\(.*\\)" 3)
                                         ("--" "^\\(global\\|defaults\\)" 0))
              font-lock-defaults '(haproxy-font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("haproxy\\.cfg\\'"  . haproxy-mode))

(provide 'haproxy-mode)

;;; haproxy-mode.el ends here

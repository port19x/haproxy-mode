;;; haproxy-mode.el --- Major mode for editing HAProxy config files -*- lexical-binding: t -*-

;; Copyright (c) 2024 port19

;; Author: port19 <port19@port19.xyz>
;; Version: 0.5.5
;; Package-Requires: ((emacs "24"))
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
;; existed before.  Version 0.x denotes an unfinished project.  See the TODO
;; comments in this source file for planned additions.

;; Put this file into your `load-path` and the following into your `~/.emacs`:
;;   (require 'haproxy-mode)

;; See the README for more details:
;; https://github.com/port19x/haproxy-mode/

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
   ;; proxy keywords (https://docs.haproxy.org/2.9/configuration.html#4.1)
   ;; HACK combine previous approach with regex-opt where possible
   ;; "option\s+url\\|option\s+enable"
   ;; "\\(?1:option\s+\\(?:enable\\|url\\)\\)"
   ;; (regexp-opt '("WORD1" "WORD2"))
   ;; "\\(PREFIX\s+\\(WORD1\\|WORD2\\)\\)"
   '("\\(^\s+\\)\\(acl\\|backlog\\|balance\\|bind\\|capture\s+cookie\\|capture\s+request\s+header\\|capture\s+response\s+header\\|clitcpka-cnt\\|clitcpka-idle\\|clitcpka-intvl\\|compression\\|cookie\\|declare\s+capture\\|default-server\\|default_backend\\|description\\|disabled\\|dispatch\\|email-alert\s+from\\|email-alert\s+level\\|email-alert\s+mailers\\|email-alert\s+myhostname\\|email-alert\s+to\\|enabled\\|errorfile\\|errorfiles\\|errorloc\\|errorloc302\\|errorloc303\\|error-log-format\\|force-persist\\|filter\\|fullconn\\|hash-type\\|http-after-response\\|http-check\s+comment\\|http-check\s+connect\\|http-check\s+disable-on-404\\|http-check\s+expect\\|http-check\s+send\\|http-check\s+send-state\\|http-check\s+set-var\\|http-check\s+unset-var\\|http-error\\|http-request\\|http-response\\|http-reuse\\|http-send-name-header\\|id\\|ignore-persist\\|load-server-state-from-file\\|log\\|log-format\\|log-format-sd\\|log-tag\\|max-keep-alive-queue\\|max-session-srv-conns\\|maxconn\\|mode\\|monitor\s+fail\\|monitor-uri\\|option\s+abortonclose\\|option\s+accept-invalid-http-request\\|option\s+accept-invalid-http-response\\|option\s+allbackups\\|option\s+checkcache\\|option\s+clitcpka\\|option\s+contstats\\|option\s+disable-h2-upgrade\\|option\s+dontlog-normal\\|option\s+dontlognull\\|option\s+forwardfor\\|option\s+forwarded\\|option\s+h1-case-adjust-bogus-client\\|option\s+h1-case-adjust-bogus-server\\|option\s+http-buffer-request\\|option\s+http-ignore-probes\\|option\s+http-keep-alive\\|option\s+http-no-delay\\|option\s+http-pretend-keepalive\\|option\s+http-restrict-req-hdr-names\\|option\s+http-server-close\\|option\s+http-use-proxy-header\\|option\s+httpchk\\|option\s+httpclose\\|option\s+httplog\\|option\s+httpslog\\|option\s+independent-streams\\|option\s+ldap-check\\|option\s+external-check\\|option\s+log-health-checks\\|option\s+log-separate-errors\\|option\s+logasap\\|option\s+mysql-check\\|option\s+nolinger\\|option\s+originalto\\|option\s+persist\\|option\s+pgsql-check\\|option\s+prefer-last-server\\|option\s+redispatch\\|option\s+redis-check\\|option\s+smtpchk\\|option\s+socket-stats\\|option\s+splice-auto\\|option\s+splice-request\\|option\s+splice-response\\|option\s+spop-check\\|option\s+srvtcpka\\|option\s+ssl-hello-chk\\|option\s+tcp-check\\|option\s+tcp-smart-accept\\|option\s+tcp-smart-connect\\|option\s+tcpka\\|option\s+tcplog\\|option\s+transparent\\|option\s+idle-close-on-response\\|external-check\s+command\\|external-check\s+path\\|persist\s+rdp-cookie\\|rate-limit\s+sessions\\|redirect\\|retries\\|retry-on\\|server\\|server-state-file-name\\|server-template\\|source\\|srvtcpka-cnt\\|srvtcpka-idle\\|srvtcpka-intvl\\|stats\s+admin\\|stats\s+auth\\|stats\s+enable\\|stats\s+hide-version\\|stats\s+http-request\\|stats\s+realm\\|stats\s+refresh\\|stats\s+scope\\|stats\s+show-desc\\|stats\s+show-legends\\|stats\s+show-node\\|stats\s+uri\\|stick\s+match\\|stick\s+on\\|stick\s+store-request\\|stick\s+store-response\\|stick-table\\|tcp-check\s+comment\\|tcp-check\s+connect\\|tcp-check\s+expect\\|tcp-check\s+send\\|tcp-check\s+send-lf\\|tcp-check\s+send-binary\\|tcp-check\s+send-binary-lf\\|tcp-check\s+set-var\\|tcp-check\s+unset-var\\|tcp-request\s+connection\\|tcp-request\s+content\\|tcp-request\s+inspect-delay\\|tcp-request\s+session\\|tcp-response\s+content\\|tcp-response\s+inspect-delay\\|timeout\s+check\\|timeout\s+client\\|timeout\s+client-fin\\|timeout\s+client-hs\\|timeout\s+connect\\|timeout\s+http-keep-alive\\|timeout\s+http-request\\|timeout\s+queue\\|timeout\s+server\\|timeout\s+server-fin\\|timeout\s+tarpit\\|timeout\s+tunnel\\|unique-id-format\\|unique-id-header\\|use_backend\\|use-fcgi-app\\|use-server\\)" . font-lock-variable-name-face)

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
   ;; paths, time, ports
   '("\\(/[/a-z.]+\\)\\(\s+\\|$\\)" . font-lock-string-face)
   '("\\([0-9]+\\)\\([um]?\\)\\([smhd]$\\)" . font-lock-string-face)
   '("\\(:[0-9]+\\)\\(\s+\\|$\\)" . font-lock-string-face)
   ;; alert to the presence of acls
   '(" if " . font-lock-builtin-face)))


;;;;##########################################################################
;;;;  Code
;;;;##########################################################################

(defvar haproxy-mode-map
  (let
      ((map (make-sparse-keymap)))
    map)
  "Keymap for editing haproxy config files.")

; TODO flycheck & flymake support via haproxy -c shell-command (+ invokability via local key or menu bar)
; TODO indent-line-function
; TODO define abbrevs

;; (define-abbrev global-abbrev-table "lol" "LAUGHT OUT LOUD")

;; (defun test ()
;;   (let ((prompt (read-string "Give me something: ")))
;;     (insert (concat "LAUGHT OUT LOUD -- " prompt))))

;; (define-abbrev global-abbrev-table "lol" "" 'test)

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
              ;; FIXME consult not grouping these properly
              imenu-generic-expression `(("Misc" "^\\(listen\\|resolvers\\)" 0)
                                         ("Backends" "^\\(backend\\)\\([\s\t]+\\)\\(.*\\)" 3)
                                         ("Frontends" "^\\(frontend\\)\\([\s\t]+\\)\\(.*\\)" 3)
                                         ("--" "^\\(global\\|defaults\\)" 0))
              font-lock-defaults '(haproxy-font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("haproxy\\.cfg\\'"  . haproxy-mode))

(provide 'haproxy-mode)

;;; haproxy-mode.el ends here

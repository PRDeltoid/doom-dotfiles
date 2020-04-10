;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Taylor"
      user-mail-address "")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Source Code Pro" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! org (setq
  org-directory "~/Dropbox/org/gtd/"
  org-startup-indented t
  org-pretty-entities t
  org-outline-path-complete-in-steps nil
  org-refile-use-outline-path t
  org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "MAYBE(m)" "|" "DONE(d)" "CANCELLED(c)"))
  org-tag-alist '(("@home" . ?h) ("@school" . ?s) ("buy" . ?b) ("DONE" . ?d) ("PROJECT" . ?p) ("AREA" . ?a))
  org-archive-location (concat org-directory "archive.org::")
  org-stuck-projects '("+PROJECT/-MAYBE-DONE-CANCELLED" ("TODO") nil "\\<IGNORE\\>")
  org-agenda-files
        (list (concat org-directory "todo.org")
              (concat org-directory "inbox.org")
              (concat org-directory "incubator.org")))
  org-refile-targets
      '((nil :maxlevel . 2)
        (org-agenda-files :maxlevel . 2))
  (add-hook 'org-mode-hook #'visual-line-mode)
  )


(setq org-agenda-custom-commands
    '(
      ("W" todo-tree "WAITING")
      ("r" "Refile"
        ((todo "TODO"
              ((org-agenda-files (list (concat org-directory "inbox.org")))))))
      ("h" tags-todo "@home")
      ("s" tags-todo "@school")
      ("n" todo "NOTE")
      ("p" tags-todo "PROJECT" nil)
      ("A" tags-todo "AREA" nil)
      ("a" "My agenda"
        ((org-agenda-list)
        (todo "TODO"
              ((org-agenda-overriding-header "Refile")
                (org-agenda-files (list (concat org-directory "inbox.org")))))
        (org-agenda-list-stuck-projects)
        (todo "TODO"
              ((org-agenda-overriding-header "Actions")
                (org-agenda-files (list (concat org-directory "todo.org")))
                ))))))
(setq org-capture-templates
    '(("t" "Todo" entry (file+headline (lambda() (concat org-directory "inbox.org")) "Inbox")
        "** TODO %?\n%U" :empty-lines 1)
      ("T" "Todo with Clipboard" entry (file+headline (lambda () (concat org-directory "inbox.org")) "Inbox")
        "** TODO %?\n%U\n   %c" :empty-lines 1)
      ("n" "Note" entry (file+headline (lambda () (concat org-directory "inbox.org")) "Inbox")
        "** NOTE %?\n%U" :empty-lines 1)
      ("I" "Incubator" entry (file (lambda () (concat org-directory "incubator.org")))
        "** %?\n%U" :empty-lines 1)))
;; ------------------
;; Emacs Settings
;; ------------------

(global-visual-line-mode t) ; wrap lines at border
(setq create-lockfiles nil) ; turn off lock files
(setq display-line-numbers-type 'relative) ; relative line numbers

;; ------------------
;; Keymaps
;; ------------------

(map! :nv ";" 'evil-ex) ; make semi-colon behave as colon in evil mode
(map! :n "t" 'org-todo) ; make t open org-todo on line

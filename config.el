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
(setq doom-big-font (font-spec :family "Source Code Pro" :size 40))

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
;;
;; ----------------
;; Variables
;; ----------------
(setq +org-base-path "~/Dropbox/org/")
(setq +daypage-path (concat +org-base-path "days/"))
(setq +org-wiki-path (concat +org-base-path "wiki/"))
(setq +org-wiki-index (concat +org-wiki-path "index.org"))
(setq +org-todo-file (concat +org-base-path "todo.org"))
(setq +org-inbox-file (concat +org-base-path "inbox.org"))
(setq +org-incubator-file (concat +org-base-path "incubator.org"))
(setq +org-quotes-file (concat +org-wiki-path "personal/quotes.org"))

;; ----------------
;; My Functions
;; ----------------

(defun open-wiki ()
  (interactive)
  (find-file
   (expand-file-name +org-wiki-index)))

;; ----------------
;; Org Stuff
;; ----------------
(after! org (setq
  org-capture-templates '()
  org-directory "~/Dropbox/org/gtd/"
  org-startup-indented t
  org-pretty-entities t
  org-want-todo-bindings t
  ;;org-outline-path-complete-in-steps nil
  org-refile-use-outline-path t
  org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "MAYBE(m)" "|" "DONE(d)" "CANCELLED(c)"))
  org-tag-alist '(("@home" . ?h) ("@school" . ?s) ("buy" . ?b) ("PROJECT" . ?p))
  org-archive-location (concat org-directory "archive.org::")
  org-stuck-projects '("+PROJECT/-MAYBE-DONE-CANCELLED" ("TODO") nil "\\<IGNORE\\>")
  org-agenda-files
        (list +org-todo-file
              +org-inbox-file
              +org-incubator-file))
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
              ((org-agenda-files (list +org-inbox-file))))))
      ("h" tags-todo "@home")
      ("s" tags-todo "@school")
      ("a" "My agenda"
        ((org-agenda-list)
        (todo "TODO"
              ((org-agenda-overriding-header "Refile")
                (org-agenda-files (list +org-inbox-file))))
        (org-agenda-list-stuck-projects)
        (todo "TODO"
              ((org-agenda-overriding-header "Actions")
                (org-agenda-files (list +org-todo-file))
                ))))))


;; ----------------
;; Org Captures
;; ----------------
;; %t - timestamp, date only, also %^t for "prompt for date"
;; %T - date-time stamp
;; %U - inactive timestamp (???)
;; %c - clipboard head, %C - interactive clipboard selection
;; %f - name of file capture called from
;; %F - full path of file capture was called from
;; %^g - prompt for tags, also %^G for tag completion from tags in all agenda files
;; %^{PROMPT} - prompt for input using PROMPT as a prompt. Replace with entered value
;; %? - position cursor here after template has been expanded
(after! org
  (add-to-list 'org-capture-templates
      '("t" "Todo" entry (file +org-inbox-file)
        "* TODO %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("T" "Todo with Clipboard" entry (file +org-inbox-file)
        "* TODO %?\n%U\n   %c" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("n" "Note" entry (file +org-inbox-file)
        "* NOTE %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("r" "Research" entry (file +org-inbox-file)
        "* RESEARCH %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("I" "Incubator" entry (file +org-incubator-file)
        "* %?\n%U" :empty-lines 1)))


(after! org
  (add-to-list 'org-capture-templates
      '("Q" "Quote" entry (file +org-quotes-file)
        "* %?\n" :empty-lines 1)))
;; ------------------
;; General Emacs Settings
;; ------------------

(global-visual-line-mode t) ; wrap lines at border
(setq create-lockfiles nil) ; turn off lock files
(setq display-line-numbers-type 'relative) ; relative line numbers

;; ------------------
;; Keymaps
;; ------------------

(map! :nv ";" 'evil-ex) ; make semi-colon behave as colon in evil mode

(after! org
  (map! :map evil-org-mode-map
        :localleader
        :desc "Create/Edit Todo" "t" #'org-todo
        :desc "Schedule" "s" #'org-schedule
        :desc "Deadline" "d" #'org-deadline
        :desc "Refile" "r" #'org-refile
        :desc "Filter" "f" #'org-match-sparse-tree))

(map! :leader
      :prefix "n"
      "o" #'todays-daypage
      "O" #'find-daypage
      "w" #'open-wiki)

;;Make unhiding link prettifying syntax easier
(after! org
  (map! :map evil-org-mode-map
        :localleader
        :prefix "l"
        "t" #'org-toggle-link-display))

(after! org-roam
        (map! :leader
            :prefix "n"
            :desc "org-roam" "l" #'org-roam
            :desc "org-roam-insert" "i" #'org-roam-insert
            :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
            :desc "org-roam-find-file" "f" #'org-roam-find-file
            :desc "org-roam-capture" "c" #'org-roam-capture))

;; ----------------
;; Daypage Stuff
;; from https://github.com/ar1a/dotfiles/blob/master/emacs/.doom.d/%2Borg.el
;; ----------------
(defun find-daypage (&optional date)
  "Go to the day page for the specified date, or today's if none is specified"
  (interactive (list (org-read-date)))
  (setq date (or date (format-time-string "%Y-%m-%d" (current-time))))
  (find-file
   (expand-file-name (concat +daypage-path date ".org"))))

(defun todays-daypage ()
  "Go straight to today's day page without prompting for a date."
  (interactive)
  (find-daypage))

(set-file-template!
 "/[0-9]\\{4\\}\\(?:-[0-9]\\{2\\}\\)\\{2\\}\\.org$"
 :trigger "__daypage")

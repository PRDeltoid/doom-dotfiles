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
(setq +org-gtd-path (concat +org-base-path "gtd/"))
(setq +daypage-path (concat +org-base-path "days/"))
(setq +org-wiki-path (concat +org-base-path "wiki/"))
(setq +org-wiki-index (concat +org-wiki-path "index.org"))
(setq +org-todo-file (concat +org-gtd-path "todo.org"))
(setq +org-inbox-file (concat +org-gtd-path "inbox.org"))
(setq +org-wiki-inbox-file (concat +org-wiki-path "wiki_inbox.org"))
(setq +org-incubator-file (concat +org-gtd-path "incubator.org"))
(setq +org-quotes-file (concat +org-wiki-path "personal/quotes.org"))

(setq fill-column 90)


;; ----------------
;; My Functions
;; ----------------
(defun open-wiki ()
  (interactive)
  (find-file
   (expand-file-name +org-wiki-index)))


;; Allow search of my personal knowledgebase
(defun my/org-notes-search ()
  "Perform a text search on `org-wiki-path'."
  (interactive)
  (require 'org)
  (let ((default-directory +org-wiki-path))
    (+default/search-project-for-symbol-at-point "")))

;; ----------------
;; Doom Stuff
;; ----------------

;; Add a Wiki link to the dashboard menu
(setq +doom-dashboard-menu-sections
      (cons '("Open wiki"
        :icon (all-the-icons-octicon "clippy" :face 'doom-dashboard-menu-title)
        :action open-wiki)
      +doom-dashboard-menu-sections))

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
  org-refile-use-outline-path 'file
  org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "MAYBE(m)" "|" "DONE(d)" "CANCELLED(c)"))
  org-tag-alist '(("@home" . ?h) ("@self" . ?s) ("Testbrain" . ?t) ("Misc" . ?m)("MagicMirror" . ?a) ("PiNAS" . ?c))
  org-archive-location (concat org-directory "archive.org::")
  org-stuck-projects '("+PROJECT/-MAYBE-DONE-CANCELLED" ("TODO") nil "\\<IGNORE\\>")
  org-agenda-files
        (list +org-todo-file
              +org-inbox-file
              +org-incubator-file)
  org-hide-emphasis-markers t)
  org-refile-targets
      '((nil :maxlevel . 2)
        (org-agenda-files :maxlevel . 2))
  (add-hook 'org-mode-hook #'visual-line-mode)
  )

(after! org
  (add-to-list 'org-capture-templates
      '("b" "Bug" entry (file +org-todo-file)
        "* BUG %?\n%U" :empty-lines 1)))

(setq org-agenda-custom-commands
  '(
    ("h" tags-todo "@home")
    ("W" todo-tree "WAITING")
    ("r" "Refile"
      ((todo "TODO"
              ((org-agenda-files (list +org-inbox-file))))))
    ("a" "My agenda"
      ((tags-todo "@home"
            ((org-agenda-overriding-header "Home")(org-agenda-sorting-strategy '(todo-state-up))))
       (tags-todo "@self"
            ((org-agenda-overriding-header "Self Improvement")(org-agenda-sorting-strategy '(todo-state-up))))
       (tags-todo "Misc"
            ((org-agenda-overriding-header "Miscellaneous")(org-agenda-sorting-strategy '(todo-state-up))))
      (tags-todo "Testbrain"
            ((org-agenda-overriding-header "Testbrain")(org-agenda-sorting-strategy '(todo-state-up))))
      (tags-todo "PiNAS"
            ((org-agenda-overriding-header "Pi NAS")(org-agenda-sorting-strategy '(todo-state-up))))
      (tags-todo "MagicMirror"
            ((org-agenda-overriding-header "Magic Mirror")(org-agenda-sorting-strategy '(todo-state-up))))
      (tags-todo "-{.*}"
            ((org-agenda-overriding-header "Untagged")(org-agenda-files(list +org-todo-file))(org-agenda-sorting-strategy '(todo-state-up))))
      (todo "TODO"
            ((org-agenda-overriding-header "Refile")
              (org-agenda-files (list +org-inbox-file))))
      (todo "TODO"
            ((org-agenda-overriding-header "Incubator")
             (org-agenda-files (list +org-incubator-file))))))))

;; Delete empty org agenda sections
(defun org-agenda-delete-empty-blocks ()
    "Remove empty agenda blocks.
  A block is identified as empty if there are fewer than 2
  non-empty lines in the block (excluding the line with
  `org-agenda-block-separator' characters)."
    (when org-agenda-compact-blocks
      (user-error "Cannot delete empty compact blocks"))
    (setq buffer-read-only nil)
    (save-excursion
      (goto-char (point-min))
      (let* ((blank-line-re "^\\s-*$")
             (content-line-count (if (looking-at-p blank-line-re) 0 1))
             (start-pos (point))
             (block-re (format "%c\\{10,\\}" org-agenda-block-separator)))
        (while (and (not (eobp)) (forward-line))
          (cond
           ((looking-at-p block-re)
            (when (< content-line-count 2)
              (delete-region start-pos (1+ (point-at-bol))))
            (setq start-pos (point))
            (forward-line)
            (setq content-line-count (if (looking-at-p blank-line-re) 0 1)))
           ((not (looking-at-p blank-line-re))
            (setq content-line-count (1+ content-line-count)))))
        (when (< content-line-count 2)
          (delete-region start-pos (point-max)))
        (goto-char (point-min))
        ;; The above strategy can leave a separator line at the beginning
        ;; of the buffer.
        (when (looking-at-p block-re)
          (delete-region (point) (1+ (point-at-eol))))))
    (setq buffer-read-only t))

  (add-hook 'org-agenda-finalize-hook #'org-agenda-delete-empty-blocks)
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
      '("t" "Todo" entry (file +org-todo-file)
        "* TODO %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("T" "Todo with Clipboard" entry (file +org-todo-file)
        "* TODO %?\n%U\n   %c" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("n" "Note" entry (file +org-wiki-inbox-file)
        "* NOTE %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("r" "Research" entry (file +org-todo-file)
        "* RESEARCH %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("i" "Inbox TODO" entry (file +org-inbox-file)
        "* TODO %?\n%U" :empty-lines 1)))

(after! org
  (add-to-list 'org-capture-templates
      '("I" "Incubator" entry (file +org-incubator-file)
        "* TODO %?\n%U" :empty-lines 1)))


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

;; Make scrolling over pictures less shitty
;; (pixel-scroll-mode)
;; (setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
;; (setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
;; (setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.
;; (setq mouse-wheel-progressive-speed nil) ; Progressive speed is too fast for me.

;;
;; Keymaps
;; ------------------

(map! :nv ";" 'evil-ex
      :n "t" 'org-todo) ; make semi-colon behave as colon in evil mode

(after! org
  (map! :map evil-org-mode-map
        :localleader
        :desc "Create/Edit Todo" "t" #'org-todo
        :desc "Schedule" "s" #'org-schedule
        :desc "Deadline" "d" #'org-deadline
        :desc "Refile" "r" #'org-refile
        :desc "Filter" "f" #'org-match-sparse-tree
        :desc "Screenshot" "i" #'my/org-download-clipboard))

(map! :leader
      :prefix "n"
      "o" #'todays-daypage
      "O" #'find-daypage
      "w" #'open-wiki
      "." #'my/org-notes-search)

;; Shorthand for opening wiki
(map! :leader
      "W" #'open-wiki ;;Shorthand for opening wiki
      :desc "Open org-scratch buffer" "X" #'doom/open-scratch-buffer ;;Swap scratch buffer with capture
      :desc "org-capture" "x" #'org-capture) ;; Swap capture with scratch buffer

;;Make unhiding link prettifying syntax easier
(after! org
  (map! :map evil-org-mode-map
        :localleader
        :prefix "l"
        "t" #'org-toggle-link-display))

(use-package! org-download
  :after org)

;; ----------------
;; Org-Download Stuff
;; ----------------
(after! org
  (setq org-download-screenshot-method "convert clipboard: %s")
  (setq-default org-download-image-dir "./images")
  (setq-default org-download-heading-lvl nil)
  (setq org-download-screenshot-file "C:/Users/Taylor/AppData/Local/Temp/screenshot.png")
  (setq org-download-method 'directory)
  (setq org-download-annotate-function (lambda (_link) "")))

(defun my/org-download-clipboard ()
  (interactive)
  (require 'org-download)
  (org-download-clipboard)
  (org-download-rename-last-file))

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

;; ----------
;; Domain-specific config loading
;; Occurs at the end to make sure all the changes above are replaced 
;; with the more specific config being loaded below
;; ----------
(if (getenv "WORK")
    (load! "work-config.el" "~/.doom.d/work-config"))

;;Make it so SPC-f-f searches in the default org dir
(cd +org-base-path)

;;;; Nyxt Configuration - Initialization File

;;; Commentary:
;;; Set Mode & Browser Settings

;;; References
;;; 1. https://github.com/aartaka/nyxt-config/
;;; 2. https://discourse.atlas.engineer/t/where-is-the-download-directory-specified/285
;;;    Set XDG_DOWNLOAD_DIR in start-stumpwm.sh -> should define custom XDG env vars there!
;;;    see: nyxt:describe-function?fn=%1Bxdg-download-dir&function=%1Bxdg-download-dir
;;; 3. TBD
;;; 4. TBD


;;; Start-Up & Configuration

(in-package #:nyxt-user)

;;; Reset ASDF registries to allow loading Lisp systems from
;;; everywhere.
#+nxt-3 (reset-asdf-registries)

;;; Load quicklisp
#+quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))


;; Loading files from the same directory (~/.config/nyxt/).
(define-nyxt-user-system-and-load "nyxt-user/basic-config"
  :components ("theme" ; TODO - convert to an extension and keep utilities loaded as modules...
               "passwords"
               "passwords-dev"
               "utilities"))


;; Base broswer/buffer configurations
(define-configuration :browser
    ((restore-session-on-startup-p nil)))

(define-configuration :buffer
    ((default-modes `(emacs-mode ,@%slot-value%))))

;; Looks horrible...
;; (define-configuration :web-buffer
;;     ((default-modes `(dark-mode ,@%slot-value%))))

;; Drastically impacts Nyxt startup...
(define-configuration :web-buffer
    ((default-modes `(blocker-mode ,@%slot-value%))))

;; trialing out
(define-configuration :document-buffer
    ((search-always-auto-complete-p nil)))

;; Borrowed from aartaka
(define-configuration :prompt-buffer
    ((dynamic-attribute-width-p t)))

(defmethod files:resolve ((profile nyxt:nyxt-profile) (file nyxt/mode/bookmark:bookmarks-file))
  "Reroute bookmarks to the `.config/nyxt/' directory."
  #p"~/.config/nyxt/bookmarks.lisp")


;;; Nyxt Extensions

;; A simple extension that you can use to test your Nyxt installation (i.e. can you load extensions).
(define-nyxt-user-system-and-load "nyxt-user/nx-fruit-proxy"
  :description "This proxy system saves us if nx-fruit fails to load.
Otherwise it will break all the config loading."
  :depends-on ("nx-fruit"))

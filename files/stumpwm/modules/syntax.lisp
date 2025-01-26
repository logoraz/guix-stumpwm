;;;; syntax.lisp --> StumpWM Macro's, Helpers, & Commands

;;; Author:
;;; Erik P Almaraz

;;; License:
;;; GPLv3

;;; Commentary:
;;;

;;; References:
;;;

(in-package :stumpwm)

;;; StumpWM Commands, Helper Functions, and Macros

(defcommand delete-window-and-frame () ()
  "Delete the current frame with its window."
  (delete-window)
  (remove-split))

(defcommand hsplit-and-focus () ()
  "Create a new frame on the right and focus it."
  (hsplit)
  (move-focus :right))

(defcommand vsplit-and-focus () ()
  "Create a new frame below and move focus to it."
  (vsplit)
  (move-focus :down))

(defcommand term (&optional program) ()
  "Invoke a terminal, possibly with a @arg{program}."
  (sb-thread:make-thread
   (lambda ()
     (run-shell-command (if program
                            (format nil "kitty ~A" program)
                            "kitty")))))


;;; Common Lisp Servers (Slynk & Swank)
(defvar *stumpwm-port* 4005
  "Default port to establish a connection to either slynk or micros")

;; Lem connection to StumpWM
(defcommand micros-start-server () ()
  "Start a micros server for StumpWM/Lem."
  (sb-thread:make-thread
   (lambda ()
     (micros:create-server :port *stumpwm-port* :dont-close t))
   :name "Micros Server Process.")
  (echo-string (current-screen) "Starting micros for StumpWM."))

(defcommand micros-stop-server () ()
  "Stop current micros server for StumpWM."
  (micros:stop-server *stumpwm-port*)
  (echo-string (current-screen) "Closing micros."))

;; Emacs connection to StumpWM
(defcommand slynk-start-server () ()
  "Start a slynk server for sly."
  (require :slynk)
  (sb-thread:make-thread 
   (lambda ()
     (slynk:create-server :port *stumpwm-port* :dont-close t))
   :name "Slynk Server Process.")
  (echo-string (current-screen) "Starting slynk."))

(defcommand slynk-stop-server () ()
  "Stop current slynk server for sly."
  (slynk:stop-server *stumpwm-port*)
  (echo-string (current-screen) "Closing slynk."))


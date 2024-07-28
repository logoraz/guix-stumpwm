;;;; Guix HOME Configuration
;; TODO: use package symbols instead of package strings & specifications->packages
;; specify gnu packages & gnu services -> use-package-modules & use-service-modules
(use-modules (gnu)
             (gnu home)
             (gnu home services)
             (gnu home services desktop)
             (gnu home services sound)
             (gnu home services shells)
             (guix gexp))

(use-package-modules fonts web-browsers gnuzilla password-utils gnupg mail
                     gstreamer video gnucash gimp inkscape graphics compression
                     version-control xorg xdisorg compton image-viewers linux
                     music networking lisp lisp-xyz wm guile guile-xyz
                     emacs emacs-xyz)

(define %logoraz-packages
  (list font-fira-code  ;;|--> gnu packages fonts
        font-iosevka-aile
        font-dejavu
        font-google-noto
        font-google-noto-emoji
        font-google-material-design-icons
        font-google-noto-sans-cjk
        nyxt       ;;|--> gnu packages web-browsers :www-mail
        icecat     ;;|--> gnu packages gnuzilla
        keepassxc  ;;|--> gnu packages password-utils
        gnupg      ;;|--> gnu packages gnupg
        isync      ;;|--> gnu packages mail
        msmtp
        mu
        gstreamer  ;;|--> gnu packages gstreamer
        gst-plugins-good
        gst-plugins-bad
        gst-libav
        mpv        ;;|--> gnu packages video :apps
        vlc
        gnucash    ;;|--> gnu packages gnucash
        gimp       ;;|--> gnu packages gimp
        inkscape   ;;|--> gnu packages inkscape
        blender    ;;|--> gnu packages graphics
        zip        ;;|--> gnu packages compression :utilities
        unzip
        git))      ;;|--> gnu packages version-control

(define %x11-util-packages
  (list xterm      ;;|--> gnu packages xorg
        xterm
        transset
        xhost
        xset
        xsetroot
        xinput
        xrdb
        xrandr
        xclip      ;;|--> gnu packages xdisorg
        xsel
        xss-lock
        picom      ;;|--> gnu packages compton
        feh        ;;|--> gnu packages image-viewers
        pipewire   ;;|--> gnu packages linux
        wireplumber
        lm-sensors
        brightnessctl
        playerctl  ;;|--> gnu packages music
        blueman))  ;;|--> gnu package networking

(define %cl-stumpwm-packages
  ;;clasp?? |--> gnux packages lisp
  (list sbcl-slynk ;;|--> gnu packages lisp-xyz
        sbcl-parse-float
        sbcl-cl-ppcre
        sbcl-zpng
        sbcl-salza2
        sbcl-clx
        sbcl-zpb-ttf
        sbcl-cl-vectors
        sbcl-cl-store
        sbcl-trivial-features
        sbcl-global-vars
        sbcl-trivial-garbage
        sbcl-bordeaux-threads
        sbcl-cl-fad
        sbcl-clx-truetype
        sbcl-stumpwm-ttf-fonts ;;|--> gnu packages wm :stumpwm-contrib/util
        sbcl-stumpwm-kbd-layouts
        sbcl-stumpwm-swm-gaps
        sbcl-stumpwm-globalwindows
        sbcl-stumpwm-screenshot
        sbcl-stumpwm-cpu ;;:stumpwm-contrib/modeline
        sbcl-stumpwm-mem
        sbcl-stumpwm-wifi
        sbcl-stumpwm-battery-portable))

(define %emacs-packages
  (list  guile-next      ;;|--> gnu packages guile
         guile-ares-rs   ;;|--> gnu packages guile-xyz
         emacs           ;;|--> gnu packages emacs
         emacs-diminish  ;;|--> gnu packages emacs-xyz
         emacs-delight
         emacs-nord-theme
         emacs-doom-themes
         emacs-nerd-icons
         emacs-doom-modeline
         emacs-ligature
         emacs-no-littering
         emacs-ws-butler
         emacs-undo-tree
         emacs-paredit
         emacs-visual-fill-column
         emacs-mct
         emacs-orderless
         emacs-corfu
         emacs-marginalia
         emacs-beframe
         emacs-denote
         emacs-magit
         emacs-vterm
         emacs-guix
         emacs-arei
         emacs-sly
         emacs-mbsync
         emacs-org-superstar
         emacs-org-appear
         emacs-erc-hl-nicks
         emacs-erc-image
         emacs-emojify))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages (append
            %logoraz-packages
            %x11-util-packages
            %cl-stumpwm-packages
            %emacs-packages))
 
 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 ;; TODO: Implement the following
 ;; 1. (service home-xdg-configuration-files-service-type ...)
 ;; 2. (service home-files-service-type ...)
 ;; 3. (service home-dotfiles-service-type ..)
 (services
  (list
   (simple-service 'env-vars home-environment-variables-service-type
                   '(("EDITOR" . "emacs")
                     ("BROWSER" . "nyxt")
                     ("XDG_SESSION_TYPE" . "x11")
                     ("XDG_SESSION_DESKOP" . "stumpwm")
                     ("XDG_CURRENT_DESKTOP" . "stumpwm")
                     ("XDG_DOWNLOAD_DIR" . "/home/logoraz/Downloads/")))
   (service home-dbus-service-type)
   (service home-pipewire-service-type)
   (service home-bash-service-type
            (home-bash-configuration
	     (guix-defaults? #f)
             (aliases '(("grep" . "grep --color=auto")
                        ("ls"   . "ls -p --color=auto")
                        ("ll"   . "ls -l")
                        ("la"   . "ls -la")
                        ("ghr"  . "guix home reconfigure")
                        ("gsr"  . "sudo guix system reconfigure")
                        ("gup"  . "guix pull && guix upgrade")
                        ("gud"  . "guix system delete-generations")
                        ("ghd"  . "guix home delete-generations")))
             (bashrc
              (list (local-file "./dot-bashrc.sh"
                                #:recursive? #t)))
             (bash-profile
              (list (local-file "./dot-bash_profile.sh"
                                #:recursive? #t))))))))

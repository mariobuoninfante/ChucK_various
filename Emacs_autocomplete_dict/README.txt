ChucK Dictionary for Emacs auto-complete package
---

INSTALL
---
  - download Emacs auto-complete here: https://github.com/auto-complete

  - after auto-complete is installed place "chuck-mode" in the autocomplete /dict folder (should be here: ~/.emacs.d/elpa/autocomplete)

  - in Emacs go to "Customize Setup -> Auto Complete" and add "chuck-mode" to "Ac Modes"



EXTRA
---
in my "~/.emacs" I added:

(ac-config-default)
(global-auto-complete-mode t)

to turn auto-complete ON by default. This with Emacs 26.3 on Ubuntu Studio 20.04 LTS.

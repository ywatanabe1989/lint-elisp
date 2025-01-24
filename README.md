<!-- ---
!-- Timestamp: 2025-01-25 02:06:42
!-- Author: ywatanabe
!-- File: /home/ywatanabe/proj/lint-elisp/README.md
!-- --- -->

# lint-elisp

A simple Emacs package for formatting Elisp code with consistent style.

## Installation

1. Copy `lint-elisp.el` to your Emacs load path
2. Add to your init file:

```elisp
(require 'lint-elisp)
```

## Usage

`M-x lint-this-elisp-buffer`

## Configurations
``` elisp
;; C-c C-l
(define-key emacs-lisp-mode-map
            (kbd "C-c C-l")
            'lint-this-elisp-buffer)

;; Before saving
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'lint-this-elisp-buffer nil t)))
```

## License

MIT

## Contact

Yusuke Watanabe (ywtanabe@alumini.u-tokyo.ac.jp)


<!-- EOF -->
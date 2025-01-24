;;; -*- coding: utf-8; lexical-binding: t -*-
;;; Author: 2025-01-25 02:21:17
;;; Timestamp: <2025-01-25 02:21:17>
;;; File: /home/ywatanabe/proj/lint-elisp/lint-elisp.el


;; 1. Main entry
;; ----------------------------------------

(defun lint-this-elisp-buffer ()
  "Format current elisp buffer with consistent style.
Handles header skipping, whitespace cleanup, indentation,
and adds newlines before parentheses and comments."
  (interactive)
  (when (derived-mode-p 'emacs-lisp-mode)
    (let ((original-point (point)))

      ;; Skip header
      (--skip-header)

      ;; Clean up extra whitespace
      (--cleanup-extra-white-spaces)

      ;; Formats Indent
      (--format-indents)

      ;; Add newlines before parentheses
      (--add-newline-before-top-level-parentheses)

      ;; Add newlines before comments
      (--add-newline-before-comment-blocks)

      ;; Final formatting
      (goto-char original-point))))

;; 2. Core functions
;; ----------------------------------------

(defun --skip-header ()
  "Skip past comment-only lines at buffer start."
  (goto-char (point-min))
  (while (looking-at "^;")
    (forward-line)))

(defun --cleanup-extra-white-spaces ()
  "Remove extra whitespace and blank lines throughout buffer."
  (while (not (eobp))
    (let ((line-start (point)))
      (forward-line)
      (when (looking-at "[\t\n ]*[^[:space:]]")
        (delete-horizontal-space)
        (delete-blank-lines)))))

(defun --format-indents ()
  "Indent entire buffer according to elisp formatting rules."
  (mark-whole-buffer)
  (indent-for-tab-command))

(defun --add-newline-before-top-level-parentheses ()
  "Add newline before each top-level form."
  (goto-char (point-min))
  (while (re-search-forward "^(" nil t)
    (forward-line -1)
    (end-of-line)
    (insert "\n")
    (forward-line 2)))

(defun --is-top-of-consecutive-comment ()
  "Check if current line is top of consecutive comment block."
  (interactive)
  (let* (;; Previous
         (_ (forward-line -1))
         (is-comment-previous (looking-at "^[[:space:]]*;"))
         (_ (forward-line 1))

         ;; Current
         (is-comment-current (looking-at "^[[:space:]]*;"))

         ;; Next
         (_ (forward-line 1))
         (is-comment-next (looking-at "^[[:space:]]*;"))
         (_ (forward-line -1))
         (is-top (and (not is-comment-previous) is-comment-current))
         (is-bottom (and is-comment-current (not is-comment-next)))
         (is-top-of-comment-block (and is-top (not is-bottom))))
    (message "%s" is-top-of-comment-block)
    is-top-of-comment-block))

(defun --is-bottom-of-consecutive-comment ()
  "Check if current line is top of consecutive comment block."
  (interactive)
  (let* (;; Previous
         (_ (forward-line -1))
         (is-comment-previous (looking-at "^[[:space:]]*;"))
         (_ (forward-line 1))

         ;; Current
         (is-comment-current (looking-at "^[[:space:]]*;"))

         ;; Next
         (_ (forward-line 1))
         (is-comment-next (looking-at "^[[:space:]]*;"))
         (_ (forward-line -1))
         (is-top (and (not is-comment-previous) is-comment-current))
         (is-bottom (and is-comment-current (not is-comment-next)))
         (is-top-of-comment-block (and (not is-top) is-bottom)))
    (message "%s" is-top-of-comment-block)
    is-top-of-comment-block))

(defun --is-single-line-comment ()
  "Check if current line is a single line comment."
  (interactive)
  (let* (;; Previous
         (_ (forward-line -1))
         (is-comment-previous (looking-at "^[[:space:]]*;"))
         (_ (forward-line 1))

         ;; Current
         (is-comment-current (looking-at "^[[:space:]]*;"))

         ;; Next
         (_ (forward-line 1))
         (is-comment-next (looking-at "^[[:space:]]*;"))
         (_ (forward-line -1))
         (is-single (and (not is-comment-previous)
                         is-comment-current
                         (not is-comment-next))))
    (message "%s" is-single)
    is-single))

(defun --add-newline-before-comment-blocks ()
  "Add newline before comment blocks, preserving consecutive comments."
  (goto-char (point-min))
  (while (re-search-forward "^[[:space:]]*;" nil t)
    (beginning-of-line)
    (when (or (--is-top-of-consecutive-comment) (--is-single-line-comment))
      (forward-line -1)
      (end-of-line)
      (insert "\n")
      (forward-line 1))
    (forward-line 1)
    (end-of-line)))

;; ;; 3. Key Binding and Hook
;; ;; ----------------------------------------
;; (define-key emacs-lisp-mode-map
;;             (kbd "C-c C-l")
;;             'lint-this-elisp-buffer)
;; ;; Before saving
;; (add-hook 'emacs-lisp-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook 'lint-this-elisp-buffer nil t)))
;; ;; EOF

(provide 'lint-elisp)

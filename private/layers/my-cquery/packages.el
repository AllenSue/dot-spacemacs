;;; packages.el --- My cquery Layer packages File for Spacemacs

(defconst my-cquery-packages
  '(
    (company-lsp :requires company)
    (cquery :requires lsp-mode)
    helm-xref
    lsp-mode
    (lsp-ui :requires lsp-mode)
    ))

(defun my-cquery/init-cquery()
  (use-package cquery
    :init
    (add-hook 'c-mode-common-hook
              (lambda ()
                (require 'company-lsp)
                (lsp-cquery-enable)))
    :config
    (setq
     cquery-executable "/home/allen/tools/cquery/build/release/bin/cquery"
     cquery-extra-init-params '(:index (:comments 0) :completion (:detailedLabel t))
     )
    ))

(defun my-cquery/init-company-lsp()
  (use-package company-lsp
    :defer t
    :init
    (setq company-quickhelp-delay 0)
    ;; Language servers have better idea filtering and sorting,
    ;; don't filter results on the client side.
    (setq
     company-transformers nil
     company-lsp-async t
     company-lsp-cache-candidates nil
     )
    (spacemacs|add-company-backends :backends company-lsp :modes c-mode-common)
    ))

(defun my-cquery/init-helm-xref()
  (use-package helm-xref
    :config
    (progn
      ;; This is required to make xref-find-references not give a prompt.
      ;; xref-find-references asks the identifier (which has no text property) and
      ;; then passes it to lsp-mode, which requires the text property at point to
      ;; locate the references.
      ;; https://debbugs.gnu.org/cgi/bugreport.cgi?bug=29619
      (setq xref-prompt-for-identifier
            '(not
              xref-find-definitions
              xref-find-definitions-other-window
              xref-find-definitions-other-frame
              xref-find-references
              spacemacs/jump-to-definition))
      ;; Use helm-xref to display xref.el results.
      (setq xref-show-xrefs-function #'helm-xref-show-xrefs)
      )))

(defun my-cquery/init-lsp-mode()
  (use-package lsp-mode
    :defer t
    :config
    (progn
      (require 'lsp-flycheck)
      (require 'lsp-imenu)
      (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)
      (spacemacs|diminish lsp-mode " Ⓛ" " L")
      )))

(defun my-cquery/init-lsp-ui()
  (use-package lsp-ui
    :init
    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
    :config
    (progn
      (setq
       lsp-ui-sideline-show-symbol nil  ; don't show symbol on the right of info
       lsp-ui-sideline-show-hover nil
       )
      (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
      (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
      )))

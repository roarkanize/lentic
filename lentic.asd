;;;; lentic.asd

(asdf:defsystem #:lentic
  :description "An experimental expansion to Coalton's standard library. "
  :author "roarkanize <roarkanize@disroot.org>"
  :license "BSD-3"
  :version "alpha"
  :depends-on (#:coalton)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "enum")
               (:file "file")))

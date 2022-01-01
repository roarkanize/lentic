(in-package #:cl-user)

(uiop:define-package #:lentic
  (:use #:coalton #:coalton-library)
  
  ;; Types
  (:export
   #:Enum
   #:Bounded
   #:File
   #:IOMode)

  ;; num.lisp
  (:export
   #:minBound
   #:maxBound
   #:succ
   #:pred
   #:toEnum
   #:fromEnum)

  ;; file.lisp
  (:export
   #:ReadMode
   #:WriteMode
   #:AppendMode
   #:openMode
   #:closeMode
   #:getLine))

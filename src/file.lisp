(cl:in-package #:lentic)

(coalton-toplevel
  (define-type File (File Lisp-Object IOMode))
  (define-type IOMode
    ReadMode
    WriteMode
    AppendMode)

  (declare openFile (String -> IOMode -> (Result String File)))
  (declare closeFile (File -> Unit))
  (declare getLine (File -> (Result String String)))

  (define (openFile path mode)
    (lisp (Result String File) (path mode)
      (cl:handler-case
          (coalton-library:Ok
           (cl:cond
             ((cl:eq mode ReadMode) (File (cl:open path :direction :input) mode))
             ((cl:eq mode WriteMode) (File (cl:open path :direction :output) mode))
             ((cl:eq mode AppendMode) (File (cl:open path :direction :output :if-exists :append) mode))))
        (cl:t (c)
          (coalton-library:Err (cl:format cl:nil "~a" c))))))

  (define (closeFile file)
    (match file
      ;; The result of `CLOSE' if given a stream that is already closed is "implementation dependent",
      ;; but testing on SBCL, always returns `COMMON-LISP:T' regardless of the stream's status.
      ;; I am aware that this is not standard behavior but I choose to stick to it.
      ((File f _) (lisp Unit (f) (cl:progn (cl:close f) unit)))))

  (define (getLine file)
    (match file
      ((File stream mode)
       (lisp (Result String String) (stream mode)
         (cl:cond
           ((cl:eq mode ReadMode) (cl:handler-case
                                      (coalton-library:Ok (cl:read-line stream cl:nil))
                                    (cl:t (c)
                                      (coalton-library:Err (cl:format cl:nil "~a" c)))))
           (cl:t (coalton-library:Err "file handler is not in read mode"))))))))

(cl:in-package #:lentic)

(coalton-toplevel
  (define-class (Enum :a)
    "Types that can be sequentially ordered."
    (succ (:a -> :a))
    (pred (:a -> :a))
    (toEnum (Integer -> :a))
    (fromEnum (:a -> Integer)))
  (define-class (Bounded :a)
    "Types that are bounded in size"
    (minBound :a)
    (maxBound :a)))

(cl:defmacro %define-enum-stuff (name bits signed?)
  `(coalton-toplevel
     (define-instance (Bounded ,name)
       (define minBound (the ,name (into (if ,signed? ,(cl:- 0 (cl:expt 2 (cl:- bits 1))) 0))))
       (define maxBound (the ,name (into (if ,signed? ,(cl:- (cl:expt 2 (cl:- bits 1)) 1) ,(cl:- (cl:expt 2 bits) 1))))))
     (define-instance (Enum ,name)
       (define (succ a)
         (match a
           (maxBound (error ,(cl:format cl:nil "Enum.succ{~A}: bad argument" name)))
           (_ (+ (into 1) a))))
       (define (pred a)
         (match a
           (minBound (error ,(cl:format cl:nil "Enum.pred{~a}: bad argument" name)))
           (_ (- a (into 1)))))
       (define (toEnum a) (fromInt a))
       (define (fromEnum a) (into a)))))

(%define-enum-stuff U8 8 False)
(%define-enum-stuff U16 16 False)
(%define-enum-stuff U32 32 False)
(%define-enum-stuff U64 64 False)
(%define-enum-stuff I8 8 True)
(%define-enum-stuff I16 16 True)
(%define-enum-stuff I32 32 True)
(%define-enum-stuff I64 64 True)

(coalton-toplevel
  ;; phoebe - "note that coalton's `integer' type expands to `cl:integer', and is therefore unbounded"
  (define-instance (Enum Integer)
    (define (succ a) (+ a 1))
    (define (pred a) (- a 1))
    (define (toEnum a) a)
    (define (fromEnum a) a)))

(coalton-toplevel
  (define-instance (Enum Single-Float)
    (define (succ a) (+ a 1.0))
    (define (pred a) (- a 1.0))
    (define (toEnum a) (fromInt a))
    (define (fromEnum a) (coalton-library::withDefault 0 (single-float->integer a)))))

(coalton-toplevel
  (define-instance (Enum Double-Float)
    (define (succ a) (+ a (lisp Double-Float () (cl:coerce 1 'cl:double-float))))
    (define (pred a) (- a (lisp Double-Float () (cl:coerce 1 'cl:double-float))))
    (define (toEnum a) (fromInt a))
    (define (fromEnum a) (coalton-library::withDefault 0 (double-float->integer a)))))

(coalton-toplevel
  (define-instance (Bounded Boolean)
    (define minBound False)
    (define maxbound True))
  (define-instance (Enum Boolean)
    (define (succ a)
      (match a
        ((False) True)
        ((True) (error "Enum.Bool.succ: bad argument"))))
    (define (pred a)
      (match a
        ((True) False)
        ((False) (error "Enum.Bool.pred: bad argument"))))
    (define (toEnum a)
      (match a
        (1 True)
        (0 False)
        (_ (error "Enum.Bool.toEnum: bad argument"))))
    (define (fromEnum a)
      (match a
        ((True) 1)
        ((False) 0)))))

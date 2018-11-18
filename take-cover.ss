;; 12. Take Cover


;; as seen earlier, for the length example, the following could work
(define Y
  (lambda (le)
    ((lambda (make-length) (make-length make-length))
     (lambda (make-length)
       (le (lambda (l) ((make-length make-length) l)))))))

;; and in its generic form
(define Y
  (lambda (f)
    ((lambda (g) (g g))
     (lambda (g)
       (f (lambda (x) ((g g) x)))))))

((Y
  (lambda (length)
    (lambda (l)
      (cond
       ((null? l) 0)
       (else (add1 (length (cdr l))))))))
 '(bird dog cat))

(define Y
  (lambda (f)
    ((lambda (g) (g g))
     (lambda (g)
       (f (lambda (x) ((g g) x)))))))

(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) '())
     ((eq? (car lat) a) (multirember a (cdr lat)))
     (else (cons (car lat) (multirember a (cdr lat)))))))

(multirember 'bird '(bird dog bird bird cat bird))

;; and using the Y combinator
(define multirember
  (lambda (a lat)
    ((Y (lambda (mr)
          (lambda (lat)
            (cond
             ((null? lat) '())
             ((eq? a (car lat))
              (mr (cdr lat)))
             (else (cons (car lat)
                         (mr (cdr lat))))))))
     lat)))

(multirember 'cat '(dog bird cat))

;; Let's imagine that we defined our procedure like so:
;; (define mr
;;   (lambda (lat)
;;     (cond
;;      ((null? lat) '())
;;      ((eq? a (car lat))
;;       (mr (cdr lat)))
;;      (else (cons (car lat) (mr (cdr lat)))))))

;; (define multirember
;;   (lambda (a lat)
;;     (mr lat)))

;; This will fail, because our function mr does not have `a` in scope,
;; names are bound within the lambda scope in which they are declared

;; generally speaking, letrec (like other binding forms) maps name to values
;; as with other binding forms, it accomplishes this by way of scope
;; it allows us write one or more functions that are self-referential,
;; without using the define keyword and/or the Y combinator
;; letrec has the form: (letrec ((var expr) ...) body1 body2 ...)
;;
;; Per the Chez Scheme documentation (https://www.scheme.com/tspl4/binding.html#g88):
;; "letrec is similar to let and let*, except that all of the expressions
;; expr ... are within the scope of all of the variables var ....
;; letrec allows the definition of mutually recursive procedures."
;;
;; Moreover:
;; "Choose letrec over let or let* when there is a circular dependency
;; among the variables and their values and when the order of evaluation
;; is unimportant. Choose letrec* over letrec when there is a circular
;; dependency and the bindings need to be evaluated from left to right."

;; without letrec, this will fail with the reference to `sum' with
;; 'exception: variable sum is not bound'
;; (let ((sum (lambda (x)
;;              (cond
;;               ((zero? x) 0)
;;               (else (+ x (sum (- x 1))))))))
;;   (sum 6))

(letrec ((sum (lambda (x)
                (cond
                 ((zero? x) 0)
                 (else (+ x (sum (- x 1))))))))
  (sum 5))

;; this is, of course, equivalent
(define sum
  (lambda (x)
    (cond
     ((zero? x) 0)
     (else (+ x (sum (- x 1)))))))

(sum 5)

;; let's compare our approaches:
;; our original...
(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) '())
     ((eq? (car lat) a) (multirember a (cdr lat)))
     (else (cons (car lat) (multirember a (cdr lat)))))))

;; using letrec...

;; a naive approach could look like...
;; (define multirember
;;   (lambda (a lat)
;;     (letrec ((mr (lambda (a lat)
;;                    (cond
;;                     ((null? lat) '())
;;                     ((eq? a (car lat)) (mr a (cdr lat)))
;;                     (else (cons (car lat) (mr a (cdr lat))))))))
;;       (mr a lat))))

;; that's fine, but letrec affords us the ability to define
;; a recursive function that knows all the arguments of all the
;; surrounding (lambda ...) expressions
;;
;; In other words, we no longer have to explicitly pass `a` in the letrec form...
(define multirember
  (lambda (a lat)
    ((letrec
         ([mr (lambda (lat)
               (cond
                ((null? lat) '())
                ((eq? a (car lat)) (mr (cdr lat)))
                (else (cons (car lat) (mr (cdr lat))))))])
       mr)
     lat)))

(multirember 'bird '(cat bird bird dog))

;; the body/bodies of the letrec form is what the result of the (letrec ...) is,
;; it may refer to the named recursive function
;; in other words, the form `(letrec ((mr ...)) mr)` defines and returns a recursive function
;; continuing from this (per our example), the value of the expression
;; ((letrec ((mr ...)) mr) lat) is the result of applying the recursive function mr to lat

;; in our cleanest form, we are left with...
(define multirember
  (lambda (a lat)
    (letrec
        ([mr (lambda (lat)
               (cond
                ((null? lat) '())
                ((eq? (car lat) a) (mr (cdr lat)))
                (else (cons (car lat) (mr (cdr lat))))))])
      (mr lat))))

(multirember 'bird '(cat bird bird dog))

;; This is the 12th Commandment in action!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                                              ;
;  Use `(letrec ...)` to remove arguments that ;
;  do not change for recursive applications.   ;
;                                              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

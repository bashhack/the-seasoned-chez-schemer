;; 11. Welcome Back to the Show

(define atom?
  (lambda (x)
    (and (not (pair? x)) (not (null? x)))))

(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) a)
               (member? a (cdr lat)))))))

(member? 'dog '(cat dog bird))

(define is-next-identical?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (eq? (car lat) a)))))

(define two-in-a-row?
  (lambda (lat)
    (cond
     ((null? lat) #f)
     (else (or (is-next-identical? (car lat) (cdr lat))
               (two-in-a-row? (cdr lat)))))))

(two-in-a-row? '(dog cat bird))
(two-in-a-row? '(dog cat bird bird))

(define two-in-a-row-b?
  (lambda (preceding lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? preceding (car lat))
               (two-in-a-row-b? (car lat) (cdr lat)))))))

(define two-in-a-row?
  (lambda (lat)
    (cond
     ((null? lat) #f)
     (else (two-in-a-row-b? (car lat) (cdr lat))))))

(two-in-a-row? '(dog cat bird))
(two-in-a-row? '(dog cat bird bird))
(two-in-a-row? '(dog cat dog dog bird))

(define sum-of-prefixes-b
  (lambda (preceding-sum tup)
    (cond
     ((null? tup) '())
     (else (cons (+ preceding-sum (car tup))
                 (sum-of-prefixes-b
                  (+ preceding-sum (car tup))
                  (cdr tup)))))))

(define sum-of-prefixes
  (lambda (tup)
    (sum-of-prefixes-b 0 tup)))

(sum-of-prefixes '(1 1 1 1 1))
(sum-of-prefixes '(10 20 30 40 50))

(define sub1
  (lambda (n)
    (- n 1)))

(define one?
  (lambda (n)
    (eq? n 1)))

(define pick
  (lambda (n lat)
    (cond
     ((one? n) (car lat))
     (else (pick (sub1 n) (cdr lat))))))

(pick 2 '(cat dog bird))

;; Yikes! Need to write this out:
;; 'The function `scramble' takes a non-empty tup
;; in which no number is greater than its own index,
;; and returns a tup of the same length. Each number
;; in the argument is treated as a backward index
;; from its own position to a point earlier in the tup.
;; The result at each position is found by counting
;; backward from the next position
;; according to this index.'
;;
;; a'_{i} = a{i+1 - a_{i}}

(define scramble-b
  (lambda (tup rev-prefix)
    (cond
     ((null? tup) '())
     (else
      (cons (pick (car tup) (cons (car tup) rev-prefix))
            (scramble-b (cdr tup) (cons (car tup) rev-prefix)))))))

(define scramble
  (lambda (tup)
    (scramble-b tup '())))

(scramble '(1 1 1 3 4 2 1 1 9 2))

;; Working through the function evaluation:
;; 1
(cons (pick 1 (cons 1 '()))
      (scramble-b '(1 1 3 4 2 1 1 9 2) (cons 1 '())))
(cons 1 (scramble-b '(1 1 3 4 2 1 1 9 2) (cons 1 '())))

;; 2
(cons (pick 1 (cons 1 '(1)))
      (scramble-b '(1 3 4 2 1 1 9 2) (cons 1 '(1))))
(cons (pick 1 '(1 1))
      (scramble-b '(1 3 4 2 1 1 9 2) '(1 1)))
(cons 1 (cons 1 (scramble-b '(1 3 4 2 1 1 9 2) '(1 1))))

;; 3
(cons (pick 1 (cons 1 '(1 1)))
      (scramble-b '(3 4 2 1 1 9 2) (cons 1 '(1 1))))
(cons (pick 1 '(1 1 1))
      (scramble-b '(3 4 2 1 1 9 2) '(1 1 1)))
(cons 1 (cons 1 (cons 1 (scramble-b '(3 4 2 1 1 9 2) '(1 1 1)))))

;; 4
(cons (pick 3 (cons 3 '(1 1 1)))
      (scramble-b '(4 2 1 1 9 2) (cons 3 '(1 1 1))))
(cons (pick 3 '(3 1 1 1))
      (scramble-b '(4 2 1 1 9 2) '(3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (scramble-b '(4 2 1 1 9 2) '(3 1 1 1))))))

;; 5
(cons (pick 4 (cons 4 '(3 1 1 1)))
      (scramble-b '(2 1 1 9 2) (cons 4 '(3 1 1 1))))
(cons (pick 4 '(4 3 1 1 1))
      (scramble-b '(2 1 1 9 2) '(4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (scramble-b '(2 1 1 9 2) '(4 3 1 1 1)))))))

;; 6
(cons (pick 2 (cons 2 '(4 3 1 1 1)))
      (scramble-b '(1 1 9 2) (cons 2 '(4 3 1 1 1))))
(cons (pick 2 '(2 4 3 1 1 1))
      (scramble-b '(1 1 9 2) '(2 4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (scramble-b '(1 1 9 2) '(2 4 3 1 1 1))))))))

;; 7
(cons (pick 1 (cons 1 '(2 4 3 1 1 1)))
      (scramble-b '(1 9 2) (cons 1 '(2 4 3 1 1 1))))
(cons (pick 1 '(1 2 4 3 1 1 1))
      (scramble-b '(1 9 2) '(1 2 4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (cons 1 (scramble-b '(1 9 2) '(1 2 4 3 1 1 1)))))))))

;; 8
(cons (pick 1 (cons 1 '(9 2)))
      (scramble-b '(9 2) (cons 1 '(1 2 4 3 1 1 1))))
(cons (pick 1 '(1 9 2))
      (scramble-b '(9 2) '(1 1 2 4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (cons 1 (cons 1 (scramble-b '(9 2) '(1 1 2 4 3 1 1 1))))))))))

;; 9
(cons (pick 9 (cons 9 '(1 1 2 4 3 1 1 1)))
      (scramble-b '(2) (cons 9 '(1 1 2 4 3 1 1 1))))
(cons (pick 9 '(9 1 1 2 4 3 1 1 1))
      (scramble-b '(2) '(9 1 1 2 4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (cons 1 (cons 1 (cons 1 (scramble-b '(2) '(9 1 1 2 4 3 1 1 1)))))))))))

;; 10
(cons (pick 2 (cons 2 '(9 1 1 2 4 3 1 1 1)))
      (scramble-b '() (cons 2 '(9 1 1 2 4 3 1 1 1))))
(cons (pick 2 '(2 9 1 1 2 4 3 1 1 1))
      (scramble-b '() '(2 9 1 1 2 4 3 1 1 1)))
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (cons 1 (cons 1 (cons 1 (cons 9 (scramble-b '() '(2 9 1 1 2 4 3 1 1 1))))))))))))

;; 11
(cons 1 (cons 1 (cons 1 (cons 1 (cons 1 (cons 4 (cons 1 (cons 1 (cons 1 (cons 9 '()))))))))))

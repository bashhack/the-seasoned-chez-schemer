;; Using the Applicative-Order Y Combinator in Clojure
;; ---------------------------------------------------
;; Working through the 'stack frames' of manual evaluation
;; to better understand the Y Combinator, using Clojure
;; because of its closeness in syntax and semantics to Scheme.

(def fact-maker
  (fn [self]
    (fn [n]
      (if (zero? n)
        1
        (* n ((self self) (- n 1)))))))


((fact-maker fact-maker) 6)

;; equivalent to the above call...
(((fn [self]
    (fn [n]
      (if (zero? n)
        1
        (* n ((self self) (- n 1))))))
  (fn [self]
    (fn [n]
      (if (zero? n)
        1
        (* n ((self self) (- n 1))))))) 6)

;; evaluation:

;; 1
(((fn [self]
    (fn [n]
      (if (zero? n)
        1
        (* n ((self self) (- n 1))))))
  (fn [self]
    (fn [n]
      (if (zero? n)
        1
        (* n ((self self) (- n 1))))))) 6)

;; 2
((fn [n]
   (if (zero? n)
     1
     (* n (((fn [self]
              (fn [n]
                (if (zero? n)
                  1
                  (* n ((self self) (- n 1))))))
            (fn [self]
              (fn [n]
                (if (zero? n)
                  1
                  (* n ((self self) (- n 1))))))) (- n 1))))) 6)

;; 3
((fn [n]
   (if (zero? n)
     1
     (* n (((fn [n]
              (if (zero? n)
                1
                (* n ((fn [self]
                        (fn [n]
                          (if (zero? n)
                            1
                            (* n ((self self) (- n 1))))))
                      (fn [self]
                        (fn [n]
                          (if (zero? n)
                            1
                            (* n ((self self) (- n 1))))))) (- n 1))))) (- n 1))))) 6)

;; 4
(* 6 ((fn [n]
        (if (zero? n)
          1
          (* n (((fn [self]
                   (fn [n]
                     (if (zero? n)
                       1
                       (* n ((self self) (- n 1))))))
                 (fn [self]
                   (fn [n]
                     (if (zero? n)
                       1
                       (* n ((self self) (- n 1))))))) (- n 1))))) 5))

;; 5
(* 6
   (* 5 ((fn [n]
           (if (zero? n)
             1
             (* n ((fn [self]
                     (fn [n]
                       (if (zero? n)
                         1
                         (* n ((self self) (- n 1))))))
                   (fn [self]
                     (fn [n]
                       (if (zero? n)
                         1
                         (* n ((self self) (- n 1))))))) (- n 1)))) 4)))

;; 6
(* 6
   (* 5
      (* 4 ((fn [n]
              (if (zero? n)
                1
                (* n ((fn [self]
                        (fn [n]
                          (if (zero? n)
                            1
                            (* n ((self self) (- n 1))))))
                      (fn [self]
                        (fn [n]
                          (if (zero? n)
                            1
                            (* n ((self self) (- n 1))))))) (- n 1)))) 3))))

;; 7
(* 6
   (* 5
      (* 4
         (* 3 ((fn [n]
                 (if (zero? n)
                   1
                   (* n ((fn [self]
                           (fn [n]
                             (if (zero? n)
                               1
                               (* n ((self self) (- n 1))))))
                         (fn [self]
                           (fn [n]
                             (if (zero? n)
                               1
                               (* n ((self self) (- n 1))))))) (- n 1)))) 2)))))

;; 8
(* 6
   (* 5
      (* 4
         (* 3
            (* 2 ((fn [n]
                    (if (zero? n)
                      1
                      (* n ((fn [self]
                              (fn [n]
                                (if (zero? n)
                                  1
                                  (* n ((self self) (- n 1))))))
                            (fn [self]
                              (fn [n]
                                (if (zero? n)
                                  1
                                  (* n ((self self) (- n 1))))))) (- n 1)))) 1))))))

;; 9
(* 6
   (* 5
      (* 4
         (* 3
            (* 2
               (* 1 ((fn [n]
                       (if (zero? n)
                         1
                         (* n ((fn [self]
                                 (fn [n]
                                   (if (zero? n)
                                     1
                                     (* n ((self self) (- n 1))))))
                               (fn [self]
                                 (fn [n]
                                   (if (zero? n)
                                     1
                                     (* n ((self self) (- n 1))))))) (- n 1)))) 0)))))))


;; 10
(* 6
   (* 5
      (* 4
         (* 3
            (* 2
               (* 1 1 ))))))

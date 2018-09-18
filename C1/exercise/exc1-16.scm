;;;fast-recursion
;;;
(define (fast-expt-recursion b n)
  (cond ((= n 0) 
         1)
        ((even? n) 
         (square (fast-expt-recursion b (/ n 2))))
        (else 
         (* b (fast-expt-recursion b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))


;;;iterator
;;;
(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(define (fast-expt-iter a b n)
    (cond ((= n 0) a)
          ((even? n)
            (fast-expt-iter a (square b) (/ n 2)))
          (else (fast-expt-iter (* a b) b (- n 1)))))

(define (square x) (* x x) )

(display (fast-expt 2 10))
(newline)
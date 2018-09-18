(define (square x) (* x x))

;;;recursion
;;;
(define (expt-recursion b n)
  (if (= n 0) 
      1 
      (* b (expt-recursion b (- n 1)))))

;;;iterator
;;;
(define (expt b n) 
    (expt-iter b n 1))
  
  (define (expt-iter b counter product)
    (if (= counter 0)
        product
        (expt-iter b
                   (- counter 1)
                   (* b product))))


;;;fast-recursion
;;;
(define (fast-expt b n)
  (cond ((= n 0) 
         1)
        ((even? n) 
         (square (fast-expt b (/ n 2))))
        (else 
         (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))



;;;fast-iterator
;;;
(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(define (fast-expt-iter a b n)
    (cond ((= n 0) a)
          ((even? n)
            (fast-expt-iter a (square b) (/ n 2)))
          (else (fast-expt-iter (* a b) b (- n 1)))))
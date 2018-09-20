(define (filtered-accmulate
         combiner null-value filter term a next b)
  (cond ((> a b) null-value)
        ((filter a) 
            (combiner (term a)
                      (filtered-accmulate 
                        combiner null-value filter term (next a) next b)))
        (else (filtered-accmulate 
          combiner null-value filter term (next a) next b))))

(define (inc x) (+ x 1))
(define (plus x y) (+ x y))
(define (identity x) x)

(define (sum-even a b)
  (filtered-accmulate plus 0 prime? identity a inc b))

(display (sum-even 1 10))
(newline)


(define (square x) (* x x))
(define (smallest-divisor n) (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) 
        n)
        ((divides? test-divisor n) 
        test-divisor)
        (else (find-divisor 
            n 
            (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))




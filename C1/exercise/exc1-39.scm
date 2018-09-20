(define (cont-frac n d k)
  (define (con-iter i result)
    (if (= i 0)
        result
        (con-iter (- i 1) (/ (n i) (+ (d i) result)))))
  (con-iter k 0.0))

(define (tan-cf x k)
  (define (n i)
    (if (= i 1) x (- (* x x))))
  (define (d i)
    (- (* i 2) 1))
  (cont-frac n d k))

(display (tan-cf 10 100))
(newline)  
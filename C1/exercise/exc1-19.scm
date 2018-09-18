(define (square x) (* x x))

(define (fib n)
    (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q n)
    (display "a:")
    (display a)
    (display "  b:")
    (display b)
    (display "  p:")
    (display p)
    (display "  q:")
    (display q)
    (display "  n:")
    (display n)
    (newline)
    (cond ((= n 0)
            b)
          ((even? n)
            (fib-iter a 
                      b
                      (+ (square p) (square q))
                      (+ (* 2 p q) (square q))
                      (/ n 2)))
          (else
            (fib-iter (+ (* b q) (* a q) (* a p))
                      (+ (* b p) (* a q))
                      p
                      q
                      (- n 1)))))

(display (fib 10))
(newline)            
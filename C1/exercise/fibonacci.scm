(define (fib n)
   (fib-iter 1 0 n))

(define (fib-iter a b count)
    (if (= count 0)
        b
        (fib-iter (+ a b) a (- count 1))))

;fib(5)
;fib-iter(1 0 5)
;fib-iter(1 1 4)
;fib-iter(2 1 3)
;fib-iter(3 2 2)
;fib-iter(5 3 1)
;fib-iter(8 5 0)
;5
;
; 0 1 1 2 3 5

(display (fib 5))
(newline)

(define (square x) (* x x))

(define (fib-logtime n)
    (define (fib-iter a b p q n)
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
    (fib-iter 1 0 0 1 n))

(display (fib-logtime 8))
(newline)    
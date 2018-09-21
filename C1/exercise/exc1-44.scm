
(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeat f n)
  (define (repeat-iter k result)
    (if (= k 1)
        result
        (repeat-iter (- k 1)
                     (compose f result))))
  (repeat-iter n f))

(define dx 0.00001)

(define (smooth f)
  (lambda (x)
    (/ (+ (f (- x dx))
          (f x)
          (f (+ x dx)))
        3)))

(define (square x)
  (* x x))

(define (repeat-smooth f n)
  ((repeat smooth n) f))

(display ((smooth square) 5))
(newline)

(display ((repeat-smooth square 10) 5))  
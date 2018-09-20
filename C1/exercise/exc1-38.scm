(define (cont-frac n d k)
  (define (con-iter i result)
    (if (= i 0)
        result
        (con-iter (- i 1) (/ (n i) (+ (d i) result)))))
  (con-iter k 0))

(define (try k)
  (cont-frac (lambda (i) 1.0)
             d
             k))

(define (d i)
  (if (= (remainder i 3) 2)
      (* 2 (/ (+ i 1) 3) )
      1))
      
(display (+ 2(try 10)))
(newline)
(define (cont-frac n d k)
  (define (con-iter i result)
    (if (= i 0)
        result
        (con-iter (- i 1) (/ (n i) (+ (d i) result)))))
  (con-iter k 0))

(define (cont-frac-recursion n d k)
  (define (con-recursion i)
    (if (= i k)
          (/ (n i) (d i))
          (/ (n i) (+ (d i) (con-recursion (+ i 1))))))
  (con-recursion 1))

(define (try k)
  (cont-frac (lambda (i) 1.0)
             (lambda (i) 1.0)
             k))

(define (try-r k)
  (cont-frac-recursion (lambda (i) 1.0)
                       (lambda (i) 1.0)
                       k))

(display (try 10))
(newline)     
  
(display (try-r 10))
(newline)

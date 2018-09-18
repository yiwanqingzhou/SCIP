(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti-fast a b)
    (define (iter a b product)
        (cond ((= b 0) product)
              ((even? b)
                (iter (double a) (halve b) product))
              (else
                (iter a (- b 1) (+ a product) ))))
    (iter a b 0))

(display (muti-fast 2 10))
(newline)
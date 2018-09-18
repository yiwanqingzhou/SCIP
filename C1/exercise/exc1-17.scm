
;;;
;;;(define (* a b)
;;;    (if (= b 0)
;;;        0
;;;        (+ a (* a (- b 1)))))
;;;

(define (muti a b)
    (define (muti-iter a b product)
        (if (= b 0)
            product
            (muti-iter a (- b 1) (+ product a))))
    (muti-iter a b 0))

(display (muti 2 3))
(newline)

(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti-logtime a b)
    (cond ((= b 0) 0)
          ((even? b) 
            (double (muti-logtime a (halve b))))
          (else 
            (+ a (muti-logtime a (- b 1))))))

(display (muti-logtime 2 10))
(newline)



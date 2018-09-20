(define (double f)
  (lambda (x) (f (f x))))

(define (inc x)
  (+ x 1))

(display
  (((double double) inc) 0)
)
(newline)

(display
  ((double (double inc)) 0)
)
(newline)

;;;2
(display
  ((double ((double double) inc)) 0)
)
(newline)

(display
  (((double (double double)) inc) 0)
)
(newline)

;;;3
(display
  ((double (double ((double double) inc))) 0)
)
(newline)

(display
  ((double ((double (double double)) inc)) 0)
)
(newline)

(display
  (((double (double (double double))) inc) 0)
)
(newline)
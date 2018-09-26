(define (even n) (not (remainder n 2)))
(define (odd n) (not (even n)))

(define (same-parity . items)
  (define (filter-rec proc a)
    (cond ((null? a) '())
          ((proc (car a)) (cons (car a) (filter-rec proc (cdr a))))
          (else (filter-rec proc (cdr a)))))
  (if (even (car items))
    (filter-rec even items)
    (filter-rec odd items)))

(display
    (same-parity 1 2 3 4 5 6 7))
(newline)
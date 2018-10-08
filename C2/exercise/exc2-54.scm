(define (equal? a b)
    (cond ((and (pair? a) (pair? b))
                (and (equal? (car a) (car b))
                    (equal? (cdr a) (cdr b))))
          ((or (pair? a) (pair? b)) #f)
          (else (eq? a b))))

(define a '(this is a list))
(define b '(this is a list))
(define c '(this))
(define d '(this (is a) list))

(display (equal? a b))
(newline)

(display (equal? a c))
(newline)

(display (equal? a d))
(newline)
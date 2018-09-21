(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))

(display(car (car z)))
(newline)
(display (car z))
(newline)
(display (cdr z))
(newline)

(define a (cons x 3))

(display (car a))
(newline)
(display (cdr a))
(newline)
(define a (list 1 3 (list 5 7) 9))

(define b (list (list 7 )))

(define c (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))


(display a)
(newline)
;(display (car (cdr (car (cdr (cdr a))))))
(display (cadr (cadr (cdr a))))
(newline)
(newline)

(display b)
(newline)
(display (car (car b)))
(newline)
(newline)

(display c)
(newline)
(display (cadr (cadr (cadr (cadr (cadr (cadr c)))))))
(newline)
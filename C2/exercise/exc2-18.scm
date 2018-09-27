
(define (reverse items)
  (define (reverse-iter a result)
    (if (null? a)
        result
        (reverse-iter (cdr a) (cons (car a) result))))
  (reverse-iter items '()))


(define x (list 1 2 3))

(display (reverse x))
(newline)
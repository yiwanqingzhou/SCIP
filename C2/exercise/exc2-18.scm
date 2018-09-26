
(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ count 1))))
  (length-iter items 0))

(define (reverse items)
  (define (reverse-iter a result)
    (let ((len (length a)))
        (if (= len 0)
            result
            (reverse-iter (cdr a) (cons (car a) result)))))
  (reverse-iter items '()))


(define a (list 1 2 3))

(display (reverse a))
(newline)
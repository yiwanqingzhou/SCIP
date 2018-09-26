(define nil '())

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (square x) (* x x))            

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) 
            (square-list (cdr items)))))

(display
  (square-list (list 1 2 3 4)))
(newline)

(define (square-list items)
  (map square items))

(display
  (square-list (list 1 2 3 4)))
(newline)
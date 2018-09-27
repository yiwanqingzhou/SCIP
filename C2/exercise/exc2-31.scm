(define nil '())

(define (square x) (* x x))


(define (square-tree tree)
  (tree-map square tree))
  
(define (tree-map proc items)
  (cond ((null? items) 
            nil)
        ((not (pair? items)) 
            (proc items))
        (else
            (cons (tree-map proc (car items))
                  (tree-map proc (cdr items))))))


(define a (list 1 (list 2 4) (list 4 5) 6))
(display a)
(newline)
(display (square-tree a))
(newline)                  
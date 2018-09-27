(define (square-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (square tree))
        (else
            (cons (square-tree (car tree))
                  (square-tree (cdr tree))))))

(define (square x) (* x x))

(define nil '())

(define a (list 1 (list 2 4) (list 4 5) 6))
(display a)
(newline)
(display (square-tree a))
(newline)

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (square-tree tree)
  (map (lambda (sub-tree)
          (if (pair? sub-tree)
              (square-tree sub-tree)
              (square sub-tree)))
        tree))

(display (square-tree a))
(newline)        
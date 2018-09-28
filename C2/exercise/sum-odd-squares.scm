(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares 
                  (car tree))
                 (sum-odd-squares 
                  (cdr tree)))))
)



;;;
(define (enumerate-tree tree)
    (cond ((null? tree) nil)
          ((not (pair? tree)) (list tree))
          (else 
              (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree)))))
)

(define (filter predicate sequence)
    (cond ((null? sequence) nil)
          ((predicate (car sequence))
              (cons (car sequence)
                    (filter predicate (cdr sequence))))
          (else
            (filter predicate (cdr sequence))))
)

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items))))
)

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence))))
)

(define (sum-odd-squares tree)
  (accumulate 
   +
   0
   (map square
        (filter odd?
                (enumerate-tree tree))))
)
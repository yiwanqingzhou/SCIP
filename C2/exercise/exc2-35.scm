(define (accumulate op initial sequence)
(if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else 
            (append (enumerate-tree (car tree))
                    (enumerate-tree (cdr tree)))))
)        

;;; old          
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x) 1))
        (else (+ count-leaves (car x)
                 count-leaves (cdr x)))))

;;; 1)
(define (count-leaves t)
  (accumulate + 0 
    (map (lambda (x) 
            (if (pair? x) (count-leaves x) 1)) 
          t)))

(define nil '())

;;; 2)
(define (count-leaves t)
  (accumulate + 0 
    (map (lambda (x) 1) (enumerate-tree t)))
)

;;; 3)
(define (count-leaves t)
    (accumulate 
      (lambda (x y) (+ y 1))
      0 
      (enumerate-tree t))
)

(display (count-leaves '(1 2 (4 3 5) (5 6) (7 8) 9)))
(newline)
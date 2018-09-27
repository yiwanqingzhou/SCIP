(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

  
;;;a)  
(define (left-branch m) (car m))  
(define (right-branch m) (cadr m))
  
(define (branch-length b) (car b))  
(define (branch-structure b) (cadr b))  


;;;b)
(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

(define (branch-weight branch)
  (structure-weight (branch-structure branch)))
  
(define (structure-weight structure)
  (if (pair? structure)
        (total-weight structure)
        (structure)))


;;;c)
(define (equal? mobile)
  (let ((R (right-branch mobile))
        (L (left-branch mobile)))
      (= (* (branch-length R) (branch-weight R)) 
         (* (branch-length L) (branch-weight R)))))
         
         

;;;d)
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure)) 
    
(define (left-branch m) (car m))
(define (right-branch m) (cdr m))
(define (branch-length b) (car b))
(define (branch-structure b) (cdr b))    
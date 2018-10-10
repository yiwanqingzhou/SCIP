(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((equal? (car set) x) #t)
          (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
    (if (element-of-set? x set)
        set
        (cons x set)))
        
(define (intersection-set set1 set2)
    (cond ((or (null? set1) (null? set2)) '())
          ((element-of-set? (car set1) set2)
              (cons 
                (car set1) 
                (intersection-set (cdr set1) set2)))
          (else (intersection-set (cdr set1) set2))))

; (define (intersection-set set1 set2)
;     (define (intersection-set-iter set result)
;         (cond ((null? set) result)
;               ((element-of-set? (car set) set2)
;                     (intersection-set-iter
;                         (cdr set)
;                         (cons (car set1) result)))
;               (intersection-set-iter (cdr set) result)))
;     (intersection-set-iter set1 '()))

(define (union-set set1 set2)
    (cond ((null? set1) set2)
          ((element-of-set? (car set1) set2)
              (union-set (cdr set1) set2))
      (else (cons (car set1) 
                  (union-set (cdr set1) set2)))))

(define a (list 5 6 2 4))
(define b (list 2 1 5))

(display (intersection-set a b))
(newline)

(display (union-set a b))
(newline)
;;; 可重复

(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((equal? (car set) x) #t)
          (else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
        (cons x set))
        
; (define (intersection-set set1 set2)
;     (cond ((or (null? set1) (null? set2)) '())
;           ((element-of-set? (car set1) set2)
;               (cons 
;                 (car set1)
;                 (intersection-set (cdr set1) set2)))
;           (else (intersection-set (cdr set1) set2))))

(define (remove-element x set)
    (cond ((null? set) '())
          ((equal? (car set) x)
                (cdr set))
          (else
            (cons (car set)
                  (remove-element x (cdr set))))))

(define (intersection-set set1 set2)
    (if (or (null? set1) (null? set2))
        '()
        (let ((removed (remove-element (car set1) set2)))
            (if (< (length removed) (length set2))
                (cons (car set1)
                      (intersection-set (cdr set1) removed))
                (intersection-set (cdr set1) set2)))))                  

(define (union-set set1 set2)
    (if (null? set1)
        set2
        (cons (car set1)
              (union-set (cdr set1) set2))))
        


(define a (list 5 5 6 2 2 4))
(define b (list 2 2 1 5))


(display (intersection-set a b))
(newline)

(display (union-set a b))
(newline)
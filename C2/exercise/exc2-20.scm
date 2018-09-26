
(define (same-parity . items)
  (define remain (remainder (car items) 2))
  (define (filter-iter a result)
    (cond ((null? a) 
              (reverse result))
          ((= remain (remainder (car a) 2))
              (filter-iter (cdr a) (cons (car a) result)))
          (else
              (filter-iter (cdr a) result))))           
  (filter-iter items '() ))


; (define (even n) (= (remainder n 2) 0))
; (define (odd n) (not (even n)))

; (define (filter-rec proc a)
;     (cond ((null? a) 
;               '())    
;           ((proc (car a)) 
;               (cons (car a) (filter-rec proc (cdr a))))
;           (else 
;               (filter-rec proc (cdr a)))))
              
; (define (same-parity . items)
;   (if (even (car items))
;     (filter-rec even items)
;     (filter-rec odd items)))

(display
  (same-parity 1 2 3 4 5 6 7))
(newline)
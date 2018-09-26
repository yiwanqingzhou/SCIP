;;;2-17

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ count 1))))
  (length-iter items 0))


(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))


; (define (last-pair items)
;   (list-ref items (- (length items) 1)))


; (define (last-pair items)
;   (if (null?  (cdr items))
;       (car items)
;       (last-pair (cdr items))))


(define (last-pair items)
  (cond ((null? items) 
            (error "list empty -- LAST-PAIR"))
        ((null? (cdr items)) 
            items)
        (else
            (last-pair (cdr items)))))


(define a (list 23 32 45 73))            
  
(display (last-pair a))
(newline) 
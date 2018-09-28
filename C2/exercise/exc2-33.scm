
(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence))))
)


;;;1)
(define nil '())

; (define (map proc items)
;   (if (null? items)
;       nil
;       (cons (proc (car items))
;             (map proc (cdr items))))
; )

(define (map p sequence)
  (accumulate 
    (lambda (x y)
      (cons (p x) y))    
    nil 
    sequence))

(display (map (lambda (x) (* x x)) '(1 5 4)))
(newline)

;;;2)
; (define (append list1 list2)
;   (if (null? list1)
;       list2
;       (cons (car list1) 
;             (append (cdr list1) 
;                     list2))))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(display (append '(1 3 4) '(4 5)))
(newline)

;;;3)
; (define (length items)
;   (if (null? items)
;       0
;       (+ 1 (length (cdr items))))
; )

(define (length sequence)
  (accumulate (lambda (x y) (+ y 1)) 0 sequence)  
)

(display (length '(1 34 5 3)))
(newline)
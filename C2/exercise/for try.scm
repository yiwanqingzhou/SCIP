; (display (list 1 (list 2 (list 3 4))))
; (newline)

; (display (cons 1 (cons 2 (cons 3 4))))
; (newline)

; (display (cons 1 (cons 2 (cons 3 (cons 4 '())))))
; (newline)

; (display (cons 1 (cons 2 (list 3 4))))
; (newline)

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))
            

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))
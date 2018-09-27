
(define (reverse items)
  (define (reverse-iter a result)
    (if (null? a)
        result
        (reverse-iter (cdr a) (cons (car a) result))))
  (reverse-iter items '()))

; (define (reverse items)
;   (if (null? items)
;       '()
;       (append (reverse (cdr items))
;               (list (car items)))))

(define (deep-reverse items)
  (cond ((null? items) '())
        ((not (pair? items)) items)
        (else
            (reverse (cons (deep-reverse (car items))
                           (deep-reverse (cdr items)))))))


;;;
(define (tree-reverse lst)
  (define (iter remained-items result)
      ; (display "remained-items:  ")
      ; (display remained-items)
      ; (newline)
      ; (display "result:  ")
      ; (display result)
      ; (newline)
      (if (null? remained-items)
          result
          (iter (cdr remained-items)
                (cons (if (pair? (car remained-items))
                          (tree-reverse (car remained-items))
                          (car remained-items))
                      result))))
  (iter lst '()))                    


(define y (list (list 1 2 5) (list 3 4)))
(display (deep-reverse y))
(newline)
(display (tree-reverse y))
(newline)


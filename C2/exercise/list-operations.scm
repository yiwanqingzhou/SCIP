;;;list-ref

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))

(define squares 
  (list 1 4 9 16 25))

(display (list-ref squares 3))
(newline)


;;;length-recursion

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

; (define odds
;   (list 1 3 5 7))

; (display (length odds))
; (newline)


;;;length-iteration

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ count 1))))
  (length-iter items 0))

(define odds
  (list 1 3 5 7))

(display (length odds))
(newline)


;;;append

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) 
            (append (cdr list1) 
                    list2))))

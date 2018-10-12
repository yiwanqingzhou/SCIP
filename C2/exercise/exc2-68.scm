(define (encode message tree)
    (if (null? message)
        '()
        (append (encode-symbol (car message) tree)
                (encode (cdr message) tree))))

(define (encode-symbol cur-symbol tree)
    (cond ((leaf? tree) '())
          ((symbol-in-tree? cur-symbol (symbols (left-branch tree)))
                (cons 0
                      (encode-symbol cur-symbol (left-branch tree))))
          ((symbol-in-tree? cur-symbol (symbols (right-branch tree)))
                (cons 1
                      (encode-symbol cur-symbol (right-branch tree))))
          (else 
                (error "This symbol not in tree: " cur-symbol))))

(define (symbol-in-tree? cur-symbol symbols)
    (cond ((null? symbols) #f)
          ((eq? (car symbols) cur-symbol) #t)
          (else (symbol-in-tree? cur-symbol (cdr symbols)))))

; (display (encode decode-message sample-tree))
; (newline)          
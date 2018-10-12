;;; 2-69
(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs)))

(define (successive-merge set)
    (cond ((null? set) '())
          ((= (length set) 1) (car set))
          ((> (length set) 1)
                (let ((new-branch (make-code-tree (car set) (cadr set)))
                      (new-set (cddr set)))
                    (successive-merge (adjoin-set new-branch new-set))))))

; (define x '((A 4) (B 2) (C 1) (D 1) (E 1)))
; (display (generate-huffman-tree x))
; (newline)
;;; 2-70

(define alphabet '((A 2) (NA 16) (BOOM 1) (SHA 3) (GET 2) (YIP 9) (JOB 2) (WAH 1)))
(define alphabet-tree (generate-huffman-tree alphabet))

(define message-1 '(GET A JOB))
(display (encode message-1 alphabet-tree))
(newline)
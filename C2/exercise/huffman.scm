(define (make-leaf symbol weight)
    (list 'leaf symbol weight))

(define (leaf? object)
    (eq? (car object) 'leaf ))
    
(define (symbol-leaf x) (cadr x)) 
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
    (list left
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
    (if (leaf? tree)
        (list (symbol-leaf tree))
        (caddr tree)))

(define (weight tree)
    (if (leaf? tree)
        (weight-leaf tree)
        (cadddr tree)))

(define (decode bits tree)
    (define (decode-1 bits current-branch)
        (if (null? bits)
            '()
            (let ((next-branch 
                    (choose-branch (car bits) current-branch)))
                (if (leaf? next-branch)
                    (cons (symbol-leaf next-branch)
                          (decode-1 (cdr bits) tree))
                    (decode-1 (cdr bits) next-branch)))))
    (decode-1 bits tree))
    
(define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set)))
                (cons x set))
          (else
            (cons (car set)
                  (adjoin-set x (cdr set))))))
                  
(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
            (adjoin-set (make-leaf (car pair)
                                   (cadr pair))
                        (make-leaf-set (cdr pairs))))))

;;; 2-67
(define sample-tree
    (make-code-tree (make-leaf 'A 4)
                    (make-code-tree (make-leaf 'B 2)
                                    (make-code-tree (make-leaf 'D 1)
                                                    (make-leaf 'C 1)))))
                            
(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(define decode-message (decode sample-message sample-tree))


;;; 2-68
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

;;; 2-70

(define alphabet '((A 2) (NA 16) (BOOM 1) (SHA 3) (GET 2) (YIP 9) (JOB 2) (WAH 1)))
(define alphabet-tree (generate-huffman-tree alphabet))

(define message-1 '(GET A JOB))
(display (encode message-1 alphabet-tree))
(newline)
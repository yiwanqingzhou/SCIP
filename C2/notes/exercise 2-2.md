# 2.2 Hierarchical Data and the Closure Property

## 2.2.1

### Exc 2-17
```scheme
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
```

### Exc 2-18
```scheme
(define (reverse items)
  (define (reverse-iter a result)
    (if (null? a)
        result
        (reverse-iter (cdr a) (cons (car a) result))))
  (reverse-iter items '()))


(define x (list 1 2 3))

(display (reverse x))
(newline)
```

### Exc 2-19
```scheme
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) 
             (no-more? coin-values)) 
         0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount (first-denomination coin-values))
                coin-values)))))

(define (first-denomination coin-values)
  (car coin-values))
  
(define (except-first-denomination coin-values)
  (cdr coin-values))
  
(define (no-more? coin-values)
  (null? coin-values))

(display (cc 100 us-coins))
(newline)
```

### Exc 2-20
```scheme
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
```

### Exc 2-21
```scheme
(define nil '())

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (square x) (* x x))            

(define (square-list items)
  (if (null? items)
      nil
      (cons (square (car items)) 
            (square-list (cdr items)))))

(display
  (square-list (list 1 2 3 4)))
(newline)

(define (square-list items)
  (map square items))

(display
  (square-list (list 1 2 3 4)))
(newline)
```

### Exc 2-22

### Exc 2-23
```scheme
(define (for-each proc items)
  (if (null? items)
      #t
      (begin
        (proc (car items))
        (for-each proc (cdr items)))))


(for-each 
  (lambda (x) (display x) (newline))
  (list 57 321 88))
```


## 2.2.2

### Exc 2-24
```scheme
(define a (list 1 (list 2 (list 3 4))))

(define b (cons 1 (cons 2 (cons 3 4))))

(define c (cons 1 (cons 2 (cons 3 (cons 4 '())))))

(define d (cons 1 (cons 2 (list 3 4))))
```

### Exc 2-25
```scheme
(define a (list 1 3 (list 5 7) 9))

(define b (list (list 7 )))

(define c (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))


(display a)
(newline)
;(display (car (cdr (car (cdr (cdr a))))))
(display (cadr (cadr (cdr a))))
(newline)
(newline)

(display b)
(newline)
(display (car (car b)))
(newline)
(newline)

(display c)
(newline)
(display (cadr (cadr (cadr (cadr (cadr (cadr c)))))))
(newline)
```

### Exc 2-26
```scheme
(define x (list 1 2 3))

(define y (list 4 5 6))

(display (append x y))
(newline)

(display (cons x y))
(newline)

(display (list x y))
(newline)
```

### Exc 2-27
```scheme
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
```

### Exc 2-28
```scheme
(define (fringe items)
  (cond ((null? items) '())
        ((not (pair? items))  
            (list items))
        (else
            (append (fringe (car items))
                    (fringe (cdr items))))))


(define y (list (list 1 2 5) (list 3 4)))
(display y)
(newline)
(display (fringe y))
(newline)

(define (tree-reverse lst)
  (define (iter remained-items result)
      (if (null? remained-items)
          result
          (iter (cdr remained-items)
                (append
                        (if (pair? (car remained-items))
                            (tree-reverse (car remained-items))
                            (list (car remained-items)))
                        result))))
  (iter lst '()))

(display (tree-reverse y))
(newline)
```

### Exc 2-29
```scheme
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

  
;;;a)  
(define (left-branch m) (car m))  
(define (right-branch m) (cadr m))
  
(define (branch-length b) (car b))  
(define (branch-structure b) (cadr b))  


;;;b)
(define (total-weight mobile)
  (+ (branch-weight (left-branch mobile))
     (branch-weight (right-branch mobile))))

(define (branch-weight branch)
  (structure-weight (branch-structure branch)))
  
(define (structure-weight structure)
  (if (pair? structure)
        (total-weight structure)
        (structure)))


;;;c)
(define (equal? mobile)
  (let ((R (right-branch mobile))
        (L (left-branch mobile)))
      (= (* (branch-length R) (branch-weight R)) 
         (* (branch-length L) (branch-weight R)))))
         
         

;;;d)
(define (make-mobile left right)
  (cons left right))
(define (make-branch length structure)
  (cons length structure)) 
    
(define (left-branch m) (car m))
(define (right-branch m) (cdr m))
(define (branch-length b) (car b))
(define (branch-structure b) (cdr b))
```

### Exc 2-30
```scheme
(define (square-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (square tree))
        (else
            (cons (square-tree (car tree))
                  (square-tree (cdr tree))))))

(define a (list 1 (list 2 4) (list 4 5) 6))
(display a)
(newline)
(display (square-tree a))
(newline)

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (square-tree tree)
  (map (lambda (sub-tree)
          (if (pair? sub-tree)
              (square-tree sub-tree)
              (square sub-tree)))
        tree))

(display (square-tree a))
(newline) 
```

### Exc 2-31
```scheme
(define (square-tree tree)
  (tree-map square tree))
  
(define (tree-map proc items)
  (cond ((null? items) 
            nil)
        ((not (pair? items)) 
            (proc items))
        (else
            (cons (tree-map proc (car items))
                  (tree-map proc (cdr items))))))

(define a (list 1 (list 2 4) (list 4 5) 6))
(display a)
(newline)
(display (square-tree a))
(newline)
```

### Exc 2-32
```scheme
(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
          (append rest 
                  (map (lambda (x)
                          (cons (car s) x)) 
                       rest)))))


(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))


(define x (list 1 2 3))
(display (subsets x))
(newline)            
```

## 2.2.3

### Exc 2-33
```scheme

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
```

### Exc 2-34
```scheme

(define (accumulate op initial sequence)
(if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence))))
)


;;; Horner’s rule

(define (horner-eval x coefficient-sequence)
  (accumulate 
   (lambda (this-coeff higher-terms)
     (+ this-coeff (* x higher-terms)))
   0
   coefficient-sequence))

(display
(horner-eval 2 (list 1 3)))
(newline)
```

### Exc 2-35
```scheme
(define (accumulate op initial sequence)
(if (null? sequence)
    initial
    (op (car sequence)
        (accumulate op initial (cdr sequence)))))

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(define (enumerate-tree tree)
  (cond ((null? tree) nil)
        ((not (pair? tree)) (list tree))
        (else 
            (append (enumerate-tree (car tree))
                    (enumerate-tree (cdr tree)))))
)        

;;; old          
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x) 1))
        (else (+ count-leaves (car x)
                 count-leaves (cdr x)))))

;;; 1)
(define (count-leaves t)
  (accumulate + 0 
    (map (lambda (x) 
            (if (pair? x) (count-leaves x) 1)) 
          t)))

(define nil '())

;;; 2)
(define (count-leaves t)
  (accumulate + 0 
    (map (lambda (x) 1) (enumerate-tree t)))
)

;;; 3)
(define (count-leaves t)
    (accumulate 
      (lambda (x y) (+ y 1))
      0 
      (enumerate-tree t))
)

(display (count-leaves '(1 2 (4 3 5) (5 6) (7 8) 9)))
(newline)
```

### Exc 2-36
```scheme
(define (accumulate-n  op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (car-n seqs))
            (accumulate-n op init (cdr-n seqs)))))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))
          
(define nil '())

; (define (car-n seqs)
;   (if (null? seqs)
;       nil
;       (cons (caar seqs)
;             (car-n (cdr seqs)))))

; (define (cdr-n seqs)
;   (if (null? seqs)
;       nil
;       (cons (cdar seqs)
;             (cdr-n (cdr seqs)))))

(define (car-n seqs)
    (map car seqs))
(define (cdr-n seqs)
    (map cdr seqs))    


(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))
(display (accumulate-n + 0 s))
(newline)
```

### Exc 2-37
```scheme
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

; (define (matrix-*-vector m v)
;   (map ⟨??⟩ m))

(define (transpose mat)
  (accumulate-n cons nil mat))

; (define (matrix-*-matrix m n)
;   (let ((cols (transpose n)))
;     (map ⟨??⟩ m)))
 
(define s (list (list 1 2 3 4) (list 4 5 6 6) (list 6 7 8 9)))
(display s)
(newline)
(display (transpose s))
(newline)
```

### Exc 2-38
```scheme
(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

  
;;;accumulate
(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (fold-right op initial (cdr sequence))))
)


; (fold-right / 1 (list 1 2 3))
; (fold-left  / 1 (list 1 2 3))
; (fold-right list nil (list 1 2 3))
; (fold-left  list nil (list 1 2 3))
```

### Exc 2-39
```scheme
(define (reverse sequence)
  (fold-right (lambda (x y) 
                  (append y (list x)))
              nil
              sequence))

(define (reverse sequence)
  (fold-left (lambda (x y)
                  (append (list y) x))
              nil
              sequence))     
              
(define (reverse sequence)
  (fold-left (lambda (x y)
                  (cons y x))
              nil
              sequence))              

(define x (list 1 3 5))
(display (reverse x))
(newline)
```

### Exc 2-40
```scheme
(define (unique-list n)
  (accumulate 
    append
    nil
    (map (lambda (i)
           (map (lambda (j) 
                  (list i j))
                (enumerate-interval 1 (- i 1))))
         (enumerate-interval 1 n))))


(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (unique-list n)
  (flatmap (lambda (i)
              (map 
                  (lambda (j) (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

```

### Exc 2-41
```scheme
(define (s-sum-triples n s)
    (filter 
        (lambda (triples) 
            (= (+ (car triples) (cadr triples) (caddr triples)) s)) 
        (unique-triples n))
)

(define (unique-triples n)
    (flatmap
        (lambda (i)
            (flatmap (lambda (j)
                    (map (lambda (k)
                            (list i j k))
                         (enumerate-interval 1 (- j 1))))
                 (enumerate-interval 1 (- i 1))))                        
        (enumerate-interval 1 n)))
```

### Exc 2-42
```scheme
(define (queens board-size)
  (define (queen-cols k)            ;queen-cols：返回前k列中放皇后的所有格局的序列
    (if (= k 0)
        (list empty-board)
        (filter                     ;filter：过滤不安全的皇后位置
          (lambda (positions)
                (safe? k positions))        ;safe? : 判断第k列的皇后是否安全
          (flatmap
            (lambda (rest-of-queens)        ;rest-of-queens：前k-1列放置k-1个皇后的方式
                (map (lambda (new-row)      ;new-row：第k列放置的行编号
                        (adjoin-position new-row 
                                         k 
                                         rest-of-queens))
                     (enumerate-interval 1 board-size)))
            (queen-cols (- k 1))))))
  (queen-cols board-size))

;;;
(define empty-board '())

(define (adjoin-position new-row k rest-of-queens)
    (cons (list new-row k) rest-of-queens))

(define (safe? k positions)
    (define (check-safe current-queen existing-queens)
        (if (null? existing-queens)
            #t
            (and (check current-queen (car existing-queens))
                 (check-safe current-queen (cdr existing-queens)))))
    (define (check current-queen existing-queen)
        (let ((cx (car current-queen))
              (cy (cadr current-queen))
              (ex (car existing-queen))
              (ey (cadr existing-queen)))
            (cond ((= cx ex) #f)
                  ((= (+ cx cy) (+ ex ey)) #f)
                  ((= (- cy cx) (- ey ex)) #f)
                  (else #t))))
    (check-safe (car positions) (cdr positions)))

(define (print-queen items)
    (if (null? items)
        #t
        (begin
            (display (car items))
            (newline)
            (print-queen (cdr items)))))

(print-queen (queens 6))
```

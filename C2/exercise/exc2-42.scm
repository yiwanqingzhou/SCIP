(define nil '())

(define (map proc items)
    (if (null? items)
        nil
        (cons (proc (car items))
              (map proc (cdr items)))))

(define (filter predicate sequence)
    (cond ((null? sequence) nil)
            ((predicate (car sequence))
                (cons (car sequence)
                    (filter predicate (cdr sequence))))
            (else (filter predicate (cdr sequence)))))

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))            

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low
            (enumerate-interval (+ low 1) high))))


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
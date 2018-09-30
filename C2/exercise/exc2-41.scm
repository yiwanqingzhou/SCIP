(define nil '())

(define (s-sum-triples n s)
    (filter 
        (lambda (triples) 
            (= (+ (car triples) (cadr triples) (caddr triples)) s)) 
        (unique-triples n))
)            

; (define (make-triples-sum triples)
;     (let ((A (car triples))
;           (B (cadr triples))
;           (C (caddr triples)))
;        (list A B C (+ A B C))))

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
            (else
            (filter predicate (cdr sequence))))
)

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low
            (enumerate-interval (+ low 1) high))))

(define (unique-triples n)
    (flatmap
        (lambda (i)
            (flatmap (lambda (j)
                    (map (lambda (k)
                            (list i j k))
                         (enumerate-interval 1 (- j 1))))
                 (enumerate-interval 1 (- i 1))))                        
        (enumerate-interval 1 n)))

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))
        

; (display (unique-triples 6))
; (newline)
(display (s-sum-triples 6 10))
(newline)
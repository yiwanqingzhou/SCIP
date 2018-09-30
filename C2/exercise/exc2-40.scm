(define nil '())

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

(define (enumerate-interval low high)
  (if (> low high)
      nil
      (cons low
            (enumerate-interval (+ low 1) high))))


; (define (prime-sum? pair)
;   (prime? (+ (car pair) (cadr pair))))

; (define (make-pair-sum pair)
;   (list (car pair) 
;         (cadr pair)
;         (+ (car pair)
;            (cadr pair))))

; (define (prime-sum-pairs n)
;   (map make-pair-sum
;        (filter 
;         prime-sum?
;         (flatmap
;          (lambda (i)
;            (map (lambda (j) 
;                   (list i j))
;                 (enumerate-interval 
;                  1 
;                  (- i 1))))
;          (enumerate-interval 1 n)))))
         

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

;;;
(define (unique-list n)
  (accumulate 
    append
    nil
    (map (lambda (i)
           (map (lambda (j) 
                  (list i j))
                (enumerate-interval 1 (- i 1))))
         (enumerate-interval 1 n))))

(display (unique-list 5))
(newline)

;;;
(define (unique-list n)
  (flatmap (lambda (i)
              (map 
                  (lambda (j) (list i j))
                  (enumerate-interval 1 (- i 1))))
           (enumerate-interval 1 n)))

(display (unique-list 5))
(newline)
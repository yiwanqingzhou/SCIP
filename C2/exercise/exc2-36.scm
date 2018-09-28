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
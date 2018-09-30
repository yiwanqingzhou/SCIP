(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence))))
)

(define (accumulate-n  op init seqs)
  (if (null? (car seqs))
      nil
      (cons (accumulate op init (car-n seqs))
            (accumulate-n op init (cdr-n seqs)))))

(define nil '())

(define (car-n seqs)
    (map car seqs))
(define (cdr-n seqs)
    (map cdr seqs)) 


;;;;
      
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
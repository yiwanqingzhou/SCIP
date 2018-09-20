(define (f g)
  (g 2))

(define (square x)
  (* x x))  

(display (f square))
(newline)

(display
(f (lambda (z)
      (* z (+ z 1))))
      )
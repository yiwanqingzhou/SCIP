
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
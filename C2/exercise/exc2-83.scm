(define (raise x)
   (let ((proc (get 'raise (list (type-tag x)))))
        (if proc 
            (proc x)
            #f)))

(define (raise-integer-to-rational x)
    (make-rational x 1))
(define (raise-rational-to-real x)
    (make-real (/ (cadr x) (cddr x))))
(define (raise-real-to-complex x)
    (make-complex-from-real-imag x 0))
(put 'raise '(scheme-number) raise-integer-to-rational)
(put 'raise '(rational) raise-rational-to-real)
(put 'raise '(real) raise-real-to-complex)

(define (make-real x)
    (cons 'real (+ x 0.0)))
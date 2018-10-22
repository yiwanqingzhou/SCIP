(put 'negate '(scheme-number)
    (lambda (x) (- x)))


(put 'negate '(rational)
    (lambda (x)
        (make-rational (- (numer x)) (denom x))))


(put 'negate '(real)
    (lambda (x) (cons 'real (- x))))


(put 'negate '(complex)
    (lambda (z) 
        (make-complex-from-real-imag (- (real-part z))
                                     (- (imag-part z)))))  

(define (negate-terms term-list)
    (if (empty-termlist? term-list)
        term-list
        (let ((term (first-term term-list)))
            (adjoin-term (make-term (order term) (negate (coeff term)))
                            (negate-terms (rest-terms term-list))))))
(define (negate-poly p)
    (make-poly (variable p) (negate-terms (term-list p))))
(define (sub-poly p1 p2)
    (add-poly p1 (negate-poly p2)))

(put 'sub '(polynomial polynomial)
    (lambda (p1 p2) (cons 'polynomial (sub-poly p1 p2))))
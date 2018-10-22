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

(define (sub-terms L1 L2)
    (add-terms L1 (negate-terms L2)))

(define (sub-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
        (make-poly (variable p1)
                    (sub-terms (term-list p1)
                                (term-list p2)))
        (error "Polys not in same var -- SUB-POLY"
                (list p1 p2))))

(put 'sub '(polynomial polynomial)
    (lambda (p1 p2) (cons 'polynomial (sub-poly p1 p2))))

    
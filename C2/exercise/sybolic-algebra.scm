; (load "put-and-get.scm")
; (load "tagged-data.scm")
; (load "data-directed-programming.scm")
; (load "sybolic-algebra.scm")



(define (install-scheme-number-package)
    (define (raise-integer-to-rational x)
        (make-rational x 1))

    (define (tag x)
        (attach-tag 'scheme-number x))
    (put 'add '(scheme-number scheme-number)
        (lambda (x y) (tag (+ x y))))
    (put 'sub '(scheme-number scheme-number)
        (lambda (x y) (tag (- x y))))
    (put 'mul '(scheme-number scheme-number)
        (lambda (x y) (tag (* x y))))
    (put 'div '(scheme-number scheme-number)
        (lambda (x y) (tag (/ x y))))
    (put 'equ? '(scheme-number scheme-number)
        (lambda (x y) (= x y)))
    (put '=zero? '(scheme-number)
        (lambda (x) (= x 0)))
    (put 'raise '(scheme-number)
        raise-integer-to-rational)
    (put 'negate '(scheme-number)
        (lambda (x) (tag (- x))))
    (put 'make 'scheme-number
        (lambda (x) (tag x)))
'done )

(define (make-scheme-number x)
    ((get 'make 'scheme-number ) x))



(define (install-rational-package)
    ;;; internal procedures
    (define (numer x) (car x))
    (define (denom x) (cdr x))
    (define (make-rat n d)
        (let ((g (gcd n d)))
            (cons (/ n g) (/ d g))))
    (define (add-rat x y)
        (make-rat (+ (* (numer x) (denom y))
                     (* (denom x) (numer y)))
                  (* (denom x) (denom y))))
    (define (sub-rat x y)
        (make-rat (- (* (numer x) (denom y))
                     (* (numer y) (denom x)))
                  (* (denom x) (denom y))))
    (define (mul-rat x y)
        (make-rat (* (numer x) (numer y))
                  (* (denom x) (denom y))))
    (define (div-rat x y)
        (make-rat (* (numer x) (denom y))
                  (* (denom x) (numer y))))
    (define (rational-equ? x y)
        (=  (* (numer x) (denom y))
            (* (numer y) (denom x))))
    (define (rational-zero? x)
        (= (numer x) 0))
    (define (raise-rational-to-real x)
        (make-real (/ (numer x) (denom x))))
    
    ;;; interface to rest of the system
    (define (tag x) (attach-tag 'rational x))
    (put 'add '(rational rational)
        (lambda (x y) (tag (add-rat x y))))
    (put 'sub '(rational rational)
        (lambda (x y) (tag (sub-rat x y))))
    (put 'mul '(rational rational)
        (lambda (x y) (tag (mul-rat x y))))
    (put 'div '(rational rational)
        (lambda (x y) (tag (div-rat x y))))
    (put 'equ? '(rational rational)
        (lambda (x y) (rational-equ? x y)))
    (put '=zero? '(rational)
        (lambda (x) (rational-zero? x)))
    (put 'raise '(rational) raise-rational-to-real)
    (put 'project '(rational) 
        (lambda (x)
            (make-scheme-number (round (/ (car x) (cdr x))))))
    (put 'negate '(rational)
        (lambda (x)
            (tag (make-rat (- (numer x)) (denom x)))))
    (put 'make 'rational
        (lambda (n d) (tag (make-rat n d))))
        
    (put 'numer '(rational) numer)
    (put 'denom '(rational) denom)
'done )

(define (make-rational n d)
    ((get 'make 'rational ) n d))
(define (numer x) (apply-generic 'numer x))
(define (denom x) (apply-generic 'denom x))




(define (install-real-package)
    (define (raise-real-to-complex x)
        (make-complex-from-real-imag x 0))

    (define (tag x)
        (cons 'real x))
    (put 'add '(real real)
        (lambda (x y) (tag (+ x y))))
    (put 'sub '(real real)
        (lambda (x y) (tag (- x y))))
    (put 'mul '(real real)
        (lambda (x y) (tag (* x y))))
    (put 'div '(real real)
        (lambda (x y) (tag (/ x y))))
    (put 'equ? '(real real)
        (lambda (x y) (= x y)))
    (put '=zero? '(real)
        (lambda (x) (= x 0)))
    (put 'raise '(real) 
        raise-real-to-complex)
    (put 'project '(real)
        (lambda (x)
            (let ((rational (inexact->exact x)))
                (make-rational  (numerator rational)
                                (denominator rational)))))
    (put 'negate '(real)
        (lambda (x) (tag (- x))))
    (put 'make 'real
        (lambda (x) (tag (+ x 0.0))))
'done )

(define (make-real x)
    ((get 'make 'real ) x))
    


(define (install-complex-package)
    ;; imported proceduers from rectangular and polar packages
    (define (make-from-real-imag x y)
        ((get 'make-from-real-imag 'rectangular ) x y))
    (define (make-from-mag-ang x y)
        ((get 'make-from-mag-ang 'polar ) x y))
    
    ;; internal procedures
    (define (add-complex z1 z2)
        (make-from-real-imag (+ (real-part z1) (real-part z2))
                             (+ (imag-part z2) (imag-part z2))))
    (define (sub-complex z1 z2)
        (make-from-real-imag (- (real-part z1) (real-part z2))
                             (- (imag-part z1) (imag-part z2))))
    (define (mul-complex z1 z2)
        (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                           (+ (angle z1) (angle z2))))
    (define (div-complex z1 z2)
        (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                           (- (angle z1) (angle z2))))
    (define (complex-equ? z1 z2)
        (and (= (real-part z1) (real-part z2))
             (= (imag-part z1) (imag-part z2))))
    (define (complex-zero? z)
        (and (= (real-part z) 0)
             (= (imag-part z) 0)))
    (define (raise-complex-to-poly z)
        (make-polynomial 'x (list (cons 0 z))))
    
    ;; interface
    (define (tag x)
        (attach-tag 'complex x))
    (put 'add '(complex complex)
        (lambda (z1 z2) (tag (add-complex z1 z2))))
    (put 'sub '(complex complex)
        (lambda (z1 z2) (tag (sub-complex z1 z2))))
    (put 'mul '(complex complex)
        (lambda (z1 z2) (tag (mul-complex z1 z2))))
    (put 'div '(complex complex)
        (lambda (z1 z2) (tag (div-complex z1 z2))))
    (put 'equ? '(complex complex)
        (lambda (z1 z2) (complex-equ? z1 z2)))
    (put '=zero? '(complex) complex-zero?)
    (put 'raise '(complex) 
        raise-complex-to-poly)
    (put 'project '(complex)
        (lambda (z) (make-real (real-part z))))
    (put 'negate '(complex)
        (lambda (z) 
            (tag (make-from-real-imag (- (real-part z))
                                      (- (imag-part z))))))
    (put 'make-from-real-imag 'complex
        (lambda (x y) (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'complex
        (lambda (r a) (tag (make-from-mag-ang r a))))
    
    (put 'real-part '(complex) real-part)
    (put 'imag-part '(complex) imag-part)
    (put 'magnitude '(complex) magnitude)
    (put 'angle '(complex) angle)
'done )

(define (make-complex-from-real-imag x y)
    ((get 'make-from-real-imag 'complex ) x y))
(define (make-complex-from-mag-ang x y)
    ((get 'make-from-mag-ang 'complex ) x y))






(define (install-polynomial-package)
    ;; internal procedures
    ;; representation of poly
    (define (make-poly variable term-list)
        (cons variable term-list))
    (define (variable p) (car p))
    (define (term-list p) (cdr p))
    (define (same-variable? v1 v2)
        (and (variable? v1)
            (variable? v2)
            (eq? v1 v2)))
    (define (variable? x) (symbol? x))


    ;; representation of terms and term lists
    (define (adjoin-term term term-list)
        (if (=zero? (coeff term))
            term-list
            (cons term term-list)))
    (define (the-empty-termlist) '())
    (define (first-term term-list) (car term-list))
    (define (rest-terms term-list) (cdr term-list))
    (define (empty-termlist? term-list) 
        (null? term-list))
    (define (make-term order coeff) 
        (list order coeff))
    (define (order term) (car term))
    (define (coeff term) (cadr term))

    (define (add-terms L1 L2)
        (cond ((empty-termlist? L1) L2)
              ((empty-termlist? L2) L1)
              (else
                (let ((t1 (first-term L1)) 
                      (t2 (first-term L2)))
                  (cond ((> (order t1) (order t2))
                         (adjoin-term t1 (add-terms (rest-terms L1) L2)))
                        ((< (order t1) (order t2))
                         (adjoin-term t2 (add-terms L1 (rest-terms L2))))
                        (else       
                            (adjoin-term (make-term (order t1)
                                                    (add (coeff t1) 
                                                         (coeff t2)))
                                         (add-terms (rest-terms L1)
                                                    (rest-terms L2)))))))))
    
    (define (mul-terms L1 L2)
        (if (empty-termlist? L1)
            (the-empty-termlist)
            (add-terms (mul-term-by-all-terms (first-term L1) L2)
                       (mul-terms (rest-terms L1) L2))))

    (define (mul-term-by-all-terms t1 L)
        (if (empty-termlist? L)
            (the-empty-termlist)
            (let ((t2 (first-term L)))
                (adjoin-term
                    (make-term (+ (order t1) (order t2))
                               (mul (coeff t1) (coeff t2)))
                    (mul-term-by-all-terms t1 (rest-terms L))))))
    
    
    ;; arithmetic on poly
    (define (add-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                       (add-terms (term-list p1)
                                  (term-list p2)))
            (error "Polys not in same var -- ADD-POLY"
                    (list p1 p2))))

    ;; (define (sub-poly p1 p2) 
    ;;    (add-poly p1 (negate-poly p2)))

    (define (mul-poly p1 p2)
        (if (same-variable? (variable p1) 
                            (variable p2))
            (make-poly (variable p1)
                       (mul-terms (term-list p1)
                                  (term-list p2)))
            (error "Polys not in same var -- MUL-POLY"
                    (list p1 p2))))
    


    ;; added
    ;; 2-87
    (define (poly-zero? p)
        (define (terms-zero? terms)
            (or (empty-termlist? terms)
                (and (=zero? (coeff (first-term terms)))
                     (terms-zero? (rest-terms terms)))))
        (terms-zero? (term-list p)))

    ;; 2-88
    (define (negate-terms term-list)
        (if (empty-termlist? term-list)
            term-list
            (let ((term (first-term term-list)))
                (adjoin-term (make-term (order term) (negate (coeff term)))
                             (negate-terms (rest-terms term-list))))))

    (define (negate-poly p)
        (make-poly (variable p) (negate-terms (term-list p))))

    (define (sub-terms L1 L2)
        (add-terms L1 (negate-terms L2)))

    (define (sub-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                       (sub-terms (term-list p1)
                                  (term-list p2)))
            (error "Polys not in same var -- SUB-POLY"
                    (list p1 p2))))

    (define (div-terms L1 L2)  ;; 返回商和余
    (cond ((empty-termlist? L2) 
            (error "Can't div an empty poly -- DIV-POLY"
                    (list L1 L2)))
          ((empty-termlist? L1)
          (list (the-empty-termlist) (the-empty-termlist)))
          (else
            (let ((t1 (first-term L1))
                  (t2 (first-term L2)))
                (if (> (order t2) (order t1))
                    (list (the-empty-termlist) L1)
                    (let ((new-c (div (coeff t1) 
                                        (coeff t2)))
                            (new-o (- (order t1) 
                                    (order t2))))
                        (let ((rest-of-result
                                (div-terms
                                    (sub-terms 
                                        L1
                                        (mul-term-by-all-terms 
                                            (make-term new-o new-c)
                                            L2))
                                    L2)))
                            (cons (adjoin-term (make-term new-o new-c)
                                            (car rest-of-result))
                                (cdr rest-of-result)))))))))
                            
    (define (div-poly p1 p2)
        (if (same-variable? (variable p1) (variable p2))
            (make-poly (variable p1)
                       (div-terms (term-list p1)
                                  (term-list p2)))
            (error "Polys not in same var -- DIV-POLY"
                    (list p1 p2))))


    ;; interface to rest of the system
    (define (tag p) (attach-tag 'polynomial p))
    (put 'add '(polynomial polynomial)
        (lambda (p1 p2) (tag (add-poly p1 p2))))
    (put 'mul '(polynomial polynomial)
        (lambda (p1 p2) (tag (mul-poly p1 p2))))
    (put 'make 'polynomial
        (lambda (var terms) (tag (make-poly var terms))))

    ;; added
    (put '=zero? '(polynomial) poly-zero?)
    (put 'negate '(polynomial)
        (lambda (p) (tag (negate-poly p))))
    (put 'sub '(polynomial polynomial)
        (lambda (p1 p2) (tag (sub-poly p1 p2))))
    (put 'div '(polynomial polynomial)
        (lambda (p1 p2) (tag (div-poly p1 p2))))

'done )

(define (make-polynomial var terms)
    ((get 'make 'polynomial) var terms))




(install-scheme-number-package)
(install-rational-package)
(install-complex-package)
(install-real-package)
(install-polynomial-package)





(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((a1 (car args))
                    (a2 (cadr args)))
                  (cond ((raise-to? a1 a2)
                         (apply-generic op (raise-to? a1 a2) a2))
                        ((raise-to? a2 a1)
                         (apply-generic op a1 (raise-to? a2 a1)))
                        (else
                         (error "No method for these types1"
                                    (list op type-tags)))))
              (error "No method for these types2"
                        (list op type-tags)))))))


(define (apply-generic-nonerror op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          #f))))



(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))

(define (equ? x y) (apply-generic 'equ? x y))
(define (=zero? x) (apply-generic '=zero? x))

(define (negate x) (apply-generic 'negate x))

(define (raise x) (apply-generic-nonerror 'raise x))
(define (project x) (apply-generic-nonerror 'project x))

(define (raise-to? from to)
    (let ((type-from (type-tag from))
          (type-to (type-tag to)))
        (if (eq? type-from type-to)
            from
            (let ((upper (raise from)))
                (if upper
                    (raise-to? upper to)
                    #f)))))

(define (drop x)
    (let ((dropped (project x)))
        (if dropped
            (let ((res (raise dropped)))
                (if (equal? x res)
                    (let ((dd (drop dropped)))
                        (if dd
                            dd
                            dropped))
                    #f))
            #f)))

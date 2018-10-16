(load "tagged-data.scm")
(load "put-and-get.scm")
(load "data-directed-programming.scm")

(define (equ? x y)
    (apply-generic 'equ? x y))

(define (zero? x)
    (apply-generic 'zero? x))

(define (apply-generic op . args)
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))
                (error "No method for these types -- APPLY-GENERIC"
                    (list op type-tags))))))

(define (install-scheme-number-package)
    (define (tag x)
        (attach-tag 'scheme-number x))
    (put 'equ? '(scheme-number scheme-number)
        (lambda (x y) (= x y)))
    (put 'zero? '(scheme-number)
        (lambda (x) (= x 0)))
    (put 'make 'scheme-number
        (lambda (x) (tag x)))
'done )                    

(define (make-scheme-number x)
    ((get 'make 'scheme-number ) x))


(define (install-rational-package)
    (define (numer x) (car x))
    (define (denom x) (cdr x))
    (define (make-rat n d)
        (let ((g (gcd n d)))
            (cons (/ n g) (/ d g))))
    (define (rational-equ? x y)
        (=  (* (numer x) (denom y))
            (* (numer y) (denom x))))
    (define (rational-zero? x)
        (= (numer x) 0))

    (define (tag x)
        (attach-tag 'rational x))
    (put 'equ? '(rational rational)
        (lambda (x y) 
            (rational-equ? x y)))
    (put 'zero? '(rational)
        (lambda (x)
            (rational-zero? x)))
    (put 'make 'rational
        (lambda (n d)
            (tag (make-rat n d))))
'done )

(define (make-rational n d)
    ((get 'make 'rational ) n d))


(define (install-complex-package)
    ;; imported proceduers from rectangular and polar packages
    (define (make-from-real-imag x y)
        ((get 'make-from-real-imag 'rectangular ) x y))
    (define (make-from-mag-ang x y)
        ((get 'make-from-mag-ang 'polar ) x y))
    (define (complex-equ? z1 z2)
        (and (= (real-part z1) (real-part z2))
             (= (imag-part z1) (imag-part z2))))
    (define (complex-zero? z)
        (and (= (real-part z) 0)
             (= (imag-part z) 0)))
    
    (define (tag z)
        (attach-tag 'complex z))
    (put 'equ? '(complex complex)
        (lambda (z1 z2)
            (complex-equ? z1 z2)))
    (put 'zero? '(complex)
        (lambda (z)
            (complex-zero? z)))

    (put 'make-from-real-imag 'complex
        (lambda (x y)
            (tag (make-from-real-imag x y))))
    (put 'make-from-mag-ang 'complex
        (lambda (r a)
            (tag (make-from-mag-ang r a))))

    (put 'real-part '(complex) real-part)
    (put 'imag-part '(complex) imag-part)
    (put 'magnitude '(complex) magnitude)
    (put 'angle '(complex) angle)
'done )

(define (make-complex-from-real-imag x y)
    ((get 'make-from-real-imag 'complex ) x y))

(define (make-complex-from-mag-ang r a)
    ((get 'make-from-mag-ang 'complex ) r a))

(install-scheme-number-package)
(install-rational-package)
(install-complex-package)    
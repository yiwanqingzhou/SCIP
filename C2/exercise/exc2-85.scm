(define (project x)
    (apply-generic-nonerror 'project x))

(put 'project '(complex)
    (lambda (z)
        (make-real (real-part z))))

(put 'project '(real)
    (lambda (x)
        (let ((rational (inexact->exact x)))
            (make-rational  (numerator rational)
                            (denominator rational)))))

(put 'project '(rational) 
    (lambda (x)
         (make-scheme-number (round (/ (car x) (cdr x))))))



(define (equal? x y)
    (apply-generic 'equal? x y))

(put 'equal? '(scheme-number scheme-number)
    (lambda (x y) (= x y)))

(put 'equal? '(rational rational)
    (lambda (x y)
        (= (* (car x) (cdr y))
           (* (cdr x) (car y)))))

(put 'equal? '(real real)
    (lambda (x y) 
        (< (- x y) 0.00001)))

(put 'equal? '(complex complex)
    (lambda (x y)
        (and (= (real-part x) (real-part y))
             (= (imag-part x) (imag-part y)))))


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



; (define rat1 (make-rational 3 5))
; (define rat2 (make-rational 3 1))
; (define com1 (make-complex-from-real-imag 3 5))
; (define com2 (make-complex-from-real-imag 3 0))            
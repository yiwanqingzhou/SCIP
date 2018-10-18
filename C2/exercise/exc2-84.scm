;; 2-83
; (define (raise x)
;     (apply-generic 'raise x))

(define (raise x)
   (apply-generic-nonerror 'raise x))

(define (raise-integer-to-rational x)
    (make-rational x 1))
(define (raise-rational-to-real x)
    (make-real (/ (car x) (cdr x))))
(define (raise-real-to-complex x)
    (make-complex-from-real-imag x 0))
    
(put 'raise '(scheme-number) raise-integer-to-rational)
(put 'raise '(rational) raise-rational-to-real)
(put 'raise '(real) raise-real-to-complex)


;; 2-84
(define (raise-to? from to)
    (let ((type-from (type-tag from))
          (type-to (type-tag to)))
        (if (eq? type-from type-to)
            from
            (let ((upper (raise from)))
                (if upper
                    (raise-to? upper to)
                    #f)))))

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
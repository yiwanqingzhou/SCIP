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
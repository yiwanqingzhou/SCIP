

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

(put 'div '(polynomial polynomial)
    (lambda (p1 p2) (tag (div-poly p1 p2))))                


(define (install-sparse-terms-package)
  ;; internal procedures
  ;; representation of terms and term lists
  (define (adjoin-term term term-list)
    (cond ((=zero? (coeff term)) term-list)
          ((or (empty-termlist? term-list)
               (> (order term) (order (first-term term-list))))
           (cons term term-list))
          (else (error
                 "Cannot adjoin term of lower order than term list -- ADJOIN-TERM"
                 (list term term-list)))))

  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  ;; creation
  (define (insert-term term terms)
    (if (empty-termlist? terms)
        (adjoin-term term terms)
        (let* ((head (first-term terms))
               (head-order (order head))
               (term-order (order term)))
          (cond ((> term-order head-order) 
                    (adjoin-term term terms))
                ((= term-order head-order)
                 (adjoin-term (make-term term-order 
                                         (add (coeff term) (coeff head)))
                              (rest-terms terms)))
                (else (adjoin-term 
                        head 
                        (insert-term term (rest-terms terms))))))))
  (define (build-terms terms result)
    (if (null? terms)
        result
        (build-terms (cdr terms) 
                     (insert-term (car terms) result))))
  (define (make-from-terms terms)
    (build-terms terms (the-empty-termlist)))

  (define (convert-to-term-list coeffs)
    (if (null? coeffs)
        (the-empty-termlist)
        (adjoin-term (make-term (- (length coeffs) 1) (car coeffs))
                     (convert-to-term-list (cdr coeffs)))))
  (define (make-from-coeffs coeffs)
    (convert-to-term-list coeffs))

  ;; interface to rest of the system
  (define (tag tl) (attach-tag 'sparse-terms tl))
  (put 'adjoin-term 'sparse-terms
       (lambda (t tl) (tag (adjoin-term t tl))))
  (put 'the-empty-termlist 'sparse-terms
       (lambda () (tag (the-empty-termlist))))
  (put 'first-term '(sparse-terms)
       (lambda (tl) (first-term tl)))
  (put 'rest-terms '(sparse-terms)
       (lambda (tl) (tag (rest-terms tl))))
  (put 'empty-termlist? '(sparse-terms)
       (lambda (tl) (empty-termlist? tl)))
  (put 'make-from-terms 'sparse-terms
       (lambda (terms) (tag (make-from-terms terms))))
  (put 'make-from-coeffs 'sparse-terms
       (lambda (coeffs) (tag (make-from-coeffs coeffs))))
  (put-coercion 'sparse-terms 'dense-terms sparse-terms->dense-terms)

'done )


;; Coercion
(define (sparse-terms->dense-terms L)
    ((get 'make-from-terms 'dense-terms ) L))

(define (dense-terms->spare-terms L)
    ((get 'make-from-terms 'sparse-terms ) L))



;;; Dense
;;; 
(define (install-dense-terms-package)
    ;; internal procedures
    ;; representation of term lists
    (define (adjoin-term term term-list)
        (let ((term-order (order term))
              (term-coeff (coeff term)))
        (cond ((=zero? term-coeff) term-list)
              ((= term-order (+ 1 (term-list-order term-list)))
                (cons term-coeff term-list))
              ((> term-order (term-list-order term-list))
                (adjoin-term term (cons zero term-list)))
              (else (error
                    "Cannot adjoin term of lower order than term list -- ADJOIN-TERM"
                        (list term term-list))))))
    (define (the-empty-termlist) '())
    (define (first-term term-list)
        (if (empty-termlist? term-list)
            (make-term 0 zero)
            (let ((head (car term-list)))
                (if (=zero? head)
                    (first-term (cdr term-list))
                    (make-term (term-list-order term-list) (car term-list))))))
    (define (rest-terms term-list)
        (let ((tail (cdr term-list)))
            (cond ((empty-termlist? tail) tail)
                  ((=zero? (car tail)) (rest-terms tail))
                  (else tail))))
    (define (empty-termlist? term-list)
        (null? term-list))
    (define (term-list-order term-list)
        (- (length term-list) 1))

    ;; Creation
    (define (strip-leading-zeros coeffs)
        (cond ((empty-termlist? coeffs) (the-empty-termlist))
            ((not (=zero? (first-term coeffs))) coeffs)
            (else (make-from-coeffs (rest-terms coeffs)))))
    (define (make-from-coeffs coeffs) coeffs)

    (define (insert-term term terms)
        (if (empty-termlist? terms)
            (adjoin-term term terms)
            (let* ((head (first-term terms))
                   (head-order (order head))
                   (term-order (order term)))
            (cond ((> term-order head-order) (adjoin-term term terms))
                  ((= term-order head-order)
                    (adjoin-term (make-term term-order (add (coeff term) (coeff head)))
                                 (rest-terms terms)))
                    (else (adjoin-term head (insert-term term (rest-terms terms))))))))
    (define (build-terms terms result)
        (if (null? terms)
            result
            (build-terms (cdr terms) 
                        (insert-term (car terms) result))))
    (define (make-from-terms terms)
        (build-terms terms (the-empty-termlist)))
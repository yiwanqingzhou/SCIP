(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp) 
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
           (make-product 
            (multiplier exp)
            (deriv (multiplicand exp) var))
           (make-product 
            (deriv (multiplier exp) var)
            (multiplicand exp))))
; ⟨more rules can be added here⟩
        (else (error "unknown expression type: DERIV" exp))))


(define (deriv exp var)
    (cond ((number? exp) 0)
          ((variable? exp) 
          (if (same-variable? exp var) 1 0))
             (else ((get 'deriv (operator exp)) 
                    (operands exp) 
                    var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(install-sum-package
    (define (addend exp) (car exp))
    (define (augend exp) (cdr exp))    
    
    (define (make-sum a1 a2)
        (cond ((=number? a1 0) a2)
              ((=number? a2 0) a1)
              ((and (number? a1) (number? a2)) 
               (+ a1 a2))
              (else (list '+ a1 a2))))
    
    (put 'addend '+ addend)
    (put 'augend '+ augend)
    (put 'make-sum '+ make-sum)
    (put 'deriv '+
        (lambda (exp var) 
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var))))

'done )

(define (make-sum x y)
    ((get 'make-sum '+ ) x y))
(define (addend exp)
    ((get 'addend '+ ) exp))
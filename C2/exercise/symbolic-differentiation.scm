;;;是否变量
(define (variable? x) 
    (symbol? x))

;;;v1&v2是同一个变量吗
(define (same-variable? v1 v2)
  (and (variable? v1)
       (variable? v2)
       (eq? v1 v2)))


;;;和式&乘式
(define (make-sum a1 a2) (list '+ a1 a2))
(define (make-product m1 m2) (list '* m1 m2))

(define (addend s) (cadr s))
(define (augend s) (caddr s))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))
(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) 
         (+ a1 a2))
        (else (list '+ a1 a2))))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) 
               (=number? m2 0)) 
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) 
           (* m1 m2))
          (else (list '* m1 m2))))

;;;常量          
(define (=number? exp num)
    (and (number? exp) (= exp num)))          


;;;
(define (deriv exp var)
  (cond ((number? exp) 0)                   ;常量
        ((variable? exp)                    ;单变量
            (if (same-variable? exp var) 1 0))
        ((sum? exp)                         ;和式
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var)))
        ((product? exp)                     ;乘式
            (make-sum
                (make-product 
                    (multiplier exp)
                    (deriv (multiplicand exp) var))
                (make-product 
                    (deriv (multiplier exp) var)
                    (multiplicand exp))))
        (else (error "unknown expression       
                                  type: DERIV" exp))))

(display (deriv '(+ x 3) 'x))
(newline)                                  
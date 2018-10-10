# 2.3 Symbolic Data

## 2.3.1

### Exc 2-53
```scheme
(list 'a 'b 'c )

(list (list 'george ))

(cdr '((x1 x2) (yq y2)))

(cadr '((x1 x2) (yq y2)))

(pair? (car '(a short list)))

(memq 'red '((red shoes) (blue socks)))

(memq 'red '(red shoes blue socks))
```


### Exc 2-54
```scheme
(define (equal? a b)
    (cond ((and (pair? a) (pair? b))
                (and (equal? (car a) (car b))
                    (equal? (cdr a) (cdr b))))
          ((or (pair? a) (pair? b)) #f)
          (else (eq? a b))))
```


### Exc 2-55
```scheme

```


## 2.3.2

### Exc 2-56
```scheme
(define (deriv exp var)
  (cond ((number? exp) 0)                   ; 常量
        ((variable? exp)                    ; 单变量
            (if (same-variable? exp var) 1 0))
        ((sum? exp)                         ; 和式
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var)))
        ((product? exp)                     ; 乘式
            (make-sum
                (make-product 
                    (multiplier exp)
                    (deriv (multiplicand exp) var))
                (make-product 
                    (deriv (multiplier exp) var)
                    (multiplicand exp))))
        ((exponentiation? exp)              ; 乘幂 2-56
            (make-product
                (make-product 
                    (exponent exp)
                    (make-exponentiation 
                        (base exp) 
                        (- (exponent exp) 1)))
                (deriv (base exp) var)))
        (else (error "unknown expression       
                                  type: DERIV" exp))))


;;; 乘幂  2-56                                
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))
(define (base p) (cadr p))
(define (exponent p) (caddr p))
(define (make-exponentiation base exponent)
    (cond ((=number? exponent 0) 1)
          ((=number? exponent 1) base)
          ((and (number? base) (number? exponent))
            (power base exponent))
          (else (list '** base exponent ))))

(define (power base exponent)
    (define (power-iter result k)
        (if (= k exponent)
            result
            (power-iter (*base result) (+ k 1))))
    (power-iter 1 0))
```

### Exc 2-57
```scheme
;;; 和式
(define (addend s) (cadr s))
(define (augend s)
    (if (> (length s) 3)
        (cons '+ (cddr s))
        (caddr s)))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) 
         (+ a1 a2))
        (else (list '+ a1 a2))))


;;; 乘式        
(define (multiplier p) (cadr p))
(define (multiplicand p) 
    (if (> (length p) 3)
        (cons '* (cddr p))
        (caddr p)))
(define (product? x)
  (and (pair? x) (eq? (car x) '*)))
(define (make-product m1 m2)
    (cond ((or (=number? m1 0) 
               (=number? m2 0)) 
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) 
           (* m1 m2))
          (else (list '* m1 m2))))
```

### Exc 2-58
a)
```scheme
;;; 常量          
(define (=number? exp num)
    (and (number? exp) (= exp num)))   

;;; 是否变量
(define (variable? x) 
    (symbol? x))

;;; v1&v2是同一个变量吗
(define (same-variable? v1 v2)
  (and (variable? v1)
       (variable? v2)
       (eq? v1 v2)))


(define (cleaner sequence) 
    (if (null? (cdr sequence)) 
        (car sequence) 
        sequence))

;;; 和式
(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+ )))

(define (addend s) 
    (car (cleaner s)))
(define (augend s) 
    (caddr (cleaner s)))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) 
         (+ a1 a2))
        (else (list a1 '+ a2))))


;;; 乘式        
(define (product? x)
  (and (pair? x) (eq? (cadr x) '* )))

(define (multiplier p)
    (car (cleaner p)))
(define (multiplicand p)
    (caddr (cleaner p)))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) 
               (=number? m2 0)) 
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) 
           (* m1 m2))
          (else (list m1 '* m2))))

       
;;;
(define (deriv exp var)
  (cond ((number? exp) 0)                   ; 常量
        ((variable? exp)                    ; 单变量
            (if (same-variable? exp var) 1 0))
        ((sum? exp)                         ; 和式
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var)))
        ((product? exp)                     ; 乘式
            (make-sum
                (make-product 
                    (multiplier exp)
                    (deriv (multiplicand exp) var))
                (make-product 
                    (deriv (multiplier exp) var)
                    (multiplicand exp))))
        ((exponentiation? exp)              ; 乘幂 2-56
            (make-product
                (make-product 
                    (exponent exp)
                    (make-exponentiation 
                        (base exp) 
                        (- (exponent exp) 1)))
                (deriv (base exp) var)))
        (else (error "unknown expression       
                                  type: DERIV" exp))))


;;; 乘幂  2-56                                
(define (exponentiation? x)
  (and (pair? x) (eq? (cadr x) '**)))
(define (base p) (car (cleaner p)))
(define (exponent p) (caddr (cleaner p)))
(define (make-exponentiation base exponent)
    (cond ((=number? exponent 0) 1)
          ((=number? exponent 1) base)
          ((and (number? base) (number? exponent))
            (power base exponent))
          (else (list '** base exponent ))))

(define (power base exponent)
    (define (power-iter result k)
        (if (= k exponent)
            result
            (power-iter (* base result) (+ k 1))))
    (power-iter 1 0))

(define a '(x + (3 * (x + (y + 2)))))

(display (deriv a 'x ))
(newline)
```

b)
puzzle
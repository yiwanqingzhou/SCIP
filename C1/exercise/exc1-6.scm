(define (square x) (* x x))

(define (abs x)
	(if (< x 0) (- x) x))

(define (average x y) 
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))


(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (sqrt x)
  (sqrt-iter 1.0 x))

(display (sqrt 9))
(newline)


(define (sqrt-iter-cond guess x)
  (cond ((good-enough? guess x) guess)
      	(else (sqrt-iter (improve guess x) x))))

(define (sqrt-cond x)
  (sqrt-iter-cond 1.0 x))

(display (sqrt-cond 9))
(newline)


(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter-newif guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter-newif (improve guess x) x)))

(define (sqrt-newif x)
  (sqrt-iter-newif 1.0 x))

(display (sqrt-newif 9))
(newline)


(define (square x) (* x x))

(define (abs x)
	(if (< x 0) (- x) x))

(define (average x y) 
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (sqrt x) (sqrt-iter 0.5 1.0 x))

(define (sqrt-iter lassguess guess x)
  (if (good-enough? lassguess guess) guess
      (sqrt-iter guess (improve guess x) x)))

(define (good-enough? lassguess guess)
  (< (abs (- lassguess guess) ) 0.01))

(display (sqrt 9))
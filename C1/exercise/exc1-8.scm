
(define (square x) (* x x))
(define (cube x) (* x x x))

(define (abs x)
	(if (< x 0) (- x) x))

(define (average x y z) 
  (/ (+ x y z) 3))

(define (improve guess x)
  (average (/ x (square guess)) guess guess))

(define (cube-root x) (cube-root-iter 1.0 x))

(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x) x)))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x) ) 0.01))

(display (cube-root 8))
(newline)
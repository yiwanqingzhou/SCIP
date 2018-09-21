(define (make-segment start-point end-point)
  (cons start-point end-point))

(define (start-segment segment)
  (car segment))
  
(define (end-segment segment)
  (cdr segment))
  
(define (make-point x y)
  (cons x y))
  
(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (midpoint-segment s)
  (let ((start (start-segment s))
        (end (end-segment s)))
    (make-point 
        (/ (+ (x-point start) (x-point end)) 2)
        (/ (+ (y-point start) (y-point end)) 2))))

(define (print-point p)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")")
  (newline))

(define ss (make-point 1 -2))
(define se (make-point 5 6))
(define s (make-segment ss se))
(print-point (midpoint-segment s))

(define (gcd a b)
(if (= (remainder a b) 0)
    b
    (gcd b (remainder a b))))

(define (fix-abs x)
  (if (or (and (< (car x) 0) (< (cdr x) 0)) 
          (and (> (car x) 0) (< (cdr x) 0)))
      (cons (- (car x)) (- (cdr x)))
      x))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (fix-abs (cons (/ n g) (/ d g)))))


(define (numer x)
  (car x))
  
(define (denom x)
  (cdr x))

(define (print-rat x)
  (display (numer x))
  (display "/")
  (display (denom x))
  (newline))

(print-rat (make-rat 1 5))
(print-rat (make-rat -1 5))
(print-rat (make-rat 1 -5))
(print-rat (make-rat -1 -5))
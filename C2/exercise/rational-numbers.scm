(define (make-rat n d)
  (cons n d))

(define (numer x)
  (car x))

(define (denom x)
  (cdr x))


(define (add-rat x y)
(make-rat (+ (* (numer x) (denom y))
             (* (numer y) (denom x)))
          (* (denom x) (denom y))))

(define (sub-rat x y)
(make-rat (- (* (numer x) (denom y))
             (* (numer y) (denom x)))
          (* (denom x) (denom y))))

(define (mul-rat x y)
(make-rat (* (numer x) (numer y))
          (* (denom x) (denom y))))

(define (div-rat x y)
(make-rat (* (numer x) (denom y))
          (* (denom x) (numer y))))

(define (equal-rat? x y)
(= (* (numer x) (denom y))
   (* (numer y) (denom x))))

(define (print-rat x)
  (display (numer x))
  (display "/")
  (display (denom x))
  (newline))


;;;考虑约分
(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

(define (gcd a b)
  (if (= (remainder a b) 0)
      b
      (gcd b (remainder a b))))
      
;;;
;;;考虑正负
;;;
(define (fix-abs x)
  (if (or (and (< (car x) 0) (< (cdr x) 0)) 
          (and (> (car x) 0) (< (cdr x) 0)))
      (cons (- (car x)) (- (cdr x)))
      x))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (fix-abs (cons (/ n g) (/ d g)))))

(print-rat (make-rat 1 5))
(print-rat (make-rat -1 5))
(print-rat (make-rat 1 -5))
(print-rat (make-rat -1 -5))
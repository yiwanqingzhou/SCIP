(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))

;;;
;;;
(define (iterative-improve good-enough? improve)
  (lambda (guess)
      (let ((next (improve guess)))
        (if (good-enough? guess next)
            guess
            ((iterative-improve good-enough? improve) next)))))


(define (fixed-point f first-guess)
  (define tolerance 0.0001)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  ((iterative-improve close-enough? f) first-guess))

(define (average x y)
  (/ (+ x y) 2))

(define (average-damp f)
  (lambda (x) (average x (f x))))

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
                1.0))          

(display (sqrt 9))                
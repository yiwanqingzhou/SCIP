
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))
      
(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (even? x)
  (= (remainder x 2) 0))

(define (inc x)
  (+ x 1))

(define (term k)
  (if (even? k)
      (/ (+ k 2) (+ k 1))
      (/ (+ k 1) (+ k 2))))

(define (pi n)
  (* 4 (product term 1.0 inc n)))

(display (pi 100))
(newline)

(define (pi-iter n)
  (* 4 (product-iter term 1.0 inc n)))

(display (pi-iter 100))
(newline)
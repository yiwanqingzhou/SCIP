(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

(define (accumulate combiner null-value term a next b)
  (define (accumulate-iter a result)
    (if (> a b)
        result
        (accumulate-iter (next a) 
                         (combiner (term a) result))))
  (accumulate-iter a null-value))              

(define (sum term a next b)
  (define (plus x y)
    (+ x y))
  (define null-value 0)
  (accumulate plus null-value term a next b))

(define (identity x) x)
(define (inc x) (+ x 1))

(define (sum-intergers a b)
  (sum identity a inc b))

(define (product term a next b)
  (define (muti x y)
    (* x y))
  (define null-value 1)
  (accumulate muti null-value term a next b))

(define (product-itergers a b)
  (product identity a inc b))

(display (sum-intergers 1 5))
(newline)
(display (product-itergers 1 5))
(newline)  
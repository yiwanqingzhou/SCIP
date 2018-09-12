
(define (max x y) (if (> x y) x y))
(define (larger-sum a b c)
        (cond ((= (max a b) (max b c)) (+ (max a b) (max a c)))
              (else (+ (max a b) (max b c)))))

(display (larger-sum 3 5 6))

(newline)

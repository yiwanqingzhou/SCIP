(define (repeat f n)
  (if (= n 1)
      f
      (lambda (x)
          (f ((repeat f (- n 1)) x)))))


(define (repeat f n)
  (define (repeat-iter k result)
    (if (= k 1)
        result
        (repeat-iter (- k 1)
                      (lambda (x)
                              (f (result x))))))
  (repeat-iter n f))   

(define (compose f g)
  (lambda (x) (f (g x))))

(define (repeat f n)
  (if (= n 1)
      f
      (compose f (repeat f (- n 1)))))

(define (repeat f n)
  (define (repeat-iter k result)
    (if (= k 1)
        result
        (repeat-iter (- k 1)
                     (compose f result))))
  (repeat-iter n f))      

(define (square x)
  (* x x))

(display ((repeat square 2) 5))
(newline)
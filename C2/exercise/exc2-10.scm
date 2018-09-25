;;;2-7

(define (add-interval x y)
  (make-interval (+ (lower-bound x) 
                    (lower-bound y))
                 (+ (upper-bound x) 
                    (upper-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) 
                (lower-bound y)))
        (p2 (* (lower-bound x) 
                (upper-bound y)))
        (p3 (* (upper-bound x) 
                (lower-bound y)))
        (p4 (* (upper-bound x) 
                (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                    (max p1 p2 p3 p4))))                    
                  
(define (div-interval x y)
  (mul-interval x
      (make-interval
          (/ 1.0 (upper-bound y))
          (/ 1.0 (lower-bound y)))))

          
(define (make-interval a b)
  (cons a b))
  
(define (upper-bound interval)
  (max (car interval) (cdr interval)))

(define (lower-bound interval)
  (min (car interval) (cdr interval))) 


;;;2-8

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y) )))

(define (print-interval interval)
  (display "[")
  (display (lower-bound interval))
  (display " , ")
  (display (upper-bound interval))
  (display "]")
  (newline))                 


;;;2-9
(define (width-interval interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))


;;;2-10
(define (div-interval x y)
  (if (< (* (upper-bound y) (lower-bound y)) 0)
      (error "Division error (interval spans 0)" y)
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
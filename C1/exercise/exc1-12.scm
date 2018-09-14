;Pascal’s triangle
;recursive process

(define (Pascal row column)
    (cond ((= column 1) 1)
          ((= column row) 1)
          ((or (= row 1) (= row 2)) 1)
          (else (+ (Pascal (- row 1) column) 
                   (Pascal (- row 1) (- column 1))))))

(display (Pascal 5 1))
(newline)

(display (Pascal 5 2))
(newline)

(display (Pascal 5 3))
(newline)

(display (Pascal 5 3))
(newline)

(display (Pascal 5 5))
(newline)
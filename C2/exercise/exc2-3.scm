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


(define (perimeter r)
  (let ((length (length-of-rectangle))
         width (width-of-rectangle))
    (* (+ length width) 2)))

(define (area rectangle)
  (let ((length (length-of-rectangle))
         width (width-of-rectangle))
    (* length width)))

; (define (length-of-rectangle r)
;   (car r))

; (define (width-of-rectangle r)
;   (cdr r))

; (define (make-rectangle length width)
;   (cons length width))

(define (length-of-rectangle r)
  (let ((transversae (transversae-of-rectangle r)))
    (abs (- (x-point (end-point transversae)) 
            (x-point (start-point transversae))))))

(define (width-of-rectangle r)
  (let ((vertical (vertical-of-rectangle r)))
    (abs (- (y-point (end-point vertical))
            (y-point (start-point vertical))))))

(define (make-rectangle transversae vertical)
  (cons transversae vertical))

(define (transversae-of-rectangle r)
  (car r))

(define (vertical-of-rectangle r)
  (cdr r))
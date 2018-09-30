# 2.1 Introduction to Data Abstaction 数据抽象导引

## 2.1.1

### Exc 2-1
```scheme
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
```

## 2.1.2

### Exc 2-2
```scheme
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

(define (midpoint-segment s)
  (let ((start (start-segment s))
        (end (end-segment s)))
    (make-point 
        (/ (+ (x-point start) (x-point end)) 2)
        (/ (+ (y-point start) (y-point end)) 2))))

(define (print-point p)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")")
  (newline))

(define ss (make-point 1 -2))
(define se (make-point 5 6))
(define s (make-segment ss se))
(print-point (midpoint-segment s))
```

### Exc 2-3
```scheme
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
```

## 2.1.3

### Exc 2-4
```scheme
(define (cons x y)
    (lambda (m)
        (m x y)))

(define (car z)
    (z (lambda (p q) p)))

;(car (cons 1 2))
;(car (lambda (m) (m 1 2)))
;( (lambda (m) (m 1 2)  (lambda (p q) p) )
;( (lambda (p q) p) 1 2)
;1

(define (cdr z)
  (z (lambda (p q) q)))
```

### Exc 2-5
```scheme
;;2^a * 3^b
;;

(define (cons a b)
  (* (expt 2 a)
     (expt 3 b)))

(define (log-x n x result)
  (if (= (remainder n x) 0)
      (log-x (/ n x) x (+ result 1))
      result))

(define (car x)
  (log-x x 2 0))

(define (cdr x)
  (log-x x 3 0))


(define aaa (cons 3 4))

(display (car aaa))
(newline)
(display (cdr aaa))
(newline)

```

### Exc 2-6
```scheme
;;
;;Church numerals
;;
(define zero (lambda (f) (lambda (x) x)))

(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

(display 
((zero 2) 1))
(newline)
```


## 2.1.4
### Exc 2-7
```scheme
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

(define (upper-bound interval)
  (min (car interval) (cdr interval)))    
```

### Exc 2-8
```scheme
(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
                 (- (upper-bound x) (lower-bound y) )))

(define (print-intervel interval)
  (display "[")
  (display (lower-bound interval))
  (display " , ")
  (display (upper-bound interval))
  (display "]")
  (newline))                 
```

### Exc 2-9
```scheme
(define (width-interval interval)
  (/ (- (upper-bound interval) (lower-bound interval)) 2))



(define p1 (make-interval 1 8))
(print-interval p1)
(display (width-interval p1))
(newline)

(define p2 (make-interval 3 6))
(print-interval p2)
(display (width-interval p2))
(newline)

(display "add: ")
(display (width-interval (add-interval p1 p2)))
(newline)

(display "sub: ")
(display (width-interval (sub-interval p1 p2)))
(newline)

(display "mul: ")
(display (width-interval (mul-interval p1 p2)))
(newline)

(display "div: ")
(display (width-interval (div-interval p1 p2)))
(newline)
```

### Exc 2-10
```scheme
(define (div-interval x y)
  (if (< (* (upper-bound y) (lower-bound y)) 0)
      (error "Division error (interval spans 0)" y)
      (mul-interval x
                    (make-interval (/ 1.0 (upper-bound y))
                                   (/ 1.0 (lower-bound y))))))
```

### Exc 2-11


### Exc 2-12
```scheme
(define (make-center-percent c p)
  (make-interval (- c (/ (* c p) 100)) (+ c (/ (* c p) 100))))

(define (make-center-percent c p)
  (let ((width (/ (* c p) 100)))
    (make-interval (- c width) (+ c width))))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (percent i)
  (let ((c (center i))
        (l (lower-bound i)))
      (* (/ (- c l) c) 100)))

(define i (make-center-percent 10 50))
(print-interval i)
(display (upper-bound i))
(newline)
(display (lower-bound i))
(newline)
(display (center i))
(newline)
(display (percent i))
(newline)
```

### Exc 2-13


### Exc 2-14
```scheme
(define A (make-center-percent 2 10))
(define B (make-center-percent 2 10))

(print-interval (div-interval A B))
(print-interval-percent (div-interval A B))

(newline)

(print-interval (div-interval A A))
(print-interval-percent (div-interval A A))
```

### Exc 2-15


### Exc 2-16

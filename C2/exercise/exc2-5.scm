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

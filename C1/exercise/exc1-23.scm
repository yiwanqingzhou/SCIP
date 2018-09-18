; (define greet "hello")
; (display greet)
; (newline)

; (define greet "hello world")
; (display greet)
; (newline)
(define (square x) (* x x))

(define (smallest-divisor n)
    (find-divisor n 2))

; (define (find-divisor n test-divisor)
;     (cond ((> (square test-divisor) n) 
;         n)
;         ((divides? test-divisor n) 
;         test-divisor)
;         (else (find-divisor 
;             n 
;             (+ test-divisor 1)))))

(define (divides? a b)
    (= (remainder b a) 0))

(define (prime? n)
    (= n (smallest-divisor n)))

(define (next n)
    (if (= n 2) 3 (+ n 2)))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) 
        n)
        ((divides? test-divisor n) 
        test-divisor)
        (else (find-divisor 
            n 
            (next test-divisor)))))

(display (prime? 67))
(newline)
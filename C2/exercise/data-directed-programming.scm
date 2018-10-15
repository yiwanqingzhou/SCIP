
;;; tagged
(define (attach-tag type-tag contents)
(cons type-tag contents))

(define (type-tag datum)
(if (pair? datum)
    (car datum)
    (error "Bad tagged datum: TYPE-TAG" datum)))

(define (contents datum)
(if (pair? datum)
    (cdr datum)
    (error "Bad tagged datum: CONTENTS" datum)))
    


;;; apply-generic
(define (apply-generic op . args)                   ; 参数个数可能不同
    (let ((type-tags (map type-tag args)))
        (let ((proc (get op type-tags)))
            (if proc
                (apply proc (map contents args))    ; 找到了对应的过程
                (error "No method for these types -- APPLY-GENERIC"
                    (list op type-tags))))))


;;; 通用型选择函数
(define (real-part z)
    (apply-generic 'real-part z))
(define (imag-part z)
    (apply-generic 'imag-part z))
(define (magnitude z)
    (apply-generic 'magnitude z))
(define (angle z)
    (apply-generic 'angle z))
    

;;; 构造函数
(define (make-form-real-imag x y)
    ((get 'make-form-real-imag 'rectangular ) x y))
(define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar ) r a))





;;; 基于直角坐标的版本

(define (install-rectangular-package)

;; internal procedures
(define (real-part z) (car z))
(define (imag-part z) (cdr z))
(define (make-form-real-imag x y)
    (cons x y))
(define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
(define (angle z)
    (atan (imag-part z) (real-part z)))
(define (make-from-mag-ang r a)
    (cons (* r (cos a)) ((* r (sin a)))))  ; 先把ra换算成xy再cons


;; interface to the rest of the system
(define (tag x) (attach-tag 'rectangular x))
(put 'real-part '(rectangular) real-part)
(put 'imag-part '(rectangular) imag-part)
(put 'magnitude '(rectangular) magnitude)
(put 'angle '(rectangular) angle)

(put 'make-form-real-imag 'rectangular
    (lambda (x y) (tag (make-form-real-imag x y))))  ; 组合时需要带tag
(put 'make-from-mag-ang 'rectangular
    (lambda (r a) (tag (make-from-mag-ang r a))))

'done
)




;;; 基于极坐标的版本

(define (install-polar-package)

;; internal procedures
(define (magnitude z) (car z))
(define (angle z) (cdr z))
(define (make-from-mag-ang r a)
    (cons r a))
(define (real-part z)
    (* (magnitude z) (cos (angle z))))
(define (imag-part z)
    (* (magnitude z) (sin (angle z))))
(define (make-form-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))      ; 先把xy换算成ra再cons
          (atan y x)))

;; interface to the rest of the system
(define (tag x) (attach-tag 'polar x))
(put 'real-part '(polar) real-part)
(put 'imag-part '(polar) imag-part)
(put 'magnitude '(polar) magnitude)
(put 'angle '(polar) angle)

(put 'make-form-real-imag 'polar
    (lambda (x y) 
        (tag (make-form-real-imag x y))))
(put 'make-from-mag-ang 'polar
    (lambda (r a)
        (tag (make-from-mag-ang r a))))        

'done
)

(define (square x) (* x x))
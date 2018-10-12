
; ;;; 未排序
; (define (lookup given-key set-of-records)
;   (cond ((null? set-of-records) #f)
;         ((equal? given-key (key (car set-of-records)))
;             (car set-of-records))
;         (else (lookup given-key (cdr set-of-records)))))



; ;;; 二叉树
; (define (lookup given-key set-of-records)
;   (if (null? set-of-records)
;       #f
;       (let ((cur-key (key (entry set-of-records))))
;         (cond ((= given-key cur-key) (entry set-of-records))
;               ((< given-key cur-key)
;                   (lookup given-key (left-branch set-of-records)))
;               ((> given-key cur-key)
;                   (lookup given-key (right-branch set-of-records)))))))


(define cookie-set (make-parameter 123))
(display (cookie-set))
(newline)



(define (try-fun x)
     (parameterize ((cookie-set x))
                (cookie-set)))

(define (try-fun-1 x)
    (let ((cookie-set (try-fun x)))
        (display cookie-set)))

(try-fun-1 456)
(newline)

(display (cookie-set))
(newline)
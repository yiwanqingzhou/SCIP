; (define operation-table (make-table))
; (define get (operation-table 'lookup-proc))
; (define put (operation-table 'insert-proc!))


; (define global-array '())

; (define (make-entry k v) (list k v))
; (define (key entry) (car entry))
; (define (value entry) (cadr entry))

; (define (put op type item)
;   (define (put-helper k array)
;     (cond ((null? array) (list(make-entry k item)))
;           ((equal? (key (car array)) k) array)
;           (else (cons (car array) (put-helper k (cdr array))))))
;   (set! global-array (put-helper (list op type) global-array)))

; (define (get op type)
;   (define (get-helper k array)
;     (cond ((null? array) #f)
;           ((equal? (key (car array)) k) (value (car array)))
;           (else (get-helper k (cdr array)))))
;   (get-helper (list op type) global-array))

(define false #f)

(define (make-table)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (cdr record)
                  false))
            false)))
    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key-2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key-2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key-1
                                  (cons key-2 value))
                            (cdr local-table)))))
      'ok)    
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
            ((eq? m 'insert-proc!) insert!)
            (else (error "Unknown operation - TABLE" m))))
    dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
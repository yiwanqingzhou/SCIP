# 2.3 Symbolic Data

## 2.3.1

### Exc 2-53
```scheme
(list 'a 'b 'c )

(list (list 'george ))

(cdr '((x1 x2) (yq y2)))

(cadr '((x1 x2) (yq y2)))

(pair? (car '(a short list)))

(memq 'red '((red shoes) (blue socks)))

(memq 'red '(red shoes blue socks))
```


### Exc 2-54
```scheme
(define (equal? a b)
    (cond ((and (pair? a) (pair? b))
                (and (equal? (car a) (car b))
                    (equal? (cdr a) (cdr b))))
          ((or (pair? a) (pair? b)) #f)
          (else (eq? a b))))
```


### Exc 2-55
```scheme

```
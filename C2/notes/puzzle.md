## 2.1

- exc 2.6
- exc 2.14
- exc 2.16

## 2.2
```scheme
(define a (list 1 (list 2 (list 3 4))))

(define b (cons 1 (cons 2 (cons 3 4))))

(define c (cons 1 (cons 2 (cons 3 (cons 4 '())))))

(define d (cons 1 (cons 2 (list 3 4))))
```


```scheme
(define nil '())

(define x (list 1 2))

(cons 1 nil)
(cons nil 1)
(list 1 nil)
(list nil 1)
(append nil 1)
(append 1 nil)

(cons x nil)
(cons nil x)
(list x nil)
(list nil x)
(append x nil)
(append nil x)
```


- exc 2.27
- exc 2.28
- exc 2.32

## 2.3
- exc 2.58  b)
- exc 2.70 大小写字符转换 以非字符串为参数

## 2.4
- map 和 apply 的区别
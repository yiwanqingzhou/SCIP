## 2.3 Symbolic Data 符号数据
All the compound data objects we have used so far were constructed ultimately from numbers. In this section we extend the representational capability of our language by introducing the ability to work with arbitrary symbols as data.


### 2.3.1 Quotation 引号

```scheme
(define a 1)
(define b 2)

(list a b)
(1 2)

(list 'a 'b)
(a b)

(list 'a b)
(a 2)


(car '(a b c))
a

(cdr '(a b c))
(b c)
```

<br>

>**eq?**
>
>```eq?``` 过程以两个符号为参数，检查它们是否为同样的符号。
>
>利用 ```eq?``` 可以实现一个成为 ```memq``` 的有用过程，它以一个符号和一个表为参数。如果这个符号不包含在这个表里（也就是说，它与表里的任何项目都不 ```eq?```），```memq``` 就返回假；否则就返回该表中这个符号第一次出现开始的那个子表。

```scheme
(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))
```

<br>

### 2.3.2 Example: Symbolic Differentiation 符号求导

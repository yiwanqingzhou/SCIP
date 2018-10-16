## 2.5 带有通用型操作的系统
Systems with Generic Operations



<br>

### 2.5.1 通用型算术运算 Generic Arithmetic Operations

定义通用型算术过程：
```scheme
(define (add x y) (apply-generic 'add x y))
(define (sub x y) (apply-generic 'sub x y))
(define (mul x y) (apply-generic 'mul x y))
(define (div x y) (apply-generic 'div x y))
```

完整过程在 ```generic-arithmetic-operations.scm```中。

关于复数的过程：
```scheme
(define (install-complex-package)
    ;; imported proceduers from rectangular and polar packages
    (define (make-from-real-imag x y)
        ((get 'make-from-real-imag 'rectangular ) x y))
    (define (make-from-mag-ang x y)
        ((get 'make-from-mag-ang 'polar ) x y))

    ;; internal procedures
    (define (add-complex z1 z2)
        (make-from-real-imag (+ (real-part z1) (real-part z2))
                             (+ (imag-part z2) (imag-part z2))))
    (define (sub-complex z1 z2)
        (make-from-real-imag (- (real-part z1) (real-part z2))
                             (- (imag-part z1) (imag-part z2))))
    (define (mul-complex z1 z2)
        (make-from-mag-ang (* (magnitude z1) (magnitude z2))
                           (+ (angle z1) (angle z2))))
    (define (div-complex z1 z2)
        (make-from-mag-ang (/ (magnitude z1) (magnitude z2))
                           (- (angle z1) (angle z2))))

    ;; interface
    (define (tag x) (attch-tag 'complex x))
    (put 'add '(complex complex)
        (lambda (z1 z2) (tag (add-complex z1 z2))))
    (put 'sub '(complex complex)
        (lambda (z1 z2) (tag (sub-complex z1 z2))))
    (put 'mul '(complex complex)
        (lambda (z1 z2) (tag (mul-complex z1 z2))))
    (put 'div '(complex complex)
        (lambda (z1 z2) (tag (div-complex z1 z2))))
    (put 'make-from-real-imag 'complex
        (lambda (x y) (tag make-from-real-imag x y)))
    (put 'make-from-mag-ang 'complex
        (lambda (r a) (tag (make-from-mag-ang r a))))

'done )

(define (make-complex-from-real-imag x y)
    ((get 'make-from-real-imag 'complex ) x y))
(define (make-complex-from-mag-ang x y)
    ((get 'make-from-mag-ang 'complex ) x y))
```

在复数包之外的程序可以从实部和虚部出发构造复数，也可以从模和幅角出发。
请注意这里如何将原先定义在直角坐标和极坐标包里的集成过程导出，放入复数包中，又如何从这里导出送给外面的世界。

这里描述的是一个具有两层标志的系统。外层标志（complex）用于将这个数引导到复数包，一旦进入复数包，下一个标志（rectangular)就会引导这个数进入直角坐标表示包。

在一个大型的复杂系统里可能又许多层次，每层与下一层次之间的连接都借助于一些通用型操作。当一个数据对象被“向下”传输时，用于引导它进入适当程序包的最外层标志被剥除（通过使用contents），下一层的标志（如果有的话）变成可见的，并将被用于下一次分派。


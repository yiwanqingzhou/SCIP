## 2.5 带有通用型操作的系统
Systems with Generic Operations



<br>

### 2.5.1 通用型算术运算
Generic Arithmetic Operations

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

这里描述的是一个**具有两层标志**的系统。外层标志（complex）用于将这个数引导到复数包，一旦进入复数包，下一个标志（rectangular)就会引导这个数进入直角坐标表示包。

在一个大型的复杂系统里可能又许多层次，每层与下一层次之间的连接都借助于一些通用型操作。当一个数据对象被“向下”传输时，用于引导它进入适当程序包的最外层标志被剥除（通过使用contents），下一层的标志（如果有的话）变成可见的，并将被用于下一次分派。


<br>

### 2.5.2 不同类型数据的组合 Combining Data of Different Types



>#### 强制
>不同的数据类型通常都不是完全相互无关的，常常存在一些方式，是我们可以把一种类型的对象看作另一种类型的对象。这种过程就称为强制。
>
>举例来说，如果现在需要做常规数值与复数的混合算术，我们就可以将常规数值看成是虚部为0的复数。这样就把问题转换为两个复数的运算问题，可以由复数包以正常的方式处理了。

<br>

```scheme
(define (scheme-number->complex n)
    (make-complex-from-real-imag (contents n) 0))

(put-coercion 'scheme-number 'complex scheme-number->complex)
``` 

<br>

一旦将上述转换表格装配好，我们就可以修改 ```apply-generic``` 过程，得到一种处理强制的统一方法。在要求应用一个操作时，我们将首先检查是否存在针对实际参数类型的操作定义，就像前面一样。如果存在，那么就将任务分派到由操作-类型表格中找出的相应过程去，否则就去做强制。    
考虑两个参数的情况：检查强制表格，查看第一个参数类型的对象能否转换到第二个参数的类型，如果可以就对第一个参数做强制转换后再进行运算。如果第一个参数类型不能强制到第二个类型，那么就看看第二个参数的类型能否转换到第一个参数的类型。最后，如果不存在从一个类型到另一类型的强制，那么就只能放弃了。

```scheme
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (if (= (length args) 2)
              (let ((type1 (car type-tags))
                    (type2 (cadr type-tags))
                    (a1 (car args))
                    (a2 (cadr args)))
                (let ((t1->t2 (get-coercion type1 type2))
                      (t2->t1 (get-coercion type2 type1)))
                  (cond (t1->t2
                         (apply-generic op (t1->t2 a1) a2))
                        (t2->t1
                         (apply-generic op a1 (t2->t1 a2)))
                        (else
                         (error "No method for these types"
                                    (list op type-tags))))))
              (error "No method for these types"
                        (list op type-tags)))))))
```

<br>

#### 类型的层次结构 P135

- 类型塔
    - 超类型
    - 子类型
    - raise过程

<br>

#### 层次结构的不足 P136

一个类型可能有多于一个子类型，一个类型也可能有多于一个超类型。

<br>
<br>


### 2.5.3 实例：符号代数 Symbolic Algebra



<br>

#### 多项式算术

#### 项表的表示

#### 符号代数中类型的层次结构


# 1.3 Formulating Abstractions with Higher-Order Procedures
> Often the same programming pattern will be used with a number of different procedures. To express such patterns as concepts, we will need to construct procedures that can accept procedures as arguments or return procedures as values.
> 
> Procedures that manipulate procedures are called *higher-order procedures*. 
> 
> This section shows how higher-order procedures can serve as powerful abstraction mechanisms, vastly increasing the expressive power of our language.

<br>

### 1.3.1 过程作为参数 Procedures as Arguments

- 计算从a到b的各整数之和

```scheme
(define (sum-integers a b)
  (if (> a b) 
      0 
      (+ a (sum-integers (+ a 1) b))))
```

- 计算从a到b的各整数的立方之和

```scheme
(define (sum-cubes a b)
  (if (> a b) 
      0 
      (+ (cube a) 
         (sum-cubes (+ a 1) b))))
```

- 计算下面的序列之和
$$ \frac{1}{1*3} + \frac{1}{5*7} + \frac{1}{9*11} + … $$

```scheme
(define (pi-sum a b)
  (if (> a b)
      0
      (+ (/ 1.0 (* a (+ a 2))) 
         (pi-sum (+ a 4) b))))
```
<br>

可以发现上述三个过程非常相似，共享这一种公共的基础模式。
$$  \sum_{n=a}^{b} f(n) = f(a) + … + f(b) $$

```scheme
(define (<name> a b)
  (if (> a b)
      0
      (+ (<term> a)
         (<name> (<next> a) b))))
```


把上面的“空位”翻译成形式参数，即成为**程序模板**：
```scheme
(define (sun term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))
```

<br>

在这个程序模板基础上  

重写*计算从a到b的各整数之和*:
```scheme
(define (inc n) (+ n 1))
(define (identity x) x)

(define (sum-integers a b)
  (sum identity a inc b))
```

重写*计算从a到b的各整数的立方之和*:
```scheme
(define (inc n) (+ n 1))
(define (cube x) (* x x x))

(define (sum-cubes a b)
  (sum cube a inc b))

```

重写*pi-sum*:
```scheme
(define (pi-sum a b)
  (define (pi-next x) 
    (+ x 4))
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (sum pi-term a pi-next b))
```
<br>

一旦有了sum，我们就能用它作为基本构件，取形式化其他概念。

例如，求出函数$f$在范围$a$和$b$之间的定积分的近似值，可以用下面公式去完成

$$ \int_{a}^{b}f=[\ f(a+\frac{dx}{2})+f(a+dx+\frac{dx}{2})+f(a+2dx+\frac{dx}{2})\ ]\ dx $$

我们可以将这个公式直接描述为一个过程：
```scheme
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) 
     dx))
```
<br>

### 1.3.2 用lambda构造过程

一般而言，lambda创建过程都方式与define相同，但不需要提供过程名字
```scheme
(lambda (⟨formal-parameters⟩) ⟨body⟩)

(lambda (x) (+ x 4))

(lambda                     (x)     (+   x     4))
    |                        |       |   |     |
the procedure of an argument x that adds x and 4


((lambda (x) (+ x 4)) 1)
> 5

```

<br>
<br>

 事实上
 ```scheme
 (define (plus4 x) (+ x 4))
```
等价于
```scheme
 (define plus4 (lambda (x) (+ x 4)))
```

<br>

**用let创建局部变量**

lambda的另一个应用是创建局部变量。

在一个过程里，除了使用那些已经约束为过程参数的变量外，我们常常还需要另外一些局部变量。

例如，

$$f(x,y) = x(1+xy)^2 + y(1-y) +(1+xy)(1-y)$$

可能就希望表述成
$$a = 1 + xy$$
$$b = 1 - y$$
$$f(x,y) = xa^2+yb+ab$$

程序：

```scheme
(define (f x y)
  (define (f-helper a b)
    (+ (* x (square a))
       (* y b)
       (* a b)))
  (f-helper (+ 1 (* x y)) 
            (- 1 y)))
```

用lambda：

```scheme
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a)) 
        (* y b) 
        (* a b)))
   (+ 1 (* x y))
   (- 1 y)))
```

用let：

```scheme
(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))
```

<br>

**let的定义：**

```scheme
(let ((⟨var₁⟩ ⟨exp₁⟩)
      (⟨var₂⟩ ⟨exp₂⟩)
      …
      (⟨varₙ⟩ ⟨expₙ⟩))
  ⟨body⟩)


((lambda (⟨var₁⟩ … ⟨varₙ⟩)
   ⟨body⟩)
 ⟨exp₁⟩
 …
 ⟨expₙ⟩)
```

<br>

**let定义的变量的值是在let之外计算的**

假如x的值为2，那么在以下let中，x = 3，y = 4：

```scheme
(let ((x 3)
      (y (+ x 2)))
  (* x y))

> 12
```


<br>

### 1.3.3 过程作为一般性的方法
- 区间折半法寻找方程的根
  

- 函数不动点
  
> 满足方程 $f(x) = x$，那么称x为函数$f$的不动点。
>
> 对于某些函数，通过从某个猜测开始，反复地应用$f$
> $$ f(x),\ f(f(x)),\ f(f(f(x)))，……$$ 
> 直到值的变化不大时，就可以找到它的一个不动点。

```scheme
(define tolerance 0.0001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
          next
          (try next))))
  (try first-guess))
```
用这个方法求出方程 $y = sin y + cos y$ 的一个解：
```scheme
(fixed-point (lambda (y) (+ (sin y) (cos y)))
             0.1)
```

<br>

计算平方根：

$$ y = \sqrt{x}$$
$$ y^2 = x$$
$$ y = \frac{x}{y}$$

可以化为 $y = \frac{x}{y}$ 的不动点

```scheme
(define (sqrt x)
  (fixed-point (lambda (y) (/ x y))
                0.1))
```
但是这种方法搜寻不动点并不收敛，因为函数的特别，猜测的结果总是不断重复，在答案的两边震荡。
我们可以将猜测的值改为 y 和 x/y 的平均值。

```scheme
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
                0.1))
```

**查阅sqrt-contract.scm，对比1.1.7中的sqrt(x)与此版本的对比**

<br>

### 1.3.4 过程作为返回值

- 平均阻尼

求 $\sqrt{x}$ （$y\Rightarrow x/y$ 不动点）原程序（1.3.3）：
```scheme
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
                1.0))

```

将平均阻尼的思维抽象成average-damp，程序改为：
```scheme
(define (average-damp f)
    (lanbda(x) (average x (f x))))

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
                0.1))
```

推广为提取立方根的过程：
```scheme
(define (cube-root x)
  (fixed-point 
   (average-damp 
    (lambda (y) 
      (/ x (square y))))
   1.0))
```
<br>

- 牛顿法


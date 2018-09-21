# 2. Builing Abstactions with Data 构造数据抽象

## 2.1 Introduction to Data Abstaction 数据抽象导引
> The basic idea of data abstraction is to structure the programs that are to use compound data objects so that they operate on “abstract data.” That is, our programs should use data in such a way as to make no assumptions about the data that are not strictly necessary for performing the task at hand. At the same time, a “concrete” data representation is defined independent of the programs that use the data. The interface between these two parts of our system will be a set of procedures, called **selectors** and **constructors**, that implement the abstract data in terms of the concrete representation. To illustrate this technique, we will consider how to design a set of procedures for manipulating rational numbers.

<br>

### 2.1.1 实例：有理数（Rational Numbers）的算数运算
> 假定我们已经有了一种从分子和分母构造有理数的方法。  
> 并进一步假定，如果有了一个有理数，我们有一种方法取得（选出）它的分子和分母。  
> 现在再假定有关的构造函数和选择函数都可以作为过程使用：
> 
> ```(make-rat ⟨n⟩ ⟨d⟩)``` 返回一个有理数，其分子是整数⟨n⟩，分母是整数⟨d⟩
> 
> ```(numer ⟨x⟩)``` 返回有理数⟨x⟩的分子
> 
> ```(denom ⟨x⟩)``` 返回有理数⟨x⟩的分母
> 

<br>

**wishful thinking**

>我们还没有说有理数将如何表示，也没有说过程numer denom 和 make-rat 应如何实现。  
>然而，如果我们真的有了这三个过程，那么就可以根据下面关系去做有理数的加减乘除和相等判断了：

$$\frac{n_1}{d_1} + \frac{n_2}{d_2} = \frac{n_1d_2 + n_2d_1}{d_1d_2}$$
$$\frac{n_1}{d_1} - \frac{n_2}{d_2} = \frac{n_1d_2 - n_2d_1}{d_1d_2}$$
$$\frac{n_1}{d_1} \cdot \frac{n_2}{d_2} = \frac{n_1n_2}{d_1d_2}$$
$$\frac{n_1}{d_1}\  /\  \frac{n_2}{d_2} = \frac{n_1d_2}{d_1n_2}$$
$$\frac{n_1}{d_1} = \frac{n_2}{d_2} \quad 当且仅当 \quad n_1d_2 = n_2d_1$$

```scheme
(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
               (* (numer y) (denom x)))
            (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
            (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
            (* (denom x) (numer y))))

(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))
```

<br>

#### 序对
- cons
- car
- cdr

```scheme
(define x (cons 1 2))

(car x)
> 1

(cdr x)
> 2
```


**一个序对也是一个数据对象，可以像基本数据对象一样给它一个名字且操作它。进一步说，还可以用cons去构造以序对作为元素的序对，并继续这样做下去**
```scheme
(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))

(car (car z))
> 1

(car (cdr z))
> 3
```

<br>

那么，有理数的表示也很容易了：
```scheme
(define (make-rat n d)
  (cons n d))

(define (numer x)
  (car x))

(define (denom x)
  (cdr x))
```

**考虑约分和正负有理数**
```scheme
(define (gcd a b)
(if (= (remainder a b) 0)
    b
    (gcd b (remainder a b))))

(define (fix-abs x)
  (if (or (and (< (car x) 0) (< (cdr x) 0)) 
          (and (> (car x) 0) (< (cdr x) 0)))
      (cons (- (car x)) (- (cdr x)))
      x))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (fix-abs (cons (/ n g) (/ d g)))))


(define (numer x)
  (car x))
  
(define (denom x)
  (cdr x))
```

<br>

### 2.1.2 抽象屏蔽












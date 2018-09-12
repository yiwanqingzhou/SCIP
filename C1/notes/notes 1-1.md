# 1.1 The Elements of Programming

### 1. 前缀运算
```scheme
(+ 137 349)
486

(- 1000 334)
666

(+ 21 35 12 7)
75

(+ (* 3 5) (- 10 6))
19

```


### 2. define 定义
#### 2.1 定义变量
```scheme
(define size 2)

size
2

(* 5 size)
10
```

#### 2.2 定义方法
```scheme
(define (square x) (* x x))
```

```scheme
(define (square x)    (*       x       x))
  |      |      |      |       |       |
 To square something, multiply it by itself.
```

```scheme
(define (⟨name⟩ ⟨formal parameters⟩) ⟨body⟩)
```
 
```scheme
(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)
136
```

### 3. 正则序 & 应用序
##### 正则序：将式子完全展开后再计算  
##### 应用序：直到subexpression实际需要时才计算它的值

```scheme
(define (square x) (* x x))

(square (* 5 2))
```
正则序：
``` scheme
	(* (* 5 2) (* 5 2))
```
会发生重复求值，降低效率  
在超过可以采用替换方式模拟都过程范围之后，正则序都处理将变得更复杂得多。

应用序： 先求出
```scheme
		(* 5 2)
```
再计算square

##### Lips采用应用序求值  


### 4. cond条件
```scheme
    (cond (⟨p₁⟩ ⟨e₁⟩)
          (⟨p₂⟩ ⟨e₂⟩)
          …
          (⟨pₙ⟩ ⟨eₙ⟩))
```

```scheme
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (-x))))
```

### 5. else 否则

```scheme
(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))
```

### 6. if
```scheme
	(if ⟨predicate⟩ ⟨consequent⟩ ⟨alternative⟩)
```

```scheme
(define (abs x)
  (if (< x 0)
      (- x)
      x))
```

### 7. and & or & not

```scheme
	(and ⟨e₁⟩ … ⟨eₙ⟩)

	(or ⟨e₁⟩ … ⟨eₙ⟩)

	(not ⟨e⟩)
```

```scheme
(and (> x 5) (< x 10))

(define (>= x y) 
  (or (> x y) (= x y)))

```

### 8. 牛顿法求平方根
##### 展示了如何不用任何都迭代结构（循环）来实现迭代

```scheme
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x) x)))
      
      
(define (improve guess x)
  (average guess (/ x guess)))
  
  
(define (average x y) 
  (/ (+ x y) 2))


(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))


(define (sqrt x)
  (sqrt-iter 1.0 x))

```


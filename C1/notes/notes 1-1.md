# 1.1 The Elements of Programming

## 1. 前缀运算
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


## 2. 命名 define 
### 2.1 命名变量
```scheme
(define size 2)

size
2

(* 5 size)
10
```

### 2.2 命名过程
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

## 3. 正则序 & 应用序
##### 正则序：将式子完全展开后再计算  
##### 应用序：直到subexpression实际需要时才计算它的值

> *normal-order evaluation*: fully expand and then reduce   
> *applicative-order evaluation*: evaluate the arguments and then apply  
> 
> **Lisp uses applicative-order evaluation**

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


## 4. 条件判断

### 4.1 cond
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

### 4.2 else 

```scheme
(define (abs x)
  (cond ((< x 0) (- x))
        (else x)))
```

### 4.3 if
```scheme
	(if ⟨predicate⟩ ⟨consequent⟩ ⟨alternative⟩)
```

```scheme
(define (abs x)
  (if (< x 0)
      (- x)
      x))
```

### 4.4 and & or & not

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

## 5. 牛顿法求平方根 -- 递归

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

##### 优化 good-enough? 方法
> An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test.

```scheme

(define (sqrt x) (sqrt-iter 0.5 1.0 x))

(define (sqrt-iter lassguess guess x)
  (if (good-enough? lassguess guess) guess
      (sqrt-iter guess (improve guess x) x)))

(define (good-enough? lassguess guess)
  (< (abs (- lassguess guess) ) 0.01))

```

## 6. 抽象黑盒 Procedures as Black-Box Abstractions
- 局部变量 Local names
  
- 内部定义和块结构 Internal definitions and block structure
  - 可以将子过程局部化 
  - 由于x在sqrt都定义中是受约束都，而子过程也都定义在sqrt中，也就是说都在x都定义域里。所以x不再需要作为形参在各过程中传递，可以直接作为内部参数直接调用

  ```scheme
  (define (sqrt x)
    (define (good-enough? guess)
      (< (abs (- (square guess) x)) 0.001))
    (define (sqrt-iter guess)
      (if (good-enough? guess)
          guess
          (sqrt-iter (improve guess))))        
    (define (improve guess)
      (average guess (/ x guess)))      
    (sqrt-iter 1.0))
  ```


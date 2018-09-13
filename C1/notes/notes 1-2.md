# 1.2 Procedures and the Processes They Generate


## 1.2.1 线性递归和迭代 Linear Recursion and Iteration


#### n阶乘的实现

- 递归计算方式 Recursion

```scheme
(define (factorial n)
   (if (= n 1)
       1
       (* n (factorial (- n 1)))))
```

- 迭代计算方式 Iteration

```scheme
(define (factorial n)
    (fact-iter 1 1 n))

(define (fact-iter product counter max-counter)
    (if (> counter max-counter)
        product
        (fact-iter (* product counter) (+ counter 1) max-counter)))
```
<br />

 **递归计算过程 & 递归过程**  
 recursive process & recursive procedure
> 
> 当我们说一个过程是递归 (recursive procedure) 的时候，论述的是一个语法形式上的事实，说明这个过程的定义中（直接或间接地）引用了该过程本身。
>
>在说某一计算过程既有某种模式（如线性递归）时，我们说的是这一计算过程的进展方式，而不是相应过程书写上的语法形式。

<br />

**尾递归**
>Scheme will execute an iterative process in constant space, even if the iterative process is described by a recursive procedure. An implementation with this property is called **tail-recursive**. 

<br />

**递归和迭代方式的加法**

```scheme
(define (+ a b)
  (if (= a 0) 
      b 
      (inc (+ (dec a) b))))
```

```scheme
(define (+ a b)
  (if (= a 0) 
      b 
      (+ (dec a) (inc b))))
```


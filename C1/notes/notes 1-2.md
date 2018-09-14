# 1.2 Procedures and the Processes They Generate


### 1.2.1 线性递归和迭代 Linear Recursion and Iteration


**n阶乘的实现**

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
 
当我们说一个过程是递归 (recursive procedure) 的时候，论述的是一个语法形式上的事实，说明这个过程的定义中（直接或间接地）引用了该过程本身。  
在说某一计算过程既有某种模式（如线性递归）时，我们说的是这一计算过程的进展方式，而不是相应过程书写上的语法形式。

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
<br>

### 1.2.2 树形递归 Tree Recursion

**斐波那契数序列**
- 递归计算方式

对于Fibonacci numbers：  
0, 1, 1, 2, 3, 5, 8, 13, 21, ….

我们马上可以将它的定义翻译成一个简单的递归程序：

```scheme
(define (fib n)
    (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                    (fib (- n 2))))))
```
此过程作为典型的树形递归具有教育意义，但它却是一种很糟糕都计算方法，因为它做了太多都冗余运算。
 
 <br />
   
- 迭代计算方式

我们可以规划出一种计算斐波那契数的迭代计算过程，其基本想法就是用一对整数a和b，将它们分别初始化为Fib(1)=1和Fib(0)=0，而后反复地同时使用下面的变换规则：  

    a : a+b  
    b : a

```scheme
(define (fib n) 
(fib-iter 1 0 n))

(define (fib-iter a b count)
(if (= count 0)
    b
    (fib-iter (+ a b) a (- count 1))))
```

> 虽然第一个fib过程远比第二个低效，但它却更简单易读。  
> 当我们考虑的是对**层次结构性的数据**进行操作，而不是对数字操作时，我们会发现树递归是一种自然而强大都工具。

<br>

**实例：换零钱**
> How many different ways can we make change of $1.00, given half-dollars, quarters, dimes, nickels, and pennies? More generally, can we write a procedure to compute the number of ways to change any given amount of money?
> 
> 将1美元换成半美元，四分之一美元，10美分，5美分，1美分的硬币，一共有多少中不同的方式？
> 
<br>
采用递归过程，此问题有一种很简单的解法。假设我们所考虑的可用硬币类型种类排了某种顺序，就有下面的关系：  

将总数为a的现金换成n种硬币的不同方式的数目=
（d为第一种硬币都币值）
- 将现金a换成除了d之外的(n-1)种硬币的不同方式数目 +
- 将现金a-d换成所有硬币都不同方式数目

边界条件：
- a = 0，1
- a < 0，0
- n = 0，0

```scheme
(define (count-change amount)
  (cc amount 5))

(define (cc amount kinds-of-coins)
  (cond ((= amount 0) 1)
        ((or (< amount 0) 
             (= kinds-of-coins 0)) 
         0)
        (else 
         (+ (cc amount (- kinds-of-coins 1))
            (cc (- amount (first-denomination 
                           kinds-of-coins))
                kinds-of-coins)))))

(define (first-denomination kinds-of-coins)
  (cond ((= kinds-of-coins 1) 1)
        ((= kinds-of-coins 2) 5)
        ((= kinds-of-coins 3) 10)
        ((= kinds-of-coins 4) 25)
        ((= kinds-of-coins 5) 50)))
```

此程序与第一个fib过程的计算过程类似，都是产生出一个树形的递归计算过程。



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

<br>

### 1.2.3 增长的阶 Orders of Growth

> The previous examples illustrate that processes can differ considerably in the rates at which they consume computational resources. One convenient way to describe this difference is to use the notion of order of growth to obtain a gross measure of the resources required by a process as the inputs become larger.

<br />

### 1.2.4 求幂 Exponentiation

**计算b^n**

- 直接翻译定义成递归过程：

```scheme
(define (expt b n)
  (if (= n 0) 
      1 
      (* b (expt b (- n 1)))))
```
<br>

- 线性迭代方式：
```scheme
(define (expt b n) 
(expt-iter b n 1))

(define (expt-iter b counter product)
    (if (= counter 0)
        product
        (expt-iter b
                    (- counter 1)
                    (* b product))))
```
<br>

- 对于指数为2都乘幂优化:
  
    b^n = (b^(n/2))^2  --- n is even  
    b^n = b * b^(n-1)  --- n is odd

```scheme
(define (fast-expt b n)
  (cond ((= n 0) 
         1)
        ((even? n) 
         (square (fast-expt b (/ n 2))))
        (else 
         (* b (fast-expt b (- n 1))))))

(define (even? n)
  (= (remainder n 2) 0))
```

*remainder: 求余*

<br>

### 1.2.5 最大公约数 Greatest Common Divisors

**欧几里德算法：**
>The idea of the algorithm is based on the observation that, if r is the remainder when a is divided by b, then the common divisors of a and b are precisely the same as the common divisors of b and r. Thus, we can use the equation  
>```
>GCD(a,b) = GCD(b,r)
>```
>to successively reduce the problem of computing a GCD to the problem of computing the GCD of smaller and smaller pairs of integers.

```
GCD(206,40) = GCD(40,6)
            = GCD(6,4)
            = GCD(4,2)
            = GCD(2,0) = 2
```

```scheme
(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))
```

**Lamé’s 定理：**
>如果欧几里德算法需要k步计算出一对整数的GCD，那么这对数中较小的那个数必然大于或者等于第k个斐波那契数。

<br>

## 1.2.6 实例：素数检测 Testing for Primality

- 寻找因子 Searching for divisors  

  用从2开始的连续整数去检查它们能否整除n，
  当且仅当n是自己都最小因子时，n为质数。  
  此方法具有O(sqrt(n))的增长阶。

    ```scheme
    (define (smallest-divisor n)
    (find-divisor n 2))

    (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) 
            n)
            ((divides? test-divisor n) 
            test-divisor)
            (else (find-divisor 
                n 
                (+ test-divisor 1)))))

    (define (divides? a b)
    (= (remainder b a) 0))

    (define (prime? n)
    (= n (smallest-divisor n)))
    ```

- 费马检查 The Fermat test
  
  > 费马小定理：如果n是一个素数，a是小于n的任意正整数，那么a都n次方与a模n同余。
  >
  > 如果n不是素数，那么，一般而言，大部分的 a < n 都满足上面关系。
  >
  > 这就引出了下面这个检查素数的算法：对于给定的整数n，随机任取一个 a < n 并计算出a^n取模n的余数。如果得到的结果不等于a，那么n就肯定不是素数。如果它就是a，那么n是素数都机会就很大。现在再取另一个随机的a并采用同样方式检查。如果它满足上述等式，那么我们就能对n是素数有更大都信心了。通过检查越来越多都a值，我们就可以不断增加对有关结果的信心。

    <br>
    为了实现费马检查，我们需要有一个过程来计算一个数的幂对另一个数取模的结果：

    ```scheme
    (define (expmod base exp m)
        (cond ((= exp 0) 1)
              ((even? exp)
                (remainder 
                    (square (expmod base (/ exp 2) m))
                m))
              (else 
                (remainder 
                    (* base (expmod base (- exp 1) m))
                m))))
    ```

    <br>
    执行费马检查需要选取1～n-1之间（包含这两者）的数a，而后检查a的n次幂取模n的余数是否等于a。随机数a都选取由random完成，我们假定它已经包含在scheme的基本过程中，它返回比其输入参数小的某个非负整数。这样，要得到1和n-1之间的随机数，只需要random(n-1)+1：

    ```scheme
    (define (fermat-test n)
        (define (try-it a)
            (= (expmod a n n) a))
        (try-it (+ 1 (random (- n 1)))))

    (define (fast-prime? n times)
    (cond ((= times 0) true)
            ((fermat-test n) 
            (fast-prime? n (- times 1)))
            (else false)))
    ```


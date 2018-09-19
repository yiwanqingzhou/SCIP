# Exercise 1-1


## 1.1

```scheme
10
(+ 5 3 4)
(- 9 1)
(/ 6 2)
(+ (* 2 4) (- 4 6))
(define a 3)
(define b (+ a 1))
(+ a b (* a b))
(= a b)
(if (and (> b a) (< b (* a b)))
    b
    a)
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
(+ 2 (if (> b a) b a))
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
```


## 1.2

```scheme
(/ (+ 5 4 (- 2 (- 3 (+ 6 4/5))))(* 3 (- 6 2) (- 2 7)))
```


## 1.3
> Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

```scheme
(define (max x y) (if (> x y) x y))
(define (larger-sum a b c)
        (cond ((= (max a b) (max b c)) (+ (max a b) (max a c)))
              (else (+ (max a b) (max b c)))))
```


## 1.4
> Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

```scheme
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
```
<br />

## 1.5

> Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

```scheme
(define (p) (p))

(define (test x y) 
  (if (= x 0) 0 y))  
```

> Then he evaluates the expression

```scheme
(test 0 (p))
```

> What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

<br>
在执行 (test 0 (p)) 时，采用正则序，p会无限扩展自己，导致死循环
<br />

## 1.6
```scheme
(define (new-if predicate then-clause else-clause)
   (cond (predicate then-clause))
         (else else-clause)))
```

- if和cond是应用序  

- 自定义都new-if是正则序  

- **在new-if中重复调用方法会无限扩展导致死循环** 


## 1.7
> The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers.  
> An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test.   
> Does this work better for small and large numbers?

<br />

```scheme
(define (sqrt x) (sqrt-iter 0.5 1.0 x))

(define (sqrt-iter lassguess guess x)
  (if (good-enough? lassguess guess) guess
      (sqrt-iter guess (improve guess x) x)))

(define (good-enough? lassguess guess)
  (< (abs (- lassguess guess) ) 0.01))

```


## 1.8

> To implement a cube-root procedure analogous to the square-root procedure.

```scheme
(define (square x) (* x x))
(define (cube x) (* x x x))

(define (abs x)
	(if (< x 0) (- x) x))

(define (average x y z) 
  (/ (+ x y z) 3))

(define (improve guess x)
  (average (/ x (square guess)) guess guess))

(define (cube-root x) (cube-root-iter 1.0 x))

(define (cube-root-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-root-iter (improve guess x) x)))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x) ) 0.01))

```


## 1.9

> Each of the following two procedures defines a method for adding two positive integers in terms of the procedures inc, which increments its argument by 1, and dec, which decrements its argument by 1.

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

## 1.10

**Ackermann’s function**

```scheme
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1)
                 (A x (- y 1))))))
```

## 1.11

> A function f is defined by the rule that $f(n)=n$ if $n<3$ and $f(n)=f(n−1)+2f(n−2)+3f(n−3)$ if $n≥3$. Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process.

```scheme
(define (f-iter  a b c count)
   (if (= count 0)
       c
       (f-iter (+ a (* 2 b) (* 3 c)) a b (- count 1))))

(define (f n)
   (f-iter 2 1 0 n))
```


## 1.12
> The following pattern of numbers is called Pascal’s triangle.
>
>              1
>            1   1
>          1   2   1
>        1   3   3   1
>      1   4   6   4   1
>            . . .
> The numbers at the edge of the triangle are all 1, and each number inside the triangle is the sum of the two numbers above it.35 Write a procedure that computes elements of Pascal’s triangle by means of a recursive process.

```scheme
(define (Pascal row column)
    (cond ((= column 1) 1)
          ((= column row) 1)
          ((or (= row 1) (= row 2)) 1)
          (else (+ (Pascal (- row 1) column) 
                   (Pascal (- row 1) (- column 1))))))
```


## 1.13


## 1.14
> Draw the tree illustrating the process generated by the *count-change* procedure of **1.2.2** in making change for 11 cents. What are the orders of growth of the space and number of steps used by this process as the amount to be changed increases?


## 1.15
>```scheme
>(define (cube x) (* x x x))
>
>(define (p x)(- (* 3 x) (* 4 (cube x))))
>
>(define (sine angle)
>    (if (not (> (abs angle) 0.01))
>        angle
>        (p (sine (/ angle 3.0)))))
>```
>1.How many times is the procedure p applied when (sine 12.15) is evaluated? 
>
>2.What is the order of growth in space and number of steps (as a function of a) used by the process generated by the sine procedure when (sine a) is evaluated?


## 1.16
> Design a procedure that evolves an iterative exponentiation process that uses successive squaring and uses a logarithmic number of steps, as does fast-expt.

 ```scheme
(define (square x) (* x x))

(define (fast-expt b n)
  (fast-expt-iter 1 b n))

(define (fast-expt-iter a b n)
    (cond ((= n 0) a)
          ((even? n)
            (fast-expt-iter a (square b) (/ n 2)))
          (else (fast-expt-iter (* a b) b (- n 1)))))
```

##1.17
> The exponentiation algorithms in this section are based on performing exponentiation by means of repeated multiplication. In a similar way, one can perform integer multiplication by means of repeated addition.  
> The following multiplication procedure (in which it is assumed that our language can only add, not multiply) is analogous to the expt procedure:
>
>```scheme
>(define (* a b)
>  (if (= b 0)
>      0
>      (+ a (* a (- b 1)))))
>```
>This algorithm takes a number of steps that is linear in b. Now suppose we include, together with addition, operations double, which doubles an integer, and halve, which divides an (even) integer by 2.   
>Using these, design a multiplication procedure analogous to fast-expt that uses a logarithmic number of steps.

```scheme
(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti-logtime a b)
    (cond ((= b 0) 0)
          ((even? b) 
            (double (muti-logtime a (halve b))))
          (else 
            (+ a (muti-logtime a (- b 1))))))
```


## 1.18
>Using the results of **Exercise 1.16** and **Exercise 1.17**, devise a procedure that generates an iterative process for multiplying two integers in terms of adding, doubling, and halving and uses a logarithmic number of steps.

```scheme
(define (double x)
    (+ x x))

(define (halve x)
    (/ x 2))

(define (even? n)
  (= (remainder n 2) 0))

(define (muti-fast a b)
    (define (iter a b product)
        (cond ((= b 0) product)
              ((even? b)
                (iter (double a) (halve b) product))
              (else
                (iter a (- b 1) (+ a product) ))))
    (iter a b 0))
```


## 1.19


## 1.20


## 1.21
>Use the smallest-divisor procedure to find the smallest divisor of each of the following numbers: 199, 1999, 19999.

```scheme
(define (smallest-divisor n)

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

(find-divisor n 2))

(define (prime? n)
    (= n (smallest-divisor n)))

(define (square x) (* x x))

(display (smallest-divisor 199))
(newline)
(display (smallest-divisor 1999))
(newline)
(display (smallest-divisor 19999))
(newline)
```

## 1.22
Unbound variable: runtime

## 1.23
> The smallest-divisor procedure shown at the start of this section does lots of needless testing: After it checks to see if the number is divisible by 2 there is no point in checking to see if it is divisible by any larger even numbers. This suggests that the values used for test-divisor should not be 2, 3, 4, 5, 6, …, but rather 2, 3, 5, 7, 9, …. To implement this change, define a procedure next that returns 3 if its input is equal to 2 and otherwise returns its input plus 2. Modify the smallest-divisor procedure to use (next test-divisor) instead of (+ test-divisor 1). With timed-prime-test incorporating this modified version of smallest-divisor, run the test for each of the 12 primes found in **Exercise 1.22.** Since this modification halves the number of test steps, you should expect it to run about twice as fast. Is this expectation confirmed? If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2?

**Scheme 保证，当一个环境中存在两个同名的绑定时，新的绑定会覆盖旧的绑定。**
```scheme
(define greet "hello")
(display greet)
(newline)

(define greet "hello world")
(display greet)
(newline)
```

```
hello
hello world
```

新定义：
```scheme
(define (next n)
    (if (= n 2) 3 (+ n 2)))

(define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) 
        n)
        ((divides? test-divisor n) 
        test-divisor)
        (else (find-divisor 
            n 
            (next test-divisor)))))
```


## 1.24


## 1.25
> Alyssa P. Hacker complains that we went to a lot of extra work in writing expmod. After all, she says, since we already know how to compute exponentials, we could have simply written
> ```scheme
> (define (expmod base exp m)
>   (remainder (fast-expt base exp) m))
> ```
> Is she correct? Would this procedure serve as well for our fast prime tester? Explain.

<br>

Alyssa 的 expmod 函数在理论上是没有错的，但是在实际中却运行得不好。  
因为费马检查在对一个非常大的数进行素数检测的时候，可能需要计算一个很大的乘幂，比如说，求十亿的一亿次方，这种非常大的数值计算的速度非常慢，而且很容易因为超出实现的限制而造成溢出。  
而原本的 expmod 函数，通过每次对乘幂进行 remainder 操作将乘幂限制在一个很小的范围内，这样可以最大限度地避免溢出，而且计算速度快得多。


## 1.26
>Louis Reasoner is having great difficulty doing **Exercise 1.24.** His *fast-prime?* test seems to run more slowly than his prime? test. Louis calls his friend Eva Lu Ator over to help. When they examine Louis’s code, they find that he has rewritten the expmod procedure to use an explicit multiplication, rather than calling square:

>```scheme
>(define (expmod base exp m)
>  (cond ((= exp 0) 1)
>        ((even? exp)
>         (remainder 
>          (* (expmod base (/ exp 2) m)
>             (expmod base (/ exp 2) m))
>          m))
>        (else
>         (remainder 
>          (* base 
>             (expmod base (- exp 1) m))
>          m))))
>```
>
>“I don’t see what difference that could make,” says Louis. “I do.” says Eva. “By writing the procedure like that, you have transformed the Θ(logn) process into $a$ Θ(n) process.” Explain.

<br>

```scheme
(* (expmod base (/ exp 2) m)
   (expmod base (/ exp 2) m))

(square (expmod base (/ exp 2) m))
```
不使用square，将进行两次```(expmod base (/ exp 2) m)```计算。


## 1.27


## 1.28


## 1.29
>Simpson’s Rule is a more accurate method of numerical integration than the method illustrated above. Using Simpson’s Rule, the integral of a function f between a and b is approximated as
>$$\frac{h}{3}\ (+4y_1+2y_2+4y_3+2y_4+⋯+2y_{n−2}+4y_{n−1}+y_n)$$
>where $h=(b−a)/n$, for some even integer $n$, and $y_k=f(a+kh)$. (Increasing $n$ increases the accuracy of the approximation.) Define a procedure that takes as arguments $f,\ a,\ b,$ and $n$ and returns the value of the integral, computed using Simpson’s Rule. Use your procedure to integrate cube between 0 and 1 (with $n$=100 and $n$=1000), and compare the results to those of the integral procedure shown above.


```scheme
(define (integral-h f a b n)
  (define h (/ (- b a) n))
  (define (y k)
      (f (+ a (* k h))))
  (define (mutifator k)
    (cond ((= k 0) 1)
          ((= k n) 1)
          ((even? k) 2)
          (else 4)))
  (define (even? x)
    (= (remainder x 2) 0))
  (define (term x)
    (* (mutifator x) (y x)))
  (define (next x)
    (+ x 1))
  (* (/ h 3)
     (sum term 0 next n)))
```

## 1.30
>The sum procedure above generates a linear recursion. The procedure can be rewritten so that the sum is performed iteratively. Show how to do this by filling in the missing expressions in the following definition:
>```scheme
>(define (sum term a next b)
>  (define (iter a result)
>    (if ⟨??⟩
>        ⟨??⟩
>        (iter ⟨??⟩ ⟨??⟩)))
>  (iter ⟨??⟩ ⟨??⟩))

```scheme
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) 
          (+ result (term a)))))
  (iter a 0))
```

## 1.31

>The sum procedure is only the simplest of a vast number of similar abstractions that can be captured as higher-order procedures Write an analogous procedure called product that returns the product of the values of a function at points over a given range. Show how to define factorial in terms of product. Also use product to compute approximations to $π$ using the formula

$$ \frac{π}{4} = \frac{2⋅4⋅4⋅6⋅6⋅8⋅……}{3⋅3⋅5⋅5⋅7⋅7⋅……} $$

```scheme
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))))
      
(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* (term a) result))))
  (iter a 1))

(define (even? x)
  (= (remainder x 2) 0))

(define (inc x)
  (+ x 1))

(define (term k)
  (if (even? k)
      (/ (+ k 2) (+ k 1))
      (/ (+ k 1) (+ k 2))))

(define (pi n)
  (* 4 (product term 1.0 inc n)))

(define (pi-iter n)
  (* 4 (product-iter term 1.0 inc n)))
```


## 1.32
> 1.Show that sum and product (Exercise 1.31) are both special cases of a still more general notion called accumulate that combines a collection of terms, using some general accumulation function:
> ```scheme
> (accumulate 
>   combiner null-value term a next b)
>```
> Accumulate takes as arguments the same term and range specifications as sum and product, together with a combiner procedure (of two arguments) that specifies how the current term is to be combined with the accumulation of the preceding terms and a null-value that specifies what base value to use when the terms run out. Write accumulate and show how sum and product can both be defined as simple calls to accumulate.
>
> 2.If your accumulate procedure generates a recursive process, write one that generates an iterative process. If it generates an iterative process, write one that generates a recursive process.

```scheme
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value term (next a) next b))))

(define (accumulate combiner null-value term a next b)
  (define (accumulate-iter a result)
    (if (> a b)
        result
        (accumulate-iter (next a) 
                         (combiner (term a) result))))
  (accumulate-iter a null-value))              

(define (sum term a next b)
  (define (plus x y)
    (+ x y))
  (define null-value 0)
  (accumulate plus null-value term a next b))

(define (identity x) x)
(define (inc x) (+ x 1))

(define (sum-intergers a b)
  (sum identity a inc b))

(define (product term a next b)
  (define (muti x y)
    (* x y))
  (define null-value 1)
  (accumulate muti null-value term a next b))

(define (product-itergers a b)
  (product identity a inc b))
```

## 1.33
```scheme
(define (filtered-accmulate
         combiner null-value filter term a next b)
  (cond ((> a b) null-value)
        ((filter a) 
            (combiner (term a)
                      (filtered-accmulate 
                        combiner null-value filter term (next a) next b)))
        (else (filtered-accmulate 
          combiner null-value filter term (next a) next b))))

(define (inc x) (+ x 1))
(define (plus x y) (+ x y))
(define (identity x) x)

(define (sum-even a b)
  (filtered-accmulate plus 0 prime? identity a inc b))
```

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

> A function f is defined by the rule that f(n)=n if n<3 and f(n)=f(n−1)+2f(n−2)+3f(n−3) if n≥3. Write a procedure that computes f by means of a recursive process. Write a procedure that computes f by means of an iterative process.

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
> Draw the tree illustrating the process generated by the count-change procedure of 1.2.2 in making change for 11 cents. What are the orders of growth of the space and number of steps used by this process as the amount to be changed increases?


## 1.15
```scheme
(define (cube x) (* x x x))

(define (p x)(- (* 3 x) (* 4 (cube x))))

(define (sine angle)
    (if (not (> (abs angle) 0.01))
        angle
        (p (sine (/ angle 3.0)))))
```
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
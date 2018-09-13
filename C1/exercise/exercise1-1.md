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
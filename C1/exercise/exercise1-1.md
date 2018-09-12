# Exercise 1-1


### 1.1

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

### 1.2

```scheme
(/ (+ 5 4 (- 2 (- 3 (+ 6 4/5))))(* 3 (- 6 2) (- 2 7)))
```

### 1.3
> Define a procedure that takes three numbers as arguments and returns the sum of the squares of the two larger numbers.

```scheme
(define (max x y) (if (> x y) x y))
(define (larger-sum a b c)
        (cond ((= (max a b) (max b c)) (+ (max a b) (max a c)))
              (else (+ (max a b) (max b c)))))
```

### 1.4
> Observe that our model of evaluation allows for combinations whose operators are compound expressions. Use this observation to describe the behavior of the following procedure:

```scheme
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))
```
<br />

### 1.5

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

### 1.6
```scheme
(define (new-if predicate then-clause else-clause)
   (cond (predicate then-clause))
         (else else-clause)))
```

- if和cond是应用序  

- 自定义都new-if是正则序  

- **在new-if中重复调用方法会无限扩展导致死循环** 
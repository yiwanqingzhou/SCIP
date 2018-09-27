## 2.2 Hierarchical Data and the Closure Property 层次性数据和闭包性质

<br>

> 我们可以建立元素本身也是序对的序对，这就是表结构得以作为一种表示工具的根本基础。
> 
> 我们将这种能力称为cons的闭包性质。
> 
> 一般说，某种组合数据对象的操作满足闭包性质，那就是说，通过它组合起对象得到的结果本身还可以通过同样的操作再进行组合。
> 
> 闭包性质是任何一种组合功能的威力的关键要素，因为它使我们能够建立起层次性的结构，这些结构由一些部分构成，而其中的各个部分又是由它自己的各部分构成，并且可以如此继续下去。

<br>

### 2.2.1 序列的表示

```scheme
(list ⟨a₁⟩ ⟨a₂⟩ … ⟨aₙ⟩)
```

is equivalent to

```scheme
(cons ⟨a₁⟩
      (cons ⟨a₂⟩
            (cons …
                  (cons ⟨aₙ⟩
                        nil)…)))
```
<br>

**nil ： 表示序对的链结束，也可以当作一个不包含任何元素的序列，空表。**

**car ： 选取表的第一项**

**cdr ： 选取表中除去第一项之后剩下的所有项形成的子表**

<br>

```scheme
(define one-through-four (list 1 2 3 4))

one-through-four
> (1 2 3 4)
```

```scheme
(car one-through-four)
> 1

(cdr one-through-four)
> (2 3 4)

(car (cdr one-through-four))
> 2

(cons 10 one-through-four)
> (10 1 2 3 4)

(cons 5 one-through-four)
> (5 1 2 3 4)
```

<br>

#### 表操作

>For $n=0$, **list-ref** should return the car of the list.
>
>Otherwise, **list-ref** should return the $(n−1)-st$ item of the cdr of the list.

```scheme
(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) 
                (- n 1))))

```
<br>

>Often we cdr down the whole list. To aid in this, Scheme includes a primitive predicate null?, which tests whether its argument is the empty list. The procedure length, which returns the number of items in a list, illustrates this typical pattern of use:

```scheme
;;;recursion

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))


;;;iteration

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ count 1))))
  (length-iter items 0))
```

<br>

>Another conventional programming technique is to “cons up” an answer list while cdring down a list, as in the procedure append, which takes two lists as arguments and combines their elements to make a new list:

```scheme
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) 
            (append (cdr list1) 
                    list2))))
```

<br>

#### 带点尾部记法的define

>The procedures +, *, and list take arbitrary numbers of arguments. One way to define such procedures is to use **define with dotted-tail notation**. In a procedure definition, a parameter list that has a dot before the last parameter name indicates that, when the procedure is called, the initial parameters (if any) will have as values the initial arguments, as usual, but the final parameter’s value will be a list of any remaining arguments. For instance, given the definition

```scheme
(define (f x y . z) ⟨body⟩)
```
the procedure f can be called with two or more arguments. If we evaluate

```scheme
(f 1 2 3 4 5 6)
```
then in the body of f, ```x``` will be 1, ```y``` will be 2, and ```z``` will be the list ```(3 4 5 6)```.

Given the definition

```scheme
(define (g . w) ⟨body⟩)
```
the procedure g can be called with zero or more arguments. If we evaluate
```scheme
(g 1 2 3 4 5 6)
```
then in the body of ```g```, ```w``` will be the list ```(1 2 3 4 5 6).```

<br>

#### 表的映射

一个特别有用的操作是将某种变换应用于一个表的所有元素，得到所有结果构成的表。  

举例来说，下面过程将一个表里的所有元素按给定因子做一次缩放。
```scheme
(define (scale-list items factor)
  (if (null? items)
      nil
      (cons (* (car items) factor)
            (scale-list (cdr items) 
                        factor))))

(scale-list (list 1 2 3 4 5) 10)
> (10 20 30 40 50)
```

我们可以抽象出具有一般性的想法，将其中的公共模式表述为一个高阶过程，就像1.3节中所做的那样。

这一高阶过程称为map，它有一个过程参数和一个表参数，返回值是将这一过程应用于表中各个元素得到的结果形成的表。

```scheme
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(map abs (list -10 2.5 -11.6 17))
> (10 2.5 11.6 17)

(map (lambda (x) (* x x)) (list 1 2 3 4))
> (1 4 9 16)
```

Now we can give a new definition of scale-list in terms of map:

```scheme
(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))
```
<br>

**for each**

过程for each与map类似，它以一个过程和一个元素表为参数，但它并不返回结果的表，只是将这一过程从左到右应用于各个元素，将过程应用于元素得到的值都丢掉不用。for-each通产惯用语那些执行某些动作的过程，如打印等。
```scheme
(define (for-each proc items)
  (if (null? items)
      #t
      (begin
        (proc (car items))
        (for-each proc (cdr items)))))


(for-each 
 (lambda (x) (newline) (display x))
 (list 57 321 88))

> 57
> 321
> 88
```
<br>


### 2.2.2 层次性结构 **难**

```scheme
(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x) 1))
        (else (+ (count-leave (car x))
                 (count-leave (cdr x))))))
```                 
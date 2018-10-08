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

<br>

#### 对树的映射

map是处理序列的一种强有力的抽象，于此类似，map与递归的结合也是处理树的一种强有力抽象。

例如，可以有与2.2.1节的scale-list类似的scale-tree过程，以一个数值因子和一颗树作为参数，返回一颗具有同样形状的树，树中的每个数值都做了一次缩放。

对于scale-tree的递归方案也与count-leaves类似：

```scheme
(define (scale-tree tree factor)
  (cond ((null? tree) nil)
        ((not (pair? tree)) 
            (* tree factor))
        (else
         (cons (scale-tree (car tree) 
                           factor)
               (scale-tree (cdr tree) 
                           factor)))))
```
<br>

另一种方法是将树看成子树的序列，并对它使用map。我们在这种序列上做映射，依次对各颗子树做缩放，并返回结果的表。对于基础情况，也就是当被处理的树是树叶时，就直接用因子去乘它。
```scheme
(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))


(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))
```
<br>


### 2.2.3 序列作为一种约定的界面

**sum-odd-squares** 以一棵树为参数,计算出值为奇数的叶子的平方和:
```scheme
(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares 
                  (car tree))
                 (sum-odd-squares 
                  (cdr tree))))))
```
<br>

> 这个过程可以用一些级联的处理步骤的信号来描述:
> 
> - 从一个**枚举器**开始，它产生出由给定的树的所有树叶组成“信号”。   
> - 这一信号流过一个**过滤器**，所有不是奇数的树都被删除了。   
> - 这样得到的信号又通过一个**映射**，这是一个“转换装置”，它将square过程应用于每个元素。   
> - 这一输出被馈入一个**累积器**，该装置用 + 将所有的元素组合起来，以初始的0开始。

<br>

- **映射**  
  可以用map过程来完成:

  ```scheme
  (map square (list 1 2 3 4 5))
  > (1 4 9 16 25)
  ```

- **过滤器**  
  过滤一个序列，也就是选出满足某个给定谓词的元素。

  ```scheme
  (define (filter predicate sequence)
    (cond ((null? sequence) nil)
          ((predicate (car sequence))
          (cons (car sequence)
                (filter predicate 
                        (cdr sequence))))
          (else  (filter predicate 
                        (cdr sequence)))))


  (filter odd? (list 1 2 3 4 5))
  > (1 3 5)
  ```

- **累积器**：

  ```scheme
  (define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op 
                        initial 
                        (cdr sequence)))))


  (accumulate + 0 (list 1 2 3 4 5))
  > 15
  (accumulate * 1 (list 1 2 3 4 5))
  > 120
  (accumulate cons nil (list 1 2 3 4 5))
  > (1 2 3 4 5)
  ```

- **枚举器**  
  剩下的就是实现有关的信号流图，枚举出需要处理的数据序列。  
  枚举出一棵树的所有树叶，可以用：

  ```scheme
  (define (enumerate-tree tree)
    (cond ((null? tree) nil)
          ((not (pair? tree)) (list tree))
          (else (append 
                (enumerate-tree (car tree))
                (enumerate-tree (cdr tree))))))

  (enumerate-tree (list 1 (list 2 (list 3 4)) 5))
  (1 2 3 4 5)
  ```

现在可以像信号流图那样重新构造**sum-odd-squares**了。
```scheme
(define (sum-odd-squares tree)
  (accumulate 
   +
   0
   (map square
        (filter odd?
                (enumerate-tree tree)))))
```
<br>

我们还可以按照顺序操作的方式来制定传统的数据处理应用程序。假设我们有一系列的人事记录，我们想要找到薪水最高的程序员的薪水。假设我们有一个返回记录薪水的选择器salary，还有一个谓词programmer?检查记录是否为程序员。那么我们可以写成：

```scheme
(define (salary-of-highest-paid-programmer records)
  (accumulate 
   max
   0
   (map salary
        (filter programmer? records))))
```

#### 嵌套映射
给定自然数n，找出所有不同的有序对i和j，其中 $1<=j<i<=n$ ，使得 $i+j$ 是素数。

完成这一计算的一种很自然的组织方式：首先生成出所有小于等于n的正自然数的有序对；而后通过过滤，得到那些和为素数的有序对；最后对每个通过了过滤的序对 $(i,j)$，产生出一个三元组 $(i,j,i+j)$ 。

> 这个过程用信号来描述:
>
> 1. 对序列```(enumerate-interval 1 n)```做一次映射，得到 $i$。
> 
> 2. 对于每个i，对序列```(enumerate-interval 1 （- i 1))```做一次映射，得到 $j$。
>
> 3. 对于每个j，用map生成序对```(list i j)```
> 
> 4. 将所有序对组合起来（用append累积起来）
>
> 5. 过滤和不为素数的序对
>
> 6. 用map对每个序对生成序对```(list i j (+ i j))```


```scheme

;;;The combination of mapping and accumulating with append

(define (flatmap proc seq)
  (accumulate append nil (map proc seq)))

;;;
(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) 
        (cadr pair) 
        (+ (car pair) (cadr pair))))

;;;
(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter 
        prime-sum?
        (flatmap
         (lambda (i)
           (map (lambda (j) 
                  (list i j))
                (enumerate-interval 
                 1 
                 (- i 1))))
         (enumerate-interval 1 n)))))       
```

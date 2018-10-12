## 2.3 Symbolic Data 符号数据
All the compound data objects we have used so far were constructed ultimately from numbers. In this section we extend the representational capability of our language by introducing the ability to work with arbitrary symbols as data.


### 2.3.1 Quotation 引号

```scheme
(define a 1)
(define b 2)

(list a b)
(1 2)

(list 'a 'b)
(a b)

(list 'a b)
(a 2)


(car '(a b c))
a

(cdr '(a b c))
(b c)
```

<br>

>**eq?**
>
>```eq?``` 过程以两个符号为参数，检查它们是否为同样的符号。
>
>利用 ```eq?``` 可以实现一个成为 ```memq``` 的有用过程，它以一个符号和一个表为参数。如果这个符号不包含在这个表里（也就是说，它与表里的任何项目都不 ```eq?```），```memq``` 就返回假；否则就返回该表中这个符号第一次出现开始的那个子表。

```scheme
(define (memq item x)
  (cond ((null? x) false)
        ((eq? item (car x)) x)
        (else (memq item (cdr x)))))
```

<br>

### 2.3.2 Example: Symbolic Differentiation 符号求导

```scheme
;;; 是否变量
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1)
       (variable? v2)
       (eq? v1 v2)))

;;; 和式
(define (addend s) (cadr s))
(define (augend s)
    (if (> (length s) 3)
        (cons '+ (cddr s))
        (caddr s)))
(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) 
         (+ a1 a2))
        (else (list '+ a1 a2))))

;;; 乘式        
(define (multiplier p) (cadr p))
(define (multiplicand p) 
    (if (> (length p) 3)
        (cons '* (cddr p))
        (caddr p)))
(define (product? x)
  (and (pair? x) (eq? (car x) '*)))
(define (make-product m1 m2)
    (cond ((or (=number? m1 0) 
               (=number? m2 0)) 
           0)
          ((=number? m1 1) m2)
          ((=number? m2 1) m1)
          ((and (number? m1) (number? m2)) 
           (* m1 m2))
          (else (list '* m1 m2))))

;;; 常量          
(define (=number? exp num)
    (and (number? exp) (= exp num)))          

;;; 乘幂  2-56                                
(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))
(define (base p) (cadr p))
(define (exponent p) (caddr p))
(define (make-exponentiation base exponent)
    (cond ((=number? exponent 0) 1)
          ((=number? exponent 1) base)
          ((and (number? base) (number? exponent))
            (power base exponent))
          (else (list '** base exponent ))))

(define (power base exponent)
    (define (power-iter result k)
        (if (= k exponent)
            result
            (power-iter (* base result) (+ k 1))))
    (power-iter 1 0))

;;;
(define (deriv exp var)
  (cond ((number? exp) 0)                   ; 常量
        ((variable? exp)                    ; 单变量
            (if (same-variable? exp var) 1 0))
        ((sum? exp)                         ; 和式
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var)))
        ((product? exp)                     ; 乘式
            (make-sum
                (make-product 
                    (multiplier exp)
                    (deriv (multiplicand exp) var))
                (make-product 
                    (deriv (multiplier exp) var)
                    (multiplicand exp))))
        ((exponentiation? exp)              ; 乘幂 2-56
            (make-product
                (make-product 
                    (exponent exp)
                    (make-exponentiation 
                        (base exp) 
                        (- (exponent exp) 1)))
                (deriv (base exp) var)))
        (else (error "unknown expression       
                                  type: DERIV" exp))))
```

### 2.3.3 实例：集合的表示

#### 集合的基础操作

- **union-set** 
  计算两个集合的并集

- **intersection-set**  
  计算两个集合的交集

- **element-of-set?**  
  用于确定某个给定元素是不是某个给定集合的成员

- **adjoin-set**  
  以一个对象和一个集合为参数，返回该集合加入了该对象之后的集合

<br>

#### 集合作为未排序的表 Sets as unordered lists

（元素不重复）

- **element-of-set?**
  
  这个过程的实现类似 ```memq```，但它应该用 ```equal?``` 而不是 ```eq?```，以保证集合元素可以不是符号。

```scheme
(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((equal? (car set) x) #t)
          (else (element-of-set? x (cdr set)))))
```
<br>

- **adjoin-set**
  
  利用 ```element-of-set?``` 就能很容易写出 ```adjoin-set``  
  如果要加入的对象已经在相应集合里，那么就返回那个集合；否则使用cons将该对象加入到该集合中

```scheme
(define (adjoin-set x set)
    (if (element-of-set? x set)
        set
        (cons x set)))
```
<br>

- **intersection-set**
  
  可以使用递归策略实现

```scheme
(define (intersection-set set1 set2)
    (cond ((or (null? set1) (null? set2)) '())
          ((element-of-set? (car set1) set)
              (cons 
                (car set1) 
                (intersection-set (cdr set1) set2)))
          (else (intersection-set (cdr set1) set2)))
```
<br>

- **union-set**
  
```scheme
(define (union-set set1 set2)
    (cond ((null? set1) set2)
          ((element-of-set? (car set1) set2)
          (cons 
            (car set1) 
            (union-set (cdr set1) set2)))
      (else (union-set (cdr set1) set2))))
```

<br>
<br>

#### 集合作为排序的表 Sets as ordered lists
加速集合操作的一种方式是改变表示方式，使集合元素按照上升序排列。

<br>


- **element-of-set?**
  
  为了检查一个项的存在性，现在就不必扫描整个表了  
  可以通过比较大小来辅助查找

```scheme
(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((= x (car set)) #t)
          ((< x (car set)) #f)
          (else (element-of-set? x (cdr set)))))
```
<br>

- **intersection-set**  

```scheme
(define (intersection-set set1 set2)
    (if (or (null? set1) (null? set2)) 
        '()
        (let ((x1 (car set1))
              (x2 (car set2))
              (s1 (cdr set1))
              (s2 (cdr set2)))
            (cond ((= x1 x2) 
                    (cons x1 
                          (intersection-set s1 s2)))
                  ((< x1 x2)
                    (intersection-set s1 set2))
                  (else (intersection-set set1 s2))))))
```


- **adjoin-set**  
```scheme
(define (adjoin-set x set)
    (cond ((null? set) x)
          ((= x (car set)) set)  
          ((< x (car set))
                (cons x set))
          (else (cons (car set)
                      (adjoin-set x (cdr set))))))
```
  
  - **union-set** 
```scheme
(define (union-set set1 set2)
    (cond ((null? set1) set2)
          ((null? set2) set1)
          (else
            (let ((x1 (car set1))
                 (x2 (car set2))
                 (s1 (cdr set1))
                 (s2 (cdr set2)))
                 (cond ((< x1 x2) 
                         (cons x1 (union-set s1 set2)))
                       ((= x1 x2)
                         (cons x1 (union-set s1 s2)))
                       ((> x1 x2)
                         (cons x2 (union-set set1 s2))))))))
```
<br>


#### 集合作为二叉树 Sets as binary trees

- 树中每个结点保存集合中的一个元素，称为该结点的“数据项”，它还链接到另外的两个结点（可能为空）。  
  其中“左边”的链接所指向的所有元素均小于本结点的元素，而“右边”链接到的元素都大于本结点里的元素。

- 同一个集合表示为树可能有多种不同的方式。  
  我们对一个合法表示的要求就是，位于左子树里的所有元素都小于本结点里的数据项，而位于右子树里的所有元素都大于它。

- 我们可以用表来表示树，将结点表示为三个元素的表：本结点中的数据项，其左子树和右子树。  
  以空表作为左子树或者右子树，就表示没有子树连接在哪里。

```scheme
(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make entry left right)
    (list entry left right))
```
<br>


- **element-of-set?**
```scheme
(define (element-of-set? x set)
    (cond ((null? set) #f)
          ((= x (entry set)) #t)
          ((< x (entry set))
            (element-of-set? x (left-branch set))
          ((> x (entry set))
            (element-of-set? x (right-branch set))))))
```

- **adjoin-set**
```scheme
(define (adjoin-set x set)
    (cond ((null? set) (make-tree x '() '()))
          ((= x (entry set)) set)
          ((< x (entry set))
            (make-tree (entry set)
                       (adjoin-set x (left-branch set))
                       (right-branch set)))
          ((> x (entry set))
            (make-tree (entry set)
                       (left-branch set)
                       (adjoin-set x (right-branch))))))   
```
<br>

**但是adjoin-set并不能保证树的平衡性**  

只有平衡二叉树，才能实现对数复杂度的搜索。

解决这个问题的一种方式是定义一个操作，它可以将任意的树变换为一棵具有同样元素的平衡树。
在每执行过几次adjoin-set操作之后，我们就可以通过执行它来保持树的平衡。

当然，解决这个通体的方法还有很多，大部分这类方法都涉及到设计一种新的数据结构（比如B树和红黑树），设法使这种数据结构上的搜索和插入操作都能够在 $O(log n)$ 步数内完成。

```scheme
(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

```

<br>

#### 集合与信息检索 information retrieval

集合所讨论的技术在涉及信息检索的各种应用中将会一次又一次地出现。

典型的数据管理系统都需将大量时间用在访问和修改所存的数据上，因此就需要访问记录的高效方法。  
完成此事的一种方式是将每个记录中的一部分当作标识key（键值）。
所用键值可以是任何能唯一标识记录的东西。  
在确定了采用什么键值之后，就可以将记录定义为一种数据结构，并包含key选择过程，它可以从给定记录中提取出有关的键值。

现在就可以将这个数据库表示为一个记录的集合。为了根据给定键值确定相关记录的位置，我们用一个过程 ```lookup```，它以一个键值和一个数据库为参数，返回具有这个键值的记录，或者在找不到相应记录时报告失败。  

<br>

```lookup``` 的实现方式几乎与 ```element-of-set?``` 一模一样，如果记录的集合被表示为未排序的表，我们就可以用：


```scheme
(define (lookup given-key set-of-records)
  (cond ((null? set-of-records) #f)
        ((equal? given-key (key (car set-of-records)))
            (car set-of-records))
        (else (lookup given-key (cdr set-of-records)))))
```
<br>

如果记录的集合被表示为二叉树的表，我们就可以用：
```scheme
(define (lookup given-key set-of-records)
  (if (null? set-of-records)
      #f
      (let ((cur-key (key (entry set-of-records))))
        (cond ((= given-key cur-key) (entry set-of-records))
              ((< given-key cur-key)
                  (lookup given-key (left-branch set-of-records)))
              ((> given-key cur-key)
                  (lookup given-key (right-branch set-of-records)))))))
```

<br>

### 2.3.4 实例：Huffman编码树

- 定长编码 fixed-length codes  
    Representing each symbol in the message with the same number of bits.

    <br>

- 变长编码 variable-length codes  
  
  Different symbols may be represented by different numbers of bits.

  One of the difficulties of using a variable-length code is knowing when you have reached the end of a symbol in reading a sequence of zeros and ones. 

    - 分隔符 separator code 


    - 前缀码 prefix code
  
        To design the code in such a way that no complete code for any symbol is the beginning (or prefix) of the code for another symbol.

<br>

如果能够通过变长前缀码去利用被编码消息中符号出现的相对频度，那么就能明显地节约空间。
完成这件事情的一种特定方式成为Huffman编码。

一个Huffman编码可以表示为一棵二叉树，其中的树叶都是被编码的符号。  
树中每个非叶结点代表一个集合，其中包含了这一结点之下的所有树叶上的符号。
除此之外，位于树叶的每个符号还被赋予一个权重（也就是它的相对频度），非叶结点所包含的权重是位于它之下的所有叶结点的权重之和。这种权重在编码和解码中并不使用。

<br>

**Huffman解码**
P111

<br>

**生成Huffman树**

生成Huffman树的算法实际上十分简单，其想法就是设法安排这棵树，使得那些带有最低频度的符号出现在离树根最远的地方。  

这一构造过程从叶结点的集合开始，这种结点中包含各个符号和它们的频度，这就是开始构造编码的初始数据。  
现在要找出两个具有最低权重的叶，归并它们，产生出一个以这两个结点为左右分支的结点。新结点的权重就是那两个结点的权重之和。然后我们从原来的集合里删除前面的两个叶结点，并用这个新的结点代替它们。  
随后继续这一过程，在其中的每一步都归并两个具有最小权重的结点，将它们从集合中删除并用一个以这两个结点作为左右分钟的新结点取而代之。
当集合中只剩下一个结点时，过程终止，而这个结点就是树根。

    Initial {(A 8) (B 3) (C 1) (D 1) (E 1) (F 1) (G 1) (H 1)}

    Merge   {(A 8) (B 3) ({C D} 2) (E 1) (F 1) (G 1) (H 1)}

    Merge   {(A 8) (B 3) ({C D} 2) ({E F} 2) (G 1) (H 1)}

    Merge   {(A 8) (B 3) ({C D} 2) ({E F} 2) ({G H} 2)}

    Merge   {(A 8) (B 3) ({C D} 2) ({E F G H} 4)}

    Merge   {(A 8) ({B C D} 5) ({E F G H} 4)}

    Merge   {(A 8) ({B C D E F G H} 9)}

    Final   {({A B C D E F G H} 17)}

<br>

**Huffman树的表示**

将一棵树的树叶表示为包含符号leaf、叶中符号和权重的表：

```scheme
(define (make-leaf symbol weight)
    (list 'leaf symbol weight))

(define (leaf? object)
    (eq? (car object) 'leaf ))
    
(define (symbol-leaf x) (cadr x)) 
(define (weight-leaf x) (caddr x))
```

<br>

一棵一般的树也是一个表，其中包含一个左分支、一个右分支、一个符号集合和一个权重。

在归并两个结点做出一棵树时，树的权重也就是这两个结点的权重之和，其符号集就是两个结点的符号集的并集。因为这里的符号集用表来表示，通过 ```append``` 过程就可以得到它们的并集。

但在对树叶或者一般树调用过程 ```symbols``` 和 ```wight``` 时，它们需要做的事情有一点不同。

```scheme
(define (make-code-tree left right)
    (list left
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))))

(define (left-branch tree)
    (car tree))

(define (right-branch tree)
    (cadr tree))

(define (symbols tree)
    (if (leaf? tree)
        (list (symbol-leaf tree))
        (caddr tree)))

(define (weight tree)
    (if (leaf? tree)
        (weight-leaf tree)
        (cadddr tree)))      
```

<br>

**解码过程**
The decoding procedure

解码的过程以一个0／1表和一棵Huffman树为参数：
```scheme
(define (decode bits tree)
    (define decode-1 bits current-branch)
        (if (null? bits)
            '()
            (let ((next-branch 
                    (choose-branch (car bits) current-branch)))
                (if (leaf? next-branch)
                    (cons (symbols current-branch)
                          (decode-1 (cdr bits) tree))
                    (decode-1 (cdr bits) next-branch))))
    (decode-1 bits tree))
    
(define (choose-branch bit branch)
    (cond ((= bit 0) (left-branch branch))
          ((= bit 1) (right-branch branch))
          (else (error "bad bit -- CHOOSE-BRANCH" bit))))
```

<br>

**带权重元素的集合**
Sets of weighted elements

在树的表示中，每个非叶节点都包含一组符号，我们将其表示为一个简单的列表。但是，上面讨论的树生成算法还要求我们处理树叶和树的集合，依次合并两个最小的项。因为我们需要重复地找到集合中最小的项，所以对这种集合使用有序表示是很方便的。

我们准备将树叶和树的集合表示为一批元素的表，按照权重的上升顺序排列表中的元素。

```scheme
(define (adjoin-set x set)
    (cond ((null? set) (list x))
          ((< (weight x) (weight (car set)))
                (cons x set))
          (else
            (cons (car set)
                  (adjoin-set x (cdr set))))))
```

下面过程构造出树叶的初始排序集合（以一个符号-权重对偶的表为参数，如 ```((A 4) (B 2) (C 1) (D 1))```）：
```scheme
(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
            (adjoin-set (make-leaf (car pair)
                                   (cadr pair))
                        (make-leaf-set (cdr pairs))))))
```


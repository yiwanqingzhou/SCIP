## 2.4 抽象数据的多重表示
Multiple Representations for Abstract Data 

In this section, we will learn how to cope with data that may be represented in different ways by different parts of a program. This requires constructing **generic procedures** —— procedures that can operate on data that may be represented in more than one way. Our main technique for building generic procedures will be to work in terms of data objects that have **type tags**, that is, data objects that include explicit information about how they are to be processed. We will also discuss **data-directed** programming, a powerful and convenient implementation strategy for additively assembling systems with generic operations.

通过**类型标志**形成“垂直”的屏障，构造**通用性过程**。

如：对于复数的表示，可以使用直角坐标和极座标两种，需要在两者中形成垂直屏障，使得使用复数的程序可以对于两种表达方式都成立。

<br>

### 2.4.1 复数的表示 Representations for Complex Numbers

对于复数的表示，可以使用直角坐标和极座标两种:
```scheme
(make-from-real-imag (real-part z) 
                     (imag-part z))

(make-from-mag-ang (magnitude z) 
                   (angle z))
```


复数的两种不同表示方式分别适合不同的运算
```scheme
(define (add-complex z1 z2)
  (make-from-real-imag 
   (+ (real-part z1) (real-part z2))
   (+ (imag-part z1) (imag-part z2))))

(define (sub-complex z1 z2)
  (make-from-real-imag 
   (- (real-part z1) (real-part z2))
   (- (imag-part z1) (imag-part z2))))

(define (mul-complex z1 z2)
  (make-from-mag-ang 
   (* (magnitude z1) (magnitude z2))
   (+ (angle z1) (angle z2))))

(define (div-complex z1 z2)
  (make-from-mag-ang 
   (/ (magnitude z1) (magnitude z2))
   (- (angle z1) (angle z2))))
```

<br>

假定有两个程序员，他们正在分别独立地设计这以复数系统的具体表示形式。

A选择了复数的直角坐标表示形式，利用三角关系的公式建立起实部和虚部对偶与模和幅角对偶之间的联系：

```scheme
(define (real-part z) (car z))
(define (imag-part z) (cdr z))

(define (magnitude z)
  (sqrt (+ (square (real-part z)) 
           (square (imag-part z)))))

(define (angle z)
  (atan (imag-part z) (real-part z)))

(define (make-from-real-imag x y) 
  (cons x y))

(define (make-from-mag-ang r a)
  (cons (* r (cos a)) (* r (sin a))))
```


B选择了复数的极坐标形式，对于她而言，选取模和幅角的操作直截了当，但必须通过三角关系去得到实部和虚部：

```scheme
(define (real-part z)
  (* (magnitude z) (cos (angle z))))

(define (imag-part z)
  (* (magnitude z) (sin (angle z))))

(define (magnitude z) (car z))
(define (angle z) (cdr z))

(define (make-from-real-imag x y)
  (cons (sqrt (+ (square x) (square y)))
        (atan y x)))

(define (make-from-mag-ang r a) 
  (cons r a))
```

数据抽象的规则保证了 ```add-complex、sub-complex、mul-complex、div-complex``` 的同一套实现对于A或者B的表示都能正常工作。

<br><br>

### 2.4.2 带标志数据 Tagged data

```scheme
;;; 添加标志 / 选取内容
(define (attach-tag type-tag contents)
  (cons type-tag contents))

(define (type-tag datum)
  (if (pair? datum)
      (car datum)
      (error "Bad tagged datum: 
              TYPE-TAG" datum)))

(define (contents datum)
  (if (pair? datum)
      (cdr datum)
      (error "Bad tagged datum: 
              CONTENTS" datum)))
```      

<br>

```scheme
;;; 直角坐标 / 极坐标
(define (rectangular? z)
  (eq? (type-tag z) 'rectangular))

(define (polar? z)
  (eq? (type-tag z) 'polar))


(define (real-part z)
  (cond ((rectangular? z)
         (real-part-rectangular (contents z)))
        ((polar? z)
         (real-part-polar (contents z)))
        (else (error "Unknown type: 
               REAL-PART" z))))

(define (imag-part z)
  (cond ((rectangular? z)
         (imag-part-rectangular (contents z)))
        ((polar? z)
         (imag-part-polar (contents z)))
        (else (error "Unknown type: 
               IMAG-PART" z))))

(define (magnitude z)
  (cond ((rectangular? z)
         (magnitude-rectangular (contents z)))
        ((polar? z)
         (magnitude-polar (contents z)))
        (else (error "Unknown type: 
               MAGNITUDE" z))))

(define (angle z)
  (cond ((rectangular? z)
         (angle-rectangular (contents z)))
        ((polar? z)

(define (make-from-real-imag x y)
  (make-from-real-imag-rectangular x y))

(define (make-from-mag-ang r a)
  (make-from-mag-ang-polar r a))



(define (add-complex z1 z2)
  (make-from-real-imag 
   (+ (real-part z1) (real-part z2))
   (+ (imag-part z1) (imag-part z2))))  
```

<br><br>

### 2.4.3 数据导向的程序设计和可加性 Data-Directed Programming and Additivity

<br>

To implement this plan, assume that we have two procedures, put and get, for manipulating the operation-and-type table:


```(put ⟨op⟩ ⟨type⟩ ⟨item⟩) ``` installs the ```⟨item⟩``` in the table, indexed by the ```⟨op⟩``` and the ```⟨type⟩```.

```(get ⟨op⟩ ⟨type⟩) ``` looks up the ```⟨op⟩```, ```⟨type⟩``` entry in the table and returns the item found there. If no item is found, get returns false. 

```scheme
(define (install-rectangular-package)
  ;; internal procedures
  (define (real-part z) (car z))
  (define (imag-part z) (cdr z))
  (define (make-from-real-imag x y) 
    (cons x y))
  (define (magnitude z)
    (sqrt (+ (square (real-part z))
             (square (imag-part z)))))
  (define (angle z)
    (atan (imag-part z) (real-part z)))
  (define (make-from-mag-ang r a)
    (cons (* r (cos a)) (* r (sin a))))
  ;; interface to the rest of the system
  (define (tag x) 
    (attach-tag 'rectangular x))
  (put 'real-part '(rectangular) real-part)
  (put 'imag-part '(rectangular) imag-part)
  (put 'magnitude '(rectangular) magnitude)
  (put 'angle '(rectangular) angle)
  (put 'make-from-real-imag 'rectangular
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'rectangular
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done)
```

```scheme
(define (install-polar-package)
  ;; internal procedures
  (define (magnitude z) (car z))
  (define (angle z) (cdr z))
  (define (make-from-mag-ang r a) (cons r a))
  (define (real-part z)
    (* (magnitude z) (cos (angle z))))
  (define (imag-part z)
    (* (magnitude z) (sin (angle z))))
  (define (make-from-real-imag x y)
    (cons (sqrt (+ (square x) (square y)))
          (atan y x)))
  ;; interface to the rest of the system
  (define (tag x) (attach-tag 'polar x))
  (put 'real-part '(polar) real-part)
  (put 'imag-part '(polar) imag-part)
  (put 'magnitude '(polar) magnitude)
  (put 'angle '(polar) angle)
  (put 'make-from-real-imag 'polar
       (lambda (x y) 
         (tag (make-from-real-imag x y))))
  (put 'make-from-mag-ang 'polar
       (lambda (r a) 
         (tag (make-from-mag-ang r a))))
  'done)
```


<br><br>

**!!! 重要**

```scheme
;访问有关表格

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (error
            "No method for these types: 
             APPLY-GENERIC"
            (list op type-tags))))))
```

利用 ```apply-generic```， 各种通用型选择函数可以定义如下：
```scheme
(define (real-part z) (apply-generic 'real-part z))
(define (imag-part z) (apply-generic 'imag-part z))
(define (magnitude z) (apply-generic 'mangitude z))
(define (angle z) (apply-generic 'angle z))
```

构造函数：
```scheme
(define (make-form-real-imag x y)
    ((get 'make-form-real-imag 'rectangular ) x y))
(define (make-from-mag-ang r a)
    ((get 'make-from-mag-ang 'polar ) r a))
```

<br><br>

**消息传递**

在数据导向的程序设计里，最关键的想法就是通过显式处理操作-类型表格的方式，管理程序中的各种通用型操作。
我们在2.4.2节中所用的程序设计风格，是一种基于类型进行分派的组织方式，其中让每个操作管理自己的分派。
从效果上看，就是将操作-类型表格分解为一行一行，每个通用型过程表示表格中的一行。

另一种实现策略是将这以表格按列进行分解，不是采用一批“智能操作”去基于数据类型进行分派，而是采用“智能数据对象”，让它们基于操作名完成所需的分派工作。
如果我们相这样做，所需要做的就是做出一种安排，将每一个数据对象（例如一个采用直角坐标表示的复数）表示为一个过程。它以操作的名字作为输入，能够去执行制定的操作。

按照这种方式，```make-from-real-imag``` 应该写成：
```scheme
(define (make-from-real-imag x y)
  (define (dispatch op)
    (cond ((eq? op 'real-part) x)
          ((eq? op 'imag-part) y)
          ((eq? op 'magnitude)
           (sqrt (+ (square x) (square y))))
          ((eq? op 'angle) (atan y x))
          (else
           (error "Unknown op: 
            MAKE-FROM-REAL-IMAG" op))))
  dispatch)
```
  
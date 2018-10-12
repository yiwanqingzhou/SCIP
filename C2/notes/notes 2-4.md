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
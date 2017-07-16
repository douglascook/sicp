; Interval arithmetic - extended exercise
; Intervals are meant to represent the range of values imprecise quantities can take


; Given procedures for manipulating intervals
; Simply add the lower and upper bounds to form the sum
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
                 (+ (upper-bound x) (upper-bound y))))

; Find the min and max of all bound-pairs to form the product
(define (multiply-interval-original x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

; Multiply one interval by the reciprocal of the other, the bounds of the
; reciprocal are reversed ie upper then lower bound
(define (divide-interval-original x y)
  (multiply-interval x
                     (make-interval (/ 1.0 (upper-bound y))
                                    (/ 1.0 (lower-bound y)))))

; Width is half the distance between upper and lower bounds
(define (width interval)
  (/ (- (upper-bound interval)
        (lower-bound interval))
     2))


; Exercise 2.7
; Define selectors for upper and lower bounds
(define (make-interval lower upper)
  (if (> lower upper)
      (error "Upper bound must be larger than lower bound")
      (cons lower upper)))

(define (lower-bound interval) (car interval))

(define (upper-bound interval) (cdr interval))


; Exercise 2.8
; Define a procedure for subtraction
(define (subtract-interval a b)
  (make-interval (- (lower-bound a) (upper-bound b))
                 (- (upper-bound a) (lower-bound b))))


; Exercise 2.10
; Modify the procedure for division to raise an error if trying to divide by zero
(define (divide-interval x y)
  (define zero-denominator?
    (<= (* (lower-bound y)
           (upper-bound y))
        0))
  (if zero-denominator?
      (error "Cannot divide by an interval containing zero")
      (multiply-interval x
                         (make-interval (/ 1.0 (upper-bound y))
                                        (/ 1.0 (lower-bound y))))))


; Exercise 2.11
; Improve the multiplication procedure by considering the sign of endpoints

; FIXME this is hideous...
(define (multiply-interval x y)
  (cond ((and (positive? (lower-bound x))
              (positive? (upper-bound x))
              (positive? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (* (lower-bound x) (lower-bound y))
                        (* (upper-bound x) (upper-bound y))))
        ((and (negative? (lower-bound x))
              (negative? (upper-bound x))
              (negative? (lower-bound y))
              (negative? (upper-bound y)))
         (make-interval (* (upper-bound x) (upper-bound y))
                        (* (lower-bound x) (lower-bound y))))
        ((and (negative? (lower-bound x))
              (positive? (upper-bound x))
              (positive? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (* (lower-bound x) (upper-bound y))
                        (* (upper-bound x) (upper-bound y))))
        ((and (positive? (lower-bound x))
              (positive? (upper-bound x))
              (negative? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (* (upper-bound x) (lower-bound y))
                        (* (upper-bound x) (upper-bound y))))
        ((and (negative? (lower-bound x))
              (negative? (upper-bound x))
              (positive? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (* (lower-bound x) (upper-bound y))
                        (* (upper-bound x) (lower-bound y))))
        ((and (positive? (lower-bound x))
              (positive? (upper-bound x))
              (negative? (lower-bound y))
              (negative? (upper-bound y)))
         (make-interval (* (upper-bound x) (lower-bound y))
                        (* (lower-bound x) (upper-bound y))))
        ((and (negative? (lower-bound x))
              (negative? (upper-bound x))
              (negative? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (* (lower-bound x) (upper-bound y))
                        (* (lower-bound x) (lower-bound y))))
        ((and (negative? (lower-bound x))
              (positive? (upper-bound x))
              (negative? (lower-bound y))
              (negative? (upper-bound y)))
         (make-interval (* (upper-bound x) (lower-bound y))
                        (* (lower-bound x) (lower-bound y))))
        ((and (negative? (lower-bound x))
              (positive? (upper-bound x))
              (negative? (lower-bound y))
              (positive? (upper-bound y)))
         (make-interval (min (* (upper-bound x) (lower-bound y))
                             (* (lower-bound x) (upper-bound y)))
                        (max (* (upper-bound x) (upper-bound y))
                             (* (lower-bound x) (lower-bound y)))))))

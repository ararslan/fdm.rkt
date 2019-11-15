#lang racket/base

(require math)

(provide forward-grid backward-grid central-grid dfdx)

(define (forward-grid p)
  (in-range 0 p))

(define (backward-grid p)
  (in-range (- 1 p) 1))

(define (central-grid p)
  (if (odd? p)
      (in-range (quotient (- 1 p) 2) (add1 (quotient (- p 1) 2)))
      (in-sequences (in-range (quotient (- p) 2) 0)
                    (in-range 1 (add1 (quotient p 2))))))

(define (coefs p q grid)
  (let* ([c (for*/matrix p p ([i (in-range 0 p)]
                              [g grid])
              (expt g i))]
         [x (for*/matrix p 1 ([i (in-range p)])
              (if (= i q)
                  (factorial q)
                  0))])
    (matrix-solve c x)))

(define (maxabs x)
  (cond [(flonum? x) (flabs x)]
        [(number? x) (abs x)]
        [(array? x) (array-all-max (array-map abs x))]
        [else (apply max (map abs x))]))

(define (est-bound x cond)
  (+ (* cond (maxabs x)) 1e-20))

(define (dfdx gridf p q f x
              #:adapt (adapt 1)
              #:condition (condition 100)
              #:eps (eps epsilon.0)
              #:bound (bound (est-bound (f x) condition)))
  (begin
    (when (> adapt 0)
      (set! bound
        (let* ([g (gridf p)]
               [c (coefs p q g)]
               [d (dfdx gridf p q f x
                        #:adapt (- adapt 1)
                        #:condition condition
                        #:eps eps
                        #:bound bound)])
          (est-bound d condition))))
    (define grid (gridf p))
    (define coef (coefs p q grid))
    (define c1
      (* eps (array-all-sum (array-map abs coef))))
    (define c2
      (/ (* bound (for/sum ([g grid]
                            [c (in-array coef)])
                    (abs (* g (expt c p)))))
         (factorial p)))
    (define step
      (expt (* [/ q (- p q)] [/ c1 c2]) (/ p)))
    (/ (for/sum ([g grid]
                 [c (in-array coef)])
         (* c (f (+ x (* step g)))))
       (expt step q))))

;;; Tests

(module+ test
  (require rackunit)
  (check-=
    (dfdx central-grid 5 1 sin 1.0)
    (cos 1.0)
    1e-10))

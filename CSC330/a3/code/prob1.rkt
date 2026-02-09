#lang racket



;; ====================================== Answers ======================================

; 1.1: TODO
(define stream-for-n-steps #f)

; 1.2: TODO
(define fibo-stream #f)

; 1.3: TODO
(define filter-stream #f)

; 1.4: TODO
(define create-stream #f) ; replace define with macro definition



;; ==================================== Test suite =====================================

(require rackunit)

;; Sample stream for testing stream-for-n-steps
(define nat-num-stream (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))]) (lambda () (f 0))))

;; Test create-stream macro
(create-stream squares using (lambda (x) (* x x)) starting at 5 with increment 2)

(define tests
  (test-suite "Sample tests for A3 P1"
   (check-equal? (stream-for-n-steps nat-num-stream 10)
                 '(0 1 2 3 4 5 6 7 8 9)
                 "stream-for-n-steps test")
   (check-equal? (stream-for-n-steps fibo-stream 10) 
                 '(0 1 1 2 3 5 8 13 21 34) 
                 "fibo-stream test")
   (check-equal? (stream-for-n-steps (filter-stream (lambda (i) (> i 5)) nat-num-stream) 5)
                 '(6 7 8 9 10)
                 "filter stream test")
   (check-equal? (stream-for-n-steps squares 5)
                 '(25 49 81 121 169)
                 "stream defined using a macro. only tests is return value")))

;; Run the tests
(require rackunit/text-ui)
(run-tests tests)

#lang racket
(provide (all-defined-out))

;; CSC 330, Assignment 3, Problem 1
;; Ryan Glaeser
;; V00832892

;; ====================================== Answers ======================================

; 1.1: TODO
(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([next (s)])
        (cons (car next) 
              (stream-for-n-steps (cdr next) (- n 1))))))


; 1.2: TODO
(define fibo-stream
  (letrec ([f (lambda (curr next) (cons curr (lambda () (f next (+ curr next)))))]) 
  (lambda () (f 0 1))))

; 1.3: TODO
(define (filter-stream f s)
  (lambda ()
    (let ([next (s)])
      (if (f (car next))
          (cons (car next) (filter-stream f (cdr next)))
          ((filter-stream f (cdr next)))))))
    

; 1.4: TODO
(define-syntax create-stream
  (syntax-rules (using starting at with increment)
    [(create-stream name using f starting at i0 with increment delta)
      (define name
        (letrec ([gen (lambda (x)
          (cons (f x) (lambda () (gen (+ x delta)))))])
          (lambda () (gen i0))))]))



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

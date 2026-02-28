#lang racket



;; ===================================== Preamble ======================================

(provide (all-defined-out)) ;; so we can put tests in a second file

;; Definition of structures for MF/PL programs - Do NOT change
(struct var (string) #:transparent) ;; a variable, e.g., (var "foo")
(struct int (num) #:transparent) ;; a constant number, e.g., (int 17)
(struct add (e1 e2) #:transparent) ;; add two expressions
(struct if> (e1 e2 e3 e4) #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual) #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body)
(struct apair (e1 e2) #:transparent) ;; make a new pair
(struct fst (e) #:transparent) ;; get first part of a pair
(struct snd (e) #:transparent) ;; get second part of a pair
(struct aunit () #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0
;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent)



;; ====================================== Answers ======================================

; 2.1: TODO
(define (rkt-list->mfpl-list lst)
  (cond [(null? lst) (aunit)]
        [(list? lst) 
         (apair (rkt-list->mfpl-list (car lst)) 
                (rkt-list->mfpl-list (cdr lst)))]
        [#t lst]))

; 2.2: TODO
(define (mfpl-list->rkt-list lst)
  (cond [(aunit? lst) null]
        [(apair? lst)
          (cons (mfpl-list->rkt-list (apair-e1 lst)) (mfpl-list->rkt-list (apair-e2 lst)))]
        [#t lst]))

; 2.3
;; Lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond
    [(null? env) (error "unbound variable during evaluation" str)]
    [(equal? (car (car env)) str) (cdr (car env))]
    [#t (envlookup (cdr env) str)]))
; TODO:
;; DO NOT change the two cases given to you.
;; DO add more cases for other kinds of MF/PL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp (see below).
(define (eval-under-env e env)
  (cond
    [(var? e) (envlookup env (var-string e))]
    [(add? e)
     (let ([v1 (eval-under-env (add-e1 e) env)] [v2 (eval-under-env (add-e2 e) env)])
       (if (and (int? v1) (int? v2))
           (int (+ (int-num v1) (int-num v2)))
           (error "MF/PL addition applied to non-number")))]
    ; TODO
    ; add more cases here
    ; one for each type of expression
    [(int? e) e]
    [(aunit? e) e]
    [(closure? e) e]
    [(apair? e)
     (apair (eval-under-env (apair-e1 e) env)
            (eval-under-env (apair-e2 e) env))]
    [(if>? e)
     (let ([v1 (eval-under-env (if>-e1 e) env)]
           [v2 (eval-under-env (if>-e2 e) env)])
       (if (and (int? v1) (int? v2))
           (if (> (int-num v1) (int-num v2))
               (eval-under-env (if>-e3 e) env)
               (eval-under-env (if>-e4 e) env))
           (error "MF/PL if> applied to non-numbers")))]
    [(call? e)
     (let ([v1 (eval-under-env (call-funexp e) env)]
           [v2 (eval-under-env (call-actual e) env)])
       (if (closure? v1)
           (let* ([f (closure-fun v1)]
                  [c-env (closure-env v1)]
                  [base-env (cons (cons (fun-formal f) v2) c-env)]
                  [final-env (if (fun-nameopt f)
                                 (cons (cons (fun-nameopt f) v1) base-env)
                                 base-env)])
             (eval-under-env (fun-body f) final-env))
           (error "MF/PL call applied to non-closure")))]
    [(mlet? e)
     (let ([v (eval-under-env (mlet-e e) env)])
       (eval-under-env (mlet-body e) (cons (cons (mlet-var e) v) env)))]
    [(fun? e) (closure env e)]
    [(fst? e)
     (let ([v (eval-under-env (fst-e e) env)])
       (if (apair? v)
           (apair-e1 v)
           (error "MF/PL fst applied to non-pair")))]
    [(snd? e)
     (let ([v (eval-under-env (snd-e e) env)])
       (if (apair? v)
           (apair-e2 v)
           (error "MF/PL snd applied to non-pair")))]
    [(isaunit? e)
     (if (aunit? (eval-under-env (isaunit-e e) env))
         (int 1)
         (int 0))]
    [#t (error (format "bad MF/PL expression: ~v" e))]))

;; Do NOT change (modify eval-under-env instead!)
;; Note how evaluating an expression start with an empty environment
(define (eval-exp e)
  (eval-under-env e null))

; 2.4: TODO
(define (ifaunit e1 e2 e3)
  #f)

; 2.5: TODO
(define (mlet* lstlst e2)
  #f)

; 2.6: TODO
(define (if= e1 e2 e3 e4)
  #f)

; 2.7: TODO
(define mfpl-map #f)
;; This binding is a bit tricky. it must return a function.
;; the first two lines should be something like this:
;;
;;   (fun "mfpl-map" "f"    ;; it is  function "mfpl-map" that takes a function f
;;       (fun #f "lst"      ;; and it returns an anonymous function
;;          ...
;;
;; also remember that we can only call functions with one parameter, but
;; because they are curried instead of
;;    (call funexp1 funexp2 exp3)
;; we do
;;    (call (call funexp1 funexp2) exp3)
;;

; 2.8: TODO
(define mfpl-map-add-N
  (mlet "map" mfpl-map #f ; (notice map is now in MF/PL scope)
        ))



;; ==================================== Test suite =====================================
; See prob2_test.rkt

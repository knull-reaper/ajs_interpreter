;; by r34p3r
;; 2024-10-21
#lang typed/racket/base

(require racket/match)
(require "function.rkt")

(provide (all-defined-out))

(define-type Class class)
(struct class ([name : String] [superclass : (Option Class)] [methods : (HashTable String Function)]))

(: make-class (-> String (Option Class) (HashTable String Function) Class))
(define (make-class name superclass methods)
  (class name superclass methods))

(: class-find-method (-> Class String (Option Function)))
(define (class-find-method c name)
  (match-define (class class-name superclass methods) c)
  (cond
    [(hash-has-key? methods name)
     (hash-ref methods name)] 
    [superclass
     (class-find-method superclass name)]
    [else #f]))
;; by r34p3r
;; 2024-10-13
#lang racket/base

(require "libraries/interpreter.rkt")
(require "libraries/resolver.rkt")
(require "libraries/error.rkt")

(define interpreter (make-interpreter))
(define resolver (make-resolver interpreter))

(define-syntax-rule (run stmts)
  (unless had-error ; parser error
    (resolve-all! resolver stmts)
    (unless had-error ; resolver error
      (interpret! interpreter stmts))))

(define-syntax-rule (ajs-module-begin STMT ...)
  (#%module-begin (run (list STMT ...))))

(provide
  (rename-out [ajs-module-begin #%module-begin])
  #%top #%app #%datum #%top-interaction)
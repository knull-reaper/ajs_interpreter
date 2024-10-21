;; by r34p3r
;; 2024-10-13
#lang racket/base

(require racket/port)
(require "libraries/parser.rkt")
(require "libraries/scanner.rkt")

(define (read-syntax _ port)
  (define source (port->string port))
  (define scanner (make-scanner source))
  (define tokens (scan-tokens! scanner))
  (define parser (make-parser tokens))
  (define statements (parse! parser))
  (define module-datum `(module ajs-mod ajs/expander
                          ,@statements))
  (datum->syntax #f module-datum))

(provide read-syntax)
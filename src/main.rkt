;; by r34p3r
;; 2024-10-13
;; file pass garna ko lagi send the file as an argument on the command line
#lang typed/racket/base

(require racket/match)
(require racket/file)
(require "ajs/libraries/parser.rkt")
(require "ajs/libraries/scanner.rkt")
(require "ajs/libraries/interpreter.rkt")
(require "ajs/libraries/resolver.rkt")
(require "ajs/libraries/error.rkt")
(require "ajs/libraries/stmt.rkt")
(require "ajs/libraries/pretty-print.rkt")

(provide main)

(define interpreter-instance (make-interpreter))

;; entry point
(: main (-> Void))
(define (main)
  (define args (current-command-line-arguments))
  (match args
    [(vector) (run-prompt)]
    [(vector f) (run-file interpreter-instance f)] 
    [_ (println "Usage: racket-ajs [script]")]))

(: run-prompt (-> Void))
(define (run-prompt)
  (let loop ()
    (display "> ")
    (define line (read-line))
    (unless (eof-object? line)
      (run interpreter-instance line)
      (set-had-error! #f)
      (loop))))

(: run-file (-> Interpreter Path-String Void))
(define (run-file interpreter filename)
  (define source (file->string filename))
  (run interpreter source)
  (when had-error (exit 65))
  (when had-runtime-error (exit 70)))

(: run (-> Interpreter String (Option Any)))
(define (run interpreter source)
  (define scanner (make-scanner source))
  (define tokens (scan-tokens! scanner))
  (define parser (make-parser tokens))
  (define statements (parse! parser))
  (unless had-error
    (let ([resolver (make-resolver interpreter)])
      (resolve-all! resolver statements)
      (unless had-error
        (interpret! interpreter statements)))))

(main)

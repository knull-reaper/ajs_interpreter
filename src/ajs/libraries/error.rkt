;; by r34p3r
;; 2024-10-09
;; separated for better error handling on 2024-10-13
#lang typed/racket/base

(require racket/match)
(require "token.rkt")

(provide (all-defined-out))

(: had-error Boolean)
(define had-error #f)

(: had-runtime-error Boolean)
(define had-runtime-error #f)

(: set-had-error! (-> Boolean Void))
(define (set-had-error! bool)
  (set! had-error bool))

(: set-had-runtime-error! (-> Boolean Void))
(define (set-had-runtime-error! bool)
  (set! had-runtime-error bool))

(struct exn:parse-error exn:fail ())
(define-type ParseError exn:parse-error)

(: make-parse-error (-> Token String exn:parse-error))
(define (make-parse-error token message)
  (ajs-error token message) ; print error message and set had-error
  (exn:parse-error (ajs-error-message (token-line token) "" message)
                   (current-continuation-marks)))

(: raise-parse-error (-> Token String exn:parse-error))
(define (raise-parse-error token message)
  (raise (make-parse-error token message)))

;; for runtime errors
(struct exn:runtime-error exn:fail ([token : Token]))
(define-type RuntimeError exn:runtime-error)

(: make-runtime-error (-> Token String RuntimeError))
(define (make-runtime-error token message)
  (exn:runtime-error message (current-continuation-marks) token))

(: raise-runtime-error (-> Token String RuntimeError))
(define (raise-runtime-error token message)
  (raise (make-runtime-error token message)))

(: runtime-error (-> RuntimeError Void))
(define (runtime-error e)
  (set-had-runtime-error! #t)
  (displayln (runtime-error-message e) (current-error-port)))

(: runtime-error-message (-> RuntimeError String))
(define (runtime-error-message e)
  (format "~a\n[line ~a]"
          (exn-message e)
          (token-line (exn:runtime-error-token e))))

(: raise-undefined-variable-error (-> Token String exn:runtime-error))
(define (raise-undefined-variable-error name lexeme)
  (raise-runtime-error
   name (format "Undefined variable '~a'." lexeme)))

;; eof errors

(: ajs-error (-> Token String Void))
(define (ajs-error t message)
  (match-define (token type lexeme _ line) t)
  (if (equal? type EOF)
      (report-error line " at end" message)
      (report-error line (format " at '~a'" lexeme) message)))

(: report-error (-> Integer String String Void))
(define (report-error line where message)
  (displayln (ajs-error-message line where message) (current-error-port))
  (set-had-error! #t))

(: ajs-error-message (-> Integer String String String))
(define (ajs-error-message line where message)
  (format "[line ~a] Error~a: ~a" line where message))

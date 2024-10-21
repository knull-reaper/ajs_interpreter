;; by r34p3r
;; 2024-10-09
;; unable to find a way to escape the && and || in the keywords hash so proceeding with ands and ors. :( din vari lago
#lang typed/racket/base

(provide (struct-out token) (all-defined-out))

(define-type ajs-Literal (U String Number Boolean Null))

(struct token ([type : Symbol] 
               [lexeme : String] 
               [literal : ajs-Literal] 
               [line : Integer])
  #:mutable)

(define-type Token token)

(: make-token (->* (Symbol String Integer) (ajs-Literal) Token))
(define (make-token type lexeme line [literal null])
  (token type lexeme literal line))

(: keywords (HashTable String Symbol))
(define keywords
  (hash
   "and" 'AND
   "class" 'CLASS
   "else" 'ELSE
   "false" 'FALSE
   "for" 'FOR
   "function" 'FUNCTION
   "if" 'IF
   "null" 'NIL
   "or" 'OR
   "print" 'PRINT
   "return" 'RETURN
   "super" 'SUPER
   "this" 'THIS
   "true" 'TRUE
   "const" 'CONST
   "while" 'WHILE))

(define LEFT_PAREN 'LEFT_PAREN)
(define RIGHT_PAREN 'RIGHT_PAREN)
(define LEFT_BRACE 'LEFT_BRACE)
(define RIGHT_BRACE 'RIGHT_BRACE)
(define COMMA 'COMMA)
(define DOT 'DOT)
(define MINUS 'MINUS)
(define PLUS 'PLUS)
(define SEMICOLON 'SEMICOLON)
(define SLASH 'SLASH)
(define STAR 'STAR)
(define BANG 'BANG)
(define BANG_EQUAL 'BANG_EQUAL)
(define EQUAL 'EQUAL)
(define EQUAL_EQUAL 'EQUAL_EQUAL)
(define GREATER 'GREATER)
(define GREATER_EQUAL 'GREATER_EQUAL)
(define LESS 'LESS)
(define LESS_EQUAL 'LESS_EQUAL)
(define IDENTIFIER 'IDENTIFIER)
(define STRING 'STRING)
(define NUMBER 'NUMBER)
(define AND 'AND)
(define CLASS 'CLASS)
(define ELSE 'ELSE)
(define FALSE 'FALSE)
(define FUNCTION 'FUNCTION)
(define FOR 'FOR)
(define IF 'IF)
(define NIL 'NIL)
(define OR 'OR)
(define PRINT 'PRINT)
(define RETURN 'RETURN)
(define SUPER 'SUPER)
(define THIS 'THIS)
(define TRUE 'TRUE)
(define CONST 'CONST)
(define WHILE 'WHILE)
(define EOF 'EOF)

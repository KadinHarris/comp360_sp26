#lang br/quicklang

;;; read-syntax takes in a file path (unused here), a port (or a source file)
;;; it reads the port into a list of lines
;;; it processes the lines into DATUMS or SYMBOLS
;;; then it splices those datums into ANOTHER datum (the module)
;;; Racket can later read those datums as actual Racket code,
;;; which is what datum->syntax is for!
;;; add an additional ' to '(handle ~a) and
;;; change the module code to (module stacker-mod br ...)
;;; to see what the reader produces
(displayln "Make sure you see this in your output!")
(define (read-syntax path port) ; port is the source code
  (define src-lines (port->lines port)) ; put every line into a list
;  (define filtered (filter (lambda (line)
;                             (if (string=? line "")
;                                 #t
;                                 (not (char=? #\;
;                                              (string-ref line 0)))))
;                           src-lines))
  (define src-datums (format-datums '(handle ~a) src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt"
                          ,@src-datums))
  (datum->syntax #f module-datum))


(provide read-syntax) ; expose this function to other modules!


;;; a macro is a function that turns some code into different code
;;; we'll talk about SYNTAX PATTERNS like HANDLE-EXPR later!
;;; #' creates a syntax object which remembers the lexical context
;;; (more on that later, I hope!)
;;; this is analogous to a closure (but very different!)
;;; now any module using this language will process its body through our macro
;;; this macro expands at compile time, transforming
;;; the expressions from the reader into a module body
;;; that runs them and displays the top of the stack
(define-macro (stacker-module-begin HANDLE-EXPR ...)
  #'(#%module-begin
     HANDLE-EXPR ...
     (display (first stack))))

; any module using our stacker language needs to use OUR #%module-begin
; so we point #%module-begin to our macro
; otherwise, it will point to the macro handling
; our language's language (in this case, br/quicklang)
(provide (rename-out [stacker-module-begin #%module-begin])) 

(define stack '())

(define (pop-stack!)
  (define top (car stack))
  (set! stack (cdr stack))
  top)

(define (push-stack! a)
  (set! stack (cons a stack)))

(define (handle [arg #f])
  (cond ((equal? arg +) (push-stack! (+ (pop-stack!) (pop-stack!))))
        ((equal? arg *) (push-stack! (* (pop-stack!) (pop-stack!))))
        ((or (equal? arg -) (equal? arg /)
             (let ((first pop-stack!)
                   (second pop-stack!))
               (push-stack! (arg second first))))
         ((number? arg) (push-stack! arg))))

  (define dump (lambda ()
                 (displayln (first stack))
                 (set! stack '())))

  (provide handle dump)

  (provide + *)
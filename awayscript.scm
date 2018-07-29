(define script-active #f)                                                                                                                                                          
(define inactivity-limit (* 60 2))

(weechat:register "awayscript"
                  "tjb"
                  "1.0"
                  "MIT"
                  "a script that takes over when you go away"
                  ""
                  "")

(define (highlight-away-cb data buffer date tags displayed highlight prefix message)
  (if (and script-active (= 1 highlight))                                                                                                                                          
      (weechat:command buffer
                       (format #f "~a (inactive: ~a second~:p)" (speak) (string->number (weechat:info_get "inactivity" "")))))
  weechat:WEECHAT_RC_OK)

(define (inactive?)
  (let ((time-inactive (string->number (weechat:info_get "inactivity"
                                                         ""))))
    (> time-inactive inactivity-limit)))

(define (check-inactivity data remaining-calls)
  (if (inactive?)
      (set! script-active #t)                                                                                                                                                      
      (set! script-active #f))                                                                                                                                                     
  weechat:WEECHAT_RC_OK)

(define (speak)
  "Temporary till we get some actual speech code in here"
  (do ((len 0 (1+ len))
       (out "" (string-append out "g")))
      ((> len (random 30))
       out)))

(weechat:hook_print ""                  ;buffer                                                                                                                                     
                    ""                  ;tags                                                                                                                                       
                    ""                  ;message                                                                                                                                    
                    0                   ;strip_colors                                                                                                                               
                    "highlight-away-cb" ;callback                                                                                                                                   
                    "")                 ;callback_data                                                                                                                              

(weechat:hook_timer 1000               ;interval                                                                                                                                    
                    0                  ;alignment                                                                                                                                   
                    0                  ;max_calls (0 is infinite)                                                                                                                   
                    "check-inactivity" ;callback                                                                                                                                    
                    "")

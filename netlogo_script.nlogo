breed [deer a-deer]
breed [poacher a-poacher]
breed [government prosecutor]
breed [NGO an-NGO]
turtles-own [money]
patches-own [countdown]

;;setup;;

to setup
  clear-all
  ask patches [ set pcolor green ]
  set-default-shape deer "sheep 2"               ; set up default properties of deer
  create-deer initial-number-deer                ; count deer = initial-number-deer (the one setted up in slide
  [ 
    set color brown
    set size 2
    set money 0
    setxy random-xcor random-ycor
  ]
  set-default-shape poacher "dog"                ; set up default properties of pracher
  create-poacher initial-number-poacher
  [
    set color white
    set size 2
    set money 0
    setxy random-xcor random-ycor
  ]
  set-default-shape government "person police"   ; set up default properties of prosecutor
  create-government initial-number-prosecutor
  [
    set color blue
    set size 2
    set money 0
    setxy random-xcor random-ycor
  ]
   set-default-shape NGO "dollar bill"           ; set up default properties of NGO
  create-NGO initial-number-NGO
  [
    set color yellow
    set size 2
    set money 0
    setxy random-xcor random-ycor
  ]
  reset-ticks
end

;;go;;

to go
  ; if not any? turtles [ stop ]       ; run until there is not any turtles (??
  if ticks > equi [ stop ]             ; stop at a givin ticks
  ask deer [
    move
  ]
  ask poacher [
    move
    hunt-deer
  ]
  ask government [
    move
    ; gov-manage
    prosecute-poacher
    ; hunt-deer-prosecutor
  ]
  ask NGO [
    move
    collaborate
    ; gather-intelligence
    manage-deer
  ]
  tick
end

;;tasks;;

to move
  rt random 50
  lt random 50
  fd 1
  set money money * 0.9999    ; discount rate?
end

to hunt-deer 
  ; behaviour of poacher
  let prey one-of deer-here   ; prey = some deer here
  ; if there is some deer, and the resources-into-hunting value is not exceeded
  if prey != nobody and random-float (count deer / (1 / (count poacher / count deer))) * resources-into-hunting < resources-into-hunting 
  ; the poacher agent’s money value is increased by the associated money-gain-from-hunt
  ; but with consideration given for the current number of poachers and therefore the likeliness of them encountering a deer given their number 
    [ set money money + ((money-gain-from-hunt / (count deer / (1 / (count poacher / count deer))))/ 2.25)
      ask prey [ set money money - ((money-gain-from-hunt / (count deer / (1 / (count poacher / count deer))))/ 2.25)] set money money * 1]
      set money money * 1
end

; behaviour of government ------------
to gov-manage  
  ;; extension *****
  let prey one-of deer-here
  if prey != nobody and random-float (count deer / (1 / (count government / count deer))) * resources-to-manage < resources-to-manage
     ; wildlife benefited from being managed
     ;                                             [[   chances of encountering them within the system   ]]
     [set money money - ((benefits-from-management / (count deer / (1 / (count government / count deer))))/ 1.1)
     ask prey [set money money + ((benefits-from-management / (count deer / (1 / (count government / count deer))))/ 1.1) ]
     set money money * 1 ]
     set money money * 1
end

to prosecute-poacher 
  let prey one-of poacher-here
  if prey != nobody and random-float (count poacher / (1 / (count government / count poacher))) * chances-of-prosecution < chances-of-prosecution
  [ set money money + ((fine / (count poacher / (1 / (count government / count poacher))))/ 5)
    ask prey [ set money money - ((fine / (count poacher / (1 / (count government / count poacher))))/ 5) ]  set money money * 1 ]
    set money money * 1
end

to hunt-deer-prosecutor 
  ;; extension *****
  let prey one-of deer-here
  if prey != nobody and random-float (count deer / (1 / (count government / count deer))) * chances-of-prosecution < chances-of-prosecution
    [ set money money + ((fine / (count deer / (1 / (count government / count deer))))/ 5)
      ask prey [ set money money - ((fine / (count deer / (1 / (count government / count deer))))/ 5) ]   set money money * 1 ]
      set money money * 1
end


;; behaviour of NGO ------------------------
to collaborate 
  let prey one-of government-here
  if prey != nobody and random-float (count government / (1 / (count NGO / count government))) * chances-of-alignment < chances-of-alignment
  [ set money money + ((contribution / (count government / (1 / (count NGO / count government))))/ 1.5)
    ask prey [set money money - ((contribution / (count government / (1 / (count NGO / count government))))/ 1.5)] set money money * 1 ]
    set money money * 1
end

to gather-intelligence 
  ;; extension *****
  let prey one-of poacher-here
  if prey != nobody and random-float (count poacher / (1 / (count NGO / count poacher))) * chances-of-alignment < chances-of-alignment
  [ set money money + ((contribution / (count poacher / (1 / (count NGO / count poacher))))/ 1.5)
    ask prey [set money money - ((contribution / (count poacher / (1 / (count NGO / count poacher))))/ 1.5)] set money money * 1 ]
    set money money * 1
end

to manage-deer 
  let prey one-of deer-here
  if prey != nobody and random-float (count deer / (1 / (count NGO / count deer))) * resources-to-manage < resources-to-manage
    [set money money - ((benefits-from-management / (count deer / (1 / (count NGO / count deer))))/ 1.1)
     ask prey [set money money + ((benefits-from-management / (count deer / (1 / (count NGO / count deer))))/ 1.1)]
     set money money * 1 ]
     set money money * 1
end

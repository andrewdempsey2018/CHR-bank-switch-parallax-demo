.segment "ZEROPAGE"
car_x: .res 1
car_y: .res 1
car_frame: .res 1

.segment "CODE"

.export DrawCar
.proc DrawCar
  php  ; save registers
  pha
  txa
  pha
  tya
  pha

  ldx car_frame

  ldx #0
  .repeat 5, I
    lda car_y
    sta $0204 + (I*4) + 0

    lda car_top_f1 + I
    sta $0204 + (I*4) + 1

    lda #$03          ; palette #3
    sta $0204 + (I*4) + 2

    lda car_x
    clc
    adc #(I*8)
    sta $0204 + (I*4) + 3
  .endrepeat

  .repeat 5, I
    lda car_y
    clc
    adc #8
    sta $0204 + 20 + (I*4) + 0

    lda car_middle_f1 + I
    sta $0204 + 20 + (I*4) + 1

    lda #$03
    sta $0204 + 20 + (I*4) + 2

    lda car_x
    clc
    adc #(I*8)
    sta $0204 + 20 + (I*4) + 3
  .endrepeat
  
  .repeat 5, I
    lda car_y
    clc
    adc #16
    sta $0204 + 40 + (I*4) + 0

    lda car_bottom_f1 + I
    sta $0204 + 40 + (I*4) + 1

    lda #$03
    sta $0204 + 40 + (I*4) + 2

    lda car_x
    clc
    adc #(I*8)
    sta $0204 + 40 + (I*4) + 3
  .endrepeat

  pla ; restore registers
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.segment "RODATA"

car_top_f1:
  .byte $30, $31, $32, $33, $34
car_middle_f1:
  .byte $40, $41, $42, $43, $44
car_bottom_f1:
  .byte $50, $51, $52, $53, $54

car_top_f2:
  .byte $35, $36, $37, $38, $39
car_middle_f2:
  .byte $45, $46, $47, $48, $49
car_bottom_f2:
  .byte $55, $56, $57, $58, $59
.segment "ZEROPAGE"

.segment "CODE"

.export DrawClouds
.proc DrawClouds
  php  ; save registers
  pha
  txa
  pha
  tya
  pha

  cloud1_x = 40
  cloud1_y = 16

  cloud2_x = 160
  cloud2_y = 24


DrawClouds:

  .repeat 3, I
    lda #cloud1_y
    sta $0240 + (I*4)

    lda cloud1 + I
    sta $0240 + (I*4) + 1

    lda #$00
    sta $0240 + (I*4) + 2

    lda #cloud1_x
    clc
    adc #(I*8)
    sta $0240 + (I*4) + 3
  .endrepeat

  .repeat 3, I
    lda #cloud1_y + 8
    sta $0240 + 12 + (I*4)

    lda cloud1 + 3 + I
    sta $0240 + 12 + (I*4) + 1

    lda #$00
    sta $0240 + 12 + (I*4) + 2

    lda #cloud1_x
    clc
    adc #(I*8)
    sta $0240 + 12 + (I*4) + 3
  .endrepeat

  .repeat 3, I
    lda #cloud2_y
    sta $0240 + 24 + (I*4)

    lda cloud2 + I
    sta $0240 + 24 + (I*4) + 1

    lda #$00
    sta $0240 + 24 + (I*4) + 2

    lda #cloud2_x
    clc
    adc #(I*8)
    sta $0240 + 24 + (I*4) + 3
  .endrepeat

  .repeat 3, I
    lda #cloud2_y + 8
    sta $0240 + 36 + (I*4)

    lda cloud2 + 3 + I
    sta $0240 + 36 + (I*4) + 1

    lda #$00
    sta $0240 + 36 + (I*4) + 2

    lda #cloud2_x
    clc
    adc #(I*8)
    sta $0240 + 36 + (I*4) + 3
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

cloud1:
.byte $01, $02, $03
.byte $11, $12, $13

cloud2:
.byte $04, $05, $06
.byte $14, $15, $16
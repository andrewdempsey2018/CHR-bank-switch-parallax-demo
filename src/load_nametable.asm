;.include "constants.inc"

.segment "RODATA"

.segment "ZEROPAGE"

.segment "CODE"
.export load_nametable
.proc load_nametable
  php  ; save registers
  pha
  txa
  pha
  tya
  pha


  lda $2002             ; read PPU status to reset the high/low latch
  lda nametableAddress
  sta $2006             ; write the high byte of $2000 address
  lda #$00
  sta $2006             ; write the low byte of $2000 address

  ldx #$00
  ldy #$00
OutsideLoop:

InsideLoop:

  lda (pointer), y       ;
  sta $2007             ; write to PPU
  iny
  cpy #0
  bne InsideLoop

  inc pointer+1
  inx
  cpx #4
  bne OutsideLoop

  pla ; restore registers
  tay
  pla
  tax
  pla
  plp

  rts
.endproc
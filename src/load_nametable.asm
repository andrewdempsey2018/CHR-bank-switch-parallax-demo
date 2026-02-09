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


  lda PPUSTATUS             ; read PPU status to reset the high/low latch
  lda nametableAddress
  sta PPUADDR             ; write the high byte of $2000 address
  lda #$00
  sta PPUADDR             ; write the low byte of $2000 address

  ldx #$00
  ldy #$00
OutsideLoop:

InsideLoop:

  lda (pointer), y       ;
  sta PPUDATA           ; write to PPU
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
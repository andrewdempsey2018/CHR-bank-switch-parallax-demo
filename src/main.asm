.include "constants.inc" 
.include "header.inc"
.include "reset.asm"
.include "load_nametable.asm"
.include "controllers.asm"

.segment "ZEROPAGE"
nametableAddress: .res 1
sleeping: .res 1
buttons_held: .res 1
buttons_pressed: .res 1
pointer: .res 2

timer: .res 1
bank_no: .res 1

.segment "CODE"

.proc irq_handler
  rti
.endproc

.proc nmi_handler
  ; save registers
  php
  pha
  txa
  pha
  tya
  pha

  lda #$00
  sta OAMADDR
  lda #$02
  sta OAMDMA
  lda #$00

  jsr read_controller

  ;This is the PPU clean up section, so rendering the next frame starts properly.
  lda #%10010000   ; enable NMI, sprites from Pattern Table 0, background from Pattern Table 1
  sta $2000
  lda #%00011110   ; enable sprites, enable background, no clipping on left side
  sta $2001

  ;;
  lda #$00
  sta sleeping

  ; restore registers and return
  pla
  tay
  pla
  tax
  pla
  plp

  rti
.endproc

.proc clear_oam
  php  ; save registers
  pha
  txa
  pha
  tya
  pha

	ldx #$00
	lda #$F8
@clear_oam:
	sta $0200, x ; set sprite y-positions off the screen
	inx
	inx
	inx
	inx
	bne @clear_oam

  pla ; restore registers
  tay
  pla
  tax
  pla
  plp

  rts
.endproc

.proc main
  ldx PPUSTATUS
  ldx #$3f
  stx PPUADDR
  ldx #$00
  stx PPUADDR

load_palettes:
  lda palettes,X
  sta PPUDATA
  inx
  cpx #$20 ; there are 32 colours to load
  bne load_palettes

  ; init title screen
  lda #<level1 ;point to low byte of nametable
  sta pointer
  lda #>level1 ;point to high byte of nametable
  sta pointer+1
  jsr load_nametable
  ; finished setting up title screen

  lda #%10010000  ; turn on NMIs, sprites use first pattern table
  sta PPUCTRL
  lda #%00011110  ; turn on screen
  sta PPUMASK
  ;;

vblankwait:       ; wait for another vblank before continuing
  bit PPUSTATUS
  bpl vblankwait

mainloop:
  inc timer
  lda timer
  cmp #4
  bne :+

  lda #0
  sta timer

  inc bank_no
  lda bank_no
  sta BANK_SWITCH
  cmp #$03
  bne :+
  lda #$00
  sta bank_no
:

DontBank:

done:
  ;loop
  inc sleeping
sleep:
  lda sleeping
  bne sleep

  jmp mainloop
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "graphics1.chr"
.incbin "graphics2.chr"
.incbin "graphics3.chr"
.incbin "graphics4.chr"
.incbin "graphics5.chr"

.segment "RODATA"

palettes:
; background
  .byte $21,$10,$16,$30
  .byte $21,$2d,$10,$30
  .byte $21,$0f,$23,$30
  .byte $21,$0f,$19,$29

; sprites
  .byte $21,$00,$10,$20
  .byte $21,$0f,$27,$20
  .byte $21,$0f,$00,$30
  .byte $21,$0f,$15,$20

.include "level1.asm"


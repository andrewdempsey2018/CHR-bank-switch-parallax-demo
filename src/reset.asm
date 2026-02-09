.segment "ZEROPAGE"

.segment "CODE"
.export reset_handler
.proc reset_handler
  sei
  cld
  ldx #$40
  stx $4017
  ldx #$FF
  txs
  inx
  stx $2000
  stx $2001
  stx $4010
  bit $2002
vblankwait:
  bit $2002
  bpl vblankwait

	ldx #$00
	lda #$FF
clear_oam:
	sta $0200,X ; set sprite y-positions off the screen
	inx
	inx
	inx
	inx
	bne clear_oam

  lda #$00
  sta timer
  sta bank_no

  ldx #$20
  stx nametableAddress

vblankwait2:
  bit $2002
  bpl vblankwait2
  jmp main
.endproc
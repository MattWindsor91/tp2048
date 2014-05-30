SRC=		2048.PAS
UNITS=		GRID.PAS KEYMAP.PAS
BIN=		2048
COMPILER=	fpc
CFLAGS=		-Mtp

${BIN}: ${SRC} ${UNITS}
	${COMPILER} ${CFLAGS} ${SRC}

clean:
	rm -f ${BIN} *.o *.ppu *.tpu

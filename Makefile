SRC=		2048.PAS
BIN=		2048
COMPILER=	fpc
CFLAGS=		-Mtp

${BIN}: ${SRC}
	${COMPILER} ${CFLAGS} ${SRC}

clean:
	rm ${BIN}
	rm ${BIN}.o

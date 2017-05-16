ASMBLR=as6809
ASMOPS= -o -l

ASLINKER= aslink
LINKOPS= -s -m -w -u

SOURCE_EXT= asm
OBJ_EXT= rel
EXE_EXT= s19

OBJS = main.$(OBJ_EXT) ./uinterface/c4io.$(OBJ_EXT) \
./juego/instrucciones.$(OBJ_EXT) ./asmlib/io.$(OBJ_EXT) \
./asmlib/testing.$(OBJ_EXT) ./juego/turn.$(OBJ_EXT) \
./juego/internal.$(OBJ_EXT) ./asmlib/artlog.$(OBJ_EXT)

EMUL= m6809-run


main.s19: $(OBJS)
	$(ASLINKER) $(LINKOPS) main.$(EXE_EXT) $(OBJS)

main.$(OBJ_EXT): main.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) main.$(SOURCE_EXT)
	
./uinterface/c4io.$(OBJ_EXT): ./uinterface/c4io.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./uinterface/c4io.$(SOURCE_EXT)
	
./juego/instrucciones.$(OBJ_EXT): ./juego/instrucciones.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./juego/instrucciones.$(SOURCE_EXT)
	
./juego/turn.$(OBJ_EXT): ./juego/turn.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./juego/turn.$(SOURCE_EXT)
	
./asmlib/io.$(OBJ_EXT): ./asmlib/io.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/io.$(SOURCE_EXT)
	
./asmlib/testing.$(OBJ_EXT): ./asmlib/testing.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/testing.$(SOURCE_EXT)
	
./asmlib/artlog.$(OBJ_EXT): ./asmlib/artlog.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/artlog.$(SOURCE_EXT)
	
./juego/internal.$(OBJ_EXT): ./juego/internal.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./juego/internal.$(SOURCE_EXT)
	
exe:
	$(EMUL) main.$(EXE_EXT)
	


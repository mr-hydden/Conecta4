ASMBLR=as6809
ASMOPS= -o -l

ASLINKER= aslink
LINKOPS= -s -m -w -u

SOURCE_EXT= asm
OBJ_EXT= rel
EXE_EXT= s19

OBJS = conecta4.$(OBJ_EXT) ./front-end/c4io.$(OBJ_EXT) \
./front-end/instrucciones.$(OBJ_EXT) ./asmlib/io.$(OBJ_EXT) \
./asmlib/ctype.$(OBJ_EXT) ./back-end/turno.$(OBJ_EXT) \
./back-end/internal.$(OBJ_EXT) ./asmlib/artlog.$(OBJ_EXT) \
./back-end/comprueba4.$(OBJ_EXT) ./back-end/comprueba4-bajoNivel.$(OBJ_EXT)

EMUL= m6809-run


conecta4.s19: $(OBJS)
	$(ASLINKER) $(LINKOPS) conecta4.$(EXE_EXT) $(OBJS)

conecta4.$(OBJ_EXT): conecta4.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) conecta4.$(SOURCE_EXT)
	
./front-end/c4io.$(OBJ_EXT): ./front-end/c4io.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./front-end/c4io.$(SOURCE_EXT)
	
./front-end/instrucciones.$(OBJ_EXT): ./front-end/instrucciones.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./front-end/instrucciones.$(SOURCE_EXT)
	
./back-end/turno.$(OBJ_EXT): ./back-end/turno.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./back-end/turno.$(SOURCE_EXT)
	
./asmlib/io.$(OBJ_EXT): ./asmlib/io.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/io.$(SOURCE_EXT)
	
./asmlib/ctype.$(OBJ_EXT): ./asmlib/ctype.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/ctype.$(SOURCE_EXT)
	
./asmlib/artlog.$(OBJ_EXT): ./asmlib/artlog.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./asmlib/artlog.$(SOURCE_EXT)
	
./back-end/internal.$(OBJ_EXT): ./back-end/internal.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./back-end/internal.$(SOURCE_EXT)
	
./back-end/comprueba4.$(OBJ_EXT): ./back-end/comprueba4.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./back-end/comprueba4.$(SOURCE_EXT)
	
./back-end/comprueba4-bajoNivel.$(OBJ_EXT):./back-end/comprueba4-bajoNivel.$(SOURCE_EXT)
	$(ASMBLR) $(ASMOPS) ./back-end/comprueba4-bajoNivel.$(SOURCE_EXT)
	
exe:
	$(EMUL) conecta4.$(EXE_EXT)
	
debug:
	ensambla -d conecta4 ./front-end/c4io \
	./front-end/instrucciones ./asmlib/io \
	./asmlib/ctype ./back-end/turno \
	./back-end/internal ./asmlib/artlog \
	./back-end/comprueba4 ./back-end/comprueba4-bajoNivel
	
	


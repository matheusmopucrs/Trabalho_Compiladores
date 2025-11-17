%{
  import java.io.*;
  import java.util.ArrayList;
  import java.util.Stack;
%}
 

%token ID, INT, FLOAT, BOOL, NUM, LIT, VOID, MAIN, READ, WRITE, IF, ELSE
%token WHILE,TRUE, FALSE, IF, ELSE
%token DO
%token FOR
%token EQ, LEQ, GEQ, NEQ 
%token AND, OR
%token INC, DEC, ADDEQ
%token BREAK, CONTINUE

%right '='
%right '?' ':'        /* condicional ternário */
%left OR
%left AND
%left  '>' '<' EQ LEQ GEQ NEQ
%left '+' '-'
%left '*' '/' '%'
%left '!' 

%type <sval> ID
%type <sval> LIT
%type <sval> NUM
%type <ival> type


%%

prog : { geraInicio(); } dList mainF { geraAreaDados(); geraAreaLiterais(); } ;

mainF : VOID MAIN '(' ')'   { System.out.println("_start:"); }
        '{' lcmd  { geraFinal(); } '}'
      ; 

dList : decl dList 
      | 
      ;

decl : type ID ';' 
      {  
        TS_entry nodo = ts.pesquisa($2);
        if (nodo != null) 
            yyerror("(sem) variavel >" + $2 + "< jah declarada");
        else 
            ts.insert(new TS_entry($2, $1)); 
      }
      ;

type : INT    { $$ = INT; }
     | FLOAT  { $$ = FLOAT; }
     | BOOL   { $$ = BOOL; }
     ;

lcmd : lcmd cmd
     |
     ;
	   

/* 
 * comando = expressao seguida de ';'
 * (inclusive atribuicao, pois '=' entrou em exp)
 */
cmd :  exp ';'

    | '{' lcmd '}' 
      { 
        System.out.println("\t\t# terminou o bloco..."); 
      }
					     
    | WRITE '(' LIT ')' ';' 
      { 
        strTab.add($3);
        System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
        System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
        System.out.println("\tCALL _writeLit"); 
        System.out.println("\tCALL _writeln"); 
        strCount++;
      }
      
    | WRITE '(' LIT 
      { 
        strTab.add($3);
        System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
        System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
        System.out.println("\tCALL _writeLit"); 
        strCount++;
      }
      ',' exp ')' ';' 
      { 
        System.out.println("\tPOPL %EAX"); 
        System.out.println("\tCALL _write");	
        System.out.println("\tCALL _writeln"); 
      }
         
    | READ '(' ID ')' ';'								
      {
        System.out.println("\tPUSHL $_"+$3);
        System.out.println("\tCALL _read");
        System.out.println("\tPOPL %EDX");
        System.out.println("\tMOVL %EAX, (%EDX)");
      }
	
    | BREAK ';'
      {
        if (pBreak.empty())
            yyerror("(sem) comando 'break' fora de laco");
        else
            System.out.printf("\tJMP rot_%02d   # break\n", pBreak.peek());
      }

    | CONTINUE ';'
      {
        if (pContinue.empty())
            yyerror("(sem) comando 'continue' fora de laco");
        else
            System.out.printf("\tJMP rot_%02d   # continue\n", pContinue.peek());
      }

    /* DO { cmd } WHILE (exp); */
    | DO 
      {
        pRot.push(proxRot);             // rótulo início do do-while
        pContinue.push(pRot.peek());    // continue -> volta para o início
        pBreak.push(pRot.peek()+1);     // break -> vai para o fim
        System.out.printf("rot_%02d:\n", pRot.peek());
        proxRot += 2;                   // reserva rot_fim = inicio+1
      }
      cmd
      WHILE '(' exp ')' ';'
      {
        System.out.println("\tPOPL %EAX   # do-while testa no final");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf ("\tJNE rot_%02d\n", pRot.peek());
        System.out.printf("rot_%02d:\n", (int)pRot.peek()+1);
        pRot.pop();
        pContinue.pop();
        pBreak.pop();
      }

    /* WHILE (exp) cmd */
    | WHILE 
      {
        pRot.push(proxRot);         // rótulo início do while
        proxRot += 2;               // reserva também o rótulo de fim (inicio+1)
        pContinue.push(pRot.peek());        // continue -> volta para o início
        pBreak.push(pRot.peek()+1);         // break -> fim
        System.out.printf("rot_%02d:\n", pRot.peek());
      } 
      '(' exp ')' 
      {
        System.out.println("\tPOPL %EAX   # desvia se falso...");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", (int)pRot.peek()+1);
      } 
      cmd 
      {
        System.out.printf("\tJMP rot_%02d   # terminou cmd na linha de cima\n", pRot.peek());
        System.out.printf("rot_%02d:\n", (int)pRot.peek()+1);
        pRot.pop();
        pContinue.pop();
        pBreak.pop();
      }  
							
    /* IF (exp) cmd restoIf */
    | IF '(' exp 
      {	
        pRot.push(proxRot);  proxRot += 2;
        System.out.println("\tPOPL %EAX");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", pRot.peek());
      }
      ')' cmd 
      restoIf 
      {
        System.out.printf("rot_%02d:\n",pRot.peek()+1);
        pRot.pop();
      }

    /* FOR ( init ; cond ; incr ) cmd */
    | FOR '(' for_init ';'
      {
        int Lcond = proxRot++;
        int Lbody = proxRot++;
        int Lcont = proxRot++;
        int Lend  = proxRot++;

        pForCond.push(Lcond);   // cond
        pForBody.push(Lbody);   // corpo
        pForIncr.push(Lcont);   // incremento / continue
        pBreak.push(Lend);      // break
        pContinue.push(Lcont);  // continue

        /* depois da inicializacao, pula para a condicao */
        System.out.printf("\tJMP rot_%02d\n", Lcond);
      }
      for_cond ';'
      for_incr ')'
      {
        /* rótulo do corpo: proximo código é o cmd */
        System.out.printf("rot_%02d:\n", pForBody.peek());
      }
      cmd
      {
        /* fim do corpo: vai para o incremento (continue também cai lá) */
        System.out.printf("\tJMP rot_%02d\n", pForIncr.peek());

        /* rótulo de saída do for */
        System.out.printf("rot_%02d:\n", pBreak.peek());

        pForIncr.pop();
        pForCond.pop();
        pForBody.pop();
        pBreak.pop();
        pContinue.pop();
      }

    ;
     
restoIf 
    : ELSE  
      {
        System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
        System.out.printf("rot_%02d:\n",pRot.peek());
      } 							
      cmd  
							
    | {
        System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
        System.out.printf("rot_%02d:\n",pRot.peek());
      } 
    ;										

/* 1a expressao do for: INICIALIZACAO (resultado descartado) */
for_init :
      /* vazio */
    | exp  
      { 
        System.out.println("\tPOPL %EAX   # descarta resultado da inicializacao do for"); 
      }
    ;

/* 2a expressao: CONDICAO (pode ser vazia) */
for_cond :
      /* vazio */
      {
        /* condicao vazia: sempre verdadeira */
        int Lcond = pForCond.peek();
        int Lbody = pForBody.peek();
        System.out.printf("rot_%02d:\n", Lcond);
        System.out.printf("\tJMP rot_%02d\n", Lbody);
      }
    |
      { 
        /* label da condicao vem ANTES da expressao */
        int Lcond = pForCond.peek();
        System.out.printf("rot_%02d:\n", Lcond);
      }
      exp
      {
        System.out.println("\tPOPL %EAX   # condicao do for");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", pBreak.peek());      // sai do for se falso
        System.out.printf("\tJMP rot_%02d\n", pForBody.peek());   // vai pro corpo se verdadeiro
      }
    ;

/* 3a expressao: INCREMENTO (pode ser vazia) */
for_incr :
      /* vazio */
      {
        int Lcont = pForIncr.peek();
        int Lcond = pForCond.peek();
        System.out.printf("rot_%02d:\n", Lcont);
        System.out.printf("\tJMP rot_%02d\n", Lcond);
      }
    |
      { 
        int Lcont = pForIncr.peek();
        System.out.printf("rot_%02d:\n", Lcont);
      }
      exp
      {
        System.out.println("\tPOPL %EAX   # incremento do for");
        System.out.printf("\tJMP rot_%02d\n", pForCond.peek());
      }
    ;

exp :  NUM   
        { System.out.println("\tPUSHL $"+$1); } 

    |  TRUE  
        { System.out.println("\tPUSHL $1"); } 

    |  FALSE 
        { System.out.println("\tPUSHL $0"); }      

    |  ID    
        { System.out.println("\tPUSHL _"+$1); }

    | '(' exp	')' 

    | '!' exp       
        { gcExpNot(); }

      /* PRÉ-incremento/decremento: ++a, --a */
    | INC ID        
        { gcPreInc($2); }

    | DEC ID        
        { gcPreDec($2); }

      /* PÓS-incremento/decremento: a++, a-- */
    | ID INC        
        { gcPosInc($1); }

    | ID DEC        
        { gcPosDec($1); }

    | ID ADDEQ exp   
        { gcAtribAdd($1); }

    | exp '+' exp		
        { gcExpArit('+'); }

    | exp '-' exp		
        { gcExpArit('-'); }

    | exp '*' exp		
        { gcExpArit('*'); }

    | exp '/' exp		
        { gcExpArit('/'); }

    | exp '%' exp		
        { gcExpArit('%'); }
																			
    | exp '>' exp		
        { gcExpRel('>'); }

    | exp '<' exp		
        { gcExpRel('<'); }											

    | exp EQ  exp		
        { gcExpRel(EQ); }											

    | exp LEQ exp		
        { gcExpRel(LEQ); }											

    | exp GEQ exp		
        { gcExpRel(GEQ); }											

    | exp NEQ exp		
        { gcExpRel(NEQ); }											

    | exp OR  exp		
        { gcExpLog(OR); }											

    | exp AND exp		
        { gcExpLog(AND); }			

    /* condicional ternário: cond ? exp1 : exp2 */
    | exp '?' exp ':' exp 
        { gcTernario(); }

    /* atribuicao como expressao */
    | ID '=' exp          
        { gcAtrib($1); }
		
    ;							


%%

  private Yylex lexer;

  private TabSimb ts = new TabSimb();

  private int strCount = 0;
  private ArrayList<String> strTab = new ArrayList<String>();

  private Stack<Integer> pRot = new Stack<Integer>();
  private int proxRot = 1;

  private Stack<Integer> pBreak = new Stack<Integer>();
  private Stack<Integer> pContinue = new Stack<Integer>();

  private Stack<Integer> pForIncr = new Stack<Integer>();
  private Stack<Integer> pForCond = new Stack<Integer>();
  private Stack<Integer> pForBody = new Stack<Integer>();

  public static int ARRAY = 100;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error + "  linha: " + lexer.getLine());
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }  

  public void setDebug(boolean debug) {
    yydebug = debug;
  }

  public void listarTS() { ts.listar();}

  public static void main(String args[]) throws IOException {

    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
      yyparser.yyparse();
      // yyparser.listarTS();

    }
    else {
      // interactive mode
      System.out.println("\n\tFormato: java Parser entrada.cmm >entrada.s\n");
    }

  }

  void gcExpArit(int oparit) {
    System.out.println("\tPOPL %EBX");
    System.out.println("\tPOPL %EAX");

    switch (oparit) {
      case '+' : System.out.println("\tADDL %EBX, %EAX" ); break;
      case '-' : System.out.println("\tSUBL %EBX, %EAX" ); break;
      case '*' : System.out.println("\tIMULL %EBX, %EAX" ); break;

      case '/': 
        System.out.println("\tMOVL $0, %EDX");
        System.out.println("\tIDIVL %EBX");
        break;

      case '%': 
        System.out.println("\tMOVL $0, %EDX");
        System.out.println("\tIDIVL %EBX");
        System.out.println("\tMOVL %EDX, %EAX");
        break;
    }
    System.out.println("\tPUSHL %EAX");
  }

  /* atribuicao como expressao */
  void gcAtrib(String id) {
    System.out.println("\tPOPL %EDX");           // valor da RHS
    System.out.println("\tMOVL %EDX, _" + id);   // grava na variavel
    System.out.println("\tPUSHL %EDX");          // reempilha valor atribuido
  }

  /* pre/pós incremento/decremento */

  // ++a  -> incrementa a, empilha novo valor
  void gcPreInc(String id) {
    System.out.println("\tMOVL _" + id + ", %EAX");
    System.out.println("\tADDL $1, %EAX");
    System.out.println("\tMOVL %EAX, _" + id);
    System.out.println("\tPUSHL %EAX");
  }

  // --a  -> decrementa a, empilha novo valor
  void gcPreDec(String id) {
    System.out.println("\tMOVL _" + id + ", %EAX");
    System.out.println("\tSUBL $1, %EAX");
    System.out.println("\tMOVL %EAX, _" + id);
    System.out.println("\tPUSHL %EAX");
  }

  // a++  -> empilha valor antigo, depois incrementa variável
  void gcPosInc(String id) {
    System.out.println("\tPUSHL _" + id);          // valor antigo vira resultado da expressão
    System.out.println("\tMOVL _" + id + ", %EAX");
    System.out.println("\tADDL $1, %EAX");
    System.out.println("\tMOVL %EAX, _" + id);
  }

  // a--  -> empilha valor antigo, depois decrementa variável
  void gcPosDec(String id) {
    System.out.println("\tPUSHL _" + id);          // valor antigo vira resultado da expressão
    System.out.println("\tMOVL _" + id + ", %EAX");
    System.out.println("\tSUBL $1, %EAX");
    System.out.println("\tMOVL %EAX, _" + id);
  }

  void gcAtribAdd(String id) {
    System.out.println("\tPOPL %EDX");         // RHS
    System.out.println("\tMOVL _" + id + ", %EAX");  // carrega LHS
    System.out.println("\tADDL %EDX, %EAX");   // soma
    System.out.println("\tMOVL %EAX, _" + id); // grava em id
    System.out.println("\tPUSHL %EAX");        // reempilha resultado
  }

  /* operador condicional ternário (cond ? e1 : e2) */
  void gcTernario() {
    int rFalse = proxRot++;
    int rEnd   = proxRot++;

    // pilha (topo -> base): e2, e1, cond
    System.out.println("\tPOPL %EAX   # expr_falsa");
    System.out.println("\tPOPL %EBX   # expr_verdadeira");
    System.out.println("\tPOPL %ECX   # condicao");
    System.out.println("\tCMPL $0, %ECX");
    System.out.printf ("\tJE rot_%02d\n", rFalse);
    System.out.println("\tMOVL %EBX, %EAX");              // cond != 0 -> resultado = verdadeira
    System.out.printf ("\tJMP rot_%02d\n", rEnd);
    System.out.printf("rot_%02d:\n", rFalse);             // cond == 0 -> fica com falsa em %EAX
    System.out.printf("rot_%02d:\n", rEnd);
    System.out.println("\tPUSHL %EAX");                   // empilha resultado da expressão
  }

  public void gcExpRel(int oprel) {

    System.out.println("\tPOPL %EAX");
    System.out.println("\tPOPL %EDX");
    System.out.println("\tCMPL %EAX, %EDX");
    System.out.println("\tMOVL $0, %EAX");
    
    switch (oprel) {
      case '<':        System.out.println("\tSETL  %AL"); break;
      case '>':        System.out.println("\tSETG  %AL"); break;
      case Parser.EQ:  System.out.println("\tSETE  %AL"); break;
      case Parser.GEQ: System.out.println("\tSETGE %AL"); break;
      case Parser.LEQ: System.out.println("\tSETLE %AL"); break;
      case Parser.NEQ: System.out.println("\tSETNE %AL"); break;
    }
    
    System.out.println("\tPUSHL %EAX");
  }

  public void gcExpLog(int oplog) {

    System.out.println("\tPOPL %EDX");
    System.out.println("\tPOPL %EAX");

    System.out.println("\tCMPL $0, %EAX");
    System.out.println("\tMOVL $0, %EAX");
    System.out.println("\tSETNE %AL");
    System.out.println("\tCMPL $0, %EDX");
    System.out.println("\tMOVL $0, %EDX");
    System.out.println("\tSETNE %DL");

    switch (oplog) {
      case Parser.OR:  
        System.out.println("\tORL  %EDX, %EAX");  
        break;
      case Parser.AND: 
        System.out.println("\tANDL %EDX, %EAX"); 
        break;
    }

    System.out.println("\tPUSHL %EAX");
  }

  public void gcExpNot(){
    System.out.println("\tPOPL %EAX" );
    System.out.println("\tNEGL %EAX" );
    System.out.println("\tPUSHL %EAX");
  }

  private void geraInicio() {
    System.out.println(".text\n\n#\t nome COMPLETO e matricula dos componentes do grupo...\n#\n"); 
    System.out.println(".GLOBL _start\n\n");  
  }

  private void geraFinal(){
	
    System.out.println("\n\n");
    System.out.println("#");
    System.out.println("# devolve o controle para o SO (final da main)");
    System.out.println("#");
    System.out.println("\tmov $0, %ebx");
    System.out.println("\tmov $1, %eax");
    System.out.println("\tint $0x80");
	
    System.out.println("\n");
    System.out.println("#");
    System.out.println("# Funcoes da biblioteca (IO)");
    System.out.println("#");
    System.out.println("\n");
    System.out.println("_writeln:");
    System.out.println("\tMOVL $__fim_msg, %ECX");
    System.out.println("\tDECL %ECX");
    System.out.println("\tMOVB $10, (%ECX)");
    System.out.println("\tMOVL $1, %EDX");
    System.out.println("\tJMP _writeLit");
    System.out.println("_write:");
    System.out.println("\tMOVL $__fim_msg, %ECX");
    System.out.println("\tMOVL $0, %EBX");
    System.out.println("\tCMPL $0, %EAX");
    System.out.println("\tJGE _write3");
    System.out.println("\tNEGL %EAX");
    System.out.println("\tMOVL $1, %EBX");
    System.out.println("_write3:");
    System.out.println("\tPUSHL %EBX");
    System.out.println("\tMOVL $10, %EBX");
    System.out.println("_divide:");
    System.out.println("\tMOVL $0, %EDX");
    System.out.println("\tIDIVL %EBX");
    System.out.println("\tDECL %ECX");
    System.out.println("\tADD $48, %DL");
    System.out.println("\tMOVB %DL, (%ECX)");
    System.out.println("\tCMPL $0, %EAX");
    System.out.println("\tJNE _divide");
    System.out.println("\tPOPL %EBX");
    System.out.println("\tCMPL $0, %EBX");
    System.out.println("\tJE _print");
    System.out.println("\tDECL %ECX");
    System.out.println("\tMOVB $'-', (%ECX)");
    System.out.println("_print:");
    System.out.println("\tMOVL $__fim_msg, %EDX");
    System.out.println("\tSUBL %ECX, %EDX");
    System.out.println("_writeLit:");
    System.out.println("\tMOVL $1, %EBX");
    System.out.println("\tMOVL $4, %EAX");
    System.out.println("\tint $0x80");
    System.out.println("\tRET");
    System.out.println("_read:");
    System.out.println("\tMOVL $15, %EDX");
    System.out.println("\tMOVL $__msg, %ECX");
    System.out.println("\tMOVL $0, %EBX");
    System.out.println("\tMOVL $3, %EAX");
    System.out.println("\tint $0x80");
    System.out.println("\tMOVL $0, %EAX");
    System.out.println("\tMOVL $0, %EBX");
    System.out.println("\tMOVL $0, %EDX");
    System.out.println("\tMOVL $__msg, %ECX");
    System.out.println("\tCMPB $'-', (%ECX)");
    System.out.println("\tJNE _reading");
    System.out.println("\tINCL %ECX");
    System.out.println("\tINC %BL");
    System.out.println("_reading:");
    System.out.println("\tMOVB (%ECX), %DL");
    System.out.println("\tCMP $10, %DL");
    System.out.println("\tJE _fimread");
    System.out.println("\tSUB $48, %DL");
    System.out.println("\tIMULL $10, %EAX");
    System.out.println("\tADDL %EDX, %EAX");
    System.out.println("\tINCL %ECX");
    System.out.println("\tJMP _reading");
    System.out.println("_fimread:");
    System.out.println("\tCMPB $1, %BL");
    System.out.println("\tJNE _fimread2");
    System.out.println("\tNEGL %EAX");
    System.out.println("_fimread2:");
    System.out.println("\tRET");
    System.out.println("\n");
  }

  private void geraAreaDados(){
    System.out.println("");		
    System.out.println("#");
    System.out.println("# area de dados");
    System.out.println("#");
    System.out.println(".data");
    System.out.println("#");
    System.out.println("# variaveis globais");
    System.out.println("#");
    ts.geraGlobais();	
    System.out.println("");
  }

  private void geraAreaLiterais() { 

    System.out.println("#\n# area de literais\n#");
    System.out.println("__msg:");
    System.out.println("\t.zero 30");
    System.out.println("__fim_msg:");
    System.out.println("\t.byte 0");
    System.out.println("\n");

    for (int i = 0; i<strTab.size(); i++ ) {
      System.out.println("_str_"+i+":");
      System.out.println("\t .ascii \""+strTab.get(i)+"\""); 
      System.out.println("_str_"+i+"Len = . - _str_"+i);  
    }		
  }
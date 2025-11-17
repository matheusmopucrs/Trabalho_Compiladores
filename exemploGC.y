%{
  import java.io.*;
  import java.util.ArrayList;
  import java.util.Stack;
  import java.util.HashMap;
%}
 

%token ID, INT, FLOAT, BOOL, NUM, LIT, VOID, MAIN, READ, WRITE, IF, ELSE
%token WHILE,TRUE, FALSE, IF, ELSE
%token DO
%token FOR
%token EQ, LEQ, GEQ, NEQ 
%token AND, OR
%token INC, DEC, ADDEQ
%token BREAK, CONTINUE
%token STRUCT
%token DOT

%right '='
%right '?' ':'        
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

prog :
  { geraInicio(); } dList mainF { geraAreaDados(); geraAreaLiterais(); }
;

mainF :
  VOID MAIN '(' ')' { System.out.println("_start:"); }
  '{' lcmd { geraFinal(); } '}'
;

dList :
  decl dList
  | structDecl dList
  | 
;

structDecl :
  STRUCT ID '{'
    {
      if (procuraStruct($2) != null) {
        yyerror("(sem) struct >" + $2 + "< jah declarada");
      } else {
        structEmConstrucao = new TipoStruct($2);
      }
    }
    structCampos
  '}' ';'
    {
      if (structEmConstrucao != null) {
        tabStruct.add(structEmConstrucao);
        structEmConstrucao = null;
      }
    }
;

structCampos :
  | structCampos structCampo
;

structCampo :
  type ID ';'
    {
      if (structEmConstrucao == null) {
        yyerror("(int) campo struct fora de contexto");
      } else {
        int tamCampo = 4;
        CampoStruct c = new CampoStruct($2, $1, structEmConstrucao.tamanho);
        structEmConstrucao.campos.add(c);
        structEmConstrucao.tamanho += tamCampo;
      }
    }
  | type ID '[' NUM ']' ';'
    {
      if (structEmConstrucao == null) {
        yyerror("(int) campo struct fora de contexto");
      } else {
        int n = Integer.parseInt($4);
        int tamCampo = n * 4;  

        CampoStruct c = new CampoStruct($2, $1, structEmConstrucao.tamanho);

        structEmConstrucao.campos.add(c);
        structEmConstrucao.tamanho += tamCampo;
      }
    }
;

decl :
  type ID ';'
    {
      TS_entry nodo = ts.pesquisa($2);
      if (nodo != null)
        yyerror("(sem) variavel >" + $2 + "< jah declarada");
      else
        ts.insert(new TS_entry($2, $1));
    }

  | type ID '[' NUM ']' ';'
    {
      TS_entry nodo = ts.pesquisa($2);
      if (nodo != null)
        yyerror("(sem) variavel >" + $2 + "< jah declarada");
      else {
        int n = Integer.parseInt($4);

        TS_entry novo = new TS_entry($2, ARRAY, n, $1);
        ts.insert(novo);
      }
    }

  | STRUCT ID ID ';'
    {
      TipoStruct tsDef = procuraStruct($2);
      if (tsDef == null) {
        yyerror("(sem) struct >" + $2 + "< nao declarada");
      } else {
        TS_entry nodo = ts.pesquisa($3);
        if (nodo != null) {
          yyerror("(sem) variavel >" + $3 + "< jah declarada");
        } else {
          TS_entry novo = new TS_entry($3, INT); 
          novo.setTam(tsDef.tamanho);
          ts.insert(novo);

          tipoDaVarStruct.put($3, $2);
        }
      }
    }

  | STRUCT ID ID '[' NUM ']' ';'
    {
      TipoStruct tsDef = procuraStruct($2);
      if (tsDef == null) {
        yyerror("(sem) struct >" + $2 + "< nao declarada");
      } else {
        TS_entry nodo = ts.pesquisa($3);
        if (nodo != null) {
          yyerror("(sem) variavel >" + $3 + "< jah declarada");
        } else {
          int n = Integer.parseInt($5);

          TS_entry novo = new TS_entry($3, ARRAY, n, INT);
          novo.setTam(n * tsDef.tamanho);
          ts.insert(novo);

          tipoDaVarStruct.put($3, $2);
        }
      }
    }
;

type :
  INT    { $$ = INT; }
  | FLOAT  { $$ = FLOAT; }
  | BOOL   { $$ = BOOL; }
;

lcmd :
  lcmd cmd
  |
;

cmd :
  exp ';'

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

  | DO 
    {
      pRot.push(proxRot);            
      pContinue.push(pRot.peek());    
      pBreak.push(pRot.peek()+1);     
      System.out.printf("rot_%02d:\n", pRot.peek());
      proxRot += 2;                   
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

  | WHILE 
    {
      pRot.push(proxRot);         
      proxRot += 2;               
      pContinue.push(pRot.peek());        
      pBreak.push(pRot.peek()+1);        
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

  | FOR '(' for_init ';'
    {
      int Lcond = proxRot++;
      int Lbody = proxRot++;
      int Lcont = proxRot++;
      int Lend  = proxRot++;

      pForCond.push(Lcond);  
      pForBody.push(Lbody);   
      pForIncr.push(Lcont);   
      pBreak.push(Lend);      
      pContinue.push(Lcont);  

      System.out.printf("\tJMP rot_%02d\n", Lcond);
    }
    for_cond ';'
    for_incr ')'
    {
      System.out.printf("rot_%02d:\n", pForBody.peek());
    }
    cmd
    {
      System.out.printf("\tJMP rot_%02d\n", pForIncr.peek());

      System.out.printf("rot_%02d:\n", pBreak.peek());

      pForIncr.pop();
      pForCond.pop();
      pForBody.pop();
      pBreak.pop();
      pContinue.pop();
    }

  | ID DOT ID '=' exp ';'
    {
      gcAtribField($1, $3);
    }

  | ID '[' exp ']' '=' exp ';'
    {
      gcAtribArray($1);
    }
;

restoIf :
  ELSE  
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

for_init :
  | exp  
    { 
      System.out.println("\tPOPL %EAX   # descarta resultado da inicializacao do for"); 
    }
;

for_cond :
    {
      int Lcond = pForCond.peek();
      int Lbody = pForBody.peek();
      System.out.printf("rot_%02d:\n", Lcond);
      System.out.printf("\tJMP rot_%02d\n", Lbody);
    }
  |
    { 
      int Lcond = pForCond.peek();
      System.out.printf("rot_%02d:\n", Lcond);
    }
    exp
    {
      System.out.println("\tPOPL %EAX   # condicao do for");
      System.out.println("\tCMPL $0, %EAX");
      System.out.printf("\tJE rot_%02d\n", pBreak.peek());      
      System.out.printf("\tJMP rot_%02d\n", pForBody.peek());   
    }
;

for_incr :
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

exp :
  NUM   
    { System.out.println("\tPUSHL $"+$1); } 

  | TRUE  
    { System.out.println("\tPUSHL $1"); } 

  | FALSE 
    { System.out.println("\tPUSHL $0"); }      

  | ID    
    { System.out.println("\tPUSHL _"+$1); }

  | ID DOT ID
    { gcLoadField($1, $3); }

  | ID '[' exp ']'
    { gcLoadArrayElem($1); }

  | '(' exp ')'

  | '!' exp       
    { gcExpNot(); }

  | INC ID        
    { gcPreInc($2); }

  | DEC ID        
    { gcPreDec($2); }

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

  | exp '?' exp ':' exp 
    { gcTernario(); }

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

// --------- SUPORTE A STRUCT ---------

private HashMap<String,String> tipoDaVarStruct = new HashMap<String,String>();

class CampoStruct {
  String nome;
  int    tipo;  
  int    offset;

  CampoStruct(String n, int t, int o) {
    nome = n;
    tipo = t;
    offset = o;
  }
}

class TipoStruct {
  String nome;
  ArrayList<CampoStruct> campos = new ArrayList<CampoStruct>();
  int tamanho; 

  TipoStruct(String n) {
    nome = n;
    tamanho = 0;
  }
}

private ArrayList<TipoStruct> tabStruct = new ArrayList<TipoStruct>();

private TipoStruct structEmConstrucao = null;

private TipoStruct procuraStruct(String nome) {
  for (TipoStruct ts : tabStruct) {
    if (ts.nome.equals(nome)) return ts;
  }
  return null;
}

private CampoStruct procuraCampo(TipoStruct ts, String campo) {
  for (CampoStruct c : ts.campos) {
    if (c.nome.equals(campo)) return c;
  }
  return null;
}

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
    yyparser = new Parser(new FileReader(args[0]));
    yyparser.yyparse();

  }
  else {
    System.out.println("\n\tFormato: java Parser entrada.cmm >entrada.s\n");
  }

}

// --- ARRAYS DE INTEIROS ---

void gcLoadArrayElem(String id) {
  System.out.println("\tPOPL %ECX");               
  System.out.println("\tMOVL _" + id + "(,%ECX,4), %EAX");
  System.out.println("\tPUSHL %EAX");
}


void gcAtribArray(String id) {
  System.out.println("\tPOPL %EAX");               
  System.out.println("\tPOPL %ECX");               
  System.out.println("\tMOVL %EAX, _" + id + "(,%ECX,4)");
}

void gcLoadField(String idVar, String idCampo) {
  String nomeStruct = tipoDaVarStruct.get(idVar);
  if (nomeStruct == null) {
    yyerror("(sem) variavel struct >" + idVar + "< nao tem tipo struct associado");
    return;
  }

  TipoStruct tsDef = procuraStruct(nomeStruct);
  if (tsDef == null) {
    yyerror("(sem) tipo struct >" + nomeStruct + "< nao encontrado");
    return;
  }

  CampoStruct campo = procuraCampo(tsDef, idCampo);
  if (campo == null) {
    yyerror("(sem) campo >" + idCampo + "< nao existe em struct " + nomeStruct);
    return;
  }

  int off = campo.offset;

  System.out.println("\tMOVL _" + idVar + " + " + off + ", %EAX");
  System.out.println("\tPUSHL %EAX");
}

void gcAtribField(String idVar, String idCampo) {
  String nomeStruct = tipoDaVarStruct.get(idVar);
  if (nomeStruct == null) {
    yyerror("(sem) variavel struct >" + idVar + "< nao tem tipo struct associado");
    return;
  }

  TipoStruct tsDef = procuraStruct(nomeStruct);
  if (tsDef == null) {
    yyerror("(sem) tipo struct >" + nomeStruct + "< nao encontrado");
    return;
  }

  CampoStruct campo = procuraCampo(tsDef, idCampo);
  if (campo == null) {
    yyerror("(sem) campo >" + idCampo + "< nao existe em struct " + nomeStruct);
    return;
  }

  int off = campo.offset;

  System.out.println("\tPOPL %EAX");
  System.out.println("\tMOVL %EAX, _" + idVar + " + " + off);
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

void gcAtrib(String id) {
  System.out.println("\tPOPL %EDX");           
  System.out.println("\tMOVL %EDX, _" + id);   
  System.out.println("\tPUSHL %EDX");          
}

void gcPreInc(String id) {
  System.out.println("\tMOVL _" + id + ", %EAX");
  System.out.println("\tADDL $1, %EAX");
  System.out.println("\tMOVL %EAX, _" + id);
  System.out.println("\tPUSHL %EAX");
}

void gcPreDec(String id) {
  System.out.println("\tMOVL _" + id + ", %EAX");
  System.out.println("\tSUBL $1, %EAX");
  System.out.println("\tMOVL %EAX, _" + id);
  System.out.println("\tPUSHL %EAX");
}

void gcPosInc(String id) {
  System.out.println("\tPUSHL _" + id);          
  System.out.println("\tMOVL _" + id + ", %EAX");
  System.out.println("\tADDL $1, %EAX");
  System.out.println("\tMOVL %EAX, _" + id);
}

void gcPosDec(String id) {
  System.out.println("\tPUSHL _" + id);          
  System.out.println("\tMOVL _" + id + ", %EAX");
  System.out.println("\tSUBL $1, %EAX");
  System.out.println("\tMOVL %EAX, _" + id);
}

void gcAtribAdd(String id) {
  System.out.println("\tPOPL %EDX");         
  System.out.println("\tMOVL _" + id + ", %EAX");  
  System.out.println("\tADDL %EDX, %EAX");   
  System.out.println("\tMOVL %EAX, _" + id); 
  System.out.println("\tPUSHL %EAX");        
}

void gcTernario() {
  int rFalse = proxRot++;
  int rEnd   = proxRot++;

  System.out.println("\tPOPL %EAX   # expr_falsa");
  System.out.println("\tPOPL %EBX   # expr_verdadeira");
  System.out.println("\tPOPL %ECX   # condicao");
  System.out.println("\tCMPL $0, %ECX");
  System.out.printf ("\tJE rot_%02d\n", rFalse);
  System.out.println("\tMOVL %EBX, %EAX");              
  System.out.printf ("\tJMP rot_%02d\n", rEnd);
  System.out.printf("rot_%02d:\n", rFalse);             
  System.out.printf("rot_%02d:\n", rEnd);
  System.out.println("\tPUSHL %EAX");                   
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

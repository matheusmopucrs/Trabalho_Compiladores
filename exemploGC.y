%{
  import java.io.*;
  import java.util.ArrayList;
  import java.util.Stack;
  import java.io.ByteArrayOutputStream;
  import java.io.PrintStream;
%}

/* ---------- TOKENS ---------- */
%token ID INT FLOAT BOOL NUM LIT VOID MAIN READ WRITE IF ELSE DO FOR
%token WHILE TRUE FALSE
%token EQ LEQ GEQ NEQ
%token AND OR
%token INC DEC
%token PLUSEQ MINUSEQ MULEQ DIVEQ MODEQ
%token BREAK CONTINUE          /* ADICIONADO */

%right '=' PLUSEQ MINUSEQ MULEQ DIVEQ MODEQ
%right '?' ':'            /* operador condicional */
%left OR
%left AND
%left '>' '<' EQ LEQ GEQ NEQ
%left '+' '-'
%left '*' '/' '%'
%left '!' INC DEC

/* ---------- TIPOS SEMÂNTICOS ---------- */
%type <sval> ID LIT NUM
%type <sval> for_cond for_update
%type <ival> type
%%
/* --- PROGRAMA --- */
prog : { geraInicio(); } dList mainF { geraAreaDados(); geraAreaLiterais(); } ;

/* --- FUNÇÃO MAIN --- */
mainF : VOID MAIN '(' ')' { System.out.println("_start:"); }
      '{' lcmd { geraFinal(); } '}'  ;

/* --- DECLARAÇÕES --- */
dList : decl dList | ;
decl : type ID ';' {
          TS_entry nodo = ts.pesquisa($2);
          if (nodo != null)
              yyerror("(sem) variavel >" + $2 + "< jah declarada");
          else ts.insert(new TS_entry($2, $1));
        } ;
type : INT   { $$ = INT; }
     | FLOAT { $$ = FLOAT; }
     | BOOL  { $$ = BOOL; } ;

/* --- COMANDOS --- */
lcmd : lcmd cmd | ;
cmd : exp ';' {
        /* Consome o valor da expressão da pilha para evitar lixo e stack imbalance. */
        System.out.println("\tPOPL %EAX");
      }
    | WRITE '(' LIT ',' exp ')' ';' {
          strTab.add($3);
          System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX");
          System.out.println("\tMOVL $_str_"+strCount+", %ECX");
          System.out.println("\tCALL _writeLit");
          strCount++;
          System.out.println("\tPOPL %EAX");
          System.out.println("\tCALL _write");
          System.out.println("\tCALL _writeln");
      }
    | WRITE '(' LIT ')' ';' {
          strTab.add($3);
          System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX");
          System.out.println("\tMOVL $_str_"+strCount+", %ECX");
          System.out.println("\tCALL _writeLit");
          System.out.println("\tCALL _writeln");
          strCount++;
      }
    | READ '(' ID ')' ';' {
          System.out.println("\tPUSHL $_"+$3);
          System.out.println("\tCALL _read");
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL %EAX, (%EDX)");
      }
    | WHILE {
          /* Aloca 3 rótulos: base (teste), base+1 (fim/break), base+2 (continue) */
          int base = proxRot;
          proxRot += 3;
          pRot.push(base);
          System.out.printf("rot_%02d:\n", base);     /* Rótulo de início (teste) */
          /* NÃO imprimir rot_base+2 aqui - será impresso no lugar certo ao gerar continue/update */
      } '(' exp ')' {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tCMPL $0, %EAX");
          System.out.printf("\tJE rot_%02d\n", pRot.peek() + 1); /* Salto p/ fim (break) */
      } cmd {
          System.out.printf("\tJMP rot_%02d\n", pRot.peek()); /* Volta ao início (base) */
          System.out.printf("rot_%02d:\n", pRot.peek() + 1); /* Rótulo de fim (break) */
          pRot.pop();
      }
    | DO {
          /* Aloca 3 rótulos: base (corpo), base+1 (fim/break), base+2 (teste/continue) */
          int base = proxRot;
          proxRot += 3;
          pRot.push(base);
          System.out.printf("rot_%02d:\n", base); /* Início do corpo */
      } cmd {
          /* Destino do 'continue' será o teste/atualização (rot_base+2) -- imprimimos esse rótulo aqui */
          System.out.printf("rot_%02d:\n", pRot.peek() + 2); /* Destino do 'continue' */
      } WHILE '(' exp ')' ';' {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tCMPL $0, %EAX");
          System.out.printf("\tJNE rot_%02d\n", pRot.peek());     /* Volta ao início (base) */
          System.out.printf("rot_%02d:\n", pRot.peek() + 1); /* Rótulo de fim (break) */
          pRot.pop();
      }

    /* -------- FOR (corrigido e integrado) -------- */
    | FOR '(' for_init ';' for_cond ';' for_update ')' 
      {
          /* determina base de rótulos para este for: start=base, end=base+1, update=base+2 */
          int base = proxRot;
          proxRot += 3;
          pRot.push(base);

          /* rótulo de início do loop */
          System.out.printf("rot_%02d:\n", base);

          /* condição (pode ser vazia -> for(;;)) */
          if (!currentCondCode.equals("")) {
              System.out.print(currentCondCode);
              System.out.println("\tPOPL %EAX");
              System.out.println("\tCMPL $0, %EAX");
              System.out.printf("\tJE rot_%02d\n", base + 1); /* salta para fim do loop */
          }
      }
      cmd
      {
          /* ao terminar o corpo, rótulo de update (usado por 'continue') */
          int base = pRot.peek();
          System.out.printf("rot_%02d:\n", base + 2);          /* rot_base_update */
          /* imprime update (se houver) */
          System.out.print(currentUpdateCode);
          System.out.printf("\tJMP rot_%02d\n", base);        /* volta ao início */
          System.out.printf("rot_%02d:\n", base + 1);         /* rótulo de saída (fim do loop) */

          pRot.pop();
          currentCondCode = "";
          currentUpdateCode = "";
      }

    | IF '(' exp {
          /* Use pilha separada para IFs para não conflitar com pRot (que é usada por laços) */
          pIf.push(proxRot); proxRot += 2;
          System.out.println("\tPOPL %EAX");
          System.out.println("\tCMPL $0, %EAX");
          System.out.printf("\tJE rot_%02d\n", pIf.peek());
      } ')' cmd restoIf {
          System.out.printf("rot_%02d:\n", pIf.peek() + 1);
          pIf.pop();
      }
    | '{' lcmd '}'
    | BREAK ';' {
          if (pRot.isEmpty())
              yyerror("break fora de laco");
          else {
              /* Salta para o rótulo de FIM (base+1) */
              System.out.printf("\tJMP rot_%02d\n", pRot.peek() + 1);
          }
      }
    | CONTINUE ';' {
          if (pRot.isEmpty())
              yyerror("continue fora de laco");
          else {
              /* Salta para o rótulo de UPDATE/TESTE (base+2) */
              System.out.printf("\tJMP rot_%02d\n", pRot.peek() + 2);
          }
      }
    ;

/* ----------------- FOR helpers ----------------- */
for_init :
      exp {
          /* consome o valor que a expressão deixou na pilha (para não deixar lixo) */
          System.out.println("\tPOPL %EAX");
      }
    | /* vazio */ ;

for_cond :
      {
          /* captura a saída do System.out gerada pela avaliação da condição */
          condBaos = new ByteArrayOutputStream();
          condOldOut = System.out;
          System.setOut(new PrintStream(condBaos));
      } 
      exp 
      {
          System.setOut(condOldOut);
          /* remove eventual PUSHL final deixado pela expressão (evita empilhar lixo toda iteração) */
          String code = condBaos.toString();
          int idx = code.lastIndexOf("\n\tPUSHL %EAX");
          if (idx >= 0) {
              /* remove o PUSHL final (mantém newline anterior) */
              code = code.substring(0, idx);
              if (!code.endsWith("\n")) code += "\n";
          }
          currentCondCode = code;
      }
    | {
          currentCondCode = "";
      }
    ;

for_update :
      {
          /* captura update (para imprimir somente após o corpo) */
          updateBaos = new ByteArrayOutputStream();
          updateOldOut = System.out;
          System.setOut(new PrintStream(updateBaos));
      } 
      exp 
      {
          System.setOut(updateOldOut);
          /* remove eventual PUSHL final deixado pela expressão (evita empilhar lixo) */
          String code = updateBaos.toString();
          int idx = code.lastIndexOf("\n\tPUSHL %EAX");
          if (idx >= 0) {
              code = code.substring(0, idx);
              if (!code.endsWith("\n")) code += "\n";
          }
          currentUpdateCode = code;
      }
    | {
          currentUpdateCode = "";
      }
    ;

/* --- RESTO IF --- */
restoIf : ELSE {
          System.out.printf("\tJMP rot_%02d\n", pIf.peek() + 1);
          System.out.printf("rot_%02d:\n", pIf.peek());
      } cmd
        | {
          System.out.printf("\tJMP rot_%02d\n", pIf.peek() + 1);
          System.out.printf("rot_%02d:\n", pIf.peek());
      }
      ;

/* --- LVALUE (apenas endereço) --- */
lvalue : ID { System.out.println("\tPUSHL $_"+$1); } ;

/* --- EXPRESSÕES --- */
exp : NUM { System.out.println("\tPUSHL $"+$1); }
    | TRUE { System.out.println("\tPUSHL $1"); }
    | FALSE { System.out.println("\tPUSHL $0"); }
    | ID { System.out.println("\tPUSHL _"+$1); }
    | '(' exp ')'
    | '!' exp { gcExpNot(); }
    /* PRÉ-INCREMENTO */
    | INC ID {
          System.out.println("\tPUSHL $_"+$2);
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL (%EDX), %EAX");
          System.out.println("\tADDL $1, %EAX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tPUSHL %EAX");
      }
    /* PRÉ-DECREMENTO */
    | DEC ID {
          System.out.println("\tPUSHL $_"+$2);
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL (%EDX), %EAX");
          System.out.println("\tSUBL $1, %EAX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tPUSHL %EAX");
      }
    /* PÓS-INCREMENTO */
    | ID INC {
          System.out.println("\tPUSHL _"+$1);
          System.out.println("\tPUSHL $_"+$1);
          System.out.println("\tPOPL %EDX");
          System.out.println("\tPOPL %EAX");
          System.out.println("\tADDL $1, %EAX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tSUBL $1, %EAX");
          System.out.println("\tPUSHL %EAX");
      }
    /* PÓS-DECREMENTO */
    | ID DEC {
          System.out.println("\tPUSHL _"+$1);
          System.out.println("\tPUSHL $_"+$1);
          System.out.println("\tPOPL %EDX");
          System.out.println("\tPOPL %EAX");
          System.out.println("\tSUBL $1, %EAX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tADDL $1, %EAX");
          System.out.println("\tPUSHL %EAX");
      }
    /* ATRIBUIÇÃO SIMPLES */
    | lvalue '=' exp {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tPUSHL %EAX");
      }
    /* ATRIBUIÇÕES COMPOSTAS */
    | lvalue PLUSEQ exp {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tPOPL %EDX");
          System.out.println("\tADDL (%EDX), %EAX");
          System.out.println("\tMOVL %EAX, (%EDX)");
          System.out.println("\tPUSHL %EAX");
      }
    | lvalue MINUSEQ exp {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL (%EDX), %EBX");
          System.out.println("\tSUBL %EAX, %EBX");
          System.out.println("\tMOVL %EBX, (%EDX)");
          System.out.println("\tPUSHL %EBX");
      }
    | lvalue MULEQ exp {
          System.out.println("\tPOPL %EAX");
          System.out.println("\tPOPL %EDX");
          System.out.println("\tMOVL (%EDX), %EBX");
          System.out.println("\tIMULL %EAX, %EBX");
          System.out.println("\tMOVL %EBX, (%EDX)");
          System.out.println("\tPUSHL %EBX");
      }
    | lvalue DIVEQ exp {
          /* Preserve endereço em %EBX; divisor em %ECX */
          System.out.println("\tPOPL %ECX"); /* divisor */
          System.out.println("\tPOPL %EBX"); /* endereço */
          System.out.println("\tMOVL (%EBX), %EAX");
          System.out.println("\tMOVL $0, %EDX");
          System.out.println("\tIDIVL %ECX");
          System.out.println("\tMOVL %EAX, (%EBX)");
          System.out.println("\tPUSHL %EAX");
      }
    | lvalue MODEQ exp {
          /* Preserve endereço em %EBX; divisor em %ECX */
          System.out.println("\tPOPL %ECX"); /* divisor */
          System.out.println("\tPOPL %EBX"); /* endereço */
          System.out.println("\tMOVL (%EBX), %EAX");
          System.out.println("\tMOVL $0, %EDX");
          System.out.println("\tIDIVL %ECX");
          System.out.println("\tMOVL %EDX, %EAX"); /* resto em EAX */
          System.out.println("\tMOVL %EAX, (%EBX)");
          System.out.println("\tPUSHL %EAX");
      }
    /* OPERADOR CONDICIONAL (?:) - usa rótulos locais sem empilhar em pRot/pIf */
    | exp '?' exp ':' exp {
          System.out.println("\tPOPL %EAX"); // exp_false
          System.out.println("\tPOPL %EBX"); // exp_true
          System.out.println("\tPOPL %ECX"); // cond
          System.out.println("\tCMPL $0, %ECX");
          int _base = proxRot; proxRot += 2;
          System.out.printf("\tJE rot_%02d\n", _base);
          System.out.println("\tMOVL %EBX, %EAX");
          System.out.printf("\tJMP rot_%02d\n", _base + 1);
          System.out.printf("rot_%02d:\n", _base);
          /* nada a fazer além de deixar EAX com o valor correto (exp_false já estava em EAX) */
          System.out.printf("rot_%02d:\n", _base + 1);
          System.out.println("\tPUSHL %EAX");
      }
    /* OPERAÇÕES ARITMÉTICAS */
    | exp '+' exp { gcExpArit('+'); }
    | exp '-' exp { gcExpArit('-'); }
    | exp '*' exp { gcExpArit('*'); }
    | exp '/' exp { gcExpArit('/'); }
    | exp '%' exp { gcExpArit('%'); }
    /* RELACIONAIS */
    | exp '>' exp { gcExpRel('>'); }
    | exp '<' exp { gcExpRel('<'); }
    | exp EQ exp { gcExpRel(EQ); }
    | exp LEQ exp { gcExpRel(LEQ); }
    | exp GEQ exp { gcExpRel(GEQ); }
    | exp NEQ exp { gcExpRel(NEQ); }
    /* LÓGICAS */
    | exp OR exp { gcExpLog(OR); }
    | exp AND exp { gcExpLog(AND); }
    ;
%%
/* ---------- ATRIBUTOS E MÉTODOS JAVA ---------- */
private Yylex lexer;
private TabSimb ts = new TabSimb();
private int strCount = 0;
private ArrayList<String> strTab = new ArrayList<>();
private Stack<Integer> pRot = new Stack<>();   /* pilha para laços (for/while/do) */
private Stack<Integer> pIf  = new Stack<>();   /* pilha separada para IF/ELSE rótulos */
private int proxRot = 1;
private String currentCondCode = "";
private String currentUpdateCode = "";
private ByteArrayOutputStream condBaos;
private PrintStream condOldOut;
private ByteArrayOutputStream updateBaos;
private PrintStream updateOldOut;

private int yylex() {
    int ret;
    try {
        yylval = new ParserVal(0);
        ret = lexer.yylex();
    } catch (IOException e) {
        System.err.println("IO error: " + e);
        ret = -1;
    }
    return ret;
}
public void yyerror(String s) {
    System.err.println("Error: " + s + " linha: " + lexer.getLine());
}
public Parser(Reader r) {
    lexer = new Yylex(r, this);
}
public void setDebug(boolean d) { yydebug = d; }
public void listarTS() { ts.listar(); }
public static void main(String[] args) throws IOException {
    if (args.length > 0) {
        new Parser(new FileReader(args[0])).yyparse();
    } else {
        System.out.println("Uso: java Parser arquivo.cmm > arquivo.s");
    }
}

/* ---------- GERAÇÃO DE CÓDIGO ---------- */
void gcExpArit(int op) {
    System.out.println("\tPOPL %EBX");
    System.out.println("\tPOPL %EAX");
    switch (op) {
        case '+': System.out.println("\tADDL %EBX, %EAX"); break;
        case '-': System.out.println("\tSUBL %EBX, %EAX"); break;
        case '*': System.out.println("\tIMULL %EBX, %EAX"); break;
        case '/': case '%':
            System.out.println("\tMOVL $0, %EDX");
            System.out.println("\tIDIVL %EBX");
            if (op == '%') System.out.println("\tMOVL %EDX, %EAX");
            break;
    }
    System.out.println("\tPUSHL %EAX");
}
public void gcExpRel(int op) {
    System.out.println("\tPOPL %EAX");
    System.out.println("\tPOPL %EDX");
    System.out.println("\tCMPL %EAX, %EDX");
    System.out.println("\tMOVL $0, %EAX");
    switch (op) {
        case '<': System.out.println("\tSETL %AL"); break;
        case '>': System.out.println("\tSETG %AL"); break;
        case Parser.EQ: System.out.println("\tSETE %AL"); break;
        case Parser.GEQ: System.out.println("\tSETGE %AL"); break;
        case Parser.LEQ: System.out.println("\tSETLE %AL"); break;
        case Parser.NEQ: System.out.println("\tSETNE %AL"); break;
    }
    System.out.println("\tPUSHL %EAX");
}
public void gcExpLog(int op) {
    System.out.println("\tPOPL %EDX");
    System.out.println("\tPOPL %EAX");
    System.out.println("\tCMPL $0, %EAX");
    System.out.println("\tMOVL $0, %EAX");
    System.out.println("\tSETNE %AL");
    System.out.println("\tCMPL $0, %EDX");
    System.out.println("\tMOVL $0, %EDX");
    System.out.println("\tSETNE %DL");
    if (op == Parser.OR) System.out.println("\tORL %EDX, %EAX");
    else System.out.println("\tANDL %EDX, %EAX");
    System.out.println("\tPUSHL %EAX");
}
public void gcExpNot() {
    System.out.println("\tPOPL %EAX");
    System.out.println("\tNEGL %EAX");
    System.out.println("\tPUSHL %EAX");
}
private void geraInicio() {
    System.out.println(".text\n.GLOBL _start\n");
}
private void geraFinal() {
    System.out.println("\n\tmov $0, %ebx");
    System.out.println("\tmov $1, %eax");
    System.out.println("\tint $0x80\n");
    // Biblioteca IO
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
}
private void geraAreaDados() {
    System.out.println(".data");
    ts.geraGlobais();
}
private void geraAreaLiterais() {
    System.out.println("__msg:\t.zero 30");
    System.out.println("__fim_msg:\t.byte 0\n");
    for (int i = 0; i < strTab.size(); i++) {
        System.out.printf("_str_%d:\t.ascii \"%s\"\n", i, strTab.get(i));
        System.out.printf("_str_%dLen = . - _str_%d\n", i, i);
    }
}

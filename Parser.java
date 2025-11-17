//### This file created by BYACC 1.8(/Java extension  1.15)
//### Java capabilities added 7 Jan 97, Bob Jamison
//### Updated : 27 Nov 97  -- Bob Jamison, Joe Nieten
//###           01 Jan 98  -- Bob Jamison -- fixed generic semantic constructor
//###           01 Jun 99  -- Bob Jamison -- added Runnable support
//###           06 Aug 00  -- Bob Jamison -- made state variables class-global
//###           03 Jan 01  -- Bob Jamison -- improved flags, tracing
//###           16 May 01  -- Bob Jamison -- added custom stack sizing
//###           04 Mar 02  -- Yuval Oren  -- improved java performance, added options
//###           14 Mar 02  -- Tomas Hurka -- -d support, static initializer workaround
//### Please send bug reports to tom@hukatronic.cz
//### static char yysccsid[] = "@(#)yaccpar	1.8 (Berkeley) 01/20/90";






//#line 2 "exemploGC.y"
  import java.io.*;
  import java.util.ArrayList;
  import java.util.Stack;
//#line 21 "Parser.java"




public class Parser
{

boolean yydebug;        //do I want debug output?
int yynerrs;            //number of errors so far
int yyerrflag;          //was there an error?
int yychar;             //the current working character

//########## MESSAGES ##########
//###############################################################
// method: debug
//###############################################################
void debug(String msg)
{
  if (yydebug)
    System.out.println(msg);
}

//########## STATE STACK ##########
final static int YYSTACKSIZE = 500;  //maximum stack size
int statestk[] = new int[YYSTACKSIZE]; //state stack
int stateptr;
int stateptrmax;                     //highest index of stackptr
int statemax;                        //state when highest index reached
//###############################################################
// methods: state stack push,pop,drop,peek
//###############################################################
final void state_push(int state)
{
  try {
		stateptr++;
		statestk[stateptr]=state;
	 }
	 catch (ArrayIndexOutOfBoundsException e) {
     int oldsize = statestk.length;
     int newsize = oldsize * 2;
     int[] newstack = new int[newsize];
     System.arraycopy(statestk,0,newstack,0,oldsize);
     statestk = newstack;
     statestk[stateptr]=state;
  }
}
final int state_pop()
{
  return statestk[stateptr--];
}
final void state_drop(int cnt)
{
  stateptr -= cnt; 
}
final int state_peek(int relative)
{
  return statestk[stateptr-relative];
}
//###############################################################
// method: init_stacks : allocate and prepare stacks
//###############################################################
final boolean init_stacks()
{
  stateptr = -1;
  val_init();
  return true;
}
//###############################################################
// method: dump_stacks : show n levels of the stacks
//###############################################################
void dump_stacks(int count)
{
int i;
  System.out.println("=index==state====value=     s:"+stateptr+"  v:"+valptr);
  for (i=0;i<count;i++)
    System.out.println(" "+i+"    "+statestk[i]+"      "+valstk[i]);
  System.out.println("======================");
}


//########## SEMANTIC VALUES ##########
//public class ParserVal is defined in ParserVal.java


String   yytext;//user variable to return contextual strings
ParserVal yyval; //used to return semantic vals from action routines
ParserVal yylval;//the 'lval' (result) I got from yylex()
ParserVal valstk[];
int valptr;
//###############################################################
// methods: value stack push,pop,drop,peek.
//###############################################################
void val_init()
{
  valstk=new ParserVal[YYSTACKSIZE];
  yyval=new ParserVal();
  yylval=new ParserVal();
  valptr=-1;
}
void val_push(ParserVal val)
{
  if (valptr>=YYSTACKSIZE)
    return;
  valstk[++valptr]=val;
}
ParserVal val_pop()
{
  if (valptr<0)
    return new ParserVal();
  return valstk[valptr--];
}
void val_drop(int cnt)
{
int ptr;
  ptr=valptr-cnt;
  if (ptr<0)
    return;
  valptr = ptr;
}
ParserVal val_peek(int relative)
{
int ptr;
  ptr=valptr-relative;
  if (ptr<0)
    return new ParserVal();
  return valstk[ptr];
}
final ParserVal dup_yyval(ParserVal val)
{
  ParserVal dup = new ParserVal();
  dup.ival = val.ival;
  dup.dval = val.dval;
  dup.sval = val.sval;
  dup.obj = val.obj;
  return dup;
}
//#### end semantic value section ####
public final static short ID=257;
public final static short INT=258;
public final static short FLOAT=259;
public final static short BOOL=260;
public final static short NUM=261;
public final static short LIT=262;
public final static short VOID=263;
public final static short MAIN=264;
public final static short READ=265;
public final static short WRITE=266;
public final static short IF=267;
public final static short ELSE=268;
public final static short WHILE=269;
public final static short TRUE=270;
public final static short FALSE=271;
public final static short DO=272;
public final static short FOR=273;
public final static short EQ=274;
public final static short LEQ=275;
public final static short GEQ=276;
public final static short NEQ=277;
public final static short AND=278;
public final static short OR=279;
public final static short INC=280;
public final static short DEC=281;
public final static short ADDEQ=282;
public final static short BREAK=283;
public final static short CONTINUE=284;
public final static short YYERRCODE=256;
final static short yylhs[] = {                           -1,
    3,    0,    5,    7,    4,    2,    2,    8,    1,    1,
    1,    6,    6,    9,    9,    9,   11,    9,    9,    9,
    9,   12,    9,   13,   14,    9,   15,    9,   19,   21,
    9,   22,   16,   16,   17,   17,   18,   23,   18,   20,
   24,   20,   10,   10,   10,   10,   10,   10,   10,   10,
   10,   10,   10,   10,   10,   10,   10,   10,   10,   10,
   10,   10,   10,   10,   10,   10,   10,   10,
};
final static short yylen[] = {                            2,
    0,    3,    0,    0,    9,    2,    0,    3,    1,    1,
    1,    2,    0,    2,    3,    5,    0,    8,    5,    2,
    2,    0,    8,    0,    0,    7,    0,    7,    0,    0,
   11,    0,    3,    0,    0,    1,    0,    0,    2,    0,
    0,    2,    1,    1,    1,    1,    3,    2,    2,    2,
    2,    2,    3,    3,    3,    3,    3,    3,    3,    3,
    3,    3,    3,    3,    3,    3,    5,    3,
};
final static short yydefred[] = {                         1,
    0,    0,    9,   10,   11,    0,    0,    0,    0,    0,
    2,    6,    8,    0,    0,    3,    0,   13,    0,    0,
   43,    0,    0,    0,   24,   44,   45,   22,    0,    0,
    0,    0,    0,    0,    0,   13,    0,   12,    0,   51,
   52,    0,    0,    0,    0,    0,    0,    0,    0,   49,
   50,   20,   21,   48,    0,    0,    5,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   14,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   47,   15,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   56,   57,   58,    0,    0,    0,
    0,    0,    0,   29,    0,   19,   16,    0,    0,   25,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   32,   28,   26,    0,    0,    0,   18,    0,   23,    0,
    0,   33,   30,    0,    0,   31,
};
final static short yydgoto[] = {                          1,
    6,    7,    2,   11,   17,   19,   37,    8,   38,   39,
  100,   48,   47,  116,  101,  122,   81,  118,  112,  130,
  135,  128,  119,  131,
};
final static short yysindex[] = {                         0,
    0, -234,    0,    0,    0, -253, -248, -234,  -49, -247,
    0,    0,    0,  -22,   -4,    0,  -85,    0,    9,  -55,
    0,   -1,    1,    3,    0,    0,    0,    0,    4, -211,
 -210,  -11,   -9,   51,   51,    0,  -74,    0,   83,    0,
    0,   51,   51, -205, -209,   51,   14,    9,   51,    0,
    0,    0,    0,    0,   92,  -33,    0,   51,   51,   51,
   51,   51,   51,   51,   51,   51,   51,   51,   51,   51,
   51,    0,  159,  159,   15,   16,  159,   51, -214,  159,
    2,    0,    0,  -34,  -34,  -34,  -34,  303,   52,  114,
  -34,  -34,   -2,   -2,    0,    0,    0,    5,    6,   19,
   17,  121,   20,    0,   51,    0,    0,   51,    9,    0,
   51,    0,  159,  128, -200,    9,  152,   11,   51,   12,
    0,    0,    0,   13,    0,  159,    0,    9,    0,   32,
   51,    0,    0,  159,    9,    0,
};
final static short yyrindex[] = {                         0,
    0, -187,    0,    0,    0,    0,    0, -187,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,  -48,   59,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   21,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,  -39,  -29,    0,   35,   37,    0,    0,   23,
    0,    0,    0,  314,  323,  353,  360,  -36,  -27,    0,
  410,  418,  398,  404,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   26,  -25,    0,  -12,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   34,   24,    0,    0,    0,    0,
    0,    0,    0,   45,    0,    0,
};
final static short yygindex[] = {                         0,
    0,   79,    0,    0,    0,   57,    0,    0,  -47,  440,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,
};
final static int YYTABLESIZE=697;
static short yytable[];
static { yytable();}
static void yytable(){
yytable = new short[]{                         34,
   79,   53,   71,    9,   66,   43,   35,   69,   67,   13,
   68,   68,   70,   65,   10,   67,   14,   15,   53,   53,
   34,   66,   66,    3,    4,    5,   66,   34,   68,   68,
   65,   65,   67,   67,   71,   65,   16,   18,   44,   69,
   45,   34,   46,   49,   70,   50,   51,   52,   35,   53,
   57,   75,   76,   78,  103,   98,   99,  109,   38,  111,
  104,  115,  108,  106,  107,   38,   41,  121,  123,  125,
  127,  129,  133,   41,   40,    7,    4,   27,   17,   35,
  132,   36,   39,   34,   37,   42,   12,  136,   71,   36,
   35,   83,   56,   69,   67,   46,   68,    0,   70,   46,
   46,   46,    0,   46,    0,   46,    0,    0,    0,    0,
   34,   66,   34,   65,    0,    0,   46,   46,   46,   71,
   46,   46,    0,    0,   69,   67,    0,   68,   71,   70,
    0,   36,   82,   69,   67,    0,   68,    0,   70,    0,
    0,   72,   66,    0,   65,   64,    0,    0,    0,    0,
   71,   66,    0,   65,   64,   69,   67,   71,   68,    0,
   70,  110,   69,   67,   71,   68,    0,   70,  120,   69,
   67,  105,   68,   66,   70,   65,   64,    0,    0,    0,
   66,    0,   65,   64,    0,    0,    0,   66,   71,   65,
   64,    0,  124,   69,   67,   71,   68,    0,   70,    0,
   69,   67,    0,   68,    0,   70,    0,    0,    0,    0,
    0,   66,    0,   65,   64,    0,    0,    0,   66,    0,
   65,   64,    0,   20,   40,   41,   42,   21,    0,    0,
    0,   22,   23,   24,    0,   25,   26,   27,   28,   29,
    0,   66,   66,    0,   34,    0,   30,   31,   34,   32,
   33,   65,   34,   34,   34,    0,   34,   34,   34,   34,
   34,    0,    0,    0,    0,   20,    0,   34,   34,   21,
   34,   34,    0,   22,   23,   24,    0,   25,   26,   27,
   28,   29,   38,    0,    0,    0,   38,    0,   30,   31,
   41,   32,   33,    0,   41,   38,   38,    0,    0,    0,
    0,    0,    0,   41,   41,   38,   38,   20,    0,    0,
    0,   21,    0,   41,   41,    0,    0,    0,    0,    0,
   26,   27,    0,    0,    0,   58,   59,   60,   61,   62,
   30,   31,   46,   46,   46,   46,   46,   46,    0,   71,
    0,    0,    0,    0,   69,   67,    0,   68,    0,   70,
    0,    0,    0,    0,   61,    0,   58,   59,   60,   61,
   62,   63,   66,   62,   65,   58,   59,   60,   61,   62,
   63,   61,   61,   61,    0,   61,   61,    0,    0,    0,
   62,   62,   62,    0,   62,   62,    0,   58,   59,   60,
   61,   62,   63,   63,   58,   59,   60,   61,   62,   63,
   64,   58,   59,   60,   61,   62,   63,    0,    0,    0,
   63,   63,   63,    0,   63,   63,    0,   64,   64,   64,
    0,   64,   64,    0,    0,   58,   59,   60,   61,   62,
   63,    0,   58,   59,   60,   61,   62,   63,   54,    0,
   54,    0,   54,    0,   55,    0,   55,    0,   55,    0,
   59,    0,    0,    0,    0,   54,   54,   54,   60,   54,
   54,   55,   55,   55,    0,   55,   55,   59,   59,   59,
    0,   59,   59,   54,   55,   60,   60,   60,    0,   60,
   60,   73,   74,    0,    0,   77,    0,    0,   80,    0,
    0,    0,    0,    0,    0,    0,    0,   84,   85,   86,
   87,   88,   89,   90,   91,   92,   93,   94,   95,   96,
   97,    0,    0,    0,    0,    0,    0,  102,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  113,    0,    0,  114,    0,    0,
  117,    0,    0,    0,    0,    0,    0,    0,  126,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
  134,    0,    0,    0,    0,    0,   58,   59,   60,   61,
    0,    0,    0,    0,    0,    0,    0,   61,   61,   61,
   61,   61,   61,    0,    0,    0,   62,   62,   62,   62,
   62,   62,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   63,   63,   63,   63,
   63,   63,    0,   64,   64,   64,   64,   64,   64,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,   54,   54,   54,   54,   54,   54,   55,   55,   55,
   55,   55,   55,   59,   59,   59,   59,   59,   59,    0,
    0,   60,   60,   60,   60,   60,   60,
};
}
static short yycheck[];
static { yycheck(); }
static void yycheck() {
yycheck = new short[] {                         33,
   48,   41,   37,  257,   41,   61,   40,   42,   43,   59,
   45,   41,   47,   41,  263,   41,  264,   40,   58,   59,
   33,   58,   59,  258,  259,  260,   63,   40,   58,   59,
   58,   59,   58,   59,   37,   63,   41,  123,   40,   42,
   40,   33,   40,   40,   47,  257,  257,   59,   40,   59,
  125,  257,  262,   40,  269,   41,   41,   41,   33,   40,
   59,  109,   44,   59,   59,   40,   33,  268,  116,   59,
   59,   59,   41,   40,   41,  263,  125,   41,   44,   59,
  128,   59,   59,   33,   59,   41,    8,  135,   37,  123,
   40,  125,   36,   42,   43,   37,   45,   -1,   47,   41,
   42,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,
  123,   60,  125,   62,   -1,   -1,   58,   59,   60,   37,
   62,   63,   -1,   -1,   42,   43,   -1,   45,   37,   47,
   -1,  123,   41,   42,   43,   -1,   45,   -1,   47,   -1,
   -1,   59,   60,   -1,   62,   63,   -1,   -1,   -1,   -1,
   37,   60,   -1,   62,   63,   42,   43,   37,   45,   -1,
   47,   41,   42,   43,   37,   45,   -1,   47,   41,   42,
   43,   58,   45,   60,   47,   62,   63,   -1,   -1,   -1,
   60,   -1,   62,   63,   -1,   -1,   -1,   60,   37,   62,
   63,   -1,   41,   42,   43,   37,   45,   -1,   47,   -1,
   42,   43,   -1,   45,   -1,   47,   -1,   -1,   -1,   -1,
   -1,   60,   -1,   62,   63,   -1,   -1,   -1,   60,   -1,
   62,   63,   -1,  257,  280,  281,  282,  261,   -1,   -1,
   -1,  265,  266,  267,   -1,  269,  270,  271,  272,  273,
   -1,  278,  279,   -1,  257,   -1,  280,  281,  261,  283,
  284,  279,  265,  266,  267,   -1,  269,  270,  271,  272,
  273,   -1,   -1,   -1,   -1,  257,   -1,  280,  281,  261,
  283,  284,   -1,  265,  266,  267,   -1,  269,  270,  271,
  272,  273,  257,   -1,   -1,   -1,  261,   -1,  280,  281,
  257,  283,  284,   -1,  261,  270,  271,   -1,   -1,   -1,
   -1,   -1,   -1,  270,  271,  280,  281,  257,   -1,   -1,
   -1,  261,   -1,  280,  281,   -1,   -1,   -1,   -1,   -1,
  270,  271,   -1,   -1,   -1,  274,  275,  276,  277,  278,
  280,  281,  274,  275,  276,  277,  278,  279,   -1,   37,
   -1,   -1,   -1,   -1,   42,   43,   -1,   45,   -1,   47,
   -1,   -1,   -1,   -1,   41,   -1,  274,  275,  276,  277,
  278,  279,   60,   41,   62,  274,  275,  276,  277,  278,
  279,   58,   59,   60,   -1,   62,   63,   -1,   -1,   -1,
   58,   59,   60,   -1,   62,   63,   -1,  274,  275,  276,
  277,  278,  279,   41,  274,  275,  276,  277,  278,  279,
   41,  274,  275,  276,  277,  278,  279,   -1,   -1,   -1,
   58,   59,   60,   -1,   62,   63,   -1,   58,   59,   60,
   -1,   62,   63,   -1,   -1,  274,  275,  276,  277,  278,
  279,   -1,  274,  275,  276,  277,  278,  279,   41,   -1,
   43,   -1,   45,   -1,   41,   -1,   43,   -1,   45,   -1,
   41,   -1,   -1,   -1,   -1,   58,   59,   60,   41,   62,
   63,   58,   59,   60,   -1,   62,   63,   58,   59,   60,
   -1,   62,   63,   34,   35,   58,   59,   60,   -1,   62,
   63,   42,   43,   -1,   -1,   46,   -1,   -1,   49,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   58,   59,   60,
   61,   62,   63,   64,   65,   66,   67,   68,   69,   70,
   71,   -1,   -1,   -1,   -1,   -1,   -1,   78,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  105,   -1,   -1,  108,   -1,   -1,
  111,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  119,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  131,   -1,   -1,   -1,   -1,   -1,  274,  275,  276,  277,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  274,  275,  276,
  277,  278,  279,   -1,   -1,   -1,  274,  275,  276,  277,
  278,  279,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  274,  275,  276,  277,
  278,  279,   -1,  274,  275,  276,  277,  278,  279,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  274,  275,  276,  277,  278,  279,  274,  275,  276,
  277,  278,  279,  274,  275,  276,  277,  278,  279,   -1,
   -1,  274,  275,  276,  277,  278,  279,
};
}
final static short YYFINAL=1;
final static short YYMAXTOKEN=284;
final static String yyname[] = {
"end-of-file",null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,"'!'",null,null,null,"'%'",null,null,"'('","')'","'*'","'+'",
"','","'-'",null,"'/'",null,null,null,null,null,null,null,null,null,null,"':'",
"';'","'<'","'='","'>'","'?'",null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,"'{'",null,"'}'",null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,
null,null,null,null,null,null,null,null,"ID","INT","FLOAT","BOOL","NUM","LIT",
"VOID","MAIN","READ","WRITE","IF","ELSE","WHILE","TRUE","FALSE","DO","FOR","EQ",
"LEQ","GEQ","NEQ","AND","OR","INC","DEC","ADDEQ","BREAK","CONTINUE",
};
final static String yyrule[] = {
"$accept : prog",
"$$1 :",
"prog : $$1 dList mainF",
"$$2 :",
"$$3 :",
"mainF : VOID MAIN '(' ')' $$2 '{' lcmd $$3 '}'",
"dList : decl dList",
"dList :",
"decl : type ID ';'",
"type : INT",
"type : FLOAT",
"type : BOOL",
"lcmd : lcmd cmd",
"lcmd :",
"cmd : exp ';'",
"cmd : '{' lcmd '}'",
"cmd : WRITE '(' LIT ')' ';'",
"$$4 :",
"cmd : WRITE '(' LIT $$4 ',' exp ')' ';'",
"cmd : READ '(' ID ')' ';'",
"cmd : BREAK ';'",
"cmd : CONTINUE ';'",
"$$5 :",
"cmd : DO $$5 cmd WHILE '(' exp ')' ';'",
"$$6 :",
"$$7 :",
"cmd : WHILE $$6 '(' exp ')' $$7 cmd",
"$$8 :",
"cmd : IF '(' exp $$8 ')' cmd restoIf",
"$$9 :",
"$$10 :",
"cmd : FOR '(' for_init ';' $$9 for_cond ';' for_incr ')' $$10 cmd",
"$$11 :",
"restoIf : ELSE $$11 cmd",
"restoIf :",
"for_init :",
"for_init : exp",
"for_cond :",
"$$12 :",
"for_cond : $$12 exp",
"for_incr :",
"$$13 :",
"for_incr : $$13 exp",
"exp : NUM",
"exp : TRUE",
"exp : FALSE",
"exp : ID",
"exp : '(' exp ')'",
"exp : '!' exp",
"exp : INC ID",
"exp : DEC ID",
"exp : ID INC",
"exp : ID DEC",
"exp : ID ADDEQ exp",
"exp : exp '+' exp",
"exp : exp '-' exp",
"exp : exp '*' exp",
"exp : exp '/' exp",
"exp : exp '%' exp",
"exp : exp '>' exp",
"exp : exp '<' exp",
"exp : exp EQ exp",
"exp : exp LEQ exp",
"exp : exp GEQ exp",
"exp : exp NEQ exp",
"exp : exp OR exp",
"exp : exp AND exp",
"exp : exp '?' exp ':' exp",
"exp : ID '=' exp",
};

//#line 378 "exemploGC.y"

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
//#line 766 "Parser.java"
//###############################################################
// method: yylexdebug : check lexer state
//###############################################################
void yylexdebug(int state,int ch)
{
String s=null;
  if (ch < 0) ch=0;
  if (ch <= YYMAXTOKEN) //check index bounds
     s = yyname[ch];    //now get it
  if (s==null)
    s = "illegal-symbol";
  debug("state "+state+", reading "+ch+" ("+s+")");
}





//The following are now global, to aid in error reporting
int yyn;       //next next thing to do
int yym;       //
int yystate;   //current parsing state from state table
String yys;    //current token string


//###############################################################
// method: yyparse : parse input and execute indicated items
//###############################################################
int yyparse()
{
boolean doaction;
  init_stacks();
  yynerrs = 0;
  yyerrflag = 0;
  yychar = -1;          //impossible char forces a read
  yystate=0;            //initial state
  state_push(yystate);  //save it
  val_push(yylval);     //save empty value
  while (true) //until parsing is done, either correctly, or w/error
    {
    doaction=true;
    if (yydebug) debug("loop"); 
    //#### NEXT ACTION (from reduction table)
    for (yyn=yydefred[yystate];yyn==0;yyn=yydefred[yystate])
      {
      if (yydebug) debug("yyn:"+yyn+"  state:"+yystate+"  yychar:"+yychar);
      if (yychar < 0)      //we want a char?
        {
        yychar = yylex();  //get next token
        if (yydebug) debug(" next yychar:"+yychar);
        //#### ERROR CHECK ####
        if (yychar < 0)    //it it didn't work/error
          {
          yychar = 0;      //change it to default string (no -1!)
          if (yydebug)
            yylexdebug(yystate,yychar);
          }
        }//yychar<0
      yyn = yysindex[yystate];  //get amount to shift by (shift index)
      if ((yyn != 0) && (yyn += yychar) >= 0 &&
          yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
        {
        if (yydebug)
          debug("state "+yystate+", shifting to state "+yytable[yyn]);
        //#### NEXT STATE ####
        yystate = yytable[yyn];//we are in a new state
        state_push(yystate);   //save it
        val_push(yylval);      //push our lval as the input for next rule
        yychar = -1;           //since we have 'eaten' a token, say we need another
        if (yyerrflag > 0)     //have we recovered an error?
           --yyerrflag;        //give ourselves credit
        doaction=false;        //but don't process yet
        break;   //quit the yyn=0 loop
        }

    yyn = yyrindex[yystate];  //reduce
    if ((yyn !=0 ) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
      {   //we reduced!
      if (yydebug) debug("reduce");
      yyn = yytable[yyn];
      doaction=true; //get ready to execute
      break;         //drop down to actions
      }
    else //ERROR RECOVERY
      {
      if (yyerrflag==0)
        {
        yyerror("syntax error");
        yynerrs++;
        }
      if (yyerrflag < 3) //low error count?
        {
        yyerrflag = 3;
        while (true)   //do until break
          {
          if (stateptr<0)   //check for under & overflow here
            {
            yyerror("stack underflow. aborting...");  //note lower case 's'
            return 1;
            }
          yyn = yysindex[state_peek(0)];
          if ((yyn != 0) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
            if (yydebug)
              debug("state "+state_peek(0)+", error recovery shifting to state "+yytable[yyn]+" ");
            yystate = yytable[yyn];
            state_push(yystate);
            val_push(yylval);
            doaction=false;
            break;
            }
          else
            {
            if (yydebug)
              debug("error recovery discarding state "+state_peek(0)+" ");
            if (stateptr<0)   //check for under & overflow here
              {
              yyerror("Stack underflow. aborting...");  //capital 'S'
              return 1;
              }
            state_pop();
            val_pop();
            }
          }
        }
      else            //discard this token
        {
        if (yychar == 0)
          return 1; //yyabort
        if (yydebug)
          {
          yys = null;
          if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
          if (yys == null) yys = "illegal-symbol";
          debug("state "+yystate+", error recovery discards token "+yychar+" ("+yys+")");
          }
        yychar = -1;  //read another
        }
      }//end error recovery
    }//yyn=0 loop
    if (!doaction)   //any reason not to proceed?
      continue;      //skip action
    yym = yylen[yyn];          //get count of terminals on rhs
    if (yydebug)
      debug("state "+yystate+", reducing "+yym+" by rule "+yyn+" ("+yyrule[yyn]+")");
    if (yym>0)                 //if count of rhs not 'nil'
      yyval = val_peek(yym-1); //get current semantic value
    yyval = dup_yyval(yyval); //duplicate yyval if ParserVal is used as semantic value
    switch(yyn)
      {
//########## USER-SUPPLIED ACTIONS ##########
case 1:
//#line 34 "exemploGC.y"
{ geraInicio(); }
break;
case 2:
//#line 34 "exemploGC.y"
{ geraAreaDados(); geraAreaLiterais(); }
break;
case 3:
//#line 36 "exemploGC.y"
{ System.out.println("_start:"); }
break;
case 4:
//#line 37 "exemploGC.y"
{ geraFinal(); }
break;
case 8:
//#line 45 "exemploGC.y"
{  
        TS_entry nodo = ts.pesquisa(val_peek(1).sval);
        if (nodo != null) 
            yyerror("(sem) variavel >" + val_peek(1).sval + "< jah declarada");
        else 
            ts.insert(new TS_entry(val_peek(1).sval, val_peek(2).ival)); 
      }
break;
case 9:
//#line 54 "exemploGC.y"
{ yyval.ival = INT; }
break;
case 10:
//#line 55 "exemploGC.y"
{ yyval.ival = FLOAT; }
break;
case 11:
//#line 56 "exemploGC.y"
{ yyval.ival = BOOL; }
break;
case 15:
//#line 71 "exemploGC.y"
{ 
        System.out.println("\t\t# terminou o bloco..."); 
      }
break;
case 16:
//#line 76 "exemploGC.y"
{ 
        strTab.add(val_peek(2).sval);
        System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
        System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
        System.out.println("\tCALL _writeLit"); 
        System.out.println("\tCALL _writeln"); 
        strCount++;
      }
break;
case 17:
//#line 86 "exemploGC.y"
{ 
        strTab.add(val_peek(0).sval);
        System.out.println("\tMOVL $_str_"+strCount+"Len, %EDX"); 
        System.out.println("\tMOVL $_str_"+strCount+", %ECX"); 
        System.out.println("\tCALL _writeLit"); 
        strCount++;
      }
break;
case 18:
//#line 94 "exemploGC.y"
{ 
        System.out.println("\tPOPL %EAX"); 
        System.out.println("\tCALL _write");	
        System.out.println("\tCALL _writeln"); 
      }
break;
case 19:
//#line 101 "exemploGC.y"
{
        System.out.println("\tPUSHL $_"+val_peek(2).sval);
        System.out.println("\tCALL _read");
        System.out.println("\tPOPL %EDX");
        System.out.println("\tMOVL %EAX, (%EDX)");
      }
break;
case 20:
//#line 109 "exemploGC.y"
{
        if (pBreak.empty())
            yyerror("(sem) comando 'break' fora de laco");
        else
            System.out.printf("\tJMP rot_%02d   # break\n", pBreak.peek());
      }
break;
case 21:
//#line 117 "exemploGC.y"
{
        if (pContinue.empty())
            yyerror("(sem) comando 'continue' fora de laco");
        else
            System.out.printf("\tJMP rot_%02d   # continue\n", pContinue.peek());
      }
break;
case 22:
//#line 126 "exemploGC.y"
{
        pRot.push(proxRot);             /* rótulo início do do-while*/
        pContinue.push(pRot.peek());    /* continue -> volta para o início*/
        pBreak.push(pRot.peek()+1);     /* break -> vai para o fim*/
        System.out.printf("rot_%02d:\n", pRot.peek());
        proxRot += 2;                   /* reserva rot_fim = inicio+1*/
      }
break;
case 23:
//#line 135 "exemploGC.y"
{
        System.out.println("\tPOPL %EAX   # do-while testa no final");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf ("\tJNE rot_%02d\n", pRot.peek());
        System.out.printf("rot_%02d:\n", (int)pRot.peek()+1);
        pRot.pop();
        pContinue.pop();
        pBreak.pop();
      }
break;
case 24:
//#line 147 "exemploGC.y"
{
        pRot.push(proxRot);         /* rótulo início do while*/
        proxRot += 2;               /* reserva também o rótulo de fim (inicio+1)*/
        pContinue.push(pRot.peek());        /* continue -> volta para o início*/
        pBreak.push(pRot.peek()+1);         /* break -> fim*/
        System.out.printf("rot_%02d:\n", pRot.peek());
      }
break;
case 25:
//#line 155 "exemploGC.y"
{
        System.out.println("\tPOPL %EAX   # desvia se falso...");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", (int)pRot.peek()+1);
      }
break;
case 26:
//#line 161 "exemploGC.y"
{
        System.out.printf("\tJMP rot_%02d   # terminou cmd na linha de cima\n", pRot.peek());
        System.out.printf("rot_%02d:\n", (int)pRot.peek()+1);
        pRot.pop();
        pContinue.pop();
        pBreak.pop();
      }
break;
case 27:
//#line 171 "exemploGC.y"
{	
        pRot.push(proxRot);  proxRot += 2;
        System.out.println("\tPOPL %EAX");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", pRot.peek());
      }
break;
case 28:
//#line 179 "exemploGC.y"
{
        System.out.printf("rot_%02d:\n",pRot.peek()+1);
        pRot.pop();
      }
break;
case 29:
//#line 186 "exemploGC.y"
{
        int Lcond = proxRot++;
        int Lbody = proxRot++;
        int Lcont = proxRot++;
        int Lend  = proxRot++;

        pForCond.push(Lcond);   /* cond*/
        pForBody.push(Lbody);   /* corpo*/
        pForIncr.push(Lcont);   /* incremento / continue*/
        pBreak.push(Lend);      /* break*/
        pContinue.push(Lcont);  /* continue*/

        /* depois da inicializacao, pula para a condicao */
        System.out.printf("\tJMP rot_%02d\n", Lcond);
      }
break;
case 30:
//#line 203 "exemploGC.y"
{
        /* rótulo do corpo: proximo código é o cmd */
        System.out.printf("rot_%02d:\n", pForBody.peek());
      }
break;
case 31:
//#line 208 "exemploGC.y"
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
break;
case 32:
//#line 226 "exemploGC.y"
{
        System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
        System.out.printf("rot_%02d:\n",pRot.peek());
      }
break;
case 34:
//#line 232 "exemploGC.y"
{
        System.out.printf("\tJMP rot_%02d\n", pRot.peek()+1);
        System.out.printf("rot_%02d:\n",pRot.peek());
      }
break;
case 36:
//#line 242 "exemploGC.y"
{ 
        System.out.println("\tPOPL %EAX   # descarta resultado da inicializacao do for"); 
      }
break;
case 37:
//#line 250 "exemploGC.y"
{
        /* condicao vazia: sempre verdadeira */
        int Lcond = pForCond.peek();
        int Lbody = pForBody.peek();
        System.out.printf("rot_%02d:\n", Lcond);
        System.out.printf("\tJMP rot_%02d\n", Lbody);
      }
break;
case 38:
//#line 258 "exemploGC.y"
{ 
        /* label da condicao vem ANTES da expressao */
        int Lcond = pForCond.peek();
        System.out.printf("rot_%02d:\n", Lcond);
      }
break;
case 39:
//#line 264 "exemploGC.y"
{
        System.out.println("\tPOPL %EAX   # condicao do for");
        System.out.println("\tCMPL $0, %EAX");
        System.out.printf("\tJE rot_%02d\n", pBreak.peek());      /* sai do for se falso*/
        System.out.printf("\tJMP rot_%02d\n", pForBody.peek());   /* vai pro corpo se verdadeiro*/
      }
break;
case 40:
//#line 275 "exemploGC.y"
{
        int Lcont = pForIncr.peek();
        int Lcond = pForCond.peek();
        System.out.printf("rot_%02d:\n", Lcont);
        System.out.printf("\tJMP rot_%02d\n", Lcond);
      }
break;
case 41:
//#line 282 "exemploGC.y"
{ 
        int Lcont = pForIncr.peek();
        System.out.printf("rot_%02d:\n", Lcont);
      }
break;
case 42:
//#line 287 "exemploGC.y"
{
        System.out.println("\tPOPL %EAX   # incremento do for");
        System.out.printf("\tJMP rot_%02d\n", pForCond.peek());
      }
break;
case 43:
//#line 294 "exemploGC.y"
{ System.out.println("\tPUSHL $"+val_peek(0).sval); }
break;
case 44:
//#line 297 "exemploGC.y"
{ System.out.println("\tPUSHL $1"); }
break;
case 45:
//#line 300 "exemploGC.y"
{ System.out.println("\tPUSHL $0"); }
break;
case 46:
//#line 303 "exemploGC.y"
{ System.out.println("\tPUSHL _"+val_peek(0).sval); }
break;
case 48:
//#line 308 "exemploGC.y"
{ gcExpNot(); }
break;
case 49:
//#line 312 "exemploGC.y"
{ gcPreInc(val_peek(0).sval); }
break;
case 50:
//#line 315 "exemploGC.y"
{ gcPreDec(val_peek(0).sval); }
break;
case 51:
//#line 319 "exemploGC.y"
{ gcPosInc(val_peek(1).sval); }
break;
case 52:
//#line 322 "exemploGC.y"
{ gcPosDec(val_peek(1).sval); }
break;
case 53:
//#line 325 "exemploGC.y"
{ gcAtribAdd(val_peek(2).sval); }
break;
case 54:
//#line 328 "exemploGC.y"
{ gcExpArit('+'); }
break;
case 55:
//#line 331 "exemploGC.y"
{ gcExpArit('-'); }
break;
case 56:
//#line 334 "exemploGC.y"
{ gcExpArit('*'); }
break;
case 57:
//#line 337 "exemploGC.y"
{ gcExpArit('/'); }
break;
case 58:
//#line 340 "exemploGC.y"
{ gcExpArit('%'); }
break;
case 59:
//#line 343 "exemploGC.y"
{ gcExpRel('>'); }
break;
case 60:
//#line 346 "exemploGC.y"
{ gcExpRel('<'); }
break;
case 61:
//#line 349 "exemploGC.y"
{ gcExpRel(EQ); }
break;
case 62:
//#line 352 "exemploGC.y"
{ gcExpRel(LEQ); }
break;
case 63:
//#line 355 "exemploGC.y"
{ gcExpRel(GEQ); }
break;
case 64:
//#line 358 "exemploGC.y"
{ gcExpRel(NEQ); }
break;
case 65:
//#line 361 "exemploGC.y"
{ gcExpLog(OR); }
break;
case 66:
//#line 364 "exemploGC.y"
{ gcExpLog(AND); }
break;
case 67:
//#line 368 "exemploGC.y"
{ gcTernario(); }
break;
case 68:
//#line 372 "exemploGC.y"
{ gcAtrib(val_peek(2).sval); }
break;
//#line 1292 "Parser.java"
//########## END OF USER-SUPPLIED ACTIONS ##########
    }//switch
    //#### Now let's reduce... ####
    if (yydebug) debug("reduce");
    state_drop(yym);             //we just reduced yylen states
    yystate = state_peek(0);     //get new state
    val_drop(yym);               //corresponding value drop
    yym = yylhs[yyn];            //select next TERMINAL(on lhs)
    if (yystate == 0 && yym == 0)//done? 'rest' state and at first TERMINAL
      {
      if (yydebug) debug("After reduction, shifting from state 0 to state "+YYFINAL+"");
      yystate = YYFINAL;         //explicitly say we're done
      state_push(YYFINAL);       //and save it
      val_push(yyval);           //also save the semantic value of parsing
      if (yychar < 0)            //we want another character?
        {
        yychar = yylex();        //get next character
        if (yychar<0) yychar=0;  //clean, if necessary
        if (yydebug)
          yylexdebug(yystate,yychar);
        }
      if (yychar == 0)          //Good exit (if lex returns 0 ;-)
         break;                 //quit the loop--all DONE
      }//if yystate
    else                        //else not done yet
      {                         //get next state and push, for next yydefred[]
      yyn = yygindex[yym];      //find out where to go
      if ((yyn != 0) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn]; //get new state
      else
        yystate = yydgoto[yym]; //else go to new defred
      if (yydebug) debug("after reduction, shifting from state "+state_peek(0)+" to state "+yystate+"");
      state_push(yystate);     //going again, so push state & val...
      val_push(yyval);         //for next action
      }
    }//main loop
  return 0;//yyaccept!!
}
//## end of method parse() ######################################



//## run() --- for Thread #######################################
/**
 * A default run method, used for operating this parser
 * object in the background.  It is intended for extending Thread
 * or implementing Runnable.  Turn off with -Jnorun .
 */
public void run()
{
  yyparse();
}
//## end of method run() ########################################



//## Constructors ###############################################
/**
 * Default constructor.  Turn off with -Jnoconstruct .

 */
public Parser()
{
  //nothing to do
}


/**
 * Create a parser, setting the debug to true or false.
 * @param debugMe true for debugging, false for no debug.
 */
public Parser(boolean debugMe)
{
  yydebug=debugMe;
}
//###############################################################



}
//################### END OF CLASS ##############################

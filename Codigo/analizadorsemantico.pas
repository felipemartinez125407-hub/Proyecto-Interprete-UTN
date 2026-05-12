unit AnalizadorSemantico;

{$mode ObjFPC}{$H+}
Interface
uses
  AnalizadorLexico, AnalizadorSintactico, math, crt, Sysutils;

Const
    MaxVar =   50;
    MaxMatriz =   50;

Type

    TvarMatriz = record
        celdas:array[1..MaxMatriz, 1..MaxMatriz] Of real;
        filas:integer;
        columnas:integer;
    end;
    TTipo =   (TrealL,TmatrizL);
    TElemEstado = Record
        lexemaId:string;
        ValReal:real;
        Tipo:TTipo;
        ValMatriz:Tvarmatriz;
    End;
    TEstado =   Record
        elementos:   array [1..maxVar] Of TElemEstado;
        cant:   word;
    End;

Function multiplicacionMatrices(matriz1,matriz2:tvarmatriz; var error:byte):tvarmatriz;
Procedure escribirMatriz(matriz:tvarmatriz);
Procedure InicializarEst(Var Estado:TEstado);
Function ValorDe(Var E:TEstado; lexVar:String; indicefila:integer; IndiceColumna:integer; var encontrado:boolean):real;
Procedure agregarVar(Var E:tEstado; Var lexemaId:String; Var tipo:TTipo; var fil:integer; var col:integer);
Procedure evalProgram(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalVar(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalConjSentencias(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalB(var Arbol:tArbolDerivacion; var estado:TEstado);
procedure evalType(var Arbol:tArbolDerivacion; var estado:TEstado; var tipo:TTipo; var fil:integer; var col:integer);
Procedure evalSentencia(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalAsignacion(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalC(var Arbol:tArbolDerivacion; var estado:TEstado;nombreVar:string);
Procedure evalread(var Arbol:tArbolDerivacion; var estado:TEstado;nombreVar:string);
Procedure evalD(var Arbol:tArbolDerivacion; var estado:TEstado; nombreVar:string; valor:real);
Procedure evalwrite(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalconjwrite(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalE(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalcondicional(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalY(var Arbol:tArbolDerivacion; var estado:TEstado);
Procedure evalwhile(var Arbol:tArbolDerivacion; var estado:TEstado);
Function evalCond(var Arbol:tArbolDerivacion; var estado:TEstado):boolean;
Procedure evalCantFilasDe(var Arbol:tArbolDerivacion; var estado:TEstado; var filas:integer);
Procedure evalCantColDe(var Arbol:tArbolDerivacion; var estado:TEstado; var columnas:integer);
Procedure evalExpresionReal(var Arbol:tArbolDerivacion; var estado:TEstado; var op1Real:real; var op1Matriz:Tvarmatriz; var tipoOp1:ttipo);
Procedure evalSumRes(var Arbol:tArbolDerivacion; var estado:TEstado; var op1Real:real; var op1Matriz:TvarMatriz; var tipo:Ttipo);
Procedure evalTermino(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
Procedure evalMultDiv(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
Procedure evalTerminoSecundario(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
Procedure evalOperando(var Arbol:tArbolDerivacion; var estado:TEstado; var resultadoReal:real; var resultadoMatriz:Tvarmatriz; var tipo:ttipo);
Procedure evalI(arbol:tarbolderivacion; var estado:TEstado; Idvar:string; var resultadoreal:real; var resultadomatriz:tvarmatriz; var tipo:ttipo);
Procedure evalCM(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz);
Procedure evalM(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);
Procedure evalJ(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; maxcol:integer);
Procedure evalFila(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);
Procedure evalK(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);

implementation


Procedure InicializarEst(Var Estado:TEstado);
begin
   Estado.cant:=0;
end;

function SumaMatrices(Matriz1,matriz2:tvarmatriz;var error:byte):tvarmatriz;
var
    i,j:integer;
    Resultado:tvarmatriz;
begin
   if (matriz1.filas = matriz2.filas) and (matriz1.columnas = matriz2.columnas) then
   begin
       resultado.filas:= matriz1.filas;
       resultado.columnas:= matriz2.columnas;
       for i:=1 to matriz1.filas do
           for j:=1 to matriz1.columnas do resultado.celdas[i,j]:= matriz1.celdas[i,j] + matriz2.celdas[i,j];
   end else error:= 1;
   SumaMatrices:= resultado;
end;

function multescalar(matriz:tvarmatriz; esc:real):tvarmatriz;
var
    i,j:integer;
begin
   for i:=1 to matriz.filas do
       for j:=1 to matriz.columnas do Matriz.celdas[i,j]:=matriz.celdas[i,j]*esc;
   multescalar:= matriz;
end;

function RestaMatrices(Matriz1,matriz2:tvarmatriz;var error:byte):tvarmatriz;
begin
    multescalar(matriz2,-1);
    RestaMatrices := sumaMatrices(matriz1, multescalar(matriz2, -1), error);
end;

function multiplicacionMatrices(matriz1, matriz2: tvarmatriz; var error: byte): tvarmatriz;
var
    i, j, k: integer;
    resultado: tvarmatriz;
    suma: real;
begin
    error := 0;
    if matriz1.columnas = matriz2.filas then
    begin
        resultado.filas := matriz1.filas;
        resultado.columnas := matriz2.columnas;
        for i := 1 to matriz1.filas do
        begin
            for j := 1 to matriz2.columnas do
            begin
                suma := 0;
                for k := 1 to matriz1.columnas do
                begin
                    suma := suma + matriz1.celdas[i, k] * matriz2.celdas[k, j];
                end;
                resultado.celdas[i, j] := resultado.celdas[i,j] + suma;
            end;
        end;
        multiplicacionMatrices := resultado;
    end
    else error := 3;
end;

Function transposicionmatrices(matriz:tvarmatriz):tvarmatriz;
var
    i,j:integer;
    resultado:tvarmatriz;
begin
   resultado.filas:=matriz.columnas;
   resultado.columnas:=matriz.filas;
   for i:=1 to matriz.filas do
       for j:=1 to matriz.columnas do resultado.celdas[j,i]:=matriz.celdas[i,j];
   transposicionMatrices:=resultado;
end;

Procedure escribirMatriz(matriz:tvarmatriz);   //No lo usamos porque hay que declarar el tamaño de la matraiz antes
var
    i,j:integer;
begin
   write('{');
   for i:=1 to matriz.filas do
       begin
       write('{');
       for j:=1 to matriz.columnas do
           begin
               write(matriz.celdas[i,j]:2:2);
               if j <> matriz.columnas then write(',') else write('}');
           end;
       if i <> matriz.filas then write(',');
       end;
   write('}');
end;

Procedure buscarvar(idVar:string; var e:testado; var indice:integer; var encontrado:boolean);
var
i:integer;
begin
   encontrado:=false;
   i:=1;
   while (not encontrado) and (i <= e.cant) do
   begin
        If e.elementos[i].lexemaId = idvar then
        begin
          indice:=i;
          encontrado:=true;
        end
        else inc(i);
   end;
end;

Function ValorDe(Var E:TEstado; lexVar:String; indicefila:integer; IndiceColumna:integer; var encontrado:boolean):real;
var
    i:integer;
    valaux:real;
begin
   encontrado:=false;
   i:=1;
   buscarvar(lexvar, e, i,encontrado);
   if encontrado then
   begin
     if indicefila <> 0 then valorde:=e.elementos[i].valmatriz.celdas[indicefila,indicecolumna] else valorde:=e.elementos[i].ValReal;
   end else valorde:=0;
end;

Procedure agregarVar(Var E:tEstado; Var lexemaId:String; Var tipo:TTipo; var fil:integer; var col:integer);
var
    i,j:integer;
begin
     inc(e.cant);
     e.elementos[e.cant].lexemaId:=lexemaId;
     if tipo = trealL then
     begin
         e.elementos[e.cant].ValReal:=0;
         e.elementos[e.cant].Tipo:=TrealL;
     end else
     begin
         e.elementos[e.cant].ValMatriz.filas:= fil;
         e.elementos[e.cant].ValMatriz.columnas:= col;
         e.elementos[e.cant].tipo:=tmatrizl;
         For i:=1 to fil do
             for j:=1 to col do e.elementos[e.cant].ValMatriz.celdas[i,j]:= 0;             //Inicializa las celdas en 0;
     end;
end;

Procedure ActualizarEstadoVar(var estado:testado; nombreVar:string; tipo:ttipo; ValorReal:real; ValorMatriz:tvarmatriz; Fil,col:integer);
var
    indice:integer;
    encontrado:boolean;
begin
   buscarvar(nombrevar,estado,indice,encontrado);
   If encontrado then
   begin
        if tipo= TrealL then
        begin
            if fil = 0 then estado.elementos[indice].ValReal:= valorreal else estado.elementos[indice].ValMatriz.celdas[fil,col]:= valorreal;
        end
        else estado.elementos[indice].ValMatriz.celdas:= valormatriz.celdas;
   end;

end;


//<Program> ::= “Program” “id” “var” <Var> “Cuerpo” “{“<ConjSentencias> “}”
Procedure evalProgram(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     evalVar(Arbol^.hijos.elem[4], estado);             //3 a 4
     evalconjSentencias(Arbol^.hijos.elem[7], estado);       //6 a 7
end;

//<Var> ::= “id” “=” <Type> ”;” <Var> | ε
Procedure evalVar(var Arbol:tArbolDerivacion; var estado:TEstado);
var tipo:TTipo;
    fil, col:integer;
begin
     if Arbol^.hijos.cant <> 0 then
     begin
       evalType(Arbol^.hijos.elem[3], estado, tipo, fil, col);
       agregarVar(estado, Arbol^.hijos.elem[1]^.lexema, tipo, fil, col);
       Evalvar(arbol^.hijos.elem[5],estado);
     end;
end;

//<ConjSentencias> ::= <Sentencia> “;” <B>
 Procedure evalConjSentencias(var Arbol:tArbolDerivacion; var estado:TEstado);
 begin
      evalSentencia(Arbol^.hijos.elem[1], estado);
      evalB(Arbol^.hijos.elem[3], estado);
 end;

//<B> ::= <ConjSentencias> | ε
 Procedure evalB(var Arbol:tArbolDerivacion; var estado:TEstado);
 begin
      if Arbol^.hijos.cant <> 0 then
      begin
        evalConjSentencias(Arbol^.hijos.elem[1],estado);
      end;
 end;

//<Type> ::= “real” | “Matrix” ”[“ "Nat" "," "Nat" “]” | “nat”
procedure evalType(var Arbol:tArbolDerivacion; var estado:TEstado; var tipo:TTipo; var fil:integer; var col:integer);
var
    resultado:real;
    Matrizaux:tvarMatriz;
    Tipoaux: ttipo;
begin
     case Arbol^.hijos.elem[1]^.simbolo of
     Ttypereal:begin      //Treal --> Ttypereal   28/2/2026
       tipo:=TrealL;
       fil:=0;
       col:=0;
     end;
     Ttypenat:begin
       tipo:=TrealL;
       fil:=0;
       col:=0;
     end;
     Ttypematrix:begin
                      tipo:=TmatrizL;
                      evalExpresionReal(arbol^.hijos.elem[3], estado,resultado, Matrizaux,Tipoaux);
                      fil:=trunc(resultado);
                      evalExpresionReal(arbol^.hijos.elem[5], estado,resultado, Matrizaux,Tipoaux);
                      col:=trunc(resultado);
                 end;
     end;
end;

//<Sentencia> ::= <Asignacion> | <Read> | <Write> | <condicional> | <While>
Procedure evalSentencia(var Arbol:tArbolDerivacion; var estado:TEstado);
var
    col, fil:integer ;
begin

   if Arbol^.hijos.cant < 1 then
  begin
    writeln('ERROR CRITICO: El nodo Sentencia no tiene hijos.');
    readkey;
    exit;
  end;
  if Arbol^.hijos.elem[1] = nil then
  begin
    writeln('ERROR CRITICO: El puntero del hijo 1 de Sentencia es nil.');
    readkey;
    exit;
  end;
     case Arbol^.hijos.elem[1]^.simbolo of
     Vasignacion: evalAsignacion(Arbol^.hijos.elem[1], estado);
     Vread: evalread(Arbol^.hijos.elem[1], estado, arbol^.lexema);
     Vwrite: evalwrite(Arbol^.hijos.elem[1], estado);
     Vcondicional: evalcondicional(Arbol^.hijos.elem[1], estado);
     Vwhile: evalwhile(Arbol^.hijos.elem[1], estado);
     end;
end;

//<Asignacion> ::= “id”  <C>
Procedure evalAsignacion(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     evalC(Arbol^.hijos.elem[2], estado, Arbol^.hijos.elem[1]^.lexema);
end;

//<C> ::=  := <ExpresionReal> | “[“<ExpresionReal> “,” <ExpresionReal> “]” “:=” <ExpresionReal>
Procedure evalC(var Arbol:tArbolDerivacion; var estado:TEstado;nombreVar:string);
var
    ResultadoauxReal:real;
    col,fil:integer;
    ResultadoauxMatriz:Tvarmatriz;
    Tipoaux:ttipo;
begin
     col:=0;
     fil:=0;
     Case Arbol^.hijos.elem[1]^.simbolo of
     Tasignacion:begin
                      EvalExpresionReal(Arbol^.hijos.elem[2], estado, ResultadoauxReal, resultadoauxMatriz, Tipoaux);
                      ActualizarEstadoVar(estado, nombreVar, tipoaux, ResultadoauxReal, resultadoauxMatriz, Fil, col);
                 end;
     TcorcheteA:begin
                      EvalExpresionReal(Arbol^.hijos.elem[2], estado, resultadoauxreal, resultadoauxMatriz, Tipoaux);
                      fil:= trunc(resultadoauxreal);
                      EvalExpresionReal(Arbol^.hijos.elem[4], estado, resultadoauxreal, resultadoauxMatriz, Tipoaux);
                      col:= trunc(resultadoauxreal);
                      EvalExpresionReal(Arbol^.hijos.elem[7], estado, ResultadoauxReal, resultadoauxMatriz, Tipoaux);
                      ActualizarEstadoVar(estado, nombreVar, treall, ResultadoauxReal, resultadoauxMatriz, Fil, col);
                end;
     end;
end;

//<Read> ::= “read” "(" "string" “,”  “id” <D>
Procedure evalread(var Arbol:tArbolDerivacion; var estado:TEstado; nombreVar:string);
var
    valorlectura:real;
begin
     write(arbol^.hijos.elem[3]^.lexema);
     readln(valorlectura);
     evalD(Arbol^.hijos.elem[6], estado, arbol^.hijos.elem[5]^.lexema, valorlectura);
end;

//<D> ::= “)” | “[" <ExpresionReal> "," <ExpresionReal> ”]” “)”
Procedure evalD(var Arbol:tArbolDerivacion; var estado:TEstado; nombreVar:string; valor:real);
var
    matrizaux:tvarmatriz;
    resultadoauxreal:real;
    fil, col:integer;
    tipoaux:ttipo;
begin
     if Arbol^.hijos.elem[1]^.simbolo = TparentesisC then Actualizarestadovar(estado, nombrevar, Treall, valor, matrizaux,0,0) else
     begin
          EvalExpresionReal(Arbol^.hijos.elem[2], estado, resultadoauxreal, matrizaux, Tipoaux);
          fil:= trunc(resultadoauxreal);
          EvalExpresionReal(Arbol^.hijos.elem[4], estado, resultadoauxreal, matrizaux, Tipoaux);
          col:= trunc(resultadoauxreal);
          ActualizarEstadoVar(estado, nombrevar, treall, valor, matrizaux, Fil, col);
     end;
end;

//<Write> ::= “write” “(“ <ConjWrite> “)”
Procedure evalwrite(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     evalconjwrite(arbol^.hijos.elem[3], estado);
end;

//<ConjWrite> ::= “string” <E> | <ExpresionReal> <F>
Procedure evalconjwrite(var Arbol:tArbolDerivacion; var estado:TEstado);
var
    resultadoreal:real;
    resultadoMatriz:Tvarmatriz;
    tipo:ttipo;
begin
     case arbol^.hijos.elem[1]^.simbolo of
     Tstring:begin
                  write(arbol^.hijos.elem[1]^.lexema);
                  evalE(arbol^.hijos.elem[2], estado);
             end;
     VexpresionReal:begin
                         evalExpresionReal(arbol^.hijos.elem[1], estado, resultadoReal,ResultadoMatriz,tipo);
                         if tipo = trealL then write(resultadoreal:2:2) else escribirMatriz(ResultadoMatriz);
                         evalE(arbol^.hijos.elem[2], estado);
                    end;
     end;
end;

//<E> ::= “,” <ListaEscritura> | ε
Procedure evalE(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     if arbol^.hijos.cant <> 0 then
     begin
       evalconjwrite(arbol^.hijos.elem[2], estado);
     end else writeln('');
end;

//<condicional> ::= “if” <Cond> “then” “{" <ConjSentencias> “}” <Y>
Procedure evalcondicional(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     if evalCond(arbol^.hijos.elem[2], estado) then evalconjSentencias(arbol^.hijos.elem[5], estado)
     else evalY(arbol^.hijos.elem[7], estado);
end;

//<Y> ::= “else “then” “{“ <ConjSentencias> “}” | ε
Procedure evalY(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     if arbol^.hijos.cant <> 0 then evalconjsentencias (arbol^.hijos.elem[4], estado);
end;

//<While> ::= “While” <Cond> "{“<ConjSentencias> “}”
Procedure evalwhile(var Arbol:tArbolDerivacion; var estado:TEstado);
begin
     while evalCond(arbol^.hijos.elem[2], estado) do evalconjSentencias(arbol^.hijos.elem[4], estado);
end;

//<Cond> ::= <ExpresionReal> “OpRel” <ExpresionReal>
Function evalCond(var Arbol:tArbolDerivacion; var estado:TEstado):boolean;
var
    aux1,aux2:real;
    matrizaux:tvarmatriz;
    tipoaux:ttipo;
begin
   evalexpresionreal(arbol^.hijos.elem[1],estado,aux1,matrizaux,tipoaux);
   evalexpresionreal(arbol^.hijos.elem[3],estado,aux2,matrizaux,tipoaux);
   case arbol^.hijos.elem[2]^.lexema of
        '<':  evalcond:= aux1 < aux2;
        '>':  evalcond:= aux1 > aux2;
        '==': evalcond:= aux1 = aux2;
        '>=': evalcond:= aux1 >= aux2;
        '<=': evalcond:= aux1 <= aux2;
        '<>': evalcond:= aux1 <> aux2;
   end;
end;

//<ExpresionReal> ::= <termino> <SumRes>
Procedure evalExpresionReal(var Arbol:tArbolDerivacion; var estado:TEstado; var op1Real:real; var op1Matriz:Tvarmatriz; var tipoOp1:ttipo);
begin
     evalTermino(arbol^.hijos.elem[1], estado, op1Real, op1Matriz, tipoop1);
     evalSumRes(arbol^.hijos.elem[2], estado, op1real, op1matriz, tipoop1);
end;

//<SumRes> ::= “+” <ExpresionReal> | “-” <ExpresionReal> | ε
Procedure evalSumRes(var Arbol:tArbolDerivacion; var estado:TEstado; var op1Real:real; var op1Matriz:TvarMatriz; var tipo:Ttipo);
var
    aux2:real;
    auxM:tvarmatriz;
    auxT:ttipo;
begin
     if arbol^.hijos.cant <> 0 then
     begin
       evalExpresionReal(arbol^.hijos.elem[2], estado, aux2, auxm, auxT);

       if (tipo = auxT) and (tipo = TrealL) then
       begin
         case arbol^.hijos.elem[1]^.simbolo of
           Tmas:begin
             op1real:=op1real+aux2;
             evalSumRes(arbol^.hijos.elem[3], estado, op1Real, op1Matriz, tipo);
           end;
           Tmenos:begin
             op1real:=op1real-aux2;
             evalSumRes(arbol^.hijos.elem[3], estado,op1Real, op1Matriz, tipo);
           end;
         end;
       end;

     end;
end;

//<termino> ::= <terminoSecundario>  <MultDiv>
Procedure evalTermino(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
begin
     evalTerminoSecundario(arbol^.hijos.elem[1], estado, opreal, opmatriz, tipoOP);
     evalMultDiv(arbol^.hijos.elem[2], estado, opreal, opmatriz, tipoop);
end;

//<MultDiv> ::=  “*” <terminoSecundario> <MultDiv> | “/” <terminoSecundario> <MultDiv> | ε
Procedure evalMultDiv(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
var
    aux2:real;
    auxM:tvarmatriz;
    auxT:ttipo;
begin
     if arbol^.hijos.cant <> 0 then
     begin
       evalterminosecundario(arbol^.hijos.elem[2], estado, aux2, auxm, auxT);

       if (tipoop = auxT) and (tipoop = TrealL) then
       begin
         case arbol^.hijos.elem[1]^.simbolo of
           Tmultiplicacion:begin
             opreal:=opreal*aux2;
             evalMultDiv(arbol^.hijos.elem[3], estado, opReal, opMatriz, tipoop);
           end;
           Tdivision:begin
             opreal:=opreal/aux2;
             evalMultDiv(arbol^.hijos.elem[3], estado,opReal, opMatriz, tipoop);
           end;
         end;
       end;
     end;
end;

//<terminoSecundario> ::= “sqrt” “(" <ExpresionReal> “,” <ExpresionReal> ")” | “pot” “(" <ExpresionReal> “,” <ExpresionReal> ")” | “(" <ExpresionReal> ")” | <Operando>
Procedure evalTerminoSecundario(var Arbol:tArbolDerivacion; var estado:TEstado; var opreal:real; var opmatriz:tvarmatriz; var tipoOP:ttipo);
var
    aux1,aux2:real;
    matrizaux:tvarmatriz;
    tipoaux1,tipoaux2:ttipo;
begin
     case arbol^.hijos.elem[1]^.simbolo of
     Tsqrt: begin
       evalexpresionreal(arbol^.hijos.elem[3],estado,aux1,matrizaux,tipoaux1);
       evalexpresionreal(arbol^.hijos.elem[5],estado,aux2,matrizaux,tipoaux2);
       if (tipoaux1 = tipoaux2) and (tipoaux1 = trealL) then opreal:= power(aux1,(1/aux2));
     end;
     Tpot: begin
       evalexpresionreal(arbol^.hijos.elem[3],estado,aux1,matrizaux,tipoaux1);
       evalexpresionreal(arbol^.hijos.elem[5],estado,aux2,matrizaux,tipoaux2);
       if (tipoaux1 = tipoaux2) and (tipoaux1 = trealL) then opreal:= power(aux1,(aux2));
     end;
     TparentesisA: evalexpresionreal(arbol^.hijos.elem[2],estado,opreal,opmatriz,tipoop);
     Voperando: evalOperando(arbol^.hijos.elem[1],estado,opreal,opmatriz,tipoop);
     end;
end;

//<Operando> ::= “id” <I> | “Real”| “Nat” | “-” <Operando> | “add” “(“ <ExpresionReal> “,” <ExpresionReal> ”)” | “substract” “(“<ExpresionReal> ”,” <ExpresionReal>”)” |
//“multiplication” “(" <ExpresionReal> “,” <ExpresionReal> ")” | “transpose” “(" <ExpresionReal> ")” | “multEsc” “(" <ExpresionReal> ",” <ExpresionReal> ")” | <CM>| <CantFilasDe> |  <CantColDe>

Procedure evalOperando(var Arbol:tArbolDerivacion; var estado:TEstado; var resultadoReal:real; var resultadoMatriz:Tvarmatriz; var tipo:ttipo);
var
    aux:real;
    col, filas:integer;
    matrizaux1,matrizaux2:tvarmatriz;
    Tipoaux1,tipoaux2: ttipo;
    error:byte;

begin
     case arbol^.hijos.elem[1]^.simbolo of
       Tid: EvalI(arbol^.hijos.elem[2],estado, arbol^.hijos.elem[1]^.lexema,resultadoreal,resultadomatriz,tipo);
       Treal, TNat:begin //Ttypereal --> Treal, TNat 28/02/2026
                        val(arbol^.hijos.elem[1]^.lexema, resultadoreal, error);
                        tipo:=TrealL;
                   end;
       Tmenos:begin
                    evaloperando(arbol^.hijos.elem[2],estado,resultadoreal,resultadomatriz,tipo);
                    if tipo = treall then resultadoreal:=resultadoreal*(-1) else ResultadoMatriz:= multescalar(resultadomatriz,-1);
              end;
       TaddM:begin
                    Tipo:=tmatrizl;
                    evalexpresionreal(arbol^.hijos.elem[3],estado,aux,matrizaux1,tipoaux1);
                    evalexpresionreal(arbol^.hijos.elem[5],estado,aux,matrizaux2,tipoaux2);
                    if tipoaux1 = tipoaux2 then resultadoMatriz:=sumaMatrices(matrizaux1,matrizaux2,error) else error:=2;
              end;
       TsubstractM:begin
                    Tipo:=tmatrizl;
                    evalexpresionreal(arbol^.hijos.elem[3],estado,aux,matrizaux1,tipoaux1);
                    evalexpresionreal(arbol^.hijos.elem[5],estado,aux,matrizaux2,tipoaux2);
                    if tipoaux1 = tipoaux2 then resultadoMatriz:=RestaMatrices(matrizaux1,matrizaux2,error) else error:=2;
               end;
       TmultiplicationM:begin
                             Tipo:=tmatrizl;
                             evalexpresionreal(arbol^.hijos.elem[3],estado,aux,matrizaux1,tipoaux1);
                             evalexpresionreal(arbol^.hijos.elem[5],estado,aux,matrizaux2,tipoaux2);
                             if tipoaux1 = tipoaux2 then resultadoMatriz:=Multiplicacionmatrices(matrizaux1,matrizaux2,error) else error:=2;
                        end;
       TtransposeM:begin
                             Tipo:=tmatrizl;
                             evalexpresionreal(arbol^.hijos.elem[3],estado,aux,matrizaux1,tipoaux1);
                             if tipoaux1 = Tmatrizl then resultadoMatriz:=transposicionmatrices(matrizaux1) else error:=4;
                       end;
       TmultEsc:begin
                    Tipo:=tmatrizl;
                    evalexpresionreal(arbol^.hijos.elem[3],estado,aux,matrizaux1,tipoaux1);
                    evalexpresionreal(arbol^.hijos.elem[5],estado,aux,matrizaux2,tipoaux2);
                    if (tipoaux1 = tmatrizl) and (tipoaux2 = treall) then resultadoMatriz:=multescalar(matrizaux1,aux) else error:=5;
       end;
       VcantFilasDe: begin
                     tipo:=treall;
                     evalCantFilasDe(arbol^.hijos.elem[1], estado, filas);
                     resultadoreal:=filas;
       end;
       VcantColDe: begin
                     tipo:=treall;
                     evalCantColDe(arbol^.hijos.elem[1], estado, col);
                     resultadoreal:=col;
       end;
       Vcm:begin
          tipo:=tmatrizl;
          evalCM(arbol^.hijos.elem[1], estado,Resultadomatriz);
       end;
     end;
end;

//<CantFilasDe> ::= “cantFilasDe” “(“ “id” “)”
Procedure evalCantFilasDe(var Arbol:tArbolDerivacion; var estado:TEstado; var filas:integer);
var
    i:integer;
    encontrado:boolean;
begin
     buscarVar(arbol^.hijos.elem[3]^.lexema, estado, i, encontrado);
     if encontrado then filas:= estado.elementos[i].ValMatriz.filas
     else writeln('Variable no declarada');
end;

//<CantColumnasDe> ::= “cantColumnasDe” “(“ “id” “)”
Procedure evalCantColDe(var Arbol:tArbolDerivacion; var estado:TEstado; var columnas:integer);
var
    i:integer;
    encontrado:boolean;
begin
     buscarVar(arbol^.hijos.elem[3]^.lexema, estado, i, encontrado);
     if encontrado then columnas:= estado.elementos[i].valMatriz.columnas
     else writeln('Variable no declarada');
end;

//<I> ::= “[" <ExpresionReal> “,” <ExpresionReal> "]” | ε
Procedure evalI(arbol:tarbolderivacion; var estado:TEstado; Idvar:string; var resultadoreal:real; var resultadomatriz:tvarmatriz; var tipo:ttipo);
var
    aux:real;
    fil,col,indice:integer;
    Matrizaux:tvarmatriz;
    tipoaux:ttipo;
    encontrado:boolean;
begin
     if arbol^.hijos.cant <> 0 then
     begin
          evalexpresionreal(arbol^.hijos.elem[2],estado,aux,matrizaux,tipoaux);
          fil:=trunc(aux);
          evalexpresionreal(arbol^.hijos.elem[4],estado,aux,matrizaux,tipoaux);
          col:=trunc(aux);
          Resultadoreal:= valorde(estado,Idvar,fil,col,encontrado);
          tipo:=treall;
     end else
     begin
          buscarvar(idvar,estado,indice,encontrado);
          //writeln('Depuracion: Intentando evaluar variable: ', idvar, ' en nodo con simbolo: ', arbol^.simbolo); //Prueba para ver si el simbolo del nodo es lo esperado 28/02/2026
          if estado.elementos[indice].Tipo = treall then
          begin
            tipo:=treall;
            resultadoreal:= valorde(estado,idvar,0,0,encontrado);
          end else
          begin
            tipo:= tmatrizl;
            resultadomatriz:= estado.elementos[indice].ValMatriz;
          end;
     end;
end;

//<CM> ::= “{" <M> "}”
Procedure evalCM(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz);
var
    maxcol,col,i,j:integer;
begin
     maxcol:=0;
     col:=0;
     ResultadoMatriz.filas:=0;
     for i:=1 to maxmatriz do
         for j:=1 to maxmatriz do
             resultadoMatriz.celdas[i,j]:=0;
     ResultadoMatriz.columnas:=0;
     evalM(arbol^.hijos.elem[2], estado,resultadomatriz,maxcol,col);
     resultadoMatriz.columnas:=maxcol;
end;

//<M> ::= “{" <Fila> "}” <J>
Procedure evalM(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);
begin
     inc(resultadomatriz.filas);
     evalFila(arbol^.hijos.elem[2], estado,resultadomatriz,maxcol,col);
     EvalJ(arbol^.hijos.elem[4],estado,resultadomatriz, maxcol);
end;

//<J> ::= “,” <M> | ε
Procedure evalJ(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; maxcol:integer);
var
    col:integer;
begin
     col:=0;
     if arbol^.hijos.cant <> 0 then
     begin
       evalM(arbol^.hijos.elem[2],estado,resultadomatriz,maxcol,col);
     end;
end;

//<Fila> ::= <ExpresiónReal> <K>
Procedure evalFila(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);
var
    auxreal:real;
    auxmatriz:tvarmatriz;
    auxtipo:ttipo;
begin
     inc(col);
     evalexpresionreal(arbol^.hijos.elem[1],estado,auxreal,auxmatriz,auxtipo);
     ResultadoMatriz.celdas[resultadoMatriz.filas,col]:=auxreal;
     evalK(arbol^.hijos.elem[2], estado,resultadomatriz,maxcol,col);
     if col > maxcol then maxcol:=col;
end;

//<K> ::= “,” <Fila> | ε
Procedure evalK(var Arbol:tArbolDerivacion; var estado:TEstado; var ResultadoMatriz:Tvarmatriz; var maxcol,col:integer);
begin
     if arbol^.hijos.cant <> 0 then
     begin
       evalFila(arbol^.hijos.elem[2],estado,resultadomatriz,maxcol,col);
     end;
end;

end.




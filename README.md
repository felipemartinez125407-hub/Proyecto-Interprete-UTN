# Felipe-Martinez
proyectos propios



Documentación del Intérprete — Lenguaje FAF.net
________________________________________
Descripción General del Lenguaje
El lenguaje de programación FAF.net está compuesto por una sección de declaración de variables seguida de un cuerpo de programa. Las variables pueden ser de tipo real, nat (natural) o matrix (matriz de reales con dimensiones fijas). Todas las variables deben ser declaradas antes de ser utilizadas.
El cuerpo del programa se delimita con llaves ({ }) y contiene una secuencia de sentencias separadas por punto y coma. Las sentencias disponibles son: asignaciones, lecturas, escrituras, condicionales (if/else) y ciclos (while).
El lenguaje soporta expresiones aritméticas sobre reales (suma, resta, multiplicación, división, potencia y raíz), y expresiones sobre matrices (suma, resta, multiplicación entre matrices, transposición, producto escalar). Las condiciones se expresan mediante operadores relacionales (<, >, ==, >=, <=, <>). El lenguaje es sensible a mayúsculas y minúsculas.
________________________________________
Descripción de la Semántica Asociada
Program: Representa la estructura completa del programa. Comienza con la palabra reservada program seguida del nombre del programa y la sección var con las declaraciones. Luego aparece la palabra cuerpo y el bloque de sentencias encerrado entre llaves.
Var: Declara las variables del programa. Cada declaración asigna un identificador a un tipo mediante el símbolo =. Las declaraciones terminan con punto y coma y se pueden encadenar.
Type: Define el tipo de una variable. Puede ser real (número real), nat (número natural, tratado internamente como real), o matrix[N, M] donde N y M son expresiones que determinan la cantidad de filas y columnas respectivamente (máximo 50x50).
ConjSentencias: Representa una secuencia de una o más sentencias, cada una separada por punto y coma. Permite que el cuerpo del programa ejecute múltiples acciones en secuencia.
B: Variable auxiliar de la gramática que permite encadenar conjuntos de sentencias. Deriva en otro ConjSentencias o en épsilon.
Sentencia: Representa una acción del programa. Puede ser una asignación, una lectura, una escritura, un condicional o un ciclo.
Asignacion: Asigna el resultado de una expresión a una variable. Si la variable es de tipo matriz, se puede asignar a una celda específica usando índices entre corchetes (id[fila, col] := expresion). Si es de tipo real o nat, la asignación es directa (id := expresion).
C: Variable auxiliar de la gramática para la asignación. Distingue entre asignación directa (:=) y asignación indexada a una celda de matriz ([expr, expr] := expr).
Read: Sentencia de lectura. Muestra una cadena por pantalla como prompt y lee un valor numérico desde la entrada estándar. Puede leer un escalar (read("mensaje", id)) o una celda de matriz (read("mensaje", id[fila, col])).
D: Variable auxiliar de la gramática para la lectura. Distingue entre lectura de variable escalar (cierra con )) y lectura de celda de matriz (índices entre corchetes antes del cierre).
Write: Sentencia de escritura. Imprime por pantalla una lista de uno o más elementos separados por comas: cadenas, expresiones reales o matrices completas.
ConjWrite: Representa un elemento o lista de elementos a imprimir. Puede comenzar con una cadena de texto o con una expresión real/matricial.
E: Variables auxiliares de la gramática que permiten encadenar múltiples elementos en la lista de escritura mediante comas.
Condicional: Estructura if <cond> then { <sentencias> } con rama opcional else then { <sentencias> }. Evalúa la condición y ejecuta el bloque correspondiente.
Y: Variable auxiliar que representa la rama opcional else del condicional. Si no hay rama else, deriva en épsilon.
While: Ciclo condicional while <cond> { <sentencias> }. Evalúa la condición y repite el bloque de sentencias mientras ésta sea verdadera.
Cond: Condición relacional formada por dos expresiones reales separadas por un operador relacional. Operadores disponibles: <, >, ==, >=, <=, <>.
ExpresionReal: Expresión aritmética que evalúa a un valor real o matricial. Está formada por un término seguido opcionalmente de sumas o restas.
SumRes : Variable auxiliar que maneja las sumas (+) y restas (-) de la expresión. Permite asociatividad por izquierda.
Termino: Componente de una expresión real formado por un término secundario seguido opcionalmente de multiplicaciones o divisiones.
MultDiv : Variable auxiliar que maneja multiplicaciones escalares (*) y divisiones (/). Tiene mayor precedencia que las sumas y restas.
TerminoSecundario: Componente de mayor precedencia en la expresión. Puede ser sqrt(expr, n) (raíz n-ésima), pot(base, exp) (potencia), una expresión entre paréntesis, o un operando simple.
Operando: Unidad básica de una expresión. Puede ser un identificador (con índices opcionales para matrices), un literal real, un literal natural, un operando negado (-), o una función matricial: add(m1, m2), substract(m1, m2), multiplication(m1, m2), transpose(m), multesc(m, escalar).
I: Variable auxiliar para el acceso indexado a matrices. Si está presente, incluye dos índices [fila, col]. Si es épsilon, se accede a la variable completa.
CM: Constante matriz literal definida entre llaves externas que envuelven a M.
M: Representa una fila de la constante matriz, encerrada entre llaves internas. Seguida de J para permitir múltiples filas.
J: Variable auxiliar que permite encadenar múltiples filas en la constante matriz mediante comas.
Fila: Secuencia de expresiones reales separadas por comas que representan los valores de una fila de la matriz.
K: Variable auxiliar que permite encadenar múltiples columnas dentro de una fila mediante comas.
CantFilasDe: Función especial cantFilasDe(id) que devuelve el número de filas de la matriz identificada por id como valor real.
CantColumnasDe: Función especial cantColumnasDe(id) que devuelve el número de columnas de la matriz identificada por id como valor real.
________________________________________
Componentes del Intérprete
Analizador Léxico 
El analizador léxico es responsable de transformar la secuencia de caracteres del archivo fuente en una secuencia de componentes léxicos (tokens). Implementa autómatas finitos determinísticos para reconocer los distintos tipos de tokens.
Tabla de Símbolos: Se inicializa con todas las palabras reservadas del lenguaje: program, var, cuerpo, real, nat, matrix, read, write, if, then, else, while, sqrt, pot, add, substract, multiplication, transpose, multesc, cantfilde, cantcolde. Si un identificador leído no se encuentra en la tabla, se agrega con el tipo Tid.
Reconocimiento de identificadores: Se implementa mediante un AFD de 4 estados. Un identificador válido comienza con una letra (a-z, A-Z) y puede contener letras, dígitos y guiones bajos (no puede terminar en guion bajo ni contener dos guiones seguidos). La comparación con la tabla de palabras reservadas se realiza en minúsculas para garantizar insensibilidad de palabras clave.
Reconocimiento de números: Se implementa mediante un AFD de 4 estados. Distingue entre naturales (solo dígitos, estado final 1 → TNat) y reales (dígitos, punto decimal, dígitos, estado final 3 → Treal).
Reconocimiento de cadenas: Se implementa mediante un AFD de 3 estados. Una cadena válida está delimitada por comillas dobles ("). El lexema almacenado no incluye las comillas.
Reconocimiento de símbolos especiales: Se reconocen los símbolos {, }, [, ], (, ), ,, +, -, *, /, =, ;. Para los símbolos potencialmente dobles (:=, ==, >=, <=, <>), se lee un carácter adicional para determinar si forman un operador compuesto.
________________________________________
Analizador Sintáctico 
El analizador sintáctico implementa un parser descendente predictivo no recursivo (LL(1)) basado en una Tabla de Análisis Sintáctico (TAS) y una pila explícita. Construye el árbol de derivación durante el análisis.
Tabla de Análisis Sintáctico (TAS): Es una tabla bidimensional indexada por variable gramatical y componente léxico (terminal). Cada celda contiene un puntero a la producción que debe aplicarse. Las celdas con cant = 0 representan producciones épsilon.
Árbol de Derivación: Se construye mediante nodos (tNodoArbol) que almacenan el símbolo gramatical, el lexema (para los terminales) y un arreglo de punteros a los nodos hijos. El árbol se guarda en un archivo de texto al finalizar el análisis exitoso.
Algoritmo: El parser mantiene una pila de pares (símbolo, nodo del árbol). Inicialmente apila el símbolo de fin (TEnd) y la variable inicial (VProgram). En cada iteración desapila el tope: si es un terminal, lo compara con el token actual; si es una variable, consulta la TAS y apila los símbolos de la producción correspondiente, agregando los nodos hijos al árbol. El análisis termina con éxito cuando se desapila TEnd y el token actual también es TEnd.
Manejo de errores: Si el tope de la pila es un terminal que no coincide con el token actual, o si la TAS no tiene entrada para una variable con el token actual, se reporta error sintáctico indicando qué se esperaba y qué se encontró. Si el token actual es TError, se reporta error léxico.
________________________________________
Analizador Semántico / Evaluador 
El evaluador recorre el árbol de derivación construido por el analizador sintáctico y ejecuta el programa. Implementa un estado que mantiene los valores de todas las variables declaradas.
Estado (TEstado): Arreglo de hasta 50 elementos, cada uno con: nombre del identificador, tipo (TrealL o TmatrizL), valor real y valor matricial. Las matrices se representan como arreglos bidimensionales de reales con sus dimensiones almacenadas.
Operaciones sobre matrices implementadas:
•	SumaMatrices: suma elemento a elemento; requiere dimensiones iguales.
•	RestaMatrices: implementada como suma con la segunda matriz multiplicada por -1.
•	MultiplicacionMatrices: producto matricial estándar; requiere que columnas de la primera iguale filas de la segunda.
•	TransposicionMatrices: transpone intercambiando filas y columnas.
•	MultEscalar: multiplica todos los elementos de la matriz por un escalar.
Evaluación de expresiones: Las expresiones se evalúan recursivamente siguiendo la estructura del árbol. Cada función eval recibe el nodo del árbol y el estado, y devuelve el resultado como un par (valor real, valor matricial) junto con el tipo resultado. Las prioridades de operadores se respetan por la estructura jerárquica de la gramática: pot/sqrt > *// > +/-.
Escritura de matrices: Se imprime en formato {{v1,v2,...},{v3,v4,...},...} con dos decimales por valor.
________________________________________
Gramática del Lenguaje
Gramática BNF
La forma BNF (Backus-Naur Form) es la representación canónica de la gramática, sin factorizar ni eliminar recursividad a izquierda. Permite visualizar la estructura completa del lenguaje.
<Program>          ::= "Program" "id" "var" <Var> "Cuerpo" "{" <ConjSentencias> "}"
<Var>              ::= "id" "=" <Type> ";" <Var>
                       | ε
<Type>             ::= "real"
                       | "nat"
                       | "Matrix" "[" "Nat" "," "Nat" "]"
<ConjSentencias>   ::= <Sentencia> ";"
                       | <Sentencia> ";" <ConjSentencias>
<Sentencia>        ::= <Asignacion>
                       | <Read>
                       | <Write>
                       | <Condicional>
                       | <While>
<Asignacion>       ::= "id" ":=" <ExpresionReal>
                       | "id" "[" <ExpresionReal> "," <ExpresionReal> "]" ":=" <ExpresionReal>
<Read>             ::= "read" "(" "string" "," "id" ")"
                       | "read" "(" "string" "," "id" "[" <ExpresionReal> "," <ExpresionReal> "]" ")"
<Write>            ::= "write" "(" <ConjWrite> ")"
<ConjWrite>        ::= "string"
                       | "string" "," <ConjWrite>
                       | <ExpresionReal>
                       | <ExpresionReal> "," <ConjWrite>
<Condicional>      ::= "if" <Cond> "then" "{" <ConjSentencias> "}"
                       | "if" <Cond> "then" "{" <ConjSentencias> "}" "else" "then" "{" <ConjSentencias> "}"
<While>            ::= "While" <Cond> "{" <ConjSentencias> "}"
<Cond>             ::= <ExpresionReal> "OpRel" <ExpresionReal>
<ExpresionReal>    ::= <ExpresionReal> "+" <ExpresionReal>
                       | <ExpresionReal> "-" <ExpresionReal>
                       | <ExpresionReal> "*" <ExpresionReal>
                       | <ExpresionReal> "/" <ExpresionReal>
                       | "-" <ExpresionReal>
                       | "(" <ExpresionReal> ")"
                       | "sqrt" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "pot" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "add" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "substract" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "multiplication" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "transpose" "(" <ExpresionReal> ")"
                       | "multEsc" "(" <ExpresionReal> "," <ExpresionReal> ")"
                       | "cantFilasDe" "(" "id" ")"
                       | "cantColumnasDe" "(" "id" ")"
                       | "id"
                       | "id" "[" <ExpresionReal> "," <ExpresionReal> "]"
                       | "Real"
                       | "Nat"
                       | <CM>
<CM>               ::= "{" <M> "}"
<M>               ::= "{" <Fila> "}"
                       | "{" <Fila> "}" "," <M>
<Fila>             ::= <ExpresionReal>
                       | <ExpresionReal> "," <Fila>
Gramática LL(1)
La gramática LL(1) es la versión factorizada y sin recursividad a izquierda, apta para ser analizada por un parser descendente predictivo con un token de lookahead. Se introducen variables auxiliares (B, C, D, E, I, J, K, SumRes, MultDiv, etc.) para eliminar las ambigüedades y las recursiones izquierdas de la BNF.
<Program>          ::= "Program" "id" "var" <Var> "Cuerpo" "{" <ConjSentencias> "}"
<Var>              ::= "id" "=" <Type> ";" <Var> | ε
<ConjSentencias>   ::= <Sentencia> ";" <B>
<B>                ::= <ConjSentencias> | ε
<Type>             ::= "real" | "Matrix" "[" "Nat" "," "Nat" "]" | "nat"
<Sentencia>        ::= <Asignacion> | <Read> | <Write> | <Condicional> | <While>
<Asignacion>       ::= "id" <C>
<C>                ::= <ExpresionReal> | "[" <ExpresionReal> "," <ExpresionReal> "]" ":=" <ExpresionReal>
<Read>             ::= "read" "(" "string" "," "id" <D>
<D>                ::= ")" | "[" <ExpresionReal> "," <ExpresionReal> "]" ")"
<Write>            ::= "write" "(" <ConjWrite> ")"
<ConjWrite>        ::= "string" <E> | <ExpresionReal> <E>
<E>                ::= "," <ConjWrite> | ε
<Condicional>      ::= "if" <Cond> "then" "{" <ConjSentencias> "}" <Y>
<Y>                ::= "else" "then" "{" <ConjSentencias> "}" | ε
<While>            ::= "While" <Cond> "{" <ConjSentencias> "}"
<Cond>             ::= <ExpresionReal> "OpRel" <ExpresionReal>
<ExpresionReal>    ::= <Termino> <SumRes>
<SumRes>           ::= "+" <ExpresionReal> | "-" <ExpresionReal> | ε
<Termino>          ::= <TerminoSecundario> <MultDiv>
<MultDiv>          ::= "*" <TerminoSecundario> <MultDiv> | "/" <TerminoSecundario> <MultDiv> | ε
<TerminoSecundario> ::= "sqrt" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | "pot" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | "(" <ExpresionReal> ")"
                        | <Operando>
<Operando>         ::= "id" <I>
                        | "Real" | "Nat"
                        | "-" <Operando>
                        | "add" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | "substract" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | "multiplication" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | "transpose" "(" <ExpresionReal> ")"
                        | "multEsc" "(" <ExpresionReal> "," <ExpresionReal> ")"
                        | <CM> | <CantFilasDe> | <CantColDe>
<CantFilasDe>      ::= "cantFilasDe" "(" "id" ")"
<CantColDe>        ::= "cantColumnasDe" "(" "id" ")"
<I>                ::= "[" <ExpresionReal> "," <ExpresionReal> "]" | ε
<CM>               ::= "{" <M> "}"
<M>                ::= "{" <Fila> "}" <J>
<J>                ::= "," <M> | ε
<Fila>             ::= <ExpresionReal> <K>
<K>                ::= "," <Fila> | ε
________________________________________
Programas de Ejemplo
Programa 7 — Multiplicación de dos matrices NxM
Lee dos matrices A (NxM) y B (MxP) elemento por elemento, las multiplica usando la función multiplication y muestra la matriz resultado.
Programa 8 — Normalización Min-Max por columna
Lee una matriz, calcula el mínimo y máximo de cada columna y normaliza cada valor según la fórmula: valor_norm = (valor - min) / (max - min). Muestra la matriz normalizada.
Programa 9 — Simetrizacion de una matriz
Lee una matriz cuadrada, luego calcula su matriz simétrica aplicando la fórmula: S = (A + Aᵀ) / 2. Para ello transpone la matriz ingresada usando transpose, suma la original con su transpuesta usando add, y multiplica el resultado por el escalar 0.5 con multesc. Finalmente muestra la matriz original y la matriz simetrizada resultante.





Codigo



program Tpsint;
uses crt, analizadorLexico, analizadorsintactico, AnalizadorSemantico;
var
  codigo:archcar;
     Tabla_simbolos:TablaDeSimbolos;
   //  complex:tipocomplex;
    // control:longint;
    // lex:string;
  arbol:Tarbolderivacion;
  Archivoarbol:text;
  control:LongInt;
  lexema:String;
  Complex:tipoComplex;
  TS:TabladeSimbolos;
  estado:TEstado;
//const
  //ruta= 'C:\Users\Franc\OneDrive\ProgramasSintaxis\Program Prueba7.txt'  ;

  // analizador_Sintactico(codigo, arbol);
 // evalinicio(arbol,estado);
  //readkey;

begin
   {InicializarTS(TS);
   Assign(codigo,ruta);
   Reset(codigo);

   While (Complex<>Terror) and (Complex<>Tend) do
   begin
     ObtenerSiguienteComplex(codigo,Control,TS,Complex,Lexema);
     write(Complex,':');
     writeln(Lexema);
     readkey;
   end;
   if complex=Terror then
   writeln('Error lexico');
   readkey; }

   analizador_Sintactico(codigo, arbol);
   evalprogram(arbol,estado);
   readkey;
end.


end. 


unit analizadorlexico;


interface

Const
    MaxSim = 200;
    Final = #130;
    ruta7='C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba7.txt';
    ruta8='C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba8 aux.txt';
    ruta9='C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba 9 aux.txt';
    ruta10=   'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\program traspon.txt';
type
archcar= File Of Char;
 TipoSimbGramatical = (Taux, Tprogram, Tid, Tvar, TasignacionTipo, Tbody, Tread , Twrite,TllaveA, TllaveC, Tif, Tthen, Twhile, Ttypereal, Ttypematrix, Ttypenat, Tpot, Tsqrt,
 TparentesisA, TparentesisC,TNat, Tmenos, Tmas, Ttranspose, TsubstractM, TaddM, TmultiplicationM, TtransposeM, Tmultesc, TcantFilDe, TcantColDe,TcorcheteA, TcorcheteC, Treal,
 Tstring, Tcoma, Telse, Tpuntoycoma, Tmultiplicacion, TopRel, Tasignacion, Tdivision, TEnd, TError, VProgram, Vvar,VConjSentencias, Vsentencia, Vb, Vtype,
 Vasignacion, Vc, Vread, Vd, Ve, Vf, Vwrite, VConjWrite, Vcondicional, Vy, Vwhile, VcantFilasDe, VcantColDe,Vcond, Vexpresionreal, Vg,Vtermino, Vh,
 Vterminosecundario, Voperando, Vi, Vcm, Vm, Vfila, Vj, Vk, epsilon);
 {27/01/2026 --> Se agregó TNat}

 { Tmenos es - y TsubstractM es resta de matrices  y lo mismo para las demas operaciones}

TipoComplex= Taux..Terror;
TElemTS = Record
          compLex: tipocomplex;
          Lexema: string;
        End;
TablaDeSimbolos = Record
        cant: 0..maxsim;
        elem: array[1..MaxSim] Of TElemTS;

        End;

procedure ObtenerSiguienteCompLex (var codigo:archcar; var control:longint; var tabla:tabladesimbolos; var complex:tipoCompLex; var lexema:string);
procedure InicializarTS(var Tabla:tablaDeSimbolos);
implementation

procedure agregaraTS(var tabla:tablaDeSimbolos; lex:string; comp:tipocomplex);
begin
   inc(tabla.cant);
   tabla.elem[tabla.cant].compLex:= comp;
   tabla.elem[tabla.cant].lexema:= lex;
end;

procedure InicializarTS(var Tabla:tablaDeSimbolos);
begin
   tabla.cant:=0;
   AgregaraTS(tabla,'program',tprogram);
   AgregaraTS(tabla,'var',tvar);
   AgregaraTS(tabla,'cuerpo',tbody);
   AgregaraTS(tabla,'real',Ttypereal);
   AgregaraTS(tabla, 'nat',Ttypenat);
   AgregaraTS(tabla,'matrix',Ttypematrix);
   agregaraTS(tabla,'read', tRead);
   AgregaraTS(tabla,'write',TWrite);
   AgregaraTS(tabla,'if', Tif);
   AgregaraTS(tabla,'then',Tthen);
   AgregaraTS(tabla,'else',Telse);
   AgregaraTS(tabla,'while',twhile);
   AgregaraTS(tabla,'sqrt',tsqrt);
   AgregaraTS(tabla,'pot',tpot);
   agregaraTS(tabla,'add',TaddM);
   agregaraTS(tabla,'substract',TsubstractM);
   AgregaraTS(tabla,'multiplication',tmultiplicationM);
   agregaraTS(tabla,'transpose',TtransposeM);
   AgregaraTS(tabla,'multesc',Tmultesc);
   AgregaraTS(tabla,'cantfilde',TcantFilDe);
   AgregaraTS(tabla,'cantcolde',TcantColDe);

end;

Procedure SalteaNoSignificativos(var codigo:archcar; var control:longint);
var
  caraux:char;
  posaux:longint;
begin
   posaux:=control;
   caraux:= #0;
   while (caraux in [#0..#32]) and (not eof(codigo)) do
     begin
       read(codigo,caraux);
       inc(posaux);
     end;
   if not (caraux in [#0..#32]) then control:= (posaux - 1) else control:=posaux;
   seek(codigo,control);                                                                                //Para posicionar puntero en el primer caracter no significativo
end;

Function EsIdentificador(var codigo:archcar; var control:longint; var lex:string):Boolean;
Const
  q0=0;
  F=[2];
Type
  Q=0..3;
  Sigma=(Palabra, Digito, Otro, Guion);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  controlaux:Integer;
  EstadoActual:Q;
  Delta:TipoDelta;
  CarActual: Char;
  Function CarASimb(Car:Char):Sigma;
Begin
  Case Car of
    'a'..'z', 'A'..'Z':CarASimb:=Palabra;
    '0'..'9'	     :CarASimb:=Digito;
    '_' : CarASimb:=Guion;
  else
   CarASimb:=Otro
  End;
End;

Begin
  controlaux:= control;
  CarActual:= 'a';
  Delta[0,Palabra]:=2;
  Delta[0,Digito]:=1;
  Delta[0,Otro]:=1;
  Delta[0,Guion]:=1;
  Delta[1,Digito]:=1;
  Delta[1,Guion]:=1;
  Delta[1,Palabra]:=1;
  Delta[1,Guion]:=1;
  Delta[2,Palabra]:=2;
  Delta[2,Digito]:=2;
  Delta[2,Guion]:=3;
  Delta[2,Otro]:=1;
  Delta[3,Palabra]:=2;
  Delta[3,Digito]:=2;
  Delta[3,Guion]:=1;
  Delta[3,Otro]:=1;

  EstadoActual:=q0;
  while (carasimb(CarActual) <> Otro) and not eof(codigo) do
  begin
       read(codigo,CarActual);
       inc(controlaux);
       if (carasimb(caractual) <> Otro) then
       begin
            lex:= lex+CarActual;
            EstadoActual:=Delta[EstadoActual,CarASimb(CarActual)];
            end else seek(Codigo,controlaux-1)
  end;
    if (estadoActual in F) then control:= (controlaux -1) else
     begin
       seek(codigo,control);
       lex:='';
     end;
EsIdentificador:=EstadoActual in F;
end;






// Cambiamos el nombre y agregamos "var complex" para devolver el tipo exacto
function EsNumero(var codigo:archcar; var control:longint; var lex:string; var complex:TipoComplex):boolean;
const
 q0=0;
 F=[1,3];
Type
 Q= 0..3;
 Sigma=(Digito, Punto, Otro);
 TipoDelta=Array[Q, Sigma] of Q;

Var
 controlaux:integer;
 EstadoActual:Q;
 Delta:TipoDelta;
 CarActual:char;
function carASImb(car:char):Sigma;
 begin
   case Car of
   '0'..'9': carASimb:=Digito;
   '.': carASimb:=Punto;
   else
     carASimb:=Otro;
   end;
 end;
begin
  CarActual:='1'; // Inicializacion dummy para entrar al while
  controlaux:=control;

  Delta[0, Otro]:=0;  Delta[0, Punto]:=0;  Delta[0, Digito]:=1;
  Delta[1, Otro]:=0;  Delta[1, Digito]:=1; Delta[1, Punto]:=2;
  Delta[2, Otro]:=2;  Delta[2, Punto]:=2;  Delta[2, Digito]:=3;
  Delta[3, Otro]:=2;  Delta[3, Punto]:=2;  Delta[3, Digito]:=3;

  EstadoActual:=q0;

  while (carAsimb(carActual) <> otro) and not eof(codigo) do
  begin
      read(codigo,caractual);
      inc(controlaux);

      {// PEQUEÑO ARREGLO DE SEGURIDAD PARA EOF
      if eof(codigo) and (carAsimb(caractual) <> otro) then
      begin
         Lex:= lex+caractual;
         EstadoActual:=Delta[EstadoActual, carASimb(CarActual)];
         break;
      end;   }

      if carAsimb(carActual) <> otro then
      begin
        Lex:= lex+caractual;
        EstadoActual:=Delta[EstadoActual, carASimb(CarActual)];
      end else Seek(codigo,(controlaux-1));
  end;

   // --- AQUÍ ESTÁ LA LÓGICA DE LA OPCIÓN B ---
   if (EstadoActual in F) then
   begin
       control:= (controlaux -1);

       // Si terminó en estado 1 (solo dígitos), es Natural
       if EstadoActual = 1 then
           complex := TNat
       // Si terminó en estado 3 (dígitos + punto + dígitos), es Real
       else
           complex := Treal;

       EsNumero:= True;
   end else
     begin
       seek(codigo,control);
       lex:='';
       EsNumero:= False;
     end;
end;



function EsCadena(var codigo:archcar; var control:longint; var lex:string):boolean;        //cambiar
  const
   q0=0;
   F=[2];
  Type
   Q= 0..3;
   Sigma=(Comilla, Otro);
   TipoDelta=Array[Q, Sigma] of Q;

  Var
   controlaux:integer;
   EstadoActual:Q;
   Delta:TipoDelta;
   caractual:char;
  function carASImb(car:char):Sigma;
   begin
     case Car of
     '"' : carASimb:=Comilla;
     else
       carASimb:=Otro;
     end;
   end;
begin

  controlaux:=control;
  Delta[0, Otro]:=3;
  Delta[0, Comilla]:=1;
  Delta[1, Otro]:=1;
  Delta[1, Comilla]:=2;
  Delta[2, Otro]:=3;
  Delta[2, Comilla]:=3;
  Delta[3, Otro]:=3;
  Delta[3, Comilla]:=3;

  EstadoActual:=q0;
  while not(EstadoActual in [2..3]) and (not eof(codigo)) do
    begin
        read(codigo,caractual);
        inc(controlaux);
        if EstadoActual <> 2 then
        begin
          if caractual <> '"' then Lex:= lex+caractual;                    //para guardar el lexema sin las comillas
          EstadoActual:=Delta[EstadoActual, carASimb(CarActual)];

        end else Seek(codigo,(controlaux-1));
    end;
  if (estadoActual in F) then control:= controlaux else
    begin
      seek(codigo,control);
      lex:='';
    end;
  EsCadena:=EstadoActual in F;
end;



Procedure InstalarEnTabla(var tabla:tablaDeSimbolos; lexema:string; var complex:tipoComplex);
var
 encontrado:boolean;
 i:byte;
begin
     i:=1;
     encontrado:= false;
     while (i <= tabla.cant) and (not encontrado) do
     begin
         if tabla.elem[i].lexema = lowercase(lexema) then                                               //se fija si está en la tabla, si está pasa el complex asociado, si no lo suma como id
         begin
           complex:= tabla.elem[i].complex;
           encontrado:=true
         end;
         inc(i);
     end;
     if not encontrado then
     begin
       agregaraTS(tabla, lexema, Tid);
       complex:=tid;
     end;
end;

function EsSimboloEspecial (var codigo:archcar; var control:longint; var lexema:string; var complex:tipocomplex):boolean;
var
 controlaux:longint;
 carActual:char;
 lexaux:string;
begin
  controlaux:=control;
  read(codigo,carActual);
  inc(controlaux);
  case CarActual of
       '{':  complex:= TllaveA;
       '}':  complex:= TllaveC;
       '[':  complex:= TcorcheteA;
       ']':  complex:= TcorcheteC;
       '(':  complex:= TparentesisA;
       ')':  complex:= TparentesisC;
       ',':  complex:= Tcoma;
       '+':  complex:= Tmas;
       '-':  complex:= Tmenos;
       '*':  complex:= Tmultiplicacion;
       '/':  complex:= Tdivision;
       '=':  complex:= TasignacionTipo;
       '<':  complex:= toprel;
       '>':  complex:= toprel;
       ';':  complex:= tpuntoycoma;
  end;
  Lexaux:=carActual;
  if ((not eof(codigo)) and (carActual in ['<'..'>',':']))then          //Para detectar los simbolos "dobles"
  begin
    read(codigo,carActual);
    inc(controlaux);
    Lexaux:= Lexaux + carActual;
    if lexaux = ':=' then
    begin
      complex:= Tasignacion;
      lexema:=lexaux;
    end else
    if (lexaux = '==') or (lexaux = '>=') or (lexaux = '<=') or (lexaux= '<>') then
    begin
      complex:= Toprel;
      lexema:=lexaux;
    end else
    begin
        dec(controlaux);
        lexaux:= lexaux[1];
        seek(codigo, controlaux);
    end;
  end;
  if complex in [Tprogram..Terror] then
  begin
    EsSimboloEspecial:= true;
    Control:=controlaux;
    lexema:= lexaux;
  end
  else EsSimboloEspecial:= false;

end;

procedure ObtenerSiguienteCompLex (var codigo:archcar ; var control:longint; var tabla:tabladesimbolos; var complex:tipoCompLex; var lexema:string);
begin
   lexema:='';
   complex:=Taux;
   SalteaNoSignificativos(Codigo,control);
   if eof(codigo) then complex:= Tend else
     begin
       SalteaNoSignificativos(Codigo,control);
       if esIdentificador(codigo, control, lexema) then InstalarEnTabla(tabla, lexema, complex)
       else if EsNumero(codigo, control, lexema, complex) then begin {} end
       else if EsCadena(codigo, control, lexema) then complex:= Tstring
       else if not EsSimboloespecial(codigo,control,lexema,complex) then complex:=Terror;

     end;

end;

end.

unit AnalizadorSintactico;

interface

uses
AnalizadorLexico, crt;

Const
MaxProd = 8;                                                                  //maximo de componentes lexicos de todas las producciones
RutaArbol= 'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\arbol.txt';

ruta7 =  'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba7.txt';
ruta8 =   'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba8 aux.txt';
ruta9 =   'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\Program Prueba 9 aux.txt';
ruta10=   'C:\Users\Felipe\Desktop\ProySIntaxis\Final FInal\program traspon.txt';
type

tProduccion = record
            elem: array[1..MaxProd] of Tiposimbgramatical;
            cant: 0..MaxProd;
end;
tVariables = VProgram..Vk;
tTerminalesyFinal = Tprogram..Tend;                                         //Se usa nomas para marcar el tamaño de la tas
tTAS = array[tVariables, tTerminalesyFinal] of ^tProduccion;
tArbolDerivacion= ^tNodoArbol;
tipoHijos = record
            elem: array[1..MaxProd] of TArbolDerivacion;
            cant:0..MaxProd;
end;
tNodoArbol = record
            simbolo: TiposimbGramatical;
            lexema:string;
            hijos: tipoHijos;
end;

tDatoPila=record
            simb:Tiposimbgramatical;
            nodo:TarbolDerivacion;
            end;
tPunteroPila=^tNodoPila;
tNodoPila=record
            info:tDatoPila;
            sig:tPunteroPila;
            end;
tPila=record
       tope:tPunteroPila;
       tam:word;
       end;
Procedure analizador_sintactico(var Codigo:archcar; var Arbol_derivacion:TarbolDerivacion);
procedure guardararbol(var ar:text; var raiz: tArbolderivacion; Desplazamiento:integer);


implementation
Procedure MostrarPila(P:tpunteropila; control:longint; lex:string);
var
paux:tpunteropila;
begin
  Paux:=p;
  while(paux<>nil) do
  begin
      writeln(paux^.info.simb);
      paux:=paux^.sig;
  end;

end;

Procedure crearPila(Var p:tPila);
Begin
  p.tam := 0;
  p.tope := Nil;
End;

Procedure apilar(Var p:tPila; simbolo:Tiposimbgramatical; nodo:tarbolderivacion);
Var dir: tPunteroPila;
Begin
  new(dir);
  dir^.info.simb:= simbolo;
  dir^.info.nodo:= nodo;
  dir^.sig := p.tope;
  p.tope := dir;
  inc(p.tam)
End;

Procedure desapilar(var p:tPila; var simbolo:TipoSimbGramatical; var nodo:tarbolderivacion);
Var dir: tPunteroPila;
Begin
  Simbolo := p.tope^.info.simb;
  nodo := p.tope^.info.nodo;
  dir := p.tope;
  p.tope := p.tope^.sig;
  dispose(dir);
  dec(p.tam)
End;

procedure apilarTodos(var celda:tProduccion; var padre:Tarbolderivacion; var p:tPila);
var
 n: 0..MaxProd;                                                               //apila todos los elementos de la produccion en la pila
Begin
  for n:= celda.cant downto 1 do apilar(p, celda.elem[n], padre^.hijos.elem[n]);
end;

procedure inicializarTAS(var TAS:tTAS);
var i, j:Tiposimbgramatical;
begin
  for i:=VProgram to Vk do
      for j:=tProgram to tend do
      TAS[i, j] := nil;
end;

Procedure crear_nodo(var nodo:TArbolderivacion);
begin
 new(nodo);
 nodo^.Simbolo:=taux;
 nodo^.lexema:='';
 nodo^.Hijos.cant:= 0;
end;

procedure CargarTAS(var TAS:tTAS);
begin
   new(TAS[VProgram,Tprogram]);
   TAS[VProgram,Tprogram]^.elem[1]:=TProgram;
   TAS[VProgram,Tprogram]^.elem[2]:=Tid;
   TAS[VProgram,Tprogram]^.elem[3]:=TVar;
   TAS[VProgram,Tprogram]^.elem[4]:=Vvar;
   TAS[VProgram,Tprogram]^.elem[5]:=Tbody;
   TAS[VProgram,Tprogram]^.elem[6]:=TllaveA;
   TAS[VProgram,Tprogram]^.elem[7]:=VConjsentencias;
   TAS[VProgram,Tprogram]^.elem[8]:=TllaveC;
   TAS[VProgram,Tprogram]^.cant:=8;

   new(TAS[Vvar,Tid]);
   TAS[Vvar,Tid]^.elem[1]:=Tid;
   TAS[Vvar,Tid]^.elem[2]:=Tasignaciontipo;
   TAS[Vvar,Tid]^.elem[3]:=Vtype;
   TAS[Vvar,Tid]^.elem[4]:=Tpuntoycoma;
   TAS[Vvar,Tid]^.elem[5]:=Vvar;
   TAS[Vvar,Tid]^.cant:=5;

   new(TAS[Vvar,Tbody]);
   TAS[Vvar,Tbody]^.cant:=0;                                           //se marca la cant en 0 para tomar epsilon

   new(TAS[Vconjsentencias, Tid]);
   TAS[Vconjsentencias,Tid]^.elem[1]:=Vsentencia;
   TAS[Vconjsentencias,Tid]^.elem[2]:=Tpuntoycoma;
   TAS[Vconjsentencias,Tid]^.elem[3]:=Vb;
   TAS[Vconjsentencias,Tid]^.cant:=3;

   new(TAS[VConjsentencias,TRead]);
   TAS[Vconjsentencias,Tread]^.elem[1]:=Vsentencia;
   TAS[Vconjsentencias,Tread]^.elem[2]:=Tpuntoycoma;
   TAS[Vconjsentencias,Tread]^.elem[3]:=Vb;
   TAS[Vconjsentencias,Tread]^.cant:=3;

   new(TAS[VConjsentencias,Twrite]);
   TAS[Vconjsentencias,Twrite]^.elem[1]:=Vsentencia;
   TAS[Vconjsentencias,Twrite]^.elem[2]:=Tpuntoycoma;
   TAS[Vconjsentencias,Twrite]^.elem[3]:=Vb;
   TAS[Vconjsentencias,Twrite]^.cant:=3;

   new(TAS[VConjsentencias,Tif]);
   TAS[VConjsentencias,Tif]^.elem[1]:=Vsentencia;
   TAS[Vconjsentencias,Tif]^.elem[2]:=Tpuntoycoma;
   TAS[Vconjsentencias,Tif]^.elem[3]:=Vb;
   TAS[Vconjsentencias,Tif]^.cant:=3;

   new(TAS[VConjsentencias,Twhile]);
   TAS[Vconjsentencias,Twhile]^.elem[1]:=Vsentencia;
   TAS[Vconjsentencias,Twhile]^.elem[2]:=Tpuntoycoma;
   TAS[Vconjsentencias,Twhile]^.elem[3]:=Vb;
   TAS[Vconjsentencias,Twhile]^.cant:=3;

   new(TAS[Vb,Tid]);
   TAS[Vb,Tid]^.elem[1]:=VConjsentencias;
   TAS[Vb,Tid]^.cant:=1;

   new(TAS[Vb,TRead]);
   TAS[Vb,Tread]^.elem[1]:=VConjsentencias;
   TAS[Vb,Tread]^.cant:=1;

   new(TAS[Vb,Twrite]);
   TAS[Vb,Twrite]^.elem[1]:=Vconjsentencias;
   TAS[Vb,Twrite]^.cant:=1;

   new(TAS[Vb,Tif]);
   TAS[Vb,Tif]^.elem[1]:=VConjsentencias;
   TAS[Vb,Tif]^.cant:=1;

   new(TAS[Vb,Twhile]);
   TAS[Vb,Twhile]^.elem[1]:=Vconjsentencias;
   TAS[Vb,Twhile]^.cant:=1;

   new(TAS[Vb,TllaveC]);
   TAS[Vb,TllaveC]^.cant:=0;

   new(TAS[Vtype,TTypeReal]);
   TAS[Vtype,TtypeReal]^.elem[1]:=TtypeReal;
   TAS[Vtype,TtypeReal]^.cant:=1;

   new(TAS[Vtype,Ttypematrix]);
   TAS[Vtype,Ttypematrix]^.elem[1]:=Ttypematrix;
   TAS[Vtype,Ttypematrix]^.elem[2]:=TcorcheteA;
   TAS[Vtype,Ttypematrix]^.elem[3]:=vexpresionreal;
   TAS[Vtype,Ttypematrix]^.elem[4]:=Tcoma;
   TAS[Vtype,Ttypematrix]^.elem[5]:=vexpresionreal;
   TAS[Vtype,Ttypematrix]^.elem[6]:=TcorcheteC;
   TAS[Vtype,Ttypematrix]^.cant:=6;

   new(TAS[Vtype, Ttypenat]);
   TAS[Vtype,Ttypenat]^.elem[1] := Ttypenat;
   TAS[Vtype,Ttypenat]^.cant := 1;

   new(TAS[Vsentencia,Tid]);
   TAS[Vsentencia,Tid]^.elem[1]:=Vasignacion;
   TAS[Vsentencia,Tid]^.cant:=1;

   new(TAS[Vsentencia,TRead]);
   TAS[Vsentencia,TRead]^.elem[1]:=VRead;
   TAS[Vsentencia,TRead]^.cant:=1;

   new(TAS[Vsentencia,Twrite]);
   TAS[Vsentencia,TWrite]^.elem[1]:=Vwrite;
   TAS[Vsentencia,Twrite]^.cant:=1;

   new(TAS[Vsentencia,Tif]);
   TAS[Vsentencia,Tif]^.elem[1]:=Vcondicional;
   TAS[Vsentencia,Tif]^.cant:=1;

   new(TAS[Vsentencia,Twhile]);
   TAS[Vsentencia,Twhile]^.elem[1]:=Vwhile;
   TAS[Vsentencia,Twhile]^.cant:= 1;

   new(TAS[Vasignacion, Tid]);
   TAS[Vasignacion,Tid]^.elem[1]:=Tid;
   TAS[Vasignacion,Tid]^.elem[2]:=Vc;
   TAS[Vasignacion,Tid]^.cant:=2;

   new(TAS[Vc,Tasignacion]);
   TAS[Vc,Tasignacion]^.elem[1]:=Tasignacion;
   TAS[Vc,tasignacion]^.elem[2]:=Vexpresionreal;
   TAS[Vc,tasignacion]^.cant:=2;

   new(TAS[Vc,TcorcheteA]);
   TAS[Vc,TcorcheteA]^.elem[1]:=TcorcheteA;
   TAS[Vc,TcorcheteA]^.elem[2]:=Vexpresionreal;
   TAS[Vc,TcorcheteA]^.elem[3]:=Tcoma;
   TAS[Vc,TcorcheteA]^.elem[4]:=Vexpresionreal;
   TAS[Vc,TcorcheteA]^.elem[5]:=TcorcheteC;
   TAS[Vc,TcorcheteA]^.elem[6]:=Tasignacion;
   TAS[Vc,TcorcheteA]^.elem[7]:=Vexpresionreal;
   TAS[Vc,TcorcheteA]^.cant:=7;

   new(TAS[VRead,TRead]);
   TAS[VRead,TRead]^.elem[1]:=TRead;
   TAS[Vread,Tread]^.elem[2]:=TparentesisA;
   TAS[Vread,Tread]^.elem[3]:=Tstring;
   TAS[Vread,Tread]^.elem[4]:=Tcoma;
   TAS[Vread,Tread]^.elem[5]:=Tid;
   TAS[Vread,Tread]^.elem[6]:=Vd;
   TAS[Vread,Tread]^.cant:=6;

   new(TAS[Vd,TcorcheteA]);
   TAS[Vd,TcorcheteA]^.elem[1]:=TcorcheteA;
   TAS[Vd,TcorcheteA]^.elem[2]:=Vexpresionreal;
   TAS[Vd,TcorcheteA]^.elem[3]:=Tcoma;
   TAS[Vd,TcorcheteA]^.elem[4]:=Vexpresionreal;
   TAS[Vd,TcorcheteA]^.elem[5]:=TcorcheteC;
   TAS[Vd,TcorcheteA]^.elem[6]:=TparentesisC;
   TAS[Vd,TcorcheteA]^.cant:=6;

   new(TAS[Vd,TparentesisC]);
   TAS[Vd,TparentesisC]^.elem[1]:=TparentesisC;
   TAS[Vd,TparentesisC]^.cant:=1;

   new(TAS[Vwrite,Twrite]);
   TAS[Vwrite,Twrite]^.elem[1]:=Twrite;
   TAS[Vwrite,Twrite]^.elem[2]:=TparentesisA;
   TAS[Vwrite,Twrite]^.elem[3]:=VConjWrite;
   TAS[Vwrite,Twrite]^.elem[4]:=TparentesisC;
   TAS[Vwrite,Twrite]^.cant:=4;

   new(TAS[VConjWrite,Tid]);
   TAS[VConjWrite,Tid]^.elem[1]:=Vexpresionreal;
   TAS[VConjWrite,Tid]^.elem[2]:=Vf;
   TAS[VConjWrite,Tid]^.cant:=2;

   new(TAS[VConjWrite,TllaveA]);
   TAS[VConjWrite,TllaveA]^.elem[1]:=Vexpresionreal;
   TAS[VConjWrite,TllaveA]^.elem[2]:=Vf;
   TAS[VConjWrite,TllaveA]^.cant:=2;

   new(TAS[Vconjwrite,Tsqrt]);
   TAS[Vconjwrite,Tsqrt]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,Tsqrt]^.elem[2]:=Vf;
   TAS[Vconjwrite,Tsqrt]^.cant:=2;

   new(TAS[Vconjwrite,Tpot]);
   TAS[Vconjwrite,Tpot]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,Tpot]^.elem[2]:=Vf;
   TAS[Vconjwrite,Tpot]^.cant:=2;

   new(TAS[Vconjwrite,TparentesisA]);
   TAS[Vconjwrite,TparentesisA]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TparentesisA]^.elem[2]:=Vf;
   TAS[Vconjwrite,TparentesisA]^.cant:=2;

   new(TAS[Vconjwrite,Treal]);
   TAS[Vconjwrite,Treal]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,Treal]^.elem[2]:=Vf;
   TAS[Vconjwrite,Treal]^.cant:=2;

   new(TAS[Vconjwrite,TNat]);
   TAS[Vconjwrite,TNat]^.elem[1]:=Vexpresionreal;            //NUEVO 10/2/2026
   TAS[Vconjwrite,TNat]^.elem[2]:=Vf;
   TAS[Vconjwrite,TNat]^.cant:=2;

   new(TAS[Vconjwrite,Tmenos]);
   TAS[Vconjwrite,Tmenos]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,Tmenos]^.elem[2]:=Vf;
   TAS[Vconjwrite,Tmenos]^.cant:=2;

   new(TAS[Vconjwrite,TsubstractM]);
   TAS[Vconjwrite,TsubstractM]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TsubstractM]^.elem[2]:=Vf;
   TAS[Vconjwrite,TsubstractM]^.cant:=2;

   new(TAS[VConjWrite,TmultiplicationM]);
   TAS[Vconjwrite,TmultiplicationM]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TmultiplicationM]^.elem[2]:=Vf;
   TAS[Vconjwrite,TmultiplicationM]^.cant:=2;

   new(TAS[Vconjwrite,TtransposeM]);
   TAS[Vconjwrite,TtransposeM]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TtransposeM]^.elem[2]:=Vf;
   TAS[Vconjwrite,TtransposeM]^.cant:=2;

   new(TAS[Vconjwrite,Tmultesc]);
   TAS[Vconjwrite,Tmultesc]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,Tmultesc]^.elem[2]:=Vf;
   TAS[Vconjwrite,Tmultesc]^.cant:=2;

   new(TAS[Vconjwrite,TaddM]);
   TAS[Vconjwrite,TaddM]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TaddM]^.elem[2]:=Vf;
   TAS[Vconjwrite,TaddM]^.cant:=2;

   new(TAS[Vconjwrite,TcantFilDe]);
   TAS[Vconjwrite,TcantFilDe]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TcantFilDe]^.elem[2]:=Vf;
   TAS[Vconjwrite,TcantFilDe]^.cant:=2;

   new(TAS[Vconjwrite,TcantColDe]);
   TAS[Vconjwrite,TcantColDe]^.elem[1]:=Vexpresionreal;
   TAS[Vconjwrite,TcantColDe]^.elem[2]:=Vf;
   TAS[Vconjwrite,TcantColDe]^.cant:=2;

   new(TAS[Vconjwrite,Tstring]);
   TAS[Vconjwrite,Tstring]^.elem[1]:=Tstring;
   TAS[Vconjwrite,Tstring]^.elem[2]:=Ve;
   TAS[Vconjwrite,Tstring]^.cant:=2;

   new(TAS[Ve,Tcoma]);
   TAS[Ve,Tcoma]^.elem[1]:=Tcoma;
   TAS[Ve,Tcoma]^.elem[2]:=Vconjwrite;
   TAS[Ve,Tcoma]^.cant:=2;

   new(TAS[Ve,TparentesisC]);
   TAS[Ve,TparentesisC]^.cant:=0;

   new(TAS[Vf,Tcoma]);
   TAS[Vf,Tcoma]^.elem[1]:=Tcoma;
   TAS[Vf,Tcoma]^.elem[2]:=Vconjwrite;
   TAS[Vf,Tcoma]^.cant:=2;

   new(TAS[Vf,TparentesisC]);
   TAS[Vf,TparentesisC]^.cant:=0;

   new(TAS[Vcondicional,Tif]);
   TAS[Vcondicional, Tif]^.elem[1]:=Tif;
   TAS[Vcondicional, Tif]^.elem[2]:=Vcond;
   TAS[Vcondicional, Tif]^.elem[3]:=Tthen;
   TAS[Vcondicional, Tif]^.elem[4]:=TllaveA;
   TAS[Vcondicional, Tif]^.elem[5]:=VConjsentencias;
   TAS[Vcondicional, Tif]^.elem[6]:=TllaveC;
   TAS[Vcondicional, Tif]^.elem[7]:=Vy;
   TAS[Vcondicional, Tif]^.cant:=7;

   new(TAS[Vy,Telse]);
   TAS[Vy, Telse]^.elem[1]:=Telse;
   TAS[Vy, Telse]^.elem[2]:=Tthen;
   TAS[Vy, Telse]^.elem[3]:=TllaveA;
   TAS[Vy, Telse]^.elem[4]:=Vconjsentencias;
   TAS[Vy, Telse]^.elem[5]:=TllaveC;
   TAS[Vy, Telse]^.cant:=5;

   new(TAS[Vy,Tpuntoycoma]);
   TAS[Vy, Tpuntoycoma]^.cant:=0;

   new(TAS[Vwhile,Twhile]);
   TAS[Vwhile, Twhile]^.elem[1]:=Twhile;
   TAS[Vwhile, Twhile]^.elem[2]:=Vcond;
   TAS[Vwhile, Twhile]^.elem[3]:=TllaveA;
   TAS[Vwhile, Twhile]^.elem[4]:=Vconjsentencias;
   TAS[Vwhile, Twhile]^.elem[5]:=TllaveC;
   TAS[Vwhile, Twhile]^.cant:=5;

   new(TAS[Vcond,Tid]);
   TAS[Vcond,Tid]^.elem[1]:=Vexpresionreal;
   TAS[Vcond,Tid]^.elem[2]:=Toprel;
   TAS[Vcond,Tid]^.elem[3]:=Vexpresionreal;
   TAS[Vcond,Tid]^.cant:=3;

   new(TAS[Vcond,TllaveA]);
   TAS[Vcond ,TllaveA]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TllaveA]^.elem[2]:=Toprel;
   TAS[Vcond ,TllaveA]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TllaveA]^.cant:=3;

   new(TAS[Vcond ,Tsqrt]);
   TAS[Vcond ,Tsqrt]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Tsqrt]^.elem[2]:=Toprel;
   TAS[Vcond ,Tsqrt]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Tsqrt]^.cant:=3;

   new(TAS[Vcond ,Tpot]);
   TAS[Vcond ,Tpot]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Tpot]^.elem[2]:=Toprel;
   TAS[Vcond ,Tpot]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Tpot]^.cant:=3;

   new(TAS[Vcond ,TparentesisA]);
   TAS[Vcond ,TparentesisA]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TparentesisA]^.elem[2]:=Toprel;
   TAS[Vcond ,TparentesisA]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TparentesisA]^.cant:=3;

   new(TAS[Vcond ,Treal]);
   TAS[Vcond ,Treal]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Treal]^.elem[2]:=Toprel;
   TAS[Vcond ,Treal]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Treal]^.cant:=3;

   new(TAS[Vcond ,TNat]);
   TAS[Vcond ,Treal]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Treal]^.elem[2]:=Toprel;
   TAS[Vcond ,Treal]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Treal]^.cant:=3;

   new(TAS[Vcond ,Tmenos]);
   TAS[Vcond ,Tmenos]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Tmenos]^.elem[2]:=Toprel;
   TAS[Vcond ,Tmenos]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Tmenos]^.cant:=3;

   new(TAS[Vcond ,TsubstractM]);
   TAS[Vcond ,TsubstractM]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TsubstractM]^.elem[2]:=Toprel;
   TAS[Vcond ,TsubstractM]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TsubstractM]^.cant:=3;

   new(TAS[Vcond ,TmultiplicationM]);
   TAS[Vcond ,TmultiplicationM]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TmultiplicationM]^.elem[2]:=Toprel;
   TAS[Vcond ,TmultiplicationM]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TmultiplicationM]^.cant:=3;

   new(TAS[Vcond ,TtransposeM]);
   TAS[Vcond ,TtransposeM]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TtransposeM]^.elem[2]:=Toprel;
   TAS[Vcond ,TtransposeM]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TtransposeM]^.cant:=3;

   new(TAS[Vcond ,Tmultesc]);
   TAS[Vcond ,Tmultesc]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,Tmultesc]^.elem[2]:=Toprel;
   TAS[Vcond ,Tmultesc]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,Tmultesc]^.cant:=3;

   new(TAS[Vcond ,TaddM]);
   TAS[Vcond ,TaddM]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TaddM]^.elem[2]:=Toprel;
   TAS[Vcond ,TaddM]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TaddM]^.cant:=3;

   new(TAS[Vcond ,TcantFilDe]);
   TAS[Vcond ,TcantFilDe]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TcantFilDe]^.elem[2]:=Toprel;
   TAS[Vcond ,TcantFilDe]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TcantFilDe]^.cant:=3;

   new(TAS[Vcond ,TcantColDe]);
   TAS[Vcond ,TcantColDe]^.elem[1]:=Vexpresionreal;
   TAS[Vcond ,TcantColDe]^.elem[2]:=Toprel;
   TAS[Vcond ,TcantColDe]^.elem[3]:=Vexpresionreal;
   TAS[Vcond ,TcantColDe]^.cant:=3;

   new(TAS[Vexpresionreal,Tid]);
   TAS[Vexpresionreal,Tid]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Tid]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Tid]^.cant:=2;

   new(TAS[Vexpresionreal,TllaveA]);
   TAS[Vexpresionreal,TllaveA]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TllaveA]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TllaveA]^.cant:=2;

   new(TAS[Vexpresionreal,Tsqrt]);
   TAS[Vexpresionreal,Tsqrt]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Tsqrt]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Tsqrt]^.cant:=2;

   new(TAS[Vexpresionreal,Tpot]);
   TAS[Vexpresionreal,Tpot]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Tpot]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Tpot]^.cant:=2;

   new(TAS[Vexpresionreal,TparentesisA]);
   TAS[Vexpresionreal,TparentesisA]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TparentesisA]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TparentesisA]^.cant:=2;

   new(TAS[Vexpresionreal,Treal]);
   TAS[Vexpresionreal,Treal]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Treal]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Treal]^.cant:=2;

   new(TAS[Vexpresionreal,TNat]);
   TAS[Vexpresionreal,TNat]^.elem[1]:=Vtermino;            //NUEVO 10/2/2026
   TAS[Vexpresionreal,TNat]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TNat]^.cant:=2;

   new(TAS[Vexpresionreal,Tmenos]);
   TAS[Vexpresionreal,Tmenos]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Tmenos]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Tmenos]^.cant:=2;

   new(TAS[Vexpresionreal,TsubstractM]);
   TAS[Vexpresionreal,TsubstractM]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TsubstractM]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TsubstractM]^.cant:=2;

   new(TAS[Vexpresionreal,TmultiplicationM]);
   TAS[Vexpresionreal,TmultiplicationM]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TmultiplicationM]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TmultiplicationM]^.cant:=2;

   new(TAS[Vexpresionreal,TtransposeM]);
   TAS[Vexpresionreal,TtransposeM]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TtransposeM]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TtransposeM]^.cant:=2;

   new(TAS[Vexpresionreal,Tmultesc]);
   TAS[Vexpresionreal,Tmultesc]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,Tmultesc]^.elem[2]:=Vg;
   TAS[Vexpresionreal,Tmultesc]^.cant:=2;

   new(TAS[Vexpresionreal,TaddM]);
   TAS[Vexpresionreal,TaddM]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TaddM]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TaddM]^.cant:=2;

   new(TAS[Vexpresionreal,TcantFilDe]);
   TAS[Vexpresionreal,TcantFilDe]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TcantFilDe]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TcantFilDe]^.cant:=2;

   new(TAS[Vexpresionreal,TcantColDe]);
   TAS[Vexpresionreal,TcantColDe]^.elem[1]:=Vtermino;
   TAS[Vexpresionreal,TcantColDe]^.elem[2]:=Vg;
   TAS[Vexpresionreal,TcantColDe]^.cant:=2;

   new(TAS[Vg,Tmenos]);
   TAS[Vg,Tmenos]^.elem[1]:=Tmenos;
   TAS[Vg,Tmenos]^.elem[2]:=Vexpresionreal;
   TAS[Vg,Tmenos]^.elem[3]:=Vg;
   TAS[Vg,Tmenos]^.cant:=3;

   new(TAS[Vg,Tmas]);
   TAS[Vg,Tmas]^.elem[1]:=Tmas;
   TAS[Vg,Tmas]^.elem[2]:=Vexpresionreal;
   TAS[Vg,Tmas]^.elem[3]:=Vg;
   TAS[Vg,Tmas]^.cant:=3;

   new(TAS[Vg,TparentesisC]);
   TAS[Vg,TparentesisC]^.cant:=0;

   new(TAS[Vg,Tcoma]);
   TAS[Vg,Tcoma]^.cant:=0;

   new(TAS[Vg,Toprel]);
   TAS[Vg,Toprel]^.cant:=0;

   new(TAS[Vg,TcorcheteC]);
   TAS[Vg,TcorcheteC]^.cant:=0;

   new(TAS[Vg,TllaveC]);
   TAS[Vg,TllaveC]^.cant:=0;

   new(TAS[Vg,TllaveA]);
   TAS[Vg,TllaveA]^.cant:=0;

   new(TAS[Vg,Tpuntoycoma]);
   TAS[Vg,Tpuntoycoma]^.cant:=0;

   new(TAS[Vg,Tthen]);
   TAS[Vg,Tthen]^.cant:=0;

   new(TAS[Vtermino,Tid]);
   TAS[Vtermino,Tid]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Tid]^.elem[2]:=Vh;
   TAS[Vtermino,Tid]^.cant:=2;

   new(TAS[Vtermino,TllaveA]);
   TAS[Vtermino,TllaveA]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TllaveA]^.elem[2]:=Vh;
   TAS[Vtermino,TllaveA]^.cant:=2;

   new(TAS[Vtermino,Tsqrt]);
   TAS[Vtermino,Tsqrt]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Tsqrt]^.elem[2]:=Vh;
   TAS[Vtermino,Tsqrt]^.cant:=2;

   new(TAS[Vtermino,Tpot]);
   TAS[Vtermino,Tpot]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Tpot]^.elem[2]:=Vh;
   TAS[Vtermino,Tpot]^.cant:=2;

   new(TAS[Vtermino,TparentesisA]);
   TAS[Vtermino,TparentesisA]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TparentesisA]^.elem[2]:=Vh;
   TAS[Vtermino,TparentesisA]^.cant:=2;

   new(TAS[Vtermino,Treal]);
   TAS[Vtermino,Treal]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Treal]^.elem[2]:=Vh;
   TAS[Vtermino,Treal]^.cant:=2;

   new(TAS[Vtermino,TNat]);
   TAS[Vtermino,TNat]^.elem[1]:=Vterminosecundario;     //NUEVO 10/2/2026
   TAS[Vtermino,TNat]^.elem[2]:=Vh;
   TAS[Vtermino,TNat]^.cant:=2;

   new(TAS[Vtermino,Tmenos]);
   TAS[Vtermino,Tmenos]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Tmenos]^.elem[2]:=Vh;
   TAS[Vtermino,Tmenos]^.cant:=2;

   new(TAS[Vtermino,TsubstractM]);
   TAS[Vtermino,TsubstractM]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TsubstractM]^.elem[2]:=Vh;
   TAS[Vtermino,TsubstractM]^.cant:=2;

   new(TAS[Vtermino,TmultiplicationM]);
   TAS[Vtermino,TmultiplicationM]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TmultiplicationM]^.elem[2]:=Vh;
   TAS[Vtermino,TmultiplicationM]^.cant:=2;

   new(TAS[Vtermino,TtransposeM]);
   TAS[Vtermino,TtransposeM]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TtransposeM]^.elem[2]:=Vh;
   TAS[Vtermino,TtransposeM]^.cant:=2;

   new(TAS[Vtermino,Tmultesc]);
   TAS[Vtermino,Tmultesc]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,Tmultesc]^.elem[2]:=Vh;
   TAS[Vtermino,Tmultesc]^.cant:=2;

   new(TAS[Vtermino,TaddM]);
   TAS[Vtermino,TaddM]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TaddM]^.elem[2]:=Vh;
   TAS[Vtermino,TaddM]^.cant:=2;

   new(TAS[Vtermino,TcantFilDe]);
   TAS[Vtermino,TcantFilDe]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TcantFilDe]^.elem[2]:=Vh;
   TAS[Vtermino,TcantFilDe]^.cant:=2;

   new(TAS[Vtermino,TcantColDe]);
   TAS[Vtermino,TcantColDe]^.elem[1]:=Vterminosecundario;
   TAS[Vtermino,TcantColDe]^.elem[2]:=Vh;
   TAS[Vtermino,TcantColDe]^.cant:=2;

   new(TAS[Vh,TmultiplicationM]);
   TAS[Vh,TmultiplicationM]^.elem[1]:=TmultiplicationM;
   TAS[Vh,TmultiplicationM]^.elem[2]:=Vterminosecundario;
   TAS[Vh,TmultiplicationM]^.elem[3]:=Vh;
   TAS[Vh,TmultiplicationM]^.cant:=3;

   new(TAS[Vh,Tdivision]);
   TAS[Vh,Tdivision]^.elem[1]:=Tdivision;
   TAS[Vh,Tdivision]^.elem[2]:=Vterminosecundario;
   TAS[Vh,Tdivision]^.elem[3]:=Vh;
   TAS[Vh,Tdivision]^.cant:=3;

   new(TAS[Vh,Tmenos]);
   TAS[Vh,Tmenos]^.cant:=0;

   new(TAS[Vh,Tmas]);
   TAS[Vh,Tmas]^.cant:=0;

   new(TAS[Vh,TparentesisC]);
   TAS[Vh,TparentesisC]^.cant:=0;

   new(TAS[Vh,Tcoma]);
   TAS[Vh,Tcoma]^.cant:=0;

   new(TAS[Vh,Toprel]);
   TAS[Vh,Toprel]^.cant:=0;

   new(TAS[Vh,TcorcheteC]);
   TAS[Vh,TcorcheteC]^.cant:=0;

   new(TAS[Vh,TllaveC]);
   TAS[Vh,TllaveC]^.cant:=0;

   new(TAS[Vh,TllaveA]);
   TAS[Vh,TllaveA]^.cant:=0;

   new(TAS[Vh,Tthen]);
   TAS[Vh,Tthen]^.cant:=0;

   new(TAS[Vh,Tpuntoycoma]);
   TAS[Vh,Tpuntoycoma]^.cant:=0;

   new(TAS[Vterminosecundario,Tid]);
   TAS[Vterminosecundario,Tid]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,Tid]^.cant:=1;

   new(TAS[Vterminosecundario,Treal]);
   TAS[Vterminosecundario,Treal]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,Treal]^.cant:=1;

   new(TAS[Vterminosecundario,TNat]);
   TAS[Vterminosecundario,TNat]^.elem[1]:=Voperando;   //NUEVO 10/2/2026
   TAS[Vterminosecundario,TNat]^.cant:=1;

   new(TAS[Vterminosecundario,Tmenos]);
   TAS[Vterminosecundario,Tmenos]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,Tmenos]^.cant:=1;

   new(TAS[Vterminosecundario,TsubstractM]);
   TAS[Vterminosecundario,TsubstractM]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TsubstractM]^.cant:=1;

   new(TAS[Vterminosecundario,TmultiplicationM]);
   TAS[Vterminosecundario,TmultiplicationM]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TmultiplicationM]^.cant:=1;

   new(TAS[Vterminosecundario,TtransposeM]);
   TAS[Vterminosecundario,TtransposeM]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TtransposeM]^.cant:=1;

   new(TAS[Vterminosecundario,TMultEsc]);
   TAS[Vterminosecundario,TMulTEsc]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TMultEsc]^.cant:=1;

   new(TAS[Vterminosecundario,TaddM]);
   TAS[Vterminosecundario,TaddM]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TaddM]^.cant:=1;

   new(TAS[Vterminosecundario,Tsqrt]);
   TAS[Vterminosecundario,Tsqrt]^.elem[1]:=Tsqrt;
   TAS[Vterminosecundario,Tsqrt]^.elem[2]:=TparentesisA;
   TAS[Vterminosecundario,Tsqrt]^.elem[3]:=Vexpresionreal;
   TAS[Vterminosecundario,Tsqrt]^.elem[4]:=Tcoma;
   TAS[Vterminosecundario,Tsqrt]^.elem[5]:=Vexpresionreal;
   TAS[Vterminosecundario,Tsqrt]^.elem[6]:=TparentesisC;
   TAS[Vterminosecundario,Tsqrt]^.cant:=6;

   new(TAS[Vterminosecundario,Tpot]);
   TAS[Vterminosecundario,Tpot]^.elem[1]:=Tpot;
   TAS[Vterminosecundario,Tpot]^.elem[2]:=TparentesisA;
   TAS[Vterminosecundario,Tpot]^.elem[3]:=Vexpresionreal;
   TAS[Vterminosecundario,Tpot]^.elem[4]:=Tcoma;
   TAS[Vterminosecundario,Tpot]^.elem[5]:=Vexpresionreal;
   TAS[Vterminosecundario,Tpot]^.elem[6]:=TparentesisC;
   TAS[Vterminosecundario,Tpot]^.cant:=6;

   new(TAS[Vterminosecundario,TparentesisA]);
   TAS[Vterminosecundario,TparentesisA]^.elem[1]:=TparentesisA;
   TAS[Vterminosecundario,TparentesisA]^.elem[2]:=Vexpresionreal;
   TAS[Vterminosecundario,TparentesisA]^.elem[3]:=TparentesisC;
   TAS[Vterminosecundario,TparentesisA]^.cant:=3;

   new(TAS[Vterminosecundario,TllaveA]);
   TAS[Vterminosecundario,TllaveA]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TllaveA]^.cant:=1;

   new(TAS[Vterminosecundario,TcantFilDe]);
   TAS[Vterminosecundario,TcantFilDe]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TcantFilDe]^.cant:=1;

   new(TAS[Vterminosecundario,TcantColDe]);
   TAS[Vterminosecundario,TcantColDe]^.elem[1]:=Voperando;
   TAS[Vterminosecundario,TcantColDe]^.cant:=1;

   new(TAS[vOperando,Tid]);
   TAS[Voperando,Tid]^.elem[1]:=Tid;
   TAS[Voperando,Tid]^.elem[2]:=Vi;
   TAS[Voperando,Tid]^.cant:=2;

   new(TAS[vOperando,TllaveA]);
   TAS[Voperando,TllaveA]^.elem[1]:=Vcm;
   TAS[voperando,TllaveA]^.cant:=1;

   new(TAS[vOperando,Treal]);
   TAS[voperando,Treal]^.elem[1]:=Treal;
   TAS[Voperando,Treal]^.cant:=1;

   new(TAS[vOperando,TNat]);
   TAS[voperando,TNat]^.elem[1]:=TNat;             //NUEVO 10/2/2026
   TAS[Voperando,TNat]^.cant:=1;

   new(TAS[vOperando,Tmenos]);
   TAS[Voperando,Tmenos]^.elem[1]:=Tmenos;
   TAS[Voperando,Tmenos]^.elem[2]:=Voperando;
   TAS[Voperando,Tmenos]^.cant:=1;

   new(TAS[vOperando,TsubstractM]);
   TAS[vOperando,TsubstractM]^.elem[1]:=TsubstractM;
   TAS[vOperando,TsubstractM]^.elem[2]:=TparentesisA;
   TAS[vOperando,TsubstractM]^.elem[3]:=Vexpresionreal;
   TAS[vOperando,TsubstractM]^.elem[4]:=Tcoma;
   TAS[vOperando,TsubstractM]^.elem[5]:=Vexpresionreal;
   TAS[vOperando,TsubstractM]^.elem[6]:=TparentesisC;
   TAS[vOperando,TsubstractM]^.cant:=6;

   new(TAS[vOperando,TmultiplicationM]);
   TAS[vOperando,TmultiplicationM]^.elem[1]:=TmultiplicationM;
   TAS[vOperando,TmultiplicationM]^.elem[2]:=TparentesisA;
   TAS[vOperando,TmultiplicationM]^.elem[3]:=Vexpresionreal;
   TAS[vOperando,TmultiplicationM]^.elem[4]:=Tcoma;
   TAS[vOperando,TmultiplicationM]^.elem[5]:=Vexpresionreal;
   TAS[vOperando,TmultiplicationM]^.elem[6]:=TparentesisC;
   TAS[vOperando,TmultiplicationM]^.cant:=6;

   new(TAS[vOperando,TtransposeM]);
   TAS[vOperando,TtransposeM]^.elem[1]:=TtransposeM;
   TAS[vOperando,TtransposeM]^.elem[2]:=TparentesisA;
   TAS[vOperando,TtransposeM]^.elem[3]:=Vexpresionreal;
   TAS[vOperando,TtransposeM]^.elem[4]:=TparentesisC;
   TAS[vOperando,TtransposeM]^.cant:=4;

   new(TAS[vOperando,Tmultesc]);
   TAS[vOperando,Tmultesc]^.elem[1]:=Tmultesc;
   TAS[vOperando,Tmultesc]^.elem[2]:=TparentesisA;
   TAS[vOperando,Tmultesc]^.elem[3]:=Vexpresionreal;
   TAS[vOperando,Tmultesc]^.elem[4]:=Tcoma;
   TAS[vOperando,Tmultesc]^.elem[5]:=Vexpresionreal;
   TAS[vOperando,Tmultesc]^.elem[6]:=TparentesisC;
   TAS[vOperando,Tmultesc]^.cant:=6;

   new(TAS[vOperando,TaddM]);
   TAS[vOperando,TaddM]^.elem[1]:=TaddM;
   TAS[vOperando,TaddM]^.elem[2]:=TparentesisA;
   TAS[vOperando,TaddM]^.elem[3]:=Vexpresionreal;
   TAS[vOperando,TaddM]^.elem[4]:=Tcoma;
   TAS[vOperando,TaddM]^.elem[5]:=Vexpresionreal;
   TAS[vOperando,TaddM]^.elem[6]:=TparentesisC;
   TAS[vOperando,TaddM]^.cant:=6;

   new(TAS[vOperando,TcantFilDe]);
   TAS[Voperando,TcantFilDe]^.elem[1]:=VcantFilasDe;
   TAS[voperando,TcantFilDe]^.cant:=1;

   new(TAS[vOperando,TcantColDe]);
   TAS[voperando,TcantColDe]^.elem[1]:=VcantColDe;
   TAS[Voperando,TcantColDe]^.cant:=1;

   new(TAS[Vi,Tmenos]);
   TAS[Vi,Tmenos]^.cant:=0;

   new(TAS[Vi,Tmas]);
   TAS[Vi,Tmas]^.cant:=0;

   new(TAS[Vi,TparentesisC]);
   TAS[Vi,TparentesisC]^.cant:=0;

   new(TAS[Vi,Tcoma]);
   TAS[Vi,Tcoma]^.cant:=0;

   new(TAS[Vi,TmultiplicationM]);
   TAS[Vi,TmultiplicationM]^.cant:=0;

   new(TAS[Vi,Toprel]);
   TAS[Vi,Toprel]^.cant:=0;

   new(TAS[Vi,Tdivision]);
   TAS[Vi,Tdivision]^.cant:=0;

   new(TAS[Vi,TllaveA]);
   TAS[Vi,TllaveA]^.cant:=0;

   new(TAS[Vi,Tthen]);
   TAS[Vi,Tthen]^.cant:=0;

   new(TAS[Vi,TcorcheteC]);
   TAS[Vi,TcorcheteC]^.cant:=0;

   new(TAS[Vi,Tpuntoycoma]);
   TAS[Vi,Tpuntoycoma]^.cant:=0;

   new(TAS[Vi,TcorcheteA]);
   TAS[Vi,TcorcheteA]^.elem[1]:=TcorcheteA;
   TAS[Vi,TcorcheteA]^.elem[2]:=Vexpresionreal;
   TAS[Vi,TcorcheteA]^.elem[3]:=Tcoma;
   TAS[Vi,TcorcheteA]^.elem[4]:=Vexpresionreal;
   TAS[Vi,TcorcheteA]^.elem[5]:=TcorcheteC;
   TAS[Vi,TcorcheteA]^.cant:=5;

   new(TAS[VcantFilasDe, TcantFilDe]);
   TAS[VcantFilasDe, TcantFilDe]^.elem[1]:=TcantFilDe;
   TAS[VcantFilasDe, TcantFilDe]^.elem[2]:=TparentesisA;
   TAS[VcantFilasDe, TcantFilDe]^.elem[3]:=Tid;
   TAS[VcantFilasDe, TcantFilDe]^.elem[4]:=TparentesisC;
   TAS[VcantFilasDe, TcantFilDe]^.cant:=4;

   new(TAS[VcantColDe, TcantColDe]);
   TAS[VcantColDe, TcantColDe]^.elem[1]:=TcantColDe;
   TAS[VcantColDe, TcantColDe]^.elem[2]:=TparentesisA;
   TAS[VcantColDe, TcantColDe]^.elem[3]:=Tid;
   TAS[VcantColDe, TcantColDe]^.elem[4]:=TparentesisC;
   TAS[VcantColDe, TcantColDe]^.cant:=4;

   new(TAS[Vcm,TllaveA]);
   TAS[Vcm,TllaveA]^.elem[1]:=TllaveA;
   TAS[Vcm,TllaveA]^.elem[2]:=Vm;
   TAS[Vcm,TllaveA]^.elem[3]:=TllaveC;
   TAS[Vcm,TllaveA]^.cant:=3;

   new(TAS[Vm,TllaveA]);
   TAS[Vm,TllaveA]^.elem[1]:=TllaveA;
   TAS[Vm,TllaveA]^.elem[2]:=Vfila;
   TAS[Vm,TllaveA]^.elem[3]:=TllaveC;
   TAS[Vm,TllaveA]^.elem[4]:=Vj;
   TAS[Vm,TllaveA]^.cant:=4;

   new(TAS[Vfila,Tid]);
   TAS[Vfila,Tid]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Tid]^.elem[2]:=Vk;
   TAS[Vfila,Tid]^.cant:=2;

   new(TAS[Vfila,TllaveA]);
   TAS[Vfila,TllaveA]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TllaveA]^.elem[2]:=Vk;
   TAS[Vfila,TllaveA]^.cant:=2;

   new(TAS[Vfila,Tsqrt]);
   TAS[Vfila,Tsqrt]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Tsqrt]^.elem[2]:=Vk;
   TAS[Vfila,Tsqrt]^.cant:=2;

   new(TAS[Vfila,Tpot]);
   TAS[Vfila,Tpot]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Tpot]^.elem[2]:=Vk;
   TAS[Vfila,Tpot]^.cant:=2;

   new(TAS[vfila,TparentesisA]);
   TAS[Vfila,TparentesisA]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TparentesisA]^.elem[2]:=Vk;
   TAS[Vfila,TparentesisA]^.cant:=2;

   new(TAS[Vfila,Treal]);
   TAS[Vfila,Treal]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Treal]^.elem[2]:=Vk;
   TAS[Vfila,Treal]^.cant:=2;

   new(TAS[Vfila,TNat]);
   TAS[Vfila,TNat]^.elem[1]:=Vexpresionreal;         //NUEVO 10/2/2026
   TAS[Vfila,TNat]^.elem[2]:=Vk;
   TAS[Vfila,TNat]^.cant:=2;

   new(TAS[Vfila,Tmenos]);
   TAS[Vfila,Tmenos]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Tmenos]^.elem[2]:=Vk;
   TAS[Vfila,Tmenos]^.cant:=2;

   new(TAS[Vfila,TsubstractM]);
   TAS[Vfila,TsubstractM]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TsubstractM]^.elem[2]:=Vk;
   TAS[Vfila,TsubstractM]^.cant:=2;

   new(TAS[Vfila,TmultiplicationM]);
   TAS[Vfila,TmultiplicationM]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TmultiplicationM]^.elem[2]:=Vk;
   TAS[Vfila,TmultiplicationM]^.cant:=2;

   new(TAS[Vfila,TtransposeM]);
   TAS[Vfila,TtransposeM]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TtransposeM]^.elem[2]:=Vk;
   TAS[Vfila,TtransposeM]^.cant:=2;

   new(TAS[Vfila,Tmultesc]);
   TAS[Vfila,Tmultesc]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,Tmultesc]^.elem[2]:=Vk;
   TAS[Vfila,Tmultesc]^.cant:=2;

   new(TAS[Vfila,TaddM]);
   TAS[Vfila,TaddM]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TaddM]^.elem[2]:=Vk;
   TAS[Vfila,TaddM]^.cant:=2;

   new(TAS[Vfila,TcantFilDe]);
   TAS[Vfila,TcantFilDe]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TcantFilDe]^.elem[2]:=Vk;
   TAS[Vfila,TcantFilDe]^.cant:=2;

   new(TAS[Vfila,TcantColDe]);
   TAS[Vfila,TcantColDe]^.elem[1]:=Vexpresionreal;
   TAS[Vfila,TcantColDe]^.elem[2]:=Vk;
   TAS[Vfila,TcantColDe]^.cant:=2;

   new(TAS[Vj,Tcoma]);
   TAS[Vj,Tcoma]^.elem[1]:=Tcoma;
   TAS[Vj,Tcoma]^.elem[2]:=Vm;
   TAS[Vj,Tcoma]^.cant:=2;

   new(TAS[Vk,Tcoma]);
   TAS[Vk,Tcoma]^.elem[1]:=Tcoma;
   TAS[Vk,Tcoma]^.elem[2]:=Vfila;
   TAS[Vk,Tcoma]^.cant:=2;

   new(TAS[Vj,TllaveC]);
   TAS[Vj,TllaveC]^.cant:=0;

   new(TAS[Vk,TllaveC]);
   TAS[Vk,TllaveC]^.cant:=0;

end;

Procedure AgregarHijos(var Nodo:tarbolderivacion; Produccion:tProduccion);
var
 i:byte;
begin
 for i:=1 to produccion.cant do
 begin
   Crear_nodo(nodo^.hijos.elem[i]);
   nodo^.Hijos.elem[i]^.Simbolo:= produccion.elem[i];
   inc(nodo^.hijos.cant);
 end;
end;

Procedure analizador_sintactico(var Codigo:archcar; var Arbol_derivacion:TarbolDerivacion);
var
 Pila:tpila;
 TAS:tTas;
 Tabla_simbolos:TablaDeSimbolos;
 complex:tipocomplex;
 control:longint;
 lex:string;
 estado:(Enproceso,Error,Exito);
 Topepila:Tiposimbgramatical;
 NodoTopePila:tarbolderivacion;
 ArchivoArbol:text;
 aux:byte;
begin
  estado:=enproceso;
  control:=0;
  Assign(archivoArbol,rutaArbol);
  rewrite(archivoarbol);
  writeln('Elija el archivo a ejecutar');
  writeln('1. Punto 7.');
  writeln('2. Punto 8.');
  writeln('3. Punto 9.');
  writeln('4. Punto extr.');

  readln(aux);
  case aux of
        1:assign(codigo,ruta7);
        2:assign(codigo,ruta8);
        3:assign(codigo,ruta9);
        4:assign(codigo,ruta10);
  end;
  clrscr;
  reset(codigo);
  inicializarTS(Tabla_simbolos);
  crearPila(pila);
  InicializarTAS(tas);
  cargarTAS(tas);
  Crear_nodo(arbol_derivacion);
  arbol_derivacion^.simbolo:=VProgram;
  apilar(pila,Tend,nil);
  apilar(pila,vprogram,arbol_derivacion);
  ObtenerSiguienteComplex(codigo,control,tabla_simbolos,complex,lex);

  while estado = enproceso do
  begin
        desapilar(pila,topepila,NodoTopepila);
        clrscr;
        MostrarPila(pila.tope, control,lex);                                                     //Lo usé para ir viendo la pila cuando marcaba error
        writeln('Desapilado = ',topepila, 'Lexema= ', lex, '  ',control);
        readkey;
        if (topepila in  [tprogram..tend]) then                                                //Si el tope es un terminal
        begin
             If TopePila = complex then
                if topepila = tend then estado:= exito
                  else
                    begin
                         NodoTopepila^.lexema:=Lex;
                         ObtenerSiguienteComplex(codigo,control,tabla_simbolos,complex,lex);
                    end
             else Estado:= error;
        end
        else if topepila in [VProgram..Vk] then                                                   //Si el tope es una variable
        begin
             if tas[Topepila,complex] <> nil then
             begin
                  AgregarHijos(nodoTopePila,tas[TopePila,complex]^);
                  apilarTodos(tas[TopePila,complex]^, NodoTopePila,pila);

             end
             else Estado:= error;
        end;
  end;
  if estado = error then
  begin
       if complex = terror then writeln('Error lexico') else
       begin
         writeln('Error Sintactico');
         writeln('Se esperaba ', topepila, ' pero se encontro ', complex);
       end;
       readkey
  end;
  If Estado = exito then guardararbol(ArchivoArbol,arbol_derivacion,0);
  close(archivoArbol);
  close(codigo);
End;


procedure guardarArbol(var ar:text; var raiz: tarbolderivacion; Desplazamiento:integer);
var
  i, j : integer;
begin
  if raiz = nil then exit;
   for j := 1 to Desplazamiento do
    write(ar, ' ');
    write(ar, raiz^.simbolo);
  if raiz^.lexema <> '' then
    write(ar, ' (', raiz^.lexema, ')');
    writeln(ar);
     for i:=1 to raiz^.hijos.cant do begin
        guardarArbol(ar, raiz^.hijos.elem[i], Desplazamiento + 4);
      end;
end;

end.

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

Procedure escribirMatriz(matriz:tvarmatriz);                            //provisional, podría mejorarse.
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

//<E> ::= “,” <ConjWrite> | ε
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






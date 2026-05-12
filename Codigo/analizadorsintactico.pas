unit AnalizadorSintactico;

interface

uses
AnalizadorLexico, crt;

Const
MaxProd = 8;                                                                  //maximo de componentes lexicos de todas las producciones
RutaArbol= 'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\arbol.txt';

ruta7 =  'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba7.txt';
ruta8 =   'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba8 aux.txt';
ruta9 =   'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba 9 aux.txt';

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
  readln(aux);
  case aux of
        1:assign(codigo,ruta7);
        2:assign(codigo,ruta8);
        3:assign(codigo,ruta9);
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

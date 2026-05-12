unit analizadorlexico;


interface

Const
    MaxSim = 200;
    Final = #130;
    ruta7 =  'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba7.txt';
    ruta8 =   'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba8 aux.txt';
    ruta9 =   'C:\Users\Fran\Desktop\Proyecto Sintaxis - Material para Presentar\Pruebas\Program Prueba 9 aux.txt';
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
  Delta[1,Guion]:=1;         //Estado rechazado en bucle
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


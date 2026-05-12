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

CLASS zcl_c02_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_c02_main IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    "Suma"
    DATA: lv_num_a TYPE i VALUE 20,
          lv_num_b TYPE i VALUE 5,
          lv_total TYPE p LENGTH 6 DECIMALS 2.

    lv_total = lv_num_a + lv_num_b.

    out->write( |Number a: { lv_num_a } + Number b: { lv_num_b } Total Suma: { lv_total } | ).

    "Obsolete ADD
    "ADD 5 TO lv_total."

    "+="
    lv_total += 5. "acumulador"
    out->write( | Total Suma: { lv_total } | ).

    lv_total = lv_num_a + lv_num_b + lv_total.
    out->write( | Total Suma: { lv_total } | ).

    CLEAR lv_total. "Limpiamos variable"
    out->write( | Total variable limpia: { lv_total } | ).



    "Resta"
    lv_total = lv_num_a - lv_num_b.
    out->write( |Number a: { lv_num_a } - Number b: { lv_num_b } Total Resta: { lv_total } | ).

    "Obsolete SUBTRACT"
    "SUBTRACT 2 FROM lv_total."

    lv_total = lv_num_a - 1.
    out->write( | Total Resta: { lv_total }| ).



    "Multiplicar"
    lv_total = lv_num_a * lv_num_b.
    out->write( |Number a: { lv_num_a } * Number b: { lv_num_b } Total Multiplicar: { lv_total } | ).

    "Obsolete MULTIPLY"
    "MULTIPLY lv_total by 5."
    "MULTIPLY lv_total BY lv_num_a."
    lv_total *= 5.
    out->write( | Total Multiply: { lv_total } | ).

    lv_total = lv_total * 2.
    out->write( | Total Multiply: { lv_total }| ).



    "DIVIDE"
    lv_total = lv_num_a / lv_num_b.
    out->write( |Number a: { lv_num_a } / Number b: { lv_num_b } Total Dividir: { lv_total } | ).

    "Obsolete DIVIDE"
    "DIVIDE lv_total BY 2."
    lv_total /= 2.
    out->write( |Total: { lv_total } | ).

    CLEAR lv_total.

    lv_total = ( lv_num_a + lv_num_b ) / 3.
    out->write( |Total Dividir { lv_total } | ).



    "DIV"
    lv_num_a = 9.
    lv_num_b = 4.
    lv_total = lv_num_a / lv_num_b.
    out->write( | Total DIV: { lv_total } | ).
    lv_total = lv_num_a DIV lv_num_b. "Devuelve el resultado entero de la división, sin decimales.
    out->write( | Total DIV: { lv_total } | ).



    "MOD"
    lv_total = lv_num_a / lv_num_b.
    out->write( | Total MOD: { lv_total } | ).

    lv_total = lv_num_a MOD lv_num_b. "Devuelve el resto de la división, 9 en 4 cabe dos veces y resta 1, por eso = 1
    out->write( | Total MOD: { lv_total } | ).



    "EXP"
    lv_num_a = 3.
    out->write( | Number a: { lv_num_a } | ).

    lv_num_a = lv_num_a ** 2.
    out->write( | Number a: { lv_num_a } | ).

    CLEAR lv_num_a.

    lv_num_a = 3.
    DATA(lv_exp) = 3. "Inline Declaration"
    lv_num_a = lv_num_a ** lv_exp.
    out->write( | Number a: { lv_num_a } | ).



    "ipow"
    DATA(lv_result) = ipow( base = 2 exp = 3 ).
    out->write( lv_result ).



    "sqrt"
    lv_num_a = sqrt( 25 ).
    out->write( | Total SQRT: { lv_num_a }| ).

    lv_num_a = 9.
    lv_num_a = sqrt( lv_num_a ).
    out->write( | Total SQRT: { lv_num_a }| ).



    DATA lv_date TYPE d.

    "Usando el valor de la fecha del sistema"
    lv_date = cl_abap_context_info=>get_system_date( ).
    out->write( lv_date ).



    "1. Truncamiento de caracteres"
    DATA: lv_string TYPE string VALUE 'LOGALI',
          lv_char   TYPE c LENGTH 2.

    "Se intenta guardar "LOGALI" (6 caracteres) en una variable de solo 2
    lv_char = lv_string.
    out->write( lv_char ).



    "2. Redondeo"
    DATA lv_decimal TYPE p LENGTH 3 DECIMALS 2.

    "Caso A redondea a 0.17: 1 / 6 = 0.166666..."
    lv_decimal = 1 / 6.
    out->write( lv_decimal ).

    "Caso B redondea a 0.08: 1 / 12 = 0.083333...
    lv_decimal = 1 / 12.
    out->write( |1 / 12 is rounded to { lv_decimal }| ).



    "Conversión de tipo forzado"
    "Funciona solo como texto"
    DATA(lv_date_converter) = '20250101'. "mostrar así en el depurador e imprimir
    out->write( lv_date_converter ).

    "Forma correcta y segura de convertir"
    DATA(lv_date_converter2) = CONV d( '20250101' ).
    out->write( lv_date_converter2 ).



    "Text Symbols"
    "Forma incorrecta. Implica que no sea traducible y que el mantenimiento sea más difícil al corregir errores"
    out->write( 'Welcome ABAP Student' ).
    out->write( 'This is your first text symbol' ).

    "Forma correcta para que el texto se guarde en etiquetas fuera del programa"
    "clic derecho y seleccionamos quick fix, creamos un text pool y pegamos el texto"
    "Se abrirá un archivo text elements donde se mostrarán todos los textos que tenemos que guardar y listo"
    "clic derecho open others > text elements"
    out->write( TEXT-001 ).
    out->write( TEXT-002 ).



    "Funciones de longitud"
    "strlen() and numofchar nos indica la longitud del texto
    DATA(lv_num) = strlen( 'Logali Group' ). "longitud del string"
    out->write( |Longitud del texto { lv_num } | ).

    lv_num = numofchar(  'Logali Group' ). "num de caracteres del string
    out->write( |Longitud del texto { lv_num } | ).



    "Funciones de búsqueda (count)"
    "Este tipo de función no nos indicará dónde se encuentra algo sino que nos dirá cuántas veces aparece ese patrón"
    DATA lv_string_count TYPE string VALUE 'LOGALI local'.
    DATA(lv_num_count) = strlen( lv_string_count ).
    "count"

    "Distingue entre mayúsculas y minúsculas (1 vez encontrará LO)"
    lv_num_count = count( val = lv_string_count sub = 'LO' ). "encuentra el número de coincidencias con el patrón exacto
    out->write( lv_num_count ).

    "Cuenta las apariciones de caracteres individuales distinguiendo entre mayúsculas y minúsculas (dos "L" y una "O")"
    lv_num_count = count_any_of( val = lv_string_count sub = 'LO' ). "encuentra las coincidencias no importa el orden
    out->write( lv_num_count ). "encuentra el caracter L dos veces y O una vez

    "Cuenta las veces que NO aparece la subcadena, distinguiendo entre mayúsculas y minúsculas por caracter individual"
    "El conteo de caracteres empieza desde la posición 0"
    lv_num_count = count_any_not_of( val = lv_string_count sub = 'LO' ).
    out->write( lv_num_count ). "devuelve todas las posiciones que no coinciden con el patrón



    "FIND"

    "Devuelve la primera posición donde comienza la primera aparición de la cadena que le indiquemos"
    lv_num_count = find( val = lv_string_count sub = 'LI' ).
    out->write( lv_num_count ).

    "Devuelve la posición del primer caracter que encuentre que esté en la subcadena, ya sea la L o la I"
    lv_num_count = find_any_of( val = lv_string_count sub = 'LI' ).
    out->write( lv_num_count ).

    "Devuelve la posición del primer caracter que no esté en la subcadena, ya sea la L o la I"
    "Si comenzamos a leer la cadena, en la posición 0 está la L, así que no cuenta, por eso nos indicaría la posición 1"
    lv_num_count = find_any_not_of( val = lv_string_count sub = 'LI' ).
    out->write( lv_num_count ).



    "Funciones de procesamiento"
    DATA lv_string_processing TYPE string VALUE ' ¡Logali Group! Welcome to ABAP Cloud Master '.
    "Change Case of characters"

    "Convierte todo el texto a mayúsculas"
    out->write( |TO_UPPER   =  { to_upper( lv_string_processing ) }| ).
    "Convierte todo el texto a minúsculas"
    out->write( |TO_LOWER   =  { to_lower( lv_string_processing ) }| ).
    "Pone solo la primera letra de cada palabra en mayúscula"
    out->write( |TO_MIXED   =  { to_mixed( lv_string_processing ) }| ).
    "Hace lo contrario: pasa una cadena tipo título a minúsculas completas"
    out->write( |FROM_MIXED =  { from_mixed( lv_string_processing ) }| ).
    "Invierte el texto (ejemplo: ABAP → PABA)"
    out->write( |REVERSE               = { reverse( lv_string_processing ) }| ).
    "Mueve los caracteres 5 posiciones a la izquierda, eliminando los primeros"
    out->write( |SHIFT_LEFT  (places)  = { shift_left(  val = lv_string_processing places   = 5 ) }| ).
    "Mueve los caracteres 5 posiciones a la derecha, llenando con espacios"
    out->write( |SHIFT_RIGHT (places)  = { shift_right( val = lv_string_processing places   = 5 ) }| ).
    "Rota los caracteres a la izquierda (los que salen por un lado entran por el otro)"
    out->write( |SHIFT_LEFT  (circ)    = { shift_left(  val = lv_string_processing circular = 5 ) }| ).
    "Lo mismo pero rotando hacia la derecha"
    out->write( |SHIFT_RIGHT (circ)    = { shift_right( val = lv_string_processing circular = 5 ) }| ).



    "Extract a Substring"
    "Corta la cadena desde la posición 9, con longitud 6"
    out->write( |SUBSTRING        = { substring(        val = lv_string_processing off = 9 len = 6 ) }| ).
    "Devuelve el texto desde “ABAP” en adelante"
    out->write( |SUBSTRING_FROM   = { substring_from(   val = lv_string_processing sub = 'ABAP' ) }| ).
    "Devuelve lo que viene después de "ABAP""
    out->write( |SUBSTRING_AFTER  = { substring_after(  val = lv_string_processing sub = 'ABAP' ) }| ).
    "Devuelve el texto hasta incluir "ABAP""
    out->write( |SUBSTRING_TO     = { substring_to(     val = lv_string_processing sub = 'ABAP' ) }| ).
    "Devuelve todo lo que hay antes de "ABAP""
    out->write( |SUBSTRING_BEFORE = { substring_before( val = lv_string_processing sub = 'ABAP' ) }| ).



    "Condense, Repeat and segment"
    "Elimina espacios extra (deja solo uno entre palabras y quita los del principio y final)"
    out->write( |CONDENSE = { condense( val = lv_string_processing ) }| ).
    "Repite el texto 2 veces seguidas"
    out->write( |REPEAT   = { repeat(   val = lv_string_processing occ = 2 ) }| ).
    "Devuelve la primera parte del texto antes del separador "!""
    out->write( |SEGMENT1 = { segment(  val = lv_string_processing sep = '!' index = 1 ) }| ).
    "Devuelve la segunda parte (lo que va después del primer "!")"
    out->write( |SEGMENT2 = { segment(  val = lv_string_processing sep = '!' index = 2 ) }| ).



    "Expresiones regulares - PCRE - REGEX"
    "Contains"
    DATA: lv_text    TYPE string,
          lv_pattern TYPE string.

    lv_text = 'The employee´s number is: 123-456-7890'.
    lv_pattern = `\d{3}-\d{3}-\d{4}`. "expresión regular (regex) que busca un formato de número de teléfono"

    IF contains( val = lv_text pcre = lv_pattern ).
      out->write( 'The text contains a phone number' ).
    ELSE.
      out->write( 'The text doesn´t contains a phone number' ).
    ENDIF.

    "Extrae el primer valor que cumpla el patrón"
    DATA(lv_number) = match( val = lv_text pcre = lv_pattern occ = 1 ).
    out->write( lv_number ).


    "Nuevos valores a nuestras variables"
    lv_string = 'Please contact us at support@logali.com for mor information'.
    lv_pattern = `\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b`. "regex for an email"

    IF contains( val = lv_string pcre = lv_pattern ). "verdadero"
      out->write( 'The text contains an email address' ).

      "Cuenta cuántos emails hay en total"
      DATA(lv_count) = count( val = lv_string pcre = lv_pattern ). "Cuántas veces hay coincidencias"
      out->write( lv_count ).

      "Devuelve la posición donde aparece el primer email dentro del texto"
      DATA(lv_pos) = find( val = lv_string pcre = lv_pattern occ = 1 ). "Dónde está en lv_string"
      out->write( lv_pos ).
    ELSE.
      out->write( 'The text does not contain an email address' ).
    ENDIF.



    "Concatenación"
    DATA: lv_string_concatenation_a TYPE string VALUE 'Welcome to Logali Group',
          lv_string_concatenation_b TYPE string.

    lv_string_concatenation_b = 'ABAP' && ` ` && 'Student'.

    "Forma recomendada"
    DATA(lv_fin_string) = |Concatenation 1: { lv_string_concatenation_a } / { lv_string_concatenation_b } |.
    out->write( lv_fin_string ).

    CONCATENATE lv_string_concatenation_a lv_string_concatenation_b INTO DATA(lv_fin_string2) SEPARATED BY ' '.
    out->write( |Concatenation 2: { lv_fin_string2 } | ).



    "Insert"
    "Inserta el texto 'INV' a partir de la posición 3"
    DATA(lv_ins_string) = insert( val = '123CLIENT02' sub = 'INV' off = 3 ).
    out->write( lv_ins_string ).

    "Inserta 'INV' al principio del texto"
    lv_ins_string = insert( val = '123CLIENT02' sub = `INV` ).
    out->write( lv_ins_string ).



    "Overlay"
    DATA(lv_company) = '--------------->Logali Group'.
    DATA(lv_name)    = 'ABAP_Class                  '.

    "Sobrescribe los caracteres de lv_name con los de lv_company, posición por posición"
    "Conserva la longitud de la variable original"
    OVERLAY lv_name WITH lv_company.
    out->write( lv_name ).

    DATA(lv_string_overlay)  = 'a.b.c.a.b.c.A'.
    DATA(lv_string_overlay2) = 'z.x.y.Z.x.y.z'.
    "Sobrescribe solo donde haya esas letras ('a' o 'b') en el texto base"
    OVERLAY lv_string_overlay WITH lv_string_overlay2 ONLY 'ab'.
    out->write( lv_string_overlay ).



    "SPLIT"
    DATA(lv_string_split) = 'Logali-Group-SAP-Academy'.
    out->write( lv_string_split ).

    "Divide la cadena cada vez que encuentra un - y guarda cada parte en una variable distinta"
    "(Como sabemos las variables que vamos a recibir pues las creamos (en este caso 4)"
    SPLIT lv_string_split AT '-' INTO DATA(gv_word1)
                                      DATA(gv_word2)
                                      DATA(gv_word3)
                                      DATA(gv_word4).


    out->write( gv_word1 ).
    out->write( gv_word2 ).
    out->write( gv_word3 ).
    out->write( gv_word4 ).


    "Si no sabemos cuántas variables vamos a recibir lo volcamos en tablas"
    "SPLIT .... INTO TABLE"
    DATA(lv_words) = VALUE string_table( ). "Tabla interna de tipo string"

    SPLIT lv_string_split AT '-' INTO TABLE lv_words.

    "Mostramos el contenido de la tabla"
    LOOP AT lv_words INTO DATA(lv_word).
      out->write( lv_word ).
    ENDLOOP.



    "REPLACE"
    DATA(lv_replace) = 'Logali-Group-SAP-Academy'.
    DATA(lv_sign) = '-'.

    "Obsolete REPLACE"
    "REPLACE '-' WITH '/' INTO lv_replace."

    REPLACE ALL OCCURRENCES OF '-' IN lv_replace WITH '/'.
    out->write( lv_replace ).

    "Forma recomendada reemplaza"
    lv_replace = replace( val = lv_replace sub = lv_sign with = '/' ).
    out->write( lv_replace ).

    "Desde la posición 5 quiero que reemplace 3 caracteres por '#'"
    lv_replace = replace( val = lv_replace with = `#` off = 5 len = 3 ).
    out->write( lv_replace ).



    "Funciones de comparación"
    DATA(lv_text_comparation) = 'This is an example text for SAP ABAP programming.'.

    " COMODINES:"
    " * = 0 o más caracteres"
    " + = 1 o más caracteres"
    " # = Exactamente 1 caracter"

    "CP (Contains Pattern) - verifica si contiene el patrón
    out->write( '--- Operador CP (Contains Pattern) ---' ).
    IF lv_text_comparation CP '*SAP*'.
      DATA(lv_match) = abap_true.
      out->write( 'El texto contiene el patrón "SAP"' ).
    ELSE.
      lv_match = abap_false.
      out->write( 'El texto NO contiene el patrón "SAP"' ).
    ENDIF.
    out->write( | | ).

    "NP (Not contains pattern) - Verifica si no contiene el patrón
    out->write( '--- Operador NP (Not Contains Pattern) ---' ).
    "El patrón 'g+' busca 'g' seguida de al menos 1 caracter"
    "En 'programming.' hay 'g.' que coincide con ese patrón"
    IF lv_text_comparation NP '*g+*'.
      out->write( 'El texto NO contiene el patrón "g+"' ).
    ELSE.
      out->write( 'El texto SÍ contiene el patrón "g+" (ej: "programing.")' ).
    ENDIF.



  ENDMETHOD.

ENDCLASS.

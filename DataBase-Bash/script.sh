#Programado en: Linux Mint 19.3 tricia

#!/bin/bash

# Comprueba si se han creado los archivos de las tablas
if [ ! -f Tabla1.txt ]
then   
    > Tabla1.txt
fi

if [ ! -f Tabla2.txt ]
then   
    > Tabla2.txt
fi

# Variables globales
separador="-,-"
actual=""
nAux=0
contador=0
array=()

# Comprueba si una entrada es de tipo entero
esEntero() {
    s=$(echo $1 | tr -d 0-9)
    if [ -z "$s" ]; then
        return 0
    else
        return 1
    fi
}

# Separa una cadena
separarCadena() {
    cadena=$1
    cadLen=${#cadena}
    sepLen=${#separador}
    i=0
    palLen=0
    strP=0
    array=()

    while [ $i -lt $cadLen ];
    do
        if [ $separador == ${cadena:$i:$sepLen} ]; 
        then
            array+=(${cadena:strP:$palLen})
            strP=$(( i + sepLen ))
            palLen=0
            i=$(( i + sepLen ))
        fi
        i=$(( i + 1 ))
        palLen=$(( palLen + 1 ))
    done
    
    array+=(${cadena:strP:$palLen})
}

# Ingresa datos a una tabla
ingresarDatosTabla() {
    clear 
    if [ -f "$1" -a ! -s "$1" ]
    then
        echo "Ingrese la cantidad de campos que tendra el archivo"
        echo ""
        echo "N: "
        read N
        
        if esEntero "$N";
        then
        nAux=$((N))
        else 
            echo ""
            echo "Ingrese un numero entero valido"
            echo ""
            echo "Presione Enter para continuar"
            read
            ingresarDatosTabla "$1"
        fi

        if [ $nAux == 0 ]
        then
            echo ""
            echo "Ingrese un numero entero mayor que cero"
            echo ""
            echo "Presione Enter para continuar"
            read
            ingresarDatosTabla "$1"
        fi
    else
        strAux="$( awk 'NR==1' $1 )"
        separarCadena "$strAux"
        nAux=${#array[@]}
    fi

    clear
    echo "Ingrese los campos"
    echo ""
    fila=""
    echo="$nAux"
    for (( i=1; i <= $((nAux+0)); i++  ))
    do
        echo "Campo $i:"
        read campo
        if [ -z "$campo" ]
        then
            echo "No puede quedar vacio"
            i=$((i-1))
        else
            if [ $i == $((nAux+0)) ]
            then
                fila=$fila$campo
            else
                fila=$fila$campo$separador
            fi 
        fi
    done

    echo "$fila">>$1
    echo ""
    echo "Datos guardados con exito"
}

# Ingresa datos a las tablas
ingresarDatos() {
    clear 
    echo "Seleccione la tabla"
    echo ""
    echo "1) Tabla 1"
    echo "2) Tabla 2"
    echo "3) Regresar"
	echo "Ingrese una opcion: "
    read opcion

    case $opcion in
    1)
        ingresarDatosTabla "Tabla1.txt"
    ;;
    2)
        ingresarDatosTabla "Tabla2.txt"
    ;;
    3)
    ;;
    *)
        echo ""
        echo ""
        echo "Ingrese una opcion valida"
        echo ""
        echo "Presione Enter para continuar"
        read
        ingresarDatos
    ;;
    esac
}

# Mostar datos de una tabla
mostarDatosTabla() {
    actual=$1
    clear
    if [ $1 == "Tabla1.txt" ]
    then
        echo "Tabla 1"
    else
        echo "Tabla 2"
    fi
    echo ""

    contador=0
    while IFS= read -r line; do
        contador=$((contador+1))
        separarCadena "$line"
        strAux2="${array[@]}"
        echo "$contador): $strAux2"
    done < $1

}

# Mostrar datos
mostarDatos() {
    clear 
    echo "Seleccione la tabla"
    echo ""
    echo "1) Tabla 1"
    echo "2) Tabla 2"
    echo "3) Regresar"
	echo "Ingrese una opcion: "
    read opcion

    case $opcion in
    1)
        mostarDatosTabla "Tabla1.txt"
    ;;
    2)
        mostarDatosTabla "Tabla2.txt"
    ;;
    3)
    ;;
    *)
        echo ""
        echo ""
        echo "Ingrese una opcion valida"
        echo ""
        echo "Presione Enter para continuar"
        read
        mostarDatos
    ;;
    esac
}

# Elimina datos de una tabla
eliminarDatos() {
    echo "Ingrese el indice del registro que desea eliminar"
    echo "N: "
    read n

    nAux2=0
    if esEntero "$n";
    then
    nAux2=$((n))
    else 
        echo ""
        echo "Ingrese un numero entero valido"
        echo ""
        echo "Presione Enter para continuar"
        read
        eliminarDatos "$1"
    fi

    if [ $nAux2 == 0 ]
    then
        echo "Saliendo"
    elif [ $nAux2 -gt $contador ]
    then
        echo ""
        echo "Ingrese un numero menor o igual que $contador"
        echo ""
        eliminarDatos "$1"    
    else
        sed -i $nAux2"d" $1
        echo ""
        echo "Registro eliminado con exito"
        echo ""
    fi
}

# Modifica datos de las tablas
modificarDatosTabla() {
    clear
    echo "Fila: "
    strAux="$( awk NR==$2 $1 )"
    separarCadena "$strAux"
    nAux=${#array[@]}
    strAux2="${array[@]}"
    echo "$strAux2"
    echo ""
    echo "Campos: "

    for (( i=0; i <= $((nAux-1)); i++ ))
    do
        echo "$((i+1))) ${array[$i]}"
    done
    echo "0) Salir"
    echo ""

    echo "Ingrese el indice del campo que desea modificar"
    echo "N: "
    read n

    nAux2=0
    if esEntero "$n";
    then
    nAux2=$((n))
    else 
        echo ""
        echo "Ingrese un numero entero valido"
        echo ""
        echo "Presione Enter para continuar"
        read
        modificarDatosTabla "$1" "$2"
    fi

    if [ $nAux2 == 0 ]
    then
        echo ""
        echo "Saliendo"
    elif [ $nAux2 -gt $nAux ]
    then
        echo ""
        echo "Ingrese un numero entero menor o igual que $nAux"
        echo ""
        echo "Presione Enter para continuar"
        read
        modificarDatosTabla "$1" "$2"   
    else

        for (( i=0; i<= 2; i++ ))
        do
            echo ""
            echo "Ingrese el nuevo valor del campo $nAux2: "
            read campoNuevo
            if [ -z $campoNuevo ]
            then
                echo "No puede quedar vacio"
                i=$((0))
            else
                i=$((3))
            fi
        done

        array[$((nAux2-1))]="$campoNuevo"

        strAux3=""
        for (( i=0; i <= $((nAux-1)); i++ ))
        do
            if [ $i == $((nAux-1)) ]
            then
                strAux3="$strAux3${array[$i]}"
            else
                strAux3="$strAux3${array[$i]}$separador"
            fi
        done

        nLine=$2
        echo ""
        echo "Registro modificado con exito"
        echo ""
        sed -i "${nLine}s/.*/$strAux3/" $1
    fi

}

# Modifica datos
modificarDatos() {
    strAux="$( awk 'NR==1' $1 )"
    separarCadena "$strAux"
    nAux=${#array[@]}
    echo "Ingrese el indice del registro que desea modificar"
    echo "N: "
    read n

    nAux2=0
    if esEntero "$n";
    then
    nAux2=$((n))
    else 
        echo ""
        echo "Ingrese un numero entero valido"
        echo ""
        echo "Presione Enter para continuar"
        read
        modificarDatos "$1"
    fi

    if [ $nAux2 == 0 ]
    then
        echo "Saliendo"
    elif [ $nAux2 -gt $contador ]
    then
        echo ""
        echo "Ingrese un numero menor o igual que $contador"
        echo ""
        modificarDatos "$1"    
    else
        modificarDatosTabla $1 $nAux2
    fi
}

# Consultar datos de tabla
consultarDatosTabla() {
    strAux="$( awk 'NR==1' $1 )"
    separarCadena "$strAux"
    nAux=${#array[@]}

    clear 
    echo "Ingrese el numero del campo que quiere consultar"
    strAux4=""
    for (( i=1; i<=$nAux; i++ )) 
    do
        if [ $i == $nAux ]
        then
            strAux4=$strAux4" o "$i
        elif [ $i -eq 1 ]
        then
            strAux4=$strAux4$i
        else
            strAux4=$strAux4", "$i
        fi
    done
    echo "0) Salir"
    echo "$strAux4"
    echo "N: "
    read n
    nAux2=$((n))

    if [ $nAux2 == 0 ]
    then
        echo ""
        echo "Saliendo"
    elif [ $nAux2 -gt $nAux ]
    then
        echo ""
        echo "Ingrese un numero menor o igual que $nAux"
        echo ""
        echo "Presione Enter para continuar"
        read
        consultarDatosTabla "$1"    
    else
        echo ""
        echo "Ingrese el valor del campo a consultar"
        read campoAux

        contador=0
        echo ""
        echo "Resultados"
        while IFS= read -r line; do
            separarCadena "$line"
            strAux2="${array[@]}"
            if [ $campoAux == ${array[$((nAux2-1))]} ]
            then
                contador=$((contador+1))
                echo "$contador): $strAux2"
            fi
        done < $1

        if [ $contador == 0 ]
        then
            echo ""
            echo "No se encontraron resultados" 
        fi

    fi
}

# Consultar datos
consultarDatos() {
    clear 
    echo "Seleccione la tabla"
    echo ""
    echo "1) Tabla 1"
    echo "2) Tabla 2"
    echo "3) Regresar"
	echo "Ingrese una opcion: "
    read opcion

    case $opcion in
    1)
        consultarDatosTabla "Tabla1.txt"
    ;;
    2)
        consultarDatosTabla "Tabla2.txt"
    ;;
    3)
    ;;
    *)
        echo ""
        echo ""
        echo "Ingrese una opcion valida"
        echo ""
        echo "Presione Enter para continuar"
        read
        mostarDatos
    ;;
    esac
}

# Bucle principal
while [ TRUE ]
do
	clear
	echo "Taller Evaludado 2 - SIO"
	echo ""
	echo "1 - Ingresar datos"
	echo "2 - Borrar datos"
	echo "3 - Modificar datos"
	echo "4 - Consultar datos"
	echo "5 - Salir"
	echo "Ingrese una opcion: "
	read opcion

    case $opcion in 
    1)
        ingresarDatos
    ;;
    2)
        mostarDatos

        if [ $contador == 0 ]
        then
            echo "La tabla esta vacia"
        else
            echo "0) Salir"
            echo ""
            eliminarDatos $actual
        fi
    ;;
    3)
        mostarDatos
        
        if [ $contador == 0 ]
        then
            echo "La tabla esta vacia"
        else
            echo "0) Salir"
            echo ""
            modificarDatos $actual
        fi
    ;;
    4)
        consultarDatos
    ;;
    5)
		echo ""
		echo "Presione Enter para continuar"
		read
		break
    ;;
    *)
		echo ""
		echo "Ingrese una opcion valida"
    ;;
    esac
	
	echo ""
	echo "Presione Enter para continuar"
	read	
done

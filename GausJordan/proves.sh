#!/bin/bash 
# aqui si ha de posar el path de la matriu a calcular el Gauss-Jordan i si ha de anomenar matriu.txt
cd /home/andreu/Escritorio/Uni/BashProjects/GausJordan/matriuRandom
# Guardem el valor de la columna del pibot que s'actualitza a cada volta al for principal 
PibotColum=1
#Us temporal de variables per matrius reduidas 
numReduitMatriu=0
# contem el num de columnes que hi ha (cuantitat de numeros per fila)
LimitColumnes=$(($(head -1 matriu.txt | wc -m)/3+1))
#Aqui creem la carpeta on guardar el resultat encara que nomes fa falta fer-ho un cop per tant comento la creació de la carpeta
mkdir MatriuReduida
#Aqui donarem el recorregut per files per agafar el pivot per despres fer el calculs habituals per fer Gauss Jordan
for filaRecorregut in $(cat matriu.txt)
do 
    #Aqui agafem el pivot de la matriu 
    Pibot=$(echo $filaRecorregut | cut -d: -f$PibotColum)
    PibotColum=$(($PibotColum + 1 ))
    #Aqui reduim cada fila via dividint per el pivot per fer les diferents proves 
    for filaAReduir in $(cat matriu.txt)
    do 
        for ((columne=1; columne<=$LimitColumnes; columne++))
        do 
            #El que fem es agafar individualment cada element dividintlo via 
            #un script de python senzill per fer floats ja que bash no els admet 
            num=$(echo $filaAReduir | cut -d: -f$columne)
            echo "print($num/$Pibot)" > divisio.py
            resultat=$(python3 divisio.py)
            valorNovaLinea=$valorNovaLinea":"$resultat
        done
        # Aqui guardem la fila dividida i la afegim a una matriu reduida 
        echo ${valorNovaLinea::length-1} >> MatriuReduida/matriuJordan$numReduitMatriu.txt
        # Aqui vuidem la variable 
        valorNovaLinea=""
    done
    numReduitMatriu=$(($numReduitMatriu+1))
done 

rm divisio.py 
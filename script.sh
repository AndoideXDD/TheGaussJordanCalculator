#!/bin/bash 
# aqui si ha de posar el path de la matriu a calcular el Gauss-Jordan 
cd /home/andreu/Escritorio/Uni/BashProjects/GausJordan/matriuRandom
PibotColum=1
PibotLine=1
NumLines=$(($(wc -l < matriu.txt)+1))
# Guardem el valor de la columna del pibot que s'actualitza a cada volta al for principal 
PibotColumlimit=1
# contem el num de columnes que hi ha (cuantitat de numeros per fila)
LimitColumnes=$(($(head -1 matriu.txt | wc -m)/3+1))
#Una variable per el bucle per veure el passos fets per el programa 
numReduitMatriu=0
#Aqui creem la carpeta on guardar el resultat encara que nomes fa falta fer-ho un cop per tant comento la creació de la carpeta
mkdir MatriuReduida
mkdir MatriuPerReduir
rm MatriuPerReduir/reductoraFila.txt
for ((eliominar=0; eliominar<=$LimitColumnes; eliominar++))
do
rm MatriuReduida/matriuJordan$eliominar.txt
done
clear 
for ((fila=0; fila<$NumLines; fila++))
do 
    #Treiem el pivot amb el for per poder anar actualitzant els pivots 
    Pibot=$(echo $(echo $(cat  matriu.txt | head -$PibotLine | tail -1 ) )| cut -d: -f$PibotColum)
    #Aqui divim la matriu entre el pibot per obtenir el 1 que volem 
    for ((columne=1; columne<=$LimitColumnes; columne++))
        do 
            #El que fem es agafar individualment cada element dividintlo via 
            #un script de python senzill per fer floats ja que bash no els admet 
            num=$(echo $(echo $(cat  matriu.txt | head -$PibotLine | tail -1 ) )| cut -d: -f$columne)
            echo "print($num/$Pibot)" > divisio.py
            resultat=$(python3 divisio.py)
            echo $resultat >> MatriuPerReduir/reductoraFila.txt
        done
        # Aqui guardem la fila dividida i la afegim a una matriu reduida 
        # Aqui vuidem la variable 
        valorNovaLinea=""
    # creem una variable per saber a quina fila estem 
    counterLine=1
    for filaAReduir in $(cat matriu.txt)
    do
        multiplicadorPerDonarO=$(echo $filaAReduir | cut -d: -f$PibotColum)  
        columnaR0=1
        if [[ $counterLine -eq $PibotLine ]]
        then 
            columnaR0=0    
            for num in $(cat MatriuPerReduir/reductoraFila.txt)
            do      
                valorNovaLinea=$valorNovaLinea":"$num
                columnaR0=$(($columnaR0+1))
            done
        else 
            for num in $(cat MatriuPerReduir/reductoraFila.txt)
            do 
                numPibotLine=$(echo $filaAReduir | cut -d: -f$columnaR0)
                
                echo "print($num*$multiplicadorPerDonarO-$numPibotLine)" > divisio.py
                resultat=$(python3 divisio.py)
                valorNovaLinea=$valorNovaLinea":"$resultat
                columnaR0=$(($columnaR0+1))
            done
        fi        
        # Aqui guardem el resultat de la reduccio 
        echo $valorNovaLinea| sed -e 's/^.//' >> MatriuReduida/matriuJordan$numReduitMatriu.txt
        counterLine=$(($counterLine+1))
        # Aqui vuidem la variable 
        valorNovaLinea=""
    done
    # Aqui eliminem els valors de la fila del pibot per guardar espai
    rm MatriuPerReduir/reductoraFila.txt
    #Aqui sobre escribim la matriu per donar la reduida 
    cat MatriuReduida/matriuJordan$numReduitMatriu.txt > matriu.txt
    numReduitMatriu=$(($numReduitMatriu+1))
    # Augmentem en un la columna i fila del pibot (per culpa d'aixo no podem fer que no siguin iguals, ja lo millorare )
    PibotColum=$(($PibotColum + 1 )) 
    PibotLine=$(($PibotLine + 1 )) 
done 
rm divisio.py

#!/bin/bash 
echo "Introduex el numero de columnes :"
read columnaLimit
echo "Introduex el numero de filas :"
read filaLimit
echo ""
#Borrem la matriu anterior 
rm matriu.txt
for (( columna=0; columna<$columnaLimit; columna++ ))
do  
    for ((fila=0; fila<$filaLimit; fila++))
    do 
        numRandoms=$(($RANDOM % 50))  
        valorFila=$numRandoms":"$valorFila
    done 
    echo ${valorFila::length-1} >> matriu.txt               
    valorFila=""
done
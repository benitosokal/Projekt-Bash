#!/bin/bash

#funkcja tworzaca talie
function create_deck () {
	for c in "♠" "♣" "♥" "♦"
	do
		deck=( ${deck[@]-} $(echo "A"$c) )
		for i in {2..10}
		do
			deck=( ${deck[@]-} $(echo $i$c) )
		done
		deck=( ${deck[@]-} $(echo "J"$c) )
		deck=( ${deck[@]-} $(echo "Q"$c) )
		deck=( ${deck[@]-} $(echo "K"$c) ) 
	done
}

#funkcja pobierajaca karte z tali i porzadkujaca talie
function get_card () {
	arr_nr=$((RANDOM%${#deck[@]}))
	card=${deck[$arr_nr]}
	unset deck[$arr_nr]
	max=${#deck[@]}
	for (( i=$arr_nr; i < $max; i++ ))
	do
		next=$i+1
		deck[$i]=${deck[$next]}
	done
	unset deck[$max]
}

#funkcja dodajaca do talii gracza
function add_to_player () {
	player=( ${player[@]-} $(echo $card) )
}

#funkcja dodajaca do talii krupiera
function add_to_croupier () {
	croupier=( ${croupier[@]-} $(echo $card) )
}

#funkcja liczaca wartosci kart gracza
function count_player () {
	unset L
	for c in ${player[@]} 
	do
		L=( ${L[@]-} $(echo ${c//[♠♣♥♦]/}) )
	done
	ps=0
	as_card=0
	for c in ${L[@]}
	do
		if [[ "$c" =~ ^[0-9]+$ ]]; then
			ps=$(( $ps + $c ))
		elif [[ "$c" =~ ^[KQJ]$ ]]; then
			ps=$(( $ps + 10 ))
		elif [[ "$c" =~ ^A$ ]]; then
			as_card=$(( $as_card + 1 ))	
		fi
	done
	for (( i=0; i < $as_card; i++ ))
	do
		temp=$(( $ps + 11 ))
		if [ $temp -gt 21 ]; then
			ps=$(( $ps + 1 ))
		else
			ps=$(( $ps + 11 ))
		fi 
	done
}

#funkcja liczaca wartosci kart krupiera
function count_croupier () {
	unset L	
	for c in ${croupier[@]} 
	do
		L=( ${L[@]-} $(echo ${c//[♠♣♥♦]/}) )
	done
	cs=0
	as_card=0
	for c in ${L[@]}
	do
		if [[ "$c" =~ ^[0-9]+$ ]]; then
			cs=$(( $cs + $c ))
		elif [[ "$c" =~ ^[KQJ]$ ]]; then
			cs=$(( $cs + 10 ))
		elif [[ "$c" =~ ^A$ ]]; then
			as_card=$(( $as_card + 1 ))	
		fi
	done
	for (( i=0; i < $as_card; i++ ))
	do
		temp=$(( $cs + 11 ))
		if [ $temp -gt 21 ]; then
			cs=$(( $cs + 1 ))
		else
			cs=$(( $cs + 11 ))
		fi 
	done
}

#funkcja resetujaca
function reset () {
	unset deck
	create_deck
	unset player
	unset croupier
}

#funkcja wypisujaca dane na ekranie
function show () {
	echo "Karty krupiera: "
	echo ${croupier[1]}
	echo "Twoje karty: "
	count_player	
	echo ${player[@]} "=" $ps  
}

#funkcja wypisująca wszystko na ekranie
function show_all () {
	echo "Karty krupiera: "
	count_croupier
	echo ${croupier[@]} "=" $cs
	echo "Twoje karty: "
	count_player	
	echo ${player[@]} "=" $ps  
}

#funkcja wypisująca możliwe opcje
function choice () {
	echo "1. Weź kolejną kartę"
	echo "2. Pas"
	echo "0. Koniec gry"
}

function get_choice() {
	while true; do
		echo -n "Wybór: "
		read ch
		if [[ "$ch" =~ ^[012]$ ]]; then
			break		
		fi
		echo "Podaj prawidłową wartość"
	done
}



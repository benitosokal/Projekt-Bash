#!/bin/bash

for arg in $@
do
	if [[ "$arg" == '-h' || "$arg" == '--help' ]]; then
cat << EOF

Gra w Oczko (Blackjack)

Gra polega na dobieraniu kolejnych kart dotąd, aby osiągnąć wartość liczbową 
posiadanych kart jak najbliższą (ale nie większą niż) 21. Gracz na początku 
każdego rozdania decyduje ile chce postawić pieniędzy. W zależności czy gracz 
przegrał lub wygrał, to za ilość postawionych pieniędzy jest dodawane do lub 
odejmowane z jego konta. Gracz otrzymuje kolejne karty z talii dotąd, aż sam 
zdecyduje, że nie chce już więcej kart. Suma większa lub równa 22 oznacza 
przegraną. Gracz gra doputy aż jego konto nie spadnie do zera.

EOF
		exit 0
	fi
done

source bjfunc.sh
source $HOME/lib/bjfunc.sh

#głowny program
bank=10
clear
while true; do
	if [ $bank -le 0 ]; then
		echo "Straciłeś wszystko"
		exit
	fi
	while true; do
		echo -n "Stan konta "
		echo $bank"$"
		echo -n "Ile chcesz postawić (minimum 1, 0 - kończy grę): "
		read bet
		if ! [[ "$bet" =~ ^[0-9]+$ ]]; then
			clear
			echo "Podaj prawidłową wartość"
			continue
		fi
		if [ $bet -eq 0 ]; then
			clear
			exit
		fi
		if [ $bet -lt 1 ]; then
			clear
			echo "Podaj wartość większą niż 1"
			continue
		fi
		if [ $bet -gt $bank ]; then
			clear
			echo "Stawka nie może być większa niż ilość posiadanych pieniędzy"
			continue
		fi
		break
	done
	clear
	create_deck
	get_card
	add_to_player
	get_card
	add_to_player
	get_card
	add_to_croupier
	get_card
	add_to_croupier
	echo -n "Stawka: "
	echo $bet"$"
	show
	choice
	get_choice
	while [ $ch -ne 0 ]; do
		clear
		echo -n "Stawka: "
		echo $bet"$"
		count_player		
		if [ $ch -eq 1 ]; then
			get_card
			add_to_player
			count_player
			show
			if [ $ps -gt 21 ]; then
				echo "Przegrałeś"
				bank=$(( $bank - $bet ))
				reset
				break
			fi				
		fi
		if [ $ch -eq 2 ]; then
			break
		fi
		choice
		get_choice		
	done
	if [ $ps -gt 21 ]; then
		continue
	fi
	clear
	show_all
	while true; do
		if [ $cs -gt 21 ]; then
			echo "Wygrałeś"
			bank=$(( $bank + $bet ))
			break		
		fi
		if [ $cs -gt $ps ]; then 
			echo "Przegrałeś"
			bank=$(( $bank - $bet ))
			break		
		fi
		if [ $cs -eq $ps ]; then 
			echo "Remis"
			break		
		fi 
		get_card
		add_to_croupier
		clear
		show_all		
	done
	if [ $ch -eq 0 ]; then
		clear
		exit
	fi
	reset		
done


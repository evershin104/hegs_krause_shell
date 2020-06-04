#!/bin/bash ######################################################### 
# Сценарий : Реализует сценарий эволюции математической модели Hegselman-Krause
# bounded confidence level in opinion dynamics. При запуске запрашивает у пользователя количество агентов. 
# Каждому агенту присваивается случайное мнение от 0 до количества агентов. Далее скрипт запрашивает 
# уровень уверенности (Confidence level) и максимально количество итераций эволюции модели
# если консенсус или не удается достигнуть. 
# Для каждого агента вычисляется группа доверия, в нее входят те агенты, мнение которых отличается 
# от мнения данного агента на величины меньшую либо равную confidence level (+ сам рассматриваемый агент). Находится среднее арифметическое
# для группы доверия и полученная величина присваивается агенту. И так для каждого агента каждую итерацию. 
# В случае, если изменение мнений прекратилось (эволюция модели остановлена) или достигнут консенсус (все мнения агентов равны)
# выводится соответствующее сообщение. 
# Автор : Vershinin Eldar 
# Дата : 2020.06.04
declare -i NUMBER			# Number of agents 
declare -i count			# Counter 
declare -a -i model[$NUMBER]		# Model array1
declare -a -i modelNext[$NUMBER]	# Model array2 is an array1 after iteration
declare -i CONF				# Confidence level
declare -i razn				# Opinion1 - opinion2 between two agents
declare -i iteration=0			# Iteration counter	

function calcRazn {					#
	if [ ${model[$i1]} -le ${model[$i2]} ] 		#	Calculates 
		then 					# difference between opinions
    	razn=model[$i2]-model[$i1]			# of two agents
		else 					#
    	razn=model[$i1]-model[$i2]			#
	fi						#
}							#	

function showModel {					#
	count=0						#	Shows opinions 
	echo "------t=$iteration----------"		# in model for each agent 
	while [ "$count" -le $NUMBER ]     		# and old array1 with new 
	do						# array2 after iteration
		model[$count]=${modelNext[$count]}	#
		echo $count. op = ${model[$count]}	#	
  		let "count += 1" 			#	
	done						#
	echo "-----------------"			#	
}							#

function nextIteration {					#
	for i1 in ${!model[@]} 					#	Calculates opinions				
	do							# for each agent and put it 				
	sum=${model[$i1]}					# in new array2. 	
	power=1							#					
	for i2 in ${!model[@]}					#			
	do							#						
		if [ $i1 -ne $i2 ]				#				
		then 						#					
		calcRazn					#					
			if [ $razn -le $CONF ]			#			
			then 					#					
				let 'sum += model[i2]'		#				
				let 'power += 1'		#				
			fi					#						
		fi						#						
		let 'modelNext[i1] = sum / power'		#			
	done							#						
done								#
let 'iteration += 1'						#	
}								#
								
function checkOnConsensus {					#
	count=0							#	Checks on consensus 
	for i in ${!modelNext[@]} 				# new array2 
	do							#
		if [ ${modelNext[$i]} -eq ${modelNext[1]} ]	#
		then 						#
		let 'count += 1'				#	
		fi						#
	done							#
	let 'count -= 1'					#	
	if [ $count -eq $NUMBER ] 				#
	then 							#	
		echo Consensus on $iteration iteration		#
		showModel					#
		exit						#	
	fi 							#
	count=0							#	
	for i in ${!model[@]}					#	Checks the model on stopping 
	do							# evolution if consensus wasn't reached 
		if [ ${modelNext[$i]} -eq ${model[$i]} ]	# in the last check (above)	
		then						#
			let 'count += 1'			#
		fi						#
	done							#	
	let 'count -= 1'					#
	if [ $count -eq $NUMBER ]				#	
	then 							#
		echo Evolution stopped on $iteration iteration!	#		
		exit						#
	fi							#
}								#

echo Enter the number of agents: 	# Read the number of agents		
read NUMBER				#														
if [ "$NUMBER" -le 4 ]					#		
then 							# If number of agents	
	echo Number of agents less or equal 4		# less or equal 4
	exit 						# exit 
fi							#		

declare -i RANGE=$NUMBER
NUMBER=$NUMBER-1

count=0	
echo "------t=$iteration----------"	
while [ "$count" -le $NUMBER ]     		#
do						# Fills the array of 	
	number=$RANDOM				# opinions with random
	let "number %= $RANGE"			# values from 0 to 
	model[$count]=$number			# (number of agents - 1)
	echo $count. op = ${model[$count]}	#
  	let "count += 1" 			#
done						#
echo "-----------------"
echo Enter the confidence level:			# Read confidence level			
read CONF						#
							
if [ $CONF -le 0 ]					#		
then 							# If number of agents	
	echo Confidence level less or equal 0		# less or equal 4
	exit 						# exit 
fi							#																				
declare -i power						# It's a power of trust group for specific agent				
declare -i sum							# It's a sum of trust group opinions + opinion of specific agent
declare -i maxIterations					# Max number of iterations if consensus will not 
								# reached or if model did not stop evolution

echo How many iterations do you want to check until consensus?		# Read max iterations number
read maxIterations							# 	

if [ $maxIterations -le 1 ]						#
then 									# If max iterations number 
	echo Confidence level less or equal 0				# less or equal 0 
	exit 								# exit
fi									#	

while [ $iteration -ne $maxIterations ] 			#
do								# The main cycle of model 
	nextIteration						# evolution
	checkOnConsensus					#					
	showModel						#
done								#	

echo Consensus was not reached on $iteration iteration!   	# If max iterations number reached - exit
exit							

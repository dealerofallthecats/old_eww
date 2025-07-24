#!/bin/bash

tasks_file=$HOME/.cache/eww/tasks.txt

current_tasks() {
	while (true); do
		formatted_tasks="(box :orientation 'v' :space-evenly false"
		tasks_raw=$(cat $tasks_file)
		IFS="
"
		for task_single_raw in $tasks_raw; do
			IFS='`'
			formatted_single_task=""
			counter=0
			for task_part in $task_single_raw; do
				case $counter in
				0) formatted_single_task="(task_single :title \"$task_part\" " ;; 
				1) formatted_single_task="${formatted_single_task}:status \"$task_part\" " ;;
				2) formatted_single_task="${formatted_single_task}:id \"$task_part\")" ;;
				esac
				counter=$((counter + 1))
			done
			counter=0
			formatted_tasks="$formatted_tasks $formatted_single_task"
		done
		formatted_tasks="${formatted_tasks})"
		echo $formatted_tasks
		sleep 0.5
	done
}

remove_task() {
	task_id="\`$1"
	line=$(cat $tasks_file | grep -n $task_id | head -c+2 | tr -d ':')
	sed -i -e "${line}d" $tasks_file
}

set_task_status() {
	task_id="\`$1"
	line=$(cat $tasks_file | grep -n $task_id | tail -c+2 | tr -d ':')
	line_number=$(cat $tasks_file | grep -n $task_id | head -c+2 | tr -d ':')
	IFS='`'
	counter=0
	task_status=""
	task_title=""
	task_id=""
	for task_part in $line; do
		case $counter in
		0) task_title="$task_part" ;;
		1) task_status="$task_part" ;;
		2) task_id="$task_part" ;;
		esac
		counter=$((counter + 1))
	done
	if [[ "$task_status" == "uncomplete" ]]; then
	       	task_status="complete"
        else
 		task_status="uncomplete"
	fi
	sed -i "${line_number}s/.*/${task_title}\`${task_status}\`${task_id}/" $tasks_file 
}

add_task() {
	task_name="$1"
	last_task=$(cat $tasks_file | tail -n 1)
	task_id=""
	if [[ "$last_task" != "" ]]; then
		IFS='`'
		counter=0
		for task_part in $last_task; do
			if [[ "$counter" == "2" ]]; then
				task_id=$(($task_part + 1))	
			fi
			counter=$((counter + 1))
		done
	else
		task_id="1"
	fi
	echo "${task_name}\`uncomplete\`${task_id}" >> $tasks_file
}

case $1 in
--current) current_tasks ;;
--remove) remove_task $2 ;;
--set) set_task_status $2 ;;
--add) add_task "$2" ;;
esac

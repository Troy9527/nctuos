#include <kernel/task.h>
#include <inc/x86.h>

#define ctx_switch(ts) \
  do { env_pop_tf(&((ts)->tf)); } while(0)

/* TODO: Lab5
* Implement a simple round-robin scheduler (Start with the next one)
*
* 1. You have to remember the task you picked last time.
*
* 2. If the next task is in TASK_RUNNABLE state, choose
*    it.
*
* 3. After your choice set cur_task to the picked task
*    and set its state, remind_ticks, and change page
*    directory to its pgdir.
*
* 4. CONTEXT SWITCH, leverage the macro ctx_switch(ts)
*    Please make sure you understand the mechanism.
*/
static int index = 0;  // the task we pick last time
void sched_yield(void)
{
	extern Task tasks[];
	extern Task *cur_task;

	int i, next;
	i = (index + 1)%NR_TASKS;
	
	// find the target task
	while(1){
		if(tasks[i].state == TASK_RUNNABLE){
			next = i;	
			break;
		}

		i = (i+1)%NR_TASKS;

		/*if(i == index){  // doesn't exist ant RUNNABLE task
			next = -1;
			break;
		}*/
	}

	if(next == -1){ // no other RUNNABLE task
		next = index;
	}

	if(next >=0 && next <NR_TASKS){
		cur_task = &tasks[next];
		cur_task->remind_ticks = TIME_QUANT;
		cur_task->state = TASK_RUNNING;
		index = next;
		lcr3(PADDR(cur_task->pgdir));
		env_pop_tf(&cur_task->tf);
	}
}

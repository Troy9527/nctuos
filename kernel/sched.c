#include <kernel/task.h>
#include <kernel/cpu.h>
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

//
// TODO: Lab6
// Modify your Round-robin scheduler to fit the multi-core
// You should:
//
// 1. Design your Runqueue structure first (in kernel/task.c)
//
// 2. modify sys_fork() in kernel/task.c ( we dispatch a task
//    to cpu runqueue only when we call fork system call )
//
// 3. modify sys_kill() in kernel/task.c ( we remove a task
//    from cpu runqueue when we call kill_self system call
//
// 4. modify your scheduler so that each cpu will do scheduling
//    with its runqueue
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//

void sched_yield(void)
{
	extern Task tasks[];
	//extern Task *cur_task;
	
	
	int num = thiscpu->cpu_rq.total;
	int i,index,cur_index;
	cur_index = (thiscpu->cpu_task) ? (thiscpu->cpu_rq.current_index) : 0;
	
	for(i=0; i<num; i++){
		cur_index++;
		index = thiscpu->cpu_rq.runq[cur_index%num];

		if(tasks[index].state == TASK_RUNNABLE){
			thiscpu->cpu_task = &tasks[index];
			thiscpu->cpu_task->state = TASK_RUNNING;
			thiscpu->cpu_rq.current_index = cur_index;
			lcr3(PADDR(thiscpu->cpu_task->pgdir));
			ctx_switch(thiscpu->cpu_task);
		}
	}


/*	int i, next;
	i = (index + 1)%NR_TASKS;

	// find the target task
	while(1){
		if(tasks[i].state == TASK_RUNNABLE){
			next = i;
			break;
		}

		i = (i+1)%NR_TASKS;

	}

	if(next == -1){ // no other RUNNABLE task
		next = index;
	}

	if(next >=0 && next <NR_TASKS){
		thiscpu->cpu_task = &tasks[next];
		thiscpu->cpu_task->remind_ticks = TIME_QUANT;
		thiscpu->cpu_task->state = TASK_RUNNING;
		index = next;
		lcr3(PADDR(thiscpu->cpu_task->pgdir));
		env_pop_tf(&thiscpu->cpu_task->tf);
	}*/
}

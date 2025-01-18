#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

int time_slices[] = {1, 4, 8, 16};

// struct proc *mlfq_proc[NQUEUE][NPROC + 10];
// int queue_count[NQUEUE] = {0, 0, 0, 0};

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

struct proc *mlfq_proc[NQUEUE][NPROC + 10];
int queue_count[NQUEUE] = {0, 0, 0, 0};

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// proc.c

// Add a process to the end of a given priority queue

// void init_queues()
// {
//   boost_count = 0;
// }

struct proc *select_next_process()
{
  for (int i = 0; i < NQUEUE; i++)
  {
    for (int j = 0; j < queue_count[i]; j++)
    {
      struct proc *p = mlfq_proc[i][j];
      // if (p->pid == 132)
      // {
      //   printf("%d\n", p->priority);
      //   // printf("%d %d %d %d\n", queue_count[0], queue_count[1], queue_count[2], queue_count[3]);
      // }
      if (p->state == RUNNABLE)
      {
        return p;
      }
    }
  }
  // printf("No process found\n");
  return 0;
}

void remove_from_queue(int priority, int pid)
{
  for (int i = 0; i < queue_count[priority]; i++)
  {
    if (mlfq_proc[priority][i]->pid == pid)
    {
      for (int j = i; j < queue_count[priority] - 1; j++)
      {
        mlfq_proc[priority][j] = mlfq_proc[priority][j + 1];
      }
      queue_count[priority]--;
      break;
    }
  }
}

void add_to_queue(int priority, struct proc *p)
{
  mlfq_proc[priority][queue_count[priority]] = p;
  queue_count[priority]++;
}

void send_to_last(int priority, int pid)
{
  // printf("%d\n", queue_count[priority]);
  if (queue_count[priority] == 0 || queue_count[priority] == 1)
  {
    return;
  }
  for (int i = 0; i < queue_count[priority]; i++)
  {
    if (mlfq_proc[priority][i]->pid == pid)
    {
      struct proc *p = mlfq_proc[priority][i];
      for (int j = i; j < queue_count[priority] - 1; j++)
      {
        mlfq_proc[priority][j] = mlfq_proc[priority][j + 1];
      }
      mlfq_proc[priority][queue_count[priority] - 1] = p;
      // printf("%d\n", p->parent->priority);
      break;
    }
  }
}

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void procinit(void)
{
  struct proc *p;

  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    initlock(&p->lock, "proc");
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int allocpid()
{
  int pid;

  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == UNUSED)
    {
      goto found;
    }
    else
    {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  for (int x = 0; x <= NSYSCALLS; x++)
  {
    p->syscall_count[x] = 0;
  }

  // changes for lbs
  p->tickets = 1;
  p->arrivalTime = ticks;

  // changes for mlfq
  p->priority = 0;
  p->ticks_used = 0;
  p->total_ticks = 0;
  p->is_userinit = 0;

  p->queue_num = 0;
  p->queue_ticks = 0;
  p->entry_time = ticks;

  // add_to_queue(0, p);

  // add_to_queue(0, p);

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if (p->pagetable == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;
  p->rtime = 0;
  p->etime = 0;
  p->ctime = ticks;
  p->ticks = 0;
  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if (p->trapframe)
    kfree((void *)p->trapframe);
  p->trapframe = 0;
  if (p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
  // remove_from_queue(p->priority, p->pid);
  for (int x = 0; x <= 26; x++)
  {
    p->syscall_count[x] = 0;
  }
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if (pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
               (uint64)trampoline, PTE_R | PTE_X) < 0)
  {
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
               (uint64)(p->trapframe), PTE_R | PTE_W) < 0)
  {
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
    0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
    0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
    0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
    0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
    0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
    0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00};

// Set up first user process.
void userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;

  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;     // user program counter
  p->trapframe->sp = PGSIZE; // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
  if(SCHEDULER == 2)
    add_to_queue(0, p);
  p->is_userinit = 1;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if (n > 0)
  {
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    {
      return -1;
    }
  }
  else if (n < 0)
  {
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy user memory from parent to child.
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
  {
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);
  np->tickets = p->tickets;
  np->arrivalTime = ticks;

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for (i = 0; i < NOFILE; i++)
    if (p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));
  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  if(SCHEDULER == 2)
    add_to_queue(0, np);
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void reparent(struct proc *p)
{
  struct proc *pp;

  for (pp = proc; pp < &proc[NPROC]; pp++)
  {
    if (pp->parent == p)
    {
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void exit(int status)
{
  struct proc *p = myproc();

  if (p == initproc)
    panic("init exiting");

  // Close all open files.
  for (int fd = 0; fd < NOFILE; fd++)
  {
    if (p->ofile[fd])
    {
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);

  acquire(&p->lock);
  // remove_from_queue(p->priority, p->pid);

  p->xstate = status;
  p->state = ZOMBIE;
  p->etime = ticks;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (pp = proc; pp < &proc[NPROC]; pp++)
    {
      if (pp->parent == p)
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if (pp->state == ZOMBIE)
        {
          // Found one.
          for (int i = 0; i <= 25; i++)
          {
            pp->parent->syscall_count[i] += pp->syscall_count[i];
          }
          pid = pp->pid;
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                   sizeof(pp->xstate)) < 0)
          {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || killed(p))
    {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

void lbs(struct proc *p, struct cpu *c)
{
  int total_tickets = 0, current_ticket = 0, winning_ticket = 0;
  struct proc *selected_proc = 0;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == RUNNABLE)
    {
      total_tickets += p->tickets;
    }
    release(&p->lock);
  }

  if (total_tickets == 0)
  {
    return;
  }

  // Basic idea is to generate a random number between 0 and total_tickets
  int seed = cpuid();
  seed = (seed * 1103515245 + 12345) % 4294967296;
  seed ^= seed << 16;
  seed ^= seed >> 5;
  winning_ticket = seed % total_tickets;

  current_ticket = total_tickets;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == RUNNABLE)
    {
      current_ticket -= p->tickets;
      if (current_ticket <= winning_ticket)
      {
        selected_proc = p;
        release(&p->lock);
        break;
      }
    }
    release(&p->lock);
  }

  if (selected_proc != 0)
  {
    for (p = proc; p < &proc[NPROC]; p++)
    {
      acquire(&p->lock);
      if (p->state == RUNNABLE && p->tickets == selected_proc->tickets && p->arrivalTime < selected_proc->arrivalTime)
      {
        selected_proc = p;
      }
      release(&p->lock);
    }

    acquire(&selected_proc->lock);
    if (selected_proc->state == RUNNABLE)
    {
      selected_proc->state = RUNNING;
      c->proc = selected_proc;
      swtch(&c->context, &selected_proc->context);
      c->proc = 0;
    }
    release(&selected_proc->lock);
  }
}

void mlfq2(struct proc *p, struct cpu *c)
{
  // struct proc *selected_proc = 0;
  // Select the next process to run

  // for(struct proc* q = proc;q<&proc[NPROC];q++)
  //     {
  //       if(q->pid>=3)
  //       {
  //         printf("pid: %d,queue: %d,ticks: %d\n",q->pid,q->priority,ticks);
  //       }
  //     }
  //   printf("\n");

  p = select_next_process();
  // 
  if (p != 0)
  {
  // procdump();
    // printf("Selected process: %d\n", p->pid);
    acquire(&p->lock);
    if (p->state == RUNNABLE)
    {
      // cprintf("Selected process: %d\n", p->pid);
      p->state = RUNNING;
      p->ticks_used++;
      p->total_ticks++;

      // Check if the process has used its time slice
      // printf("Process %d with priority %d used %d ticks out of %d\n", p->pid,p->priority, p->ticks_used, time_slices[p->priority]);
      remove_from_queue(p->priority, p->pid);
      c->proc = p;
      swtch(&c->context, &p->context);
      c->proc = 0;
      if (p->state == RUNNABLE)
      {

        if (p->ticks_used >= time_slices[p->priority])
        {
          p->ticks_used = 0;
          if (p->priority < 3)
          {
            
            p->priority++;
            add_to_queue(p->priority, p);
          }
          else
          {
            // Process is at the lowest priority level, re-add to the same queue
            // printf("Process %d with priority %d sent to last\n", p->pid, p->priority);
            add_to_queue(p->priority, p);
          }
        }
        else
        {
            add_to_queue(p->priority, p);

        }
      }

      // Update process ticks
    }
    release(&p->lock);
  }
}


void scheduler(void)
{
  printf("scheduler = %d\n", SCHEDULER);
  struct proc *p = 0;
  struct cpu *c = mycpu();

  c->proc = 0;
  for (;;)
  {
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    if (SCHEDULER == 1)
    {
      // implement lbs
      lbs(p, c);
    }
    else if (SCHEDULER == 2)
    {
      // implement mlfq
      // mlfq(p, c);
      mlfq2(p, c);
    }
    else
    {
      // implement default

      for (p = proc; p < &proc[NPROC]; p++)
      {
        acquire(&p->lock);
        if (p->state == RUNNABLE)
        {
          // Switch to chosen process.  It is the process's job
          // to release its lock and then reacquire it
          // before jumping back to us.
          p->state = RUNNING;
          c->proc = p;
          swtch(&c->context, &p->context);

          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
        }
        release(&p->lock);
      }
    }
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&p->lock))
    panic("sched p->lock");
  if (mycpu()->noff != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  // remove_from_queue(p->priority, p->pid);
  if (proc->ticks_used >= (1 << proc->priority))
  {
    proc->ticks_used = 0;
    if (proc->priority < NQUEUE - 1) // Demote to lower queue if possible
      proc->priority++;
  }
  p->state = RUNNABLE;
  // add_to_queue(p->priority, p);
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first)
  {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;
  // remove_from_queue(p->priority, p->pid);

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
      {
        p->state = RUNNABLE;
        int ticks_used = p->ticks_used;
        if(SCHEDULER == 2)
          add_to_queue(p->priority, p);
        p->ticks_used = ticks_used;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->pid == pid)
    {
      p->killed = 1;
      if (p->state == SLEEPING)
      {
        // Wake process from sleep().
        p->state = RUNNABLE;
        if(SCHEDULER == 2)
          add_to_queue(p->priority, p);
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int killed(struct proc *p)
{
  int k;

  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if (user_dst)
  {
    return copyout(p->pagetable, dst, src, len);
  }
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if (user_src)
  {
    return copyin(p->pagetable, dst, src, len);
  }
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [USED] "used",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s %s %d", p->pid, state, p->name, state, p->priority);
    printf("\n");
  }
  for(int x=0;x<NQUEUE;x++)
  {
    printf("Queue %d: ",x);
    for(int y=0;y<queue_count[x];y++)
    {
      printf("%d ",mlfq_proc[x][y]->pid);
    }
    printf("\n");
  }
}

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (np = proc; np < &proc[NPROC]; np++)
    {
      if (np->parent == p)
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
        {
          // Found one.
          pid = np->pid;
          *rtime = np->rtime;
          *wtime = np->etime - np->ctime - np->rtime;
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                   sizeof(np->xstate)) < 0)
          {
            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || p->killed)
    {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

void update_time()
{
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    {
      p->rtime++;
    }
    release(&p->lock);
  }
  // if(SCHEDULER == 2)
  // {
  //   for (int i = 0; i < NQUEUE; i++)
  //   {
  //     for (int j = 0; j < queue_count[i]; j++)
  //     {
  //       mlfq_proc[i][j]->queue_ticks++;
  //     }
  //   }
  // }
}
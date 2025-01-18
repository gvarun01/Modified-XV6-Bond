
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	40013103          	ld	sp,1024(sp) # 8000b400 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	slli	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	slli	a3,a3,0x3
    80000050:	0000b717          	auipc	a4,0xb
    80000054:	41070713          	addi	a4,a4,1040 # 8000b460 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	60e78793          	addi	a5,a5,1550 # 80006670 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	addi	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	addi	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd1bdf>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	e2678793          	addi	a5,a5,-474 # 80000ed2 <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srli	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	addi	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	addi	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	addi	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	936080e7          	jalr	-1738(ra) # 80002a60 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00000097          	auipc	ra,0x0
    8000013e:	7e4080e7          	jalr	2020(ra) # 8000091e <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addiw	s2,s2,1
    80000144:	0485                	addi	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	addi	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00013517          	auipc	a0,0x13
    80000190:	41450513          	addi	a0,a0,1044 # 800135a0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	aa4080e7          	jalr	-1372(ra) # 80000c38 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00013497          	auipc	s1,0x13
    800001a0:	40448493          	addi	s1,s1,1028 # 800135a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00013917          	auipc	s2,0x13
    800001a8:	49490913          	addi	s2,s2,1172 # 80013638 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	a2e080e7          	jalr	-1490(ra) # 80001bea <myproc>
    800001c4:	00002097          	auipc	ra,0x2
    800001c8:	6c4080e7          	jalr	1732(ra) # 80002888 <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	402080e7          	jalr	1026(ra) # 800025d4 <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00013717          	auipc	a4,0x13
    800001ec:	3b870713          	addi	a4,a4,952 # 800135a0 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	7ee080e7          	jalr	2030(ra) # 80002a08 <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	addi	s4,s4,1
    --n;
    8000022a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00013517          	auipc	a0,0x13
    8000023a:	36a50513          	addi	a0,a0,874 # 800135a0 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	aae080e7          	jalr	-1362(ra) # 80000cec <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	addi	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00013717          	auipc	a4,0x13
    80000268:	3cf72a23          	sw	a5,980(a4) # 80013638 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00013517          	auipc	a0,0x13
    8000027e:	32650513          	addi	a0,a0,806 # 800135a0 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	a6a080e7          	jalr	-1430(ra) # 80000cec <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	59c080e7          	jalr	1436(ra) # 80000840 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	addi	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	58a080e7          	jalr	1418(ra) # 80000840 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	57e080e7          	jalr	1406(ra) # 80000840 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	574080e7          	jalr	1396(ra) # 80000840 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	addi	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	addi	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00013517          	auipc	a0,0x13
    800002e6:	2be50513          	addi	a0,a0,702 # 800135a0 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	94e080e7          	jalr	-1714(ra) # 80000c38 <acquire>

  switch(c){
    800002f2:	47d5                	li	a5,21
    800002f4:	0af48563          	beq	s1,a5,8000039e <consoleintr+0xc8>
    800002f8:	0297c963          	blt	a5,s1,8000032a <consoleintr+0x54>
    800002fc:	47a1                	li	a5,8
    800002fe:	0ef48c63          	beq	s1,a5,800003f6 <consoleintr+0x120>
    80000302:	47c1                	li	a5,16
    80000304:	10f49f63          	bne	s1,a5,80000422 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80000308:	00002097          	auipc	ra,0x2
    8000030c:	7b0080e7          	jalr	1968(ra) # 80002ab8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000310:	00013517          	auipc	a0,0x13
    80000314:	29050513          	addi	a0,a0,656 # 800135a0 <cons>
    80000318:	00001097          	auipc	ra,0x1
    8000031c:	9d4080e7          	jalr	-1580(ra) # 80000cec <release>
}
    80000320:	60e2                	ld	ra,24(sp)
    80000322:	6442                	ld	s0,16(sp)
    80000324:	64a2                	ld	s1,8(sp)
    80000326:	6105                	addi	sp,sp,32
    80000328:	8082                	ret
  switch(c){
    8000032a:	07f00793          	li	a5,127
    8000032e:	0cf48463          	beq	s1,a5,800003f6 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000332:	00013717          	auipc	a4,0x13
    80000336:	26e70713          	addi	a4,a4,622 # 800135a0 <cons>
    8000033a:	0a072783          	lw	a5,160(a4)
    8000033e:	09872703          	lw	a4,152(a4)
    80000342:	9f99                	subw	a5,a5,a4
    80000344:	07f00713          	li	a4,127
    80000348:	fcf764e3          	bltu	a4,a5,80000310 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    8000034c:	47b5                	li	a5,13
    8000034e:	0cf48d63          	beq	s1,a5,80000428 <consoleintr+0x152>
      consputc(c);
    80000352:	8526                	mv	a0,s1
    80000354:	00000097          	auipc	ra,0x0
    80000358:	f40080e7          	jalr	-192(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000035c:	00013797          	auipc	a5,0x13
    80000360:	24478793          	addi	a5,a5,580 # 800135a0 <cons>
    80000364:	0a07a683          	lw	a3,160(a5)
    80000368:	0016871b          	addiw	a4,a3,1
    8000036c:	0007061b          	sext.w	a2,a4
    80000370:	0ae7a023          	sw	a4,160(a5)
    80000374:	07f6f693          	andi	a3,a3,127
    80000378:	97b6                	add	a5,a5,a3
    8000037a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000037e:	47a9                	li	a5,10
    80000380:	0cf48b63          	beq	s1,a5,80000456 <consoleintr+0x180>
    80000384:	4791                	li	a5,4
    80000386:	0cf48863          	beq	s1,a5,80000456 <consoleintr+0x180>
    8000038a:	00013797          	auipc	a5,0x13
    8000038e:	2ae7a783          	lw	a5,686(a5) # 80013638 <cons+0x98>
    80000392:	9f1d                	subw	a4,a4,a5
    80000394:	08000793          	li	a5,128
    80000398:	f6f71ce3          	bne	a4,a5,80000310 <consoleintr+0x3a>
    8000039c:	a86d                	j	80000456 <consoleintr+0x180>
    8000039e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800003a0:	00013717          	auipc	a4,0x13
    800003a4:	20070713          	addi	a4,a4,512 # 800135a0 <cons>
    800003a8:	0a072783          	lw	a5,160(a4)
    800003ac:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003b0:	00013497          	auipc	s1,0x13
    800003b4:	1f048493          	addi	s1,s1,496 # 800135a0 <cons>
    while(cons.e != cons.w &&
    800003b8:	4929                	li	s2,10
    800003ba:	02f70a63          	beq	a4,a5,800003ee <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003be:	37fd                	addiw	a5,a5,-1
    800003c0:	07f7f713          	andi	a4,a5,127
    800003c4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003c6:	01874703          	lbu	a4,24(a4)
    800003ca:	03270463          	beq	a4,s2,800003f2 <consoleintr+0x11c>
      cons.e--;
    800003ce:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	00000097          	auipc	ra,0x0
    800003da:	ebe080e7          	jalr	-322(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003de:	0a04a783          	lw	a5,160(s1)
    800003e2:	09c4a703          	lw	a4,156(s1)
    800003e6:	fcf71ce3          	bne	a4,a5,800003be <consoleintr+0xe8>
    800003ea:	6902                	ld	s2,0(sp)
    800003ec:	b715                	j	80000310 <consoleintr+0x3a>
    800003ee:	6902                	ld	s2,0(sp)
    800003f0:	b705                	j	80000310 <consoleintr+0x3a>
    800003f2:	6902                	ld	s2,0(sp)
    800003f4:	bf31                	j	80000310 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800003f6:	00013717          	auipc	a4,0x13
    800003fa:	1aa70713          	addi	a4,a4,426 # 800135a0 <cons>
    800003fe:	0a072783          	lw	a5,160(a4)
    80000402:	09c72703          	lw	a4,156(a4)
    80000406:	f0f705e3          	beq	a4,a5,80000310 <consoleintr+0x3a>
      cons.e--;
    8000040a:	37fd                	addiw	a5,a5,-1
    8000040c:	00013717          	auipc	a4,0x13
    80000410:	22f72a23          	sw	a5,564(a4) # 80013640 <cons+0xa0>
      consputc(BACKSPACE);
    80000414:	10000513          	li	a0,256
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	e7c080e7          	jalr	-388(ra) # 80000294 <consputc>
    80000420:	bdc5                	j	80000310 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000422:	ee0487e3          	beqz	s1,80000310 <consoleintr+0x3a>
    80000426:	b731                	j	80000332 <consoleintr+0x5c>
      consputc(c);
    80000428:	4529                	li	a0,10
    8000042a:	00000097          	auipc	ra,0x0
    8000042e:	e6a080e7          	jalr	-406(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000432:	00013797          	auipc	a5,0x13
    80000436:	16e78793          	addi	a5,a5,366 # 800135a0 <cons>
    8000043a:	0a07a703          	lw	a4,160(a5)
    8000043e:	0017069b          	addiw	a3,a4,1
    80000442:	0006861b          	sext.w	a2,a3
    80000446:	0ad7a023          	sw	a3,160(a5)
    8000044a:	07f77713          	andi	a4,a4,127
    8000044e:	97ba                	add	a5,a5,a4
    80000450:	4729                	li	a4,10
    80000452:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000456:	00013797          	auipc	a5,0x13
    8000045a:	1ec7a323          	sw	a2,486(a5) # 8001363c <cons+0x9c>
        wakeup(&cons.r);
    8000045e:	00013517          	auipc	a0,0x13
    80000462:	1da50513          	addi	a0,a0,474 # 80013638 <cons+0x98>
    80000466:	00002097          	auipc	ra,0x2
    8000046a:	1d2080e7          	jalr	466(ra) # 80002638 <wakeup>
    8000046e:	b54d                	j	80000310 <consoleintr+0x3a>

0000000080000470 <consoleinit>:

void
consoleinit(void)
{
    80000470:	1141                	addi	sp,sp,-16
    80000472:	e406                	sd	ra,8(sp)
    80000474:	e022                	sd	s0,0(sp)
    80000476:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000478:	00008597          	auipc	a1,0x8
    8000047c:	b8858593          	addi	a1,a1,-1144 # 80008000 <etext>
    80000480:	00013517          	auipc	a0,0x13
    80000484:	12050513          	addi	a0,a0,288 # 800135a0 <cons>
    80000488:	00000097          	auipc	ra,0x0
    8000048c:	720080e7          	jalr	1824(ra) # 80000ba8 <initlock>

  uartinit();
    80000490:	00000097          	auipc	ra,0x0
    80000494:	354080e7          	jalr	852(ra) # 800007e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000498:	0002b797          	auipc	a5,0x2b
    8000049c:	5f078793          	addi	a5,a5,1520 # 8002ba88 <devsw>
    800004a0:	00000717          	auipc	a4,0x0
    800004a4:	cce70713          	addi	a4,a4,-818 # 8000016e <consoleread>
    800004a8:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004aa:	00000717          	auipc	a4,0x0
    800004ae:	c5670713          	addi	a4,a4,-938 # 80000100 <consolewrite>
    800004b2:	ef98                	sd	a4,24(a5)
}
    800004b4:	60a2                	ld	ra,8(sp)
    800004b6:	6402                	ld	s0,0(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret

00000000800004bc <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004bc:	7179                	addi	sp,sp,-48
    800004be:	f406                	sd	ra,40(sp)
    800004c0:	f022                	sd	s0,32(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0xe>
    800004c6:	08054963          	bltz	a0,80000558 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00008617          	auipc	a2,0x8
    800004da:	27a60613          	addi	a2,a2,634 # 80008750 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x22>

  if(sign)
    80000502:	00088c63          	beqz	a7,8000051a <printint+0x5e>
    buf[i++] = '-';
    80000506:	fe070793          	addi	a5,a4,-32
    8000050a:	00878733          	add	a4,a5,s0
    8000050e:	02d00793          	li	a5,45
    80000512:	fef70823          	sb	a5,-16(a4)
    80000516:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000051a:	02e05b63          	blez	a4,80000550 <printint+0x94>
    8000051e:	ec26                	sd	s1,24(sp)
    80000520:	e84a                	sd	s2,16(sp)
    80000522:	fd040793          	addi	a5,s0,-48
    80000526:	00e784b3          	add	s1,a5,a4
    8000052a:	fff78913          	addi	s2,a5,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	377d                	addiw	a4,a4,-1
    80000532:	1702                	slli	a4,a4,0x20
    80000534:	9301                	srli	a4,a4,0x20
    80000536:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000053a:	fff4c503          	lbu	a0,-1(s1)
    8000053e:	00000097          	auipc	ra,0x0
    80000542:	d56080e7          	jalr	-682(ra) # 80000294 <consputc>
  while(--i >= 0)
    80000546:	14fd                	addi	s1,s1,-1
    80000548:	ff2499e3          	bne	s1,s2,8000053a <printint+0x7e>
    8000054c:	64e2                	ld	s1,24(sp)
    8000054e:	6942                	ld	s2,16(sp)
}
    80000550:	70a2                	ld	ra,40(sp)
    80000552:	7402                	ld	s0,32(sp)
    80000554:	6145                	addi	sp,sp,48
    80000556:	8082                	ret
    x = -xx;
    80000558:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000055c:	4885                	li	a7,1
    x = -xx;
    8000055e:	bf85                	j	800004ce <printint+0x12>

0000000080000560 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000560:	1101                	addi	sp,sp,-32
    80000562:	ec06                	sd	ra,24(sp)
    80000564:	e822                	sd	s0,16(sp)
    80000566:	e426                	sd	s1,8(sp)
    80000568:	1000                	addi	s0,sp,32
    8000056a:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056c:	00013797          	auipc	a5,0x13
    80000570:	0e07aa23          	sw	zero,244(a5) # 80013660 <pr+0x18>
  printf("panic: ");
    80000574:	00008517          	auipc	a0,0x8
    80000578:	a9450513          	addi	a0,a0,-1388 # 80008008 <etext+0x8>
    8000057c:	00000097          	auipc	ra,0x0
    80000580:	02e080e7          	jalr	46(ra) # 800005aa <printf>
  printf(s);
    80000584:	8526                	mv	a0,s1
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	024080e7          	jalr	36(ra) # 800005aa <printf>
  printf("\n");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	a8250513          	addi	a0,a0,-1406 # 80008010 <etext+0x10>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	014080e7          	jalr	20(ra) # 800005aa <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059e:	4785                	li	a5,1
    800005a0:	0000b717          	auipc	a4,0xb
    800005a4:	e8f72023          	sw	a5,-384(a4) # 8000b420 <panicked>
  for(;;)
    800005a8:	a001                	j	800005a8 <panic+0x48>

00000000800005aa <printf>:
{
    800005aa:	7131                	addi	sp,sp,-192
    800005ac:	fc86                	sd	ra,120(sp)
    800005ae:	f8a2                	sd	s0,112(sp)
    800005b0:	e8d2                	sd	s4,80(sp)
    800005b2:	f06a                	sd	s10,32(sp)
    800005b4:	0100                	addi	s0,sp,128
    800005b6:	8a2a                	mv	s4,a0
    800005b8:	e40c                	sd	a1,8(s0)
    800005ba:	e810                	sd	a2,16(s0)
    800005bc:	ec14                	sd	a3,24(s0)
    800005be:	f018                	sd	a4,32(s0)
    800005c0:	f41c                	sd	a5,40(s0)
    800005c2:	03043823          	sd	a6,48(s0)
    800005c6:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005ca:	00013d17          	auipc	s10,0x13
    800005ce:	096d2d03          	lw	s10,150(s10) # 80013660 <pr+0x18>
  if(locking)
    800005d2:	040d1463          	bnez	s10,8000061a <printf+0x70>
  if (fmt == 0)
    800005d6:	040a0b63          	beqz	s4,8000062c <printf+0x82>
  va_start(ap, fmt);
    800005da:	00840793          	addi	a5,s0,8
    800005de:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e2:	000a4503          	lbu	a0,0(s4)
    800005e6:	18050b63          	beqz	a0,8000077c <printf+0x1d2>
    800005ea:	f4a6                	sd	s1,104(sp)
    800005ec:	f0ca                	sd	s2,96(sp)
    800005ee:	ecce                	sd	s3,88(sp)
    800005f0:	e4d6                	sd	s5,72(sp)
    800005f2:	e0da                	sd	s6,64(sp)
    800005f4:	fc5e                	sd	s7,56(sp)
    800005f6:	f862                	sd	s8,48(sp)
    800005f8:	f466                	sd	s9,40(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	4981                	li	s3,0
    if(c != '%'){
    800005fe:	02500b13          	li	s6,37
    switch(c){
    80000602:	07000b93          	li	s7,112
  consputc('x');
    80000606:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000608:	00008a97          	auipc	s5,0x8
    8000060c:	148a8a93          	addi	s5,s5,328 # 80008750 <digits>
    switch(c){
    80000610:	07300c13          	li	s8,115
    80000614:	06400d93          	li	s11,100
    80000618:	a0b1                	j	80000664 <printf+0xba>
    acquire(&pr.lock);
    8000061a:	00013517          	auipc	a0,0x13
    8000061e:	02e50513          	addi	a0,a0,46 # 80013648 <pr>
    80000622:	00000097          	auipc	ra,0x0
    80000626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
    8000062a:	b775                	j	800005d6 <printf+0x2c>
    8000062c:	f4a6                	sd	s1,104(sp)
    8000062e:	f0ca                	sd	s2,96(sp)
    80000630:	ecce                	sd	s3,88(sp)
    80000632:	e4d6                	sd	s5,72(sp)
    80000634:	e0da                	sd	s6,64(sp)
    80000636:	fc5e                	sd	s7,56(sp)
    80000638:	f862                	sd	s8,48(sp)
    8000063a:	f466                	sd	s9,40(sp)
    8000063c:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	9e250513          	addi	a0,a0,-1566 # 80008020 <etext+0x20>
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	f1a080e7          	jalr	-230(ra) # 80000560 <panic>
      consputc(c);
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	c46080e7          	jalr	-954(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000656:	2985                	addiw	s3,s3,1
    80000658:	013a07b3          	add	a5,s4,s3
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c0>
    if(c != '%'){
    80000664:	ff6515e3          	bne	a0,s6,8000064e <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	2985                	addiw	s3,s3,1
    8000066a:	013a07b3          	add	a5,s4,s3
    8000066e:	0007c783          	lbu	a5,0(a5)
    80000672:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000676:	10078b63          	beqz	a5,8000078c <printf+0x1e2>
    switch(c){
    8000067a:	05778a63          	beq	a5,s7,800006ce <printf+0x124>
    8000067e:	02fbf663          	bgeu	s7,a5,800006aa <printf+0x100>
    80000682:	09878863          	beq	a5,s8,80000712 <printf+0x168>
    80000686:	07800713          	li	a4,120
    8000068a:	0ce79563          	bne	a5,a4,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000068e:	f8843783          	ld	a5,-120(s0)
    80000692:	00878713          	addi	a4,a5,8
    80000696:	f8e43423          	sd	a4,-120(s0)
    8000069a:	4605                	li	a2,1
    8000069c:	85e6                	mv	a1,s9
    8000069e:	4388                	lw	a0,0(a5)
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	e1c080e7          	jalr	-484(ra) # 800004bc <printint>
      break;
    800006a8:	b77d                	j	80000656 <printf+0xac>
    switch(c){
    800006aa:	09678f63          	beq	a5,s6,80000748 <printf+0x19e>
    800006ae:	0bb79363          	bne	a5,s11,80000754 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4605                	li	a2,1
    800006c0:	45a9                	li	a1,10
    800006c2:	4388                	lw	a0,0(a5)
    800006c4:	00000097          	auipc	ra,0x0
    800006c8:	df8080e7          	jalr	-520(ra) # 800004bc <printint>
      break;
    800006cc:	b769                	j	80000656 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006de:	03000513          	li	a0,48
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	bb2080e7          	jalr	-1102(ra) # 80000294 <consputc>
  consputc('x');
    800006ea:	07800513          	li	a0,120
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	ba6080e7          	jalr	-1114(ra) # 80000294 <consputc>
    800006f6:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b92080e7          	jalr	-1134(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x14e>
    80000710:	b799                	j	80000656 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x190>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d905                	beqz	a0,80000656 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b6c080e7          	jalr	-1172(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x17e>
    80000738:	bf39                	j	80000656 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x17e>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b4a080e7          	jalr	-1206(ra) # 80000294 <consputc>
      break;
    80000752:	b711                	j	80000656 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b3e080e7          	jalr	-1218(ra) # 80000294 <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b34080e7          	jalr	-1228(ra) # 80000294 <consputc>
      break;
    80000768:	b5fd                	j	80000656 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	6de2                	ld	s11,24(sp)
  if(locking)
    8000077c:	020d1263          	bnez	s10,800007a0 <printf+0x1f6>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	7d02                	ld	s10,32(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	6de2                	ld	s11,24(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d2>
    release(&pr.lock);
    800007a0:	00013517          	auipc	a0,0x13
    800007a4:	ea850513          	addi	a0,a0,-344 # 80013648 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	544080e7          	jalr	1348(ra) # 80000cec <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d6>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1101                	addi	sp,sp,-32
    800007b4:	ec06                	sd	ra,24(sp)
    800007b6:	e822                	sd	s0,16(sp)
    800007b8:	e426                	sd	s1,8(sp)
    800007ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007bc:	00013497          	auipc	s1,0x13
    800007c0:	e8c48493          	addi	s1,s1,-372 # 80013648 <pr>
    800007c4:	00008597          	auipc	a1,0x8
    800007c8:	86c58593          	addi	a1,a1,-1940 # 80008030 <etext+0x30>
    800007cc:	8526                	mv	a0,s1
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	3da080e7          	jalr	986(ra) # 80000ba8 <initlock>
  pr.locking = 1;
    800007d6:	4785                	li	a5,1
    800007d8:	cc9c                	sw	a5,24(s1)
}
    800007da:	60e2                	ld	ra,24(sp)
    800007dc:	6442                	ld	s0,16(sp)
    800007de:	64a2                	ld	s1,8(sp)
    800007e0:	6105                	addi	sp,sp,32
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	10000737          	lui	a4,0x10000
    80000816:	461d                	li	a2,7
    80000818:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000820:	00008597          	auipc	a1,0x8
    80000824:	81858593          	addi	a1,a1,-2024 # 80008038 <etext+0x38>
    80000828:	00013517          	auipc	a0,0x13
    8000082c:	e4050513          	addi	a0,a0,-448 # 80013668 <uart_tx_lock>
    80000830:	00000097          	auipc	ra,0x0
    80000834:	378080e7          	jalr	888(ra) # 80000ba8 <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000840:	1101                	addi	sp,sp,-32
    80000842:	ec06                	sd	ra,24(sp)
    80000844:	e822                	sd	s0,16(sp)
    80000846:	e426                	sd	s1,8(sp)
    80000848:	1000                	addi	s0,sp,32
    8000084a:	84aa                	mv	s1,a0
  push_off();
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	3a0080e7          	jalr	928(ra) # 80000bec <push_off>

  if(panicked){
    80000854:	0000b797          	auipc	a5,0xb
    80000858:	bcc7a783          	lw	a5,-1076(a5) # 8000b420 <panicked>
    8000085c:	eb85                	bnez	a5,8000088c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000864:	00074783          	lbu	a5,0(a4)
    80000868:	0207f793          	andi	a5,a5,32
    8000086c:	dfe5                	beqz	a5,80000864 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086e:	0ff4f513          	zext.b	a0,s1
    80000872:	100007b7          	lui	a5,0x10000
    80000876:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000087a:	00000097          	auipc	ra,0x0
    8000087e:	412080e7          	jalr	1042(ra) # 80000c8c <pop_off>
}
    80000882:	60e2                	ld	ra,24(sp)
    80000884:	6442                	ld	s0,16(sp)
    80000886:	64a2                	ld	s1,8(sp)
    80000888:	6105                	addi	sp,sp,32
    8000088a:	8082                	ret
    for(;;)
    8000088c:	a001                	j	8000088c <uartputc_sync+0x4c>

000000008000088e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088e:	0000b797          	auipc	a5,0xb
    80000892:	b9a7b783          	ld	a5,-1126(a5) # 8000b428 <uart_tx_r>
    80000896:	0000b717          	auipc	a4,0xb
    8000089a:	b9a73703          	ld	a4,-1126(a4) # 8000b430 <uart_tx_w>
    8000089e:	06f70f63          	beq	a4,a5,8000091c <uartstart+0x8e>
{
    800008a2:	7139                	addi	sp,sp,-64
    800008a4:	fc06                	sd	ra,56(sp)
    800008a6:	f822                	sd	s0,48(sp)
    800008a8:	f426                	sd	s1,40(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	ec4e                	sd	s3,24(sp)
    800008ae:	e852                	sd	s4,16(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	e05a                	sd	s6,0(sp)
    800008b4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b6:	10000937          	lui	s2,0x10000
    800008ba:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008bc:	00013a97          	auipc	s5,0x13
    800008c0:	daca8a93          	addi	s5,s5,-596 # 80013668 <uart_tx_lock>
    uart_tx_r += 1;
    800008c4:	0000b497          	auipc	s1,0xb
    800008c8:	b6448493          	addi	s1,s1,-1180 # 8000b428 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008cc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008d0:	0000b997          	auipc	s3,0xb
    800008d4:	b6098993          	addi	s3,s3,-1184 # 8000b430 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d8:	00094703          	lbu	a4,0(s2)
    800008dc:	02077713          	andi	a4,a4,32
    800008e0:	c705                	beqz	a4,80000908 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e2:	01f7f713          	andi	a4,a5,31
    800008e6:	9756                	add	a4,a4,s5
    800008e8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ec:	0785                	addi	a5,a5,1
    800008ee:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008f0:	8526                	mv	a0,s1
    800008f2:	00002097          	auipc	ra,0x2
    800008f6:	d46080e7          	jalr	-698(ra) # 80002638 <wakeup>
    WriteReg(THR, c);
    800008fa:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fe:	609c                	ld	a5,0(s1)
    80000900:	0009b703          	ld	a4,0(s3)
    80000904:	fcf71ae3          	bne	a4,a5,800008d8 <uartstart+0x4a>
  }
}
    80000908:	70e2                	ld	ra,56(sp)
    8000090a:	7442                	ld	s0,48(sp)
    8000090c:	74a2                	ld	s1,40(sp)
    8000090e:	7902                	ld	s2,32(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6aa2                	ld	s5,8(sp)
    80000916:	6b02                	ld	s6,0(sp)
    80000918:	6121                	addi	sp,sp,64
    8000091a:	8082                	ret
    8000091c:	8082                	ret

000000008000091e <uartputc>:
{
    8000091e:	7179                	addi	sp,sp,-48
    80000920:	f406                	sd	ra,40(sp)
    80000922:	f022                	sd	s0,32(sp)
    80000924:	ec26                	sd	s1,24(sp)
    80000926:	e84a                	sd	s2,16(sp)
    80000928:	e44e                	sd	s3,8(sp)
    8000092a:	e052                	sd	s4,0(sp)
    8000092c:	1800                	addi	s0,sp,48
    8000092e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000930:	00013517          	auipc	a0,0x13
    80000934:	d3850513          	addi	a0,a0,-712 # 80013668 <uart_tx_lock>
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	300080e7          	jalr	768(ra) # 80000c38 <acquire>
  if(panicked){
    80000940:	0000b797          	auipc	a5,0xb
    80000944:	ae07a783          	lw	a5,-1312(a5) # 8000b420 <panicked>
    80000948:	e7c9                	bnez	a5,800009d2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000094a:	0000b717          	auipc	a4,0xb
    8000094e:	ae673703          	ld	a4,-1306(a4) # 8000b430 <uart_tx_w>
    80000952:	0000b797          	auipc	a5,0xb
    80000956:	ad67b783          	ld	a5,-1322(a5) # 8000b428 <uart_tx_r>
    8000095a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095e:	00013997          	auipc	s3,0x13
    80000962:	d0a98993          	addi	s3,s3,-758 # 80013668 <uart_tx_lock>
    80000966:	0000b497          	auipc	s1,0xb
    8000096a:	ac248493          	addi	s1,s1,-1342 # 8000b428 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096e:	0000b917          	auipc	s2,0xb
    80000972:	ac290913          	addi	s2,s2,-1342 # 8000b430 <uart_tx_w>
    80000976:	00e79f63          	bne	a5,a4,80000994 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000097a:	85ce                	mv	a1,s3
    8000097c:	8526                	mv	a0,s1
    8000097e:	00002097          	auipc	ra,0x2
    80000982:	c56080e7          	jalr	-938(ra) # 800025d4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	00093703          	ld	a4,0(s2)
    8000098a:	609c                	ld	a5,0(s1)
    8000098c:	02078793          	addi	a5,a5,32
    80000990:	fee785e3          	beq	a5,a4,8000097a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000994:	00013497          	auipc	s1,0x13
    80000998:	cd448493          	addi	s1,s1,-812 # 80013668 <uart_tx_lock>
    8000099c:	01f77793          	andi	a5,a4,31
    800009a0:	97a6                	add	a5,a5,s1
    800009a2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a6:	0705                	addi	a4,a4,1
    800009a8:	0000b797          	auipc	a5,0xb
    800009ac:	a8e7b423          	sd	a4,-1400(a5) # 8000b430 <uart_tx_w>
  uartstart();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	ede080e7          	jalr	-290(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    800009b8:	8526                	mv	a0,s1
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	332080e7          	jalr	818(ra) # 80000cec <release>
}
    800009c2:	70a2                	ld	ra,40(sp)
    800009c4:	7402                	ld	s0,32(sp)
    800009c6:	64e2                	ld	s1,24(sp)
    800009c8:	6942                	ld	s2,16(sp)
    800009ca:	69a2                	ld	s3,8(sp)
    800009cc:	6a02                	ld	s4,0(sp)
    800009ce:	6145                	addi	sp,sp,48
    800009d0:	8082                	ret
    for(;;)
    800009d2:	a001                	j	800009d2 <uartputc+0xb4>

00000000800009d4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d4:	1141                	addi	sp,sp,-16
    800009d6:	e422                	sd	s0,8(sp)
    800009d8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009da:	100007b7          	lui	a5,0x10000
    800009de:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009e0:	0007c783          	lbu	a5,0(a5)
    800009e4:	8b85                	andi	a5,a5,1
    800009e6:	cb81                	beqz	a5,800009f6 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009e8:	100007b7          	lui	a5,0x10000
    800009ec:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f0:	6422                	ld	s0,8(sp)
    800009f2:	0141                	addi	sp,sp,16
    800009f4:	8082                	ret
    return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	bfe5                	j	800009f0 <uartgetc+0x1c>

00000000800009fa <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a04:	54fd                	li	s1,-1
    80000a06:	a029                	j	80000a10 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	8ce080e7          	jalr	-1842(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	fc4080e7          	jalr	-60(ra) # 800009d4 <uartgetc>
    if(c == -1)
    80000a18:	fe9518e3          	bne	a0,s1,80000a08 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a1c:	00013497          	auipc	s1,0x13
    80000a20:	c4c48493          	addi	s1,s1,-948 # 80013668 <uart_tx_lock>
    80000a24:	8526                	mv	a0,s1
    80000a26:	00000097          	auipc	ra,0x0
    80000a2a:	212080e7          	jalr	530(ra) # 80000c38 <acquire>
  uartstart();
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	e60080e7          	jalr	-416(ra) # 8000088e <uartstart>
  release(&uart_tx_lock);
    80000a36:	8526                	mv	a0,s1
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	2b4080e7          	jalr	692(ra) # 80000cec <release>
}
    80000a40:	60e2                	ld	ra,24(sp)
    80000a42:	6442                	ld	s0,16(sp)
    80000a44:	64a2                	ld	s1,8(sp)
    80000a46:	6105                	addi	sp,sp,32
    80000a48:	8082                	ret

0000000080000a4a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	e04a                	sd	s2,0(sp)
    80000a54:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a56:	03451793          	slli	a5,a0,0x34
    80000a5a:	ebb9                	bnez	a5,80000ab0 <kfree+0x66>
    80000a5c:	84aa                	mv	s1,a0
    80000a5e:	0002c797          	auipc	a5,0x2c
    80000a62:	1c278793          	addi	a5,a5,450 # 8002cc20 <end>
    80000a66:	04f56563          	bltu	a0,a5,80000ab0 <kfree+0x66>
    80000a6a:	47c5                	li	a5,17
    80000a6c:	07ee                	slli	a5,a5,0x1b
    80000a6e:	04f57163          	bgeu	a0,a5,80000ab0 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a72:	6605                	lui	a2,0x1
    80000a74:	4585                	li	a1,1
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	2be080e7          	jalr	702(ra) # 80000d34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a7e:	00013917          	auipc	s2,0x13
    80000a82:	c2290913          	addi	s2,s2,-990 # 800136a0 <kmem>
    80000a86:	854a                	mv	a0,s2
    80000a88:	00000097          	auipc	ra,0x0
    80000a8c:	1b0080e7          	jalr	432(ra) # 80000c38 <acquire>
  r->next = kmem.freelist;
    80000a90:	01893783          	ld	a5,24(s2)
    80000a94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a96:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	250080e7          	jalr	592(ra) # 80000cec <release>
}
    80000aa4:	60e2                	ld	ra,24(sp)
    80000aa6:	6442                	ld	s0,16(sp)
    80000aa8:	64a2                	ld	s1,8(sp)
    80000aaa:	6902                	ld	s2,0(sp)
    80000aac:	6105                	addi	sp,sp,32
    80000aae:	8082                	ret
    panic("kfree");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	59050513          	addi	a0,a0,1424 # 80008040 <etext+0x40>
    80000ab8:	00000097          	auipc	ra,0x0
    80000abc:	aa8080e7          	jalr	-1368(ra) # 80000560 <panic>

0000000080000ac0 <freerange>:
{
    80000ac0:	7179                	addi	sp,sp,-48
    80000ac2:	f406                	sd	ra,40(sp)
    80000ac4:	f022                	sd	s0,32(sp)
    80000ac6:	ec26                	sd	s1,24(sp)
    80000ac8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aca:	6785                	lui	a5,0x1
    80000acc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad0:	00e504b3          	add	s1,a0,a4
    80000ad4:	777d                	lui	a4,0xfffff
    80000ad6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad8:	94be                	add	s1,s1,a5
    80000ada:	0295e463          	bltu	a1,s1,80000b02 <freerange+0x42>
    80000ade:	e84a                	sd	s2,16(sp)
    80000ae0:	e44e                	sd	s3,8(sp)
    80000ae2:	e052                	sd	s4,0(sp)
    80000ae4:	892e                	mv	s2,a1
    kfree(p);
    80000ae6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	6985                	lui	s3,0x1
    kfree(p);
    80000aea:	01448533          	add	a0,s1,s4
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	f5c080e7          	jalr	-164(ra) # 80000a4a <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af6:	94ce                	add	s1,s1,s3
    80000af8:	fe9979e3          	bgeu	s2,s1,80000aea <freerange+0x2a>
    80000afc:	6942                	ld	s2,16(sp)
    80000afe:	69a2                	ld	s3,8(sp)
    80000b00:	6a02                	ld	s4,0(sp)
}
    80000b02:	70a2                	ld	ra,40(sp)
    80000b04:	7402                	ld	s0,32(sp)
    80000b06:	64e2                	ld	s1,24(sp)
    80000b08:	6145                	addi	sp,sp,48
    80000b0a:	8082                	ret

0000000080000b0c <kinit>:
{
    80000b0c:	1141                	addi	sp,sp,-16
    80000b0e:	e406                	sd	ra,8(sp)
    80000b10:	e022                	sd	s0,0(sp)
    80000b12:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b14:	00007597          	auipc	a1,0x7
    80000b18:	53458593          	addi	a1,a1,1332 # 80008048 <etext+0x48>
    80000b1c:	00013517          	auipc	a0,0x13
    80000b20:	b8450513          	addi	a0,a0,-1148 # 800136a0 <kmem>
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	084080e7          	jalr	132(ra) # 80000ba8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	0002c517          	auipc	a0,0x2c
    80000b34:	0f050513          	addi	a0,a0,240 # 8002cc20 <end>
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	f88080e7          	jalr	-120(ra) # 80000ac0 <freerange>
}
    80000b40:	60a2                	ld	ra,8(sp)
    80000b42:	6402                	ld	s0,0(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b48:	1101                	addi	sp,sp,-32
    80000b4a:	ec06                	sd	ra,24(sp)
    80000b4c:	e822                	sd	s0,16(sp)
    80000b4e:	e426                	sd	s1,8(sp)
    80000b50:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b52:	00013497          	auipc	s1,0x13
    80000b56:	b4e48493          	addi	s1,s1,-1202 # 800136a0 <kmem>
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	0dc080e7          	jalr	220(ra) # 80000c38 <acquire>
  r = kmem.freelist;
    80000b64:	6c84                	ld	s1,24(s1)
  if(r)
    80000b66:	c885                	beqz	s1,80000b96 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b68:	609c                	ld	a5,0(s1)
    80000b6a:	00013517          	auipc	a0,0x13
    80000b6e:	b3650513          	addi	a0,a0,-1226 # 800136a0 <kmem>
    80000b72:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b74:	00000097          	auipc	ra,0x0
    80000b78:	178080e7          	jalr	376(ra) # 80000cec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7c:	6605                	lui	a2,0x1
    80000b7e:	4595                	li	a1,5
    80000b80:	8526                	mv	a0,s1
    80000b82:	00000097          	auipc	ra,0x0
    80000b86:	1b2080e7          	jalr	434(ra) # 80000d34 <memset>
  return (void*)r;
}
    80000b8a:	8526                	mv	a0,s1
    80000b8c:	60e2                	ld	ra,24(sp)
    80000b8e:	6442                	ld	s0,16(sp)
    80000b90:	64a2                	ld	s1,8(sp)
    80000b92:	6105                	addi	sp,sp,32
    80000b94:	8082                	ret
  release(&kmem.lock);
    80000b96:	00013517          	auipc	a0,0x13
    80000b9a:	b0a50513          	addi	a0,a0,-1270 # 800136a0 <kmem>
    80000b9e:	00000097          	auipc	ra,0x0
    80000ba2:	14e080e7          	jalr	334(ra) # 80000cec <release>
  if(r)
    80000ba6:	b7d5                	j	80000b8a <kalloc+0x42>

0000000080000ba8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ba8:	1141                	addi	sp,sp,-16
    80000baa:	e422                	sd	s0,8(sp)
    80000bac:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bb0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb4:	00053823          	sd	zero,16(a0)
}
    80000bb8:	6422                	ld	s0,8(sp)
    80000bba:	0141                	addi	sp,sp,16
    80000bbc:	8082                	ret

0000000080000bbe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbe:	411c                	lw	a5,0(a0)
    80000bc0:	e399                	bnez	a5,80000bc6 <holding+0x8>
    80000bc2:	4501                	li	a0,0
  return r;
}
    80000bc4:	8082                	ret
{
    80000bc6:	1101                	addi	sp,sp,-32
    80000bc8:	ec06                	sd	ra,24(sp)
    80000bca:	e822                	sd	s0,16(sp)
    80000bcc:	e426                	sd	s1,8(sp)
    80000bce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bd0:	6904                	ld	s1,16(a0)
    80000bd2:	00001097          	auipc	ra,0x1
    80000bd6:	ffc080e7          	jalr	-4(ra) # 80001bce <mycpu>
    80000bda:	40a48533          	sub	a0,s1,a0
    80000bde:	00153513          	seqz	a0,a0
}
    80000be2:	60e2                	ld	ra,24(sp)
    80000be4:	6442                	ld	s0,16(sp)
    80000be6:	64a2                	ld	s1,8(sp)
    80000be8:	6105                	addi	sp,sp,32
    80000bea:	8082                	ret

0000000080000bec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bec:	1101                	addi	sp,sp,-32
    80000bee:	ec06                	sd	ra,24(sp)
    80000bf0:	e822                	sd	s0,16(sp)
    80000bf2:	e426                	sd	s1,8(sp)
    80000bf4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf6:	100024f3          	csrr	s1,sstatus
    80000bfa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bfe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c00:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c04:	00001097          	auipc	ra,0x1
    80000c08:	fca080e7          	jalr	-54(ra) # 80001bce <mycpu>
    80000c0c:	5d3c                	lw	a5,120(a0)
    80000c0e:	cf89                	beqz	a5,80000c28 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c10:	00001097          	auipc	ra,0x1
    80000c14:	fbe080e7          	jalr	-66(ra) # 80001bce <mycpu>
    80000c18:	5d3c                	lw	a5,120(a0)
    80000c1a:	2785                	addiw	a5,a5,1
    80000c1c:	dd3c                	sw	a5,120(a0)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    mycpu()->intena = old;
    80000c28:	00001097          	auipc	ra,0x1
    80000c2c:	fa6080e7          	jalr	-90(ra) # 80001bce <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c30:	8085                	srli	s1,s1,0x1
    80000c32:	8885                	andi	s1,s1,1
    80000c34:	dd64                	sw	s1,124(a0)
    80000c36:	bfe9                	j	80000c10 <push_off+0x24>

0000000080000c38 <acquire>:
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
    80000c42:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c44:	00000097          	auipc	ra,0x0
    80000c48:	fa8080e7          	jalr	-88(ra) # 80000bec <push_off>
  if(holding(lk))
    80000c4c:	8526                	mv	a0,s1
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	f70080e7          	jalr	-144(ra) # 80000bbe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c56:	4705                	li	a4,1
  if(holding(lk))
    80000c58:	e115                	bnez	a0,80000c7c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c5a:	87ba                	mv	a5,a4
    80000c5c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c60:	2781                	sext.w	a5,a5
    80000c62:	ffe5                	bnez	a5,80000c5a <acquire+0x22>
  __sync_synchronize();
    80000c64:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c68:	00001097          	auipc	ra,0x1
    80000c6c:	f66080e7          	jalr	-154(ra) # 80001bce <mycpu>
    80000c70:	e888                	sd	a0,16(s1)
}
    80000c72:	60e2                	ld	ra,24(sp)
    80000c74:	6442                	ld	s0,16(sp)
    80000c76:	64a2                	ld	s1,8(sp)
    80000c78:	6105                	addi	sp,sp,32
    80000c7a:	8082                	ret
    panic("acquire");
    80000c7c:	00007517          	auipc	a0,0x7
    80000c80:	3d450513          	addi	a0,a0,980 # 80008050 <etext+0x50>
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	8dc080e7          	jalr	-1828(ra) # 80000560 <panic>

0000000080000c8c <pop_off>:

void
pop_off(void)
{
    80000c8c:	1141                	addi	sp,sp,-16
    80000c8e:	e406                	sd	ra,8(sp)
    80000c90:	e022                	sd	s0,0(sp)
    80000c92:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	f3a080e7          	jalr	-198(ra) # 80001bce <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c9c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000ca0:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000ca2:	e78d                	bnez	a5,80000ccc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000ca4:	5d3c                	lw	a5,120(a0)
    80000ca6:	02f05b63          	blez	a5,80000cdc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000caa:	37fd                	addiw	a5,a5,-1
    80000cac:	0007871b          	sext.w	a4,a5
    80000cb0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cb2:	eb09                	bnez	a4,80000cc4 <pop_off+0x38>
    80000cb4:	5d7c                	lw	a5,124(a0)
    80000cb6:	c799                	beqz	a5,80000cc4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cb8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cbc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000cc0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000cc4:	60a2                	ld	ra,8(sp)
    80000cc6:	6402                	ld	s0,0(sp)
    80000cc8:	0141                	addi	sp,sp,16
    80000cca:	8082                	ret
    panic("pop_off - interruptible");
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	38c50513          	addi	a0,a0,908 # 80008058 <etext+0x58>
    80000cd4:	00000097          	auipc	ra,0x0
    80000cd8:	88c080e7          	jalr	-1908(ra) # 80000560 <panic>
    panic("pop_off");
    80000cdc:	00007517          	auipc	a0,0x7
    80000ce0:	39450513          	addi	a0,a0,916 # 80008070 <etext+0x70>
    80000ce4:	00000097          	auipc	ra,0x0
    80000ce8:	87c080e7          	jalr	-1924(ra) # 80000560 <panic>

0000000080000cec <release>:
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
    80000cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cf8:	00000097          	auipc	ra,0x0
    80000cfc:	ec6080e7          	jalr	-314(ra) # 80000bbe <holding>
    80000d00:	c115                	beqz	a0,80000d24 <release+0x38>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d0a:	0310000f          	fence	rw,w
    80000d0e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d12:	00000097          	auipc	ra,0x0
    80000d16:	f7a080e7          	jalr	-134(ra) # 80000c8c <pop_off>
}
    80000d1a:	60e2                	ld	ra,24(sp)
    80000d1c:	6442                	ld	s0,16(sp)
    80000d1e:	64a2                	ld	s1,8(sp)
    80000d20:	6105                	addi	sp,sp,32
    80000d22:	8082                	ret
    panic("release");
    80000d24:	00007517          	auipc	a0,0x7
    80000d28:	35450513          	addi	a0,a0,852 # 80008078 <etext+0x78>
    80000d2c:	00000097          	auipc	ra,0x0
    80000d30:	834080e7          	jalr	-1996(ra) # 80000560 <panic>

0000000080000d34 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d34:	1141                	addi	sp,sp,-16
    80000d36:	e422                	sd	s0,8(sp)
    80000d38:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d3a:	ca19                	beqz	a2,80000d50 <memset+0x1c>
    80000d3c:	87aa                	mv	a5,a0
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d46:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d4a:	0785                	addi	a5,a5,1
    80000d4c:	fee79de3          	bne	a5,a4,80000d46 <memset+0x12>
  }
  return dst;
}
    80000d50:	6422                	ld	s0,8(sp)
    80000d52:	0141                	addi	sp,sp,16
    80000d54:	8082                	ret

0000000080000d56 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d5c:	ca05                	beqz	a2,80000d8c <memcmp+0x36>
    80000d5e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d62:	1682                	slli	a3,a3,0x20
    80000d64:	9281                	srli	a3,a3,0x20
    80000d66:	0685                	addi	a3,a3,1
    80000d68:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d6a:	00054783          	lbu	a5,0(a0)
    80000d6e:	0005c703          	lbu	a4,0(a1)
    80000d72:	00e79863          	bne	a5,a4,80000d82 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d76:	0505                	addi	a0,a0,1
    80000d78:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d7a:	fed518e3          	bne	a0,a3,80000d6a <memcmp+0x14>
  }

  return 0;
    80000d7e:	4501                	li	a0,0
    80000d80:	a019                	j	80000d86 <memcmp+0x30>
      return *s1 - *s2;
    80000d82:	40e7853b          	subw	a0,a5,a4
}
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret
  return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	bfe5                	j	80000d86 <memcmp+0x30>

0000000080000d90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e422                	sd	s0,8(sp)
    80000d94:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d96:	c205                	beqz	a2,80000db6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d98:	02a5e263          	bltu	a1,a0,80000dbc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d9c:	1602                	slli	a2,a2,0x20
    80000d9e:	9201                	srli	a2,a2,0x20
    80000da0:	00c587b3          	add	a5,a1,a2
{
    80000da4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000da6:	0585                	addi	a1,a1,1
    80000da8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd23e1>
    80000daa:	fff5c683          	lbu	a3,-1(a1)
    80000dae:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000db2:	feb79ae3          	bne	a5,a1,80000da6 <memmove+0x16>

  return dst;
}
    80000db6:	6422                	ld	s0,8(sp)
    80000db8:	0141                	addi	sp,sp,16
    80000dba:	8082                	ret
  if(s < d && s + n > d){
    80000dbc:	02061693          	slli	a3,a2,0x20
    80000dc0:	9281                	srli	a3,a3,0x20
    80000dc2:	00d58733          	add	a4,a1,a3
    80000dc6:	fce57be3          	bgeu	a0,a4,80000d9c <memmove+0xc>
    d += n;
    80000dca:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dcc:	fff6079b          	addiw	a5,a2,-1
    80000dd0:	1782                	slli	a5,a5,0x20
    80000dd2:	9381                	srli	a5,a5,0x20
    80000dd4:	fff7c793          	not	a5,a5
    80000dd8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dda:	177d                	addi	a4,a4,-1
    80000ddc:	16fd                	addi	a3,a3,-1
    80000dde:	00074603          	lbu	a2,0(a4)
    80000de2:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000de6:	fef71ae3          	bne	a4,a5,80000dda <memmove+0x4a>
    80000dea:	b7f1                	j	80000db6 <memmove+0x26>

0000000080000dec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dec:	1141                	addi	sp,sp,-16
    80000dee:	e406                	sd	ra,8(sp)
    80000df0:	e022                	sd	s0,0(sp)
    80000df2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000df4:	00000097          	auipc	ra,0x0
    80000df8:	f9c080e7          	jalr	-100(ra) # 80000d90 <memmove>
}
    80000dfc:	60a2                	ld	ra,8(sp)
    80000dfe:	6402                	ld	s0,0(sp)
    80000e00:	0141                	addi	sp,sp,16
    80000e02:	8082                	ret

0000000080000e04 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e04:	1141                	addi	sp,sp,-16
    80000e06:	e422                	sd	s0,8(sp)
    80000e08:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e0a:	ce11                	beqz	a2,80000e26 <strncmp+0x22>
    80000e0c:	00054783          	lbu	a5,0(a0)
    80000e10:	cf89                	beqz	a5,80000e2a <strncmp+0x26>
    80000e12:	0005c703          	lbu	a4,0(a1)
    80000e16:	00f71a63          	bne	a4,a5,80000e2a <strncmp+0x26>
    n--, p++, q++;
    80000e1a:	367d                	addiw	a2,a2,-1
    80000e1c:	0505                	addi	a0,a0,1
    80000e1e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e20:	f675                	bnez	a2,80000e0c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e22:	4501                	li	a0,0
    80000e24:	a801                	j	80000e34 <strncmp+0x30>
    80000e26:	4501                	li	a0,0
    80000e28:	a031                	j	80000e34 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e2a:	00054503          	lbu	a0,0(a0)
    80000e2e:	0005c783          	lbu	a5,0(a1)
    80000e32:	9d1d                	subw	a0,a0,a5
}
    80000e34:	6422                	ld	s0,8(sp)
    80000e36:	0141                	addi	sp,sp,16
    80000e38:	8082                	ret

0000000080000e3a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e422                	sd	s0,8(sp)
    80000e3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e40:	87aa                	mv	a5,a0
    80000e42:	86b2                	mv	a3,a2
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	02d05563          	blez	a3,80000e70 <strncpy+0x36>
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	0005c703          	lbu	a4,0(a1)
    80000e50:	fee78fa3          	sb	a4,-1(a5)
    80000e54:	0585                	addi	a1,a1,1
    80000e56:	f775                	bnez	a4,80000e42 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e58:	873e                	mv	a4,a5
    80000e5a:	9fb5                	addw	a5,a5,a3
    80000e5c:	37fd                	addiw	a5,a5,-1
    80000e5e:	00c05963          	blez	a2,80000e70 <strncpy+0x36>
    *s++ = 0;
    80000e62:	0705                	addi	a4,a4,1
    80000e64:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e68:	40e786bb          	subw	a3,a5,a4
    80000e6c:	fed04be3          	bgtz	a3,80000e62 <strncpy+0x28>
  return os;
}
    80000e70:	6422                	ld	s0,8(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e7c:	02c05363          	blez	a2,80000ea2 <safestrcpy+0x2c>
    80000e80:	fff6069b          	addiw	a3,a2,-1
    80000e84:	1682                	slli	a3,a3,0x20
    80000e86:	9281                	srli	a3,a3,0x20
    80000e88:	96ae                	add	a3,a3,a1
    80000e8a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e8c:	00d58963          	beq	a1,a3,80000e9e <safestrcpy+0x28>
    80000e90:	0585                	addi	a1,a1,1
    80000e92:	0785                	addi	a5,a5,1
    80000e94:	fff5c703          	lbu	a4,-1(a1)
    80000e98:	fee78fa3          	sb	a4,-1(a5)
    80000e9c:	fb65                	bnez	a4,80000e8c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e9e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ea2:	6422                	ld	s0,8(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret

0000000080000ea8 <strlen>:

int
strlen(const char *s)
{
    80000ea8:	1141                	addi	sp,sp,-16
    80000eaa:	e422                	sd	s0,8(sp)
    80000eac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eae:	00054783          	lbu	a5,0(a0)
    80000eb2:	cf91                	beqz	a5,80000ece <strlen+0x26>
    80000eb4:	0505                	addi	a0,a0,1
    80000eb6:	87aa                	mv	a5,a0
    80000eb8:	86be                	mv	a3,a5
    80000eba:	0785                	addi	a5,a5,1
    80000ebc:	fff7c703          	lbu	a4,-1(a5)
    80000ec0:	ff65                	bnez	a4,80000eb8 <strlen+0x10>
    80000ec2:	40a6853b          	subw	a0,a3,a0
    80000ec6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ec8:	6422                	ld	s0,8(sp)
    80000eca:	0141                	addi	sp,sp,16
    80000ecc:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ece:	4501                	li	a0,0
    80000ed0:	bfe5                	j	80000ec8 <strlen+0x20>

0000000080000ed2 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ed2:	1141                	addi	sp,sp,-16
    80000ed4:	e406                	sd	ra,8(sp)
    80000ed6:	e022                	sd	s0,0(sp)
    80000ed8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eda:	00001097          	auipc	ra,0x1
    80000ede:	ce4080e7          	jalr	-796(ra) # 80001bbe <cpuid>
    userinit();      // first user process
    // init_queues();   // initialize MLFQ queues  
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ee2:	0000a717          	auipc	a4,0xa
    80000ee6:	55670713          	addi	a4,a4,1366 # 8000b438 <started>
  if(cpuid() == 0){
    80000eea:	c139                	beqz	a0,80000f30 <main+0x5e>
    while(started == 0)
    80000eec:	431c                	lw	a5,0(a4)
    80000eee:	2781                	sext.w	a5,a5
    80000ef0:	dff5                	beqz	a5,80000eec <main+0x1a>
      ;
    __sync_synchronize();
    80000ef2:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ef6:	00001097          	auipc	ra,0x1
    80000efa:	cc8080e7          	jalr	-824(ra) # 80001bbe <cpuid>
    80000efe:	85aa                	mv	a1,a0
    80000f00:	00007517          	auipc	a0,0x7
    80000f04:	19850513          	addi	a0,a0,408 # 80008098 <etext+0x98>
    80000f08:	fffff097          	auipc	ra,0xfffff
    80000f0c:	6a2080e7          	jalr	1698(ra) # 800005aa <printf>
    kvminithart();    // turn on paging
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	0d8080e7          	jalr	216(ra) # 80000fe8 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	f1c080e7          	jalr	-228(ra) # 80002e34 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f20:	00005097          	auipc	ra,0x5
    80000f24:	794080e7          	jalr	1940(ra) # 800066b4 <plicinithart>
  }

  scheduler();        
    80000f28:	00001097          	auipc	ra,0x1
    80000f2c:	4b6080e7          	jalr	1206(ra) # 800023de <scheduler>
    consoleinit();
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	540080e7          	jalr	1344(ra) # 80000470 <consoleinit>
    printfinit();
    80000f38:	00000097          	auipc	ra,0x0
    80000f3c:	87a080e7          	jalr	-1926(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f40:	00007517          	auipc	a0,0x7
    80000f44:	0d050513          	addi	a0,a0,208 # 80008010 <etext+0x10>
    80000f48:	fffff097          	auipc	ra,0xfffff
    80000f4c:	662080e7          	jalr	1634(ra) # 800005aa <printf>
    printf("xv6 kernel is booting\n");
    80000f50:	00007517          	auipc	a0,0x7
    80000f54:	13050513          	addi	a0,a0,304 # 80008080 <etext+0x80>
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	652080e7          	jalr	1618(ra) # 800005aa <printf>
    printf("\n");
    80000f60:	00007517          	auipc	a0,0x7
    80000f64:	0b050513          	addi	a0,a0,176 # 80008010 <etext+0x10>
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	642080e7          	jalr	1602(ra) # 800005aa <printf>
    kinit();         // physical page allocator
    80000f70:	00000097          	auipc	ra,0x0
    80000f74:	b9c080e7          	jalr	-1124(ra) # 80000b0c <kinit>
    kvminit();       // create kernel page table
    80000f78:	00000097          	auipc	ra,0x0
    80000f7c:	326080e7          	jalr	806(ra) # 8000129e <kvminit>
    kvminithart();   // turn on paging
    80000f80:	00000097          	auipc	ra,0x0
    80000f84:	068080e7          	jalr	104(ra) # 80000fe8 <kvminithart>
    procinit();      // process table
    80000f88:	00001097          	auipc	ra,0x1
    80000f8c:	b72080e7          	jalr	-1166(ra) # 80001afa <procinit>
    trapinit();      // trap vectors
    80000f90:	00002097          	auipc	ra,0x2
    80000f94:	e7c080e7          	jalr	-388(ra) # 80002e0c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f98:	00002097          	auipc	ra,0x2
    80000f9c:	e9c080e7          	jalr	-356(ra) # 80002e34 <trapinithart>
    plicinit();      // set up interrupt controller
    80000fa0:	00005097          	auipc	ra,0x5
    80000fa4:	6fa080e7          	jalr	1786(ra) # 8000669a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	70c080e7          	jalr	1804(ra) # 800066b4 <plicinithart>
    binit();         // buffer cache
    80000fb0:	00002097          	auipc	ra,0x2
    80000fb4:	7c6080e7          	jalr	1990(ra) # 80003776 <binit>
    iinit();         // inode table
    80000fb8:	00003097          	auipc	ra,0x3
    80000fbc:	e7c080e7          	jalr	-388(ra) # 80003e34 <iinit>
    fileinit();      // file table
    80000fc0:	00004097          	auipc	ra,0x4
    80000fc4:	e2c080e7          	jalr	-468(ra) # 80004dec <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	7f4080e7          	jalr	2036(ra) # 800067bc <virtio_disk_init>
    userinit();      // first user process
    80000fd0:	00001097          	auipc	ra,0x1
    80000fd4:	f6c080e7          	jalr	-148(ra) # 80001f3c <userinit>
    __sync_synchronize();
    80000fd8:	0330000f          	fence	rw,rw
    started = 1;
    80000fdc:	4785                	li	a5,1
    80000fde:	0000a717          	auipc	a4,0xa
    80000fe2:	44f72d23          	sw	a5,1114(a4) # 8000b438 <started>
    80000fe6:	b789                	j	80000f28 <main+0x56>

0000000080000fe8 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fe8:	1141                	addi	sp,sp,-16
    80000fea:	e422                	sd	s0,8(sp)
    80000fec:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ff2:	0000a797          	auipc	a5,0xa
    80000ff6:	44e7b783          	ld	a5,1102(a5) # 8000b440 <kernel_pagetable>
    80000ffa:	83b1                	srli	a5,a5,0xc
    80000ffc:	577d                	li	a4,-1
    80000ffe:	177e                	slli	a4,a4,0x3f
    80001000:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001002:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001006:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000100a:	6422                	ld	s0,8(sp)
    8000100c:	0141                	addi	sp,sp,16
    8000100e:	8082                	ret

0000000080001010 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001010:	7139                	addi	sp,sp,-64
    80001012:	fc06                	sd	ra,56(sp)
    80001014:	f822                	sd	s0,48(sp)
    80001016:	f426                	sd	s1,40(sp)
    80001018:	f04a                	sd	s2,32(sp)
    8000101a:	ec4e                	sd	s3,24(sp)
    8000101c:	e852                	sd	s4,16(sp)
    8000101e:	e456                	sd	s5,8(sp)
    80001020:	e05a                	sd	s6,0(sp)
    80001022:	0080                	addi	s0,sp,64
    80001024:	84aa                	mv	s1,a0
    80001026:	89ae                	mv	s3,a1
    80001028:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000102a:	57fd                	li	a5,-1
    8000102c:	83e9                	srli	a5,a5,0x1a
    8000102e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001030:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001032:	04b7f263          	bgeu	a5,a1,80001076 <walk+0x66>
    panic("walk");
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	07a50513          	addi	a0,a0,122 # 800080b0 <etext+0xb0>
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	522080e7          	jalr	1314(ra) # 80000560 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001046:	060a8663          	beqz	s5,800010b2 <walk+0xa2>
    8000104a:	00000097          	auipc	ra,0x0
    8000104e:	afe080e7          	jalr	-1282(ra) # 80000b48 <kalloc>
    80001052:	84aa                	mv	s1,a0
    80001054:	c529                	beqz	a0,8000109e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80001056:	6605                	lui	a2,0x1
    80001058:	4581                	li	a1,0
    8000105a:	00000097          	auipc	ra,0x0
    8000105e:	cda080e7          	jalr	-806(ra) # 80000d34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001062:	00c4d793          	srli	a5,s1,0xc
    80001066:	07aa                	slli	a5,a5,0xa
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001070:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd23d7>
    80001072:	036a0063          	beq	s4,s6,80001092 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	dfd5                	beqz	a5,80001046 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
    80001090:	b7c5                	j	80001070 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001092:	00c9d513          	srli	a0,s3,0xc
    80001096:	1ff57513          	andi	a0,a0,511
    8000109a:	050e                	slli	a0,a0,0x3
    8000109c:	9526                	add	a0,a0,s1
}
    8000109e:	70e2                	ld	ra,56(sp)
    800010a0:	7442                	ld	s0,48(sp)
    800010a2:	74a2                	ld	s1,40(sp)
    800010a4:	7902                	ld	s2,32(sp)
    800010a6:	69e2                	ld	s3,24(sp)
    800010a8:	6a42                	ld	s4,16(sp)
    800010aa:	6aa2                	ld	s5,8(sp)
    800010ac:	6b02                	ld	s6,0(sp)
    800010ae:	6121                	addi	sp,sp,64
    800010b0:	8082                	ret
        return 0;
    800010b2:	4501                	li	a0,0
    800010b4:	b7ed                	j	8000109e <walk+0x8e>

00000000800010b6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010b6:	57fd                	li	a5,-1
    800010b8:	83e9                	srli	a5,a5,0x1a
    800010ba:	00b7f463          	bgeu	a5,a1,800010c2 <walkaddr+0xc>
    return 0;
    800010be:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010c0:	8082                	ret
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ca:	4601                	li	a2,0
    800010cc:	00000097          	auipc	ra,0x0
    800010d0:	f44080e7          	jalr	-188(ra) # 80001010 <walk>
  if(pte == 0)
    800010d4:	c105                	beqz	a0,800010f4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010d6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010d8:	0117f693          	andi	a3,a5,17
    800010dc:	4745                	li	a4,17
    return 0;
    800010de:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010e0:	00e68663          	beq	a3,a4,800010ec <walkaddr+0x36>
}
    800010e4:	60a2                	ld	ra,8(sp)
    800010e6:	6402                	ld	s0,0(sp)
    800010e8:	0141                	addi	sp,sp,16
    800010ea:	8082                	ret
  pa = PTE2PA(*pte);
    800010ec:	83a9                	srli	a5,a5,0xa
    800010ee:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010f2:	bfcd                	j	800010e4 <walkaddr+0x2e>
    return 0;
    800010f4:	4501                	li	a0,0
    800010f6:	b7fd                	j	800010e4 <walkaddr+0x2e>

00000000800010f8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010f8:	715d                	addi	sp,sp,-80
    800010fa:	e486                	sd	ra,72(sp)
    800010fc:	e0a2                	sd	s0,64(sp)
    800010fe:	fc26                	sd	s1,56(sp)
    80001100:	f84a                	sd	s2,48(sp)
    80001102:	f44e                	sd	s3,40(sp)
    80001104:	f052                	sd	s4,32(sp)
    80001106:	ec56                	sd	s5,24(sp)
    80001108:	e85a                	sd	s6,16(sp)
    8000110a:	e45e                	sd	s7,8(sp)
    8000110c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000110e:	c639                	beqz	a2,8000115c <mappages+0x64>
    80001110:	8aaa                	mv	s5,a0
    80001112:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001114:	777d                	lui	a4,0xfffff
    80001116:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000111a:	fff58993          	addi	s3,a1,-1
    8000111e:	99b2                	add	s3,s3,a2
    80001120:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001124:	893e                	mv	s2,a5
    80001126:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000112a:	6b85                	lui	s7,0x1
    8000112c:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001130:	4605                	li	a2,1
    80001132:	85ca                	mv	a1,s2
    80001134:	8556                	mv	a0,s5
    80001136:	00000097          	auipc	ra,0x0
    8000113a:	eda080e7          	jalr	-294(ra) # 80001010 <walk>
    8000113e:	cd1d                	beqz	a0,8000117c <mappages+0x84>
    if(*pte & PTE_V)
    80001140:	611c                	ld	a5,0(a0)
    80001142:	8b85                	andi	a5,a5,1
    80001144:	e785                	bnez	a5,8000116c <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001146:	80b1                	srli	s1,s1,0xc
    80001148:	04aa                	slli	s1,s1,0xa
    8000114a:	0164e4b3          	or	s1,s1,s6
    8000114e:	0014e493          	ori	s1,s1,1
    80001152:	e104                	sd	s1,0(a0)
    if(a == last)
    80001154:	05390063          	beq	s2,s3,80001194 <mappages+0x9c>
    a += PGSIZE;
    80001158:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115a:	bfc9                	j	8000112c <mappages+0x34>
    panic("mappages: size");
    8000115c:	00007517          	auipc	a0,0x7
    80001160:	f5c50513          	addi	a0,a0,-164 # 800080b8 <etext+0xb8>
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	3fc080e7          	jalr	1020(ra) # 80000560 <panic>
      panic("mappages: remap");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	f5c50513          	addi	a0,a0,-164 # 800080c8 <etext+0xc8>
    80001174:	fffff097          	auipc	ra,0xfffff
    80001178:	3ec080e7          	jalr	1004(ra) # 80000560 <panic>
      return -1;
    8000117c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117e:	60a6                	ld	ra,72(sp)
    80001180:	6406                	ld	s0,64(sp)
    80001182:	74e2                	ld	s1,56(sp)
    80001184:	7942                	ld	s2,48(sp)
    80001186:	79a2                	ld	s3,40(sp)
    80001188:	7a02                	ld	s4,32(sp)
    8000118a:	6ae2                	ld	s5,24(sp)
    8000118c:	6b42                	ld	s6,16(sp)
    8000118e:	6ba2                	ld	s7,8(sp)
    80001190:	6161                	addi	sp,sp,80
    80001192:	8082                	ret
  return 0;
    80001194:	4501                	li	a0,0
    80001196:	b7e5                	j	8000117e <mappages+0x86>

0000000080001198 <kvmmap>:
{
    80001198:	1141                	addi	sp,sp,-16
    8000119a:	e406                	sd	ra,8(sp)
    8000119c:	e022                	sd	s0,0(sp)
    8000119e:	0800                	addi	s0,sp,16
    800011a0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011a2:	86b2                	mv	a3,a2
    800011a4:	863e                	mv	a2,a5
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	f52080e7          	jalr	-174(ra) # 800010f8 <mappages>
    800011ae:	e509                	bnez	a0,800011b8 <kvmmap+0x20>
}
    800011b0:	60a2                	ld	ra,8(sp)
    800011b2:	6402                	ld	s0,0(sp)
    800011b4:	0141                	addi	sp,sp,16
    800011b6:	8082                	ret
    panic("kvmmap");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	f2050513          	addi	a0,a0,-224 # 800080d8 <etext+0xd8>
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	3a0080e7          	jalr	928(ra) # 80000560 <panic>

00000000800011c8 <kvmmake>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800011d4:	00000097          	auipc	ra,0x0
    800011d8:	974080e7          	jalr	-1676(ra) # 80000b48 <kalloc>
    800011dc:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011de:	6605                	lui	a2,0x1
    800011e0:	4581                	li	a1,0
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	b52080e7          	jalr	-1198(ra) # 80000d34 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011ea:	4719                	li	a4,6
    800011ec:	6685                	lui	a3,0x1
    800011ee:	10000637          	lui	a2,0x10000
    800011f2:	100005b7          	lui	a1,0x10000
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	fa0080e7          	jalr	-96(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001200:	4719                	li	a4,6
    80001202:	6685                	lui	a3,0x1
    80001204:	10001637          	lui	a2,0x10001
    80001208:	100015b7          	lui	a1,0x10001
    8000120c:	8526                	mv	a0,s1
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	f8a080e7          	jalr	-118(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001216:	4719                	li	a4,6
    80001218:	004006b7          	lui	a3,0x400
    8000121c:	0c000637          	lui	a2,0xc000
    80001220:	0c0005b7          	lui	a1,0xc000
    80001224:	8526                	mv	a0,s1
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	f72080e7          	jalr	-142(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000122e:	00007917          	auipc	s2,0x7
    80001232:	dd290913          	addi	s2,s2,-558 # 80008000 <etext>
    80001236:	4729                	li	a4,10
    80001238:	80007697          	auipc	a3,0x80007
    8000123c:	dc868693          	addi	a3,a3,-568 # 8000 <_entry-0x7fff8000>
    80001240:	4605                	li	a2,1
    80001242:	067e                	slli	a2,a2,0x1f
    80001244:	85b2                	mv	a1,a2
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	f50080e7          	jalr	-176(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001250:	46c5                	li	a3,17
    80001252:	06ee                	slli	a3,a3,0x1b
    80001254:	4719                	li	a4,6
    80001256:	412686b3          	sub	a3,a3,s2
    8000125a:	864a                	mv	a2,s2
    8000125c:	85ca                	mv	a1,s2
    8000125e:	8526                	mv	a0,s1
    80001260:	00000097          	auipc	ra,0x0
    80001264:	f38080e7          	jalr	-200(ra) # 80001198 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001268:	4729                	li	a4,10
    8000126a:	6685                	lui	a3,0x1
    8000126c:	00006617          	auipc	a2,0x6
    80001270:	d9460613          	addi	a2,a2,-620 # 80007000 <_trampoline>
    80001274:	040005b7          	lui	a1,0x4000
    80001278:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000127a:	05b2                	slli	a1,a1,0xc
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	f1a080e7          	jalr	-230(ra) # 80001198 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001286:	8526                	mv	a0,s1
    80001288:	00000097          	auipc	ra,0x0
    8000128c:	7ce080e7          	jalr	1998(ra) # 80001a56 <proc_mapstacks>
}
    80001290:	8526                	mv	a0,s1
    80001292:	60e2                	ld	ra,24(sp)
    80001294:	6442                	ld	s0,16(sp)
    80001296:	64a2                	ld	s1,8(sp)
    80001298:	6902                	ld	s2,0(sp)
    8000129a:	6105                	addi	sp,sp,32
    8000129c:	8082                	ret

000000008000129e <kvminit>:
{
    8000129e:	1141                	addi	sp,sp,-16
    800012a0:	e406                	sd	ra,8(sp)
    800012a2:	e022                	sd	s0,0(sp)
    800012a4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f22080e7          	jalr	-222(ra) # 800011c8 <kvmmake>
    800012ae:	0000a797          	auipc	a5,0xa
    800012b2:	18a7b923          	sd	a0,402(a5) # 8000b440 <kernel_pagetable>
}
    800012b6:	60a2                	ld	ra,8(sp)
    800012b8:	6402                	ld	s0,0(sp)
    800012ba:	0141                	addi	sp,sp,16
    800012bc:	8082                	ret

00000000800012be <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012be:	715d                	addi	sp,sp,-80
    800012c0:	e486                	sd	ra,72(sp)
    800012c2:	e0a2                	sd	s0,64(sp)
    800012c4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012c6:	03459793          	slli	a5,a1,0x34
    800012ca:	e39d                	bnez	a5,800012f0 <uvmunmap+0x32>
    800012cc:	f84a                	sd	s2,48(sp)
    800012ce:	f44e                	sd	s3,40(sp)
    800012d0:	f052                	sd	s4,32(sp)
    800012d2:	ec56                	sd	s5,24(sp)
    800012d4:	e85a                	sd	s6,16(sp)
    800012d6:	e45e                	sd	s7,8(sp)
    800012d8:	8a2a                	mv	s4,a0
    800012da:	892e                	mv	s2,a1
    800012dc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012de:	0632                	slli	a2,a2,0xc
    800012e0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012e4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012e6:	6b05                	lui	s6,0x1
    800012e8:	0935fb63          	bgeu	a1,s3,8000137e <uvmunmap+0xc0>
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	a8a9                	j	80001348 <uvmunmap+0x8a>
    800012f0:	fc26                	sd	s1,56(sp)
    800012f2:	f84a                	sd	s2,48(sp)
    800012f4:	f44e                	sd	s3,40(sp)
    800012f6:	f052                	sd	s4,32(sp)
    800012f8:	ec56                	sd	s5,24(sp)
    800012fa:	e85a                	sd	s6,16(sp)
    800012fc:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800012fe:	00007517          	auipc	a0,0x7
    80001302:	de250513          	addi	a0,a0,-542 # 800080e0 <etext+0xe0>
    80001306:	fffff097          	auipc	ra,0xfffff
    8000130a:	25a080e7          	jalr	602(ra) # 80000560 <panic>
      panic("uvmunmap: walk");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	dea50513          	addi	a0,a0,-534 # 800080f8 <etext+0xf8>
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	24a080e7          	jalr	586(ra) # 80000560 <panic>
      panic("uvmunmap: not mapped");
    8000131e:	00007517          	auipc	a0,0x7
    80001322:	dea50513          	addi	a0,a0,-534 # 80008108 <etext+0x108>
    80001326:	fffff097          	auipc	ra,0xfffff
    8000132a:	23a080e7          	jalr	570(ra) # 80000560 <panic>
      panic("uvmunmap: not a leaf");
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	df250513          	addi	a0,a0,-526 # 80008120 <etext+0x120>
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	22a080e7          	jalr	554(ra) # 80000560 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000133e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001342:	995a                	add	s2,s2,s6
    80001344:	03397c63          	bgeu	s2,s3,8000137c <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001348:	4601                	li	a2,0
    8000134a:	85ca                	mv	a1,s2
    8000134c:	8552                	mv	a0,s4
    8000134e:	00000097          	auipc	ra,0x0
    80001352:	cc2080e7          	jalr	-830(ra) # 80001010 <walk>
    80001356:	84aa                	mv	s1,a0
    80001358:	d95d                	beqz	a0,8000130e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000135a:	6108                	ld	a0,0(a0)
    8000135c:	00157793          	andi	a5,a0,1
    80001360:	dfdd                	beqz	a5,8000131e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001362:	3ff57793          	andi	a5,a0,1023
    80001366:	fd7784e3          	beq	a5,s7,8000132e <uvmunmap+0x70>
    if(do_free){
    8000136a:	fc0a8ae3          	beqz	s5,8000133e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000136e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001370:	0532                	slli	a0,a0,0xc
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	6d8080e7          	jalr	1752(ra) # 80000a4a <kfree>
    8000137a:	b7d1                	j	8000133e <uvmunmap+0x80>
    8000137c:	74e2                	ld	s1,56(sp)
    8000137e:	7942                	ld	s2,48(sp)
    80001380:	79a2                	ld	s3,40(sp)
    80001382:	7a02                	ld	s4,32(sp)
    80001384:	6ae2                	ld	s5,24(sp)
    80001386:	6b42                	ld	s6,16(sp)
    80001388:	6ba2                	ld	s7,8(sp)
  }
}
    8000138a:	60a6                	ld	ra,72(sp)
    8000138c:	6406                	ld	s0,64(sp)
    8000138e:	6161                	addi	sp,sp,80
    80001390:	8082                	ret

0000000080001392 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001392:	1101                	addi	sp,sp,-32
    80001394:	ec06                	sd	ra,24(sp)
    80001396:	e822                	sd	s0,16(sp)
    80001398:	e426                	sd	s1,8(sp)
    8000139a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000139c:	fffff097          	auipc	ra,0xfffff
    800013a0:	7ac080e7          	jalr	1964(ra) # 80000b48 <kalloc>
    800013a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013a6:	c519                	beqz	a0,800013b4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013a8:	6605                	lui	a2,0x1
    800013aa:	4581                	li	a1,0
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	988080e7          	jalr	-1656(ra) # 80000d34 <memset>
  return pagetable;
}
    800013b4:	8526                	mv	a0,s1
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret

00000000800013c0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013c0:	7179                	addi	sp,sp,-48
    800013c2:	f406                	sd	ra,40(sp)
    800013c4:	f022                	sd	s0,32(sp)
    800013c6:	ec26                	sd	s1,24(sp)
    800013c8:	e84a                	sd	s2,16(sp)
    800013ca:	e44e                	sd	s3,8(sp)
    800013cc:	e052                	sd	s4,0(sp)
    800013ce:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013d0:	6785                	lui	a5,0x1
    800013d2:	04f67863          	bgeu	a2,a5,80001422 <uvmfirst+0x62>
    800013d6:	8a2a                	mv	s4,a0
    800013d8:	89ae                	mv	s3,a1
    800013da:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013dc:	fffff097          	auipc	ra,0xfffff
    800013e0:	76c080e7          	jalr	1900(ra) # 80000b48 <kalloc>
    800013e4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013e6:	6605                	lui	a2,0x1
    800013e8:	4581                	li	a1,0
    800013ea:	00000097          	auipc	ra,0x0
    800013ee:	94a080e7          	jalr	-1718(ra) # 80000d34 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013f2:	4779                	li	a4,30
    800013f4:	86ca                	mv	a3,s2
    800013f6:	6605                	lui	a2,0x1
    800013f8:	4581                	li	a1,0
    800013fa:	8552                	mv	a0,s4
    800013fc:	00000097          	auipc	ra,0x0
    80001400:	cfc080e7          	jalr	-772(ra) # 800010f8 <mappages>
  memmove(mem, src, sz);
    80001404:	8626                	mv	a2,s1
    80001406:	85ce                	mv	a1,s3
    80001408:	854a                	mv	a0,s2
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	986080e7          	jalr	-1658(ra) # 80000d90 <memmove>
}
    80001412:	70a2                	ld	ra,40(sp)
    80001414:	7402                	ld	s0,32(sp)
    80001416:	64e2                	ld	s1,24(sp)
    80001418:	6942                	ld	s2,16(sp)
    8000141a:	69a2                	ld	s3,8(sp)
    8000141c:	6a02                	ld	s4,0(sp)
    8000141e:	6145                	addi	sp,sp,48
    80001420:	8082                	ret
    panic("uvmfirst: more than a page");
    80001422:	00007517          	auipc	a0,0x7
    80001426:	d1650513          	addi	a0,a0,-746 # 80008138 <etext+0x138>
    8000142a:	fffff097          	auipc	ra,0xfffff
    8000142e:	136080e7          	jalr	310(ra) # 80000560 <panic>

0000000080001432 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001432:	1101                	addi	sp,sp,-32
    80001434:	ec06                	sd	ra,24(sp)
    80001436:	e822                	sd	s0,16(sp)
    80001438:	e426                	sd	s1,8(sp)
    8000143a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000143c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000143e:	00b67d63          	bgeu	a2,a1,80001458 <uvmdealloc+0x26>
    80001442:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001444:	6785                	lui	a5,0x1
    80001446:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001448:	00f60733          	add	a4,a2,a5
    8000144c:	76fd                	lui	a3,0xfffff
    8000144e:	8f75                	and	a4,a4,a3
    80001450:	97ae                	add	a5,a5,a1
    80001452:	8ff5                	and	a5,a5,a3
    80001454:	00f76863          	bltu	a4,a5,80001464 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001458:	8526                	mv	a0,s1
    8000145a:	60e2                	ld	ra,24(sp)
    8000145c:	6442                	ld	s0,16(sp)
    8000145e:	64a2                	ld	s1,8(sp)
    80001460:	6105                	addi	sp,sp,32
    80001462:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001464:	8f99                	sub	a5,a5,a4
    80001466:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001468:	4685                	li	a3,1
    8000146a:	0007861b          	sext.w	a2,a5
    8000146e:	85ba                	mv	a1,a4
    80001470:	00000097          	auipc	ra,0x0
    80001474:	e4e080e7          	jalr	-434(ra) # 800012be <uvmunmap>
    80001478:	b7c5                	j	80001458 <uvmdealloc+0x26>

000000008000147a <uvmalloc>:
  if(newsz < oldsz)
    8000147a:	0ab66b63          	bltu	a2,a1,80001530 <uvmalloc+0xb6>
{
    8000147e:	7139                	addi	sp,sp,-64
    80001480:	fc06                	sd	ra,56(sp)
    80001482:	f822                	sd	s0,48(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e852                	sd	s4,16(sp)
    80001488:	e456                	sd	s5,8(sp)
    8000148a:	0080                	addi	s0,sp,64
    8000148c:	8aaa                	mv	s5,a0
    8000148e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001490:	6785                	lui	a5,0x1
    80001492:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001494:	95be                	add	a1,a1,a5
    80001496:	77fd                	lui	a5,0xfffff
    80001498:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000149c:	08c9fc63          	bgeu	s3,a2,80001534 <uvmalloc+0xba>
    800014a0:	f426                	sd	s1,40(sp)
    800014a2:	f04a                	sd	s2,32(sp)
    800014a4:	e05a                	sd	s6,0(sp)
    800014a6:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014a8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ac:	fffff097          	auipc	ra,0xfffff
    800014b0:	69c080e7          	jalr	1692(ra) # 80000b48 <kalloc>
    800014b4:	84aa                	mv	s1,a0
    if(mem == 0){
    800014b6:	c915                	beqz	a0,800014ea <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    800014b8:	6605                	lui	a2,0x1
    800014ba:	4581                	li	a1,0
    800014bc:	00000097          	auipc	ra,0x0
    800014c0:	878080e7          	jalr	-1928(ra) # 80000d34 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c4:	875a                	mv	a4,s6
    800014c6:	86a6                	mv	a3,s1
    800014c8:	6605                	lui	a2,0x1
    800014ca:	85ca                	mv	a1,s2
    800014cc:	8556                	mv	a0,s5
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	c2a080e7          	jalr	-982(ra) # 800010f8 <mappages>
    800014d6:	ed05                	bnez	a0,8000150e <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d8:	6785                	lui	a5,0x1
    800014da:	993e                	add	s2,s2,a5
    800014dc:	fd4968e3          	bltu	s2,s4,800014ac <uvmalloc+0x32>
  return newsz;
    800014e0:	8552                	mv	a0,s4
    800014e2:	74a2                	ld	s1,40(sp)
    800014e4:	7902                	ld	s2,32(sp)
    800014e6:	6b02                	ld	s6,0(sp)
    800014e8:	a821                	j	80001500 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    800014ea:	864e                	mv	a2,s3
    800014ec:	85ca                	mv	a1,s2
    800014ee:	8556                	mv	a0,s5
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	f42080e7          	jalr	-190(ra) # 80001432 <uvmdealloc>
      return 0;
    800014f8:	4501                	li	a0,0
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	6b02                	ld	s6,0(sp)
}
    80001500:	70e2                	ld	ra,56(sp)
    80001502:	7442                	ld	s0,48(sp)
    80001504:	69e2                	ld	s3,24(sp)
    80001506:	6a42                	ld	s4,16(sp)
    80001508:	6aa2                	ld	s5,8(sp)
    8000150a:	6121                	addi	sp,sp,64
    8000150c:	8082                	ret
      kfree(mem);
    8000150e:	8526                	mv	a0,s1
    80001510:	fffff097          	auipc	ra,0xfffff
    80001514:	53a080e7          	jalr	1338(ra) # 80000a4a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001518:	864e                	mv	a2,s3
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f14080e7          	jalr	-236(ra) # 80001432 <uvmdealloc>
      return 0;
    80001526:	4501                	li	a0,0
    80001528:	74a2                	ld	s1,40(sp)
    8000152a:	7902                	ld	s2,32(sp)
    8000152c:	6b02                	ld	s6,0(sp)
    8000152e:	bfc9                	j	80001500 <uvmalloc+0x86>
    return oldsz;
    80001530:	852e                	mv	a0,a1
}
    80001532:	8082                	ret
  return newsz;
    80001534:	8532                	mv	a0,a2
    80001536:	b7e9                	j	80001500 <uvmalloc+0x86>

0000000080001538 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001538:	7179                	addi	sp,sp,-48
    8000153a:	f406                	sd	ra,40(sp)
    8000153c:	f022                	sd	s0,32(sp)
    8000153e:	ec26                	sd	s1,24(sp)
    80001540:	e84a                	sd	s2,16(sp)
    80001542:	e44e                	sd	s3,8(sp)
    80001544:	e052                	sd	s4,0(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000154a:	84aa                	mv	s1,a0
    8000154c:	6905                	lui	s2,0x1
    8000154e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001550:	4985                	li	s3,1
    80001552:	a829                	j	8000156c <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001554:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001556:	00c79513          	slli	a0,a5,0xc
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	fde080e7          	jalr	-34(ra) # 80001538 <freewalk>
      pagetable[i] = 0;
    80001562:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001566:	04a1                	addi	s1,s1,8
    80001568:	03248163          	beq	s1,s2,8000158a <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000156c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000156e:	00f7f713          	andi	a4,a5,15
    80001572:	ff3701e3          	beq	a4,s3,80001554 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001576:	8b85                	andi	a5,a5,1
    80001578:	d7fd                	beqz	a5,80001566 <freewalk+0x2e>
      panic("freewalk: leaf");
    8000157a:	00007517          	auipc	a0,0x7
    8000157e:	bde50513          	addi	a0,a0,-1058 # 80008158 <etext+0x158>
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	fde080e7          	jalr	-34(ra) # 80000560 <panic>
    }
  }
  kfree((void*)pagetable);
    8000158a:	8552                	mv	a0,s4
    8000158c:	fffff097          	auipc	ra,0xfffff
    80001590:	4be080e7          	jalr	1214(ra) # 80000a4a <kfree>
}
    80001594:	70a2                	ld	ra,40(sp)
    80001596:	7402                	ld	s0,32(sp)
    80001598:	64e2                	ld	s1,24(sp)
    8000159a:	6942                	ld	s2,16(sp)
    8000159c:	69a2                	ld	s3,8(sp)
    8000159e:	6a02                	ld	s4,0(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret

00000000800015a4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015a4:	1101                	addi	sp,sp,-32
    800015a6:	ec06                	sd	ra,24(sp)
    800015a8:	e822                	sd	s0,16(sp)
    800015aa:	e426                	sd	s1,8(sp)
    800015ac:	1000                	addi	s0,sp,32
    800015ae:	84aa                	mv	s1,a0
  if(sz > 0)
    800015b0:	e999                	bnez	a1,800015c6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015b2:	8526                	mv	a0,s1
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	f84080e7          	jalr	-124(ra) # 80001538 <freewalk>
}
    800015bc:	60e2                	ld	ra,24(sp)
    800015be:	6442                	ld	s0,16(sp)
    800015c0:	64a2                	ld	s1,8(sp)
    800015c2:	6105                	addi	sp,sp,32
    800015c4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015c6:	6785                	lui	a5,0x1
    800015c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ca:	95be                	add	a1,a1,a5
    800015cc:	4685                	li	a3,1
    800015ce:	00c5d613          	srli	a2,a1,0xc
    800015d2:	4581                	li	a1,0
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	cea080e7          	jalr	-790(ra) # 800012be <uvmunmap>
    800015dc:	bfd9                	j	800015b2 <uvmfree+0xe>

00000000800015de <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015de:	c679                	beqz	a2,800016ac <uvmcopy+0xce>
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	0880                	addi	s0,sp,80
    800015f6:	8b2a                	mv	s6,a0
    800015f8:	8aae                	mv	s5,a1
    800015fa:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015fc:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015fe:	4601                	li	a2,0
    80001600:	85ce                	mv	a1,s3
    80001602:	855a                	mv	a0,s6
    80001604:	00000097          	auipc	ra,0x0
    80001608:	a0c080e7          	jalr	-1524(ra) # 80001010 <walk>
    8000160c:	c531                	beqz	a0,80001658 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000160e:	6118                	ld	a4,0(a0)
    80001610:	00177793          	andi	a5,a4,1
    80001614:	cbb1                	beqz	a5,80001668 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001616:	00a75593          	srli	a1,a4,0xa
    8000161a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000161e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	526080e7          	jalr	1318(ra) # 80000b48 <kalloc>
    8000162a:	892a                	mv	s2,a0
    8000162c:	c939                	beqz	a0,80001682 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	85de                	mv	a1,s7
    80001632:	fffff097          	auipc	ra,0xfffff
    80001636:	75e080e7          	jalr	1886(ra) # 80000d90 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000163a:	8726                	mv	a4,s1
    8000163c:	86ca                	mv	a3,s2
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ce                	mv	a1,s3
    80001642:	8556                	mv	a0,s5
    80001644:	00000097          	auipc	ra,0x0
    80001648:	ab4080e7          	jalr	-1356(ra) # 800010f8 <mappages>
    8000164c:	e515                	bnez	a0,80001678 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000164e:	6785                	lui	a5,0x1
    80001650:	99be                	add	s3,s3,a5
    80001652:	fb49e6e3          	bltu	s3,s4,800015fe <uvmcopy+0x20>
    80001656:	a081                	j	80001696 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b1050513          	addi	a0,a0,-1264 # 80008168 <etext+0x168>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	f00080e7          	jalr	-256(ra) # 80000560 <panic>
      panic("uvmcopy: page not present");
    80001668:	00007517          	auipc	a0,0x7
    8000166c:	b2050513          	addi	a0,a0,-1248 # 80008188 <etext+0x188>
    80001670:	fffff097          	auipc	ra,0xfffff
    80001674:	ef0080e7          	jalr	-272(ra) # 80000560 <panic>
      kfree(mem);
    80001678:	854a                	mv	a0,s2
    8000167a:	fffff097          	auipc	ra,0xfffff
    8000167e:	3d0080e7          	jalr	976(ra) # 80000a4a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001682:	4685                	li	a3,1
    80001684:	00c9d613          	srli	a2,s3,0xc
    80001688:	4581                	li	a1,0
    8000168a:	8556                	mv	a0,s5
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	c32080e7          	jalr	-974(ra) # 800012be <uvmunmap>
  return -1;
    80001694:	557d                	li	a0,-1
}
    80001696:	60a6                	ld	ra,72(sp)
    80001698:	6406                	ld	s0,64(sp)
    8000169a:	74e2                	ld	s1,56(sp)
    8000169c:	7942                	ld	s2,48(sp)
    8000169e:	79a2                	ld	s3,40(sp)
    800016a0:	7a02                	ld	s4,32(sp)
    800016a2:	6ae2                	ld	s5,24(sp)
    800016a4:	6b42                	ld	s6,16(sp)
    800016a6:	6ba2                	ld	s7,8(sp)
    800016a8:	6161                	addi	sp,sp,80
    800016aa:	8082                	ret
  return 0;
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret

00000000800016b0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016b0:	1141                	addi	sp,sp,-16
    800016b2:	e406                	sd	ra,8(sp)
    800016b4:	e022                	sd	s0,0(sp)
    800016b6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016b8:	4601                	li	a2,0
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	956080e7          	jalr	-1706(ra) # 80001010 <walk>
  if(pte == 0)
    800016c2:	c901                	beqz	a0,800016d2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016c4:	611c                	ld	a5,0(a0)
    800016c6:	9bbd                	andi	a5,a5,-17
    800016c8:	e11c                	sd	a5,0(a0)
}
    800016ca:	60a2                	ld	ra,8(sp)
    800016cc:	6402                	ld	s0,0(sp)
    800016ce:	0141                	addi	sp,sp,16
    800016d0:	8082                	ret
    panic("uvmclear");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	ad650513          	addi	a0,a0,-1322 # 800081a8 <etext+0x1a8>
    800016da:	fffff097          	auipc	ra,0xfffff
    800016de:	e86080e7          	jalr	-378(ra) # 80000560 <panic>

00000000800016e2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016e2:	c6bd                	beqz	a3,80001750 <copyout+0x6e>
{
    800016e4:	715d                	addi	sp,sp,-80
    800016e6:	e486                	sd	ra,72(sp)
    800016e8:	e0a2                	sd	s0,64(sp)
    800016ea:	fc26                	sd	s1,56(sp)
    800016ec:	f84a                	sd	s2,48(sp)
    800016ee:	f44e                	sd	s3,40(sp)
    800016f0:	f052                	sd	s4,32(sp)
    800016f2:	ec56                	sd	s5,24(sp)
    800016f4:	e85a                	sd	s6,16(sp)
    800016f6:	e45e                	sd	s7,8(sp)
    800016f8:	e062                	sd	s8,0(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8b2a                	mv	s6,a0
    800016fe:	8c2e                	mv	s8,a1
    80001700:	8a32                	mv	s4,a2
    80001702:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001704:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001706:	6a85                	lui	s5,0x1
    80001708:	a015                	j	8000172c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000170a:	9562                	add	a0,a0,s8
    8000170c:	0004861b          	sext.w	a2,s1
    80001710:	85d2                	mv	a1,s4
    80001712:	41250533          	sub	a0,a0,s2
    80001716:	fffff097          	auipc	ra,0xfffff
    8000171a:	67a080e7          	jalr	1658(ra) # 80000d90 <memmove>

    len -= n;
    8000171e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001722:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001724:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001728:	02098263          	beqz	s3,8000174c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000172c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001730:	85ca                	mv	a1,s2
    80001732:	855a                	mv	a0,s6
    80001734:	00000097          	auipc	ra,0x0
    80001738:	982080e7          	jalr	-1662(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    8000173c:	cd01                	beqz	a0,80001754 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000173e:	418904b3          	sub	s1,s2,s8
    80001742:	94d6                	add	s1,s1,s5
    if(n > len)
    80001744:	fc99f3e3          	bgeu	s3,s1,8000170a <copyout+0x28>
    80001748:	84ce                	mv	s1,s3
    8000174a:	b7c1                	j	8000170a <copyout+0x28>
  }
  return 0;
    8000174c:	4501                	li	a0,0
    8000174e:	a021                	j	80001756 <copyout+0x74>
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret
      return -1;
    80001754:	557d                	li	a0,-1
}
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6c02                	ld	s8,0(sp)
    8000176a:	6161                	addi	sp,sp,80
    8000176c:	8082                	ret

000000008000176e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000176e:	caa5                	beqz	a3,800017de <copyin+0x70>
{
    80001770:	715d                	addi	sp,sp,-80
    80001772:	e486                	sd	ra,72(sp)
    80001774:	e0a2                	sd	s0,64(sp)
    80001776:	fc26                	sd	s1,56(sp)
    80001778:	f84a                	sd	s2,48(sp)
    8000177a:	f44e                	sd	s3,40(sp)
    8000177c:	f052                	sd	s4,32(sp)
    8000177e:	ec56                	sd	s5,24(sp)
    80001780:	e85a                	sd	s6,16(sp)
    80001782:	e45e                	sd	s7,8(sp)
    80001784:	e062                	sd	s8,0(sp)
    80001786:	0880                	addi	s0,sp,80
    80001788:	8b2a                	mv	s6,a0
    8000178a:	8a2e                	mv	s4,a1
    8000178c:	8c32                	mv	s8,a2
    8000178e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001790:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001792:	6a85                	lui	s5,0x1
    80001794:	a01d                	j	800017ba <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001796:	018505b3          	add	a1,a0,s8
    8000179a:	0004861b          	sext.w	a2,s1
    8000179e:	412585b3          	sub	a1,a1,s2
    800017a2:	8552                	mv	a0,s4
    800017a4:	fffff097          	auipc	ra,0xfffff
    800017a8:	5ec080e7          	jalr	1516(ra) # 80000d90 <memmove>

    len -= n;
    800017ac:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017b0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017b2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017b6:	02098263          	beqz	s3,800017da <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017ba:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017be:	85ca                	mv	a1,s2
    800017c0:	855a                	mv	a0,s6
    800017c2:	00000097          	auipc	ra,0x0
    800017c6:	8f4080e7          	jalr	-1804(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    800017ca:	cd01                	beqz	a0,800017e2 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    800017cc:	418904b3          	sub	s1,s2,s8
    800017d0:	94d6                	add	s1,s1,s5
    if(n > len)
    800017d2:	fc99f2e3          	bgeu	s3,s1,80001796 <copyin+0x28>
    800017d6:	84ce                	mv	s1,s3
    800017d8:	bf7d                	j	80001796 <copyin+0x28>
  }
  return 0;
    800017da:	4501                	li	a0,0
    800017dc:	a021                	j	800017e4 <copyin+0x76>
    800017de:	4501                	li	a0,0
}
    800017e0:	8082                	ret
      return -1;
    800017e2:	557d                	li	a0,-1
}
    800017e4:	60a6                	ld	ra,72(sp)
    800017e6:	6406                	ld	s0,64(sp)
    800017e8:	74e2                	ld	s1,56(sp)
    800017ea:	7942                	ld	s2,48(sp)
    800017ec:	79a2                	ld	s3,40(sp)
    800017ee:	7a02                	ld	s4,32(sp)
    800017f0:	6ae2                	ld	s5,24(sp)
    800017f2:	6b42                	ld	s6,16(sp)
    800017f4:	6ba2                	ld	s7,8(sp)
    800017f6:	6c02                	ld	s8,0(sp)
    800017f8:	6161                	addi	sp,sp,80
    800017fa:	8082                	ret

00000000800017fc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017fc:	cacd                	beqz	a3,800018ae <copyinstr+0xb2>
{
    800017fe:	715d                	addi	sp,sp,-80
    80001800:	e486                	sd	ra,72(sp)
    80001802:	e0a2                	sd	s0,64(sp)
    80001804:	fc26                	sd	s1,56(sp)
    80001806:	f84a                	sd	s2,48(sp)
    80001808:	f44e                	sd	s3,40(sp)
    8000180a:	f052                	sd	s4,32(sp)
    8000180c:	ec56                	sd	s5,24(sp)
    8000180e:	e85a                	sd	s6,16(sp)
    80001810:	e45e                	sd	s7,8(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8a2a                	mv	s4,a0
    80001816:	8b2e                	mv	s6,a1
    80001818:	8bb2                	mv	s7,a2
    8000181a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    8000181c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000181e:	6985                	lui	s3,0x1
    80001820:	a825                	j	80001858 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001822:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001826:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001828:	37fd                	addiw	a5,a5,-1
    8000182a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000182e:	60a6                	ld	ra,72(sp)
    80001830:	6406                	ld	s0,64(sp)
    80001832:	74e2                	ld	s1,56(sp)
    80001834:	7942                	ld	s2,48(sp)
    80001836:	79a2                	ld	s3,40(sp)
    80001838:	7a02                	ld	s4,32(sp)
    8000183a:	6ae2                	ld	s5,24(sp)
    8000183c:	6b42                	ld	s6,16(sp)
    8000183e:	6ba2                	ld	s7,8(sp)
    80001840:	6161                	addi	sp,sp,80
    80001842:	8082                	ret
    80001844:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001848:	9742                	add	a4,a4,a6
      --max;
    8000184a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    8000184e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001852:	04e58663          	beq	a1,a4,8000189e <copyinstr+0xa2>
{
    80001856:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001858:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000185c:	85a6                	mv	a1,s1
    8000185e:	8552                	mv	a0,s4
    80001860:	00000097          	auipc	ra,0x0
    80001864:	856080e7          	jalr	-1962(ra) # 800010b6 <walkaddr>
    if(pa0 == 0)
    80001868:	cd0d                	beqz	a0,800018a2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    8000186a:	417486b3          	sub	a3,s1,s7
    8000186e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001870:	00d97363          	bgeu	s2,a3,80001876 <copyinstr+0x7a>
    80001874:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001876:	955e                	add	a0,a0,s7
    80001878:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000187a:	c695                	beqz	a3,800018a6 <copyinstr+0xaa>
    8000187c:	87da                	mv	a5,s6
    8000187e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001880:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001884:	96da                	add	a3,a3,s6
    80001886:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001888:	00f60733          	add	a4,a2,a5
    8000188c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd23e0>
    80001890:	db49                	beqz	a4,80001822 <copyinstr+0x26>
        *dst = *p;
    80001892:	00e78023          	sb	a4,0(a5)
      dst++;
    80001896:	0785                	addi	a5,a5,1
    while(n > 0){
    80001898:	fed797e3          	bne	a5,a3,80001886 <copyinstr+0x8a>
    8000189c:	b765                	j	80001844 <copyinstr+0x48>
    8000189e:	4781                	li	a5,0
    800018a0:	b761                	j	80001828 <copyinstr+0x2c>
      return -1;
    800018a2:	557d                	li	a0,-1
    800018a4:	b769                	j	8000182e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800018a6:	6b85                	lui	s7,0x1
    800018a8:	9ba6                	add	s7,s7,s1
    800018aa:	87da                	mv	a5,s6
    800018ac:	b76d                	j	80001856 <copyinstr+0x5a>
  int got_null = 0;
    800018ae:	4781                	li	a5,0
  if(got_null){
    800018b0:	37fd                	addiw	a5,a5,-1
    800018b2:	0007851b          	sext.w	a0,a5
}
    800018b6:	8082                	ret

00000000800018b8 <select_next_process>:
// {
//   boost_count = 0;
// }

struct proc *select_next_process()
{
    800018b8:	1141                	addi	sp,sp,-16
    800018ba:	e422                	sd	s0,8(sp)
    800018bc:	0800                	addi	s0,sp,16
  for (int i = 0; i < NQUEUE; i++)
    800018be:	00012817          	auipc	a6,0x12
    800018c2:	e0280813          	addi	a6,a6,-510 # 800136c0 <queue_count>
    800018c6:	00012317          	auipc	t1,0x12
    800018ca:	23a30313          	addi	t1,t1,570 # 80013b00 <mlfq_proc>
  {
    for (int j = 0; j < queue_count[i]; j++)
    800018ce:	889a                	mv	a7,t1
    800018d0:	4581                	li	a1,0
      // if (p->pid == 132)
      // {
      //   printf("%d\n", p->priority);
      //   // printf("%d %d %d %d\n", queue_count[0], queue_count[1], queue_count[2], queue_count[3]);
      // }
      if (p->state == RUNNABLE)
    800018d2:	460d                	li	a2,3
    for (int j = 0; j < queue_count[i]; j++)
    800018d4:	00082683          	lw	a3,0(a6)
    800018d8:	00d05d63          	blez	a3,800018f2 <select_next_process+0x3a>
    800018dc:	96ae                	add	a3,a3,a1
    800018de:	068e                	slli	a3,a3,0x3
    800018e0:	969a                	add	a3,a3,t1
    800018e2:	87c6                	mv	a5,a7
      struct proc *p = mlfq_proc[i][j];
    800018e4:	6388                	ld	a0,0(a5)
      if (p->state == RUNNABLE)
    800018e6:	4d18                	lw	a4,24(a0)
    800018e8:	00c70f63          	beq	a4,a2,80001906 <select_next_process+0x4e>
    for (int j = 0; j < queue_count[i]; j++)
    800018ec:	07a1                	addi	a5,a5,8
    800018ee:	fed79be3          	bne	a5,a3,800018e4 <select_next_process+0x2c>
  for (int i = 0; i < NQUEUE; i++)
    800018f2:	0811                	addi	a6,a6,4
    800018f4:	25088893          	addi	a7,a7,592
    800018f8:	04a58593          	addi	a1,a1,74
    800018fc:	12800793          	li	a5,296
    80001900:	fcf59ae3          	bne	a1,a5,800018d4 <select_next_process+0x1c>
        return p;
      }
    }
  }
  // printf("No process found\n");
  return 0;
    80001904:	4501                	li	a0,0
}
    80001906:	6422                	ld	s0,8(sp)
    80001908:	0141                	addi	sp,sp,16
    8000190a:	8082                	ret

000000008000190c <remove_from_queue>:

void remove_from_queue(int priority, int pid)
{
    8000190c:	1141                	addi	sp,sp,-16
    8000190e:	e422                	sd	s0,8(sp)
    80001910:	0800                	addi	s0,sp,16
  for (int i = 0; i < queue_count[priority]; i++)
    80001912:	00251713          	slli	a4,a0,0x2
    80001916:	00012797          	auipc	a5,0x12
    8000191a:	daa78793          	addi	a5,a5,-598 # 800136c0 <queue_count>
    8000191e:	97ba                	add	a5,a5,a4
    80001920:	4390                	lw	a2,0(a5)
    80001922:	06c05463          	blez	a2,8000198a <remove_from_queue+0x7e>
    80001926:	25000713          	li	a4,592
    8000192a:	02e50733          	mul	a4,a0,a4
    8000192e:	00012797          	auipc	a5,0x12
    80001932:	1d278793          	addi	a5,a5,466 # 80013b00 <mlfq_proc>
    80001936:	973e                	add	a4,a4,a5
    80001938:	4781                	li	a5,0
  {
    if (mlfq_proc[priority][i]->pid == pid)
    8000193a:	6314                	ld	a3,0(a4)
    8000193c:	5a94                	lw	a3,48(a3)
    8000193e:	00b68763          	beq	a3,a1,8000194c <remove_from_queue+0x40>
  for (int i = 0; i < queue_count[priority]; i++)
    80001942:	2785                	addiw	a5,a5,1
    80001944:	0721                	addi	a4,a4,8
    80001946:	fec79ae3          	bne	a5,a2,8000193a <remove_from_queue+0x2e>
    8000194a:	a081                	j	8000198a <remove_from_queue+0x7e>
    {
      for (int j = i; j < queue_count[priority] - 1; j++)
    8000194c:	fff6059b          	addiw	a1,a2,-1 # fff <_entry-0x7ffff001>
    80001950:	0005871b          	sext.w	a4,a1
    80001954:	02e7d463          	bge	a5,a4,8000197c <remove_from_queue+0x70>
    80001958:	04a00713          	li	a4,74
    8000195c:	02e50733          	mul	a4,a0,a4
    80001960:	973e                	add	a4,a4,a5
    80001962:	070e                	slli	a4,a4,0x3
    80001964:	00012697          	auipc	a3,0x12
    80001968:	19c68693          	addi	a3,a3,412 # 80013b00 <mlfq_proc>
    8000196c:	9736                	add	a4,a4,a3
    8000196e:	367d                	addiw	a2,a2,-1
      {
        mlfq_proc[priority][j] = mlfq_proc[priority][j + 1];
    80001970:	2785                	addiw	a5,a5,1
    80001972:	6714                	ld	a3,8(a4)
    80001974:	e314                	sd	a3,0(a4)
      for (int j = i; j < queue_count[priority] - 1; j++)
    80001976:	0721                	addi	a4,a4,8
    80001978:	fec79ce3          	bne	a5,a2,80001970 <remove_from_queue+0x64>
      }
      queue_count[priority]--;
    8000197c:	050a                	slli	a0,a0,0x2
    8000197e:	00012797          	auipc	a5,0x12
    80001982:	d4278793          	addi	a5,a5,-702 # 800136c0 <queue_count>
    80001986:	97aa                	add	a5,a5,a0
    80001988:	c38c                	sw	a1,0(a5)
      break;
    }
  }
}
    8000198a:	6422                	ld	s0,8(sp)
    8000198c:	0141                	addi	sp,sp,16
    8000198e:	8082                	ret

0000000080001990 <add_to_queue>:

void add_to_queue(int priority, struct proc *p)
{
    80001990:	1141                	addi	sp,sp,-16
    80001992:	e422                	sd	s0,8(sp)
    80001994:	0800                	addi	s0,sp,16
  mlfq_proc[priority][queue_count[priority]] = p;
    80001996:	00251713          	slli	a4,a0,0x2
    8000199a:	00012797          	auipc	a5,0x12
    8000199e:	d2678793          	addi	a5,a5,-730 # 800136c0 <queue_count>
    800019a2:	97ba                	add	a5,a5,a4
    800019a4:	4398                	lw	a4,0(a5)
    800019a6:	04a00693          	li	a3,74
    800019aa:	02d50533          	mul	a0,a0,a3
    800019ae:	953a                	add	a0,a0,a4
    800019b0:	050e                	slli	a0,a0,0x3
    800019b2:	00012697          	auipc	a3,0x12
    800019b6:	14e68693          	addi	a3,a3,334 # 80013b00 <mlfq_proc>
    800019ba:	96aa                	add	a3,a3,a0
    800019bc:	e28c                	sd	a1,0(a3)
  queue_count[priority]++;
    800019be:	2705                	addiw	a4,a4,1
    800019c0:	c398                	sw	a4,0(a5)
}
    800019c2:	6422                	ld	s0,8(sp)
    800019c4:	0141                	addi	sp,sp,16
    800019c6:	8082                	ret

00000000800019c8 <send_to_last>:

void send_to_last(int priority, int pid)
{
    800019c8:	1141                	addi	sp,sp,-16
    800019ca:	e422                	sd	s0,8(sp)
    800019cc:	0800                	addi	s0,sp,16
  // printf("%d\n", queue_count[priority]);
  if (queue_count[priority] == 0 || queue_count[priority] == 1)
    800019ce:	00251713          	slli	a4,a0,0x2
    800019d2:	00012797          	auipc	a5,0x12
    800019d6:	cee78793          	addi	a5,a5,-786 # 800136c0 <queue_count>
    800019da:	97ba                	add	a5,a5,a4
    800019dc:	0007a803          	lw	a6,0(a5)
    800019e0:	4785                	li	a5,1
    800019e2:	0707d763          	bge	a5,a6,80001a50 <send_to_last+0x88>
    800019e6:	25000713          	li	a4,592
    800019ea:	02e50733          	mul	a4,a0,a4
    800019ee:	00012797          	auipc	a5,0x12
    800019f2:	11278793          	addi	a5,a5,274 # 80013b00 <mlfq_proc>
    800019f6:	973e                	add	a4,a4,a5
  {
    return;
  }
  for (int i = 0; i < queue_count[priority]; i++)
    800019f8:	4781                	li	a5,0
  {
    if (mlfq_proc[priority][i]->pid == pid)
    800019fa:	6314                	ld	a3,0(a4)
    800019fc:	5a90                	lw	a2,48(a3)
    800019fe:	00b60763          	beq	a2,a1,80001a0c <send_to_last+0x44>
  for (int i = 0; i < queue_count[priority]; i++)
    80001a02:	2785                	addiw	a5,a5,1
    80001a04:	0721                	addi	a4,a4,8
    80001a06:	fef81ae3          	bne	a6,a5,800019fa <send_to_last+0x32>
    80001a0a:	a099                	j	80001a50 <send_to_last+0x88>
    {
      struct proc *p = mlfq_proc[priority][i];
      for (int j = i; j < queue_count[priority] - 1; j++)
    80001a0c:	fff8059b          	addiw	a1,a6,-1
    80001a10:	02b7d463          	bge	a5,a1,80001a38 <send_to_last+0x70>
    80001a14:	04a00713          	li	a4,74
    80001a18:	02e50733          	mul	a4,a0,a4
    80001a1c:	973e                	add	a4,a4,a5
    80001a1e:	070e                	slli	a4,a4,0x3
    80001a20:	00012617          	auipc	a2,0x12
    80001a24:	0e060613          	addi	a2,a2,224 # 80013b00 <mlfq_proc>
    80001a28:	9732                	add	a4,a4,a2
    80001a2a:	882e                	mv	a6,a1
      {
        mlfq_proc[priority][j] = mlfq_proc[priority][j + 1];
    80001a2c:	2785                	addiw	a5,a5,1
    80001a2e:	6710                	ld	a2,8(a4)
    80001a30:	e310                	sd	a2,0(a4)
      for (int j = i; j < queue_count[priority] - 1; j++)
    80001a32:	0721                	addi	a4,a4,8
    80001a34:	ff079ce3          	bne	a5,a6,80001a2c <send_to_last+0x64>
      }
      mlfq_proc[priority][queue_count[priority] - 1] = p;
    80001a38:	04a00793          	li	a5,74
    80001a3c:	02f507b3          	mul	a5,a0,a5
    80001a40:	97ae                	add	a5,a5,a1
    80001a42:	078e                	slli	a5,a5,0x3
    80001a44:	00012717          	auipc	a4,0x12
    80001a48:	0bc70713          	addi	a4,a4,188 # 80013b00 <mlfq_proc>
    80001a4c:	97ba                	add	a5,a5,a4
    80001a4e:	e394                	sd	a3,0(a5)
      // printf("%d\n", p->parent->priority);
      break;
    }
  }
}
    80001a50:	6422                	ld	s0,8(sp)
    80001a52:	0141                	addi	sp,sp,16
    80001a54:	8082                	ret

0000000080001a56 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001a56:	7139                	addi	sp,sp,-64
    80001a58:	fc06                	sd	ra,56(sp)
    80001a5a:	f822                	sd	s0,48(sp)
    80001a5c:	f426                	sd	s1,40(sp)
    80001a5e:	f04a                	sd	s2,32(sp)
    80001a60:	ec4e                	sd	s3,24(sp)
    80001a62:	e852                	sd	s4,16(sp)
    80001a64:	e456                	sd	s5,8(sp)
    80001a66:	e05a                	sd	s6,0(sp)
    80001a68:	0080                	addi	s0,sp,64
    80001a6a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001a6c:	00013497          	auipc	s1,0x13
    80001a70:	9d448493          	addi	s1,s1,-1580 # 80014440 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001a74:	8b26                	mv	s6,s1
    80001a76:	00874937          	lui	s2,0x874
    80001a7a:	ecb90913          	addi	s2,s2,-309 # 873ecb <_entry-0x7f78c135>
    80001a7e:	0932                	slli	s2,s2,0xc
    80001a80:	de390913          	addi	s2,s2,-541
    80001a84:	093a                	slli	s2,s2,0xe
    80001a86:	13590913          	addi	s2,s2,309
    80001a8a:	0932                	slli	s2,s2,0xc
    80001a8c:	21d90913          	addi	s2,s2,541
    80001a90:	040009b7          	lui	s3,0x4000
    80001a94:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a96:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001a98:	00020a97          	auipc	s5,0x20
    80001a9c:	da8a8a93          	addi	s5,s5,-600 # 80021840 <tickslock>
    char *pa = kalloc();
    80001aa0:	fffff097          	auipc	ra,0xfffff
    80001aa4:	0a8080e7          	jalr	168(ra) # 80000b48 <kalloc>
    80001aa8:	862a                	mv	a2,a0
    if (pa == 0)
    80001aaa:	c121                	beqz	a0,80001aea <proc_mapstacks+0x94>
    uint64 va = KSTACK((int)(p - proc));
    80001aac:	416485b3          	sub	a1,s1,s6
    80001ab0:	8591                	srai	a1,a1,0x4
    80001ab2:	032585b3          	mul	a1,a1,s2
    80001ab6:	2585                	addiw	a1,a1,1
    80001ab8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001abc:	4719                	li	a4,6
    80001abe:	6685                	lui	a3,0x1
    80001ac0:	40b985b3          	sub	a1,s3,a1
    80001ac4:	8552                	mv	a0,s4
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	6d2080e7          	jalr	1746(ra) # 80001198 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001ace:	35048493          	addi	s1,s1,848
    80001ad2:	fd5497e3          	bne	s1,s5,80001aa0 <proc_mapstacks+0x4a>
  }
}
    80001ad6:	70e2                	ld	ra,56(sp)
    80001ad8:	7442                	ld	s0,48(sp)
    80001ada:	74a2                	ld	s1,40(sp)
    80001adc:	7902                	ld	s2,32(sp)
    80001ade:	69e2                	ld	s3,24(sp)
    80001ae0:	6a42                	ld	s4,16(sp)
    80001ae2:	6aa2                	ld	s5,8(sp)
    80001ae4:	6b02                	ld	s6,0(sp)
    80001ae6:	6121                	addi	sp,sp,64
    80001ae8:	8082                	ret
      panic("kalloc");
    80001aea:	00006517          	auipc	a0,0x6
    80001aee:	6ce50513          	addi	a0,a0,1742 # 800081b8 <etext+0x1b8>
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	a6e080e7          	jalr	-1426(ra) # 80000560 <panic>

0000000080001afa <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001afa:	7139                	addi	sp,sp,-64
    80001afc:	fc06                	sd	ra,56(sp)
    80001afe:	f822                	sd	s0,48(sp)
    80001b00:	f426                	sd	s1,40(sp)
    80001b02:	f04a                	sd	s2,32(sp)
    80001b04:	ec4e                	sd	s3,24(sp)
    80001b06:	e852                	sd	s4,16(sp)
    80001b08:	e456                	sd	s5,8(sp)
    80001b0a:	e05a                	sd	s6,0(sp)
    80001b0c:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001b0e:	00006597          	auipc	a1,0x6
    80001b12:	6b258593          	addi	a1,a1,1714 # 800081c0 <etext+0x1c0>
    80001b16:	00012517          	auipc	a0,0x12
    80001b1a:	bba50513          	addi	a0,a0,-1094 # 800136d0 <pid_lock>
    80001b1e:	fffff097          	auipc	ra,0xfffff
    80001b22:	08a080e7          	jalr	138(ra) # 80000ba8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b26:	00006597          	auipc	a1,0x6
    80001b2a:	6a258593          	addi	a1,a1,1698 # 800081c8 <etext+0x1c8>
    80001b2e:	00012517          	auipc	a0,0x12
    80001b32:	bba50513          	addi	a0,a0,-1094 # 800136e8 <wait_lock>
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	072080e7          	jalr	114(ra) # 80000ba8 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b3e:	00013497          	auipc	s1,0x13
    80001b42:	90248493          	addi	s1,s1,-1790 # 80014440 <proc>
  {
    initlock(&p->lock, "proc");
    80001b46:	00006b17          	auipc	s6,0x6
    80001b4a:	692b0b13          	addi	s6,s6,1682 # 800081d8 <etext+0x1d8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001b4e:	8aa6                	mv	s5,s1
    80001b50:	00874937          	lui	s2,0x874
    80001b54:	ecb90913          	addi	s2,s2,-309 # 873ecb <_entry-0x7f78c135>
    80001b58:	0932                	slli	s2,s2,0xc
    80001b5a:	de390913          	addi	s2,s2,-541
    80001b5e:	093a                	slli	s2,s2,0xe
    80001b60:	13590913          	addi	s2,s2,309
    80001b64:	0932                	slli	s2,s2,0xc
    80001b66:	21d90913          	addi	s2,s2,541
    80001b6a:	040009b7          	lui	s3,0x4000
    80001b6e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001b70:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b72:	00020a17          	auipc	s4,0x20
    80001b76:	ccea0a13          	addi	s4,s4,-818 # 80021840 <tickslock>
    initlock(&p->lock, "proc");
    80001b7a:	85da                	mv	a1,s6
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	02a080e7          	jalr	42(ra) # 80000ba8 <initlock>
    p->state = UNUSED;
    80001b86:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001b8a:	415487b3          	sub	a5,s1,s5
    80001b8e:	8791                	srai	a5,a5,0x4
    80001b90:	032787b3          	mul	a5,a5,s2
    80001b94:	2785                	addiw	a5,a5,1
    80001b96:	00d7979b          	slliw	a5,a5,0xd
    80001b9a:	40f987b3          	sub	a5,s3,a5
    80001b9e:	20f4bc23          	sd	a5,536(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001ba2:	35048493          	addi	s1,s1,848
    80001ba6:	fd449ae3          	bne	s1,s4,80001b7a <procinit+0x80>
  }
}
    80001baa:	70e2                	ld	ra,56(sp)
    80001bac:	7442                	ld	s0,48(sp)
    80001bae:	74a2                	ld	s1,40(sp)
    80001bb0:	7902                	ld	s2,32(sp)
    80001bb2:	69e2                	ld	s3,24(sp)
    80001bb4:	6a42                	ld	s4,16(sp)
    80001bb6:	6aa2                	ld	s5,8(sp)
    80001bb8:	6b02                	ld	s6,0(sp)
    80001bba:	6121                	addi	sp,sp,64
    80001bbc:	8082                	ret

0000000080001bbe <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001bbe:	1141                	addi	sp,sp,-16
    80001bc0:	e422                	sd	s0,8(sp)
    80001bc2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001bc6:	2501                	sext.w	a0,a0
    80001bc8:	6422                	ld	s0,8(sp)
    80001bca:	0141                	addi	sp,sp,16
    80001bcc:	8082                	ret

0000000080001bce <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001bce:	1141                	addi	sp,sp,-16
    80001bd0:	e422                	sd	s0,8(sp)
    80001bd2:	0800                	addi	s0,sp,16
    80001bd4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001bd6:	2781                	sext.w	a5,a5
    80001bd8:	079e                	slli	a5,a5,0x7
  return c;
}
    80001bda:	00012517          	auipc	a0,0x12
    80001bde:	b2650513          	addi	a0,a0,-1242 # 80013700 <cpus>
    80001be2:	953e                	add	a0,a0,a5
    80001be4:	6422                	ld	s0,8(sp)
    80001be6:	0141                	addi	sp,sp,16
    80001be8:	8082                	ret

0000000080001bea <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001bea:	1101                	addi	sp,sp,-32
    80001bec:	ec06                	sd	ra,24(sp)
    80001bee:	e822                	sd	s0,16(sp)
    80001bf0:	e426                	sd	s1,8(sp)
    80001bf2:	1000                	addi	s0,sp,32
  push_off();
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	ff8080e7          	jalr	-8(ra) # 80000bec <push_off>
    80001bfc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001bfe:	2781                	sext.w	a5,a5
    80001c00:	079e                	slli	a5,a5,0x7
    80001c02:	00012717          	auipc	a4,0x12
    80001c06:	abe70713          	addi	a4,a4,-1346 # 800136c0 <queue_count>
    80001c0a:	97ba                	add	a5,a5,a4
    80001c0c:	63a4                	ld	s1,64(a5)
  pop_off();
    80001c0e:	fffff097          	auipc	ra,0xfffff
    80001c12:	07e080e7          	jalr	126(ra) # 80000c8c <pop_off>
  return p;
}
    80001c16:	8526                	mv	a0,s1
    80001c18:	60e2                	ld	ra,24(sp)
    80001c1a:	6442                	ld	s0,16(sp)
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	6105                	addi	sp,sp,32
    80001c20:	8082                	ret

0000000080001c22 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001c22:	1141                	addi	sp,sp,-16
    80001c24:	e406                	sd	ra,8(sp)
    80001c26:	e022                	sd	s0,0(sp)
    80001c28:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c2a:	00000097          	auipc	ra,0x0
    80001c2e:	fc0080e7          	jalr	-64(ra) # 80001bea <myproc>
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	0ba080e7          	jalr	186(ra) # 80000cec <release>

  if (first)
    80001c3a:	00009797          	auipc	a5,0x9
    80001c3e:	7667a783          	lw	a5,1894(a5) # 8000b3a0 <first.1>
    80001c42:	eb89                	bnez	a5,80001c54 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001c44:	00001097          	auipc	ra,0x1
    80001c48:	208080e7          	jalr	520(ra) # 80002e4c <usertrapret>
}
    80001c4c:	60a2                	ld	ra,8(sp)
    80001c4e:	6402                	ld	s0,0(sp)
    80001c50:	0141                	addi	sp,sp,16
    80001c52:	8082                	ret
    first = 0;
    80001c54:	00009797          	auipc	a5,0x9
    80001c58:	7407a623          	sw	zero,1868(a5) # 8000b3a0 <first.1>
    fsinit(ROOTDEV);
    80001c5c:	4505                	li	a0,1
    80001c5e:	00002097          	auipc	ra,0x2
    80001c62:	156080e7          	jalr	342(ra) # 80003db4 <fsinit>
    80001c66:	bff9                	j	80001c44 <forkret+0x22>

0000000080001c68 <allocpid>:
{
    80001c68:	1101                	addi	sp,sp,-32
    80001c6a:	ec06                	sd	ra,24(sp)
    80001c6c:	e822                	sd	s0,16(sp)
    80001c6e:	e426                	sd	s1,8(sp)
    80001c70:	e04a                	sd	s2,0(sp)
    80001c72:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c74:	00012917          	auipc	s2,0x12
    80001c78:	a5c90913          	addi	s2,s2,-1444 # 800136d0 <pid_lock>
    80001c7c:	854a                	mv	a0,s2
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	fba080e7          	jalr	-70(ra) # 80000c38 <acquire>
  pid = nextpid;
    80001c86:	00009797          	auipc	a5,0x9
    80001c8a:	71e78793          	addi	a5,a5,1822 # 8000b3a4 <nextpid>
    80001c8e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001c90:	0014871b          	addiw	a4,s1,1
    80001c94:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001c96:	854a                	mv	a0,s2
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	054080e7          	jalr	84(ra) # 80000cec <release>
}
    80001ca0:	8526                	mv	a0,s1
    80001ca2:	60e2                	ld	ra,24(sp)
    80001ca4:	6442                	ld	s0,16(sp)
    80001ca6:	64a2                	ld	s1,8(sp)
    80001ca8:	6902                	ld	s2,0(sp)
    80001caa:	6105                	addi	sp,sp,32
    80001cac:	8082                	ret

0000000080001cae <proc_pagetable>:
{
    80001cae:	1101                	addi	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	e04a                	sd	s2,0(sp)
    80001cb8:	1000                	addi	s0,sp,32
    80001cba:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	6d6080e7          	jalr	1750(ra) # 80001392 <uvmcreate>
    80001cc4:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001cc6:	c121                	beqz	a0,80001d06 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001cc8:	4729                	li	a4,10
    80001cca:	00005697          	auipc	a3,0x5
    80001cce:	33668693          	addi	a3,a3,822 # 80007000 <_trampoline>
    80001cd2:	6605                	lui	a2,0x1
    80001cd4:	040005b7          	lui	a1,0x4000
    80001cd8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cda:	05b2                	slli	a1,a1,0xc
    80001cdc:	fffff097          	auipc	ra,0xfffff
    80001ce0:	41c080e7          	jalr	1052(ra) # 800010f8 <mappages>
    80001ce4:	02054863          	bltz	a0,80001d14 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ce8:	4719                	li	a4,6
    80001cea:	23093683          	ld	a3,560(s2)
    80001cee:	6605                	lui	a2,0x1
    80001cf0:	020005b7          	lui	a1,0x2000
    80001cf4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001cf6:	05b6                	slli	a1,a1,0xd
    80001cf8:	8526                	mv	a0,s1
    80001cfa:	fffff097          	auipc	ra,0xfffff
    80001cfe:	3fe080e7          	jalr	1022(ra) # 800010f8 <mappages>
    80001d02:	02054163          	bltz	a0,80001d24 <proc_pagetable+0x76>
}
    80001d06:	8526                	mv	a0,s1
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6902                	ld	s2,0(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret
    uvmfree(pagetable, 0);
    80001d14:	4581                	li	a1,0
    80001d16:	8526                	mv	a0,s1
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	88c080e7          	jalr	-1908(ra) # 800015a4 <uvmfree>
    return 0;
    80001d20:	4481                	li	s1,0
    80001d22:	b7d5                	j	80001d06 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d24:	4681                	li	a3,0
    80001d26:	4605                	li	a2,1
    80001d28:	040005b7          	lui	a1,0x4000
    80001d2c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d2e:	05b2                	slli	a1,a1,0xc
    80001d30:	8526                	mv	a0,s1
    80001d32:	fffff097          	auipc	ra,0xfffff
    80001d36:	58c080e7          	jalr	1420(ra) # 800012be <uvmunmap>
    uvmfree(pagetable, 0);
    80001d3a:	4581                	li	a1,0
    80001d3c:	8526                	mv	a0,s1
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	866080e7          	jalr	-1946(ra) # 800015a4 <uvmfree>
    return 0;
    80001d46:	4481                	li	s1,0
    80001d48:	bf7d                	j	80001d06 <proc_pagetable+0x58>

0000000080001d4a <proc_freepagetable>:
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	e04a                	sd	s2,0(sp)
    80001d54:	1000                	addi	s0,sp,32
    80001d56:	84aa                	mv	s1,a0
    80001d58:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d5a:	4681                	li	a3,0
    80001d5c:	4605                	li	a2,1
    80001d5e:	040005b7          	lui	a1,0x4000
    80001d62:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d64:	05b2                	slli	a1,a1,0xc
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	558080e7          	jalr	1368(ra) # 800012be <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d6e:	4681                	li	a3,0
    80001d70:	4605                	li	a2,1
    80001d72:	020005b7          	lui	a1,0x2000
    80001d76:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d78:	05b6                	slli	a1,a1,0xd
    80001d7a:	8526                	mv	a0,s1
    80001d7c:	fffff097          	auipc	ra,0xfffff
    80001d80:	542080e7          	jalr	1346(ra) # 800012be <uvmunmap>
  uvmfree(pagetable, sz);
    80001d84:	85ca                	mv	a1,s2
    80001d86:	8526                	mv	a0,s1
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	81c080e7          	jalr	-2020(ra) # 800015a4 <uvmfree>
}
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	64a2                	ld	s1,8(sp)
    80001d96:	6902                	ld	s2,0(sp)
    80001d98:	6105                	addi	sp,sp,32
    80001d9a:	8082                	ret

0000000080001d9c <freeproc>:
{
    80001d9c:	1101                	addi	sp,sp,-32
    80001d9e:	ec06                	sd	ra,24(sp)
    80001da0:	e822                	sd	s0,16(sp)
    80001da2:	e426                	sd	s1,8(sp)
    80001da4:	1000                	addi	s0,sp,32
    80001da6:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001da8:	23053503          	ld	a0,560(a0)
    80001dac:	c509                	beqz	a0,80001db6 <freeproc+0x1a>
    kfree((void *)p->trapframe);
    80001dae:	fffff097          	auipc	ra,0xfffff
    80001db2:	c9c080e7          	jalr	-868(ra) # 80000a4a <kfree>
  p->trapframe = 0;
    80001db6:	2204b823          	sd	zero,560(s1)
  if (p->pagetable)
    80001dba:	2284b503          	ld	a0,552(s1)
    80001dbe:	c519                	beqz	a0,80001dcc <freeproc+0x30>
    proc_freepagetable(p->pagetable, p->sz);
    80001dc0:	2204b583          	ld	a1,544(s1)
    80001dc4:	00000097          	auipc	ra,0x0
    80001dc8:	f86080e7          	jalr	-122(ra) # 80001d4a <proc_freepagetable>
  p->pagetable = 0;
    80001dcc:	2204b423          	sd	zero,552(s1)
  p->sz = 0;
    80001dd0:	2204b023          	sd	zero,544(s1)
  p->pid = 0;
    80001dd4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001dd8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ddc:	32048823          	sb	zero,816(s1)
  p->chan = 0;
    80001de0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001de4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001de8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001dec:	0004ac23          	sw	zero,24(s1)
  for (int x = 0; x <= 26; x++)
    80001df0:	04048793          	addi	a5,s1,64
    80001df4:	0ac48713          	addi	a4,s1,172
    p->syscall_count[x] = 0;
    80001df8:	0007a023          	sw	zero,0(a5)
  for (int x = 0; x <= 26; x++)
    80001dfc:	0791                	addi	a5,a5,4
    80001dfe:	fee79de3          	bne	a5,a4,80001df8 <freeproc+0x5c>
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6105                	addi	sp,sp,32
    80001e0a:	8082                	ret

0000000080001e0c <allocproc>:
{
    80001e0c:	1101                	addi	sp,sp,-32
    80001e0e:	ec06                	sd	ra,24(sp)
    80001e10:	e822                	sd	s0,16(sp)
    80001e12:	e426                	sd	s1,8(sp)
    80001e14:	e04a                	sd	s2,0(sp)
    80001e16:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001e18:	00012497          	auipc	s1,0x12
    80001e1c:	62848493          	addi	s1,s1,1576 # 80014440 <proc>
    80001e20:	00020917          	auipc	s2,0x20
    80001e24:	a2090913          	addi	s2,s2,-1504 # 80021840 <tickslock>
    acquire(&p->lock);
    80001e28:	8526                	mv	a0,s1
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	e0e080e7          	jalr	-498(ra) # 80000c38 <acquire>
    if (p->state == UNUSED)
    80001e32:	4c9c                	lw	a5,24(s1)
    80001e34:	cf81                	beqz	a5,80001e4c <allocproc+0x40>
      release(&p->lock);
    80001e36:	8526                	mv	a0,s1
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	eb4080e7          	jalr	-332(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001e40:	35048493          	addi	s1,s1,848
    80001e44:	ff2492e3          	bne	s1,s2,80001e28 <allocproc+0x1c>
  return 0;
    80001e48:	4481                	li	s1,0
    80001e4a:	a855                	j	80001efe <allocproc+0xf2>
  p->pid = allocpid();
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	e1c080e7          	jalr	-484(ra) # 80001c68 <allocpid>
    80001e54:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e56:	4785                	li	a5,1
    80001e58:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	cee080e7          	jalr	-786(ra) # 80000b48 <kalloc>
    80001e62:	892a                	mv	s2,a0
    80001e64:	22a4b823          	sd	a0,560(s1)
    80001e68:	04048793          	addi	a5,s1,64
    80001e6c:	0ac48713          	addi	a4,s1,172
    80001e70:	cd51                	beqz	a0,80001f0c <allocproc+0x100>
    p->syscall_count[x] = 0;
    80001e72:	0007a023          	sw	zero,0(a5)
  for (int x = 0; x <= NSYSCALLS; x++)
    80001e76:	0791                	addi	a5,a5,4
    80001e78:	fee79de3          	bne	a5,a4,80001e72 <allocproc+0x66>
  p->tickets = 1;
    80001e7c:	4785                	li	a5,1
    80001e7e:	1ef4aa23          	sw	a5,500(s1)
  p->arrivalTime = ticks;
    80001e82:	00009797          	auipc	a5,0x9
    80001e86:	5d27a783          	lw	a5,1490(a5) # 8000b454 <ticks>
    80001e8a:	1ef4ac23          	sw	a5,504(s1)
  p->priority = 0;
    80001e8e:	1e04ae23          	sw	zero,508(s1)
  p->ticks_used = 0;
    80001e92:	2004a023          	sw	zero,512(s1)
  p->total_ticks = 0;
    80001e96:	2004a223          	sw	zero,516(s1)
  p->is_userinit = 0;
    80001e9a:	3404a623          	sw	zero,844(s1)
  p->queue_num = 0;
    80001e9e:	2004a423          	sw	zero,520(s1)
  p->queue_ticks = 0;
    80001ea2:	2004a623          	sw	zero,524(s1)
  p->entry_time = ticks;
    80001ea6:	20f4a823          	sw	a5,528(s1)
  p->pagetable = proc_pagetable(p);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	e02080e7          	jalr	-510(ra) # 80001cae <proc_pagetable>
    80001eb4:	892a                	mv	s2,a0
    80001eb6:	22a4b423          	sd	a0,552(s1)
  if (p->pagetable == 0)
    80001eba:	c52d                	beqz	a0,80001f24 <allocproc+0x118>
  memset(&p->context, 0, sizeof(p->context));
    80001ebc:	07000613          	li	a2,112
    80001ec0:	4581                	li	a1,0
    80001ec2:	23848513          	addi	a0,s1,568
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	e6e080e7          	jalr	-402(ra) # 80000d34 <memset>
  p->context.ra = (uint64)forkret;
    80001ece:	00000797          	auipc	a5,0x0
    80001ed2:	d5478793          	addi	a5,a5,-684 # 80001c22 <forkret>
    80001ed6:	22f4bc23          	sd	a5,568(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001eda:	2184b783          	ld	a5,536(s1)
    80001ede:	6705                	lui	a4,0x1
    80001ee0:	97ba                	add	a5,a5,a4
    80001ee2:	24f4b023          	sd	a5,576(s1)
  p->rtime = 0;
    80001ee6:	3404a023          	sw	zero,832(s1)
  p->etime = 0;
    80001eea:	3404a423          	sw	zero,840(s1)
  p->ctime = ticks;
    80001eee:	00009797          	auipc	a5,0x9
    80001ef2:	5667a783          	lw	a5,1382(a5) # 8000b454 <ticks>
    80001ef6:	34f4a223          	sw	a5,836(s1)
  p->ticks = 0;
    80001efa:	0c04a023          	sw	zero,192(s1)
}
    80001efe:	8526                	mv	a0,s1
    80001f00:	60e2                	ld	ra,24(sp)
    80001f02:	6442                	ld	s0,16(sp)
    80001f04:	64a2                	ld	s1,8(sp)
    80001f06:	6902                	ld	s2,0(sp)
    80001f08:	6105                	addi	sp,sp,32
    80001f0a:	8082                	ret
    freeproc(p);
    80001f0c:	8526                	mv	a0,s1
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	e8e080e7          	jalr	-370(ra) # 80001d9c <freeproc>
    release(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	dd4080e7          	jalr	-556(ra) # 80000cec <release>
    return 0;
    80001f20:	84ca                	mv	s1,s2
    80001f22:	bff1                	j	80001efe <allocproc+0xf2>
    freeproc(p);
    80001f24:	8526                	mv	a0,s1
    80001f26:	00000097          	auipc	ra,0x0
    80001f2a:	e76080e7          	jalr	-394(ra) # 80001d9c <freeproc>
    release(&p->lock);
    80001f2e:	8526                	mv	a0,s1
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	dbc080e7          	jalr	-580(ra) # 80000cec <release>
    return 0;
    80001f38:	84ca                	mv	s1,s2
    80001f3a:	b7d1                	j	80001efe <allocproc+0xf2>

0000000080001f3c <userinit>:
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f46:	00000097          	auipc	ra,0x0
    80001f4a:	ec6080e7          	jalr	-314(ra) # 80001e0c <allocproc>
    80001f4e:	84aa                	mv	s1,a0
  initproc = p;
    80001f50:	00009797          	auipc	a5,0x9
    80001f54:	4ea7bc23          	sd	a0,1272(a5) # 8000b448 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001f58:	03400613          	li	a2,52
    80001f5c:	00009597          	auipc	a1,0x9
    80001f60:	45458593          	addi	a1,a1,1108 # 8000b3b0 <initcode>
    80001f64:	22853503          	ld	a0,552(a0)
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	458080e7          	jalr	1112(ra) # 800013c0 <uvmfirst>
  p->sz = PGSIZE;
    80001f70:	6785                	lui	a5,0x1
    80001f72:	22f4b023          	sd	a5,544(s1)
  p->trapframe->epc = 0;     // user program counter
    80001f76:	2304b703          	ld	a4,560(s1)
    80001f7a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001f7e:	2304b703          	ld	a4,560(s1)
    80001f82:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001f84:	4641                	li	a2,16
    80001f86:	00006597          	auipc	a1,0x6
    80001f8a:	25a58593          	addi	a1,a1,602 # 800081e0 <etext+0x1e0>
    80001f8e:	33048513          	addi	a0,s1,816
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	ee4080e7          	jalr	-284(ra) # 80000e76 <safestrcpy>
  p->cwd = namei("/");
    80001f9a:	00006517          	auipc	a0,0x6
    80001f9e:	25650513          	addi	a0,a0,598 # 800081f0 <etext+0x1f0>
    80001fa2:	00003097          	auipc	ra,0x3
    80001fa6:	864080e7          	jalr	-1948(ra) # 80004806 <namei>
    80001faa:	32a4b423          	sd	a0,808(s1)
  p->state = RUNNABLE;
    80001fae:	478d                	li	a5,3
    80001fb0:	cc9c                	sw	a5,24(s1)
  p->is_userinit = 1;
    80001fb2:	4785                	li	a5,1
    80001fb4:	34f4a623          	sw	a5,844(s1)
  release(&p->lock);
    80001fb8:	8526                	mv	a0,s1
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	d32080e7          	jalr	-718(ra) # 80000cec <release>
}
    80001fc2:	60e2                	ld	ra,24(sp)
    80001fc4:	6442                	ld	s0,16(sp)
    80001fc6:	64a2                	ld	s1,8(sp)
    80001fc8:	6105                	addi	sp,sp,32
    80001fca:	8082                	ret

0000000080001fcc <growproc>:
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	e04a                	sd	s2,0(sp)
    80001fd6:	1000                	addi	s0,sp,32
    80001fd8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001fda:	00000097          	auipc	ra,0x0
    80001fde:	c10080e7          	jalr	-1008(ra) # 80001bea <myproc>
    80001fe2:	84aa                	mv	s1,a0
  sz = p->sz;
    80001fe4:	22053583          	ld	a1,544(a0)
  if (n > 0)
    80001fe8:	01204d63          	bgtz	s2,80002002 <growproc+0x36>
  else if (n < 0)
    80001fec:	02094863          	bltz	s2,8000201c <growproc+0x50>
  p->sz = sz;
    80001ff0:	22b4b023          	sd	a1,544(s1)
  return 0;
    80001ff4:	4501                	li	a0,0
}
    80001ff6:	60e2                	ld	ra,24(sp)
    80001ff8:	6442                	ld	s0,16(sp)
    80001ffa:	64a2                	ld	s1,8(sp)
    80001ffc:	6902                	ld	s2,0(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002002:	4691                	li	a3,4
    80002004:	00b90633          	add	a2,s2,a1
    80002008:	22853503          	ld	a0,552(a0)
    8000200c:	fffff097          	auipc	ra,0xfffff
    80002010:	46e080e7          	jalr	1134(ra) # 8000147a <uvmalloc>
    80002014:	85aa                	mv	a1,a0
    80002016:	fd69                	bnez	a0,80001ff0 <growproc+0x24>
      return -1;
    80002018:	557d                	li	a0,-1
    8000201a:	bff1                	j	80001ff6 <growproc+0x2a>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000201c:	00b90633          	add	a2,s2,a1
    80002020:	22853503          	ld	a0,552(a0)
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	40e080e7          	jalr	1038(ra) # 80001432 <uvmdealloc>
    8000202c:	85aa                	mv	a1,a0
    8000202e:	b7c9                	j	80001ff0 <growproc+0x24>

0000000080002030 <fork>:
{
    80002030:	7139                	addi	sp,sp,-64
    80002032:	fc06                	sd	ra,56(sp)
    80002034:	f822                	sd	s0,48(sp)
    80002036:	f04a                	sd	s2,32(sp)
    80002038:	e456                	sd	s5,8(sp)
    8000203a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000203c:	00000097          	auipc	ra,0x0
    80002040:	bae080e7          	jalr	-1106(ra) # 80001bea <myproc>
    80002044:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80002046:	00000097          	auipc	ra,0x0
    8000204a:	dc6080e7          	jalr	-570(ra) # 80001e0c <allocproc>
    8000204e:	12050b63          	beqz	a0,80002184 <fork+0x154>
    80002052:	ec4e                	sd	s3,24(sp)
    80002054:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002056:	220ab603          	ld	a2,544(s5)
    8000205a:	22853583          	ld	a1,552(a0)
    8000205e:	228ab503          	ld	a0,552(s5)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	57c080e7          	jalr	1404(ra) # 800015de <uvmcopy>
    8000206a:	06054463          	bltz	a0,800020d2 <fork+0xa2>
    8000206e:	f426                	sd	s1,40(sp)
    80002070:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80002072:	220ab783          	ld	a5,544(s5)
    80002076:	22f9b023          	sd	a5,544(s3)
  *(np->trapframe) = *(p->trapframe);
    8000207a:	230ab683          	ld	a3,560(s5)
    8000207e:	87b6                	mv	a5,a3
    80002080:	2309b703          	ld	a4,560(s3)
    80002084:	12068693          	addi	a3,a3,288
    80002088:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000208c:	6788                	ld	a0,8(a5)
    8000208e:	6b8c                	ld	a1,16(a5)
    80002090:	6f90                	ld	a2,24(a5)
    80002092:	01073023          	sd	a6,0(a4)
    80002096:	e708                	sd	a0,8(a4)
    80002098:	eb0c                	sd	a1,16(a4)
    8000209a:	ef10                	sd	a2,24(a4)
    8000209c:	02078793          	addi	a5,a5,32
    800020a0:	02070713          	addi	a4,a4,32
    800020a4:	fed792e3          	bne	a5,a3,80002088 <fork+0x58>
  np->tickets = p->tickets;
    800020a8:	1f4aa783          	lw	a5,500(s5)
    800020ac:	1ef9aa23          	sw	a5,500(s3)
  np->arrivalTime = ticks;
    800020b0:	00009797          	auipc	a5,0x9
    800020b4:	3a47a783          	lw	a5,932(a5) # 8000b454 <ticks>
    800020b8:	1ef9ac23          	sw	a5,504(s3)
  np->trapframe->a0 = 0;
    800020bc:	2309b783          	ld	a5,560(s3)
    800020c0:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800020c4:	2a8a8493          	addi	s1,s5,680
    800020c8:	2a898913          	addi	s2,s3,680
    800020cc:	328a8a13          	addi	s4,s5,808
    800020d0:	a015                	j	800020f4 <fork+0xc4>
    freeproc(np);
    800020d2:	854e                	mv	a0,s3
    800020d4:	00000097          	auipc	ra,0x0
    800020d8:	cc8080e7          	jalr	-824(ra) # 80001d9c <freeproc>
    release(&np->lock);
    800020dc:	854e                	mv	a0,s3
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	c0e080e7          	jalr	-1010(ra) # 80000cec <release>
    return -1;
    800020e6:	597d                	li	s2,-1
    800020e8:	69e2                	ld	s3,24(sp)
    800020ea:	a071                	j	80002176 <fork+0x146>
  for (i = 0; i < NOFILE; i++)
    800020ec:	04a1                	addi	s1,s1,8
    800020ee:	0921                	addi	s2,s2,8
    800020f0:	01448b63          	beq	s1,s4,80002106 <fork+0xd6>
    if (p->ofile[i])
    800020f4:	6088                	ld	a0,0(s1)
    800020f6:	d97d                	beqz	a0,800020ec <fork+0xbc>
      np->ofile[i] = filedup(p->ofile[i]);
    800020f8:	00003097          	auipc	ra,0x3
    800020fc:	d86080e7          	jalr	-634(ra) # 80004e7e <filedup>
    80002100:	00a93023          	sd	a0,0(s2)
    80002104:	b7e5                	j	800020ec <fork+0xbc>
  np->cwd = idup(p->cwd);
    80002106:	328ab503          	ld	a0,808(s5)
    8000210a:	00002097          	auipc	ra,0x2
    8000210e:	ef0080e7          	jalr	-272(ra) # 80003ffa <idup>
    80002112:	32a9b423          	sd	a0,808(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002116:	4641                	li	a2,16
    80002118:	330a8593          	addi	a1,s5,816
    8000211c:	33098513          	addi	a0,s3,816
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	d56080e7          	jalr	-682(ra) # 80000e76 <safestrcpy>
  pid = np->pid;
    80002128:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000212c:	854e                	mv	a0,s3
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	bbe080e7          	jalr	-1090(ra) # 80000cec <release>
  acquire(&wait_lock);
    80002136:	00011497          	auipc	s1,0x11
    8000213a:	5b248493          	addi	s1,s1,1458 # 800136e8 <wait_lock>
    8000213e:	8526                	mv	a0,s1
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	af8080e7          	jalr	-1288(ra) # 80000c38 <acquire>
  np->parent = p;
    80002148:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000214c:	8526                	mv	a0,s1
    8000214e:	fffff097          	auipc	ra,0xfffff
    80002152:	b9e080e7          	jalr	-1122(ra) # 80000cec <release>
  acquire(&np->lock);
    80002156:	854e                	mv	a0,s3
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	ae0080e7          	jalr	-1312(ra) # 80000c38 <acquire>
  np->state = RUNNABLE;
    80002160:	478d                	li	a5,3
    80002162:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002166:	854e                	mv	a0,s3
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	b84080e7          	jalr	-1148(ra) # 80000cec <release>
  return pid;
    80002170:	74a2                	ld	s1,40(sp)
    80002172:	69e2                	ld	s3,24(sp)
    80002174:	6a42                	ld	s4,16(sp)
}
    80002176:	854a                	mv	a0,s2
    80002178:	70e2                	ld	ra,56(sp)
    8000217a:	7442                	ld	s0,48(sp)
    8000217c:	7902                	ld	s2,32(sp)
    8000217e:	6aa2                	ld	s5,8(sp)
    80002180:	6121                	addi	sp,sp,64
    80002182:	8082                	ret
    return -1;
    80002184:	597d                	li	s2,-1
    80002186:	bfc5                	j	80002176 <fork+0x146>

0000000080002188 <lbs>:
{
    80002188:	7139                	addi	sp,sp,-64
    8000218a:	fc06                	sd	ra,56(sp)
    8000218c:	f822                	sd	s0,48(sp)
    8000218e:	f426                	sd	s1,40(sp)
    80002190:	f04a                	sd	s2,32(sp)
    80002192:	ec4e                	sd	s3,24(sp)
    80002194:	e852                	sd	s4,16(sp)
    80002196:	e456                	sd	s5,8(sp)
    80002198:	0080                	addi	s0,sp,64
    8000219a:	8aae                	mv	s5,a1
  int total_tickets = 0, current_ticket = 0, winning_ticket = 0;
    8000219c:	4a01                	li	s4,0
  for (p = proc; p < &proc[NPROC]; p++)
    8000219e:	00012497          	auipc	s1,0x12
    800021a2:	2a248493          	addi	s1,s1,674 # 80014440 <proc>
    if (p->state == RUNNABLE)
    800021a6:	498d                	li	s3,3
  for (p = proc; p < &proc[NPROC]; p++)
    800021a8:	0001f917          	auipc	s2,0x1f
    800021ac:	69890913          	addi	s2,s2,1688 # 80021840 <tickslock>
    800021b0:	a811                	j	800021c4 <lbs+0x3c>
    release(&p->lock);
    800021b2:	8526                	mv	a0,s1
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	b38080e7          	jalr	-1224(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800021bc:	35048493          	addi	s1,s1,848
    800021c0:	01248f63          	beq	s1,s2,800021de <lbs+0x56>
    acquire(&p->lock);
    800021c4:	8526                	mv	a0,s1
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	a72080e7          	jalr	-1422(ra) # 80000c38 <acquire>
    if (p->state == RUNNABLE)
    800021ce:	4c9c                	lw	a5,24(s1)
    800021d0:	ff3791e3          	bne	a5,s3,800021b2 <lbs+0x2a>
      total_tickets += p->tickets;
    800021d4:	1f44a783          	lw	a5,500(s1)
    800021d8:	01478a3b          	addw	s4,a5,s4
    800021dc:	bfd9                	j	800021b2 <lbs+0x2a>
  if (total_tickets == 0)
    800021de:	000a1b63          	bnez	s4,800021f4 <lbs+0x6c>
}
    800021e2:	70e2                	ld	ra,56(sp)
    800021e4:	7442                	ld	s0,48(sp)
    800021e6:	74a2                	ld	s1,40(sp)
    800021e8:	7902                	ld	s2,32(sp)
    800021ea:	69e2                	ld	s3,24(sp)
    800021ec:	6a42                	ld	s4,16(sp)
    800021ee:	6aa2                	ld	s5,8(sp)
    800021f0:	6121                	addi	sp,sp,64
    800021f2:	8082                	ret
    800021f4:	e05a                	sd	s6,0(sp)
    800021f6:	8792                	mv	a5,tp
  seed = (seed * 1103515245 + 12345) % 4294967296;
    800021f8:	41c65737          	lui	a4,0x41c65
    800021fc:	e6d7071b          	addiw	a4,a4,-403 # 41c64e6d <_entry-0x3e39b193>
    80002200:	02e787bb          	mulw	a5,a5,a4
    80002204:	670d                	lui	a4,0x3
    80002206:	0397071b          	addiw	a4,a4,57 # 3039 <_entry-0x7fffcfc7>
    8000220a:	9fb9                	addw	a5,a5,a4
  seed ^= seed << 16;
    8000220c:	0107971b          	slliw	a4,a5,0x10
    80002210:	8fb9                	xor	a5,a5,a4
  seed ^= seed >> 5;
    80002212:	4057db1b          	sraiw	s6,a5,0x5
    80002216:	00fb4b33          	xor	s6,s6,a5
  winning_ticket = seed % total_tickets;
    8000221a:	034b6b3b          	remw	s6,s6,s4
  for (p = proc; p < &proc[NPROC]; p++)
    8000221e:	00012917          	auipc	s2,0x12
    80002222:	22290913          	addi	s2,s2,546 # 80014440 <proc>
    if (p->state == RUNNABLE)
    80002226:	448d                	li	s1,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002228:	0001f997          	auipc	s3,0x1f
    8000222c:	61898993          	addi	s3,s3,1560 # 80021840 <tickslock>
    80002230:	a811                	j	80002244 <lbs+0xbc>
    release(&p->lock);
    80002232:	854a                	mv	a0,s2
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	ab8080e7          	jalr	-1352(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000223c:	35090913          	addi	s2,s2,848
    80002240:	05390063          	beq	s2,s3,80002280 <lbs+0xf8>
    acquire(&p->lock);
    80002244:	854a                	mv	a0,s2
    80002246:	fffff097          	auipc	ra,0xfffff
    8000224a:	9f2080e7          	jalr	-1550(ra) # 80000c38 <acquire>
    if (p->state == RUNNABLE)
    8000224e:	01892783          	lw	a5,24(s2)
    80002252:	fe9790e3          	bne	a5,s1,80002232 <lbs+0xaa>
      current_ticket -= p->tickets;
    80002256:	1f492783          	lw	a5,500(s2)
    8000225a:	40fa0a3b          	subw	s4,s4,a5
      if (current_ticket <= winning_ticket)
    8000225e:	fd4b4ae3          	blt	s6,s4,80002232 <lbs+0xaa>
        release(&p->lock);
    80002262:	854a                	mv	a0,s2
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	a88080e7          	jalr	-1400(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000226c:	00012497          	auipc	s1,0x12
    80002270:	1d448493          	addi	s1,s1,468 # 80014440 <proc>
      if (p->state == RUNNABLE && p->tickets == selected_proc->tickets && p->arrivalTime < selected_proc->arrivalTime)
    80002274:	4a0d                	li	s4,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002276:	0001f997          	auipc	s3,0x1f
    8000227a:	5ca98993          	addi	s3,s3,1482 # 80021840 <tickslock>
    8000227e:	a821                	j	80002296 <lbs+0x10e>
    80002280:	6b02                	ld	s6,0(sp)
    80002282:	b785                	j	800021e2 <lbs+0x5a>
      release(&p->lock);
    80002284:	8526                	mv	a0,s1
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	a66080e7          	jalr	-1434(ra) # 80000cec <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000228e:	35048493          	addi	s1,s1,848
    80002292:	03348863          	beq	s1,s3,800022c2 <lbs+0x13a>
      acquire(&p->lock);
    80002296:	8526                	mv	a0,s1
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	9a0080e7          	jalr	-1632(ra) # 80000c38 <acquire>
      if (p->state == RUNNABLE && p->tickets == selected_proc->tickets && p->arrivalTime < selected_proc->arrivalTime)
    800022a0:	4c9c                	lw	a5,24(s1)
    800022a2:	ff4791e3          	bne	a5,s4,80002284 <lbs+0xfc>
    800022a6:	1f44a703          	lw	a4,500(s1)
    800022aa:	1f492783          	lw	a5,500(s2)
    800022ae:	fcf71be3          	bne	a4,a5,80002284 <lbs+0xfc>
    800022b2:	1f84a703          	lw	a4,504(s1)
    800022b6:	1f892783          	lw	a5,504(s2)
    800022ba:	fcf755e3          	bge	a4,a5,80002284 <lbs+0xfc>
        selected_proc = p;
    800022be:	8926                	mv	s2,s1
    800022c0:	b7d1                	j	80002284 <lbs+0xfc>
    acquire(&selected_proc->lock);
    800022c2:	84ca                	mv	s1,s2
    800022c4:	854a                	mv	a0,s2
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	972080e7          	jalr	-1678(ra) # 80000c38 <acquire>
    if (selected_proc->state == RUNNABLE)
    800022ce:	01892703          	lw	a4,24(s2)
    800022d2:	478d                	li	a5,3
    800022d4:	00f70963          	beq	a4,a5,800022e6 <lbs+0x15e>
    release(&selected_proc->lock);
    800022d8:	8526                	mv	a0,s1
    800022da:	fffff097          	auipc	ra,0xfffff
    800022de:	a12080e7          	jalr	-1518(ra) # 80000cec <release>
    800022e2:	6b02                	ld	s6,0(sp)
    800022e4:	bdfd                	j	800021e2 <lbs+0x5a>
      selected_proc->state = RUNNING;
    800022e6:	4791                	li	a5,4
    800022e8:	00f92c23          	sw	a5,24(s2)
      c->proc = selected_proc;
    800022ec:	012ab023          	sd	s2,0(s5)
      swtch(&c->context, &selected_proc->context);
    800022f0:	23890593          	addi	a1,s2,568
    800022f4:	008a8513          	addi	a0,s5,8
    800022f8:	00001097          	auipc	ra,0x1
    800022fc:	aaa080e7          	jalr	-1366(ra) # 80002da2 <swtch>
      c->proc = 0;
    80002300:	000ab023          	sd	zero,0(s5)
    80002304:	bfd1                	j	800022d8 <lbs+0x150>

0000000080002306 <mlfq2>:
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	e04a                	sd	s2,0(sp)
    8000230e:	1000                	addi	s0,sp,32
    80002310:	892e                	mv	s2,a1
  p = select_next_process();
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	5a6080e7          	jalr	1446(ra) # 800018b8 <select_next_process>
  if (p != 0)
    8000231a:	c10d                	beqz	a0,8000233c <mlfq2+0x36>
    8000231c:	e426                	sd	s1,8(sp)
    8000231e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	918080e7          	jalr	-1768(ra) # 80000c38 <acquire>
    if (p->state == RUNNABLE)
    80002328:	4c98                	lw	a4,24(s1)
    8000232a:	478d                	li	a5,3
    8000232c:	00f70d63          	beq	a4,a5,80002346 <mlfq2+0x40>
    release(&p->lock);
    80002330:	8526                	mv	a0,s1
    80002332:	fffff097          	auipc	ra,0xfffff
    80002336:	9ba080e7          	jalr	-1606(ra) # 80000cec <release>
    8000233a:	64a2                	ld	s1,8(sp)
}
    8000233c:	60e2                	ld	ra,24(sp)
    8000233e:	6442                	ld	s0,16(sp)
    80002340:	6902                	ld	s2,0(sp)
    80002342:	6105                	addi	sp,sp,32
    80002344:	8082                	ret
      p->state = RUNNING;
    80002346:	4791                	li	a5,4
    80002348:	cc9c                	sw	a5,24(s1)
      p->ticks_used++;
    8000234a:	2004a783          	lw	a5,512(s1)
    8000234e:	2785                	addiw	a5,a5,1
    80002350:	20f4a023          	sw	a5,512(s1)
      p->total_ticks++;
    80002354:	2044a783          	lw	a5,516(s1)
    80002358:	2785                	addiw	a5,a5,1
    8000235a:	20f4a223          	sw	a5,516(s1)
      remove_from_queue(p->priority, p->pid);
    8000235e:	588c                	lw	a1,48(s1)
    80002360:	1fc4a503          	lw	a0,508(s1)
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	5a8080e7          	jalr	1448(ra) # 8000190c <remove_from_queue>
      c->proc = p;
    8000236c:	00993023          	sd	s1,0(s2)
      swtch(&c->context, &p->context);
    80002370:	23848593          	addi	a1,s1,568
    80002374:	00890513          	addi	a0,s2,8
    80002378:	00001097          	auipc	ra,0x1
    8000237c:	a2a080e7          	jalr	-1494(ra) # 80002da2 <swtch>
      c->proc = 0;
    80002380:	00093023          	sd	zero,0(s2)
      if (p->state == RUNNABLE)
    80002384:	4c98                	lw	a4,24(s1)
    80002386:	478d                	li	a5,3
    80002388:	faf714e3          	bne	a4,a5,80002330 <mlfq2+0x2a>
        if (p->ticks_used >= time_slices[p->priority])
    8000238c:	1fc4a503          	lw	a0,508(s1)
    80002390:	00251713          	slli	a4,a0,0x2
    80002394:	00009797          	auipc	a5,0x9
    80002398:	01c78793          	addi	a5,a5,28 # 8000b3b0 <initcode>
    8000239c:	97ba                	add	a5,a5,a4
    8000239e:	2004a703          	lw	a4,512(s1)
    800023a2:	5f9c                	lw	a5,56(a5)
    800023a4:	02f74763          	blt	a4,a5,800023d2 <mlfq2+0xcc>
          p->ticks_used = 0;
    800023a8:	2004a023          	sw	zero,512(s1)
          if (p->priority < 3)
    800023ac:	4789                	li	a5,2
    800023ae:	00a7cc63          	blt	a5,a0,800023c6 <mlfq2+0xc0>
            p->priority++;
    800023b2:	2505                	addiw	a0,a0,1
    800023b4:	1ea4ae23          	sw	a0,508(s1)
            add_to_queue(p->priority, p);
    800023b8:	85a6                	mv	a1,s1
    800023ba:	2501                	sext.w	a0,a0
    800023bc:	fffff097          	auipc	ra,0xfffff
    800023c0:	5d4080e7          	jalr	1492(ra) # 80001990 <add_to_queue>
    800023c4:	b7b5                	j	80002330 <mlfq2+0x2a>
            add_to_queue(p->priority, p);
    800023c6:	85a6                	mv	a1,s1
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	5c8080e7          	jalr	1480(ra) # 80001990 <add_to_queue>
    800023d0:	b785                	j	80002330 <mlfq2+0x2a>
            add_to_queue(p->priority, p);
    800023d2:	85a6                	mv	a1,s1
    800023d4:	fffff097          	auipc	ra,0xfffff
    800023d8:	5bc080e7          	jalr	1468(ra) # 80001990 <add_to_queue>
    800023dc:	bf91                	j	80002330 <mlfq2+0x2a>

00000000800023de <scheduler>:
{
    800023de:	7139                	addi	sp,sp,-64
    800023e0:	fc06                	sd	ra,56(sp)
    800023e2:	f822                	sd	s0,48(sp)
    800023e4:	f426                	sd	s1,40(sp)
    800023e6:	f04a                	sd	s2,32(sp)
    800023e8:	ec4e                	sd	s3,24(sp)
    800023ea:	e852                	sd	s4,16(sp)
    800023ec:	e456                	sd	s5,8(sp)
    800023ee:	e05a                	sd	s6,0(sp)
    800023f0:	0080                	addi	s0,sp,64
  printf("scheduler = %d\n", SCHEDULER);
    800023f2:	4581                	li	a1,0
    800023f4:	00006517          	auipc	a0,0x6
    800023f8:	e0450513          	addi	a0,a0,-508 # 800081f8 <etext+0x1f8>
    800023fc:	ffffe097          	auipc	ra,0xffffe
    80002400:	1ae080e7          	jalr	430(ra) # 800005aa <printf>
    80002404:	8792                	mv	a5,tp
  int id = r_tp();
    80002406:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002408:	00779a93          	slli	s5,a5,0x7
    8000240c:	00011717          	auipc	a4,0x11
    80002410:	2b470713          	addi	a4,a4,692 # 800136c0 <queue_count>
    80002414:	9756                	add	a4,a4,s5
    80002416:	04073023          	sd	zero,64(a4)
          swtch(&c->context, &p->context);
    8000241a:	00011717          	auipc	a4,0x11
    8000241e:	2ee70713          	addi	a4,a4,750 # 80013708 <cpus+0x8>
    80002422:	9aba                	add	s5,s5,a4
        if (p->state == RUNNABLE)
    80002424:	498d                	li	s3,3
          p->state = RUNNING;
    80002426:	4b11                	li	s6,4
          c->proc = p;
    80002428:	079e                	slli	a5,a5,0x7
    8000242a:	00011a17          	auipc	s4,0x11
    8000242e:	296a0a13          	addi	s4,s4,662 # 800136c0 <queue_count>
    80002432:	9a3e                	add	s4,s4,a5
      for (p = proc; p < &proc[NPROC]; p++)
    80002434:	0001f917          	auipc	s2,0x1f
    80002438:	40c90913          	addi	s2,s2,1036 # 80021840 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000243c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002440:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002444:	10079073          	csrw	sstatus,a5
    80002448:	00012497          	auipc	s1,0x12
    8000244c:	ff848493          	addi	s1,s1,-8 # 80014440 <proc>
    80002450:	a811                	j	80002464 <scheduler+0x86>
        release(&p->lock);
    80002452:	8526                	mv	a0,s1
    80002454:	fffff097          	auipc	ra,0xfffff
    80002458:	898080e7          	jalr	-1896(ra) # 80000cec <release>
      for (p = proc; p < &proc[NPROC]; p++)
    8000245c:	35048493          	addi	s1,s1,848
    80002460:	fd248ee3          	beq	s1,s2,8000243c <scheduler+0x5e>
        acquire(&p->lock);
    80002464:	8526                	mv	a0,s1
    80002466:	ffffe097          	auipc	ra,0xffffe
    8000246a:	7d2080e7          	jalr	2002(ra) # 80000c38 <acquire>
        if (p->state == RUNNABLE)
    8000246e:	4c9c                	lw	a5,24(s1)
    80002470:	ff3791e3          	bne	a5,s3,80002452 <scheduler+0x74>
          p->state = RUNNING;
    80002474:	0164ac23          	sw	s6,24(s1)
          c->proc = p;
    80002478:	049a3023          	sd	s1,64(s4)
          swtch(&c->context, &p->context);
    8000247c:	23848593          	addi	a1,s1,568
    80002480:	8556                	mv	a0,s5
    80002482:	00001097          	auipc	ra,0x1
    80002486:	920080e7          	jalr	-1760(ra) # 80002da2 <swtch>
          c->proc = 0;
    8000248a:	040a3023          	sd	zero,64(s4)
    8000248e:	b7d1                	j	80002452 <scheduler+0x74>

0000000080002490 <sched>:
{
    80002490:	7179                	addi	sp,sp,-48
    80002492:	f406                	sd	ra,40(sp)
    80002494:	f022                	sd	s0,32(sp)
    80002496:	ec26                	sd	s1,24(sp)
    80002498:	e84a                	sd	s2,16(sp)
    8000249a:	e44e                	sd	s3,8(sp)
    8000249c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	74c080e7          	jalr	1868(ra) # 80001bea <myproc>
    800024a6:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	716080e7          	jalr	1814(ra) # 80000bbe <holding>
    800024b0:	c93d                	beqz	a0,80002526 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024b2:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800024b4:	2781                	sext.w	a5,a5
    800024b6:	079e                	slli	a5,a5,0x7
    800024b8:	00011717          	auipc	a4,0x11
    800024bc:	20870713          	addi	a4,a4,520 # 800136c0 <queue_count>
    800024c0:	97ba                	add	a5,a5,a4
    800024c2:	0b87a703          	lw	a4,184(a5)
    800024c6:	4785                	li	a5,1
    800024c8:	06f71763          	bne	a4,a5,80002536 <sched+0xa6>
  if (p->state == RUNNING)
    800024cc:	4c98                	lw	a4,24(s1)
    800024ce:	4791                	li	a5,4
    800024d0:	06f70b63          	beq	a4,a5,80002546 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800024d8:	8b89                	andi	a5,a5,2
  if (intr_get())
    800024da:	efb5                	bnez	a5,80002556 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024dc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800024de:	00011917          	auipc	s2,0x11
    800024e2:	1e290913          	addi	s2,s2,482 # 800136c0 <queue_count>
    800024e6:	2781                	sext.w	a5,a5
    800024e8:	079e                	slli	a5,a5,0x7
    800024ea:	97ca                	add	a5,a5,s2
    800024ec:	0bc7a983          	lw	s3,188(a5)
    800024f0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800024f2:	2781                	sext.w	a5,a5
    800024f4:	079e                	slli	a5,a5,0x7
    800024f6:	00011597          	auipc	a1,0x11
    800024fa:	21258593          	addi	a1,a1,530 # 80013708 <cpus+0x8>
    800024fe:	95be                	add	a1,a1,a5
    80002500:	23848513          	addi	a0,s1,568
    80002504:	00001097          	auipc	ra,0x1
    80002508:	89e080e7          	jalr	-1890(ra) # 80002da2 <swtch>
    8000250c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000250e:	2781                	sext.w	a5,a5
    80002510:	079e                	slli	a5,a5,0x7
    80002512:	993e                	add	s2,s2,a5
    80002514:	0b392e23          	sw	s3,188(s2)
}
    80002518:	70a2                	ld	ra,40(sp)
    8000251a:	7402                	ld	s0,32(sp)
    8000251c:	64e2                	ld	s1,24(sp)
    8000251e:	6942                	ld	s2,16(sp)
    80002520:	69a2                	ld	s3,8(sp)
    80002522:	6145                	addi	sp,sp,48
    80002524:	8082                	ret
    panic("sched p->lock");
    80002526:	00006517          	auipc	a0,0x6
    8000252a:	ce250513          	addi	a0,a0,-798 # 80008208 <etext+0x208>
    8000252e:	ffffe097          	auipc	ra,0xffffe
    80002532:	032080e7          	jalr	50(ra) # 80000560 <panic>
    panic("sched locks");
    80002536:	00006517          	auipc	a0,0x6
    8000253a:	ce250513          	addi	a0,a0,-798 # 80008218 <etext+0x218>
    8000253e:	ffffe097          	auipc	ra,0xffffe
    80002542:	022080e7          	jalr	34(ra) # 80000560 <panic>
    panic("sched running");
    80002546:	00006517          	auipc	a0,0x6
    8000254a:	ce250513          	addi	a0,a0,-798 # 80008228 <etext+0x228>
    8000254e:	ffffe097          	auipc	ra,0xffffe
    80002552:	012080e7          	jalr	18(ra) # 80000560 <panic>
    panic("sched interruptible");
    80002556:	00006517          	auipc	a0,0x6
    8000255a:	ce250513          	addi	a0,a0,-798 # 80008238 <etext+0x238>
    8000255e:	ffffe097          	auipc	ra,0xffffe
    80002562:	002080e7          	jalr	2(ra) # 80000560 <panic>

0000000080002566 <yield>:
{
    80002566:	1101                	addi	sp,sp,-32
    80002568:	ec06                	sd	ra,24(sp)
    8000256a:	e822                	sd	s0,16(sp)
    8000256c:	e426                	sd	s1,8(sp)
    8000256e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002570:	fffff097          	auipc	ra,0xfffff
    80002574:	67a080e7          	jalr	1658(ra) # 80001bea <myproc>
    80002578:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000257a:	ffffe097          	auipc	ra,0xffffe
    8000257e:	6be080e7          	jalr	1726(ra) # 80000c38 <acquire>
  if (proc->ticks_used >= (1 << proc->priority))
    80002582:	00012797          	auipc	a5,0x12
    80002586:	ebe78793          	addi	a5,a5,-322 # 80014440 <proc>
    8000258a:	1fc7a703          	lw	a4,508(a5)
    8000258e:	2007a683          	lw	a3,512(a5)
    80002592:	4785                	li	a5,1
    80002594:	00e797bb          	sllw	a5,a5,a4
    80002598:	00f6ce63          	blt	a3,a5,800025b4 <yield+0x4e>
    proc->ticks_used = 0;
    8000259c:	00012797          	auipc	a5,0x12
    800025a0:	0a07a223          	sw	zero,164(a5) # 80014640 <proc+0x200>
    if (proc->priority < NQUEUE - 1) // Demote to lower queue if possible
    800025a4:	4789                	li	a5,2
    800025a6:	00e7c763          	blt	a5,a4,800025b4 <yield+0x4e>
      proc->priority++;
    800025aa:	2705                	addiw	a4,a4,1
    800025ac:	00012797          	auipc	a5,0x12
    800025b0:	08e7a823          	sw	a4,144(a5) # 8001463c <proc+0x1fc>
  p->state = RUNNABLE;
    800025b4:	478d                	li	a5,3
    800025b6:	cc9c                	sw	a5,24(s1)
  sched();
    800025b8:	00000097          	auipc	ra,0x0
    800025bc:	ed8080e7          	jalr	-296(ra) # 80002490 <sched>
  release(&p->lock);
    800025c0:	8526                	mv	a0,s1
    800025c2:	ffffe097          	auipc	ra,0xffffe
    800025c6:	72a080e7          	jalr	1834(ra) # 80000cec <release>
}
    800025ca:	60e2                	ld	ra,24(sp)
    800025cc:	6442                	ld	s0,16(sp)
    800025ce:	64a2                	ld	s1,8(sp)
    800025d0:	6105                	addi	sp,sp,32
    800025d2:	8082                	ret

00000000800025d4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800025d4:	7179                	addi	sp,sp,-48
    800025d6:	f406                	sd	ra,40(sp)
    800025d8:	f022                	sd	s0,32(sp)
    800025da:	ec26                	sd	s1,24(sp)
    800025dc:	e84a                	sd	s2,16(sp)
    800025de:	e44e                	sd	s3,8(sp)
    800025e0:	1800                	addi	s0,sp,48
    800025e2:	89aa                	mv	s3,a0
    800025e4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800025e6:	fffff097          	auipc	ra,0xfffff
    800025ea:	604080e7          	jalr	1540(ra) # 80001bea <myproc>
    800025ee:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800025f0:	ffffe097          	auipc	ra,0xffffe
    800025f4:	648080e7          	jalr	1608(ra) # 80000c38 <acquire>
  release(lk);
    800025f8:	854a                	mv	a0,s2
    800025fa:	ffffe097          	auipc	ra,0xffffe
    800025fe:	6f2080e7          	jalr	1778(ra) # 80000cec <release>

  // Go to sleep.
  p->chan = chan;
    80002602:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002606:	4789                	li	a5,2
    80002608:	cc9c                	sw	a5,24(s1)
  // remove_from_queue(p->priority, p->pid);

  sched();
    8000260a:	00000097          	auipc	ra,0x0
    8000260e:	e86080e7          	jalr	-378(ra) # 80002490 <sched>

  // Tidy up.
  p->chan = 0;
    80002612:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002616:	8526                	mv	a0,s1
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	6d4080e7          	jalr	1748(ra) # 80000cec <release>
  acquire(lk);
    80002620:	854a                	mv	a0,s2
    80002622:	ffffe097          	auipc	ra,0xffffe
    80002626:	616080e7          	jalr	1558(ra) # 80000c38 <acquire>
}
    8000262a:	70a2                	ld	ra,40(sp)
    8000262c:	7402                	ld	s0,32(sp)
    8000262e:	64e2                	ld	s1,24(sp)
    80002630:	6942                	ld	s2,16(sp)
    80002632:	69a2                	ld	s3,8(sp)
    80002634:	6145                	addi	sp,sp,48
    80002636:	8082                	ret

0000000080002638 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002638:	7139                	addi	sp,sp,-64
    8000263a:	fc06                	sd	ra,56(sp)
    8000263c:	f822                	sd	s0,48(sp)
    8000263e:	f426                	sd	s1,40(sp)
    80002640:	f04a                	sd	s2,32(sp)
    80002642:	ec4e                	sd	s3,24(sp)
    80002644:	e852                	sd	s4,16(sp)
    80002646:	e456                	sd	s5,8(sp)
    80002648:	0080                	addi	s0,sp,64
    8000264a:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000264c:	00012497          	auipc	s1,0x12
    80002650:	df448493          	addi	s1,s1,-524 # 80014440 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002654:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    80002656:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002658:	0001f917          	auipc	s2,0x1f
    8000265c:	1e890913          	addi	s2,s2,488 # 80021840 <tickslock>
    80002660:	a811                	j	80002674 <wakeup+0x3c>
        int ticks_used = p->ticks_used;
        if(SCHEDULER == 2)
          add_to_queue(p->priority, p);
        p->ticks_used = ticks_used;
      }
      release(&p->lock);
    80002662:	8526                	mv	a0,s1
    80002664:	ffffe097          	auipc	ra,0xffffe
    80002668:	688080e7          	jalr	1672(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000266c:	35048493          	addi	s1,s1,848
    80002670:	03248663          	beq	s1,s2,8000269c <wakeup+0x64>
    if (p != myproc())
    80002674:	fffff097          	auipc	ra,0xfffff
    80002678:	576080e7          	jalr	1398(ra) # 80001bea <myproc>
    8000267c:	fea488e3          	beq	s1,a0,8000266c <wakeup+0x34>
      acquire(&p->lock);
    80002680:	8526                	mv	a0,s1
    80002682:	ffffe097          	auipc	ra,0xffffe
    80002686:	5b6080e7          	jalr	1462(ra) # 80000c38 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000268a:	4c9c                	lw	a5,24(s1)
    8000268c:	fd379be3          	bne	a5,s3,80002662 <wakeup+0x2a>
    80002690:	709c                	ld	a5,32(s1)
    80002692:	fd4798e3          	bne	a5,s4,80002662 <wakeup+0x2a>
        p->state = RUNNABLE;
    80002696:	0154ac23          	sw	s5,24(s1)
        p->ticks_used = ticks_used;
    8000269a:	b7e1                	j	80002662 <wakeup+0x2a>
    }
  }
}
    8000269c:	70e2                	ld	ra,56(sp)
    8000269e:	7442                	ld	s0,48(sp)
    800026a0:	74a2                	ld	s1,40(sp)
    800026a2:	7902                	ld	s2,32(sp)
    800026a4:	69e2                	ld	s3,24(sp)
    800026a6:	6a42                	ld	s4,16(sp)
    800026a8:	6aa2                	ld	s5,8(sp)
    800026aa:	6121                	addi	sp,sp,64
    800026ac:	8082                	ret

00000000800026ae <reparent>:
{
    800026ae:	7179                	addi	sp,sp,-48
    800026b0:	f406                	sd	ra,40(sp)
    800026b2:	f022                	sd	s0,32(sp)
    800026b4:	ec26                	sd	s1,24(sp)
    800026b6:	e84a                	sd	s2,16(sp)
    800026b8:	e44e                	sd	s3,8(sp)
    800026ba:	e052                	sd	s4,0(sp)
    800026bc:	1800                	addi	s0,sp,48
    800026be:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800026c0:	00012497          	auipc	s1,0x12
    800026c4:	d8048493          	addi	s1,s1,-640 # 80014440 <proc>
      pp->parent = initproc;
    800026c8:	00009a17          	auipc	s4,0x9
    800026cc:	d80a0a13          	addi	s4,s4,-640 # 8000b448 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800026d0:	0001f997          	auipc	s3,0x1f
    800026d4:	17098993          	addi	s3,s3,368 # 80021840 <tickslock>
    800026d8:	a029                	j	800026e2 <reparent+0x34>
    800026da:	35048493          	addi	s1,s1,848
    800026de:	01348d63          	beq	s1,s3,800026f8 <reparent+0x4a>
    if (pp->parent == p)
    800026e2:	7c9c                	ld	a5,56(s1)
    800026e4:	ff279be3          	bne	a5,s2,800026da <reparent+0x2c>
      pp->parent = initproc;
    800026e8:	000a3503          	ld	a0,0(s4)
    800026ec:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	f4a080e7          	jalr	-182(ra) # 80002638 <wakeup>
    800026f6:	b7d5                	j	800026da <reparent+0x2c>
}
    800026f8:	70a2                	ld	ra,40(sp)
    800026fa:	7402                	ld	s0,32(sp)
    800026fc:	64e2                	ld	s1,24(sp)
    800026fe:	6942                	ld	s2,16(sp)
    80002700:	69a2                	ld	s3,8(sp)
    80002702:	6a02                	ld	s4,0(sp)
    80002704:	6145                	addi	sp,sp,48
    80002706:	8082                	ret

0000000080002708 <exit>:
{
    80002708:	7179                	addi	sp,sp,-48
    8000270a:	f406                	sd	ra,40(sp)
    8000270c:	f022                	sd	s0,32(sp)
    8000270e:	ec26                	sd	s1,24(sp)
    80002710:	e84a                	sd	s2,16(sp)
    80002712:	e44e                	sd	s3,8(sp)
    80002714:	e052                	sd	s4,0(sp)
    80002716:	1800                	addi	s0,sp,48
    80002718:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000271a:	fffff097          	auipc	ra,0xfffff
    8000271e:	4d0080e7          	jalr	1232(ra) # 80001bea <myproc>
    80002722:	89aa                	mv	s3,a0
  if (p == initproc)
    80002724:	00009797          	auipc	a5,0x9
    80002728:	d247b783          	ld	a5,-732(a5) # 8000b448 <initproc>
    8000272c:	2a850493          	addi	s1,a0,680
    80002730:	32850913          	addi	s2,a0,808
    80002734:	02a79363          	bne	a5,a0,8000275a <exit+0x52>
    panic("init exiting");
    80002738:	00006517          	auipc	a0,0x6
    8000273c:	b1850513          	addi	a0,a0,-1256 # 80008250 <etext+0x250>
    80002740:	ffffe097          	auipc	ra,0xffffe
    80002744:	e20080e7          	jalr	-480(ra) # 80000560 <panic>
      fileclose(f);
    80002748:	00002097          	auipc	ra,0x2
    8000274c:	788080e7          	jalr	1928(ra) # 80004ed0 <fileclose>
      p->ofile[fd] = 0;
    80002750:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002754:	04a1                	addi	s1,s1,8
    80002756:	01248563          	beq	s1,s2,80002760 <exit+0x58>
    if (p->ofile[fd])
    8000275a:	6088                	ld	a0,0(s1)
    8000275c:	f575                	bnez	a0,80002748 <exit+0x40>
    8000275e:	bfdd                	j	80002754 <exit+0x4c>
  begin_op();
    80002760:	00002097          	auipc	ra,0x2
    80002764:	2a6080e7          	jalr	678(ra) # 80004a06 <begin_op>
  iput(p->cwd);
    80002768:	3289b503          	ld	a0,808(s3)
    8000276c:	00002097          	auipc	ra,0x2
    80002770:	a8a080e7          	jalr	-1398(ra) # 800041f6 <iput>
  end_op();
    80002774:	00002097          	auipc	ra,0x2
    80002778:	30c080e7          	jalr	780(ra) # 80004a80 <end_op>
  p->cwd = 0;
    8000277c:	3209b423          	sd	zero,808(s3)
  acquire(&wait_lock);
    80002780:	00011497          	auipc	s1,0x11
    80002784:	f6848493          	addi	s1,s1,-152 # 800136e8 <wait_lock>
    80002788:	8526                	mv	a0,s1
    8000278a:	ffffe097          	auipc	ra,0xffffe
    8000278e:	4ae080e7          	jalr	1198(ra) # 80000c38 <acquire>
  reparent(p);
    80002792:	854e                	mv	a0,s3
    80002794:	00000097          	auipc	ra,0x0
    80002798:	f1a080e7          	jalr	-230(ra) # 800026ae <reparent>
  wakeup(p->parent);
    8000279c:	0389b503          	ld	a0,56(s3)
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	e98080e7          	jalr	-360(ra) # 80002638 <wakeup>
  acquire(&p->lock);
    800027a8:	854e                	mv	a0,s3
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	48e080e7          	jalr	1166(ra) # 80000c38 <acquire>
  p->xstate = status;
    800027b2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800027b6:	4795                	li	a5,5
    800027b8:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    800027bc:	00009797          	auipc	a5,0x9
    800027c0:	c987a783          	lw	a5,-872(a5) # 8000b454 <ticks>
    800027c4:	34f9a423          	sw	a5,840(s3)
  release(&wait_lock);
    800027c8:	8526                	mv	a0,s1
    800027ca:	ffffe097          	auipc	ra,0xffffe
    800027ce:	522080e7          	jalr	1314(ra) # 80000cec <release>
  sched();
    800027d2:	00000097          	auipc	ra,0x0
    800027d6:	cbe080e7          	jalr	-834(ra) # 80002490 <sched>
  panic("zombie exit");
    800027da:	00006517          	auipc	a0,0x6
    800027de:	a8650513          	addi	a0,a0,-1402 # 80008260 <etext+0x260>
    800027e2:	ffffe097          	auipc	ra,0xffffe
    800027e6:	d7e080e7          	jalr	-642(ra) # 80000560 <panic>

00000000800027ea <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	1800                	addi	s0,sp,48
    800027f8:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800027fa:	00012497          	auipc	s1,0x12
    800027fe:	c4648493          	addi	s1,s1,-954 # 80014440 <proc>
    80002802:	0001f997          	auipc	s3,0x1f
    80002806:	03e98993          	addi	s3,s3,62 # 80021840 <tickslock>
  {
    acquire(&p->lock);
    8000280a:	8526                	mv	a0,s1
    8000280c:	ffffe097          	auipc	ra,0xffffe
    80002810:	42c080e7          	jalr	1068(ra) # 80000c38 <acquire>
    if (p->pid == pid)
    80002814:	589c                	lw	a5,48(s1)
    80002816:	01278d63          	beq	a5,s2,80002830 <kill+0x46>
          add_to_queue(p->priority, p);
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000281a:	8526                	mv	a0,s1
    8000281c:	ffffe097          	auipc	ra,0xffffe
    80002820:	4d0080e7          	jalr	1232(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002824:	35048493          	addi	s1,s1,848
    80002828:	ff3491e3          	bne	s1,s3,8000280a <kill+0x20>
  }
  return -1;
    8000282c:	557d                	li	a0,-1
    8000282e:	a829                	j	80002848 <kill+0x5e>
      p->killed = 1;
    80002830:	4785                	li	a5,1
    80002832:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002834:	4c98                	lw	a4,24(s1)
    80002836:	4789                	li	a5,2
    80002838:	00f70f63          	beq	a4,a5,80002856 <kill+0x6c>
      release(&p->lock);
    8000283c:	8526                	mv	a0,s1
    8000283e:	ffffe097          	auipc	ra,0xffffe
    80002842:	4ae080e7          	jalr	1198(ra) # 80000cec <release>
      return 0;
    80002846:	4501                	li	a0,0
}
    80002848:	70a2                	ld	ra,40(sp)
    8000284a:	7402                	ld	s0,32(sp)
    8000284c:	64e2                	ld	s1,24(sp)
    8000284e:	6942                	ld	s2,16(sp)
    80002850:	69a2                	ld	s3,8(sp)
    80002852:	6145                	addi	sp,sp,48
    80002854:	8082                	ret
        p->state = RUNNABLE;
    80002856:	478d                	li	a5,3
    80002858:	cc9c                	sw	a5,24(s1)
        if(SCHEDULER == 2)
    8000285a:	b7cd                	j	8000283c <kill+0x52>

000000008000285c <setkilled>:

void setkilled(struct proc *p)
{
    8000285c:	1101                	addi	sp,sp,-32
    8000285e:	ec06                	sd	ra,24(sp)
    80002860:	e822                	sd	s0,16(sp)
    80002862:	e426                	sd	s1,8(sp)
    80002864:	1000                	addi	s0,sp,32
    80002866:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	3d0080e7          	jalr	976(ra) # 80000c38 <acquire>
  p->killed = 1;
    80002870:	4785                	li	a5,1
    80002872:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002874:	8526                	mv	a0,s1
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	476080e7          	jalr	1142(ra) # 80000cec <release>
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6105                	addi	sp,sp,32
    80002886:	8082                	ret

0000000080002888 <killed>:

int killed(struct proc *p)
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	e426                	sd	s1,8(sp)
    80002890:	e04a                	sd	s2,0(sp)
    80002892:	1000                	addi	s0,sp,32
    80002894:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	3a2080e7          	jalr	930(ra) # 80000c38 <acquire>
  k = p->killed;
    8000289e:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800028a2:	8526                	mv	a0,s1
    800028a4:	ffffe097          	auipc	ra,0xffffe
    800028a8:	448080e7          	jalr	1096(ra) # 80000cec <release>
  return k;
}
    800028ac:	854a                	mv	a0,s2
    800028ae:	60e2                	ld	ra,24(sp)
    800028b0:	6442                	ld	s0,16(sp)
    800028b2:	64a2                	ld	s1,8(sp)
    800028b4:	6902                	ld	s2,0(sp)
    800028b6:	6105                	addi	sp,sp,32
    800028b8:	8082                	ret

00000000800028ba <wait>:
{
    800028ba:	715d                	addi	sp,sp,-80
    800028bc:	e486                	sd	ra,72(sp)
    800028be:	e0a2                	sd	s0,64(sp)
    800028c0:	fc26                	sd	s1,56(sp)
    800028c2:	f84a                	sd	s2,48(sp)
    800028c4:	f44e                	sd	s3,40(sp)
    800028c6:	f052                	sd	s4,32(sp)
    800028c8:	ec56                	sd	s5,24(sp)
    800028ca:	e85a                	sd	s6,16(sp)
    800028cc:	e45e                	sd	s7,8(sp)
    800028ce:	e062                	sd	s8,0(sp)
    800028d0:	0880                	addi	s0,sp,80
    800028d2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800028d4:	fffff097          	auipc	ra,0xfffff
    800028d8:	316080e7          	jalr	790(ra) # 80001bea <myproc>
    800028dc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800028de:	00011517          	auipc	a0,0x11
    800028e2:	e0a50513          	addi	a0,a0,-502 # 800136e8 <wait_lock>
    800028e6:	ffffe097          	auipc	ra,0xffffe
    800028ea:	352080e7          	jalr	850(ra) # 80000c38 <acquire>
    havekids = 0;
    800028ee:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800028f0:	4a95                	li	s5,5
        havekids = 1;
    800028f2:	4b05                	li	s6,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800028f4:	0001f997          	auipc	s3,0x1f
    800028f8:	f4c98993          	addi	s3,s3,-180 # 80021840 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800028fc:	00011c17          	auipc	s8,0x11
    80002900:	decc0c13          	addi	s8,s8,-532 # 800136e8 <wait_lock>
    80002904:	a0d5                	j	800029e8 <wait+0x12e>
    80002906:	04048613          	addi	a2,s1,64
          for (int i = 0; i <= 25; i++)
    8000290a:	4701                	li	a4,0
    8000290c:	4569                	li	a0,26
            pp->parent->syscall_count[i] += pp->syscall_count[i];
    8000290e:	00271693          	slli	a3,a4,0x2
    80002912:	7c9c                	ld	a5,56(s1)
    80002914:	97b6                	add	a5,a5,a3
    80002916:	43ac                	lw	a1,64(a5)
    80002918:	4214                	lw	a3,0(a2)
    8000291a:	9ead                	addw	a3,a3,a1
    8000291c:	c3b4                	sw	a3,64(a5)
          for (int i = 0; i <= 25; i++)
    8000291e:	2705                	addiw	a4,a4,1
    80002920:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80002922:	fea716e3          	bne	a4,a0,8000290e <wait+0x54>
          pid = pp->pid;
    80002926:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000292a:	000a0e63          	beqz	s4,80002946 <wait+0x8c>
    8000292e:	4691                	li	a3,4
    80002930:	02c48613          	addi	a2,s1,44
    80002934:	85d2                	mv	a1,s4
    80002936:	22893503          	ld	a0,552(s2)
    8000293a:	fffff097          	auipc	ra,0xfffff
    8000293e:	da8080e7          	jalr	-600(ra) # 800016e2 <copyout>
    80002942:	04054163          	bltz	a0,80002984 <wait+0xca>
          freeproc(pp);
    80002946:	8526                	mv	a0,s1
    80002948:	fffff097          	auipc	ra,0xfffff
    8000294c:	454080e7          	jalr	1108(ra) # 80001d9c <freeproc>
          release(&pp->lock);
    80002950:	8526                	mv	a0,s1
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	39a080e7          	jalr	922(ra) # 80000cec <release>
          release(&wait_lock);
    8000295a:	00011517          	auipc	a0,0x11
    8000295e:	d8e50513          	addi	a0,a0,-626 # 800136e8 <wait_lock>
    80002962:	ffffe097          	auipc	ra,0xffffe
    80002966:	38a080e7          	jalr	906(ra) # 80000cec <release>
}
    8000296a:	854e                	mv	a0,s3
    8000296c:	60a6                	ld	ra,72(sp)
    8000296e:	6406                	ld	s0,64(sp)
    80002970:	74e2                	ld	s1,56(sp)
    80002972:	7942                	ld	s2,48(sp)
    80002974:	79a2                	ld	s3,40(sp)
    80002976:	7a02                	ld	s4,32(sp)
    80002978:	6ae2                	ld	s5,24(sp)
    8000297a:	6b42                	ld	s6,16(sp)
    8000297c:	6ba2                	ld	s7,8(sp)
    8000297e:	6c02                	ld	s8,0(sp)
    80002980:	6161                	addi	sp,sp,80
    80002982:	8082                	ret
            release(&pp->lock);
    80002984:	8526                	mv	a0,s1
    80002986:	ffffe097          	auipc	ra,0xffffe
    8000298a:	366080e7          	jalr	870(ra) # 80000cec <release>
            release(&wait_lock);
    8000298e:	00011517          	auipc	a0,0x11
    80002992:	d5a50513          	addi	a0,a0,-678 # 800136e8 <wait_lock>
    80002996:	ffffe097          	auipc	ra,0xffffe
    8000299a:	356080e7          	jalr	854(ra) # 80000cec <release>
            return -1;
    8000299e:	59fd                	li	s3,-1
    800029a0:	b7e9                	j	8000296a <wait+0xb0>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800029a2:	35048493          	addi	s1,s1,848
    800029a6:	03348463          	beq	s1,s3,800029ce <wait+0x114>
      if (pp->parent == p)
    800029aa:	7c9c                	ld	a5,56(s1)
    800029ac:	ff279be3          	bne	a5,s2,800029a2 <wait+0xe8>
        acquire(&pp->lock);
    800029b0:	8526                	mv	a0,s1
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	286080e7          	jalr	646(ra) # 80000c38 <acquire>
        if (pp->state == ZOMBIE)
    800029ba:	4c9c                	lw	a5,24(s1)
    800029bc:	f55785e3          	beq	a5,s5,80002906 <wait+0x4c>
        release(&pp->lock);
    800029c0:	8526                	mv	a0,s1
    800029c2:	ffffe097          	auipc	ra,0xffffe
    800029c6:	32a080e7          	jalr	810(ra) # 80000cec <release>
        havekids = 1;
    800029ca:	875a                	mv	a4,s6
    800029cc:	bfd9                	j	800029a2 <wait+0xe8>
    if (!havekids || killed(p))
    800029ce:	c31d                	beqz	a4,800029f4 <wait+0x13a>
    800029d0:	854a                	mv	a0,s2
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	eb6080e7          	jalr	-330(ra) # 80002888 <killed>
    800029da:	ed09                	bnez	a0,800029f4 <wait+0x13a>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800029dc:	85e2                	mv	a1,s8
    800029de:	854a                	mv	a0,s2
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	bf4080e7          	jalr	-1036(ra) # 800025d4 <sleep>
    havekids = 0;
    800029e8:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800029ea:	00012497          	auipc	s1,0x12
    800029ee:	a5648493          	addi	s1,s1,-1450 # 80014440 <proc>
    800029f2:	bf65                	j	800029aa <wait+0xf0>
      release(&wait_lock);
    800029f4:	00011517          	auipc	a0,0x11
    800029f8:	cf450513          	addi	a0,a0,-780 # 800136e8 <wait_lock>
    800029fc:	ffffe097          	auipc	ra,0xffffe
    80002a00:	2f0080e7          	jalr	752(ra) # 80000cec <release>
      return -1;
    80002a04:	59fd                	li	s3,-1
    80002a06:	b795                	j	8000296a <wait+0xb0>

0000000080002a08 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002a08:	7179                	addi	sp,sp,-48
    80002a0a:	f406                	sd	ra,40(sp)
    80002a0c:	f022                	sd	s0,32(sp)
    80002a0e:	ec26                	sd	s1,24(sp)
    80002a10:	e84a                	sd	s2,16(sp)
    80002a12:	e44e                	sd	s3,8(sp)
    80002a14:	e052                	sd	s4,0(sp)
    80002a16:	1800                	addi	s0,sp,48
    80002a18:	84aa                	mv	s1,a0
    80002a1a:	892e                	mv	s2,a1
    80002a1c:	89b2                	mv	s3,a2
    80002a1e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a20:	fffff097          	auipc	ra,0xfffff
    80002a24:	1ca080e7          	jalr	458(ra) # 80001bea <myproc>
  if (user_dst)
    80002a28:	c095                	beqz	s1,80002a4c <either_copyout+0x44>
  {
    return copyout(p->pagetable, dst, src, len);
    80002a2a:	86d2                	mv	a3,s4
    80002a2c:	864e                	mv	a2,s3
    80002a2e:	85ca                	mv	a1,s2
    80002a30:	22853503          	ld	a0,552(a0)
    80002a34:	fffff097          	auipc	ra,0xfffff
    80002a38:	cae080e7          	jalr	-850(ra) # 800016e2 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002a3c:	70a2                	ld	ra,40(sp)
    80002a3e:	7402                	ld	s0,32(sp)
    80002a40:	64e2                	ld	s1,24(sp)
    80002a42:	6942                	ld	s2,16(sp)
    80002a44:	69a2                	ld	s3,8(sp)
    80002a46:	6a02                	ld	s4,0(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret
    memmove((char *)dst, src, len);
    80002a4c:	000a061b          	sext.w	a2,s4
    80002a50:	85ce                	mv	a1,s3
    80002a52:	854a                	mv	a0,s2
    80002a54:	ffffe097          	auipc	ra,0xffffe
    80002a58:	33c080e7          	jalr	828(ra) # 80000d90 <memmove>
    return 0;
    80002a5c:	8526                	mv	a0,s1
    80002a5e:	bff9                	j	80002a3c <either_copyout+0x34>

0000000080002a60 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a60:	7179                	addi	sp,sp,-48
    80002a62:	f406                	sd	ra,40(sp)
    80002a64:	f022                	sd	s0,32(sp)
    80002a66:	ec26                	sd	s1,24(sp)
    80002a68:	e84a                	sd	s2,16(sp)
    80002a6a:	e44e                	sd	s3,8(sp)
    80002a6c:	e052                	sd	s4,0(sp)
    80002a6e:	1800                	addi	s0,sp,48
    80002a70:	892a                	mv	s2,a0
    80002a72:	84ae                	mv	s1,a1
    80002a74:	89b2                	mv	s3,a2
    80002a76:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a78:	fffff097          	auipc	ra,0xfffff
    80002a7c:	172080e7          	jalr	370(ra) # 80001bea <myproc>
  if (user_src)
    80002a80:	c095                	beqz	s1,80002aa4 <either_copyin+0x44>
  {
    return copyin(p->pagetable, dst, src, len);
    80002a82:	86d2                	mv	a3,s4
    80002a84:	864e                	mv	a2,s3
    80002a86:	85ca                	mv	a1,s2
    80002a88:	22853503          	ld	a0,552(a0)
    80002a8c:	fffff097          	auipc	ra,0xfffff
    80002a90:	ce2080e7          	jalr	-798(ra) # 8000176e <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002a94:	70a2                	ld	ra,40(sp)
    80002a96:	7402                	ld	s0,32(sp)
    80002a98:	64e2                	ld	s1,24(sp)
    80002a9a:	6942                	ld	s2,16(sp)
    80002a9c:	69a2                	ld	s3,8(sp)
    80002a9e:	6a02                	ld	s4,0(sp)
    80002aa0:	6145                	addi	sp,sp,48
    80002aa2:	8082                	ret
    memmove(dst, (char *)src, len);
    80002aa4:	000a061b          	sext.w	a2,s4
    80002aa8:	85ce                	mv	a1,s3
    80002aaa:	854a                	mv	a0,s2
    80002aac:	ffffe097          	auipc	ra,0xffffe
    80002ab0:	2e4080e7          	jalr	740(ra) # 80000d90 <memmove>
    return 0;
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	bff9                	j	80002a94 <either_copyin+0x34>

0000000080002ab8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002ab8:	7159                	addi	sp,sp,-112
    80002aba:	f486                	sd	ra,104(sp)
    80002abc:	f0a2                	sd	s0,96(sp)
    80002abe:	eca6                	sd	s1,88(sp)
    80002ac0:	e8ca                	sd	s2,80(sp)
    80002ac2:	e4ce                	sd	s3,72(sp)
    80002ac4:	e0d2                	sd	s4,64(sp)
    80002ac6:	fc56                	sd	s5,56(sp)
    80002ac8:	f85a                	sd	s6,48(sp)
    80002aca:	f45e                	sd	s7,40(sp)
    80002acc:	f062                	sd	s8,32(sp)
    80002ace:	ec66                	sd	s9,24(sp)
    80002ad0:	e86a                	sd	s10,16(sp)
    80002ad2:	e46e                	sd	s11,8(sp)
    80002ad4:	1880                	addi	s0,sp,112
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002ad6:	00005517          	auipc	a0,0x5
    80002ada:	53a50513          	addi	a0,a0,1338 # 80008010 <etext+0x10>
    80002ade:	ffffe097          	auipc	ra,0xffffe
    80002ae2:	acc080e7          	jalr	-1332(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ae6:	00012497          	auipc	s1,0x12
    80002aea:	c8a48493          	addi	s1,s1,-886 # 80014770 <proc+0x330>
    80002aee:	0001f917          	auipc	s2,0x1f
    80002af2:	08290913          	addi	s2,s2,130 # 80021b70 <bcache+0x318>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002af6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002af8:	00005997          	auipc	s3,0x5
    80002afc:	77898993          	addi	s3,s3,1912 # 80008270 <etext+0x270>
    printf("%d %s %s %s %d", p->pid, state, p->name, state, p->priority);
    80002b00:	00005a97          	auipc	s5,0x5
    80002b04:	778a8a93          	addi	s5,s5,1912 # 80008278 <etext+0x278>
    printf("\n");
    80002b08:	00005a17          	auipc	s4,0x5
    80002b0c:	508a0a13          	addi	s4,s4,1288 # 80008010 <etext+0x10>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b10:	00006b97          	auipc	s7,0x6
    80002b14:	c58b8b93          	addi	s7,s7,-936 # 80008768 <states.0>
    80002b18:	a025                	j	80002b40 <procdump+0x88>
    printf("%d %s %s %s %d", p->pid, state, p->name, state, p->priority);
    80002b1a:	ecc6a783          	lw	a5,-308(a3)
    80002b1e:	8732                	mv	a4,a2
    80002b20:	d006a583          	lw	a1,-768(a3)
    80002b24:	8556                	mv	a0,s5
    80002b26:	ffffe097          	auipc	ra,0xffffe
    80002b2a:	a84080e7          	jalr	-1404(ra) # 800005aa <printf>
    printf("\n");
    80002b2e:	8552                	mv	a0,s4
    80002b30:	ffffe097          	auipc	ra,0xffffe
    80002b34:	a7a080e7          	jalr	-1414(ra) # 800005aa <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002b38:	35048493          	addi	s1,s1,848
    80002b3c:	03248263          	beq	s1,s2,80002b60 <procdump+0xa8>
    if (p->state == UNUSED)
    80002b40:	86a6                	mv	a3,s1
    80002b42:	ce84a783          	lw	a5,-792(s1)
    80002b46:	dbed                	beqz	a5,80002b38 <procdump+0x80>
      state = "???";
    80002b48:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b4a:	fcfb68e3          	bltu	s6,a5,80002b1a <procdump+0x62>
    80002b4e:	02079713          	slli	a4,a5,0x20
    80002b52:	01d75793          	srli	a5,a4,0x1d
    80002b56:	97de                	add	a5,a5,s7
    80002b58:	6390                	ld	a2,0(a5)
    80002b5a:	f261                	bnez	a2,80002b1a <procdump+0x62>
      state = "???";
    80002b5c:	864e                	mv	a2,s3
    80002b5e:	bf75                	j	80002b1a <procdump+0x62>
    80002b60:	00011b17          	auipc	s6,0x11
    80002b64:	b60b0b13          	addi	s6,s6,-1184 # 800136c0 <queue_count>
    80002b68:	00011b97          	auipc	s7,0x11
    80002b6c:	f98b8b93          	addi	s7,s7,-104 # 80013b00 <mlfq_proc>
  }
  for(int x=0;x<NQUEUE;x++)
    80002b70:	4a81                	li	s5,0
  {
    printf("Queue %d: ",x);
    80002b72:	00005d17          	auipc	s10,0x5
    80002b76:	716d0d13          	addi	s10,s10,1814 # 80008288 <etext+0x288>
    for(int y=0;y<queue_count[x];y++)
    80002b7a:	4d81                	li	s11,0
    {
      printf("%d ",mlfq_proc[x][y]->pid);
    80002b7c:	00005a17          	auipc	s4,0x5
    80002b80:	71ca0a13          	addi	s4,s4,1820 # 80008298 <etext+0x298>
    }
    printf("\n");
    80002b84:	00005c97          	auipc	s9,0x5
    80002b88:	48cc8c93          	addi	s9,s9,1164 # 80008010 <etext+0x10>
  for(int x=0;x<NQUEUE;x++)
    80002b8c:	4c11                	li	s8,4
    printf("Queue %d: ",x);
    80002b8e:	85d6                	mv	a1,s5
    80002b90:	856a                	mv	a0,s10
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	a18080e7          	jalr	-1512(ra) # 800005aa <printf>
    for(int y=0;y<queue_count[x];y++)
    80002b9a:	89da                	mv	s3,s6
    80002b9c:	000b2783          	lw	a5,0(s6)
    80002ba0:	02f05263          	blez	a5,80002bc4 <procdump+0x10c>
    80002ba4:	895e                	mv	s2,s7
    80002ba6:	84ee                	mv	s1,s11
      printf("%d ",mlfq_proc[x][y]->pid);
    80002ba8:	00093783          	ld	a5,0(s2)
    80002bac:	5b8c                	lw	a1,48(a5)
    80002bae:	8552                	mv	a0,s4
    80002bb0:	ffffe097          	auipc	ra,0xffffe
    80002bb4:	9fa080e7          	jalr	-1542(ra) # 800005aa <printf>
    for(int y=0;y<queue_count[x];y++)
    80002bb8:	2485                	addiw	s1,s1,1
    80002bba:	0921                	addi	s2,s2,8
    80002bbc:	0009a783          	lw	a5,0(s3)
    80002bc0:	fef4c4e3          	blt	s1,a5,80002ba8 <procdump+0xf0>
    printf("\n");
    80002bc4:	8566                	mv	a0,s9
    80002bc6:	ffffe097          	auipc	ra,0xffffe
    80002bca:	9e4080e7          	jalr	-1564(ra) # 800005aa <printf>
  for(int x=0;x<NQUEUE;x++)
    80002bce:	2a85                	addiw	s5,s5,1
    80002bd0:	0b11                	addi	s6,s6,4
    80002bd2:	250b8b93          	addi	s7,s7,592
    80002bd6:	fb8a9ce3          	bne	s5,s8,80002b8e <procdump+0xd6>
  }
}
    80002bda:	70a6                	ld	ra,104(sp)
    80002bdc:	7406                	ld	s0,96(sp)
    80002bde:	64e6                	ld	s1,88(sp)
    80002be0:	6946                	ld	s2,80(sp)
    80002be2:	69a6                	ld	s3,72(sp)
    80002be4:	6a06                	ld	s4,64(sp)
    80002be6:	7ae2                	ld	s5,56(sp)
    80002be8:	7b42                	ld	s6,48(sp)
    80002bea:	7ba2                	ld	s7,40(sp)
    80002bec:	7c02                	ld	s8,32(sp)
    80002bee:	6ce2                	ld	s9,24(sp)
    80002bf0:	6d42                	ld	s10,16(sp)
    80002bf2:	6da2                	ld	s11,8(sp)
    80002bf4:	6165                	addi	sp,sp,112
    80002bf6:	8082                	ret

0000000080002bf8 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002bf8:	711d                	addi	sp,sp,-96
    80002bfa:	ec86                	sd	ra,88(sp)
    80002bfc:	e8a2                	sd	s0,80(sp)
    80002bfe:	e4a6                	sd	s1,72(sp)
    80002c00:	e0ca                	sd	s2,64(sp)
    80002c02:	fc4e                	sd	s3,56(sp)
    80002c04:	f852                	sd	s4,48(sp)
    80002c06:	f456                	sd	s5,40(sp)
    80002c08:	f05a                	sd	s6,32(sp)
    80002c0a:	ec5e                	sd	s7,24(sp)
    80002c0c:	e862                	sd	s8,16(sp)
    80002c0e:	e466                	sd	s9,8(sp)
    80002c10:	e06a                	sd	s10,0(sp)
    80002c12:	1080                	addi	s0,sp,96
    80002c14:	8b2a                	mv	s6,a0
    80002c16:	8bae                	mv	s7,a1
    80002c18:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002c1a:	fffff097          	auipc	ra,0xfffff
    80002c1e:	fd0080e7          	jalr	-48(ra) # 80001bea <myproc>
    80002c22:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002c24:	00011517          	auipc	a0,0x11
    80002c28:	ac450513          	addi	a0,a0,-1340 # 800136e8 <wait_lock>
    80002c2c:	ffffe097          	auipc	ra,0xffffe
    80002c30:	00c080e7          	jalr	12(ra) # 80000c38 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002c34:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002c36:	4a15                	li	s4,5
        havekids = 1;
    80002c38:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002c3a:	0001f997          	auipc	s3,0x1f
    80002c3e:	c0698993          	addi	s3,s3,-1018 # 80021840 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002c42:	00011d17          	auipc	s10,0x11
    80002c46:	aa6d0d13          	addi	s10,s10,-1370 # 800136e8 <wait_lock>
    80002c4a:	a8e9                	j	80002d24 <waitx+0x12c>
          pid = np->pid;
    80002c4c:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002c50:	3404a783          	lw	a5,832(s1)
    80002c54:	00fc2023          	sw	a5,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002c58:	3444a703          	lw	a4,836(s1)
    80002c5c:	9f3d                	addw	a4,a4,a5
    80002c5e:	3484a783          	lw	a5,840(s1)
    80002c62:	9f99                	subw	a5,a5,a4
    80002c64:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002c68:	000b0e63          	beqz	s6,80002c84 <waitx+0x8c>
    80002c6c:	4691                	li	a3,4
    80002c6e:	02c48613          	addi	a2,s1,44
    80002c72:	85da                	mv	a1,s6
    80002c74:	22893503          	ld	a0,552(s2)
    80002c78:	fffff097          	auipc	ra,0xfffff
    80002c7c:	a6a080e7          	jalr	-1430(ra) # 800016e2 <copyout>
    80002c80:	04054363          	bltz	a0,80002cc6 <waitx+0xce>
          freeproc(np);
    80002c84:	8526                	mv	a0,s1
    80002c86:	fffff097          	auipc	ra,0xfffff
    80002c8a:	116080e7          	jalr	278(ra) # 80001d9c <freeproc>
          release(&np->lock);
    80002c8e:	8526                	mv	a0,s1
    80002c90:	ffffe097          	auipc	ra,0xffffe
    80002c94:	05c080e7          	jalr	92(ra) # 80000cec <release>
          release(&wait_lock);
    80002c98:	00011517          	auipc	a0,0x11
    80002c9c:	a5050513          	addi	a0,a0,-1456 # 800136e8 <wait_lock>
    80002ca0:	ffffe097          	auipc	ra,0xffffe
    80002ca4:	04c080e7          	jalr	76(ra) # 80000cec <release>
  }
}
    80002ca8:	854e                	mv	a0,s3
    80002caa:	60e6                	ld	ra,88(sp)
    80002cac:	6446                	ld	s0,80(sp)
    80002cae:	64a6                	ld	s1,72(sp)
    80002cb0:	6906                	ld	s2,64(sp)
    80002cb2:	79e2                	ld	s3,56(sp)
    80002cb4:	7a42                	ld	s4,48(sp)
    80002cb6:	7aa2                	ld	s5,40(sp)
    80002cb8:	7b02                	ld	s6,32(sp)
    80002cba:	6be2                	ld	s7,24(sp)
    80002cbc:	6c42                	ld	s8,16(sp)
    80002cbe:	6ca2                	ld	s9,8(sp)
    80002cc0:	6d02                	ld	s10,0(sp)
    80002cc2:	6125                	addi	sp,sp,96
    80002cc4:	8082                	ret
            release(&np->lock);
    80002cc6:	8526                	mv	a0,s1
    80002cc8:	ffffe097          	auipc	ra,0xffffe
    80002ccc:	024080e7          	jalr	36(ra) # 80000cec <release>
            release(&wait_lock);
    80002cd0:	00011517          	auipc	a0,0x11
    80002cd4:	a1850513          	addi	a0,a0,-1512 # 800136e8 <wait_lock>
    80002cd8:	ffffe097          	auipc	ra,0xffffe
    80002cdc:	014080e7          	jalr	20(ra) # 80000cec <release>
            return -1;
    80002ce0:	59fd                	li	s3,-1
    80002ce2:	b7d9                	j	80002ca8 <waitx+0xb0>
    for (np = proc; np < &proc[NPROC]; np++)
    80002ce4:	35048493          	addi	s1,s1,848
    80002ce8:	03348463          	beq	s1,s3,80002d10 <waitx+0x118>
      if (np->parent == p)
    80002cec:	7c9c                	ld	a5,56(s1)
    80002cee:	ff279be3          	bne	a5,s2,80002ce4 <waitx+0xec>
        acquire(&np->lock);
    80002cf2:	8526                	mv	a0,s1
    80002cf4:	ffffe097          	auipc	ra,0xffffe
    80002cf8:	f44080e7          	jalr	-188(ra) # 80000c38 <acquire>
        if (np->state == ZOMBIE)
    80002cfc:	4c9c                	lw	a5,24(s1)
    80002cfe:	f54787e3          	beq	a5,s4,80002c4c <waitx+0x54>
        release(&np->lock);
    80002d02:	8526                	mv	a0,s1
    80002d04:	ffffe097          	auipc	ra,0xffffe
    80002d08:	fe8080e7          	jalr	-24(ra) # 80000cec <release>
        havekids = 1;
    80002d0c:	8756                	mv	a4,s5
    80002d0e:	bfd9                	j	80002ce4 <waitx+0xec>
    if (!havekids || p->killed)
    80002d10:	c305                	beqz	a4,80002d30 <waitx+0x138>
    80002d12:	02892783          	lw	a5,40(s2)
    80002d16:	ef89                	bnez	a5,80002d30 <waitx+0x138>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002d18:	85ea                	mv	a1,s10
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	8b8080e7          	jalr	-1864(ra) # 800025d4 <sleep>
    havekids = 0;
    80002d24:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002d26:	00011497          	auipc	s1,0x11
    80002d2a:	71a48493          	addi	s1,s1,1818 # 80014440 <proc>
    80002d2e:	bf7d                	j	80002cec <waitx+0xf4>
      release(&wait_lock);
    80002d30:	00011517          	auipc	a0,0x11
    80002d34:	9b850513          	addi	a0,a0,-1608 # 800136e8 <wait_lock>
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	fb4080e7          	jalr	-76(ra) # 80000cec <release>
      return -1;
    80002d40:	59fd                	li	s3,-1
    80002d42:	b79d                	j	80002ca8 <waitx+0xb0>

0000000080002d44 <update_time>:

void update_time()
{
    80002d44:	7179                	addi	sp,sp,-48
    80002d46:	f406                	sd	ra,40(sp)
    80002d48:	f022                	sd	s0,32(sp)
    80002d4a:	ec26                	sd	s1,24(sp)
    80002d4c:	e84a                	sd	s2,16(sp)
    80002d4e:	e44e                	sd	s3,8(sp)
    80002d50:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002d52:	00011497          	auipc	s1,0x11
    80002d56:	6ee48493          	addi	s1,s1,1774 # 80014440 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002d5a:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002d5c:	0001f917          	auipc	s2,0x1f
    80002d60:	ae490913          	addi	s2,s2,-1308 # 80021840 <tickslock>
    80002d64:	a811                	j	80002d78 <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    80002d66:	8526                	mv	a0,s1
    80002d68:	ffffe097          	auipc	ra,0xffffe
    80002d6c:	f84080e7          	jalr	-124(ra) # 80000cec <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002d70:	35048493          	addi	s1,s1,848
    80002d74:	03248063          	beq	s1,s2,80002d94 <update_time+0x50>
    acquire(&p->lock);
    80002d78:	8526                	mv	a0,s1
    80002d7a:	ffffe097          	auipc	ra,0xffffe
    80002d7e:	ebe080e7          	jalr	-322(ra) # 80000c38 <acquire>
    if (p->state == RUNNING)
    80002d82:	4c9c                	lw	a5,24(s1)
    80002d84:	ff3791e3          	bne	a5,s3,80002d66 <update_time+0x22>
      p->rtime++;
    80002d88:	3404a783          	lw	a5,832(s1)
    80002d8c:	2785                	addiw	a5,a5,1
    80002d8e:	34f4a023          	sw	a5,832(s1)
    80002d92:	bfd1                	j	80002d66 <update_time+0x22>
  //     {
  //       mlfq_proc[i][j]->queue_ticks++;
  //     }
  //   }
  // }
    80002d94:	70a2                	ld	ra,40(sp)
    80002d96:	7402                	ld	s0,32(sp)
    80002d98:	64e2                	ld	s1,24(sp)
    80002d9a:	6942                	ld	s2,16(sp)
    80002d9c:	69a2                	ld	s3,8(sp)
    80002d9e:	6145                	addi	sp,sp,48
    80002da0:	8082                	ret

0000000080002da2 <swtch>:
    80002da2:	00153023          	sd	ra,0(a0)
    80002da6:	00253423          	sd	sp,8(a0)
    80002daa:	e900                	sd	s0,16(a0)
    80002dac:	ed04                	sd	s1,24(a0)
    80002dae:	03253023          	sd	s2,32(a0)
    80002db2:	03353423          	sd	s3,40(a0)
    80002db6:	03453823          	sd	s4,48(a0)
    80002dba:	03553c23          	sd	s5,56(a0)
    80002dbe:	05653023          	sd	s6,64(a0)
    80002dc2:	05753423          	sd	s7,72(a0)
    80002dc6:	05853823          	sd	s8,80(a0)
    80002dca:	05953c23          	sd	s9,88(a0)
    80002dce:	07a53023          	sd	s10,96(a0)
    80002dd2:	07b53423          	sd	s11,104(a0)
    80002dd6:	0005b083          	ld	ra,0(a1)
    80002dda:	0085b103          	ld	sp,8(a1)
    80002dde:	6980                	ld	s0,16(a1)
    80002de0:	6d84                	ld	s1,24(a1)
    80002de2:	0205b903          	ld	s2,32(a1)
    80002de6:	0285b983          	ld	s3,40(a1)
    80002dea:	0305ba03          	ld	s4,48(a1)
    80002dee:	0385ba83          	ld	s5,56(a1)
    80002df2:	0405bb03          	ld	s6,64(a1)
    80002df6:	0485bb83          	ld	s7,72(a1)
    80002dfa:	0505bc03          	ld	s8,80(a1)
    80002dfe:	0585bc83          	ld	s9,88(a1)
    80002e02:	0605bd03          	ld	s10,96(a1)
    80002e06:	0685bd83          	ld	s11,104(a1)
    80002e0a:	8082                	ret

0000000080002e0c <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002e0c:	1141                	addi	sp,sp,-16
    80002e0e:	e406                	sd	ra,8(sp)
    80002e10:	e022                	sd	s0,0(sp)
    80002e12:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002e14:	00005597          	auipc	a1,0x5
    80002e18:	4bc58593          	addi	a1,a1,1212 # 800082d0 <etext+0x2d0>
    80002e1c:	0001f517          	auipc	a0,0x1f
    80002e20:	a2450513          	addi	a0,a0,-1500 # 80021840 <tickslock>
    80002e24:	ffffe097          	auipc	ra,0xffffe
    80002e28:	d84080e7          	jalr	-636(ra) # 80000ba8 <initlock>
}
    80002e2c:	60a2                	ld	ra,8(sp)
    80002e2e:	6402                	ld	s0,0(sp)
    80002e30:	0141                	addi	sp,sp,16
    80002e32:	8082                	ret

0000000080002e34 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002e34:	1141                	addi	sp,sp,-16
    80002e36:	e422                	sd	s0,8(sp)
    80002e38:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e3a:	00003797          	auipc	a5,0x3
    80002e3e:	7a678793          	addi	a5,a5,1958 # 800065e0 <kernelvec>
    80002e42:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002e46:	6422                	ld	s0,8(sp)
    80002e48:	0141                	addi	sp,sp,16
    80002e4a:	8082                	ret

0000000080002e4c <usertrapret>:
}

// return to user space
//
void usertrapret(void)
{
    80002e4c:	1141                	addi	sp,sp,-16
    80002e4e:	e406                	sd	ra,8(sp)
    80002e50:	e022                	sd	s0,0(sp)
    80002e52:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	d96080e7          	jalr	-618(ra) # 80001bea <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002e60:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e62:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002e66:	00004697          	auipc	a3,0x4
    80002e6a:	19a68693          	addi	a3,a3,410 # 80007000 <_trampoline>
    80002e6e:	00004717          	auipc	a4,0x4
    80002e72:	19270713          	addi	a4,a4,402 # 80007000 <_trampoline>
    80002e76:	8f15                	sub	a4,a4,a3
    80002e78:	040007b7          	lui	a5,0x4000
    80002e7c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002e7e:	07b2                	slli	a5,a5,0xc
    80002e80:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e82:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e86:	23053703          	ld	a4,560(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002e8a:	18002673          	csrr	a2,satp
    80002e8e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e90:	23053603          	ld	a2,560(a0)
    80002e94:	21853703          	ld	a4,536(a0)
    80002e98:	6585                	lui	a1,0x1
    80002e9a:	972e                	add	a4,a4,a1
    80002e9c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e9e:	23053703          	ld	a4,560(a0)
    80002ea2:	00000617          	auipc	a2,0x0
    80002ea6:	14c60613          	addi	a2,a2,332 # 80002fee <usertrap>
    80002eaa:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002eac:	23053703          	ld	a4,560(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002eb0:	8612                	mv	a2,tp
    80002eb2:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002eb4:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002eb8:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ebc:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ec0:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002ec4:	23053703          	ld	a4,560(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ec8:	6f18                	ld	a4,24(a4)
    80002eca:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002ece:	22853503          	ld	a0,552(a0)
    80002ed2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002ed4:	00004717          	auipc	a4,0x4
    80002ed8:	1c870713          	addi	a4,a4,456 # 8000709c <userret>
    80002edc:	8f15                	sub	a4,a4,a3
    80002ede:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ee0:	577d                	li	a4,-1
    80002ee2:	177e                	slli	a4,a4,0x3f
    80002ee4:	8d59                	or	a0,a0,a4
    80002ee6:	9782                	jalr	a5
}
    80002ee8:	60a2                	ld	ra,8(sp)
    80002eea:	6402                	ld	s0,0(sp)
    80002eec:	0141                	addi	sp,sp,16
    80002eee:	8082                	ret

0000000080002ef0 <clockintr>:
}

int boost_count = 0;

void clockintr()
{
    80002ef0:	1101                	addi	sp,sp,-32
    80002ef2:	ec06                	sd	ra,24(sp)
    80002ef4:	e822                	sd	s0,16(sp)
    80002ef6:	e426                	sd	s1,8(sp)
    80002ef8:	e04a                	sd	s2,0(sp)
    80002efa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002efc:	0001f917          	auipc	s2,0x1f
    80002f00:	94490913          	addi	s2,s2,-1724 # 80021840 <tickslock>
    80002f04:	854a                	mv	a0,s2
    80002f06:	ffffe097          	auipc	ra,0xffffe
    80002f0a:	d32080e7          	jalr	-718(ra) # 80000c38 <acquire>
  ticks++;
    80002f0e:	00008497          	auipc	s1,0x8
    80002f12:	54648493          	addi	s1,s1,1350 # 8000b454 <ticks>
    80002f16:	409c                	lw	a5,0(s1)
    80002f18:	2785                	addiw	a5,a5,1
    80002f1a:	c09c                	sw	a5,0(s1)
  update_time();
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	e28080e7          	jalr	-472(ra) # 80002d44 <update_time>
        release(&p->lock);
      }
    }
  }

  wakeup(&ticks);
    80002f24:	8526                	mv	a0,s1
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	712080e7          	jalr	1810(ra) # 80002638 <wakeup>
  release(&tickslock);
    80002f2e:	854a                	mv	a0,s2
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	dbc080e7          	jalr	-580(ra) # 80000cec <release>
}
    80002f38:	60e2                	ld	ra,24(sp)
    80002f3a:	6442                	ld	s0,16(sp)
    80002f3c:	64a2                	ld	s1,8(sp)
    80002f3e:	6902                	ld	s2,0(sp)
    80002f40:	6105                	addi	sp,sp,32
    80002f42:	8082                	ret

0000000080002f44 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f44:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80002f48:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80002f4a:	0a07d163          	bgez	a5,80002fec <devintr+0xa8>
{
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80002f56:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80002f5a:	46a5                	li	a3,9
    80002f5c:	00d70c63          	beq	a4,a3,80002f74 <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80002f60:	577d                	li	a4,-1
    80002f62:	177e                	slli	a4,a4,0x3f
    80002f64:	0705                	addi	a4,a4,1
    return 0;
    80002f66:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002f68:	06e78163          	beq	a5,a4,80002fca <devintr+0x86>
  }
}
    80002f6c:	60e2                	ld	ra,24(sp)
    80002f6e:	6442                	ld	s0,16(sp)
    80002f70:	6105                	addi	sp,sp,32
    80002f72:	8082                	ret
    80002f74:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002f76:	00003097          	auipc	ra,0x3
    80002f7a:	776080e7          	jalr	1910(ra) # 800066ec <plic_claim>
    80002f7e:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002f80:	47a9                	li	a5,10
    80002f82:	00f50963          	beq	a0,a5,80002f94 <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80002f86:	4785                	li	a5,1
    80002f88:	00f50b63          	beq	a0,a5,80002f9e <devintr+0x5a>
    return 1;
    80002f8c:	4505                	li	a0,1
    else if (irq)
    80002f8e:	ec89                	bnez	s1,80002fa8 <devintr+0x64>
    80002f90:	64a2                	ld	s1,8(sp)
    80002f92:	bfe9                	j	80002f6c <devintr+0x28>
      uartintr();
    80002f94:	ffffe097          	auipc	ra,0xffffe
    80002f98:	a66080e7          	jalr	-1434(ra) # 800009fa <uartintr>
    if (irq)
    80002f9c:	a839                	j	80002fba <devintr+0x76>
      virtio_disk_intr();
    80002f9e:	00004097          	auipc	ra,0x4
    80002fa2:	c78080e7          	jalr	-904(ra) # 80006c16 <virtio_disk_intr>
    if (irq)
    80002fa6:	a811                	j	80002fba <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80002fa8:	85a6                	mv	a1,s1
    80002faa:	00005517          	auipc	a0,0x5
    80002fae:	32e50513          	addi	a0,a0,814 # 800082d8 <etext+0x2d8>
    80002fb2:	ffffd097          	auipc	ra,0xffffd
    80002fb6:	5f8080e7          	jalr	1528(ra) # 800005aa <printf>
      plic_complete(irq);
    80002fba:	8526                	mv	a0,s1
    80002fbc:	00003097          	auipc	ra,0x3
    80002fc0:	754080e7          	jalr	1876(ra) # 80006710 <plic_complete>
    return 1;
    80002fc4:	4505                	li	a0,1
    80002fc6:	64a2                	ld	s1,8(sp)
    80002fc8:	b755                	j	80002f6c <devintr+0x28>
    if (cpuid() == 0)
    80002fca:	fffff097          	auipc	ra,0xfffff
    80002fce:	bf4080e7          	jalr	-1036(ra) # 80001bbe <cpuid>
    80002fd2:	c901                	beqz	a0,80002fe2 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002fd4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002fd8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002fda:	14479073          	csrw	sip,a5
    return 2;
    80002fde:	4509                	li	a0,2
    80002fe0:	b771                	j	80002f6c <devintr+0x28>
      clockintr();
    80002fe2:	00000097          	auipc	ra,0x0
    80002fe6:	f0e080e7          	jalr	-242(ra) # 80002ef0 <clockintr>
    80002fea:	b7ed                	j	80002fd4 <devintr+0x90>
}
    80002fec:	8082                	ret

0000000080002fee <usertrap>:
{
    80002fee:	1101                	addi	sp,sp,-32
    80002ff0:	ec06                	sd	ra,24(sp)
    80002ff2:	e822                	sd	s0,16(sp)
    80002ff4:	e426                	sd	s1,8(sp)
    80002ff6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ff8:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002ffc:	1007f793          	andi	a5,a5,256
    80003000:	ebad                	bnez	a5,80003072 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003002:	00003797          	auipc	a5,0x3
    80003006:	5de78793          	addi	a5,a5,1502 # 800065e0 <kernelvec>
    8000300a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000300e:	fffff097          	auipc	ra,0xfffff
    80003012:	bdc080e7          	jalr	-1060(ra) # 80001bea <myproc>
    80003016:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003018:	23053783          	ld	a5,560(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000301c:	14102773          	csrr	a4,sepc
    80003020:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003022:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80003026:	47a1                	li	a5,8
    80003028:	04f70d63          	beq	a4,a5,80003082 <usertrap+0x94>
  else if ((which_dev = devintr()) != 0)
    8000302c:	00000097          	auipc	ra,0x0
    80003030:	f18080e7          	jalr	-232(ra) # 80002f44 <devintr>
    80003034:	c145                	beqz	a0,800030d4 <usertrap+0xe6>
  if (which_dev == 2 && p->interval > 0)
    80003036:	4789                	li	a5,2
    80003038:	06f51963          	bne	a0,a5,800030aa <usertrap+0xbc>
    8000303c:	0c44a703          	lw	a4,196(s1)
    80003040:	00e05e63          	blez	a4,8000305c <usertrap+0x6e>
    p->ticks++;
    80003044:	0c04a783          	lw	a5,192(s1)
    80003048:	2785                	addiw	a5,a5,1
    8000304a:	0007869b          	sext.w	a3,a5
    8000304e:	0cf4a023          	sw	a5,192(s1)
    if (p->ticks >= p->interval && p->alarm_set == 0)
    80003052:	00e6c563          	blt	a3,a4,8000305c <usertrap+0x6e>
    80003056:	1f04a783          	lw	a5,496(s1)
    8000305a:	cbd5                	beqz	a5,8000310e <usertrap+0x120>
  if (killed(p))
    8000305c:	8526                	mv	a0,s1
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	82a080e7          	jalr	-2006(ra) # 80002888 <killed>
    80003066:	e961                	bnez	a0,80003136 <usertrap+0x148>
      yield();
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	4fe080e7          	jalr	1278(ra) # 80002566 <yield>
    80003070:	a099                	j	800030b6 <usertrap+0xc8>
    panic("usertrap: not from user mode");
    80003072:	00005517          	auipc	a0,0x5
    80003076:	28650513          	addi	a0,a0,646 # 800082f8 <etext+0x2f8>
    8000307a:	ffffd097          	auipc	ra,0xffffd
    8000307e:	4e6080e7          	jalr	1254(ra) # 80000560 <panic>
    if (killed(p))
    80003082:	00000097          	auipc	ra,0x0
    80003086:	806080e7          	jalr	-2042(ra) # 80002888 <killed>
    8000308a:	ed1d                	bnez	a0,800030c8 <usertrap+0xda>
    p->trapframe->epc += 4;
    8000308c:	2304b703          	ld	a4,560(s1)
    80003090:	6f1c                	ld	a5,24(a4)
    80003092:	0791                	addi	a5,a5,4
    80003094:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003096:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000309a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000309e:	10079073          	csrw	sstatus,a5
    syscall();
    800030a2:	00000097          	auipc	ra,0x0
    800030a6:	308080e7          	jalr	776(ra) # 800033aa <syscall>
  if (killed(p))
    800030aa:	8526                	mv	a0,s1
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	7dc080e7          	jalr	2012(ra) # 80002888 <killed>
    800030b4:	e559                	bnez	a0,80003142 <usertrap+0x154>
  usertrapret();
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	d96080e7          	jalr	-618(ra) # 80002e4c <usertrapret>
}
    800030be:	60e2                	ld	ra,24(sp)
    800030c0:	6442                	ld	s0,16(sp)
    800030c2:	64a2                	ld	s1,8(sp)
    800030c4:	6105                	addi	sp,sp,32
    800030c6:	8082                	ret
      exit(-1);
    800030c8:	557d                	li	a0,-1
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	63e080e7          	jalr	1598(ra) # 80002708 <exit>
    800030d2:	bf6d                	j	8000308c <usertrap+0x9e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030d4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800030d8:	5890                	lw	a2,48(s1)
    800030da:	00005517          	auipc	a0,0x5
    800030de:	23e50513          	addi	a0,a0,574 # 80008318 <etext+0x318>
    800030e2:	ffffd097          	auipc	ra,0xffffd
    800030e6:	4c8080e7          	jalr	1224(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030ea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800030ee:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800030f2:	00005517          	auipc	a0,0x5
    800030f6:	25650513          	addi	a0,a0,598 # 80008348 <etext+0x348>
    800030fa:	ffffd097          	auipc	ra,0xffffd
    800030fe:	4b0080e7          	jalr	1200(ra) # 800005aa <printf>
    setkilled(p);
    80003102:	8526                	mv	a0,s1
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	758080e7          	jalr	1880(ra) # 8000285c <setkilled>
  if (which_dev == 2 && p->interval > 0)
    8000310c:	bf79                	j	800030aa <usertrap+0xbc>
      p->ticks = 0;
    8000310e:	0c04a023          	sw	zero,192(s1)
      p->alarm_set = 1;
    80003112:	4785                	li	a5,1
    80003114:	1ef4a823          	sw	a5,496(s1)
      memmove(&p->saved_alarm_tf, p->trapframe, sizeof(struct trapframe));
    80003118:	12000613          	li	a2,288
    8000311c:	2304b583          	ld	a1,560(s1)
    80003120:	0d048513          	addi	a0,s1,208
    80003124:	ffffe097          	auipc	ra,0xffffe
    80003128:	c6c080e7          	jalr	-916(ra) # 80000d90 <memmove>
      p->trapframe->epc = p->handler_addr;
    8000312c:	2304b783          	ld	a5,560(s1)
    80003130:	64f8                	ld	a4,200(s1)
    80003132:	ef98                	sd	a4,24(a5)
    80003134:	b725                	j	8000305c <usertrap+0x6e>
    exit(-1);
    80003136:	557d                	li	a0,-1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	5d0080e7          	jalr	1488(ra) # 80002708 <exit>
  if (which_dev == 2)
    80003140:	b725                	j	80003068 <usertrap+0x7a>
    exit(-1);
    80003142:	557d                	li	a0,-1
    80003144:	fffff097          	auipc	ra,0xfffff
    80003148:	5c4080e7          	jalr	1476(ra) # 80002708 <exit>
  if (which_dev == 2)
    8000314c:	b7ad                	j	800030b6 <usertrap+0xc8>

000000008000314e <kerneltrap>:
{
    8000314e:	7179                	addi	sp,sp,-48
    80003150:	f406                	sd	ra,40(sp)
    80003152:	f022                	sd	s0,32(sp)
    80003154:	ec26                	sd	s1,24(sp)
    80003156:	e84a                	sd	s2,16(sp)
    80003158:	e44e                	sd	s3,8(sp)
    8000315a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000315c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003160:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003164:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80003168:	1004f793          	andi	a5,s1,256
    8000316c:	cb85                	beqz	a5,8000319c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000316e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003172:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80003174:	ef85                	bnez	a5,800031ac <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80003176:	00000097          	auipc	ra,0x0
    8000317a:	dce080e7          	jalr	-562(ra) # 80002f44 <devintr>
    8000317e:	cd1d                	beqz	a0,800031bc <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003180:	4789                	li	a5,2
    80003182:	06f50a63          	beq	a0,a5,800031f6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003186:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000318a:	10049073          	csrw	sstatus,s1
}
    8000318e:	70a2                	ld	ra,40(sp)
    80003190:	7402                	ld	s0,32(sp)
    80003192:	64e2                	ld	s1,24(sp)
    80003194:	6942                	ld	s2,16(sp)
    80003196:	69a2                	ld	s3,8(sp)
    80003198:	6145                	addi	sp,sp,48
    8000319a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000319c:	00005517          	auipc	a0,0x5
    800031a0:	1cc50513          	addi	a0,a0,460 # 80008368 <etext+0x368>
    800031a4:	ffffd097          	auipc	ra,0xffffd
    800031a8:	3bc080e7          	jalr	956(ra) # 80000560 <panic>
    panic("kerneltrap: interrupts enabled");
    800031ac:	00005517          	auipc	a0,0x5
    800031b0:	1e450513          	addi	a0,a0,484 # 80008390 <etext+0x390>
    800031b4:	ffffd097          	auipc	ra,0xffffd
    800031b8:	3ac080e7          	jalr	940(ra) # 80000560 <panic>
    printf("scause %p\n", scause);
    800031bc:	85ce                	mv	a1,s3
    800031be:	00005517          	auipc	a0,0x5
    800031c2:	1f250513          	addi	a0,a0,498 # 800083b0 <etext+0x3b0>
    800031c6:	ffffd097          	auipc	ra,0xffffd
    800031ca:	3e4080e7          	jalr	996(ra) # 800005aa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031ce:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800031d2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800031d6:	00005517          	auipc	a0,0x5
    800031da:	1ea50513          	addi	a0,a0,490 # 800083c0 <etext+0x3c0>
    800031de:	ffffd097          	auipc	ra,0xffffd
    800031e2:	3cc080e7          	jalr	972(ra) # 800005aa <printf>
    panic("kerneltrap");
    800031e6:	00005517          	auipc	a0,0x5
    800031ea:	1f250513          	addi	a0,a0,498 # 800083d8 <etext+0x3d8>
    800031ee:	ffffd097          	auipc	ra,0xffffd
    800031f2:	372080e7          	jalr	882(ra) # 80000560 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031f6:	fffff097          	auipc	ra,0xfffff
    800031fa:	9f4080e7          	jalr	-1548(ra) # 80001bea <myproc>
    800031fe:	d541                	beqz	a0,80003186 <kerneltrap+0x38>
    80003200:	fffff097          	auipc	ra,0xfffff
    80003204:	9ea080e7          	jalr	-1558(ra) # 80001bea <myproc>
    80003208:	4d18                	lw	a4,24(a0)
    8000320a:	4791                	li	a5,4
    8000320c:	f6f71de3          	bne	a4,a5,80003186 <kerneltrap+0x38>
    yield();
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	356080e7          	jalr	854(ra) # 80002566 <yield>
    80003218:	b7bd                	j	80003186 <kerneltrap+0x38>

000000008000321a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000321a:	1101                	addi	sp,sp,-32
    8000321c:	ec06                	sd	ra,24(sp)
    8000321e:	e822                	sd	s0,16(sp)
    80003220:	e426                	sd	s1,8(sp)
    80003222:	1000                	addi	s0,sp,32
    80003224:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003226:	fffff097          	auipc	ra,0xfffff
    8000322a:	9c4080e7          	jalr	-1596(ra) # 80001bea <myproc>
  switch (n) {
    8000322e:	4795                	li	a5,5
    80003230:	0497e763          	bltu	a5,s1,8000327e <argraw+0x64>
    80003234:	048a                	slli	s1,s1,0x2
    80003236:	00005717          	auipc	a4,0x5
    8000323a:	56270713          	addi	a4,a4,1378 # 80008798 <states.0+0x30>
    8000323e:	94ba                	add	s1,s1,a4
    80003240:	409c                	lw	a5,0(s1)
    80003242:	97ba                	add	a5,a5,a4
    80003244:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003246:	23053783          	ld	a5,560(a0)
    8000324a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000324c:	60e2                	ld	ra,24(sp)
    8000324e:	6442                	ld	s0,16(sp)
    80003250:	64a2                	ld	s1,8(sp)
    80003252:	6105                	addi	sp,sp,32
    80003254:	8082                	ret
    return p->trapframe->a1;
    80003256:	23053783          	ld	a5,560(a0)
    8000325a:	7fa8                	ld	a0,120(a5)
    8000325c:	bfc5                	j	8000324c <argraw+0x32>
    return p->trapframe->a2;
    8000325e:	23053783          	ld	a5,560(a0)
    80003262:	63c8                	ld	a0,128(a5)
    80003264:	b7e5                	j	8000324c <argraw+0x32>
    return p->trapframe->a3;
    80003266:	23053783          	ld	a5,560(a0)
    8000326a:	67c8                	ld	a0,136(a5)
    8000326c:	b7c5                	j	8000324c <argraw+0x32>
    return p->trapframe->a4;
    8000326e:	23053783          	ld	a5,560(a0)
    80003272:	6bc8                	ld	a0,144(a5)
    80003274:	bfe1                	j	8000324c <argraw+0x32>
    return p->trapframe->a5;
    80003276:	23053783          	ld	a5,560(a0)
    8000327a:	6fc8                	ld	a0,152(a5)
    8000327c:	bfc1                	j	8000324c <argraw+0x32>
  panic("argraw");
    8000327e:	00005517          	auipc	a0,0x5
    80003282:	16a50513          	addi	a0,a0,362 # 800083e8 <etext+0x3e8>
    80003286:	ffffd097          	auipc	ra,0xffffd
    8000328a:	2da080e7          	jalr	730(ra) # 80000560 <panic>

000000008000328e <fetchaddr>:
{
    8000328e:	1101                	addi	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	e426                	sd	s1,8(sp)
    80003296:	e04a                	sd	s2,0(sp)
    80003298:	1000                	addi	s0,sp,32
    8000329a:	84aa                	mv	s1,a0
    8000329c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000329e:	fffff097          	auipc	ra,0xfffff
    800032a2:	94c080e7          	jalr	-1716(ra) # 80001bea <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800032a6:	22053783          	ld	a5,544(a0)
    800032aa:	02f4f963          	bgeu	s1,a5,800032dc <fetchaddr+0x4e>
    800032ae:	00848713          	addi	a4,s1,8
    800032b2:	02e7e763          	bltu	a5,a4,800032e0 <fetchaddr+0x52>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800032b6:	46a1                	li	a3,8
    800032b8:	8626                	mv	a2,s1
    800032ba:	85ca                	mv	a1,s2
    800032bc:	22853503          	ld	a0,552(a0)
    800032c0:	ffffe097          	auipc	ra,0xffffe
    800032c4:	4ae080e7          	jalr	1198(ra) # 8000176e <copyin>
    800032c8:	00a03533          	snez	a0,a0
    800032cc:	40a00533          	neg	a0,a0
}
    800032d0:	60e2                	ld	ra,24(sp)
    800032d2:	6442                	ld	s0,16(sp)
    800032d4:	64a2                	ld	s1,8(sp)
    800032d6:	6902                	ld	s2,0(sp)
    800032d8:	6105                	addi	sp,sp,32
    800032da:	8082                	ret
    return -1;
    800032dc:	557d                	li	a0,-1
    800032de:	bfcd                	j	800032d0 <fetchaddr+0x42>
    800032e0:	557d                	li	a0,-1
    800032e2:	b7fd                	j	800032d0 <fetchaddr+0x42>

00000000800032e4 <fetchstr>:
{
    800032e4:	7179                	addi	sp,sp,-48
    800032e6:	f406                	sd	ra,40(sp)
    800032e8:	f022                	sd	s0,32(sp)
    800032ea:	ec26                	sd	s1,24(sp)
    800032ec:	e84a                	sd	s2,16(sp)
    800032ee:	e44e                	sd	s3,8(sp)
    800032f0:	1800                	addi	s0,sp,48
    800032f2:	892a                	mv	s2,a0
    800032f4:	84ae                	mv	s1,a1
    800032f6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800032f8:	fffff097          	auipc	ra,0xfffff
    800032fc:	8f2080e7          	jalr	-1806(ra) # 80001bea <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003300:	86ce                	mv	a3,s3
    80003302:	864a                	mv	a2,s2
    80003304:	85a6                	mv	a1,s1
    80003306:	22853503          	ld	a0,552(a0)
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	4f2080e7          	jalr	1266(ra) # 800017fc <copyinstr>
    80003312:	00054e63          	bltz	a0,8000332e <fetchstr+0x4a>
  return strlen(buf);
    80003316:	8526                	mv	a0,s1
    80003318:	ffffe097          	auipc	ra,0xffffe
    8000331c:	b90080e7          	jalr	-1136(ra) # 80000ea8 <strlen>
}
    80003320:	70a2                	ld	ra,40(sp)
    80003322:	7402                	ld	s0,32(sp)
    80003324:	64e2                	ld	s1,24(sp)
    80003326:	6942                	ld	s2,16(sp)
    80003328:	69a2                	ld	s3,8(sp)
    8000332a:	6145                	addi	sp,sp,48
    8000332c:	8082                	ret
    return -1;
    8000332e:	557d                	li	a0,-1
    80003330:	bfc5                	j	80003320 <fetchstr+0x3c>

0000000080003332 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003332:	1101                	addi	sp,sp,-32
    80003334:	ec06                	sd	ra,24(sp)
    80003336:	e822                	sd	s0,16(sp)
    80003338:	e426                	sd	s1,8(sp)
    8000333a:	1000                	addi	s0,sp,32
    8000333c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	edc080e7          	jalr	-292(ra) # 8000321a <argraw>
    80003346:	c088                	sw	a0,0(s1)
}
    80003348:	60e2                	ld	ra,24(sp)
    8000334a:	6442                	ld	s0,16(sp)
    8000334c:	64a2                	ld	s1,8(sp)
    8000334e:	6105                	addi	sp,sp,32
    80003350:	8082                	ret

0000000080003352 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003352:	1101                	addi	sp,sp,-32
    80003354:	ec06                	sd	ra,24(sp)
    80003356:	e822                	sd	s0,16(sp)
    80003358:	e426                	sd	s1,8(sp)
    8000335a:	1000                	addi	s0,sp,32
    8000335c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000335e:	00000097          	auipc	ra,0x0
    80003362:	ebc080e7          	jalr	-324(ra) # 8000321a <argraw>
    80003366:	e088                	sd	a0,0(s1)
}
    80003368:	60e2                	ld	ra,24(sp)
    8000336a:	6442                	ld	s0,16(sp)
    8000336c:	64a2                	ld	s1,8(sp)
    8000336e:	6105                	addi	sp,sp,32
    80003370:	8082                	ret

0000000080003372 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003372:	7179                	addi	sp,sp,-48
    80003374:	f406                	sd	ra,40(sp)
    80003376:	f022                	sd	s0,32(sp)
    80003378:	ec26                	sd	s1,24(sp)
    8000337a:	e84a                	sd	s2,16(sp)
    8000337c:	1800                	addi	s0,sp,48
    8000337e:	84ae                	mv	s1,a1
    80003380:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003382:	fd840593          	addi	a1,s0,-40
    80003386:	00000097          	auipc	ra,0x0
    8000338a:	fcc080e7          	jalr	-52(ra) # 80003352 <argaddr>
  return fetchstr(addr, buf, max);
    8000338e:	864a                	mv	a2,s2
    80003390:	85a6                	mv	a1,s1
    80003392:	fd843503          	ld	a0,-40(s0)
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	f4e080e7          	jalr	-178(ra) # 800032e4 <fetchstr>
}
    8000339e:	70a2                	ld	ra,40(sp)
    800033a0:	7402                	ld	s0,32(sp)
    800033a2:	64e2                	ld	s1,24(sp)
    800033a4:	6942                	ld	s2,16(sp)
    800033a6:	6145                	addi	sp,sp,48
    800033a8:	8082                	ret

00000000800033aa <syscall>:
    [SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    800033aa:	7179                	addi	sp,sp,-48
    800033ac:	f406                	sd	ra,40(sp)
    800033ae:	f022                	sd	s0,32(sp)
    800033b0:	ec26                	sd	s1,24(sp)
    800033b2:	e84a                	sd	s2,16(sp)
    800033b4:	e44e                	sd	s3,8(sp)
    800033b6:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800033b8:	fffff097          	auipc	ra,0xfffff
    800033bc:	832080e7          	jalr	-1998(ra) # 80001bea <myproc>
    800033c0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800033c2:	23053983          	ld	s3,560(a0)
    800033c6:	0a89b783          	ld	a5,168(s3)
    800033ca:	0007891b          	sext.w	s2,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800033ce:	37fd                	addiw	a5,a5,-1
    800033d0:	4761                	li	a4,24
    800033d2:	02f76663          	bltu	a4,a5,800033fe <syscall+0x54>
    800033d6:	00391713          	slli	a4,s2,0x3
    800033da:	00005797          	auipc	a5,0x5
    800033de:	3d678793          	addi	a5,a5,982 # 800087b0 <syscalls>
    800033e2:	97ba                	add	a5,a5,a4
    800033e4:	639c                	ld	a5,0(a5)
    800033e6:	cf81                	beqz	a5,800033fe <syscall+0x54>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800033e8:	9782                	jalr	a5
    800033ea:	06a9b823          	sd	a0,112(s3)
    p->syscall_count[num]++;
    800033ee:	090a                	slli	s2,s2,0x2
    800033f0:	9926                	add	s2,s2,s1
    800033f2:	04092783          	lw	a5,64(s2)
    800033f6:	2785                	addiw	a5,a5,1
    800033f8:	04f92023          	sw	a5,64(s2)
    800033fc:	a00d                	j	8000341e <syscall+0x74>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800033fe:	86ca                	mv	a3,s2
    80003400:	33048613          	addi	a2,s1,816
    80003404:	588c                	lw	a1,48(s1)
    80003406:	00005517          	auipc	a0,0x5
    8000340a:	fea50513          	addi	a0,a0,-22 # 800083f0 <etext+0x3f0>
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	19c080e7          	jalr	412(ra) # 800005aa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003416:	2304b783          	ld	a5,560(s1)
    8000341a:	577d                	li	a4,-1
    8000341c:	fbb8                	sd	a4,112(a5)
  }
}
    8000341e:	70a2                	ld	ra,40(sp)
    80003420:	7402                	ld	s0,32(sp)
    80003422:	64e2                	ld	s1,24(sp)
    80003424:	6942                	ld	s2,16(sp)
    80003426:	69a2                	ld	s3,8(sp)
    80003428:	6145                	addi	sp,sp,48
    8000342a:	8082                	ret

000000008000342c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000342c:	1101                	addi	sp,sp,-32
    8000342e:	ec06                	sd	ra,24(sp)
    80003430:	e822                	sd	s0,16(sp)
    80003432:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003434:	fec40593          	addi	a1,s0,-20
    80003438:	4501                	li	a0,0
    8000343a:	00000097          	auipc	ra,0x0
    8000343e:	ef8080e7          	jalr	-264(ra) # 80003332 <argint>
  exit(n);
    80003442:	fec42503          	lw	a0,-20(s0)
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	2c2080e7          	jalr	706(ra) # 80002708 <exit>
  return 0; // not reached
}
    8000344e:	4501                	li	a0,0
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	6105                	addi	sp,sp,32
    80003456:	8082                	ret

0000000080003458 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003458:	1141                	addi	sp,sp,-16
    8000345a:	e406                	sd	ra,8(sp)
    8000345c:	e022                	sd	s0,0(sp)
    8000345e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003460:	ffffe097          	auipc	ra,0xffffe
    80003464:	78a080e7          	jalr	1930(ra) # 80001bea <myproc>
}
    80003468:	5908                	lw	a0,48(a0)
    8000346a:	60a2                	ld	ra,8(sp)
    8000346c:	6402                	ld	s0,0(sp)
    8000346e:	0141                	addi	sp,sp,16
    80003470:	8082                	ret

0000000080003472 <sys_fork>:

uint64
sys_fork(void)
{
    80003472:	1141                	addi	sp,sp,-16
    80003474:	e406                	sd	ra,8(sp)
    80003476:	e022                	sd	s0,0(sp)
    80003478:	0800                	addi	s0,sp,16
  return fork();
    8000347a:	fffff097          	auipc	ra,0xfffff
    8000347e:	bb6080e7          	jalr	-1098(ra) # 80002030 <fork>
}
    80003482:	60a2                	ld	ra,8(sp)
    80003484:	6402                	ld	s0,0(sp)
    80003486:	0141                	addi	sp,sp,16
    80003488:	8082                	ret

000000008000348a <sys_wait>:

uint64
sys_wait(void)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003492:	fe840593          	addi	a1,s0,-24
    80003496:	4501                	li	a0,0
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	eba080e7          	jalr	-326(ra) # 80003352 <argaddr>
  return wait(p);
    800034a0:	fe843503          	ld	a0,-24(s0)
    800034a4:	fffff097          	auipc	ra,0xfffff
    800034a8:	416080e7          	jalr	1046(ra) # 800028ba <wait>
}
    800034ac:	60e2                	ld	ra,24(sp)
    800034ae:	6442                	ld	s0,16(sp)
    800034b0:	6105                	addi	sp,sp,32
    800034b2:	8082                	ret

00000000800034b4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800034b4:	7179                	addi	sp,sp,-48
    800034b6:	f406                	sd	ra,40(sp)
    800034b8:	f022                	sd	s0,32(sp)
    800034ba:	ec26                	sd	s1,24(sp)
    800034bc:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800034be:	fdc40593          	addi	a1,s0,-36
    800034c2:	4501                	li	a0,0
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	e6e080e7          	jalr	-402(ra) # 80003332 <argint>
  addr = myproc()->sz;
    800034cc:	ffffe097          	auipc	ra,0xffffe
    800034d0:	71e080e7          	jalr	1822(ra) # 80001bea <myproc>
    800034d4:	22053483          	ld	s1,544(a0)
  if (growproc(n) < 0)
    800034d8:	fdc42503          	lw	a0,-36(s0)
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	af0080e7          	jalr	-1296(ra) # 80001fcc <growproc>
    800034e4:	00054863          	bltz	a0,800034f4 <sys_sbrk+0x40>
    return -1;
  return addr;
}
    800034e8:	8526                	mv	a0,s1
    800034ea:	70a2                	ld	ra,40(sp)
    800034ec:	7402                	ld	s0,32(sp)
    800034ee:	64e2                	ld	s1,24(sp)
    800034f0:	6145                	addi	sp,sp,48
    800034f2:	8082                	ret
    return -1;
    800034f4:	54fd                	li	s1,-1
    800034f6:	bfcd                	j	800034e8 <sys_sbrk+0x34>

00000000800034f8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800034f8:	7139                	addi	sp,sp,-64
    800034fa:	fc06                	sd	ra,56(sp)
    800034fc:	f822                	sd	s0,48(sp)
    800034fe:	f04a                	sd	s2,32(sp)
    80003500:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003502:	fcc40593          	addi	a1,s0,-52
    80003506:	4501                	li	a0,0
    80003508:	00000097          	auipc	ra,0x0
    8000350c:	e2a080e7          	jalr	-470(ra) # 80003332 <argint>
  acquire(&tickslock);
    80003510:	0001e517          	auipc	a0,0x1e
    80003514:	33050513          	addi	a0,a0,816 # 80021840 <tickslock>
    80003518:	ffffd097          	auipc	ra,0xffffd
    8000351c:	720080e7          	jalr	1824(ra) # 80000c38 <acquire>
  ticks0 = ticks;
    80003520:	00008917          	auipc	s2,0x8
    80003524:	f3492903          	lw	s2,-204(s2) # 8000b454 <ticks>
  while (ticks - ticks0 < n)
    80003528:	fcc42783          	lw	a5,-52(s0)
    8000352c:	c3b9                	beqz	a5,80003572 <sys_sleep+0x7a>
    8000352e:	f426                	sd	s1,40(sp)
    80003530:	ec4e                	sd	s3,24(sp)
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003532:	0001e997          	auipc	s3,0x1e
    80003536:	30e98993          	addi	s3,s3,782 # 80021840 <tickslock>
    8000353a:	00008497          	auipc	s1,0x8
    8000353e:	f1a48493          	addi	s1,s1,-230 # 8000b454 <ticks>
    if (killed(myproc()))
    80003542:	ffffe097          	auipc	ra,0xffffe
    80003546:	6a8080e7          	jalr	1704(ra) # 80001bea <myproc>
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	33e080e7          	jalr	830(ra) # 80002888 <killed>
    80003552:	ed15                	bnez	a0,8000358e <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003554:	85ce                	mv	a1,s3
    80003556:	8526                	mv	a0,s1
    80003558:	fffff097          	auipc	ra,0xfffff
    8000355c:	07c080e7          	jalr	124(ra) # 800025d4 <sleep>
  while (ticks - ticks0 < n)
    80003560:	409c                	lw	a5,0(s1)
    80003562:	412787bb          	subw	a5,a5,s2
    80003566:	fcc42703          	lw	a4,-52(s0)
    8000356a:	fce7ece3          	bltu	a5,a4,80003542 <sys_sleep+0x4a>
    8000356e:	74a2                	ld	s1,40(sp)
    80003570:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003572:	0001e517          	auipc	a0,0x1e
    80003576:	2ce50513          	addi	a0,a0,718 # 80021840 <tickslock>
    8000357a:	ffffd097          	auipc	ra,0xffffd
    8000357e:	772080e7          	jalr	1906(ra) # 80000cec <release>
  return 0;
    80003582:	4501                	li	a0,0
}
    80003584:	70e2                	ld	ra,56(sp)
    80003586:	7442                	ld	s0,48(sp)
    80003588:	7902                	ld	s2,32(sp)
    8000358a:	6121                	addi	sp,sp,64
    8000358c:	8082                	ret
      release(&tickslock);
    8000358e:	0001e517          	auipc	a0,0x1e
    80003592:	2b250513          	addi	a0,a0,690 # 80021840 <tickslock>
    80003596:	ffffd097          	auipc	ra,0xffffd
    8000359a:	756080e7          	jalr	1878(ra) # 80000cec <release>
      return -1;
    8000359e:	557d                	li	a0,-1
    800035a0:	74a2                	ld	s1,40(sp)
    800035a2:	69e2                	ld	s3,24(sp)
    800035a4:	b7c5                	j	80003584 <sys_sleep+0x8c>

00000000800035a6 <sys_kill>:

uint64
sys_kill(void)
{
    800035a6:	1101                	addi	sp,sp,-32
    800035a8:	ec06                	sd	ra,24(sp)
    800035aa:	e822                	sd	s0,16(sp)
    800035ac:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800035ae:	fec40593          	addi	a1,s0,-20
    800035b2:	4501                	li	a0,0
    800035b4:	00000097          	auipc	ra,0x0
    800035b8:	d7e080e7          	jalr	-642(ra) # 80003332 <argint>
  return kill(pid);
    800035bc:	fec42503          	lw	a0,-20(s0)
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	22a080e7          	jalr	554(ra) # 800027ea <kill>
}
    800035c8:	60e2                	ld	ra,24(sp)
    800035ca:	6442                	ld	s0,16(sp)
    800035cc:	6105                	addi	sp,sp,32
    800035ce:	8082                	ret

00000000800035d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800035d0:	1101                	addi	sp,sp,-32
    800035d2:	ec06                	sd	ra,24(sp)
    800035d4:	e822                	sd	s0,16(sp)
    800035d6:	e426                	sd	s1,8(sp)
    800035d8:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035da:	0001e517          	auipc	a0,0x1e
    800035de:	26650513          	addi	a0,a0,614 # 80021840 <tickslock>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	656080e7          	jalr	1622(ra) # 80000c38 <acquire>
  xticks = ticks;
    800035ea:	00008497          	auipc	s1,0x8
    800035ee:	e6a4a483          	lw	s1,-406(s1) # 8000b454 <ticks>
  release(&tickslock);
    800035f2:	0001e517          	auipc	a0,0x1e
    800035f6:	24e50513          	addi	a0,a0,590 # 80021840 <tickslock>
    800035fa:	ffffd097          	auipc	ra,0xffffd
    800035fe:	6f2080e7          	jalr	1778(ra) # 80000cec <release>
  return xticks;
}
    80003602:	02049513          	slli	a0,s1,0x20
    80003606:	9101                	srli	a0,a0,0x20
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003612:	7139                	addi	sp,sp,-64
    80003614:	fc06                	sd	ra,56(sp)
    80003616:	f822                	sd	s0,48(sp)
    80003618:	f426                	sd	s1,40(sp)
    8000361a:	f04a                	sd	s2,32(sp)
    8000361c:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000361e:	fd840593          	addi	a1,s0,-40
    80003622:	4501                	li	a0,0
    80003624:	00000097          	auipc	ra,0x0
    80003628:	d2e080e7          	jalr	-722(ra) # 80003352 <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000362c:	fd040593          	addi	a1,s0,-48
    80003630:	4505                	li	a0,1
    80003632:	00000097          	auipc	ra,0x0
    80003636:	d20080e7          	jalr	-736(ra) # 80003352 <argaddr>
  argaddr(2, &addr2);
    8000363a:	fc840593          	addi	a1,s0,-56
    8000363e:	4509                	li	a0,2
    80003640:	00000097          	auipc	ra,0x0
    80003644:	d12080e7          	jalr	-750(ra) # 80003352 <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    80003648:	fc040613          	addi	a2,s0,-64
    8000364c:	fc440593          	addi	a1,s0,-60
    80003650:	fd843503          	ld	a0,-40(s0)
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	5a4080e7          	jalr	1444(ra) # 80002bf8 <waitx>
    8000365c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000365e:	ffffe097          	auipc	ra,0xffffe
    80003662:	58c080e7          	jalr	1420(ra) # 80001bea <myproc>
    80003666:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003668:	4691                	li	a3,4
    8000366a:	fc440613          	addi	a2,s0,-60
    8000366e:	fd043583          	ld	a1,-48(s0)
    80003672:	22853503          	ld	a0,552(a0)
    80003676:	ffffe097          	auipc	ra,0xffffe
    8000367a:	06c080e7          	jalr	108(ra) # 800016e2 <copyout>
    return -1;
    8000367e:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003680:	02054063          	bltz	a0,800036a0 <sys_waitx+0x8e>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    80003684:	4691                	li	a3,4
    80003686:	fc040613          	addi	a2,s0,-64
    8000368a:	fc843583          	ld	a1,-56(s0)
    8000368e:	2284b503          	ld	a0,552(s1)
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	050080e7          	jalr	80(ra) # 800016e2 <copyout>
    8000369a:	00054a63          	bltz	a0,800036ae <sys_waitx+0x9c>
    return -1;
  return ret;
    8000369e:	87ca                	mv	a5,s2
}
    800036a0:	853e                	mv	a0,a5
    800036a2:	70e2                	ld	ra,56(sp)
    800036a4:	7442                	ld	s0,48(sp)
    800036a6:	74a2                	ld	s1,40(sp)
    800036a8:	7902                	ld	s2,32(sp)
    800036aa:	6121                	addi	sp,sp,64
    800036ac:	8082                	ret
    return -1;
    800036ae:	57fd                	li	a5,-1
    800036b0:	bfc5                	j	800036a0 <sys_waitx+0x8e>

00000000800036b2 <sys_getSysCount>:

uint64
sys_getSysCount(void)
{
    800036b2:	1101                	addi	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	1000                	addi	s0,sp,32
  int k;
  argint(0, &k);
    800036ba:	fec40593          	addi	a1,s0,-20
    800036be:	4501                	li	a0,0
    800036c0:	00000097          	auipc	ra,0x0
    800036c4:	c72080e7          	jalr	-910(ra) # 80003332 <argint>
  return myproc()->syscall_count[k];
    800036c8:	ffffe097          	auipc	ra,0xffffe
    800036cc:	522080e7          	jalr	1314(ra) # 80001bea <myproc>
    800036d0:	fec42783          	lw	a5,-20(s0)
    800036d4:	07c1                	addi	a5,a5,16
    800036d6:	078a                	slli	a5,a5,0x2
    800036d8:	953e                	add	a0,a0,a5
}
    800036da:	4108                	lw	a0,0(a0)
    800036dc:	60e2                	ld	ra,24(sp)
    800036de:	6442                	ld	s0,16(sp)
    800036e0:	6105                	addi	sp,sp,32
    800036e2:	8082                	ret

00000000800036e4 <sys_sigalarm>:

// In sysproc.c
uint64 sys_sigalarm(void)
{
    800036e4:	1101                	addi	sp,sp,-32
    800036e6:	ec06                	sd	ra,24(sp)
    800036e8:	e822                	sd	s0,16(sp)
    800036ea:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;

  argint(0, &interval);
    800036ec:	fec40593          	addi	a1,s0,-20
    800036f0:	4501                	li	a0,0
    800036f2:	00000097          	auipc	ra,0x0
    800036f6:	c40080e7          	jalr	-960(ra) # 80003332 <argint>
  if(interval < 0)
    800036fa:	fec42783          	lw	a5,-20(s0)
    return -1;
    800036fe:	557d                	li	a0,-1
  if(interval < 0)
    80003700:	0207c963          	bltz	a5,80003732 <sys_sigalarm+0x4e>
  
  argaddr(1, &handler);
    80003704:	fe040593          	addi	a1,s0,-32
    80003708:	4505                	li	a0,1
    8000370a:	00000097          	auipc	ra,0x0
    8000370e:	c48080e7          	jalr	-952(ra) # 80003352 <argaddr>
  if(handler < 0)
    return -1;

  struct proc *p = myproc();
    80003712:	ffffe097          	auipc	ra,0xffffe
    80003716:	4d8080e7          	jalr	1240(ra) # 80001bea <myproc>
  p->interval = interval;
    8000371a:	fec42783          	lw	a5,-20(s0)
    8000371e:	0cf52223          	sw	a5,196(a0)
  p->handler_addr = handler;
    80003722:	fe043783          	ld	a5,-32(s0)
    80003726:	e57c                	sd	a5,200(a0)
  p->ticks = 0;
    80003728:	0c052023          	sw	zero,192(a0)
  p->alarm_set = 0; 
    8000372c:	1e052823          	sw	zero,496(a0)

  return 0;
    80003730:	4501                	li	a0,0
}
    80003732:	60e2                	ld	ra,24(sp)
    80003734:	6442                	ld	s0,16(sp)
    80003736:	6105                	addi	sp,sp,32
    80003738:	8082                	ret

000000008000373a <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    8000373a:	1101                	addi	sp,sp,-32
    8000373c:	ec06                	sd	ra,24(sp)
    8000373e:	e822                	sd	s0,16(sp)
    80003740:	e426                	sd	s1,8(sp)
    80003742:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003744:	ffffe097          	auipc	ra,0xffffe
    80003748:	4a6080e7          	jalr	1190(ra) # 80001bea <myproc>
    8000374c:	84aa                	mv	s1,a0
  memmove(p->trapframe, &p->saved_alarm_tf, sizeof(struct trapframe));
    8000374e:	12000613          	li	a2,288
    80003752:	0d050593          	addi	a1,a0,208
    80003756:	23053503          	ld	a0,560(a0)
    8000375a:	ffffd097          	auipc	ra,0xffffd
    8000375e:	636080e7          	jalr	1590(ra) # 80000d90 <memmove>
  p->alarm_set = 0;                                         
    80003762:	1e04a823          	sw	zero,496(s1)
  return (uint64)p->trapframe->a0;
    80003766:	2304b783          	ld	a5,560(s1)
    8000376a:	7ba8                	ld	a0,112(a5)
    8000376c:	60e2                	ld	ra,24(sp)
    8000376e:	6442                	ld	s0,16(sp)
    80003770:	64a2                	ld	s1,8(sp)
    80003772:	6105                	addi	sp,sp,32
    80003774:	8082                	ret

0000000080003776 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003776:	7179                	addi	sp,sp,-48
    80003778:	f406                	sd	ra,40(sp)
    8000377a:	f022                	sd	s0,32(sp)
    8000377c:	ec26                	sd	s1,24(sp)
    8000377e:	e84a                	sd	s2,16(sp)
    80003780:	e44e                	sd	s3,8(sp)
    80003782:	e052                	sd	s4,0(sp)
    80003784:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003786:	00005597          	auipc	a1,0x5
    8000378a:	c8a58593          	addi	a1,a1,-886 # 80008410 <etext+0x410>
    8000378e:	0001e517          	auipc	a0,0x1e
    80003792:	0ca50513          	addi	a0,a0,202 # 80021858 <bcache>
    80003796:	ffffd097          	auipc	ra,0xffffd
    8000379a:	412080e7          	jalr	1042(ra) # 80000ba8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000379e:	00026797          	auipc	a5,0x26
    800037a2:	0ba78793          	addi	a5,a5,186 # 80029858 <bcache+0x8000>
    800037a6:	00026717          	auipc	a4,0x26
    800037aa:	31a70713          	addi	a4,a4,794 # 80029ac0 <bcache+0x8268>
    800037ae:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800037b2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800037b6:	0001e497          	auipc	s1,0x1e
    800037ba:	0ba48493          	addi	s1,s1,186 # 80021870 <bcache+0x18>
    b->next = bcache.head.next;
    800037be:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800037c0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800037c2:	00005a17          	auipc	s4,0x5
    800037c6:	c56a0a13          	addi	s4,s4,-938 # 80008418 <etext+0x418>
    b->next = bcache.head.next;
    800037ca:	2b893783          	ld	a5,696(s2)
    800037ce:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800037d0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800037d4:	85d2                	mv	a1,s4
    800037d6:	01048513          	addi	a0,s1,16
    800037da:	00001097          	auipc	ra,0x1
    800037de:	4e8080e7          	jalr	1256(ra) # 80004cc2 <initsleeplock>
    bcache.head.next->prev = b;
    800037e2:	2b893783          	ld	a5,696(s2)
    800037e6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800037e8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800037ec:	45848493          	addi	s1,s1,1112
    800037f0:	fd349de3          	bne	s1,s3,800037ca <binit+0x54>
  }
}
    800037f4:	70a2                	ld	ra,40(sp)
    800037f6:	7402                	ld	s0,32(sp)
    800037f8:	64e2                	ld	s1,24(sp)
    800037fa:	6942                	ld	s2,16(sp)
    800037fc:	69a2                	ld	s3,8(sp)
    800037fe:	6a02                	ld	s4,0(sp)
    80003800:	6145                	addi	sp,sp,48
    80003802:	8082                	ret

0000000080003804 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003804:	7179                	addi	sp,sp,-48
    80003806:	f406                	sd	ra,40(sp)
    80003808:	f022                	sd	s0,32(sp)
    8000380a:	ec26                	sd	s1,24(sp)
    8000380c:	e84a                	sd	s2,16(sp)
    8000380e:	e44e                	sd	s3,8(sp)
    80003810:	1800                	addi	s0,sp,48
    80003812:	892a                	mv	s2,a0
    80003814:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003816:	0001e517          	auipc	a0,0x1e
    8000381a:	04250513          	addi	a0,a0,66 # 80021858 <bcache>
    8000381e:	ffffd097          	auipc	ra,0xffffd
    80003822:	41a080e7          	jalr	1050(ra) # 80000c38 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003826:	00026497          	auipc	s1,0x26
    8000382a:	2ea4b483          	ld	s1,746(s1) # 80029b10 <bcache+0x82b8>
    8000382e:	00026797          	auipc	a5,0x26
    80003832:	29278793          	addi	a5,a5,658 # 80029ac0 <bcache+0x8268>
    80003836:	02f48f63          	beq	s1,a5,80003874 <bread+0x70>
    8000383a:	873e                	mv	a4,a5
    8000383c:	a021                	j	80003844 <bread+0x40>
    8000383e:	68a4                	ld	s1,80(s1)
    80003840:	02e48a63          	beq	s1,a4,80003874 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003844:	449c                	lw	a5,8(s1)
    80003846:	ff279ce3          	bne	a5,s2,8000383e <bread+0x3a>
    8000384a:	44dc                	lw	a5,12(s1)
    8000384c:	ff3799e3          	bne	a5,s3,8000383e <bread+0x3a>
      b->refcnt++;
    80003850:	40bc                	lw	a5,64(s1)
    80003852:	2785                	addiw	a5,a5,1
    80003854:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003856:	0001e517          	auipc	a0,0x1e
    8000385a:	00250513          	addi	a0,a0,2 # 80021858 <bcache>
    8000385e:	ffffd097          	auipc	ra,0xffffd
    80003862:	48e080e7          	jalr	1166(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    80003866:	01048513          	addi	a0,s1,16
    8000386a:	00001097          	auipc	ra,0x1
    8000386e:	492080e7          	jalr	1170(ra) # 80004cfc <acquiresleep>
      return b;
    80003872:	a8b9                	j	800038d0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003874:	00026497          	auipc	s1,0x26
    80003878:	2944b483          	ld	s1,660(s1) # 80029b08 <bcache+0x82b0>
    8000387c:	00026797          	auipc	a5,0x26
    80003880:	24478793          	addi	a5,a5,580 # 80029ac0 <bcache+0x8268>
    80003884:	00f48863          	beq	s1,a5,80003894 <bread+0x90>
    80003888:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000388a:	40bc                	lw	a5,64(s1)
    8000388c:	cf81                	beqz	a5,800038a4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000388e:	64a4                	ld	s1,72(s1)
    80003890:	fee49de3          	bne	s1,a4,8000388a <bread+0x86>
  panic("bget: no buffers");
    80003894:	00005517          	auipc	a0,0x5
    80003898:	b8c50513          	addi	a0,a0,-1140 # 80008420 <etext+0x420>
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	cc4080e7          	jalr	-828(ra) # 80000560 <panic>
      b->dev = dev;
    800038a4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800038a8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800038ac:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800038b0:	4785                	li	a5,1
    800038b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800038b4:	0001e517          	auipc	a0,0x1e
    800038b8:	fa450513          	addi	a0,a0,-92 # 80021858 <bcache>
    800038bc:	ffffd097          	auipc	ra,0xffffd
    800038c0:	430080e7          	jalr	1072(ra) # 80000cec <release>
      acquiresleep(&b->lock);
    800038c4:	01048513          	addi	a0,s1,16
    800038c8:	00001097          	auipc	ra,0x1
    800038cc:	434080e7          	jalr	1076(ra) # 80004cfc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800038d0:	409c                	lw	a5,0(s1)
    800038d2:	cb89                	beqz	a5,800038e4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800038d4:	8526                	mv	a0,s1
    800038d6:	70a2                	ld	ra,40(sp)
    800038d8:	7402                	ld	s0,32(sp)
    800038da:	64e2                	ld	s1,24(sp)
    800038dc:	6942                	ld	s2,16(sp)
    800038de:	69a2                	ld	s3,8(sp)
    800038e0:	6145                	addi	sp,sp,48
    800038e2:	8082                	ret
    virtio_disk_rw(b, 0);
    800038e4:	4581                	li	a1,0
    800038e6:	8526                	mv	a0,s1
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	100080e7          	jalr	256(ra) # 800069e8 <virtio_disk_rw>
    b->valid = 1;
    800038f0:	4785                	li	a5,1
    800038f2:	c09c                	sw	a5,0(s1)
  return b;
    800038f4:	b7c5                	j	800038d4 <bread+0xd0>

00000000800038f6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800038f6:	1101                	addi	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003902:	0541                	addi	a0,a0,16
    80003904:	00001097          	auipc	ra,0x1
    80003908:	492080e7          	jalr	1170(ra) # 80004d96 <holdingsleep>
    8000390c:	cd01                	beqz	a0,80003924 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000390e:	4585                	li	a1,1
    80003910:	8526                	mv	a0,s1
    80003912:	00003097          	auipc	ra,0x3
    80003916:	0d6080e7          	jalr	214(ra) # 800069e8 <virtio_disk_rw>
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6105                	addi	sp,sp,32
    80003922:	8082                	ret
    panic("bwrite");
    80003924:	00005517          	auipc	a0,0x5
    80003928:	b1450513          	addi	a0,a0,-1260 # 80008438 <etext+0x438>
    8000392c:	ffffd097          	auipc	ra,0xffffd
    80003930:	c34080e7          	jalr	-972(ra) # 80000560 <panic>

0000000080003934 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003934:	1101                	addi	sp,sp,-32
    80003936:	ec06                	sd	ra,24(sp)
    80003938:	e822                	sd	s0,16(sp)
    8000393a:	e426                	sd	s1,8(sp)
    8000393c:	e04a                	sd	s2,0(sp)
    8000393e:	1000                	addi	s0,sp,32
    80003940:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003942:	01050913          	addi	s2,a0,16
    80003946:	854a                	mv	a0,s2
    80003948:	00001097          	auipc	ra,0x1
    8000394c:	44e080e7          	jalr	1102(ra) # 80004d96 <holdingsleep>
    80003950:	c925                	beqz	a0,800039c0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80003952:	854a                	mv	a0,s2
    80003954:	00001097          	auipc	ra,0x1
    80003958:	3fe080e7          	jalr	1022(ra) # 80004d52 <releasesleep>

  acquire(&bcache.lock);
    8000395c:	0001e517          	auipc	a0,0x1e
    80003960:	efc50513          	addi	a0,a0,-260 # 80021858 <bcache>
    80003964:	ffffd097          	auipc	ra,0xffffd
    80003968:	2d4080e7          	jalr	724(ra) # 80000c38 <acquire>
  b->refcnt--;
    8000396c:	40bc                	lw	a5,64(s1)
    8000396e:	37fd                	addiw	a5,a5,-1
    80003970:	0007871b          	sext.w	a4,a5
    80003974:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003976:	e71d                	bnez	a4,800039a4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003978:	68b8                	ld	a4,80(s1)
    8000397a:	64bc                	ld	a5,72(s1)
    8000397c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000397e:	68b8                	ld	a4,80(s1)
    80003980:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003982:	00026797          	auipc	a5,0x26
    80003986:	ed678793          	addi	a5,a5,-298 # 80029858 <bcache+0x8000>
    8000398a:	2b87b703          	ld	a4,696(a5)
    8000398e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003990:	00026717          	auipc	a4,0x26
    80003994:	13070713          	addi	a4,a4,304 # 80029ac0 <bcache+0x8268>
    80003998:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000399a:	2b87b703          	ld	a4,696(a5)
    8000399e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800039a0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800039a4:	0001e517          	auipc	a0,0x1e
    800039a8:	eb450513          	addi	a0,a0,-332 # 80021858 <bcache>
    800039ac:	ffffd097          	auipc	ra,0xffffd
    800039b0:	340080e7          	jalr	832(ra) # 80000cec <release>
}
    800039b4:	60e2                	ld	ra,24(sp)
    800039b6:	6442                	ld	s0,16(sp)
    800039b8:	64a2                	ld	s1,8(sp)
    800039ba:	6902                	ld	s2,0(sp)
    800039bc:	6105                	addi	sp,sp,32
    800039be:	8082                	ret
    panic("brelse");
    800039c0:	00005517          	auipc	a0,0x5
    800039c4:	a8050513          	addi	a0,a0,-1408 # 80008440 <etext+0x440>
    800039c8:	ffffd097          	auipc	ra,0xffffd
    800039cc:	b98080e7          	jalr	-1128(ra) # 80000560 <panic>

00000000800039d0 <bpin>:

void
bpin(struct buf *b) {
    800039d0:	1101                	addi	sp,sp,-32
    800039d2:	ec06                	sd	ra,24(sp)
    800039d4:	e822                	sd	s0,16(sp)
    800039d6:	e426                	sd	s1,8(sp)
    800039d8:	1000                	addi	s0,sp,32
    800039da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800039dc:	0001e517          	auipc	a0,0x1e
    800039e0:	e7c50513          	addi	a0,a0,-388 # 80021858 <bcache>
    800039e4:	ffffd097          	auipc	ra,0xffffd
    800039e8:	254080e7          	jalr	596(ra) # 80000c38 <acquire>
  b->refcnt++;
    800039ec:	40bc                	lw	a5,64(s1)
    800039ee:	2785                	addiw	a5,a5,1
    800039f0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800039f2:	0001e517          	auipc	a0,0x1e
    800039f6:	e6650513          	addi	a0,a0,-410 # 80021858 <bcache>
    800039fa:	ffffd097          	auipc	ra,0xffffd
    800039fe:	2f2080e7          	jalr	754(ra) # 80000cec <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret

0000000080003a0c <bunpin>:

void
bunpin(struct buf *b) {
    80003a0c:	1101                	addi	sp,sp,-32
    80003a0e:	ec06                	sd	ra,24(sp)
    80003a10:	e822                	sd	s0,16(sp)
    80003a12:	e426                	sd	s1,8(sp)
    80003a14:	1000                	addi	s0,sp,32
    80003a16:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003a18:	0001e517          	auipc	a0,0x1e
    80003a1c:	e4050513          	addi	a0,a0,-448 # 80021858 <bcache>
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	218080e7          	jalr	536(ra) # 80000c38 <acquire>
  b->refcnt--;
    80003a28:	40bc                	lw	a5,64(s1)
    80003a2a:	37fd                	addiw	a5,a5,-1
    80003a2c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003a2e:	0001e517          	auipc	a0,0x1e
    80003a32:	e2a50513          	addi	a0,a0,-470 # 80021858 <bcache>
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	2b6080e7          	jalr	694(ra) # 80000cec <release>
}
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	e04a                	sd	s2,0(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003a56:	00d5d59b          	srliw	a1,a1,0xd
    80003a5a:	00026797          	auipc	a5,0x26
    80003a5e:	4da7a783          	lw	a5,1242(a5) # 80029f34 <sb+0x1c>
    80003a62:	9dbd                	addw	a1,a1,a5
    80003a64:	00000097          	auipc	ra,0x0
    80003a68:	da0080e7          	jalr	-608(ra) # 80003804 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003a6c:	0074f713          	andi	a4,s1,7
    80003a70:	4785                	li	a5,1
    80003a72:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003a76:	14ce                	slli	s1,s1,0x33
    80003a78:	90d9                	srli	s1,s1,0x36
    80003a7a:	00950733          	add	a4,a0,s1
    80003a7e:	05874703          	lbu	a4,88(a4)
    80003a82:	00e7f6b3          	and	a3,a5,a4
    80003a86:	c69d                	beqz	a3,80003ab4 <bfree+0x6c>
    80003a88:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003a8a:	94aa                	add	s1,s1,a0
    80003a8c:	fff7c793          	not	a5,a5
    80003a90:	8f7d                	and	a4,a4,a5
    80003a92:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003a96:	00001097          	auipc	ra,0x1
    80003a9a:	148080e7          	jalr	328(ra) # 80004bde <log_write>
  brelse(bp);
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	00000097          	auipc	ra,0x0
    80003aa4:	e94080e7          	jalr	-364(ra) # 80003934 <brelse>
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret
    panic("freeing free block");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	99450513          	addi	a0,a0,-1644 # 80008448 <etext+0x448>
    80003abc:	ffffd097          	auipc	ra,0xffffd
    80003ac0:	aa4080e7          	jalr	-1372(ra) # 80000560 <panic>

0000000080003ac4 <balloc>:
{
    80003ac4:	711d                	addi	sp,sp,-96
    80003ac6:	ec86                	sd	ra,88(sp)
    80003ac8:	e8a2                	sd	s0,80(sp)
    80003aca:	e4a6                	sd	s1,72(sp)
    80003acc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003ace:	00026797          	auipc	a5,0x26
    80003ad2:	44e7a783          	lw	a5,1102(a5) # 80029f1c <sb+0x4>
    80003ad6:	10078f63          	beqz	a5,80003bf4 <balloc+0x130>
    80003ada:	e0ca                	sd	s2,64(sp)
    80003adc:	fc4e                	sd	s3,56(sp)
    80003ade:	f852                	sd	s4,48(sp)
    80003ae0:	f456                	sd	s5,40(sp)
    80003ae2:	f05a                	sd	s6,32(sp)
    80003ae4:	ec5e                	sd	s7,24(sp)
    80003ae6:	e862                	sd	s8,16(sp)
    80003ae8:	e466                	sd	s9,8(sp)
    80003aea:	8baa                	mv	s7,a0
    80003aec:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003aee:	00026b17          	auipc	s6,0x26
    80003af2:	42ab0b13          	addi	s6,s6,1066 # 80029f18 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003af6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003af8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003afa:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003afc:	6c89                	lui	s9,0x2
    80003afe:	a061                	j	80003b86 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003b00:	97ca                	add	a5,a5,s2
    80003b02:	8e55                	or	a2,a2,a3
    80003b04:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003b08:	854a                	mv	a0,s2
    80003b0a:	00001097          	auipc	ra,0x1
    80003b0e:	0d4080e7          	jalr	212(ra) # 80004bde <log_write>
        brelse(bp);
    80003b12:	854a                	mv	a0,s2
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	e20080e7          	jalr	-480(ra) # 80003934 <brelse>
  bp = bread(dev, bno);
    80003b1c:	85a6                	mv	a1,s1
    80003b1e:	855e                	mv	a0,s7
    80003b20:	00000097          	auipc	ra,0x0
    80003b24:	ce4080e7          	jalr	-796(ra) # 80003804 <bread>
    80003b28:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003b2a:	40000613          	li	a2,1024
    80003b2e:	4581                	li	a1,0
    80003b30:	05850513          	addi	a0,a0,88
    80003b34:	ffffd097          	auipc	ra,0xffffd
    80003b38:	200080e7          	jalr	512(ra) # 80000d34 <memset>
  log_write(bp);
    80003b3c:	854a                	mv	a0,s2
    80003b3e:	00001097          	auipc	ra,0x1
    80003b42:	0a0080e7          	jalr	160(ra) # 80004bde <log_write>
  brelse(bp);
    80003b46:	854a                	mv	a0,s2
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	dec080e7          	jalr	-532(ra) # 80003934 <brelse>
}
    80003b50:	6906                	ld	s2,64(sp)
    80003b52:	79e2                	ld	s3,56(sp)
    80003b54:	7a42                	ld	s4,48(sp)
    80003b56:	7aa2                	ld	s5,40(sp)
    80003b58:	7b02                	ld	s6,32(sp)
    80003b5a:	6be2                	ld	s7,24(sp)
    80003b5c:	6c42                	ld	s8,16(sp)
    80003b5e:	6ca2                	ld	s9,8(sp)
}
    80003b60:	8526                	mv	a0,s1
    80003b62:	60e6                	ld	ra,88(sp)
    80003b64:	6446                	ld	s0,80(sp)
    80003b66:	64a6                	ld	s1,72(sp)
    80003b68:	6125                	addi	sp,sp,96
    80003b6a:	8082                	ret
    brelse(bp);
    80003b6c:	854a                	mv	a0,s2
    80003b6e:	00000097          	auipc	ra,0x0
    80003b72:	dc6080e7          	jalr	-570(ra) # 80003934 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003b76:	015c87bb          	addw	a5,s9,s5
    80003b7a:	00078a9b          	sext.w	s5,a5
    80003b7e:	004b2703          	lw	a4,4(s6)
    80003b82:	06eaf163          	bgeu	s5,a4,80003be4 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80003b86:	41fad79b          	sraiw	a5,s5,0x1f
    80003b8a:	0137d79b          	srliw	a5,a5,0x13
    80003b8e:	015787bb          	addw	a5,a5,s5
    80003b92:	40d7d79b          	sraiw	a5,a5,0xd
    80003b96:	01cb2583          	lw	a1,28(s6)
    80003b9a:	9dbd                	addw	a1,a1,a5
    80003b9c:	855e                	mv	a0,s7
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	c66080e7          	jalr	-922(ra) # 80003804 <bread>
    80003ba6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003ba8:	004b2503          	lw	a0,4(s6)
    80003bac:	000a849b          	sext.w	s1,s5
    80003bb0:	8762                	mv	a4,s8
    80003bb2:	faa4fde3          	bgeu	s1,a0,80003b6c <balloc+0xa8>
      m = 1 << (bi % 8);
    80003bb6:	00777693          	andi	a3,a4,7
    80003bba:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003bbe:	41f7579b          	sraiw	a5,a4,0x1f
    80003bc2:	01d7d79b          	srliw	a5,a5,0x1d
    80003bc6:	9fb9                	addw	a5,a5,a4
    80003bc8:	4037d79b          	sraiw	a5,a5,0x3
    80003bcc:	00f90633          	add	a2,s2,a5
    80003bd0:	05864603          	lbu	a2,88(a2)
    80003bd4:	00c6f5b3          	and	a1,a3,a2
    80003bd8:	d585                	beqz	a1,80003b00 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003bda:	2705                	addiw	a4,a4,1
    80003bdc:	2485                	addiw	s1,s1,1
    80003bde:	fd471ae3          	bne	a4,s4,80003bb2 <balloc+0xee>
    80003be2:	b769                	j	80003b6c <balloc+0xa8>
    80003be4:	6906                	ld	s2,64(sp)
    80003be6:	79e2                	ld	s3,56(sp)
    80003be8:	7a42                	ld	s4,48(sp)
    80003bea:	7aa2                	ld	s5,40(sp)
    80003bec:	7b02                	ld	s6,32(sp)
    80003bee:	6be2                	ld	s7,24(sp)
    80003bf0:	6c42                	ld	s8,16(sp)
    80003bf2:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003bf4:	00005517          	auipc	a0,0x5
    80003bf8:	86c50513          	addi	a0,a0,-1940 # 80008460 <etext+0x460>
    80003bfc:	ffffd097          	auipc	ra,0xffffd
    80003c00:	9ae080e7          	jalr	-1618(ra) # 800005aa <printf>
  return 0;
    80003c04:	4481                	li	s1,0
    80003c06:	bfa9                	j	80003b60 <balloc+0x9c>

0000000080003c08 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003c08:	7179                	addi	sp,sp,-48
    80003c0a:	f406                	sd	ra,40(sp)
    80003c0c:	f022                	sd	s0,32(sp)
    80003c0e:	ec26                	sd	s1,24(sp)
    80003c10:	e84a                	sd	s2,16(sp)
    80003c12:	e44e                	sd	s3,8(sp)
    80003c14:	1800                	addi	s0,sp,48
    80003c16:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003c18:	47ad                	li	a5,11
    80003c1a:	02b7e863          	bltu	a5,a1,80003c4a <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003c1e:	02059793          	slli	a5,a1,0x20
    80003c22:	01e7d593          	srli	a1,a5,0x1e
    80003c26:	00b504b3          	add	s1,a0,a1
    80003c2a:	0504a903          	lw	s2,80(s1)
    80003c2e:	08091263          	bnez	s2,80003cb2 <bmap+0xaa>
      addr = balloc(ip->dev);
    80003c32:	4108                	lw	a0,0(a0)
    80003c34:	00000097          	auipc	ra,0x0
    80003c38:	e90080e7          	jalr	-368(ra) # 80003ac4 <balloc>
    80003c3c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c40:	06090963          	beqz	s2,80003cb2 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80003c44:	0524a823          	sw	s2,80(s1)
    80003c48:	a0ad                	j	80003cb2 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003c4a:	ff45849b          	addiw	s1,a1,-12
    80003c4e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003c52:	0ff00793          	li	a5,255
    80003c56:	08e7e863          	bltu	a5,a4,80003ce6 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003c5a:	08052903          	lw	s2,128(a0)
    80003c5e:	00091f63          	bnez	s2,80003c7c <bmap+0x74>
      addr = balloc(ip->dev);
    80003c62:	4108                	lw	a0,0(a0)
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	e60080e7          	jalr	-416(ra) # 80003ac4 <balloc>
    80003c6c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c70:	04090163          	beqz	s2,80003cb2 <bmap+0xaa>
    80003c74:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003c76:	0929a023          	sw	s2,128(s3)
    80003c7a:	a011                	j	80003c7e <bmap+0x76>
    80003c7c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003c7e:	85ca                	mv	a1,s2
    80003c80:	0009a503          	lw	a0,0(s3)
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	b80080e7          	jalr	-1152(ra) # 80003804 <bread>
    80003c8c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003c8e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003c92:	02049713          	slli	a4,s1,0x20
    80003c96:	01e75593          	srli	a1,a4,0x1e
    80003c9a:	00b784b3          	add	s1,a5,a1
    80003c9e:	0004a903          	lw	s2,0(s1)
    80003ca2:	02090063          	beqz	s2,80003cc2 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003ca6:	8552                	mv	a0,s4
    80003ca8:	00000097          	auipc	ra,0x0
    80003cac:	c8c080e7          	jalr	-884(ra) # 80003934 <brelse>
    return addr;
    80003cb0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003cb2:	854a                	mv	a0,s2
    80003cb4:	70a2                	ld	ra,40(sp)
    80003cb6:	7402                	ld	s0,32(sp)
    80003cb8:	64e2                	ld	s1,24(sp)
    80003cba:	6942                	ld	s2,16(sp)
    80003cbc:	69a2                	ld	s3,8(sp)
    80003cbe:	6145                	addi	sp,sp,48
    80003cc0:	8082                	ret
      addr = balloc(ip->dev);
    80003cc2:	0009a503          	lw	a0,0(s3)
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	dfe080e7          	jalr	-514(ra) # 80003ac4 <balloc>
    80003cce:	0005091b          	sext.w	s2,a0
      if(addr){
    80003cd2:	fc090ae3          	beqz	s2,80003ca6 <bmap+0x9e>
        a[bn] = addr;
    80003cd6:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003cda:	8552                	mv	a0,s4
    80003cdc:	00001097          	auipc	ra,0x1
    80003ce0:	f02080e7          	jalr	-254(ra) # 80004bde <log_write>
    80003ce4:	b7c9                	j	80003ca6 <bmap+0x9e>
    80003ce6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003ce8:	00004517          	auipc	a0,0x4
    80003cec:	79050513          	addi	a0,a0,1936 # 80008478 <etext+0x478>
    80003cf0:	ffffd097          	auipc	ra,0xffffd
    80003cf4:	870080e7          	jalr	-1936(ra) # 80000560 <panic>

0000000080003cf8 <iget>:
{
    80003cf8:	7179                	addi	sp,sp,-48
    80003cfa:	f406                	sd	ra,40(sp)
    80003cfc:	f022                	sd	s0,32(sp)
    80003cfe:	ec26                	sd	s1,24(sp)
    80003d00:	e84a                	sd	s2,16(sp)
    80003d02:	e44e                	sd	s3,8(sp)
    80003d04:	e052                	sd	s4,0(sp)
    80003d06:	1800                	addi	s0,sp,48
    80003d08:	89aa                	mv	s3,a0
    80003d0a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003d0c:	00026517          	auipc	a0,0x26
    80003d10:	22c50513          	addi	a0,a0,556 # 80029f38 <itable>
    80003d14:	ffffd097          	auipc	ra,0xffffd
    80003d18:	f24080e7          	jalr	-220(ra) # 80000c38 <acquire>
  empty = 0;
    80003d1c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003d1e:	00026497          	auipc	s1,0x26
    80003d22:	23248493          	addi	s1,s1,562 # 80029f50 <itable+0x18>
    80003d26:	00028697          	auipc	a3,0x28
    80003d2a:	cba68693          	addi	a3,a3,-838 # 8002b9e0 <log>
    80003d2e:	a039                	j	80003d3c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003d30:	02090b63          	beqz	s2,80003d66 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003d34:	08848493          	addi	s1,s1,136
    80003d38:	02d48a63          	beq	s1,a3,80003d6c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003d3c:	449c                	lw	a5,8(s1)
    80003d3e:	fef059e3          	blez	a5,80003d30 <iget+0x38>
    80003d42:	4098                	lw	a4,0(s1)
    80003d44:	ff3716e3          	bne	a4,s3,80003d30 <iget+0x38>
    80003d48:	40d8                	lw	a4,4(s1)
    80003d4a:	ff4713e3          	bne	a4,s4,80003d30 <iget+0x38>
      ip->ref++;
    80003d4e:	2785                	addiw	a5,a5,1
    80003d50:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003d52:	00026517          	auipc	a0,0x26
    80003d56:	1e650513          	addi	a0,a0,486 # 80029f38 <itable>
    80003d5a:	ffffd097          	auipc	ra,0xffffd
    80003d5e:	f92080e7          	jalr	-110(ra) # 80000cec <release>
      return ip;
    80003d62:	8926                	mv	s2,s1
    80003d64:	a03d                	j	80003d92 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003d66:	f7f9                	bnez	a5,80003d34 <iget+0x3c>
      empty = ip;
    80003d68:	8926                	mv	s2,s1
    80003d6a:	b7e9                	j	80003d34 <iget+0x3c>
  if(empty == 0)
    80003d6c:	02090c63          	beqz	s2,80003da4 <iget+0xac>
  ip->dev = dev;
    80003d70:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003d74:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003d78:	4785                	li	a5,1
    80003d7a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003d7e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003d82:	00026517          	auipc	a0,0x26
    80003d86:	1b650513          	addi	a0,a0,438 # 80029f38 <itable>
    80003d8a:	ffffd097          	auipc	ra,0xffffd
    80003d8e:	f62080e7          	jalr	-158(ra) # 80000cec <release>
}
    80003d92:	854a                	mv	a0,s2
    80003d94:	70a2                	ld	ra,40(sp)
    80003d96:	7402                	ld	s0,32(sp)
    80003d98:	64e2                	ld	s1,24(sp)
    80003d9a:	6942                	ld	s2,16(sp)
    80003d9c:	69a2                	ld	s3,8(sp)
    80003d9e:	6a02                	ld	s4,0(sp)
    80003da0:	6145                	addi	sp,sp,48
    80003da2:	8082                	ret
    panic("iget: no inodes");
    80003da4:	00004517          	auipc	a0,0x4
    80003da8:	6ec50513          	addi	a0,a0,1772 # 80008490 <etext+0x490>
    80003dac:	ffffc097          	auipc	ra,0xffffc
    80003db0:	7b4080e7          	jalr	1972(ra) # 80000560 <panic>

0000000080003db4 <fsinit>:
fsinit(int dev) {
    80003db4:	7179                	addi	sp,sp,-48
    80003db6:	f406                	sd	ra,40(sp)
    80003db8:	f022                	sd	s0,32(sp)
    80003dba:	ec26                	sd	s1,24(sp)
    80003dbc:	e84a                	sd	s2,16(sp)
    80003dbe:	e44e                	sd	s3,8(sp)
    80003dc0:	1800                	addi	s0,sp,48
    80003dc2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003dc4:	4585                	li	a1,1
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	a3e080e7          	jalr	-1474(ra) # 80003804 <bread>
    80003dce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003dd0:	00026997          	auipc	s3,0x26
    80003dd4:	14898993          	addi	s3,s3,328 # 80029f18 <sb>
    80003dd8:	02000613          	li	a2,32
    80003ddc:	05850593          	addi	a1,a0,88
    80003de0:	854e                	mv	a0,s3
    80003de2:	ffffd097          	auipc	ra,0xffffd
    80003de6:	fae080e7          	jalr	-82(ra) # 80000d90 <memmove>
  brelse(bp);
    80003dea:	8526                	mv	a0,s1
    80003dec:	00000097          	auipc	ra,0x0
    80003df0:	b48080e7          	jalr	-1208(ra) # 80003934 <brelse>
  if(sb.magic != FSMAGIC)
    80003df4:	0009a703          	lw	a4,0(s3)
    80003df8:	102037b7          	lui	a5,0x10203
    80003dfc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003e00:	02f71263          	bne	a4,a5,80003e24 <fsinit+0x70>
  initlog(dev, &sb);
    80003e04:	00026597          	auipc	a1,0x26
    80003e08:	11458593          	addi	a1,a1,276 # 80029f18 <sb>
    80003e0c:	854a                	mv	a0,s2
    80003e0e:	00001097          	auipc	ra,0x1
    80003e12:	b60080e7          	jalr	-1184(ra) # 8000496e <initlog>
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	69a2                	ld	s3,8(sp)
    80003e20:	6145                	addi	sp,sp,48
    80003e22:	8082                	ret
    panic("invalid file system");
    80003e24:	00004517          	auipc	a0,0x4
    80003e28:	67c50513          	addi	a0,a0,1660 # 800084a0 <etext+0x4a0>
    80003e2c:	ffffc097          	auipc	ra,0xffffc
    80003e30:	734080e7          	jalr	1844(ra) # 80000560 <panic>

0000000080003e34 <iinit>:
{
    80003e34:	7179                	addi	sp,sp,-48
    80003e36:	f406                	sd	ra,40(sp)
    80003e38:	f022                	sd	s0,32(sp)
    80003e3a:	ec26                	sd	s1,24(sp)
    80003e3c:	e84a                	sd	s2,16(sp)
    80003e3e:	e44e                	sd	s3,8(sp)
    80003e40:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003e42:	00004597          	auipc	a1,0x4
    80003e46:	67658593          	addi	a1,a1,1654 # 800084b8 <etext+0x4b8>
    80003e4a:	00026517          	auipc	a0,0x26
    80003e4e:	0ee50513          	addi	a0,a0,238 # 80029f38 <itable>
    80003e52:	ffffd097          	auipc	ra,0xffffd
    80003e56:	d56080e7          	jalr	-682(ra) # 80000ba8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003e5a:	00026497          	auipc	s1,0x26
    80003e5e:	10648493          	addi	s1,s1,262 # 80029f60 <itable+0x28>
    80003e62:	00028997          	auipc	s3,0x28
    80003e66:	b8e98993          	addi	s3,s3,-1138 # 8002b9f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003e6a:	00004917          	auipc	s2,0x4
    80003e6e:	65690913          	addi	s2,s2,1622 # 800084c0 <etext+0x4c0>
    80003e72:	85ca                	mv	a1,s2
    80003e74:	8526                	mv	a0,s1
    80003e76:	00001097          	auipc	ra,0x1
    80003e7a:	e4c080e7          	jalr	-436(ra) # 80004cc2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003e7e:	08848493          	addi	s1,s1,136
    80003e82:	ff3498e3          	bne	s1,s3,80003e72 <iinit+0x3e>
}
    80003e86:	70a2                	ld	ra,40(sp)
    80003e88:	7402                	ld	s0,32(sp)
    80003e8a:	64e2                	ld	s1,24(sp)
    80003e8c:	6942                	ld	s2,16(sp)
    80003e8e:	69a2                	ld	s3,8(sp)
    80003e90:	6145                	addi	sp,sp,48
    80003e92:	8082                	ret

0000000080003e94 <ialloc>:
{
    80003e94:	7139                	addi	sp,sp,-64
    80003e96:	fc06                	sd	ra,56(sp)
    80003e98:	f822                	sd	s0,48(sp)
    80003e9a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e9c:	00026717          	auipc	a4,0x26
    80003ea0:	08872703          	lw	a4,136(a4) # 80029f24 <sb+0xc>
    80003ea4:	4785                	li	a5,1
    80003ea6:	06e7f463          	bgeu	a5,a4,80003f0e <ialloc+0x7a>
    80003eaa:	f426                	sd	s1,40(sp)
    80003eac:	f04a                	sd	s2,32(sp)
    80003eae:	ec4e                	sd	s3,24(sp)
    80003eb0:	e852                	sd	s4,16(sp)
    80003eb2:	e456                	sd	s5,8(sp)
    80003eb4:	e05a                	sd	s6,0(sp)
    80003eb6:	8aaa                	mv	s5,a0
    80003eb8:	8b2e                	mv	s6,a1
    80003eba:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003ebc:	00026a17          	auipc	s4,0x26
    80003ec0:	05ca0a13          	addi	s4,s4,92 # 80029f18 <sb>
    80003ec4:	00495593          	srli	a1,s2,0x4
    80003ec8:	018a2783          	lw	a5,24(s4)
    80003ecc:	9dbd                	addw	a1,a1,a5
    80003ece:	8556                	mv	a0,s5
    80003ed0:	00000097          	auipc	ra,0x0
    80003ed4:	934080e7          	jalr	-1740(ra) # 80003804 <bread>
    80003ed8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003eda:	05850993          	addi	s3,a0,88
    80003ede:	00f97793          	andi	a5,s2,15
    80003ee2:	079a                	slli	a5,a5,0x6
    80003ee4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003ee6:	00099783          	lh	a5,0(s3)
    80003eea:	cf9d                	beqz	a5,80003f28 <ialloc+0x94>
    brelse(bp);
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	a48080e7          	jalr	-1464(ra) # 80003934 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003ef4:	0905                	addi	s2,s2,1
    80003ef6:	00ca2703          	lw	a4,12(s4)
    80003efa:	0009079b          	sext.w	a5,s2
    80003efe:	fce7e3e3          	bltu	a5,a4,80003ec4 <ialloc+0x30>
    80003f02:	74a2                	ld	s1,40(sp)
    80003f04:	7902                	ld	s2,32(sp)
    80003f06:	69e2                	ld	s3,24(sp)
    80003f08:	6a42                	ld	s4,16(sp)
    80003f0a:	6aa2                	ld	s5,8(sp)
    80003f0c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003f0e:	00004517          	auipc	a0,0x4
    80003f12:	5ba50513          	addi	a0,a0,1466 # 800084c8 <etext+0x4c8>
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	694080e7          	jalr	1684(ra) # 800005aa <printf>
  return 0;
    80003f1e:	4501                	li	a0,0
}
    80003f20:	70e2                	ld	ra,56(sp)
    80003f22:	7442                	ld	s0,48(sp)
    80003f24:	6121                	addi	sp,sp,64
    80003f26:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003f28:	04000613          	li	a2,64
    80003f2c:	4581                	li	a1,0
    80003f2e:	854e                	mv	a0,s3
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	e04080e7          	jalr	-508(ra) # 80000d34 <memset>
      dip->type = type;
    80003f38:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00001097          	auipc	ra,0x1
    80003f42:	ca0080e7          	jalr	-864(ra) # 80004bde <log_write>
      brelse(bp);
    80003f46:	8526                	mv	a0,s1
    80003f48:	00000097          	auipc	ra,0x0
    80003f4c:	9ec080e7          	jalr	-1556(ra) # 80003934 <brelse>
      return iget(dev, inum);
    80003f50:	0009059b          	sext.w	a1,s2
    80003f54:	8556                	mv	a0,s5
    80003f56:	00000097          	auipc	ra,0x0
    80003f5a:	da2080e7          	jalr	-606(ra) # 80003cf8 <iget>
    80003f5e:	74a2                	ld	s1,40(sp)
    80003f60:	7902                	ld	s2,32(sp)
    80003f62:	69e2                	ld	s3,24(sp)
    80003f64:	6a42                	ld	s4,16(sp)
    80003f66:	6aa2                	ld	s5,8(sp)
    80003f68:	6b02                	ld	s6,0(sp)
    80003f6a:	bf5d                	j	80003f20 <ialloc+0x8c>

0000000080003f6c <iupdate>:
{
    80003f6c:	1101                	addi	sp,sp,-32
    80003f6e:	ec06                	sd	ra,24(sp)
    80003f70:	e822                	sd	s0,16(sp)
    80003f72:	e426                	sd	s1,8(sp)
    80003f74:	e04a                	sd	s2,0(sp)
    80003f76:	1000                	addi	s0,sp,32
    80003f78:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f7a:	415c                	lw	a5,4(a0)
    80003f7c:	0047d79b          	srliw	a5,a5,0x4
    80003f80:	00026597          	auipc	a1,0x26
    80003f84:	fb05a583          	lw	a1,-80(a1) # 80029f30 <sb+0x18>
    80003f88:	9dbd                	addw	a1,a1,a5
    80003f8a:	4108                	lw	a0,0(a0)
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	878080e7          	jalr	-1928(ra) # 80003804 <bread>
    80003f94:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f96:	05850793          	addi	a5,a0,88
    80003f9a:	40d8                	lw	a4,4(s1)
    80003f9c:	8b3d                	andi	a4,a4,15
    80003f9e:	071a                	slli	a4,a4,0x6
    80003fa0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003fa2:	04449703          	lh	a4,68(s1)
    80003fa6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003faa:	04649703          	lh	a4,70(s1)
    80003fae:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003fb2:	04849703          	lh	a4,72(s1)
    80003fb6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003fba:	04a49703          	lh	a4,74(s1)
    80003fbe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003fc2:	44f8                	lw	a4,76(s1)
    80003fc4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003fc6:	03400613          	li	a2,52
    80003fca:	05048593          	addi	a1,s1,80
    80003fce:	00c78513          	addi	a0,a5,12
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	dbe080e7          	jalr	-578(ra) # 80000d90 <memmove>
  log_write(bp);
    80003fda:	854a                	mv	a0,s2
    80003fdc:	00001097          	auipc	ra,0x1
    80003fe0:	c02080e7          	jalr	-1022(ra) # 80004bde <log_write>
  brelse(bp);
    80003fe4:	854a                	mv	a0,s2
    80003fe6:	00000097          	auipc	ra,0x0
    80003fea:	94e080e7          	jalr	-1714(ra) # 80003934 <brelse>
}
    80003fee:	60e2                	ld	ra,24(sp)
    80003ff0:	6442                	ld	s0,16(sp)
    80003ff2:	64a2                	ld	s1,8(sp)
    80003ff4:	6902                	ld	s2,0(sp)
    80003ff6:	6105                	addi	sp,sp,32
    80003ff8:	8082                	ret

0000000080003ffa <idup>:
{
    80003ffa:	1101                	addi	sp,sp,-32
    80003ffc:	ec06                	sd	ra,24(sp)
    80003ffe:	e822                	sd	s0,16(sp)
    80004000:	e426                	sd	s1,8(sp)
    80004002:	1000                	addi	s0,sp,32
    80004004:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004006:	00026517          	auipc	a0,0x26
    8000400a:	f3250513          	addi	a0,a0,-206 # 80029f38 <itable>
    8000400e:	ffffd097          	auipc	ra,0xffffd
    80004012:	c2a080e7          	jalr	-982(ra) # 80000c38 <acquire>
  ip->ref++;
    80004016:	449c                	lw	a5,8(s1)
    80004018:	2785                	addiw	a5,a5,1
    8000401a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000401c:	00026517          	auipc	a0,0x26
    80004020:	f1c50513          	addi	a0,a0,-228 # 80029f38 <itable>
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	cc8080e7          	jalr	-824(ra) # 80000cec <release>
}
    8000402c:	8526                	mv	a0,s1
    8000402e:	60e2                	ld	ra,24(sp)
    80004030:	6442                	ld	s0,16(sp)
    80004032:	64a2                	ld	s1,8(sp)
    80004034:	6105                	addi	sp,sp,32
    80004036:	8082                	ret

0000000080004038 <ilock>:
{
    80004038:	1101                	addi	sp,sp,-32
    8000403a:	ec06                	sd	ra,24(sp)
    8000403c:	e822                	sd	s0,16(sp)
    8000403e:	e426                	sd	s1,8(sp)
    80004040:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004042:	c10d                	beqz	a0,80004064 <ilock+0x2c>
    80004044:	84aa                	mv	s1,a0
    80004046:	451c                	lw	a5,8(a0)
    80004048:	00f05e63          	blez	a5,80004064 <ilock+0x2c>
  acquiresleep(&ip->lock);
    8000404c:	0541                	addi	a0,a0,16
    8000404e:	00001097          	auipc	ra,0x1
    80004052:	cae080e7          	jalr	-850(ra) # 80004cfc <acquiresleep>
  if(ip->valid == 0){
    80004056:	40bc                	lw	a5,64(s1)
    80004058:	cf99                	beqz	a5,80004076 <ilock+0x3e>
}
    8000405a:	60e2                	ld	ra,24(sp)
    8000405c:	6442                	ld	s0,16(sp)
    8000405e:	64a2                	ld	s1,8(sp)
    80004060:	6105                	addi	sp,sp,32
    80004062:	8082                	ret
    80004064:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004066:	00004517          	auipc	a0,0x4
    8000406a:	47a50513          	addi	a0,a0,1146 # 800084e0 <etext+0x4e0>
    8000406e:	ffffc097          	auipc	ra,0xffffc
    80004072:	4f2080e7          	jalr	1266(ra) # 80000560 <panic>
    80004076:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004078:	40dc                	lw	a5,4(s1)
    8000407a:	0047d79b          	srliw	a5,a5,0x4
    8000407e:	00026597          	auipc	a1,0x26
    80004082:	eb25a583          	lw	a1,-334(a1) # 80029f30 <sb+0x18>
    80004086:	9dbd                	addw	a1,a1,a5
    80004088:	4088                	lw	a0,0(s1)
    8000408a:	fffff097          	auipc	ra,0xfffff
    8000408e:	77a080e7          	jalr	1914(ra) # 80003804 <bread>
    80004092:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004094:	05850593          	addi	a1,a0,88
    80004098:	40dc                	lw	a5,4(s1)
    8000409a:	8bbd                	andi	a5,a5,15
    8000409c:	079a                	slli	a5,a5,0x6
    8000409e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800040a0:	00059783          	lh	a5,0(a1)
    800040a4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800040a8:	00259783          	lh	a5,2(a1)
    800040ac:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800040b0:	00459783          	lh	a5,4(a1)
    800040b4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800040b8:	00659783          	lh	a5,6(a1)
    800040bc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800040c0:	459c                	lw	a5,8(a1)
    800040c2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800040c4:	03400613          	li	a2,52
    800040c8:	05b1                	addi	a1,a1,12
    800040ca:	05048513          	addi	a0,s1,80
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	cc2080e7          	jalr	-830(ra) # 80000d90 <memmove>
    brelse(bp);
    800040d6:	854a                	mv	a0,s2
    800040d8:	00000097          	auipc	ra,0x0
    800040dc:	85c080e7          	jalr	-1956(ra) # 80003934 <brelse>
    ip->valid = 1;
    800040e0:	4785                	li	a5,1
    800040e2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800040e4:	04449783          	lh	a5,68(s1)
    800040e8:	c399                	beqz	a5,800040ee <ilock+0xb6>
    800040ea:	6902                	ld	s2,0(sp)
    800040ec:	b7bd                	j	8000405a <ilock+0x22>
      panic("ilock: no type");
    800040ee:	00004517          	auipc	a0,0x4
    800040f2:	3fa50513          	addi	a0,a0,1018 # 800084e8 <etext+0x4e8>
    800040f6:	ffffc097          	auipc	ra,0xffffc
    800040fa:	46a080e7          	jalr	1130(ra) # 80000560 <panic>

00000000800040fe <iunlock>:
{
    800040fe:	1101                	addi	sp,sp,-32
    80004100:	ec06                	sd	ra,24(sp)
    80004102:	e822                	sd	s0,16(sp)
    80004104:	e426                	sd	s1,8(sp)
    80004106:	e04a                	sd	s2,0(sp)
    80004108:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000410a:	c905                	beqz	a0,8000413a <iunlock+0x3c>
    8000410c:	84aa                	mv	s1,a0
    8000410e:	01050913          	addi	s2,a0,16
    80004112:	854a                	mv	a0,s2
    80004114:	00001097          	auipc	ra,0x1
    80004118:	c82080e7          	jalr	-894(ra) # 80004d96 <holdingsleep>
    8000411c:	cd19                	beqz	a0,8000413a <iunlock+0x3c>
    8000411e:	449c                	lw	a5,8(s1)
    80004120:	00f05d63          	blez	a5,8000413a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004124:	854a                	mv	a0,s2
    80004126:	00001097          	auipc	ra,0x1
    8000412a:	c2c080e7          	jalr	-980(ra) # 80004d52 <releasesleep>
}
    8000412e:	60e2                	ld	ra,24(sp)
    80004130:	6442                	ld	s0,16(sp)
    80004132:	64a2                	ld	s1,8(sp)
    80004134:	6902                	ld	s2,0(sp)
    80004136:	6105                	addi	sp,sp,32
    80004138:	8082                	ret
    panic("iunlock");
    8000413a:	00004517          	auipc	a0,0x4
    8000413e:	3be50513          	addi	a0,a0,958 # 800084f8 <etext+0x4f8>
    80004142:	ffffc097          	auipc	ra,0xffffc
    80004146:	41e080e7          	jalr	1054(ra) # 80000560 <panic>

000000008000414a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000414a:	7179                	addi	sp,sp,-48
    8000414c:	f406                	sd	ra,40(sp)
    8000414e:	f022                	sd	s0,32(sp)
    80004150:	ec26                	sd	s1,24(sp)
    80004152:	e84a                	sd	s2,16(sp)
    80004154:	e44e                	sd	s3,8(sp)
    80004156:	1800                	addi	s0,sp,48
    80004158:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000415a:	05050493          	addi	s1,a0,80
    8000415e:	08050913          	addi	s2,a0,128
    80004162:	a021                	j	8000416a <itrunc+0x20>
    80004164:	0491                	addi	s1,s1,4
    80004166:	01248d63          	beq	s1,s2,80004180 <itrunc+0x36>
    if(ip->addrs[i]){
    8000416a:	408c                	lw	a1,0(s1)
    8000416c:	dde5                	beqz	a1,80004164 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000416e:	0009a503          	lw	a0,0(s3)
    80004172:	00000097          	auipc	ra,0x0
    80004176:	8d6080e7          	jalr	-1834(ra) # 80003a48 <bfree>
      ip->addrs[i] = 0;
    8000417a:	0004a023          	sw	zero,0(s1)
    8000417e:	b7dd                	j	80004164 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004180:	0809a583          	lw	a1,128(s3)
    80004184:	ed99                	bnez	a1,800041a2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004186:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000418a:	854e                	mv	a0,s3
    8000418c:	00000097          	auipc	ra,0x0
    80004190:	de0080e7          	jalr	-544(ra) # 80003f6c <iupdate>
}
    80004194:	70a2                	ld	ra,40(sp)
    80004196:	7402                	ld	s0,32(sp)
    80004198:	64e2                	ld	s1,24(sp)
    8000419a:	6942                	ld	s2,16(sp)
    8000419c:	69a2                	ld	s3,8(sp)
    8000419e:	6145                	addi	sp,sp,48
    800041a0:	8082                	ret
    800041a2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800041a4:	0009a503          	lw	a0,0(s3)
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	65c080e7          	jalr	1628(ra) # 80003804 <bread>
    800041b0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800041b2:	05850493          	addi	s1,a0,88
    800041b6:	45850913          	addi	s2,a0,1112
    800041ba:	a021                	j	800041c2 <itrunc+0x78>
    800041bc:	0491                	addi	s1,s1,4
    800041be:	01248b63          	beq	s1,s2,800041d4 <itrunc+0x8a>
      if(a[j])
    800041c2:	408c                	lw	a1,0(s1)
    800041c4:	dde5                	beqz	a1,800041bc <itrunc+0x72>
        bfree(ip->dev, a[j]);
    800041c6:	0009a503          	lw	a0,0(s3)
    800041ca:	00000097          	auipc	ra,0x0
    800041ce:	87e080e7          	jalr	-1922(ra) # 80003a48 <bfree>
    800041d2:	b7ed                	j	800041bc <itrunc+0x72>
    brelse(bp);
    800041d4:	8552                	mv	a0,s4
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	75e080e7          	jalr	1886(ra) # 80003934 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800041de:	0809a583          	lw	a1,128(s3)
    800041e2:	0009a503          	lw	a0,0(s3)
    800041e6:	00000097          	auipc	ra,0x0
    800041ea:	862080e7          	jalr	-1950(ra) # 80003a48 <bfree>
    ip->addrs[NDIRECT] = 0;
    800041ee:	0809a023          	sw	zero,128(s3)
    800041f2:	6a02                	ld	s4,0(sp)
    800041f4:	bf49                	j	80004186 <itrunc+0x3c>

00000000800041f6 <iput>:
{
    800041f6:	1101                	addi	sp,sp,-32
    800041f8:	ec06                	sd	ra,24(sp)
    800041fa:	e822                	sd	s0,16(sp)
    800041fc:	e426                	sd	s1,8(sp)
    800041fe:	1000                	addi	s0,sp,32
    80004200:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004202:	00026517          	auipc	a0,0x26
    80004206:	d3650513          	addi	a0,a0,-714 # 80029f38 <itable>
    8000420a:	ffffd097          	auipc	ra,0xffffd
    8000420e:	a2e080e7          	jalr	-1490(ra) # 80000c38 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004212:	4498                	lw	a4,8(s1)
    80004214:	4785                	li	a5,1
    80004216:	02f70263          	beq	a4,a5,8000423a <iput+0x44>
  ip->ref--;
    8000421a:	449c                	lw	a5,8(s1)
    8000421c:	37fd                	addiw	a5,a5,-1
    8000421e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004220:	00026517          	auipc	a0,0x26
    80004224:	d1850513          	addi	a0,a0,-744 # 80029f38 <itable>
    80004228:	ffffd097          	auipc	ra,0xffffd
    8000422c:	ac4080e7          	jalr	-1340(ra) # 80000cec <release>
}
    80004230:	60e2                	ld	ra,24(sp)
    80004232:	6442                	ld	s0,16(sp)
    80004234:	64a2                	ld	s1,8(sp)
    80004236:	6105                	addi	sp,sp,32
    80004238:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000423a:	40bc                	lw	a5,64(s1)
    8000423c:	dff9                	beqz	a5,8000421a <iput+0x24>
    8000423e:	04a49783          	lh	a5,74(s1)
    80004242:	ffe1                	bnez	a5,8000421a <iput+0x24>
    80004244:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004246:	01048913          	addi	s2,s1,16
    8000424a:	854a                	mv	a0,s2
    8000424c:	00001097          	auipc	ra,0x1
    80004250:	ab0080e7          	jalr	-1360(ra) # 80004cfc <acquiresleep>
    release(&itable.lock);
    80004254:	00026517          	auipc	a0,0x26
    80004258:	ce450513          	addi	a0,a0,-796 # 80029f38 <itable>
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	a90080e7          	jalr	-1392(ra) # 80000cec <release>
    itrunc(ip);
    80004264:	8526                	mv	a0,s1
    80004266:	00000097          	auipc	ra,0x0
    8000426a:	ee4080e7          	jalr	-284(ra) # 8000414a <itrunc>
    ip->type = 0;
    8000426e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004272:	8526                	mv	a0,s1
    80004274:	00000097          	auipc	ra,0x0
    80004278:	cf8080e7          	jalr	-776(ra) # 80003f6c <iupdate>
    ip->valid = 0;
    8000427c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004280:	854a                	mv	a0,s2
    80004282:	00001097          	auipc	ra,0x1
    80004286:	ad0080e7          	jalr	-1328(ra) # 80004d52 <releasesleep>
    acquire(&itable.lock);
    8000428a:	00026517          	auipc	a0,0x26
    8000428e:	cae50513          	addi	a0,a0,-850 # 80029f38 <itable>
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	9a6080e7          	jalr	-1626(ra) # 80000c38 <acquire>
    8000429a:	6902                	ld	s2,0(sp)
    8000429c:	bfbd                	j	8000421a <iput+0x24>

000000008000429e <iunlockput>:
{
    8000429e:	1101                	addi	sp,sp,-32
    800042a0:	ec06                	sd	ra,24(sp)
    800042a2:	e822                	sd	s0,16(sp)
    800042a4:	e426                	sd	s1,8(sp)
    800042a6:	1000                	addi	s0,sp,32
    800042a8:	84aa                	mv	s1,a0
  iunlock(ip);
    800042aa:	00000097          	auipc	ra,0x0
    800042ae:	e54080e7          	jalr	-428(ra) # 800040fe <iunlock>
  iput(ip);
    800042b2:	8526                	mv	a0,s1
    800042b4:	00000097          	auipc	ra,0x0
    800042b8:	f42080e7          	jalr	-190(ra) # 800041f6 <iput>
}
    800042bc:	60e2                	ld	ra,24(sp)
    800042be:	6442                	ld	s0,16(sp)
    800042c0:	64a2                	ld	s1,8(sp)
    800042c2:	6105                	addi	sp,sp,32
    800042c4:	8082                	ret

00000000800042c6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800042c6:	1141                	addi	sp,sp,-16
    800042c8:	e422                	sd	s0,8(sp)
    800042ca:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800042cc:	411c                	lw	a5,0(a0)
    800042ce:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800042d0:	415c                	lw	a5,4(a0)
    800042d2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800042d4:	04451783          	lh	a5,68(a0)
    800042d8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800042dc:	04a51783          	lh	a5,74(a0)
    800042e0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800042e4:	04c56783          	lwu	a5,76(a0)
    800042e8:	e99c                	sd	a5,16(a1)
}
    800042ea:	6422                	ld	s0,8(sp)
    800042ec:	0141                	addi	sp,sp,16
    800042ee:	8082                	ret

00000000800042f0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800042f0:	457c                	lw	a5,76(a0)
    800042f2:	10d7e563          	bltu	a5,a3,800043fc <readi+0x10c>
{
    800042f6:	7159                	addi	sp,sp,-112
    800042f8:	f486                	sd	ra,104(sp)
    800042fa:	f0a2                	sd	s0,96(sp)
    800042fc:	eca6                	sd	s1,88(sp)
    800042fe:	e0d2                	sd	s4,64(sp)
    80004300:	fc56                	sd	s5,56(sp)
    80004302:	f85a                	sd	s6,48(sp)
    80004304:	f45e                	sd	s7,40(sp)
    80004306:	1880                	addi	s0,sp,112
    80004308:	8b2a                	mv	s6,a0
    8000430a:	8bae                	mv	s7,a1
    8000430c:	8a32                	mv	s4,a2
    8000430e:	84b6                	mv	s1,a3
    80004310:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004312:	9f35                	addw	a4,a4,a3
    return 0;
    80004314:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004316:	0cd76a63          	bltu	a4,a3,800043ea <readi+0xfa>
    8000431a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000431c:	00e7f463          	bgeu	a5,a4,80004324 <readi+0x34>
    n = ip->size - off;
    80004320:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004324:	0a0a8963          	beqz	s5,800043d6 <readi+0xe6>
    80004328:	e8ca                	sd	s2,80(sp)
    8000432a:	f062                	sd	s8,32(sp)
    8000432c:	ec66                	sd	s9,24(sp)
    8000432e:	e86a                	sd	s10,16(sp)
    80004330:	e46e                	sd	s11,8(sp)
    80004332:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004334:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004338:	5c7d                	li	s8,-1
    8000433a:	a82d                	j	80004374 <readi+0x84>
    8000433c:	020d1d93          	slli	s11,s10,0x20
    80004340:	020ddd93          	srli	s11,s11,0x20
    80004344:	05890613          	addi	a2,s2,88
    80004348:	86ee                	mv	a3,s11
    8000434a:	963a                	add	a2,a2,a4
    8000434c:	85d2                	mv	a1,s4
    8000434e:	855e                	mv	a0,s7
    80004350:	ffffe097          	auipc	ra,0xffffe
    80004354:	6b8080e7          	jalr	1720(ra) # 80002a08 <either_copyout>
    80004358:	05850d63          	beq	a0,s8,800043b2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000435c:	854a                	mv	a0,s2
    8000435e:	fffff097          	auipc	ra,0xfffff
    80004362:	5d6080e7          	jalr	1494(ra) # 80003934 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004366:	013d09bb          	addw	s3,s10,s3
    8000436a:	009d04bb          	addw	s1,s10,s1
    8000436e:	9a6e                	add	s4,s4,s11
    80004370:	0559fd63          	bgeu	s3,s5,800043ca <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80004374:	00a4d59b          	srliw	a1,s1,0xa
    80004378:	855a                	mv	a0,s6
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	88e080e7          	jalr	-1906(ra) # 80003c08 <bmap>
    80004382:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004386:	c9b1                	beqz	a1,800043da <readi+0xea>
    bp = bread(ip->dev, addr);
    80004388:	000b2503          	lw	a0,0(s6)
    8000438c:	fffff097          	auipc	ra,0xfffff
    80004390:	478080e7          	jalr	1144(ra) # 80003804 <bread>
    80004394:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004396:	3ff4f713          	andi	a4,s1,1023
    8000439a:	40ec87bb          	subw	a5,s9,a4
    8000439e:	413a86bb          	subw	a3,s5,s3
    800043a2:	8d3e                	mv	s10,a5
    800043a4:	2781                	sext.w	a5,a5
    800043a6:	0006861b          	sext.w	a2,a3
    800043aa:	f8f679e3          	bgeu	a2,a5,8000433c <readi+0x4c>
    800043ae:	8d36                	mv	s10,a3
    800043b0:	b771                	j	8000433c <readi+0x4c>
      brelse(bp);
    800043b2:	854a                	mv	a0,s2
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	580080e7          	jalr	1408(ra) # 80003934 <brelse>
      tot = -1;
    800043bc:	59fd                	li	s3,-1
      break;
    800043be:	6946                	ld	s2,80(sp)
    800043c0:	7c02                	ld	s8,32(sp)
    800043c2:	6ce2                	ld	s9,24(sp)
    800043c4:	6d42                	ld	s10,16(sp)
    800043c6:	6da2                	ld	s11,8(sp)
    800043c8:	a831                	j	800043e4 <readi+0xf4>
    800043ca:	6946                	ld	s2,80(sp)
    800043cc:	7c02                	ld	s8,32(sp)
    800043ce:	6ce2                	ld	s9,24(sp)
    800043d0:	6d42                	ld	s10,16(sp)
    800043d2:	6da2                	ld	s11,8(sp)
    800043d4:	a801                	j	800043e4 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800043d6:	89d6                	mv	s3,s5
    800043d8:	a031                	j	800043e4 <readi+0xf4>
    800043da:	6946                	ld	s2,80(sp)
    800043dc:	7c02                	ld	s8,32(sp)
    800043de:	6ce2                	ld	s9,24(sp)
    800043e0:	6d42                	ld	s10,16(sp)
    800043e2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800043e4:	0009851b          	sext.w	a0,s3
    800043e8:	69a6                	ld	s3,72(sp)
}
    800043ea:	70a6                	ld	ra,104(sp)
    800043ec:	7406                	ld	s0,96(sp)
    800043ee:	64e6                	ld	s1,88(sp)
    800043f0:	6a06                	ld	s4,64(sp)
    800043f2:	7ae2                	ld	s5,56(sp)
    800043f4:	7b42                	ld	s6,48(sp)
    800043f6:	7ba2                	ld	s7,40(sp)
    800043f8:	6165                	addi	sp,sp,112
    800043fa:	8082                	ret
    return 0;
    800043fc:	4501                	li	a0,0
}
    800043fe:	8082                	ret

0000000080004400 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004400:	457c                	lw	a5,76(a0)
    80004402:	10d7ee63          	bltu	a5,a3,8000451e <writei+0x11e>
{
    80004406:	7159                	addi	sp,sp,-112
    80004408:	f486                	sd	ra,104(sp)
    8000440a:	f0a2                	sd	s0,96(sp)
    8000440c:	e8ca                	sd	s2,80(sp)
    8000440e:	e0d2                	sd	s4,64(sp)
    80004410:	fc56                	sd	s5,56(sp)
    80004412:	f85a                	sd	s6,48(sp)
    80004414:	f45e                	sd	s7,40(sp)
    80004416:	1880                	addi	s0,sp,112
    80004418:	8aaa                	mv	s5,a0
    8000441a:	8bae                	mv	s7,a1
    8000441c:	8a32                	mv	s4,a2
    8000441e:	8936                	mv	s2,a3
    80004420:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004422:	00e687bb          	addw	a5,a3,a4
    80004426:	0ed7ee63          	bltu	a5,a3,80004522 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000442a:	00043737          	lui	a4,0x43
    8000442e:	0ef76c63          	bltu	a4,a5,80004526 <writei+0x126>
    80004432:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004434:	0c0b0d63          	beqz	s6,8000450e <writei+0x10e>
    80004438:	eca6                	sd	s1,88(sp)
    8000443a:	f062                	sd	s8,32(sp)
    8000443c:	ec66                	sd	s9,24(sp)
    8000443e:	e86a                	sd	s10,16(sp)
    80004440:	e46e                	sd	s11,8(sp)
    80004442:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004444:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004448:	5c7d                	li	s8,-1
    8000444a:	a091                	j	8000448e <writei+0x8e>
    8000444c:	020d1d93          	slli	s11,s10,0x20
    80004450:	020ddd93          	srli	s11,s11,0x20
    80004454:	05848513          	addi	a0,s1,88
    80004458:	86ee                	mv	a3,s11
    8000445a:	8652                	mv	a2,s4
    8000445c:	85de                	mv	a1,s7
    8000445e:	953a                	add	a0,a0,a4
    80004460:	ffffe097          	auipc	ra,0xffffe
    80004464:	600080e7          	jalr	1536(ra) # 80002a60 <either_copyin>
    80004468:	07850263          	beq	a0,s8,800044cc <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000446c:	8526                	mv	a0,s1
    8000446e:	00000097          	auipc	ra,0x0
    80004472:	770080e7          	jalr	1904(ra) # 80004bde <log_write>
    brelse(bp);
    80004476:	8526                	mv	a0,s1
    80004478:	fffff097          	auipc	ra,0xfffff
    8000447c:	4bc080e7          	jalr	1212(ra) # 80003934 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004480:	013d09bb          	addw	s3,s10,s3
    80004484:	012d093b          	addw	s2,s10,s2
    80004488:	9a6e                	add	s4,s4,s11
    8000448a:	0569f663          	bgeu	s3,s6,800044d6 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000448e:	00a9559b          	srliw	a1,s2,0xa
    80004492:	8556                	mv	a0,s5
    80004494:	fffff097          	auipc	ra,0xfffff
    80004498:	774080e7          	jalr	1908(ra) # 80003c08 <bmap>
    8000449c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800044a0:	c99d                	beqz	a1,800044d6 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800044a2:	000aa503          	lw	a0,0(s5)
    800044a6:	fffff097          	auipc	ra,0xfffff
    800044aa:	35e080e7          	jalr	862(ra) # 80003804 <bread>
    800044ae:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800044b0:	3ff97713          	andi	a4,s2,1023
    800044b4:	40ec87bb          	subw	a5,s9,a4
    800044b8:	413b06bb          	subw	a3,s6,s3
    800044bc:	8d3e                	mv	s10,a5
    800044be:	2781                	sext.w	a5,a5
    800044c0:	0006861b          	sext.w	a2,a3
    800044c4:	f8f674e3          	bgeu	a2,a5,8000444c <writei+0x4c>
    800044c8:	8d36                	mv	s10,a3
    800044ca:	b749                	j	8000444c <writei+0x4c>
      brelse(bp);
    800044cc:	8526                	mv	a0,s1
    800044ce:	fffff097          	auipc	ra,0xfffff
    800044d2:	466080e7          	jalr	1126(ra) # 80003934 <brelse>
  }

  if(off > ip->size)
    800044d6:	04caa783          	lw	a5,76(s5)
    800044da:	0327fc63          	bgeu	a5,s2,80004512 <writei+0x112>
    ip->size = off;
    800044de:	052aa623          	sw	s2,76(s5)
    800044e2:	64e6                	ld	s1,88(sp)
    800044e4:	7c02                	ld	s8,32(sp)
    800044e6:	6ce2                	ld	s9,24(sp)
    800044e8:	6d42                	ld	s10,16(sp)
    800044ea:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800044ec:	8556                	mv	a0,s5
    800044ee:	00000097          	auipc	ra,0x0
    800044f2:	a7e080e7          	jalr	-1410(ra) # 80003f6c <iupdate>

  return tot;
    800044f6:	0009851b          	sext.w	a0,s3
    800044fa:	69a6                	ld	s3,72(sp)
}
    800044fc:	70a6                	ld	ra,104(sp)
    800044fe:	7406                	ld	s0,96(sp)
    80004500:	6946                	ld	s2,80(sp)
    80004502:	6a06                	ld	s4,64(sp)
    80004504:	7ae2                	ld	s5,56(sp)
    80004506:	7b42                	ld	s6,48(sp)
    80004508:	7ba2                	ld	s7,40(sp)
    8000450a:	6165                	addi	sp,sp,112
    8000450c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000450e:	89da                	mv	s3,s6
    80004510:	bff1                	j	800044ec <writei+0xec>
    80004512:	64e6                	ld	s1,88(sp)
    80004514:	7c02                	ld	s8,32(sp)
    80004516:	6ce2                	ld	s9,24(sp)
    80004518:	6d42                	ld	s10,16(sp)
    8000451a:	6da2                	ld	s11,8(sp)
    8000451c:	bfc1                	j	800044ec <writei+0xec>
    return -1;
    8000451e:	557d                	li	a0,-1
}
    80004520:	8082                	ret
    return -1;
    80004522:	557d                	li	a0,-1
    80004524:	bfe1                	j	800044fc <writei+0xfc>
    return -1;
    80004526:	557d                	li	a0,-1
    80004528:	bfd1                	j	800044fc <writei+0xfc>

000000008000452a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000452a:	1141                	addi	sp,sp,-16
    8000452c:	e406                	sd	ra,8(sp)
    8000452e:	e022                	sd	s0,0(sp)
    80004530:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004532:	4639                	li	a2,14
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	8d0080e7          	jalr	-1840(ra) # 80000e04 <strncmp>
}
    8000453c:	60a2                	ld	ra,8(sp)
    8000453e:	6402                	ld	s0,0(sp)
    80004540:	0141                	addi	sp,sp,16
    80004542:	8082                	ret

0000000080004544 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004544:	7139                	addi	sp,sp,-64
    80004546:	fc06                	sd	ra,56(sp)
    80004548:	f822                	sd	s0,48(sp)
    8000454a:	f426                	sd	s1,40(sp)
    8000454c:	f04a                	sd	s2,32(sp)
    8000454e:	ec4e                	sd	s3,24(sp)
    80004550:	e852                	sd	s4,16(sp)
    80004552:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004554:	04451703          	lh	a4,68(a0)
    80004558:	4785                	li	a5,1
    8000455a:	00f71a63          	bne	a4,a5,8000456e <dirlookup+0x2a>
    8000455e:	892a                	mv	s2,a0
    80004560:	89ae                	mv	s3,a1
    80004562:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004564:	457c                	lw	a5,76(a0)
    80004566:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004568:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000456a:	e79d                	bnez	a5,80004598 <dirlookup+0x54>
    8000456c:	a8a5                	j	800045e4 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000456e:	00004517          	auipc	a0,0x4
    80004572:	f9250513          	addi	a0,a0,-110 # 80008500 <etext+0x500>
    80004576:	ffffc097          	auipc	ra,0xffffc
    8000457a:	fea080e7          	jalr	-22(ra) # 80000560 <panic>
      panic("dirlookup read");
    8000457e:	00004517          	auipc	a0,0x4
    80004582:	f9a50513          	addi	a0,a0,-102 # 80008518 <etext+0x518>
    80004586:	ffffc097          	auipc	ra,0xffffc
    8000458a:	fda080e7          	jalr	-38(ra) # 80000560 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000458e:	24c1                	addiw	s1,s1,16
    80004590:	04c92783          	lw	a5,76(s2)
    80004594:	04f4f763          	bgeu	s1,a5,800045e2 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004598:	4741                	li	a4,16
    8000459a:	86a6                	mv	a3,s1
    8000459c:	fc040613          	addi	a2,s0,-64
    800045a0:	4581                	li	a1,0
    800045a2:	854a                	mv	a0,s2
    800045a4:	00000097          	auipc	ra,0x0
    800045a8:	d4c080e7          	jalr	-692(ra) # 800042f0 <readi>
    800045ac:	47c1                	li	a5,16
    800045ae:	fcf518e3          	bne	a0,a5,8000457e <dirlookup+0x3a>
    if(de.inum == 0)
    800045b2:	fc045783          	lhu	a5,-64(s0)
    800045b6:	dfe1                	beqz	a5,8000458e <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800045b8:	fc240593          	addi	a1,s0,-62
    800045bc:	854e                	mv	a0,s3
    800045be:	00000097          	auipc	ra,0x0
    800045c2:	f6c080e7          	jalr	-148(ra) # 8000452a <namecmp>
    800045c6:	f561                	bnez	a0,8000458e <dirlookup+0x4a>
      if(poff)
    800045c8:	000a0463          	beqz	s4,800045d0 <dirlookup+0x8c>
        *poff = off;
    800045cc:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800045d0:	fc045583          	lhu	a1,-64(s0)
    800045d4:	00092503          	lw	a0,0(s2)
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	720080e7          	jalr	1824(ra) # 80003cf8 <iget>
    800045e0:	a011                	j	800045e4 <dirlookup+0xa0>
  return 0;
    800045e2:	4501                	li	a0,0
}
    800045e4:	70e2                	ld	ra,56(sp)
    800045e6:	7442                	ld	s0,48(sp)
    800045e8:	74a2                	ld	s1,40(sp)
    800045ea:	7902                	ld	s2,32(sp)
    800045ec:	69e2                	ld	s3,24(sp)
    800045ee:	6a42                	ld	s4,16(sp)
    800045f0:	6121                	addi	sp,sp,64
    800045f2:	8082                	ret

00000000800045f4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800045f4:	711d                	addi	sp,sp,-96
    800045f6:	ec86                	sd	ra,88(sp)
    800045f8:	e8a2                	sd	s0,80(sp)
    800045fa:	e4a6                	sd	s1,72(sp)
    800045fc:	e0ca                	sd	s2,64(sp)
    800045fe:	fc4e                	sd	s3,56(sp)
    80004600:	f852                	sd	s4,48(sp)
    80004602:	f456                	sd	s5,40(sp)
    80004604:	f05a                	sd	s6,32(sp)
    80004606:	ec5e                	sd	s7,24(sp)
    80004608:	e862                	sd	s8,16(sp)
    8000460a:	e466                	sd	s9,8(sp)
    8000460c:	1080                	addi	s0,sp,96
    8000460e:	84aa                	mv	s1,a0
    80004610:	8b2e                	mv	s6,a1
    80004612:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004614:	00054703          	lbu	a4,0(a0)
    80004618:	02f00793          	li	a5,47
    8000461c:	02f70263          	beq	a4,a5,80004640 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004620:	ffffd097          	auipc	ra,0xffffd
    80004624:	5ca080e7          	jalr	1482(ra) # 80001bea <myproc>
    80004628:	32853503          	ld	a0,808(a0)
    8000462c:	00000097          	auipc	ra,0x0
    80004630:	9ce080e7          	jalr	-1586(ra) # 80003ffa <idup>
    80004634:	8a2a                	mv	s4,a0
  while(*path == '/')
    80004636:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000463a:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000463c:	4b85                	li	s7,1
    8000463e:	a875                	j	800046fa <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80004640:	4585                	li	a1,1
    80004642:	4505                	li	a0,1
    80004644:	fffff097          	auipc	ra,0xfffff
    80004648:	6b4080e7          	jalr	1716(ra) # 80003cf8 <iget>
    8000464c:	8a2a                	mv	s4,a0
    8000464e:	b7e5                	j	80004636 <namex+0x42>
      iunlockput(ip);
    80004650:	8552                	mv	a0,s4
    80004652:	00000097          	auipc	ra,0x0
    80004656:	c4c080e7          	jalr	-948(ra) # 8000429e <iunlockput>
      return 0;
    8000465a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000465c:	8552                	mv	a0,s4
    8000465e:	60e6                	ld	ra,88(sp)
    80004660:	6446                	ld	s0,80(sp)
    80004662:	64a6                	ld	s1,72(sp)
    80004664:	6906                	ld	s2,64(sp)
    80004666:	79e2                	ld	s3,56(sp)
    80004668:	7a42                	ld	s4,48(sp)
    8000466a:	7aa2                	ld	s5,40(sp)
    8000466c:	7b02                	ld	s6,32(sp)
    8000466e:	6be2                	ld	s7,24(sp)
    80004670:	6c42                	ld	s8,16(sp)
    80004672:	6ca2                	ld	s9,8(sp)
    80004674:	6125                	addi	sp,sp,96
    80004676:	8082                	ret
      iunlock(ip);
    80004678:	8552                	mv	a0,s4
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	a84080e7          	jalr	-1404(ra) # 800040fe <iunlock>
      return ip;
    80004682:	bfe9                	j	8000465c <namex+0x68>
      iunlockput(ip);
    80004684:	8552                	mv	a0,s4
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	c18080e7          	jalr	-1000(ra) # 8000429e <iunlockput>
      return 0;
    8000468e:	8a4e                	mv	s4,s3
    80004690:	b7f1                	j	8000465c <namex+0x68>
  len = path - s;
    80004692:	40998633          	sub	a2,s3,s1
    80004696:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000469a:	099c5863          	bge	s8,s9,8000472a <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000469e:	4639                	li	a2,14
    800046a0:	85a6                	mv	a1,s1
    800046a2:	8556                	mv	a0,s5
    800046a4:	ffffc097          	auipc	ra,0xffffc
    800046a8:	6ec080e7          	jalr	1772(ra) # 80000d90 <memmove>
    800046ac:	84ce                	mv	s1,s3
  while(*path == '/')
    800046ae:	0004c783          	lbu	a5,0(s1)
    800046b2:	01279763          	bne	a5,s2,800046c0 <namex+0xcc>
    path++;
    800046b6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800046b8:	0004c783          	lbu	a5,0(s1)
    800046bc:	ff278de3          	beq	a5,s2,800046b6 <namex+0xc2>
    ilock(ip);
    800046c0:	8552                	mv	a0,s4
    800046c2:	00000097          	auipc	ra,0x0
    800046c6:	976080e7          	jalr	-1674(ra) # 80004038 <ilock>
    if(ip->type != T_DIR){
    800046ca:	044a1783          	lh	a5,68(s4)
    800046ce:	f97791e3          	bne	a5,s7,80004650 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800046d2:	000b0563          	beqz	s6,800046dc <namex+0xe8>
    800046d6:	0004c783          	lbu	a5,0(s1)
    800046da:	dfd9                	beqz	a5,80004678 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800046dc:	4601                	li	a2,0
    800046de:	85d6                	mv	a1,s5
    800046e0:	8552                	mv	a0,s4
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	e62080e7          	jalr	-414(ra) # 80004544 <dirlookup>
    800046ea:	89aa                	mv	s3,a0
    800046ec:	dd41                	beqz	a0,80004684 <namex+0x90>
    iunlockput(ip);
    800046ee:	8552                	mv	a0,s4
    800046f0:	00000097          	auipc	ra,0x0
    800046f4:	bae080e7          	jalr	-1106(ra) # 8000429e <iunlockput>
    ip = next;
    800046f8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800046fa:	0004c783          	lbu	a5,0(s1)
    800046fe:	01279763          	bne	a5,s2,8000470c <namex+0x118>
    path++;
    80004702:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004704:	0004c783          	lbu	a5,0(s1)
    80004708:	ff278de3          	beq	a5,s2,80004702 <namex+0x10e>
  if(*path == 0)
    8000470c:	cb9d                	beqz	a5,80004742 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000470e:	0004c783          	lbu	a5,0(s1)
    80004712:	89a6                	mv	s3,s1
  len = path - s;
    80004714:	4c81                	li	s9,0
    80004716:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80004718:	01278963          	beq	a5,s2,8000472a <namex+0x136>
    8000471c:	dbbd                	beqz	a5,80004692 <namex+0x9e>
    path++;
    8000471e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004720:	0009c783          	lbu	a5,0(s3)
    80004724:	ff279ce3          	bne	a5,s2,8000471c <namex+0x128>
    80004728:	b7ad                	j	80004692 <namex+0x9e>
    memmove(name, s, len);
    8000472a:	2601                	sext.w	a2,a2
    8000472c:	85a6                	mv	a1,s1
    8000472e:	8556                	mv	a0,s5
    80004730:	ffffc097          	auipc	ra,0xffffc
    80004734:	660080e7          	jalr	1632(ra) # 80000d90 <memmove>
    name[len] = 0;
    80004738:	9cd6                	add	s9,s9,s5
    8000473a:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000473e:	84ce                	mv	s1,s3
    80004740:	b7bd                	j	800046ae <namex+0xba>
  if(nameiparent){
    80004742:	f00b0de3          	beqz	s6,8000465c <namex+0x68>
    iput(ip);
    80004746:	8552                	mv	a0,s4
    80004748:	00000097          	auipc	ra,0x0
    8000474c:	aae080e7          	jalr	-1362(ra) # 800041f6 <iput>
    return 0;
    80004750:	4a01                	li	s4,0
    80004752:	b729                	j	8000465c <namex+0x68>

0000000080004754 <dirlink>:
{
    80004754:	7139                	addi	sp,sp,-64
    80004756:	fc06                	sd	ra,56(sp)
    80004758:	f822                	sd	s0,48(sp)
    8000475a:	f04a                	sd	s2,32(sp)
    8000475c:	ec4e                	sd	s3,24(sp)
    8000475e:	e852                	sd	s4,16(sp)
    80004760:	0080                	addi	s0,sp,64
    80004762:	892a                	mv	s2,a0
    80004764:	8a2e                	mv	s4,a1
    80004766:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004768:	4601                	li	a2,0
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	dda080e7          	jalr	-550(ra) # 80004544 <dirlookup>
    80004772:	ed25                	bnez	a0,800047ea <dirlink+0x96>
    80004774:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004776:	04c92483          	lw	s1,76(s2)
    8000477a:	c49d                	beqz	s1,800047a8 <dirlink+0x54>
    8000477c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000477e:	4741                	li	a4,16
    80004780:	86a6                	mv	a3,s1
    80004782:	fc040613          	addi	a2,s0,-64
    80004786:	4581                	li	a1,0
    80004788:	854a                	mv	a0,s2
    8000478a:	00000097          	auipc	ra,0x0
    8000478e:	b66080e7          	jalr	-1178(ra) # 800042f0 <readi>
    80004792:	47c1                	li	a5,16
    80004794:	06f51163          	bne	a0,a5,800047f6 <dirlink+0xa2>
    if(de.inum == 0)
    80004798:	fc045783          	lhu	a5,-64(s0)
    8000479c:	c791                	beqz	a5,800047a8 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000479e:	24c1                	addiw	s1,s1,16
    800047a0:	04c92783          	lw	a5,76(s2)
    800047a4:	fcf4ede3          	bltu	s1,a5,8000477e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800047a8:	4639                	li	a2,14
    800047aa:	85d2                	mv	a1,s4
    800047ac:	fc240513          	addi	a0,s0,-62
    800047b0:	ffffc097          	auipc	ra,0xffffc
    800047b4:	68a080e7          	jalr	1674(ra) # 80000e3a <strncpy>
  de.inum = inum;
    800047b8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800047bc:	4741                	li	a4,16
    800047be:	86a6                	mv	a3,s1
    800047c0:	fc040613          	addi	a2,s0,-64
    800047c4:	4581                	li	a1,0
    800047c6:	854a                	mv	a0,s2
    800047c8:	00000097          	auipc	ra,0x0
    800047cc:	c38080e7          	jalr	-968(ra) # 80004400 <writei>
    800047d0:	1541                	addi	a0,a0,-16
    800047d2:	00a03533          	snez	a0,a0
    800047d6:	40a00533          	neg	a0,a0
    800047da:	74a2                	ld	s1,40(sp)
}
    800047dc:	70e2                	ld	ra,56(sp)
    800047de:	7442                	ld	s0,48(sp)
    800047e0:	7902                	ld	s2,32(sp)
    800047e2:	69e2                	ld	s3,24(sp)
    800047e4:	6a42                	ld	s4,16(sp)
    800047e6:	6121                	addi	sp,sp,64
    800047e8:	8082                	ret
    iput(ip);
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	a0c080e7          	jalr	-1524(ra) # 800041f6 <iput>
    return -1;
    800047f2:	557d                	li	a0,-1
    800047f4:	b7e5                	j	800047dc <dirlink+0x88>
      panic("dirlink read");
    800047f6:	00004517          	auipc	a0,0x4
    800047fa:	d3250513          	addi	a0,a0,-718 # 80008528 <etext+0x528>
    800047fe:	ffffc097          	auipc	ra,0xffffc
    80004802:	d62080e7          	jalr	-670(ra) # 80000560 <panic>

0000000080004806 <namei>:

struct inode*
namei(char *path)
{
    80004806:	1101                	addi	sp,sp,-32
    80004808:	ec06                	sd	ra,24(sp)
    8000480a:	e822                	sd	s0,16(sp)
    8000480c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000480e:	fe040613          	addi	a2,s0,-32
    80004812:	4581                	li	a1,0
    80004814:	00000097          	auipc	ra,0x0
    80004818:	de0080e7          	jalr	-544(ra) # 800045f4 <namex>
}
    8000481c:	60e2                	ld	ra,24(sp)
    8000481e:	6442                	ld	s0,16(sp)
    80004820:	6105                	addi	sp,sp,32
    80004822:	8082                	ret

0000000080004824 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004824:	1141                	addi	sp,sp,-16
    80004826:	e406                	sd	ra,8(sp)
    80004828:	e022                	sd	s0,0(sp)
    8000482a:	0800                	addi	s0,sp,16
    8000482c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000482e:	4585                	li	a1,1
    80004830:	00000097          	auipc	ra,0x0
    80004834:	dc4080e7          	jalr	-572(ra) # 800045f4 <namex>
}
    80004838:	60a2                	ld	ra,8(sp)
    8000483a:	6402                	ld	s0,0(sp)
    8000483c:	0141                	addi	sp,sp,16
    8000483e:	8082                	ret

0000000080004840 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004840:	1101                	addi	sp,sp,-32
    80004842:	ec06                	sd	ra,24(sp)
    80004844:	e822                	sd	s0,16(sp)
    80004846:	e426                	sd	s1,8(sp)
    80004848:	e04a                	sd	s2,0(sp)
    8000484a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000484c:	00027917          	auipc	s2,0x27
    80004850:	19490913          	addi	s2,s2,404 # 8002b9e0 <log>
    80004854:	01892583          	lw	a1,24(s2)
    80004858:	02892503          	lw	a0,40(s2)
    8000485c:	fffff097          	auipc	ra,0xfffff
    80004860:	fa8080e7          	jalr	-88(ra) # 80003804 <bread>
    80004864:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004866:	02c92603          	lw	a2,44(s2)
    8000486a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000486c:	00c05f63          	blez	a2,8000488a <write_head+0x4a>
    80004870:	00027717          	auipc	a4,0x27
    80004874:	1a070713          	addi	a4,a4,416 # 8002ba10 <log+0x30>
    80004878:	87aa                	mv	a5,a0
    8000487a:	060a                	slli	a2,a2,0x2
    8000487c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000487e:	4314                	lw	a3,0(a4)
    80004880:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004882:	0711                	addi	a4,a4,4
    80004884:	0791                	addi	a5,a5,4
    80004886:	fec79ce3          	bne	a5,a2,8000487e <write_head+0x3e>
  }
  bwrite(buf);
    8000488a:	8526                	mv	a0,s1
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	06a080e7          	jalr	106(ra) # 800038f6 <bwrite>
  brelse(buf);
    80004894:	8526                	mv	a0,s1
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	09e080e7          	jalr	158(ra) # 80003934 <brelse>
}
    8000489e:	60e2                	ld	ra,24(sp)
    800048a0:	6442                	ld	s0,16(sp)
    800048a2:	64a2                	ld	s1,8(sp)
    800048a4:	6902                	ld	s2,0(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800048aa:	00027797          	auipc	a5,0x27
    800048ae:	1627a783          	lw	a5,354(a5) # 8002ba0c <log+0x2c>
    800048b2:	0af05d63          	blez	a5,8000496c <install_trans+0xc2>
{
    800048b6:	7139                	addi	sp,sp,-64
    800048b8:	fc06                	sd	ra,56(sp)
    800048ba:	f822                	sd	s0,48(sp)
    800048bc:	f426                	sd	s1,40(sp)
    800048be:	f04a                	sd	s2,32(sp)
    800048c0:	ec4e                	sd	s3,24(sp)
    800048c2:	e852                	sd	s4,16(sp)
    800048c4:	e456                	sd	s5,8(sp)
    800048c6:	e05a                	sd	s6,0(sp)
    800048c8:	0080                	addi	s0,sp,64
    800048ca:	8b2a                	mv	s6,a0
    800048cc:	00027a97          	auipc	s5,0x27
    800048d0:	144a8a93          	addi	s5,s5,324 # 8002ba10 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048d4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800048d6:	00027997          	auipc	s3,0x27
    800048da:	10a98993          	addi	s3,s3,266 # 8002b9e0 <log>
    800048de:	a00d                	j	80004900 <install_trans+0x56>
    brelse(lbuf);
    800048e0:	854a                	mv	a0,s2
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	052080e7          	jalr	82(ra) # 80003934 <brelse>
    brelse(dbuf);
    800048ea:	8526                	mv	a0,s1
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	048080e7          	jalr	72(ra) # 80003934 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800048f4:	2a05                	addiw	s4,s4,1
    800048f6:	0a91                	addi	s5,s5,4
    800048f8:	02c9a783          	lw	a5,44(s3)
    800048fc:	04fa5e63          	bge	s4,a5,80004958 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004900:	0189a583          	lw	a1,24(s3)
    80004904:	014585bb          	addw	a1,a1,s4
    80004908:	2585                	addiw	a1,a1,1
    8000490a:	0289a503          	lw	a0,40(s3)
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	ef6080e7          	jalr	-266(ra) # 80003804 <bread>
    80004916:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004918:	000aa583          	lw	a1,0(s5)
    8000491c:	0289a503          	lw	a0,40(s3)
    80004920:	fffff097          	auipc	ra,0xfffff
    80004924:	ee4080e7          	jalr	-284(ra) # 80003804 <bread>
    80004928:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000492a:	40000613          	li	a2,1024
    8000492e:	05890593          	addi	a1,s2,88
    80004932:	05850513          	addi	a0,a0,88
    80004936:	ffffc097          	auipc	ra,0xffffc
    8000493a:	45a080e7          	jalr	1114(ra) # 80000d90 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000493e:	8526                	mv	a0,s1
    80004940:	fffff097          	auipc	ra,0xfffff
    80004944:	fb6080e7          	jalr	-74(ra) # 800038f6 <bwrite>
    if(recovering == 0)
    80004948:	f80b1ce3          	bnez	s6,800048e0 <install_trans+0x36>
      bunpin(dbuf);
    8000494c:	8526                	mv	a0,s1
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	0be080e7          	jalr	190(ra) # 80003a0c <bunpin>
    80004956:	b769                	j	800048e0 <install_trans+0x36>
}
    80004958:	70e2                	ld	ra,56(sp)
    8000495a:	7442                	ld	s0,48(sp)
    8000495c:	74a2                	ld	s1,40(sp)
    8000495e:	7902                	ld	s2,32(sp)
    80004960:	69e2                	ld	s3,24(sp)
    80004962:	6a42                	ld	s4,16(sp)
    80004964:	6aa2                	ld	s5,8(sp)
    80004966:	6b02                	ld	s6,0(sp)
    80004968:	6121                	addi	sp,sp,64
    8000496a:	8082                	ret
    8000496c:	8082                	ret

000000008000496e <initlog>:
{
    8000496e:	7179                	addi	sp,sp,-48
    80004970:	f406                	sd	ra,40(sp)
    80004972:	f022                	sd	s0,32(sp)
    80004974:	ec26                	sd	s1,24(sp)
    80004976:	e84a                	sd	s2,16(sp)
    80004978:	e44e                	sd	s3,8(sp)
    8000497a:	1800                	addi	s0,sp,48
    8000497c:	892a                	mv	s2,a0
    8000497e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004980:	00027497          	auipc	s1,0x27
    80004984:	06048493          	addi	s1,s1,96 # 8002b9e0 <log>
    80004988:	00004597          	auipc	a1,0x4
    8000498c:	bb058593          	addi	a1,a1,-1104 # 80008538 <etext+0x538>
    80004990:	8526                	mv	a0,s1
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	216080e7          	jalr	534(ra) # 80000ba8 <initlock>
  log.start = sb->logstart;
    8000499a:	0149a583          	lw	a1,20(s3)
    8000499e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800049a0:	0109a783          	lw	a5,16(s3)
    800049a4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800049a6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800049aa:	854a                	mv	a0,s2
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	e58080e7          	jalr	-424(ra) # 80003804 <bread>
  log.lh.n = lh->n;
    800049b4:	4d30                	lw	a2,88(a0)
    800049b6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800049b8:	00c05f63          	blez	a2,800049d6 <initlog+0x68>
    800049bc:	87aa                	mv	a5,a0
    800049be:	00027717          	auipc	a4,0x27
    800049c2:	05270713          	addi	a4,a4,82 # 8002ba10 <log+0x30>
    800049c6:	060a                	slli	a2,a2,0x2
    800049c8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800049ca:	4ff4                	lw	a3,92(a5)
    800049cc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800049ce:	0791                	addi	a5,a5,4
    800049d0:	0711                	addi	a4,a4,4
    800049d2:	fec79ce3          	bne	a5,a2,800049ca <initlog+0x5c>
  brelse(buf);
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	f5e080e7          	jalr	-162(ra) # 80003934 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800049de:	4505                	li	a0,1
    800049e0:	00000097          	auipc	ra,0x0
    800049e4:	eca080e7          	jalr	-310(ra) # 800048aa <install_trans>
  log.lh.n = 0;
    800049e8:	00027797          	auipc	a5,0x27
    800049ec:	0207a223          	sw	zero,36(a5) # 8002ba0c <log+0x2c>
  write_head(); // clear the log
    800049f0:	00000097          	auipc	ra,0x0
    800049f4:	e50080e7          	jalr	-432(ra) # 80004840 <write_head>
}
    800049f8:	70a2                	ld	ra,40(sp)
    800049fa:	7402                	ld	s0,32(sp)
    800049fc:	64e2                	ld	s1,24(sp)
    800049fe:	6942                	ld	s2,16(sp)
    80004a00:	69a2                	ld	s3,8(sp)
    80004a02:	6145                	addi	sp,sp,48
    80004a04:	8082                	ret

0000000080004a06 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004a06:	1101                	addi	sp,sp,-32
    80004a08:	ec06                	sd	ra,24(sp)
    80004a0a:	e822                	sd	s0,16(sp)
    80004a0c:	e426                	sd	s1,8(sp)
    80004a0e:	e04a                	sd	s2,0(sp)
    80004a10:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004a12:	00027517          	auipc	a0,0x27
    80004a16:	fce50513          	addi	a0,a0,-50 # 8002b9e0 <log>
    80004a1a:	ffffc097          	auipc	ra,0xffffc
    80004a1e:	21e080e7          	jalr	542(ra) # 80000c38 <acquire>
  while(1){
    if(log.committing){
    80004a22:	00027497          	auipc	s1,0x27
    80004a26:	fbe48493          	addi	s1,s1,-66 # 8002b9e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004a2a:	4979                	li	s2,30
    80004a2c:	a039                	j	80004a3a <begin_op+0x34>
      sleep(&log, &log.lock);
    80004a2e:	85a6                	mv	a1,s1
    80004a30:	8526                	mv	a0,s1
    80004a32:	ffffe097          	auipc	ra,0xffffe
    80004a36:	ba2080e7          	jalr	-1118(ra) # 800025d4 <sleep>
    if(log.committing){
    80004a3a:	50dc                	lw	a5,36(s1)
    80004a3c:	fbed                	bnez	a5,80004a2e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004a3e:	5098                	lw	a4,32(s1)
    80004a40:	2705                	addiw	a4,a4,1
    80004a42:	0027179b          	slliw	a5,a4,0x2
    80004a46:	9fb9                	addw	a5,a5,a4
    80004a48:	0017979b          	slliw	a5,a5,0x1
    80004a4c:	54d4                	lw	a3,44(s1)
    80004a4e:	9fb5                	addw	a5,a5,a3
    80004a50:	00f95963          	bge	s2,a5,80004a62 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004a54:	85a6                	mv	a1,s1
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffe097          	auipc	ra,0xffffe
    80004a5c:	b7c080e7          	jalr	-1156(ra) # 800025d4 <sleep>
    80004a60:	bfe9                	j	80004a3a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004a62:	00027517          	auipc	a0,0x27
    80004a66:	f7e50513          	addi	a0,a0,-130 # 8002b9e0 <log>
    80004a6a:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004a6c:	ffffc097          	auipc	ra,0xffffc
    80004a70:	280080e7          	jalr	640(ra) # 80000cec <release>
      break;
    }
  }
}
    80004a74:	60e2                	ld	ra,24(sp)
    80004a76:	6442                	ld	s0,16(sp)
    80004a78:	64a2                	ld	s1,8(sp)
    80004a7a:	6902                	ld	s2,0(sp)
    80004a7c:	6105                	addi	sp,sp,32
    80004a7e:	8082                	ret

0000000080004a80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004a80:	7139                	addi	sp,sp,-64
    80004a82:	fc06                	sd	ra,56(sp)
    80004a84:	f822                	sd	s0,48(sp)
    80004a86:	f426                	sd	s1,40(sp)
    80004a88:	f04a                	sd	s2,32(sp)
    80004a8a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004a8c:	00027497          	auipc	s1,0x27
    80004a90:	f5448493          	addi	s1,s1,-172 # 8002b9e0 <log>
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffc097          	auipc	ra,0xffffc
    80004a9a:	1a2080e7          	jalr	418(ra) # 80000c38 <acquire>
  log.outstanding -= 1;
    80004a9e:	509c                	lw	a5,32(s1)
    80004aa0:	37fd                	addiw	a5,a5,-1
    80004aa2:	0007891b          	sext.w	s2,a5
    80004aa6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004aa8:	50dc                	lw	a5,36(s1)
    80004aaa:	e7b9                	bnez	a5,80004af8 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80004aac:	06091163          	bnez	s2,80004b0e <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80004ab0:	00027497          	auipc	s1,0x27
    80004ab4:	f3048493          	addi	s1,s1,-208 # 8002b9e0 <log>
    80004ab8:	4785                	li	a5,1
    80004aba:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004abc:	8526                	mv	a0,s1
    80004abe:	ffffc097          	auipc	ra,0xffffc
    80004ac2:	22e080e7          	jalr	558(ra) # 80000cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004ac6:	54dc                	lw	a5,44(s1)
    80004ac8:	06f04763          	bgtz	a5,80004b36 <end_op+0xb6>
    acquire(&log.lock);
    80004acc:	00027497          	auipc	s1,0x27
    80004ad0:	f1448493          	addi	s1,s1,-236 # 8002b9e0 <log>
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffc097          	auipc	ra,0xffffc
    80004ada:	162080e7          	jalr	354(ra) # 80000c38 <acquire>
    log.committing = 0;
    80004ade:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	b54080e7          	jalr	-1196(ra) # 80002638 <wakeup>
    release(&log.lock);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffc097          	auipc	ra,0xffffc
    80004af2:	1fe080e7          	jalr	510(ra) # 80000cec <release>
}
    80004af6:	a815                	j	80004b2a <end_op+0xaa>
    80004af8:	ec4e                	sd	s3,24(sp)
    80004afa:	e852                	sd	s4,16(sp)
    80004afc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004afe:	00004517          	auipc	a0,0x4
    80004b02:	a4250513          	addi	a0,a0,-1470 # 80008540 <etext+0x540>
    80004b06:	ffffc097          	auipc	ra,0xffffc
    80004b0a:	a5a080e7          	jalr	-1446(ra) # 80000560 <panic>
    wakeup(&log);
    80004b0e:	00027497          	auipc	s1,0x27
    80004b12:	ed248493          	addi	s1,s1,-302 # 8002b9e0 <log>
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	b20080e7          	jalr	-1248(ra) # 80002638 <wakeup>
  release(&log.lock);
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffc097          	auipc	ra,0xffffc
    80004b26:	1ca080e7          	jalr	458(ra) # 80000cec <release>
}
    80004b2a:	70e2                	ld	ra,56(sp)
    80004b2c:	7442                	ld	s0,48(sp)
    80004b2e:	74a2                	ld	s1,40(sp)
    80004b30:	7902                	ld	s2,32(sp)
    80004b32:	6121                	addi	sp,sp,64
    80004b34:	8082                	ret
    80004b36:	ec4e                	sd	s3,24(sp)
    80004b38:	e852                	sd	s4,16(sp)
    80004b3a:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b3c:	00027a97          	auipc	s5,0x27
    80004b40:	ed4a8a93          	addi	s5,s5,-300 # 8002ba10 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004b44:	00027a17          	auipc	s4,0x27
    80004b48:	e9ca0a13          	addi	s4,s4,-356 # 8002b9e0 <log>
    80004b4c:	018a2583          	lw	a1,24(s4)
    80004b50:	012585bb          	addw	a1,a1,s2
    80004b54:	2585                	addiw	a1,a1,1
    80004b56:	028a2503          	lw	a0,40(s4)
    80004b5a:	fffff097          	auipc	ra,0xfffff
    80004b5e:	caa080e7          	jalr	-854(ra) # 80003804 <bread>
    80004b62:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004b64:	000aa583          	lw	a1,0(s5)
    80004b68:	028a2503          	lw	a0,40(s4)
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	c98080e7          	jalr	-872(ra) # 80003804 <bread>
    80004b74:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004b76:	40000613          	li	a2,1024
    80004b7a:	05850593          	addi	a1,a0,88
    80004b7e:	05848513          	addi	a0,s1,88
    80004b82:	ffffc097          	auipc	ra,0xffffc
    80004b86:	20e080e7          	jalr	526(ra) # 80000d90 <memmove>
    bwrite(to);  // write the log
    80004b8a:	8526                	mv	a0,s1
    80004b8c:	fffff097          	auipc	ra,0xfffff
    80004b90:	d6a080e7          	jalr	-662(ra) # 800038f6 <bwrite>
    brelse(from);
    80004b94:	854e                	mv	a0,s3
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	d9e080e7          	jalr	-610(ra) # 80003934 <brelse>
    brelse(to);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	d94080e7          	jalr	-620(ra) # 80003934 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ba8:	2905                	addiw	s2,s2,1
    80004baa:	0a91                	addi	s5,s5,4
    80004bac:	02ca2783          	lw	a5,44(s4)
    80004bb0:	f8f94ee3          	blt	s2,a5,80004b4c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004bb4:	00000097          	auipc	ra,0x0
    80004bb8:	c8c080e7          	jalr	-884(ra) # 80004840 <write_head>
    install_trans(0); // Now install writes to home locations
    80004bbc:	4501                	li	a0,0
    80004bbe:	00000097          	auipc	ra,0x0
    80004bc2:	cec080e7          	jalr	-788(ra) # 800048aa <install_trans>
    log.lh.n = 0;
    80004bc6:	00027797          	auipc	a5,0x27
    80004bca:	e407a323          	sw	zero,-442(a5) # 8002ba0c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004bce:	00000097          	auipc	ra,0x0
    80004bd2:	c72080e7          	jalr	-910(ra) # 80004840 <write_head>
    80004bd6:	69e2                	ld	s3,24(sp)
    80004bd8:	6a42                	ld	s4,16(sp)
    80004bda:	6aa2                	ld	s5,8(sp)
    80004bdc:	bdc5                	j	80004acc <end_op+0x4c>

0000000080004bde <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004bde:	1101                	addi	sp,sp,-32
    80004be0:	ec06                	sd	ra,24(sp)
    80004be2:	e822                	sd	s0,16(sp)
    80004be4:	e426                	sd	s1,8(sp)
    80004be6:	e04a                	sd	s2,0(sp)
    80004be8:	1000                	addi	s0,sp,32
    80004bea:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004bec:	00027917          	auipc	s2,0x27
    80004bf0:	df490913          	addi	s2,s2,-524 # 8002b9e0 <log>
    80004bf4:	854a                	mv	a0,s2
    80004bf6:	ffffc097          	auipc	ra,0xffffc
    80004bfa:	042080e7          	jalr	66(ra) # 80000c38 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004bfe:	02c92603          	lw	a2,44(s2)
    80004c02:	47f5                	li	a5,29
    80004c04:	06c7c563          	blt	a5,a2,80004c6e <log_write+0x90>
    80004c08:	00027797          	auipc	a5,0x27
    80004c0c:	df47a783          	lw	a5,-524(a5) # 8002b9fc <log+0x1c>
    80004c10:	37fd                	addiw	a5,a5,-1
    80004c12:	04f65e63          	bge	a2,a5,80004c6e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004c16:	00027797          	auipc	a5,0x27
    80004c1a:	dea7a783          	lw	a5,-534(a5) # 8002ba00 <log+0x20>
    80004c1e:	06f05063          	blez	a5,80004c7e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004c22:	4781                	li	a5,0
    80004c24:	06c05563          	blez	a2,80004c8e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004c28:	44cc                	lw	a1,12(s1)
    80004c2a:	00027717          	auipc	a4,0x27
    80004c2e:	de670713          	addi	a4,a4,-538 # 8002ba10 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004c32:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004c34:	4314                	lw	a3,0(a4)
    80004c36:	04b68c63          	beq	a3,a1,80004c8e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004c3a:	2785                	addiw	a5,a5,1
    80004c3c:	0711                	addi	a4,a4,4
    80004c3e:	fef61be3          	bne	a2,a5,80004c34 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004c42:	0621                	addi	a2,a2,8
    80004c44:	060a                	slli	a2,a2,0x2
    80004c46:	00027797          	auipc	a5,0x27
    80004c4a:	d9a78793          	addi	a5,a5,-614 # 8002b9e0 <log>
    80004c4e:	97b2                	add	a5,a5,a2
    80004c50:	44d8                	lw	a4,12(s1)
    80004c52:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004c54:	8526                	mv	a0,s1
    80004c56:	fffff097          	auipc	ra,0xfffff
    80004c5a:	d7a080e7          	jalr	-646(ra) # 800039d0 <bpin>
    log.lh.n++;
    80004c5e:	00027717          	auipc	a4,0x27
    80004c62:	d8270713          	addi	a4,a4,-638 # 8002b9e0 <log>
    80004c66:	575c                	lw	a5,44(a4)
    80004c68:	2785                	addiw	a5,a5,1
    80004c6a:	d75c                	sw	a5,44(a4)
    80004c6c:	a82d                	j	80004ca6 <log_write+0xc8>
    panic("too big a transaction");
    80004c6e:	00004517          	auipc	a0,0x4
    80004c72:	8e250513          	addi	a0,a0,-1822 # 80008550 <etext+0x550>
    80004c76:	ffffc097          	auipc	ra,0xffffc
    80004c7a:	8ea080e7          	jalr	-1814(ra) # 80000560 <panic>
    panic("log_write outside of trans");
    80004c7e:	00004517          	auipc	a0,0x4
    80004c82:	8ea50513          	addi	a0,a0,-1814 # 80008568 <etext+0x568>
    80004c86:	ffffc097          	auipc	ra,0xffffc
    80004c8a:	8da080e7          	jalr	-1830(ra) # 80000560 <panic>
  log.lh.block[i] = b->blockno;
    80004c8e:	00878693          	addi	a3,a5,8
    80004c92:	068a                	slli	a3,a3,0x2
    80004c94:	00027717          	auipc	a4,0x27
    80004c98:	d4c70713          	addi	a4,a4,-692 # 8002b9e0 <log>
    80004c9c:	9736                	add	a4,a4,a3
    80004c9e:	44d4                	lw	a3,12(s1)
    80004ca0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004ca2:	faf609e3          	beq	a2,a5,80004c54 <log_write+0x76>
  }
  release(&log.lock);
    80004ca6:	00027517          	auipc	a0,0x27
    80004caa:	d3a50513          	addi	a0,a0,-710 # 8002b9e0 <log>
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	03e080e7          	jalr	62(ra) # 80000cec <release>
}
    80004cb6:	60e2                	ld	ra,24(sp)
    80004cb8:	6442                	ld	s0,16(sp)
    80004cba:	64a2                	ld	s1,8(sp)
    80004cbc:	6902                	ld	s2,0(sp)
    80004cbe:	6105                	addi	sp,sp,32
    80004cc0:	8082                	ret

0000000080004cc2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004cc2:	1101                	addi	sp,sp,-32
    80004cc4:	ec06                	sd	ra,24(sp)
    80004cc6:	e822                	sd	s0,16(sp)
    80004cc8:	e426                	sd	s1,8(sp)
    80004cca:	e04a                	sd	s2,0(sp)
    80004ccc:	1000                	addi	s0,sp,32
    80004cce:	84aa                	mv	s1,a0
    80004cd0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004cd2:	00004597          	auipc	a1,0x4
    80004cd6:	8b658593          	addi	a1,a1,-1866 # 80008588 <etext+0x588>
    80004cda:	0521                	addi	a0,a0,8
    80004cdc:	ffffc097          	auipc	ra,0xffffc
    80004ce0:	ecc080e7          	jalr	-308(ra) # 80000ba8 <initlock>
  lk->name = name;
    80004ce4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004ce8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004cec:	0204a423          	sw	zero,40(s1)
}
    80004cf0:	60e2                	ld	ra,24(sp)
    80004cf2:	6442                	ld	s0,16(sp)
    80004cf4:	64a2                	ld	s1,8(sp)
    80004cf6:	6902                	ld	s2,0(sp)
    80004cf8:	6105                	addi	sp,sp,32
    80004cfa:	8082                	ret

0000000080004cfc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004cfc:	1101                	addi	sp,sp,-32
    80004cfe:	ec06                	sd	ra,24(sp)
    80004d00:	e822                	sd	s0,16(sp)
    80004d02:	e426                	sd	s1,8(sp)
    80004d04:	e04a                	sd	s2,0(sp)
    80004d06:	1000                	addi	s0,sp,32
    80004d08:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004d0a:	00850913          	addi	s2,a0,8
    80004d0e:	854a                	mv	a0,s2
    80004d10:	ffffc097          	auipc	ra,0xffffc
    80004d14:	f28080e7          	jalr	-216(ra) # 80000c38 <acquire>
  while (lk->locked) {
    80004d18:	409c                	lw	a5,0(s1)
    80004d1a:	cb89                	beqz	a5,80004d2c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004d1c:	85ca                	mv	a1,s2
    80004d1e:	8526                	mv	a0,s1
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	8b4080e7          	jalr	-1868(ra) # 800025d4 <sleep>
  while (lk->locked) {
    80004d28:	409c                	lw	a5,0(s1)
    80004d2a:	fbed                	bnez	a5,80004d1c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004d2c:	4785                	li	a5,1
    80004d2e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	eba080e7          	jalr	-326(ra) # 80001bea <myproc>
    80004d38:	591c                	lw	a5,48(a0)
    80004d3a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004d3c:	854a                	mv	a0,s2
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	fae080e7          	jalr	-82(ra) # 80000cec <release>
}
    80004d46:	60e2                	ld	ra,24(sp)
    80004d48:	6442                	ld	s0,16(sp)
    80004d4a:	64a2                	ld	s1,8(sp)
    80004d4c:	6902                	ld	s2,0(sp)
    80004d4e:	6105                	addi	sp,sp,32
    80004d50:	8082                	ret

0000000080004d52 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004d52:	1101                	addi	sp,sp,-32
    80004d54:	ec06                	sd	ra,24(sp)
    80004d56:	e822                	sd	s0,16(sp)
    80004d58:	e426                	sd	s1,8(sp)
    80004d5a:	e04a                	sd	s2,0(sp)
    80004d5c:	1000                	addi	s0,sp,32
    80004d5e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004d60:	00850913          	addi	s2,a0,8
    80004d64:	854a                	mv	a0,s2
    80004d66:	ffffc097          	auipc	ra,0xffffc
    80004d6a:	ed2080e7          	jalr	-302(ra) # 80000c38 <acquire>
  lk->locked = 0;
    80004d6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004d72:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	8c0080e7          	jalr	-1856(ra) # 80002638 <wakeup>
  release(&lk->lk);
    80004d80:	854a                	mv	a0,s2
    80004d82:	ffffc097          	auipc	ra,0xffffc
    80004d86:	f6a080e7          	jalr	-150(ra) # 80000cec <release>
}
    80004d8a:	60e2                	ld	ra,24(sp)
    80004d8c:	6442                	ld	s0,16(sp)
    80004d8e:	64a2                	ld	s1,8(sp)
    80004d90:	6902                	ld	s2,0(sp)
    80004d92:	6105                	addi	sp,sp,32
    80004d94:	8082                	ret

0000000080004d96 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004d96:	7179                	addi	sp,sp,-48
    80004d98:	f406                	sd	ra,40(sp)
    80004d9a:	f022                	sd	s0,32(sp)
    80004d9c:	ec26                	sd	s1,24(sp)
    80004d9e:	e84a                	sd	s2,16(sp)
    80004da0:	1800                	addi	s0,sp,48
    80004da2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004da4:	00850913          	addi	s2,a0,8
    80004da8:	854a                	mv	a0,s2
    80004daa:	ffffc097          	auipc	ra,0xffffc
    80004dae:	e8e080e7          	jalr	-370(ra) # 80000c38 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004db2:	409c                	lw	a5,0(s1)
    80004db4:	ef91                	bnez	a5,80004dd0 <holdingsleep+0x3a>
    80004db6:	4481                	li	s1,0
  release(&lk->lk);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffc097          	auipc	ra,0xffffc
    80004dbe:	f32080e7          	jalr	-206(ra) # 80000cec <release>
  return r;
}
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	70a2                	ld	ra,40(sp)
    80004dc6:	7402                	ld	s0,32(sp)
    80004dc8:	64e2                	ld	s1,24(sp)
    80004dca:	6942                	ld	s2,16(sp)
    80004dcc:	6145                	addi	sp,sp,48
    80004dce:	8082                	ret
    80004dd0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004dd2:	0284a983          	lw	s3,40(s1)
    80004dd6:	ffffd097          	auipc	ra,0xffffd
    80004dda:	e14080e7          	jalr	-492(ra) # 80001bea <myproc>
    80004dde:	5904                	lw	s1,48(a0)
    80004de0:	413484b3          	sub	s1,s1,s3
    80004de4:	0014b493          	seqz	s1,s1
    80004de8:	69a2                	ld	s3,8(sp)
    80004dea:	b7f9                	j	80004db8 <holdingsleep+0x22>

0000000080004dec <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004dec:	1141                	addi	sp,sp,-16
    80004dee:	e406                	sd	ra,8(sp)
    80004df0:	e022                	sd	s0,0(sp)
    80004df2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004df4:	00003597          	auipc	a1,0x3
    80004df8:	7a458593          	addi	a1,a1,1956 # 80008598 <etext+0x598>
    80004dfc:	00027517          	auipc	a0,0x27
    80004e00:	d2c50513          	addi	a0,a0,-724 # 8002bb28 <ftable>
    80004e04:	ffffc097          	auipc	ra,0xffffc
    80004e08:	da4080e7          	jalr	-604(ra) # 80000ba8 <initlock>
}
    80004e0c:	60a2                	ld	ra,8(sp)
    80004e0e:	6402                	ld	s0,0(sp)
    80004e10:	0141                	addi	sp,sp,16
    80004e12:	8082                	ret

0000000080004e14 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004e14:	1101                	addi	sp,sp,-32
    80004e16:	ec06                	sd	ra,24(sp)
    80004e18:	e822                	sd	s0,16(sp)
    80004e1a:	e426                	sd	s1,8(sp)
    80004e1c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004e1e:	00027517          	auipc	a0,0x27
    80004e22:	d0a50513          	addi	a0,a0,-758 # 8002bb28 <ftable>
    80004e26:	ffffc097          	auipc	ra,0xffffc
    80004e2a:	e12080e7          	jalr	-494(ra) # 80000c38 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004e2e:	00027497          	auipc	s1,0x27
    80004e32:	d1248493          	addi	s1,s1,-750 # 8002bb40 <ftable+0x18>
    80004e36:	00028717          	auipc	a4,0x28
    80004e3a:	caa70713          	addi	a4,a4,-854 # 8002cae0 <disk>
    if(f->ref == 0){
    80004e3e:	40dc                	lw	a5,4(s1)
    80004e40:	cf99                	beqz	a5,80004e5e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004e42:	02848493          	addi	s1,s1,40
    80004e46:	fee49ce3          	bne	s1,a4,80004e3e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004e4a:	00027517          	auipc	a0,0x27
    80004e4e:	cde50513          	addi	a0,a0,-802 # 8002bb28 <ftable>
    80004e52:	ffffc097          	auipc	ra,0xffffc
    80004e56:	e9a080e7          	jalr	-358(ra) # 80000cec <release>
  return 0;
    80004e5a:	4481                	li	s1,0
    80004e5c:	a819                	j	80004e72 <filealloc+0x5e>
      f->ref = 1;
    80004e5e:	4785                	li	a5,1
    80004e60:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004e62:	00027517          	auipc	a0,0x27
    80004e66:	cc650513          	addi	a0,a0,-826 # 8002bb28 <ftable>
    80004e6a:	ffffc097          	auipc	ra,0xffffc
    80004e6e:	e82080e7          	jalr	-382(ra) # 80000cec <release>
}
    80004e72:	8526                	mv	a0,s1
    80004e74:	60e2                	ld	ra,24(sp)
    80004e76:	6442                	ld	s0,16(sp)
    80004e78:	64a2                	ld	s1,8(sp)
    80004e7a:	6105                	addi	sp,sp,32
    80004e7c:	8082                	ret

0000000080004e7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004e7e:	1101                	addi	sp,sp,-32
    80004e80:	ec06                	sd	ra,24(sp)
    80004e82:	e822                	sd	s0,16(sp)
    80004e84:	e426                	sd	s1,8(sp)
    80004e86:	1000                	addi	s0,sp,32
    80004e88:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004e8a:	00027517          	auipc	a0,0x27
    80004e8e:	c9e50513          	addi	a0,a0,-866 # 8002bb28 <ftable>
    80004e92:	ffffc097          	auipc	ra,0xffffc
    80004e96:	da6080e7          	jalr	-602(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004e9a:	40dc                	lw	a5,4(s1)
    80004e9c:	02f05263          	blez	a5,80004ec0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004ea0:	2785                	addiw	a5,a5,1
    80004ea2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ea4:	00027517          	auipc	a0,0x27
    80004ea8:	c8450513          	addi	a0,a0,-892 # 8002bb28 <ftable>
    80004eac:	ffffc097          	auipc	ra,0xffffc
    80004eb0:	e40080e7          	jalr	-448(ra) # 80000cec <release>
  return f;
}
    80004eb4:	8526                	mv	a0,s1
    80004eb6:	60e2                	ld	ra,24(sp)
    80004eb8:	6442                	ld	s0,16(sp)
    80004eba:	64a2                	ld	s1,8(sp)
    80004ebc:	6105                	addi	sp,sp,32
    80004ebe:	8082                	ret
    panic("filedup");
    80004ec0:	00003517          	auipc	a0,0x3
    80004ec4:	6e050513          	addi	a0,a0,1760 # 800085a0 <etext+0x5a0>
    80004ec8:	ffffb097          	auipc	ra,0xffffb
    80004ecc:	698080e7          	jalr	1688(ra) # 80000560 <panic>

0000000080004ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004ed0:	7139                	addi	sp,sp,-64
    80004ed2:	fc06                	sd	ra,56(sp)
    80004ed4:	f822                	sd	s0,48(sp)
    80004ed6:	f426                	sd	s1,40(sp)
    80004ed8:	0080                	addi	s0,sp,64
    80004eda:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004edc:	00027517          	auipc	a0,0x27
    80004ee0:	c4c50513          	addi	a0,a0,-948 # 8002bb28 <ftable>
    80004ee4:	ffffc097          	auipc	ra,0xffffc
    80004ee8:	d54080e7          	jalr	-684(ra) # 80000c38 <acquire>
  if(f->ref < 1)
    80004eec:	40dc                	lw	a5,4(s1)
    80004eee:	04f05c63          	blez	a5,80004f46 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004ef2:	37fd                	addiw	a5,a5,-1
    80004ef4:	0007871b          	sext.w	a4,a5
    80004ef8:	c0dc                	sw	a5,4(s1)
    80004efa:	06e04263          	bgtz	a4,80004f5e <fileclose+0x8e>
    80004efe:	f04a                	sd	s2,32(sp)
    80004f00:	ec4e                	sd	s3,24(sp)
    80004f02:	e852                	sd	s4,16(sp)
    80004f04:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004f06:	0004a903          	lw	s2,0(s1)
    80004f0a:	0094ca83          	lbu	s5,9(s1)
    80004f0e:	0104ba03          	ld	s4,16(s1)
    80004f12:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004f16:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004f1a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004f1e:	00027517          	auipc	a0,0x27
    80004f22:	c0a50513          	addi	a0,a0,-1014 # 8002bb28 <ftable>
    80004f26:	ffffc097          	auipc	ra,0xffffc
    80004f2a:	dc6080e7          	jalr	-570(ra) # 80000cec <release>

  if(ff.type == FD_PIPE){
    80004f2e:	4785                	li	a5,1
    80004f30:	04f90463          	beq	s2,a5,80004f78 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004f34:	3979                	addiw	s2,s2,-2
    80004f36:	4785                	li	a5,1
    80004f38:	0527fb63          	bgeu	a5,s2,80004f8e <fileclose+0xbe>
    80004f3c:	7902                	ld	s2,32(sp)
    80004f3e:	69e2                	ld	s3,24(sp)
    80004f40:	6a42                	ld	s4,16(sp)
    80004f42:	6aa2                	ld	s5,8(sp)
    80004f44:	a02d                	j	80004f6e <fileclose+0x9e>
    80004f46:	f04a                	sd	s2,32(sp)
    80004f48:	ec4e                	sd	s3,24(sp)
    80004f4a:	e852                	sd	s4,16(sp)
    80004f4c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004f4e:	00003517          	auipc	a0,0x3
    80004f52:	65a50513          	addi	a0,a0,1626 # 800085a8 <etext+0x5a8>
    80004f56:	ffffb097          	auipc	ra,0xffffb
    80004f5a:	60a080e7          	jalr	1546(ra) # 80000560 <panic>
    release(&ftable.lock);
    80004f5e:	00027517          	auipc	a0,0x27
    80004f62:	bca50513          	addi	a0,a0,-1078 # 8002bb28 <ftable>
    80004f66:	ffffc097          	auipc	ra,0xffffc
    80004f6a:	d86080e7          	jalr	-634(ra) # 80000cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004f6e:	70e2                	ld	ra,56(sp)
    80004f70:	7442                	ld	s0,48(sp)
    80004f72:	74a2                	ld	s1,40(sp)
    80004f74:	6121                	addi	sp,sp,64
    80004f76:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004f78:	85d6                	mv	a1,s5
    80004f7a:	8552                	mv	a0,s4
    80004f7c:	00000097          	auipc	ra,0x0
    80004f80:	3a2080e7          	jalr	930(ra) # 8000531e <pipeclose>
    80004f84:	7902                	ld	s2,32(sp)
    80004f86:	69e2                	ld	s3,24(sp)
    80004f88:	6a42                	ld	s4,16(sp)
    80004f8a:	6aa2                	ld	s5,8(sp)
    80004f8c:	b7cd                	j	80004f6e <fileclose+0x9e>
    begin_op();
    80004f8e:	00000097          	auipc	ra,0x0
    80004f92:	a78080e7          	jalr	-1416(ra) # 80004a06 <begin_op>
    iput(ff.ip);
    80004f96:	854e                	mv	a0,s3
    80004f98:	fffff097          	auipc	ra,0xfffff
    80004f9c:	25e080e7          	jalr	606(ra) # 800041f6 <iput>
    end_op();
    80004fa0:	00000097          	auipc	ra,0x0
    80004fa4:	ae0080e7          	jalr	-1312(ra) # 80004a80 <end_op>
    80004fa8:	7902                	ld	s2,32(sp)
    80004faa:	69e2                	ld	s3,24(sp)
    80004fac:	6a42                	ld	s4,16(sp)
    80004fae:	6aa2                	ld	s5,8(sp)
    80004fb0:	bf7d                	j	80004f6e <fileclose+0x9e>

0000000080004fb2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004fb2:	715d                	addi	sp,sp,-80
    80004fb4:	e486                	sd	ra,72(sp)
    80004fb6:	e0a2                	sd	s0,64(sp)
    80004fb8:	fc26                	sd	s1,56(sp)
    80004fba:	f44e                	sd	s3,40(sp)
    80004fbc:	0880                	addi	s0,sp,80
    80004fbe:	84aa                	mv	s1,a0
    80004fc0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	c28080e7          	jalr	-984(ra) # 80001bea <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004fca:	409c                	lw	a5,0(s1)
    80004fcc:	37f9                	addiw	a5,a5,-2
    80004fce:	4705                	li	a4,1
    80004fd0:	04f76863          	bltu	a4,a5,80005020 <filestat+0x6e>
    80004fd4:	f84a                	sd	s2,48(sp)
    80004fd6:	892a                	mv	s2,a0
    ilock(f->ip);
    80004fd8:	6c88                	ld	a0,24(s1)
    80004fda:	fffff097          	auipc	ra,0xfffff
    80004fde:	05e080e7          	jalr	94(ra) # 80004038 <ilock>
    stati(f->ip, &st);
    80004fe2:	fb840593          	addi	a1,s0,-72
    80004fe6:	6c88                	ld	a0,24(s1)
    80004fe8:	fffff097          	auipc	ra,0xfffff
    80004fec:	2de080e7          	jalr	734(ra) # 800042c6 <stati>
    iunlock(f->ip);
    80004ff0:	6c88                	ld	a0,24(s1)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	10c080e7          	jalr	268(ra) # 800040fe <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004ffa:	46e1                	li	a3,24
    80004ffc:	fb840613          	addi	a2,s0,-72
    80005000:	85ce                	mv	a1,s3
    80005002:	22893503          	ld	a0,552(s2)
    80005006:	ffffc097          	auipc	ra,0xffffc
    8000500a:	6dc080e7          	jalr	1756(ra) # 800016e2 <copyout>
    8000500e:	41f5551b          	sraiw	a0,a0,0x1f
    80005012:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005014:	60a6                	ld	ra,72(sp)
    80005016:	6406                	ld	s0,64(sp)
    80005018:	74e2                	ld	s1,56(sp)
    8000501a:	79a2                	ld	s3,40(sp)
    8000501c:	6161                	addi	sp,sp,80
    8000501e:	8082                	ret
  return -1;
    80005020:	557d                	li	a0,-1
    80005022:	bfcd                	j	80005014 <filestat+0x62>

0000000080005024 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005024:	7179                	addi	sp,sp,-48
    80005026:	f406                	sd	ra,40(sp)
    80005028:	f022                	sd	s0,32(sp)
    8000502a:	e84a                	sd	s2,16(sp)
    8000502c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000502e:	00854783          	lbu	a5,8(a0)
    80005032:	cbc5                	beqz	a5,800050e2 <fileread+0xbe>
    80005034:	ec26                	sd	s1,24(sp)
    80005036:	e44e                	sd	s3,8(sp)
    80005038:	84aa                	mv	s1,a0
    8000503a:	89ae                	mv	s3,a1
    8000503c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000503e:	411c                	lw	a5,0(a0)
    80005040:	4705                	li	a4,1
    80005042:	04e78963          	beq	a5,a4,80005094 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005046:	470d                	li	a4,3
    80005048:	04e78f63          	beq	a5,a4,800050a6 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000504c:	4709                	li	a4,2
    8000504e:	08e79263          	bne	a5,a4,800050d2 <fileread+0xae>
    ilock(f->ip);
    80005052:	6d08                	ld	a0,24(a0)
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	fe4080e7          	jalr	-28(ra) # 80004038 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000505c:	874a                	mv	a4,s2
    8000505e:	5094                	lw	a3,32(s1)
    80005060:	864e                	mv	a2,s3
    80005062:	4585                	li	a1,1
    80005064:	6c88                	ld	a0,24(s1)
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	28a080e7          	jalr	650(ra) # 800042f0 <readi>
    8000506e:	892a                	mv	s2,a0
    80005070:	00a05563          	blez	a0,8000507a <fileread+0x56>
      f->off += r;
    80005074:	509c                	lw	a5,32(s1)
    80005076:	9fa9                	addw	a5,a5,a0
    80005078:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000507a:	6c88                	ld	a0,24(s1)
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	082080e7          	jalr	130(ra) # 800040fe <iunlock>
    80005084:	64e2                	ld	s1,24(sp)
    80005086:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80005088:	854a                	mv	a0,s2
    8000508a:	70a2                	ld	ra,40(sp)
    8000508c:	7402                	ld	s0,32(sp)
    8000508e:	6942                	ld	s2,16(sp)
    80005090:	6145                	addi	sp,sp,48
    80005092:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005094:	6908                	ld	a0,16(a0)
    80005096:	00000097          	auipc	ra,0x0
    8000509a:	400080e7          	jalr	1024(ra) # 80005496 <piperead>
    8000509e:	892a                	mv	s2,a0
    800050a0:	64e2                	ld	s1,24(sp)
    800050a2:	69a2                	ld	s3,8(sp)
    800050a4:	b7d5                	j	80005088 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800050a6:	02451783          	lh	a5,36(a0)
    800050aa:	03079693          	slli	a3,a5,0x30
    800050ae:	92c1                	srli	a3,a3,0x30
    800050b0:	4725                	li	a4,9
    800050b2:	02d76a63          	bltu	a4,a3,800050e6 <fileread+0xc2>
    800050b6:	0792                	slli	a5,a5,0x4
    800050b8:	00027717          	auipc	a4,0x27
    800050bc:	9d070713          	addi	a4,a4,-1584 # 8002ba88 <devsw>
    800050c0:	97ba                	add	a5,a5,a4
    800050c2:	639c                	ld	a5,0(a5)
    800050c4:	c78d                	beqz	a5,800050ee <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    800050c6:	4505                	li	a0,1
    800050c8:	9782                	jalr	a5
    800050ca:	892a                	mv	s2,a0
    800050cc:	64e2                	ld	s1,24(sp)
    800050ce:	69a2                	ld	s3,8(sp)
    800050d0:	bf65                	j	80005088 <fileread+0x64>
    panic("fileread");
    800050d2:	00003517          	auipc	a0,0x3
    800050d6:	4e650513          	addi	a0,a0,1254 # 800085b8 <etext+0x5b8>
    800050da:	ffffb097          	auipc	ra,0xffffb
    800050de:	486080e7          	jalr	1158(ra) # 80000560 <panic>
    return -1;
    800050e2:	597d                	li	s2,-1
    800050e4:	b755                	j	80005088 <fileread+0x64>
      return -1;
    800050e6:	597d                	li	s2,-1
    800050e8:	64e2                	ld	s1,24(sp)
    800050ea:	69a2                	ld	s3,8(sp)
    800050ec:	bf71                	j	80005088 <fileread+0x64>
    800050ee:	597d                	li	s2,-1
    800050f0:	64e2                	ld	s1,24(sp)
    800050f2:	69a2                	ld	s3,8(sp)
    800050f4:	bf51                	j	80005088 <fileread+0x64>

00000000800050f6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800050f6:	00954783          	lbu	a5,9(a0)
    800050fa:	12078963          	beqz	a5,8000522c <filewrite+0x136>
{
    800050fe:	715d                	addi	sp,sp,-80
    80005100:	e486                	sd	ra,72(sp)
    80005102:	e0a2                	sd	s0,64(sp)
    80005104:	f84a                	sd	s2,48(sp)
    80005106:	f052                	sd	s4,32(sp)
    80005108:	e85a                	sd	s6,16(sp)
    8000510a:	0880                	addi	s0,sp,80
    8000510c:	892a                	mv	s2,a0
    8000510e:	8b2e                	mv	s6,a1
    80005110:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005112:	411c                	lw	a5,0(a0)
    80005114:	4705                	li	a4,1
    80005116:	02e78763          	beq	a5,a4,80005144 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000511a:	470d                	li	a4,3
    8000511c:	02e78a63          	beq	a5,a4,80005150 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005120:	4709                	li	a4,2
    80005122:	0ee79863          	bne	a5,a4,80005212 <filewrite+0x11c>
    80005126:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005128:	0cc05463          	blez	a2,800051f0 <filewrite+0xfa>
    8000512c:	fc26                	sd	s1,56(sp)
    8000512e:	ec56                	sd	s5,24(sp)
    80005130:	e45e                	sd	s7,8(sp)
    80005132:	e062                	sd	s8,0(sp)
    int i = 0;
    80005134:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80005136:	6b85                	lui	s7,0x1
    80005138:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000513c:	6c05                	lui	s8,0x1
    8000513e:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005142:	a851                	j	800051d6 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80005144:	6908                	ld	a0,16(a0)
    80005146:	00000097          	auipc	ra,0x0
    8000514a:	248080e7          	jalr	584(ra) # 8000538e <pipewrite>
    8000514e:	a85d                	j	80005204 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005150:	02451783          	lh	a5,36(a0)
    80005154:	03079693          	slli	a3,a5,0x30
    80005158:	92c1                	srli	a3,a3,0x30
    8000515a:	4725                	li	a4,9
    8000515c:	0cd76a63          	bltu	a4,a3,80005230 <filewrite+0x13a>
    80005160:	0792                	slli	a5,a5,0x4
    80005162:	00027717          	auipc	a4,0x27
    80005166:	92670713          	addi	a4,a4,-1754 # 8002ba88 <devsw>
    8000516a:	97ba                	add	a5,a5,a4
    8000516c:	679c                	ld	a5,8(a5)
    8000516e:	c3f9                	beqz	a5,80005234 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80005170:	4505                	li	a0,1
    80005172:	9782                	jalr	a5
    80005174:	a841                	j	80005204 <filewrite+0x10e>
      if(n1 > max)
    80005176:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    8000517a:	00000097          	auipc	ra,0x0
    8000517e:	88c080e7          	jalr	-1908(ra) # 80004a06 <begin_op>
      ilock(f->ip);
    80005182:	01893503          	ld	a0,24(s2)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	eb2080e7          	jalr	-334(ra) # 80004038 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000518e:	8756                	mv	a4,s5
    80005190:	02092683          	lw	a3,32(s2)
    80005194:	01698633          	add	a2,s3,s6
    80005198:	4585                	li	a1,1
    8000519a:	01893503          	ld	a0,24(s2)
    8000519e:	fffff097          	auipc	ra,0xfffff
    800051a2:	262080e7          	jalr	610(ra) # 80004400 <writei>
    800051a6:	84aa                	mv	s1,a0
    800051a8:	00a05763          	blez	a0,800051b6 <filewrite+0xc0>
        f->off += r;
    800051ac:	02092783          	lw	a5,32(s2)
    800051b0:	9fa9                	addw	a5,a5,a0
    800051b2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800051b6:	01893503          	ld	a0,24(s2)
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	f44080e7          	jalr	-188(ra) # 800040fe <iunlock>
      end_op();
    800051c2:	00000097          	auipc	ra,0x0
    800051c6:	8be080e7          	jalr	-1858(ra) # 80004a80 <end_op>

      if(r != n1){
    800051ca:	029a9563          	bne	s5,s1,800051f4 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    800051ce:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800051d2:	0149da63          	bge	s3,s4,800051e6 <filewrite+0xf0>
      int n1 = n - i;
    800051d6:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800051da:	0004879b          	sext.w	a5,s1
    800051de:	f8fbdce3          	bge	s7,a5,80005176 <filewrite+0x80>
    800051e2:	84e2                	mv	s1,s8
    800051e4:	bf49                	j	80005176 <filewrite+0x80>
    800051e6:	74e2                	ld	s1,56(sp)
    800051e8:	6ae2                	ld	s5,24(sp)
    800051ea:	6ba2                	ld	s7,8(sp)
    800051ec:	6c02                	ld	s8,0(sp)
    800051ee:	a039                	j	800051fc <filewrite+0x106>
    int i = 0;
    800051f0:	4981                	li	s3,0
    800051f2:	a029                	j	800051fc <filewrite+0x106>
    800051f4:	74e2                	ld	s1,56(sp)
    800051f6:	6ae2                	ld	s5,24(sp)
    800051f8:	6ba2                	ld	s7,8(sp)
    800051fa:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    800051fc:	033a1e63          	bne	s4,s3,80005238 <filewrite+0x142>
    80005200:	8552                	mv	a0,s4
    80005202:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005204:	60a6                	ld	ra,72(sp)
    80005206:	6406                	ld	s0,64(sp)
    80005208:	7942                	ld	s2,48(sp)
    8000520a:	7a02                	ld	s4,32(sp)
    8000520c:	6b42                	ld	s6,16(sp)
    8000520e:	6161                	addi	sp,sp,80
    80005210:	8082                	ret
    80005212:	fc26                	sd	s1,56(sp)
    80005214:	f44e                	sd	s3,40(sp)
    80005216:	ec56                	sd	s5,24(sp)
    80005218:	e45e                	sd	s7,8(sp)
    8000521a:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000521c:	00003517          	auipc	a0,0x3
    80005220:	3ac50513          	addi	a0,a0,940 # 800085c8 <etext+0x5c8>
    80005224:	ffffb097          	auipc	ra,0xffffb
    80005228:	33c080e7          	jalr	828(ra) # 80000560 <panic>
    return -1;
    8000522c:	557d                	li	a0,-1
}
    8000522e:	8082                	ret
      return -1;
    80005230:	557d                	li	a0,-1
    80005232:	bfc9                	j	80005204 <filewrite+0x10e>
    80005234:	557d                	li	a0,-1
    80005236:	b7f9                	j	80005204 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80005238:	557d                	li	a0,-1
    8000523a:	79a2                	ld	s3,40(sp)
    8000523c:	b7e1                	j	80005204 <filewrite+0x10e>

000000008000523e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000523e:	7179                	addi	sp,sp,-48
    80005240:	f406                	sd	ra,40(sp)
    80005242:	f022                	sd	s0,32(sp)
    80005244:	ec26                	sd	s1,24(sp)
    80005246:	e052                	sd	s4,0(sp)
    80005248:	1800                	addi	s0,sp,48
    8000524a:	84aa                	mv	s1,a0
    8000524c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000524e:	0005b023          	sd	zero,0(a1)
    80005252:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005256:	00000097          	auipc	ra,0x0
    8000525a:	bbe080e7          	jalr	-1090(ra) # 80004e14 <filealloc>
    8000525e:	e088                	sd	a0,0(s1)
    80005260:	cd49                	beqz	a0,800052fa <pipealloc+0xbc>
    80005262:	00000097          	auipc	ra,0x0
    80005266:	bb2080e7          	jalr	-1102(ra) # 80004e14 <filealloc>
    8000526a:	00aa3023          	sd	a0,0(s4)
    8000526e:	c141                	beqz	a0,800052ee <pipealloc+0xb0>
    80005270:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	8d6080e7          	jalr	-1834(ra) # 80000b48 <kalloc>
    8000527a:	892a                	mv	s2,a0
    8000527c:	c13d                	beqz	a0,800052e2 <pipealloc+0xa4>
    8000527e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005280:	4985                	li	s3,1
    80005282:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005286:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000528a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000528e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005292:	00003597          	auipc	a1,0x3
    80005296:	34658593          	addi	a1,a1,838 # 800085d8 <etext+0x5d8>
    8000529a:	ffffc097          	auipc	ra,0xffffc
    8000529e:	90e080e7          	jalr	-1778(ra) # 80000ba8 <initlock>
  (*f0)->type = FD_PIPE;
    800052a2:	609c                	ld	a5,0(s1)
    800052a4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800052a8:	609c                	ld	a5,0(s1)
    800052aa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800052ae:	609c                	ld	a5,0(s1)
    800052b0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800052b4:	609c                	ld	a5,0(s1)
    800052b6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800052ba:	000a3783          	ld	a5,0(s4)
    800052be:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800052c2:	000a3783          	ld	a5,0(s4)
    800052c6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800052ca:	000a3783          	ld	a5,0(s4)
    800052ce:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800052d2:	000a3783          	ld	a5,0(s4)
    800052d6:	0127b823          	sd	s2,16(a5)
  return 0;
    800052da:	4501                	li	a0,0
    800052dc:	6942                	ld	s2,16(sp)
    800052de:	69a2                	ld	s3,8(sp)
    800052e0:	a03d                	j	8000530e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800052e2:	6088                	ld	a0,0(s1)
    800052e4:	c119                	beqz	a0,800052ea <pipealloc+0xac>
    800052e6:	6942                	ld	s2,16(sp)
    800052e8:	a029                	j	800052f2 <pipealloc+0xb4>
    800052ea:	6942                	ld	s2,16(sp)
    800052ec:	a039                	j	800052fa <pipealloc+0xbc>
    800052ee:	6088                	ld	a0,0(s1)
    800052f0:	c50d                	beqz	a0,8000531a <pipealloc+0xdc>
    fileclose(*f0);
    800052f2:	00000097          	auipc	ra,0x0
    800052f6:	bde080e7          	jalr	-1058(ra) # 80004ed0 <fileclose>
  if(*f1)
    800052fa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800052fe:	557d                	li	a0,-1
  if(*f1)
    80005300:	c799                	beqz	a5,8000530e <pipealloc+0xd0>
    fileclose(*f1);
    80005302:	853e                	mv	a0,a5
    80005304:	00000097          	auipc	ra,0x0
    80005308:	bcc080e7          	jalr	-1076(ra) # 80004ed0 <fileclose>
  return -1;
    8000530c:	557d                	li	a0,-1
}
    8000530e:	70a2                	ld	ra,40(sp)
    80005310:	7402                	ld	s0,32(sp)
    80005312:	64e2                	ld	s1,24(sp)
    80005314:	6a02                	ld	s4,0(sp)
    80005316:	6145                	addi	sp,sp,48
    80005318:	8082                	ret
  return -1;
    8000531a:	557d                	li	a0,-1
    8000531c:	bfcd                	j	8000530e <pipealloc+0xd0>

000000008000531e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000531e:	1101                	addi	sp,sp,-32
    80005320:	ec06                	sd	ra,24(sp)
    80005322:	e822                	sd	s0,16(sp)
    80005324:	e426                	sd	s1,8(sp)
    80005326:	e04a                	sd	s2,0(sp)
    80005328:	1000                	addi	s0,sp,32
    8000532a:	84aa                	mv	s1,a0
    8000532c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000532e:	ffffc097          	auipc	ra,0xffffc
    80005332:	90a080e7          	jalr	-1782(ra) # 80000c38 <acquire>
  if(writable){
    80005336:	02090d63          	beqz	s2,80005370 <pipeclose+0x52>
    pi->writeopen = 0;
    8000533a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000533e:	21848513          	addi	a0,s1,536
    80005342:	ffffd097          	auipc	ra,0xffffd
    80005346:	2f6080e7          	jalr	758(ra) # 80002638 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000534a:	2204b783          	ld	a5,544(s1)
    8000534e:	eb95                	bnez	a5,80005382 <pipeclose+0x64>
    release(&pi->lock);
    80005350:	8526                	mv	a0,s1
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	99a080e7          	jalr	-1638(ra) # 80000cec <release>
    kfree((char*)pi);
    8000535a:	8526                	mv	a0,s1
    8000535c:	ffffb097          	auipc	ra,0xffffb
    80005360:	6ee080e7          	jalr	1774(ra) # 80000a4a <kfree>
  } else
    release(&pi->lock);
}
    80005364:	60e2                	ld	ra,24(sp)
    80005366:	6442                	ld	s0,16(sp)
    80005368:	64a2                	ld	s1,8(sp)
    8000536a:	6902                	ld	s2,0(sp)
    8000536c:	6105                	addi	sp,sp,32
    8000536e:	8082                	ret
    pi->readopen = 0;
    80005370:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005374:	21c48513          	addi	a0,s1,540
    80005378:	ffffd097          	auipc	ra,0xffffd
    8000537c:	2c0080e7          	jalr	704(ra) # 80002638 <wakeup>
    80005380:	b7e9                	j	8000534a <pipeclose+0x2c>
    release(&pi->lock);
    80005382:	8526                	mv	a0,s1
    80005384:	ffffc097          	auipc	ra,0xffffc
    80005388:	968080e7          	jalr	-1688(ra) # 80000cec <release>
}
    8000538c:	bfe1                	j	80005364 <pipeclose+0x46>

000000008000538e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000538e:	711d                	addi	sp,sp,-96
    80005390:	ec86                	sd	ra,88(sp)
    80005392:	e8a2                	sd	s0,80(sp)
    80005394:	e4a6                	sd	s1,72(sp)
    80005396:	e0ca                	sd	s2,64(sp)
    80005398:	fc4e                	sd	s3,56(sp)
    8000539a:	f852                	sd	s4,48(sp)
    8000539c:	f456                	sd	s5,40(sp)
    8000539e:	1080                	addi	s0,sp,96
    800053a0:	84aa                	mv	s1,a0
    800053a2:	8aae                	mv	s5,a1
    800053a4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800053a6:	ffffd097          	auipc	ra,0xffffd
    800053aa:	844080e7          	jalr	-1980(ra) # 80001bea <myproc>
    800053ae:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800053b0:	8526                	mv	a0,s1
    800053b2:	ffffc097          	auipc	ra,0xffffc
    800053b6:	886080e7          	jalr	-1914(ra) # 80000c38 <acquire>
  while(i < n){
    800053ba:	0d405863          	blez	s4,8000548a <pipewrite+0xfc>
    800053be:	f05a                	sd	s6,32(sp)
    800053c0:	ec5e                	sd	s7,24(sp)
    800053c2:	e862                	sd	s8,16(sp)
  int i = 0;
    800053c4:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800053c6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800053c8:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800053cc:	21c48b93          	addi	s7,s1,540
    800053d0:	a089                	j	80005412 <pipewrite+0x84>
      release(&pi->lock);
    800053d2:	8526                	mv	a0,s1
    800053d4:	ffffc097          	auipc	ra,0xffffc
    800053d8:	918080e7          	jalr	-1768(ra) # 80000cec <release>
      return -1;
    800053dc:	597d                	li	s2,-1
    800053de:	7b02                	ld	s6,32(sp)
    800053e0:	6be2                	ld	s7,24(sp)
    800053e2:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800053e4:	854a                	mv	a0,s2
    800053e6:	60e6                	ld	ra,88(sp)
    800053e8:	6446                	ld	s0,80(sp)
    800053ea:	64a6                	ld	s1,72(sp)
    800053ec:	6906                	ld	s2,64(sp)
    800053ee:	79e2                	ld	s3,56(sp)
    800053f0:	7a42                	ld	s4,48(sp)
    800053f2:	7aa2                	ld	s5,40(sp)
    800053f4:	6125                	addi	sp,sp,96
    800053f6:	8082                	ret
      wakeup(&pi->nread);
    800053f8:	8562                	mv	a0,s8
    800053fa:	ffffd097          	auipc	ra,0xffffd
    800053fe:	23e080e7          	jalr	574(ra) # 80002638 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005402:	85a6                	mv	a1,s1
    80005404:	855e                	mv	a0,s7
    80005406:	ffffd097          	auipc	ra,0xffffd
    8000540a:	1ce080e7          	jalr	462(ra) # 800025d4 <sleep>
  while(i < n){
    8000540e:	05495f63          	bge	s2,s4,8000546c <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    80005412:	2204a783          	lw	a5,544(s1)
    80005416:	dfd5                	beqz	a5,800053d2 <pipewrite+0x44>
    80005418:	854e                	mv	a0,s3
    8000541a:	ffffd097          	auipc	ra,0xffffd
    8000541e:	46e080e7          	jalr	1134(ra) # 80002888 <killed>
    80005422:	f945                	bnez	a0,800053d2 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005424:	2184a783          	lw	a5,536(s1)
    80005428:	21c4a703          	lw	a4,540(s1)
    8000542c:	2007879b          	addiw	a5,a5,512
    80005430:	fcf704e3          	beq	a4,a5,800053f8 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005434:	4685                	li	a3,1
    80005436:	01590633          	add	a2,s2,s5
    8000543a:	faf40593          	addi	a1,s0,-81
    8000543e:	2289b503          	ld	a0,552(s3)
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	32c080e7          	jalr	812(ra) # 8000176e <copyin>
    8000544a:	05650263          	beq	a0,s6,8000548e <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000544e:	21c4a783          	lw	a5,540(s1)
    80005452:	0017871b          	addiw	a4,a5,1
    80005456:	20e4ae23          	sw	a4,540(s1)
    8000545a:	1ff7f793          	andi	a5,a5,511
    8000545e:	97a6                	add	a5,a5,s1
    80005460:	faf44703          	lbu	a4,-81(s0)
    80005464:	00e78c23          	sb	a4,24(a5)
      i++;
    80005468:	2905                	addiw	s2,s2,1
    8000546a:	b755                	j	8000540e <pipewrite+0x80>
    8000546c:	7b02                	ld	s6,32(sp)
    8000546e:	6be2                	ld	s7,24(sp)
    80005470:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005472:	21848513          	addi	a0,s1,536
    80005476:	ffffd097          	auipc	ra,0xffffd
    8000547a:	1c2080e7          	jalr	450(ra) # 80002638 <wakeup>
  release(&pi->lock);
    8000547e:	8526                	mv	a0,s1
    80005480:	ffffc097          	auipc	ra,0xffffc
    80005484:	86c080e7          	jalr	-1940(ra) # 80000cec <release>
  return i;
    80005488:	bfb1                	j	800053e4 <pipewrite+0x56>
  int i = 0;
    8000548a:	4901                	li	s2,0
    8000548c:	b7dd                	j	80005472 <pipewrite+0xe4>
    8000548e:	7b02                	ld	s6,32(sp)
    80005490:	6be2                	ld	s7,24(sp)
    80005492:	6c42                	ld	s8,16(sp)
    80005494:	bff9                	j	80005472 <pipewrite+0xe4>

0000000080005496 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005496:	715d                	addi	sp,sp,-80
    80005498:	e486                	sd	ra,72(sp)
    8000549a:	e0a2                	sd	s0,64(sp)
    8000549c:	fc26                	sd	s1,56(sp)
    8000549e:	f84a                	sd	s2,48(sp)
    800054a0:	f44e                	sd	s3,40(sp)
    800054a2:	f052                	sd	s4,32(sp)
    800054a4:	ec56                	sd	s5,24(sp)
    800054a6:	0880                	addi	s0,sp,80
    800054a8:	84aa                	mv	s1,a0
    800054aa:	892e                	mv	s2,a1
    800054ac:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800054ae:	ffffc097          	auipc	ra,0xffffc
    800054b2:	73c080e7          	jalr	1852(ra) # 80001bea <myproc>
    800054b6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800054b8:	8526                	mv	a0,s1
    800054ba:	ffffb097          	auipc	ra,0xffffb
    800054be:	77e080e7          	jalr	1918(ra) # 80000c38 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054c2:	2184a703          	lw	a4,536(s1)
    800054c6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800054ca:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054ce:	02f71963          	bne	a4,a5,80005500 <piperead+0x6a>
    800054d2:	2244a783          	lw	a5,548(s1)
    800054d6:	cf95                	beqz	a5,80005512 <piperead+0x7c>
    if(killed(pr)){
    800054d8:	8552                	mv	a0,s4
    800054da:	ffffd097          	auipc	ra,0xffffd
    800054de:	3ae080e7          	jalr	942(ra) # 80002888 <killed>
    800054e2:	e10d                	bnez	a0,80005504 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800054e4:	85a6                	mv	a1,s1
    800054e6:	854e                	mv	a0,s3
    800054e8:	ffffd097          	auipc	ra,0xffffd
    800054ec:	0ec080e7          	jalr	236(ra) # 800025d4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800054f0:	2184a703          	lw	a4,536(s1)
    800054f4:	21c4a783          	lw	a5,540(s1)
    800054f8:	fcf70de3          	beq	a4,a5,800054d2 <piperead+0x3c>
    800054fc:	e85a                	sd	s6,16(sp)
    800054fe:	a819                	j	80005514 <piperead+0x7e>
    80005500:	e85a                	sd	s6,16(sp)
    80005502:	a809                	j	80005514 <piperead+0x7e>
      release(&pi->lock);
    80005504:	8526                	mv	a0,s1
    80005506:	ffffb097          	auipc	ra,0xffffb
    8000550a:	7e6080e7          	jalr	2022(ra) # 80000cec <release>
      return -1;
    8000550e:	59fd                	li	s3,-1
    80005510:	a0a5                	j	80005578 <piperead+0xe2>
    80005512:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005514:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005516:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005518:	05505463          	blez	s5,80005560 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    8000551c:	2184a783          	lw	a5,536(s1)
    80005520:	21c4a703          	lw	a4,540(s1)
    80005524:	02f70e63          	beq	a4,a5,80005560 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005528:	0017871b          	addiw	a4,a5,1
    8000552c:	20e4ac23          	sw	a4,536(s1)
    80005530:	1ff7f793          	andi	a5,a5,511
    80005534:	97a6                	add	a5,a5,s1
    80005536:	0187c783          	lbu	a5,24(a5)
    8000553a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000553e:	4685                	li	a3,1
    80005540:	fbf40613          	addi	a2,s0,-65
    80005544:	85ca                	mv	a1,s2
    80005546:	228a3503          	ld	a0,552(s4)
    8000554a:	ffffc097          	auipc	ra,0xffffc
    8000554e:	198080e7          	jalr	408(ra) # 800016e2 <copyout>
    80005552:	01650763          	beq	a0,s6,80005560 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005556:	2985                	addiw	s3,s3,1
    80005558:	0905                	addi	s2,s2,1
    8000555a:	fd3a91e3          	bne	s5,s3,8000551c <piperead+0x86>
    8000555e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005560:	21c48513          	addi	a0,s1,540
    80005564:	ffffd097          	auipc	ra,0xffffd
    80005568:	0d4080e7          	jalr	212(ra) # 80002638 <wakeup>
  release(&pi->lock);
    8000556c:	8526                	mv	a0,s1
    8000556e:	ffffb097          	auipc	ra,0xffffb
    80005572:	77e080e7          	jalr	1918(ra) # 80000cec <release>
    80005576:	6b42                	ld	s6,16(sp)
  return i;
}
    80005578:	854e                	mv	a0,s3
    8000557a:	60a6                	ld	ra,72(sp)
    8000557c:	6406                	ld	s0,64(sp)
    8000557e:	74e2                	ld	s1,56(sp)
    80005580:	7942                	ld	s2,48(sp)
    80005582:	79a2                	ld	s3,40(sp)
    80005584:	7a02                	ld	s4,32(sp)
    80005586:	6ae2                	ld	s5,24(sp)
    80005588:	6161                	addi	sp,sp,80
    8000558a:	8082                	ret

000000008000558c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000558c:	1141                	addi	sp,sp,-16
    8000558e:	e422                	sd	s0,8(sp)
    80005590:	0800                	addi	s0,sp,16
    80005592:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005594:	8905                	andi	a0,a0,1
    80005596:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005598:	8b89                	andi	a5,a5,2
    8000559a:	c399                	beqz	a5,800055a0 <flags2perm+0x14>
      perm |= PTE_W;
    8000559c:	00456513          	ori	a0,a0,4
    return perm;
}
    800055a0:	6422                	ld	s0,8(sp)
    800055a2:	0141                	addi	sp,sp,16
    800055a4:	8082                	ret

00000000800055a6 <exec>:

int
exec(char *path, char **argv)
{
    800055a6:	df010113          	addi	sp,sp,-528
    800055aa:	20113423          	sd	ra,520(sp)
    800055ae:	20813023          	sd	s0,512(sp)
    800055b2:	ffa6                	sd	s1,504(sp)
    800055b4:	fbca                	sd	s2,496(sp)
    800055b6:	0c00                	addi	s0,sp,528
    800055b8:	892a                	mv	s2,a0
    800055ba:	dea43c23          	sd	a0,-520(s0)
    800055be:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800055c2:	ffffc097          	auipc	ra,0xffffc
    800055c6:	628080e7          	jalr	1576(ra) # 80001bea <myproc>
    800055ca:	84aa                	mv	s1,a0

  begin_op();
    800055cc:	fffff097          	auipc	ra,0xfffff
    800055d0:	43a080e7          	jalr	1082(ra) # 80004a06 <begin_op>

  if((ip = namei(path)) == 0){
    800055d4:	854a                	mv	a0,s2
    800055d6:	fffff097          	auipc	ra,0xfffff
    800055da:	230080e7          	jalr	560(ra) # 80004806 <namei>
    800055de:	c135                	beqz	a0,80005642 <exec+0x9c>
    800055e0:	f3d2                	sd	s4,480(sp)
    800055e2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800055e4:	fffff097          	auipc	ra,0xfffff
    800055e8:	a54080e7          	jalr	-1452(ra) # 80004038 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800055ec:	04000713          	li	a4,64
    800055f0:	4681                	li	a3,0
    800055f2:	e5040613          	addi	a2,s0,-432
    800055f6:	4581                	li	a1,0
    800055f8:	8552                	mv	a0,s4
    800055fa:	fffff097          	auipc	ra,0xfffff
    800055fe:	cf6080e7          	jalr	-778(ra) # 800042f0 <readi>
    80005602:	04000793          	li	a5,64
    80005606:	00f51a63          	bne	a0,a5,8000561a <exec+0x74>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000560a:	e5042703          	lw	a4,-432(s0)
    8000560e:	464c47b7          	lui	a5,0x464c4
    80005612:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005616:	02f70c63          	beq	a4,a5,8000564e <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000561a:	8552                	mv	a0,s4
    8000561c:	fffff097          	auipc	ra,0xfffff
    80005620:	c82080e7          	jalr	-894(ra) # 8000429e <iunlockput>
    end_op();
    80005624:	fffff097          	auipc	ra,0xfffff
    80005628:	45c080e7          	jalr	1116(ra) # 80004a80 <end_op>
  }
  return -1;
    8000562c:	557d                	li	a0,-1
    8000562e:	7a1e                	ld	s4,480(sp)
}
    80005630:	20813083          	ld	ra,520(sp)
    80005634:	20013403          	ld	s0,512(sp)
    80005638:	74fe                	ld	s1,504(sp)
    8000563a:	795e                	ld	s2,496(sp)
    8000563c:	21010113          	addi	sp,sp,528
    80005640:	8082                	ret
    end_op();
    80005642:	fffff097          	auipc	ra,0xfffff
    80005646:	43e080e7          	jalr	1086(ra) # 80004a80 <end_op>
    return -1;
    8000564a:	557d                	li	a0,-1
    8000564c:	b7d5                	j	80005630 <exec+0x8a>
    8000564e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005650:	8526                	mv	a0,s1
    80005652:	ffffc097          	auipc	ra,0xffffc
    80005656:	65c080e7          	jalr	1628(ra) # 80001cae <proc_pagetable>
    8000565a:	8b2a                	mv	s6,a0
    8000565c:	30050f63          	beqz	a0,8000597a <exec+0x3d4>
    80005660:	f7ce                	sd	s3,488(sp)
    80005662:	efd6                	sd	s5,472(sp)
    80005664:	e7de                	sd	s7,456(sp)
    80005666:	e3e2                	sd	s8,448(sp)
    80005668:	ff66                	sd	s9,440(sp)
    8000566a:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000566c:	e7042d03          	lw	s10,-400(s0)
    80005670:	e8845783          	lhu	a5,-376(s0)
    80005674:	14078d63          	beqz	a5,800057ce <exec+0x228>
    80005678:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000567a:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000567c:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    8000567e:	6c85                	lui	s9,0x1
    80005680:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005684:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005688:	6a85                	lui	s5,0x1
    8000568a:	a0b5                	j	800056f6 <exec+0x150>
      panic("loadseg: address should exist");
    8000568c:	00003517          	auipc	a0,0x3
    80005690:	f5450513          	addi	a0,a0,-172 # 800085e0 <etext+0x5e0>
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	ecc080e7          	jalr	-308(ra) # 80000560 <panic>
    if(sz - i < PGSIZE)
    8000569c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000569e:	8726                	mv	a4,s1
    800056a0:	012c06bb          	addw	a3,s8,s2
    800056a4:	4581                	li	a1,0
    800056a6:	8552                	mv	a0,s4
    800056a8:	fffff097          	auipc	ra,0xfffff
    800056ac:	c48080e7          	jalr	-952(ra) # 800042f0 <readi>
    800056b0:	2501                	sext.w	a0,a0
    800056b2:	28a49863          	bne	s1,a0,80005942 <exec+0x39c>
  for(i = 0; i < sz; i += PGSIZE){
    800056b6:	012a893b          	addw	s2,s5,s2
    800056ba:	03397563          	bgeu	s2,s3,800056e4 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800056be:	02091593          	slli	a1,s2,0x20
    800056c2:	9181                	srli	a1,a1,0x20
    800056c4:	95de                	add	a1,a1,s7
    800056c6:	855a                	mv	a0,s6
    800056c8:	ffffc097          	auipc	ra,0xffffc
    800056cc:	9ee080e7          	jalr	-1554(ra) # 800010b6 <walkaddr>
    800056d0:	862a                	mv	a2,a0
    if(pa == 0)
    800056d2:	dd4d                	beqz	a0,8000568c <exec+0xe6>
    if(sz - i < PGSIZE)
    800056d4:	412984bb          	subw	s1,s3,s2
    800056d8:	0004879b          	sext.w	a5,s1
    800056dc:	fcfcf0e3          	bgeu	s9,a5,8000569c <exec+0xf6>
    800056e0:	84d6                	mv	s1,s5
    800056e2:	bf6d                	j	8000569c <exec+0xf6>
    sz = sz1;
    800056e4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800056e8:	2d85                	addiw	s11,s11,1
    800056ea:	038d0d1b          	addiw	s10,s10,56
    800056ee:	e8845783          	lhu	a5,-376(s0)
    800056f2:	08fdd663          	bge	s11,a5,8000577e <exec+0x1d8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800056f6:	2d01                	sext.w	s10,s10
    800056f8:	03800713          	li	a4,56
    800056fc:	86ea                	mv	a3,s10
    800056fe:	e1840613          	addi	a2,s0,-488
    80005702:	4581                	li	a1,0
    80005704:	8552                	mv	a0,s4
    80005706:	fffff097          	auipc	ra,0xfffff
    8000570a:	bea080e7          	jalr	-1046(ra) # 800042f0 <readi>
    8000570e:	03800793          	li	a5,56
    80005712:	20f51063          	bne	a0,a5,80005912 <exec+0x36c>
    if(ph.type != ELF_PROG_LOAD)
    80005716:	e1842783          	lw	a5,-488(s0)
    8000571a:	4705                	li	a4,1
    8000571c:	fce796e3          	bne	a5,a4,800056e8 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80005720:	e4043483          	ld	s1,-448(s0)
    80005724:	e3843783          	ld	a5,-456(s0)
    80005728:	1ef4e963          	bltu	s1,a5,8000591a <exec+0x374>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000572c:	e2843783          	ld	a5,-472(s0)
    80005730:	94be                	add	s1,s1,a5
    80005732:	1ef4e863          	bltu	s1,a5,80005922 <exec+0x37c>
    if(ph.vaddr % PGSIZE != 0)
    80005736:	df043703          	ld	a4,-528(s0)
    8000573a:	8ff9                	and	a5,a5,a4
    8000573c:	1e079763          	bnez	a5,8000592a <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005740:	e1c42503          	lw	a0,-484(s0)
    80005744:	00000097          	auipc	ra,0x0
    80005748:	e48080e7          	jalr	-440(ra) # 8000558c <flags2perm>
    8000574c:	86aa                	mv	a3,a0
    8000574e:	8626                	mv	a2,s1
    80005750:	85ca                	mv	a1,s2
    80005752:	855a                	mv	a0,s6
    80005754:	ffffc097          	auipc	ra,0xffffc
    80005758:	d26080e7          	jalr	-730(ra) # 8000147a <uvmalloc>
    8000575c:	e0a43423          	sd	a0,-504(s0)
    80005760:	1c050963          	beqz	a0,80005932 <exec+0x38c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005764:	e2843b83          	ld	s7,-472(s0)
    80005768:	e2042c03          	lw	s8,-480(s0)
    8000576c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005770:	00098463          	beqz	s3,80005778 <exec+0x1d2>
    80005774:	4901                	li	s2,0
    80005776:	b7a1                	j	800056be <exec+0x118>
    sz = sz1;
    80005778:	e0843903          	ld	s2,-504(s0)
    8000577c:	b7b5                	j	800056e8 <exec+0x142>
    8000577e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005780:	8552                	mv	a0,s4
    80005782:	fffff097          	auipc	ra,0xfffff
    80005786:	b1c080e7          	jalr	-1252(ra) # 8000429e <iunlockput>
  end_op();
    8000578a:	fffff097          	auipc	ra,0xfffff
    8000578e:	2f6080e7          	jalr	758(ra) # 80004a80 <end_op>
  p = myproc();
    80005792:	ffffc097          	auipc	ra,0xffffc
    80005796:	458080e7          	jalr	1112(ra) # 80001bea <myproc>
    8000579a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000579c:	22053c83          	ld	s9,544(a0)
  sz = PGROUNDUP(sz);
    800057a0:	6985                	lui	s3,0x1
    800057a2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800057a4:	99ca                	add	s3,s3,s2
    800057a6:	77fd                	lui	a5,0xfffff
    800057a8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800057ac:	4691                	li	a3,4
    800057ae:	6609                	lui	a2,0x2
    800057b0:	964e                	add	a2,a2,s3
    800057b2:	85ce                	mv	a1,s3
    800057b4:	855a                	mv	a0,s6
    800057b6:	ffffc097          	auipc	ra,0xffffc
    800057ba:	cc4080e7          	jalr	-828(ra) # 8000147a <uvmalloc>
    800057be:	892a                	mv	s2,a0
    800057c0:	e0a43423          	sd	a0,-504(s0)
    800057c4:	e519                	bnez	a0,800057d2 <exec+0x22c>
  if(pagetable)
    800057c6:	e1343423          	sd	s3,-504(s0)
    800057ca:	4a01                	li	s4,0
    800057cc:	aaa5                	j	80005944 <exec+0x39e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800057ce:	4901                	li	s2,0
    800057d0:	bf45                	j	80005780 <exec+0x1da>
  uvmclear(pagetable, sz-2*PGSIZE);
    800057d2:	75f9                	lui	a1,0xffffe
    800057d4:	95aa                	add	a1,a1,a0
    800057d6:	855a                	mv	a0,s6
    800057d8:	ffffc097          	auipc	ra,0xffffc
    800057dc:	ed8080e7          	jalr	-296(ra) # 800016b0 <uvmclear>
  stackbase = sp - PGSIZE;
    800057e0:	7bfd                	lui	s7,0xfffff
    800057e2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800057e4:	e0043783          	ld	a5,-512(s0)
    800057e8:	6388                	ld	a0,0(a5)
    800057ea:	c52d                	beqz	a0,80005854 <exec+0x2ae>
    800057ec:	e9040993          	addi	s3,s0,-368
    800057f0:	f9040c13          	addi	s8,s0,-112
    800057f4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800057f6:	ffffb097          	auipc	ra,0xffffb
    800057fa:	6b2080e7          	jalr	1714(ra) # 80000ea8 <strlen>
    800057fe:	0015079b          	addiw	a5,a0,1
    80005802:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005806:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000580a:	13796863          	bltu	s2,s7,8000593a <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000580e:	e0043d03          	ld	s10,-512(s0)
    80005812:	000d3a03          	ld	s4,0(s10)
    80005816:	8552                	mv	a0,s4
    80005818:	ffffb097          	auipc	ra,0xffffb
    8000581c:	690080e7          	jalr	1680(ra) # 80000ea8 <strlen>
    80005820:	0015069b          	addiw	a3,a0,1
    80005824:	8652                	mv	a2,s4
    80005826:	85ca                	mv	a1,s2
    80005828:	855a                	mv	a0,s6
    8000582a:	ffffc097          	auipc	ra,0xffffc
    8000582e:	eb8080e7          	jalr	-328(ra) # 800016e2 <copyout>
    80005832:	10054663          	bltz	a0,8000593e <exec+0x398>
    ustack[argc] = sp;
    80005836:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000583a:	0485                	addi	s1,s1,1
    8000583c:	008d0793          	addi	a5,s10,8
    80005840:	e0f43023          	sd	a5,-512(s0)
    80005844:	008d3503          	ld	a0,8(s10)
    80005848:	c909                	beqz	a0,8000585a <exec+0x2b4>
    if(argc >= MAXARG)
    8000584a:	09a1                	addi	s3,s3,8
    8000584c:	fb8995e3          	bne	s3,s8,800057f6 <exec+0x250>
  ip = 0;
    80005850:	4a01                	li	s4,0
    80005852:	a8cd                	j	80005944 <exec+0x39e>
  sp = sz;
    80005854:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005858:	4481                	li	s1,0
  ustack[argc] = 0;
    8000585a:	00349793          	slli	a5,s1,0x3
    8000585e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd2370>
    80005862:	97a2                	add	a5,a5,s0
    80005864:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005868:	00148693          	addi	a3,s1,1
    8000586c:	068e                	slli	a3,a3,0x3
    8000586e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005872:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005876:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000587a:	f57966e3          	bltu	s2,s7,800057c6 <exec+0x220>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000587e:	e9040613          	addi	a2,s0,-368
    80005882:	85ca                	mv	a1,s2
    80005884:	855a                	mv	a0,s6
    80005886:	ffffc097          	auipc	ra,0xffffc
    8000588a:	e5c080e7          	jalr	-420(ra) # 800016e2 <copyout>
    8000588e:	0e054863          	bltz	a0,8000597e <exec+0x3d8>
  p->trapframe->a1 = sp;
    80005892:	230ab783          	ld	a5,560(s5) # 1230 <_entry-0x7fffedd0>
    80005896:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000589a:	df843783          	ld	a5,-520(s0)
    8000589e:	0007c703          	lbu	a4,0(a5)
    800058a2:	cf11                	beqz	a4,800058be <exec+0x318>
    800058a4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800058a6:	02f00693          	li	a3,47
    800058aa:	a039                	j	800058b8 <exec+0x312>
      last = s+1;
    800058ac:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800058b0:	0785                	addi	a5,a5,1
    800058b2:	fff7c703          	lbu	a4,-1(a5)
    800058b6:	c701                	beqz	a4,800058be <exec+0x318>
    if(*s == '/')
    800058b8:	fed71ce3          	bne	a4,a3,800058b0 <exec+0x30a>
    800058bc:	bfc5                	j	800058ac <exec+0x306>
  safestrcpy(p->name, last, sizeof(p->name));
    800058be:	4641                	li	a2,16
    800058c0:	df843583          	ld	a1,-520(s0)
    800058c4:	330a8513          	addi	a0,s5,816
    800058c8:	ffffb097          	auipc	ra,0xffffb
    800058cc:	5ae080e7          	jalr	1454(ra) # 80000e76 <safestrcpy>
  oldpagetable = p->pagetable;
    800058d0:	228ab503          	ld	a0,552(s5)
  p->pagetable = pagetable;
    800058d4:	236ab423          	sd	s6,552(s5)
  p->sz = sz;
    800058d8:	e0843783          	ld	a5,-504(s0)
    800058dc:	22fab023          	sd	a5,544(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800058e0:	230ab783          	ld	a5,560(s5)
    800058e4:	e6843703          	ld	a4,-408(s0)
    800058e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800058ea:	230ab783          	ld	a5,560(s5)
    800058ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800058f2:	85e6                	mv	a1,s9
    800058f4:	ffffc097          	auipc	ra,0xffffc
    800058f8:	456080e7          	jalr	1110(ra) # 80001d4a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800058fc:	0004851b          	sext.w	a0,s1
    80005900:	79be                	ld	s3,488(sp)
    80005902:	7a1e                	ld	s4,480(sp)
    80005904:	6afe                	ld	s5,472(sp)
    80005906:	6b5e                	ld	s6,464(sp)
    80005908:	6bbe                	ld	s7,456(sp)
    8000590a:	6c1e                	ld	s8,448(sp)
    8000590c:	7cfa                	ld	s9,440(sp)
    8000590e:	7d5a                	ld	s10,432(sp)
    80005910:	b305                	j	80005630 <exec+0x8a>
    80005912:	e1243423          	sd	s2,-504(s0)
    80005916:	7dba                	ld	s11,424(sp)
    80005918:	a035                	j	80005944 <exec+0x39e>
    8000591a:	e1243423          	sd	s2,-504(s0)
    8000591e:	7dba                	ld	s11,424(sp)
    80005920:	a015                	j	80005944 <exec+0x39e>
    80005922:	e1243423          	sd	s2,-504(s0)
    80005926:	7dba                	ld	s11,424(sp)
    80005928:	a831                	j	80005944 <exec+0x39e>
    8000592a:	e1243423          	sd	s2,-504(s0)
    8000592e:	7dba                	ld	s11,424(sp)
    80005930:	a811                	j	80005944 <exec+0x39e>
    80005932:	e1243423          	sd	s2,-504(s0)
    80005936:	7dba                	ld	s11,424(sp)
    80005938:	a031                	j	80005944 <exec+0x39e>
  ip = 0;
    8000593a:	4a01                	li	s4,0
    8000593c:	a021                	j	80005944 <exec+0x39e>
    8000593e:	4a01                	li	s4,0
  if(pagetable)
    80005940:	a011                	j	80005944 <exec+0x39e>
    80005942:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005944:	e0843583          	ld	a1,-504(s0)
    80005948:	855a                	mv	a0,s6
    8000594a:	ffffc097          	auipc	ra,0xffffc
    8000594e:	400080e7          	jalr	1024(ra) # 80001d4a <proc_freepagetable>
  return -1;
    80005952:	557d                	li	a0,-1
  if(ip){
    80005954:	000a1b63          	bnez	s4,8000596a <exec+0x3c4>
    80005958:	79be                	ld	s3,488(sp)
    8000595a:	7a1e                	ld	s4,480(sp)
    8000595c:	6afe                	ld	s5,472(sp)
    8000595e:	6b5e                	ld	s6,464(sp)
    80005960:	6bbe                	ld	s7,456(sp)
    80005962:	6c1e                	ld	s8,448(sp)
    80005964:	7cfa                	ld	s9,440(sp)
    80005966:	7d5a                	ld	s10,432(sp)
    80005968:	b1e1                	j	80005630 <exec+0x8a>
    8000596a:	79be                	ld	s3,488(sp)
    8000596c:	6afe                	ld	s5,472(sp)
    8000596e:	6b5e                	ld	s6,464(sp)
    80005970:	6bbe                	ld	s7,456(sp)
    80005972:	6c1e                	ld	s8,448(sp)
    80005974:	7cfa                	ld	s9,440(sp)
    80005976:	7d5a                	ld	s10,432(sp)
    80005978:	b14d                	j	8000561a <exec+0x74>
    8000597a:	6b5e                	ld	s6,464(sp)
    8000597c:	b979                	j	8000561a <exec+0x74>
  sz = sz1;
    8000597e:	e0843983          	ld	s3,-504(s0)
    80005982:	b591                	j	800057c6 <exec+0x220>

0000000080005984 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005984:	7179                	addi	sp,sp,-48
    80005986:	f406                	sd	ra,40(sp)
    80005988:	f022                	sd	s0,32(sp)
    8000598a:	ec26                	sd	s1,24(sp)
    8000598c:	e84a                	sd	s2,16(sp)
    8000598e:	1800                	addi	s0,sp,48
    80005990:	892e                	mv	s2,a1
    80005992:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005994:	fdc40593          	addi	a1,s0,-36
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	99a080e7          	jalr	-1638(ra) # 80003332 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800059a0:	fdc42703          	lw	a4,-36(s0)
    800059a4:	47bd                	li	a5,15
    800059a6:	02e7eb63          	bltu	a5,a4,800059dc <argfd+0x58>
    800059aa:	ffffc097          	auipc	ra,0xffffc
    800059ae:	240080e7          	jalr	576(ra) # 80001bea <myproc>
    800059b2:	fdc42703          	lw	a4,-36(s0)
    800059b6:	05470793          	addi	a5,a4,84
    800059ba:	078e                	slli	a5,a5,0x3
    800059bc:	953e                	add	a0,a0,a5
    800059be:	651c                	ld	a5,8(a0)
    800059c0:	c385                	beqz	a5,800059e0 <argfd+0x5c>
    return -1;
  if(pfd)
    800059c2:	00090463          	beqz	s2,800059ca <argfd+0x46>
    *pfd = fd;
    800059c6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800059ca:	4501                	li	a0,0
  if(pf)
    800059cc:	c091                	beqz	s1,800059d0 <argfd+0x4c>
    *pf = f;
    800059ce:	e09c                	sd	a5,0(s1)
}
    800059d0:	70a2                	ld	ra,40(sp)
    800059d2:	7402                	ld	s0,32(sp)
    800059d4:	64e2                	ld	s1,24(sp)
    800059d6:	6942                	ld	s2,16(sp)
    800059d8:	6145                	addi	sp,sp,48
    800059da:	8082                	ret
    return -1;
    800059dc:	557d                	li	a0,-1
    800059de:	bfcd                	j	800059d0 <argfd+0x4c>
    800059e0:	557d                	li	a0,-1
    800059e2:	b7fd                	j	800059d0 <argfd+0x4c>

00000000800059e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800059e4:	1101                	addi	sp,sp,-32
    800059e6:	ec06                	sd	ra,24(sp)
    800059e8:	e822                	sd	s0,16(sp)
    800059ea:	e426                	sd	s1,8(sp)
    800059ec:	1000                	addi	s0,sp,32
    800059ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800059f0:	ffffc097          	auipc	ra,0xffffc
    800059f4:	1fa080e7          	jalr	506(ra) # 80001bea <myproc>
    800059f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800059fa:	2a850793          	addi	a5,a0,680
    800059fe:	4501                	li	a0,0
    80005a00:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005a02:	6398                	ld	a4,0(a5)
    80005a04:	cb19                	beqz	a4,80005a1a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005a06:	2505                	addiw	a0,a0,1
    80005a08:	07a1                	addi	a5,a5,8
    80005a0a:	fed51ce3          	bne	a0,a3,80005a02 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005a0e:	557d                	li	a0,-1
}
    80005a10:	60e2                	ld	ra,24(sp)
    80005a12:	6442                	ld	s0,16(sp)
    80005a14:	64a2                	ld	s1,8(sp)
    80005a16:	6105                	addi	sp,sp,32
    80005a18:	8082                	ret
      p->ofile[fd] = f;
    80005a1a:	05450793          	addi	a5,a0,84
    80005a1e:	078e                	slli	a5,a5,0x3
    80005a20:	963e                	add	a2,a2,a5
    80005a22:	e604                	sd	s1,8(a2)
      return fd;
    80005a24:	b7f5                	j	80005a10 <fdalloc+0x2c>

0000000080005a26 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005a26:	715d                	addi	sp,sp,-80
    80005a28:	e486                	sd	ra,72(sp)
    80005a2a:	e0a2                	sd	s0,64(sp)
    80005a2c:	fc26                	sd	s1,56(sp)
    80005a2e:	f84a                	sd	s2,48(sp)
    80005a30:	f44e                	sd	s3,40(sp)
    80005a32:	ec56                	sd	s5,24(sp)
    80005a34:	e85a                	sd	s6,16(sp)
    80005a36:	0880                	addi	s0,sp,80
    80005a38:	8b2e                	mv	s6,a1
    80005a3a:	89b2                	mv	s3,a2
    80005a3c:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005a3e:	fb040593          	addi	a1,s0,-80
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	de2080e7          	jalr	-542(ra) # 80004824 <nameiparent>
    80005a4a:	84aa                	mv	s1,a0
    80005a4c:	14050e63          	beqz	a0,80005ba8 <create+0x182>
    return 0;

  ilock(dp);
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	5e8080e7          	jalr	1512(ra) # 80004038 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005a58:	4601                	li	a2,0
    80005a5a:	fb040593          	addi	a1,s0,-80
    80005a5e:	8526                	mv	a0,s1
    80005a60:	fffff097          	auipc	ra,0xfffff
    80005a64:	ae4080e7          	jalr	-1308(ra) # 80004544 <dirlookup>
    80005a68:	8aaa                	mv	s5,a0
    80005a6a:	c539                	beqz	a0,80005ab8 <create+0x92>
    iunlockput(dp);
    80005a6c:	8526                	mv	a0,s1
    80005a6e:	fffff097          	auipc	ra,0xfffff
    80005a72:	830080e7          	jalr	-2000(ra) # 8000429e <iunlockput>
    ilock(ip);
    80005a76:	8556                	mv	a0,s5
    80005a78:	ffffe097          	auipc	ra,0xffffe
    80005a7c:	5c0080e7          	jalr	1472(ra) # 80004038 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005a80:	4789                	li	a5,2
    80005a82:	02fb1463          	bne	s6,a5,80005aaa <create+0x84>
    80005a86:	044ad783          	lhu	a5,68(s5)
    80005a8a:	37f9                	addiw	a5,a5,-2
    80005a8c:	17c2                	slli	a5,a5,0x30
    80005a8e:	93c1                	srli	a5,a5,0x30
    80005a90:	4705                	li	a4,1
    80005a92:	00f76c63          	bltu	a4,a5,80005aaa <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005a96:	8556                	mv	a0,s5
    80005a98:	60a6                	ld	ra,72(sp)
    80005a9a:	6406                	ld	s0,64(sp)
    80005a9c:	74e2                	ld	s1,56(sp)
    80005a9e:	7942                	ld	s2,48(sp)
    80005aa0:	79a2                	ld	s3,40(sp)
    80005aa2:	6ae2                	ld	s5,24(sp)
    80005aa4:	6b42                	ld	s6,16(sp)
    80005aa6:	6161                	addi	sp,sp,80
    80005aa8:	8082                	ret
    iunlockput(ip);
    80005aaa:	8556                	mv	a0,s5
    80005aac:	ffffe097          	auipc	ra,0xffffe
    80005ab0:	7f2080e7          	jalr	2034(ra) # 8000429e <iunlockput>
    return 0;
    80005ab4:	4a81                	li	s5,0
    80005ab6:	b7c5                	j	80005a96 <create+0x70>
    80005ab8:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80005aba:	85da                	mv	a1,s6
    80005abc:	4088                	lw	a0,0(s1)
    80005abe:	ffffe097          	auipc	ra,0xffffe
    80005ac2:	3d6080e7          	jalr	982(ra) # 80003e94 <ialloc>
    80005ac6:	8a2a                	mv	s4,a0
    80005ac8:	c531                	beqz	a0,80005b14 <create+0xee>
  ilock(ip);
    80005aca:	ffffe097          	auipc	ra,0xffffe
    80005ace:	56e080e7          	jalr	1390(ra) # 80004038 <ilock>
  ip->major = major;
    80005ad2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005ad6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005ada:	4905                	li	s2,1
    80005adc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80005ae0:	8552                	mv	a0,s4
    80005ae2:	ffffe097          	auipc	ra,0xffffe
    80005ae6:	48a080e7          	jalr	1162(ra) # 80003f6c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005aea:	032b0d63          	beq	s6,s2,80005b24 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005aee:	004a2603          	lw	a2,4(s4)
    80005af2:	fb040593          	addi	a1,s0,-80
    80005af6:	8526                	mv	a0,s1
    80005af8:	fffff097          	auipc	ra,0xfffff
    80005afc:	c5c080e7          	jalr	-932(ra) # 80004754 <dirlink>
    80005b00:	08054163          	bltz	a0,80005b82 <create+0x15c>
  iunlockput(dp);
    80005b04:	8526                	mv	a0,s1
    80005b06:	ffffe097          	auipc	ra,0xffffe
    80005b0a:	798080e7          	jalr	1944(ra) # 8000429e <iunlockput>
  return ip;
    80005b0e:	8ad2                	mv	s5,s4
    80005b10:	7a02                	ld	s4,32(sp)
    80005b12:	b751                	j	80005a96 <create+0x70>
    iunlockput(dp);
    80005b14:	8526                	mv	a0,s1
    80005b16:	ffffe097          	auipc	ra,0xffffe
    80005b1a:	788080e7          	jalr	1928(ra) # 8000429e <iunlockput>
    return 0;
    80005b1e:	8ad2                	mv	s5,s4
    80005b20:	7a02                	ld	s4,32(sp)
    80005b22:	bf95                	j	80005a96 <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005b24:	004a2603          	lw	a2,4(s4)
    80005b28:	00003597          	auipc	a1,0x3
    80005b2c:	ad858593          	addi	a1,a1,-1320 # 80008600 <etext+0x600>
    80005b30:	8552                	mv	a0,s4
    80005b32:	fffff097          	auipc	ra,0xfffff
    80005b36:	c22080e7          	jalr	-990(ra) # 80004754 <dirlink>
    80005b3a:	04054463          	bltz	a0,80005b82 <create+0x15c>
    80005b3e:	40d0                	lw	a2,4(s1)
    80005b40:	00003597          	auipc	a1,0x3
    80005b44:	ac858593          	addi	a1,a1,-1336 # 80008608 <etext+0x608>
    80005b48:	8552                	mv	a0,s4
    80005b4a:	fffff097          	auipc	ra,0xfffff
    80005b4e:	c0a080e7          	jalr	-1014(ra) # 80004754 <dirlink>
    80005b52:	02054863          	bltz	a0,80005b82 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005b56:	004a2603          	lw	a2,4(s4)
    80005b5a:	fb040593          	addi	a1,s0,-80
    80005b5e:	8526                	mv	a0,s1
    80005b60:	fffff097          	auipc	ra,0xfffff
    80005b64:	bf4080e7          	jalr	-1036(ra) # 80004754 <dirlink>
    80005b68:	00054d63          	bltz	a0,80005b82 <create+0x15c>
    dp->nlink++;  // for ".."
    80005b6c:	04a4d783          	lhu	a5,74(s1)
    80005b70:	2785                	addiw	a5,a5,1
    80005b72:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b76:	8526                	mv	a0,s1
    80005b78:	ffffe097          	auipc	ra,0xffffe
    80005b7c:	3f4080e7          	jalr	1012(ra) # 80003f6c <iupdate>
    80005b80:	b751                	j	80005b04 <create+0xde>
  ip->nlink = 0;
    80005b82:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005b86:	8552                	mv	a0,s4
    80005b88:	ffffe097          	auipc	ra,0xffffe
    80005b8c:	3e4080e7          	jalr	996(ra) # 80003f6c <iupdate>
  iunlockput(ip);
    80005b90:	8552                	mv	a0,s4
    80005b92:	ffffe097          	auipc	ra,0xffffe
    80005b96:	70c080e7          	jalr	1804(ra) # 8000429e <iunlockput>
  iunlockput(dp);
    80005b9a:	8526                	mv	a0,s1
    80005b9c:	ffffe097          	auipc	ra,0xffffe
    80005ba0:	702080e7          	jalr	1794(ra) # 8000429e <iunlockput>
  return 0;
    80005ba4:	7a02                	ld	s4,32(sp)
    80005ba6:	bdc5                	j	80005a96 <create+0x70>
    return 0;
    80005ba8:	8aaa                	mv	s5,a0
    80005baa:	b5f5                	j	80005a96 <create+0x70>

0000000080005bac <sys_dup>:
{
    80005bac:	7179                	addi	sp,sp,-48
    80005bae:	f406                	sd	ra,40(sp)
    80005bb0:	f022                	sd	s0,32(sp)
    80005bb2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005bb4:	fd840613          	addi	a2,s0,-40
    80005bb8:	4581                	li	a1,0
    80005bba:	4501                	li	a0,0
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	dc8080e7          	jalr	-568(ra) # 80005984 <argfd>
    return -1;
    80005bc4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005bc6:	02054763          	bltz	a0,80005bf4 <sys_dup+0x48>
    80005bca:	ec26                	sd	s1,24(sp)
    80005bcc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005bce:	fd843903          	ld	s2,-40(s0)
    80005bd2:	854a                	mv	a0,s2
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	e10080e7          	jalr	-496(ra) # 800059e4 <fdalloc>
    80005bdc:	84aa                	mv	s1,a0
    return -1;
    80005bde:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005be0:	00054f63          	bltz	a0,80005bfe <sys_dup+0x52>
  filedup(f);
    80005be4:	854a                	mv	a0,s2
    80005be6:	fffff097          	auipc	ra,0xfffff
    80005bea:	298080e7          	jalr	664(ra) # 80004e7e <filedup>
  return fd;
    80005bee:	87a6                	mv	a5,s1
    80005bf0:	64e2                	ld	s1,24(sp)
    80005bf2:	6942                	ld	s2,16(sp)
}
    80005bf4:	853e                	mv	a0,a5
    80005bf6:	70a2                	ld	ra,40(sp)
    80005bf8:	7402                	ld	s0,32(sp)
    80005bfa:	6145                	addi	sp,sp,48
    80005bfc:	8082                	ret
    80005bfe:	64e2                	ld	s1,24(sp)
    80005c00:	6942                	ld	s2,16(sp)
    80005c02:	bfcd                	j	80005bf4 <sys_dup+0x48>

0000000080005c04 <sys_read>:
{
    80005c04:	7179                	addi	sp,sp,-48
    80005c06:	f406                	sd	ra,40(sp)
    80005c08:	f022                	sd	s0,32(sp)
    80005c0a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c0c:	fd840593          	addi	a1,s0,-40
    80005c10:	4505                	li	a0,1
    80005c12:	ffffd097          	auipc	ra,0xffffd
    80005c16:	740080e7          	jalr	1856(ra) # 80003352 <argaddr>
  argint(2, &n);
    80005c1a:	fe440593          	addi	a1,s0,-28
    80005c1e:	4509                	li	a0,2
    80005c20:	ffffd097          	auipc	ra,0xffffd
    80005c24:	712080e7          	jalr	1810(ra) # 80003332 <argint>
  if(argfd(0, 0, &f) < 0)
    80005c28:	fe840613          	addi	a2,s0,-24
    80005c2c:	4581                	li	a1,0
    80005c2e:	4501                	li	a0,0
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	d54080e7          	jalr	-684(ra) # 80005984 <argfd>
    80005c38:	87aa                	mv	a5,a0
    return -1;
    80005c3a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c3c:	0007cc63          	bltz	a5,80005c54 <sys_read+0x50>
  return fileread(f, p, n);
    80005c40:	fe442603          	lw	a2,-28(s0)
    80005c44:	fd843583          	ld	a1,-40(s0)
    80005c48:	fe843503          	ld	a0,-24(s0)
    80005c4c:	fffff097          	auipc	ra,0xfffff
    80005c50:	3d8080e7          	jalr	984(ra) # 80005024 <fileread>
}
    80005c54:	70a2                	ld	ra,40(sp)
    80005c56:	7402                	ld	s0,32(sp)
    80005c58:	6145                	addi	sp,sp,48
    80005c5a:	8082                	ret

0000000080005c5c <sys_write>:
{
    80005c5c:	7179                	addi	sp,sp,-48
    80005c5e:	f406                	sd	ra,40(sp)
    80005c60:	f022                	sd	s0,32(sp)
    80005c62:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c64:	fd840593          	addi	a1,s0,-40
    80005c68:	4505                	li	a0,1
    80005c6a:	ffffd097          	auipc	ra,0xffffd
    80005c6e:	6e8080e7          	jalr	1768(ra) # 80003352 <argaddr>
  argint(2, &n);
    80005c72:	fe440593          	addi	a1,s0,-28
    80005c76:	4509                	li	a0,2
    80005c78:	ffffd097          	auipc	ra,0xffffd
    80005c7c:	6ba080e7          	jalr	1722(ra) # 80003332 <argint>
  if(argfd(0, 0, &f) < 0)
    80005c80:	fe840613          	addi	a2,s0,-24
    80005c84:	4581                	li	a1,0
    80005c86:	4501                	li	a0,0
    80005c88:	00000097          	auipc	ra,0x0
    80005c8c:	cfc080e7          	jalr	-772(ra) # 80005984 <argfd>
    80005c90:	87aa                	mv	a5,a0
    return -1;
    80005c92:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c94:	0007cc63          	bltz	a5,80005cac <sys_write+0x50>
  return filewrite(f, p, n);
    80005c98:	fe442603          	lw	a2,-28(s0)
    80005c9c:	fd843583          	ld	a1,-40(s0)
    80005ca0:	fe843503          	ld	a0,-24(s0)
    80005ca4:	fffff097          	auipc	ra,0xfffff
    80005ca8:	452080e7          	jalr	1106(ra) # 800050f6 <filewrite>
}
    80005cac:	70a2                	ld	ra,40(sp)
    80005cae:	7402                	ld	s0,32(sp)
    80005cb0:	6145                	addi	sp,sp,48
    80005cb2:	8082                	ret

0000000080005cb4 <sys_close>:
{
    80005cb4:	1101                	addi	sp,sp,-32
    80005cb6:	ec06                	sd	ra,24(sp)
    80005cb8:	e822                	sd	s0,16(sp)
    80005cba:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005cbc:	fe040613          	addi	a2,s0,-32
    80005cc0:	fec40593          	addi	a1,s0,-20
    80005cc4:	4501                	li	a0,0
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	cbe080e7          	jalr	-834(ra) # 80005984 <argfd>
    return -1;
    80005cce:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005cd0:	02054563          	bltz	a0,80005cfa <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005cd4:	ffffc097          	auipc	ra,0xffffc
    80005cd8:	f16080e7          	jalr	-234(ra) # 80001bea <myproc>
    80005cdc:	fec42783          	lw	a5,-20(s0)
    80005ce0:	05478793          	addi	a5,a5,84
    80005ce4:	078e                	slli	a5,a5,0x3
    80005ce6:	953e                	add	a0,a0,a5
    80005ce8:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005cec:	fe043503          	ld	a0,-32(s0)
    80005cf0:	fffff097          	auipc	ra,0xfffff
    80005cf4:	1e0080e7          	jalr	480(ra) # 80004ed0 <fileclose>
  return 0;
    80005cf8:	4781                	li	a5,0
}
    80005cfa:	853e                	mv	a0,a5
    80005cfc:	60e2                	ld	ra,24(sp)
    80005cfe:	6442                	ld	s0,16(sp)
    80005d00:	6105                	addi	sp,sp,32
    80005d02:	8082                	ret

0000000080005d04 <sys_fstat>:
{
    80005d04:	1101                	addi	sp,sp,-32
    80005d06:	ec06                	sd	ra,24(sp)
    80005d08:	e822                	sd	s0,16(sp)
    80005d0a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005d0c:	fe040593          	addi	a1,s0,-32
    80005d10:	4505                	li	a0,1
    80005d12:	ffffd097          	auipc	ra,0xffffd
    80005d16:	640080e7          	jalr	1600(ra) # 80003352 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005d1a:	fe840613          	addi	a2,s0,-24
    80005d1e:	4581                	li	a1,0
    80005d20:	4501                	li	a0,0
    80005d22:	00000097          	auipc	ra,0x0
    80005d26:	c62080e7          	jalr	-926(ra) # 80005984 <argfd>
    80005d2a:	87aa                	mv	a5,a0
    return -1;
    80005d2c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005d2e:	0007ca63          	bltz	a5,80005d42 <sys_fstat+0x3e>
  return filestat(f, st);
    80005d32:	fe043583          	ld	a1,-32(s0)
    80005d36:	fe843503          	ld	a0,-24(s0)
    80005d3a:	fffff097          	auipc	ra,0xfffff
    80005d3e:	278080e7          	jalr	632(ra) # 80004fb2 <filestat>
}
    80005d42:	60e2                	ld	ra,24(sp)
    80005d44:	6442                	ld	s0,16(sp)
    80005d46:	6105                	addi	sp,sp,32
    80005d48:	8082                	ret

0000000080005d4a <sys_link>:
{
    80005d4a:	7169                	addi	sp,sp,-304
    80005d4c:	f606                	sd	ra,296(sp)
    80005d4e:	f222                	sd	s0,288(sp)
    80005d50:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d52:	08000613          	li	a2,128
    80005d56:	ed040593          	addi	a1,s0,-304
    80005d5a:	4501                	li	a0,0
    80005d5c:	ffffd097          	auipc	ra,0xffffd
    80005d60:	616080e7          	jalr	1558(ra) # 80003372 <argstr>
    return -1;
    80005d64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d66:	12054663          	bltz	a0,80005e92 <sys_link+0x148>
    80005d6a:	08000613          	li	a2,128
    80005d6e:	f5040593          	addi	a1,s0,-176
    80005d72:	4505                	li	a0,1
    80005d74:	ffffd097          	auipc	ra,0xffffd
    80005d78:	5fe080e7          	jalr	1534(ra) # 80003372 <argstr>
    return -1;
    80005d7c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d7e:	10054a63          	bltz	a0,80005e92 <sys_link+0x148>
    80005d82:	ee26                	sd	s1,280(sp)
  begin_op();
    80005d84:	fffff097          	auipc	ra,0xfffff
    80005d88:	c82080e7          	jalr	-894(ra) # 80004a06 <begin_op>
  if((ip = namei(old)) == 0){
    80005d8c:	ed040513          	addi	a0,s0,-304
    80005d90:	fffff097          	auipc	ra,0xfffff
    80005d94:	a76080e7          	jalr	-1418(ra) # 80004806 <namei>
    80005d98:	84aa                	mv	s1,a0
    80005d9a:	c949                	beqz	a0,80005e2c <sys_link+0xe2>
  ilock(ip);
    80005d9c:	ffffe097          	auipc	ra,0xffffe
    80005da0:	29c080e7          	jalr	668(ra) # 80004038 <ilock>
  if(ip->type == T_DIR){
    80005da4:	04449703          	lh	a4,68(s1)
    80005da8:	4785                	li	a5,1
    80005daa:	08f70863          	beq	a4,a5,80005e3a <sys_link+0xf0>
    80005dae:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005db0:	04a4d783          	lhu	a5,74(s1)
    80005db4:	2785                	addiw	a5,a5,1
    80005db6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005dba:	8526                	mv	a0,s1
    80005dbc:	ffffe097          	auipc	ra,0xffffe
    80005dc0:	1b0080e7          	jalr	432(ra) # 80003f6c <iupdate>
  iunlock(ip);
    80005dc4:	8526                	mv	a0,s1
    80005dc6:	ffffe097          	auipc	ra,0xffffe
    80005dca:	338080e7          	jalr	824(ra) # 800040fe <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005dce:	fd040593          	addi	a1,s0,-48
    80005dd2:	f5040513          	addi	a0,s0,-176
    80005dd6:	fffff097          	auipc	ra,0xfffff
    80005dda:	a4e080e7          	jalr	-1458(ra) # 80004824 <nameiparent>
    80005dde:	892a                	mv	s2,a0
    80005de0:	cd35                	beqz	a0,80005e5c <sys_link+0x112>
  ilock(dp);
    80005de2:	ffffe097          	auipc	ra,0xffffe
    80005de6:	256080e7          	jalr	598(ra) # 80004038 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005dea:	00092703          	lw	a4,0(s2)
    80005dee:	409c                	lw	a5,0(s1)
    80005df0:	06f71163          	bne	a4,a5,80005e52 <sys_link+0x108>
    80005df4:	40d0                	lw	a2,4(s1)
    80005df6:	fd040593          	addi	a1,s0,-48
    80005dfa:	854a                	mv	a0,s2
    80005dfc:	fffff097          	auipc	ra,0xfffff
    80005e00:	958080e7          	jalr	-1704(ra) # 80004754 <dirlink>
    80005e04:	04054763          	bltz	a0,80005e52 <sys_link+0x108>
  iunlockput(dp);
    80005e08:	854a                	mv	a0,s2
    80005e0a:	ffffe097          	auipc	ra,0xffffe
    80005e0e:	494080e7          	jalr	1172(ra) # 8000429e <iunlockput>
  iput(ip);
    80005e12:	8526                	mv	a0,s1
    80005e14:	ffffe097          	auipc	ra,0xffffe
    80005e18:	3e2080e7          	jalr	994(ra) # 800041f6 <iput>
  end_op();
    80005e1c:	fffff097          	auipc	ra,0xfffff
    80005e20:	c64080e7          	jalr	-924(ra) # 80004a80 <end_op>
  return 0;
    80005e24:	4781                	li	a5,0
    80005e26:	64f2                	ld	s1,280(sp)
    80005e28:	6952                	ld	s2,272(sp)
    80005e2a:	a0a5                	j	80005e92 <sys_link+0x148>
    end_op();
    80005e2c:	fffff097          	auipc	ra,0xfffff
    80005e30:	c54080e7          	jalr	-940(ra) # 80004a80 <end_op>
    return -1;
    80005e34:	57fd                	li	a5,-1
    80005e36:	64f2                	ld	s1,280(sp)
    80005e38:	a8a9                	j	80005e92 <sys_link+0x148>
    iunlockput(ip);
    80005e3a:	8526                	mv	a0,s1
    80005e3c:	ffffe097          	auipc	ra,0xffffe
    80005e40:	462080e7          	jalr	1122(ra) # 8000429e <iunlockput>
    end_op();
    80005e44:	fffff097          	auipc	ra,0xfffff
    80005e48:	c3c080e7          	jalr	-964(ra) # 80004a80 <end_op>
    return -1;
    80005e4c:	57fd                	li	a5,-1
    80005e4e:	64f2                	ld	s1,280(sp)
    80005e50:	a089                	j	80005e92 <sys_link+0x148>
    iunlockput(dp);
    80005e52:	854a                	mv	a0,s2
    80005e54:	ffffe097          	auipc	ra,0xffffe
    80005e58:	44a080e7          	jalr	1098(ra) # 8000429e <iunlockput>
  ilock(ip);
    80005e5c:	8526                	mv	a0,s1
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	1da080e7          	jalr	474(ra) # 80004038 <ilock>
  ip->nlink--;
    80005e66:	04a4d783          	lhu	a5,74(s1)
    80005e6a:	37fd                	addiw	a5,a5,-1
    80005e6c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e70:	8526                	mv	a0,s1
    80005e72:	ffffe097          	auipc	ra,0xffffe
    80005e76:	0fa080e7          	jalr	250(ra) # 80003f6c <iupdate>
  iunlockput(ip);
    80005e7a:	8526                	mv	a0,s1
    80005e7c:	ffffe097          	auipc	ra,0xffffe
    80005e80:	422080e7          	jalr	1058(ra) # 8000429e <iunlockput>
  end_op();
    80005e84:	fffff097          	auipc	ra,0xfffff
    80005e88:	bfc080e7          	jalr	-1028(ra) # 80004a80 <end_op>
  return -1;
    80005e8c:	57fd                	li	a5,-1
    80005e8e:	64f2                	ld	s1,280(sp)
    80005e90:	6952                	ld	s2,272(sp)
}
    80005e92:	853e                	mv	a0,a5
    80005e94:	70b2                	ld	ra,296(sp)
    80005e96:	7412                	ld	s0,288(sp)
    80005e98:	6155                	addi	sp,sp,304
    80005e9a:	8082                	ret

0000000080005e9c <sys_unlink>:
{
    80005e9c:	7151                	addi	sp,sp,-240
    80005e9e:	f586                	sd	ra,232(sp)
    80005ea0:	f1a2                	sd	s0,224(sp)
    80005ea2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005ea4:	08000613          	li	a2,128
    80005ea8:	f3040593          	addi	a1,s0,-208
    80005eac:	4501                	li	a0,0
    80005eae:	ffffd097          	auipc	ra,0xffffd
    80005eb2:	4c4080e7          	jalr	1220(ra) # 80003372 <argstr>
    80005eb6:	1a054a63          	bltz	a0,8000606a <sys_unlink+0x1ce>
    80005eba:	eda6                	sd	s1,216(sp)
  begin_op();
    80005ebc:	fffff097          	auipc	ra,0xfffff
    80005ec0:	b4a080e7          	jalr	-1206(ra) # 80004a06 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005ec4:	fb040593          	addi	a1,s0,-80
    80005ec8:	f3040513          	addi	a0,s0,-208
    80005ecc:	fffff097          	auipc	ra,0xfffff
    80005ed0:	958080e7          	jalr	-1704(ra) # 80004824 <nameiparent>
    80005ed4:	84aa                	mv	s1,a0
    80005ed6:	cd71                	beqz	a0,80005fb2 <sys_unlink+0x116>
  ilock(dp);
    80005ed8:	ffffe097          	auipc	ra,0xffffe
    80005edc:	160080e7          	jalr	352(ra) # 80004038 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ee0:	00002597          	auipc	a1,0x2
    80005ee4:	72058593          	addi	a1,a1,1824 # 80008600 <etext+0x600>
    80005ee8:	fb040513          	addi	a0,s0,-80
    80005eec:	ffffe097          	auipc	ra,0xffffe
    80005ef0:	63e080e7          	jalr	1598(ra) # 8000452a <namecmp>
    80005ef4:	14050c63          	beqz	a0,8000604c <sys_unlink+0x1b0>
    80005ef8:	00002597          	auipc	a1,0x2
    80005efc:	71058593          	addi	a1,a1,1808 # 80008608 <etext+0x608>
    80005f00:	fb040513          	addi	a0,s0,-80
    80005f04:	ffffe097          	auipc	ra,0xffffe
    80005f08:	626080e7          	jalr	1574(ra) # 8000452a <namecmp>
    80005f0c:	14050063          	beqz	a0,8000604c <sys_unlink+0x1b0>
    80005f10:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005f12:	f2c40613          	addi	a2,s0,-212
    80005f16:	fb040593          	addi	a1,s0,-80
    80005f1a:	8526                	mv	a0,s1
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	628080e7          	jalr	1576(ra) # 80004544 <dirlookup>
    80005f24:	892a                	mv	s2,a0
    80005f26:	12050263          	beqz	a0,8000604a <sys_unlink+0x1ae>
  ilock(ip);
    80005f2a:	ffffe097          	auipc	ra,0xffffe
    80005f2e:	10e080e7          	jalr	270(ra) # 80004038 <ilock>
  if(ip->nlink < 1)
    80005f32:	04a91783          	lh	a5,74(s2)
    80005f36:	08f05563          	blez	a5,80005fc0 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005f3a:	04491703          	lh	a4,68(s2)
    80005f3e:	4785                	li	a5,1
    80005f40:	08f70963          	beq	a4,a5,80005fd2 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80005f44:	4641                	li	a2,16
    80005f46:	4581                	li	a1,0
    80005f48:	fc040513          	addi	a0,s0,-64
    80005f4c:	ffffb097          	auipc	ra,0xffffb
    80005f50:	de8080e7          	jalr	-536(ra) # 80000d34 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f54:	4741                	li	a4,16
    80005f56:	f2c42683          	lw	a3,-212(s0)
    80005f5a:	fc040613          	addi	a2,s0,-64
    80005f5e:	4581                	li	a1,0
    80005f60:	8526                	mv	a0,s1
    80005f62:	ffffe097          	auipc	ra,0xffffe
    80005f66:	49e080e7          	jalr	1182(ra) # 80004400 <writei>
    80005f6a:	47c1                	li	a5,16
    80005f6c:	0af51b63          	bne	a0,a5,80006022 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80005f70:	04491703          	lh	a4,68(s2)
    80005f74:	4785                	li	a5,1
    80005f76:	0af70f63          	beq	a4,a5,80006034 <sys_unlink+0x198>
  iunlockput(dp);
    80005f7a:	8526                	mv	a0,s1
    80005f7c:	ffffe097          	auipc	ra,0xffffe
    80005f80:	322080e7          	jalr	802(ra) # 8000429e <iunlockput>
  ip->nlink--;
    80005f84:	04a95783          	lhu	a5,74(s2)
    80005f88:	37fd                	addiw	a5,a5,-1
    80005f8a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005f8e:	854a                	mv	a0,s2
    80005f90:	ffffe097          	auipc	ra,0xffffe
    80005f94:	fdc080e7          	jalr	-36(ra) # 80003f6c <iupdate>
  iunlockput(ip);
    80005f98:	854a                	mv	a0,s2
    80005f9a:	ffffe097          	auipc	ra,0xffffe
    80005f9e:	304080e7          	jalr	772(ra) # 8000429e <iunlockput>
  end_op();
    80005fa2:	fffff097          	auipc	ra,0xfffff
    80005fa6:	ade080e7          	jalr	-1314(ra) # 80004a80 <end_op>
  return 0;
    80005faa:	4501                	li	a0,0
    80005fac:	64ee                	ld	s1,216(sp)
    80005fae:	694e                	ld	s2,208(sp)
    80005fb0:	a84d                	j	80006062 <sys_unlink+0x1c6>
    end_op();
    80005fb2:	fffff097          	auipc	ra,0xfffff
    80005fb6:	ace080e7          	jalr	-1330(ra) # 80004a80 <end_op>
    return -1;
    80005fba:	557d                	li	a0,-1
    80005fbc:	64ee                	ld	s1,216(sp)
    80005fbe:	a055                	j	80006062 <sys_unlink+0x1c6>
    80005fc0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005fc2:	00002517          	auipc	a0,0x2
    80005fc6:	64e50513          	addi	a0,a0,1614 # 80008610 <etext+0x610>
    80005fca:	ffffa097          	auipc	ra,0xffffa
    80005fce:	596080e7          	jalr	1430(ra) # 80000560 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005fd2:	04c92703          	lw	a4,76(s2)
    80005fd6:	02000793          	li	a5,32
    80005fda:	f6e7f5e3          	bgeu	a5,a4,80005f44 <sys_unlink+0xa8>
    80005fde:	e5ce                	sd	s3,200(sp)
    80005fe0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005fe4:	4741                	li	a4,16
    80005fe6:	86ce                	mv	a3,s3
    80005fe8:	f1840613          	addi	a2,s0,-232
    80005fec:	4581                	li	a1,0
    80005fee:	854a                	mv	a0,s2
    80005ff0:	ffffe097          	auipc	ra,0xffffe
    80005ff4:	300080e7          	jalr	768(ra) # 800042f0 <readi>
    80005ff8:	47c1                	li	a5,16
    80005ffa:	00f51c63          	bne	a0,a5,80006012 <sys_unlink+0x176>
    if(de.inum != 0)
    80005ffe:	f1845783          	lhu	a5,-232(s0)
    80006002:	e7b5                	bnez	a5,8000606e <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006004:	29c1                	addiw	s3,s3,16
    80006006:	04c92783          	lw	a5,76(s2)
    8000600a:	fcf9ede3          	bltu	s3,a5,80005fe4 <sys_unlink+0x148>
    8000600e:	69ae                	ld	s3,200(sp)
    80006010:	bf15                	j	80005f44 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80006012:	00002517          	auipc	a0,0x2
    80006016:	61650513          	addi	a0,a0,1558 # 80008628 <etext+0x628>
    8000601a:	ffffa097          	auipc	ra,0xffffa
    8000601e:	546080e7          	jalr	1350(ra) # 80000560 <panic>
    80006022:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80006024:	00002517          	auipc	a0,0x2
    80006028:	61c50513          	addi	a0,a0,1564 # 80008640 <etext+0x640>
    8000602c:	ffffa097          	auipc	ra,0xffffa
    80006030:	534080e7          	jalr	1332(ra) # 80000560 <panic>
    dp->nlink--;
    80006034:	04a4d783          	lhu	a5,74(s1)
    80006038:	37fd                	addiw	a5,a5,-1
    8000603a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000603e:	8526                	mv	a0,s1
    80006040:	ffffe097          	auipc	ra,0xffffe
    80006044:	f2c080e7          	jalr	-212(ra) # 80003f6c <iupdate>
    80006048:	bf0d                	j	80005f7a <sys_unlink+0xde>
    8000604a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000604c:	8526                	mv	a0,s1
    8000604e:	ffffe097          	auipc	ra,0xffffe
    80006052:	250080e7          	jalr	592(ra) # 8000429e <iunlockput>
  end_op();
    80006056:	fffff097          	auipc	ra,0xfffff
    8000605a:	a2a080e7          	jalr	-1494(ra) # 80004a80 <end_op>
  return -1;
    8000605e:	557d                	li	a0,-1
    80006060:	64ee                	ld	s1,216(sp)
}
    80006062:	70ae                	ld	ra,232(sp)
    80006064:	740e                	ld	s0,224(sp)
    80006066:	616d                	addi	sp,sp,240
    80006068:	8082                	ret
    return -1;
    8000606a:	557d                	li	a0,-1
    8000606c:	bfdd                	j	80006062 <sys_unlink+0x1c6>
    iunlockput(ip);
    8000606e:	854a                	mv	a0,s2
    80006070:	ffffe097          	auipc	ra,0xffffe
    80006074:	22e080e7          	jalr	558(ra) # 8000429e <iunlockput>
    goto bad;
    80006078:	694e                	ld	s2,208(sp)
    8000607a:	69ae                	ld	s3,200(sp)
    8000607c:	bfc1                	j	8000604c <sys_unlink+0x1b0>

000000008000607e <sys_open>:

uint64
sys_open(void)
{
    8000607e:	7131                	addi	sp,sp,-192
    80006080:	fd06                	sd	ra,184(sp)
    80006082:	f922                	sd	s0,176(sp)
    80006084:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80006086:	f4c40593          	addi	a1,s0,-180
    8000608a:	4505                	li	a0,1
    8000608c:	ffffd097          	auipc	ra,0xffffd
    80006090:	2a6080e7          	jalr	678(ra) # 80003332 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006094:	08000613          	li	a2,128
    80006098:	f5040593          	addi	a1,s0,-176
    8000609c:	4501                	li	a0,0
    8000609e:	ffffd097          	auipc	ra,0xffffd
    800060a2:	2d4080e7          	jalr	724(ra) # 80003372 <argstr>
    800060a6:	87aa                	mv	a5,a0
    return -1;
    800060a8:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800060aa:	0a07ce63          	bltz	a5,80006166 <sys_open+0xe8>
    800060ae:	f526                	sd	s1,168(sp)

  begin_op();
    800060b0:	fffff097          	auipc	ra,0xfffff
    800060b4:	956080e7          	jalr	-1706(ra) # 80004a06 <begin_op>

  if(omode & O_CREATE){
    800060b8:	f4c42783          	lw	a5,-180(s0)
    800060bc:	2007f793          	andi	a5,a5,512
    800060c0:	cfd5                	beqz	a5,8000617c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800060c2:	4681                	li	a3,0
    800060c4:	4601                	li	a2,0
    800060c6:	4589                	li	a1,2
    800060c8:	f5040513          	addi	a0,s0,-176
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	95a080e7          	jalr	-1702(ra) # 80005a26 <create>
    800060d4:	84aa                	mv	s1,a0
    if(ip == 0){
    800060d6:	cd41                	beqz	a0,8000616e <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800060d8:	04449703          	lh	a4,68(s1)
    800060dc:	478d                	li	a5,3
    800060de:	00f71763          	bne	a4,a5,800060ec <sys_open+0x6e>
    800060e2:	0464d703          	lhu	a4,70(s1)
    800060e6:	47a5                	li	a5,9
    800060e8:	0ee7e163          	bltu	a5,a4,800061ca <sys_open+0x14c>
    800060ec:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800060ee:	fffff097          	auipc	ra,0xfffff
    800060f2:	d26080e7          	jalr	-730(ra) # 80004e14 <filealloc>
    800060f6:	892a                	mv	s2,a0
    800060f8:	c97d                	beqz	a0,800061ee <sys_open+0x170>
    800060fa:	ed4e                	sd	s3,152(sp)
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	8e8080e7          	jalr	-1816(ra) # 800059e4 <fdalloc>
    80006104:	89aa                	mv	s3,a0
    80006106:	0c054e63          	bltz	a0,800061e2 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000610a:	04449703          	lh	a4,68(s1)
    8000610e:	478d                	li	a5,3
    80006110:	0ef70c63          	beq	a4,a5,80006208 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006114:	4789                	li	a5,2
    80006116:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000611a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000611e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006122:	f4c42783          	lw	a5,-180(s0)
    80006126:	0017c713          	xori	a4,a5,1
    8000612a:	8b05                	andi	a4,a4,1
    8000612c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006130:	0037f713          	andi	a4,a5,3
    80006134:	00e03733          	snez	a4,a4
    80006138:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000613c:	4007f793          	andi	a5,a5,1024
    80006140:	c791                	beqz	a5,8000614c <sys_open+0xce>
    80006142:	04449703          	lh	a4,68(s1)
    80006146:	4789                	li	a5,2
    80006148:	0cf70763          	beq	a4,a5,80006216 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    8000614c:	8526                	mv	a0,s1
    8000614e:	ffffe097          	auipc	ra,0xffffe
    80006152:	fb0080e7          	jalr	-80(ra) # 800040fe <iunlock>
  end_op();
    80006156:	fffff097          	auipc	ra,0xfffff
    8000615a:	92a080e7          	jalr	-1750(ra) # 80004a80 <end_op>

  return fd;
    8000615e:	854e                	mv	a0,s3
    80006160:	74aa                	ld	s1,168(sp)
    80006162:	790a                	ld	s2,160(sp)
    80006164:	69ea                	ld	s3,152(sp)
}
    80006166:	70ea                	ld	ra,184(sp)
    80006168:	744a                	ld	s0,176(sp)
    8000616a:	6129                	addi	sp,sp,192
    8000616c:	8082                	ret
      end_op();
    8000616e:	fffff097          	auipc	ra,0xfffff
    80006172:	912080e7          	jalr	-1774(ra) # 80004a80 <end_op>
      return -1;
    80006176:	557d                	li	a0,-1
    80006178:	74aa                	ld	s1,168(sp)
    8000617a:	b7f5                	j	80006166 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    8000617c:	f5040513          	addi	a0,s0,-176
    80006180:	ffffe097          	auipc	ra,0xffffe
    80006184:	686080e7          	jalr	1670(ra) # 80004806 <namei>
    80006188:	84aa                	mv	s1,a0
    8000618a:	c90d                	beqz	a0,800061bc <sys_open+0x13e>
    ilock(ip);
    8000618c:	ffffe097          	auipc	ra,0xffffe
    80006190:	eac080e7          	jalr	-340(ra) # 80004038 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006194:	04449703          	lh	a4,68(s1)
    80006198:	4785                	li	a5,1
    8000619a:	f2f71fe3          	bne	a4,a5,800060d8 <sys_open+0x5a>
    8000619e:	f4c42783          	lw	a5,-180(s0)
    800061a2:	d7a9                	beqz	a5,800060ec <sys_open+0x6e>
      iunlockput(ip);
    800061a4:	8526                	mv	a0,s1
    800061a6:	ffffe097          	auipc	ra,0xffffe
    800061aa:	0f8080e7          	jalr	248(ra) # 8000429e <iunlockput>
      end_op();
    800061ae:	fffff097          	auipc	ra,0xfffff
    800061b2:	8d2080e7          	jalr	-1838(ra) # 80004a80 <end_op>
      return -1;
    800061b6:	557d                	li	a0,-1
    800061b8:	74aa                	ld	s1,168(sp)
    800061ba:	b775                	j	80006166 <sys_open+0xe8>
      end_op();
    800061bc:	fffff097          	auipc	ra,0xfffff
    800061c0:	8c4080e7          	jalr	-1852(ra) # 80004a80 <end_op>
      return -1;
    800061c4:	557d                	li	a0,-1
    800061c6:	74aa                	ld	s1,168(sp)
    800061c8:	bf79                	j	80006166 <sys_open+0xe8>
    iunlockput(ip);
    800061ca:	8526                	mv	a0,s1
    800061cc:	ffffe097          	auipc	ra,0xffffe
    800061d0:	0d2080e7          	jalr	210(ra) # 8000429e <iunlockput>
    end_op();
    800061d4:	fffff097          	auipc	ra,0xfffff
    800061d8:	8ac080e7          	jalr	-1876(ra) # 80004a80 <end_op>
    return -1;
    800061dc:	557d                	li	a0,-1
    800061de:	74aa                	ld	s1,168(sp)
    800061e0:	b759                	j	80006166 <sys_open+0xe8>
      fileclose(f);
    800061e2:	854a                	mv	a0,s2
    800061e4:	fffff097          	auipc	ra,0xfffff
    800061e8:	cec080e7          	jalr	-788(ra) # 80004ed0 <fileclose>
    800061ec:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800061ee:	8526                	mv	a0,s1
    800061f0:	ffffe097          	auipc	ra,0xffffe
    800061f4:	0ae080e7          	jalr	174(ra) # 8000429e <iunlockput>
    end_op();
    800061f8:	fffff097          	auipc	ra,0xfffff
    800061fc:	888080e7          	jalr	-1912(ra) # 80004a80 <end_op>
    return -1;
    80006200:	557d                	li	a0,-1
    80006202:	74aa                	ld	s1,168(sp)
    80006204:	790a                	ld	s2,160(sp)
    80006206:	b785                	j	80006166 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80006208:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000620c:	04649783          	lh	a5,70(s1)
    80006210:	02f91223          	sh	a5,36(s2)
    80006214:	b729                	j	8000611e <sys_open+0xa0>
    itrunc(ip);
    80006216:	8526                	mv	a0,s1
    80006218:	ffffe097          	auipc	ra,0xffffe
    8000621c:	f32080e7          	jalr	-206(ra) # 8000414a <itrunc>
    80006220:	b735                	j	8000614c <sys_open+0xce>

0000000080006222 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006222:	7175                	addi	sp,sp,-144
    80006224:	e506                	sd	ra,136(sp)
    80006226:	e122                	sd	s0,128(sp)
    80006228:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000622a:	ffffe097          	auipc	ra,0xffffe
    8000622e:	7dc080e7          	jalr	2012(ra) # 80004a06 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006232:	08000613          	li	a2,128
    80006236:	f7040593          	addi	a1,s0,-144
    8000623a:	4501                	li	a0,0
    8000623c:	ffffd097          	auipc	ra,0xffffd
    80006240:	136080e7          	jalr	310(ra) # 80003372 <argstr>
    80006244:	02054963          	bltz	a0,80006276 <sys_mkdir+0x54>
    80006248:	4681                	li	a3,0
    8000624a:	4601                	li	a2,0
    8000624c:	4585                	li	a1,1
    8000624e:	f7040513          	addi	a0,s0,-144
    80006252:	fffff097          	auipc	ra,0xfffff
    80006256:	7d4080e7          	jalr	2004(ra) # 80005a26 <create>
    8000625a:	cd11                	beqz	a0,80006276 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000625c:	ffffe097          	auipc	ra,0xffffe
    80006260:	042080e7          	jalr	66(ra) # 8000429e <iunlockput>
  end_op();
    80006264:	fffff097          	auipc	ra,0xfffff
    80006268:	81c080e7          	jalr	-2020(ra) # 80004a80 <end_op>
  return 0;
    8000626c:	4501                	li	a0,0
}
    8000626e:	60aa                	ld	ra,136(sp)
    80006270:	640a                	ld	s0,128(sp)
    80006272:	6149                	addi	sp,sp,144
    80006274:	8082                	ret
    end_op();
    80006276:	fffff097          	auipc	ra,0xfffff
    8000627a:	80a080e7          	jalr	-2038(ra) # 80004a80 <end_op>
    return -1;
    8000627e:	557d                	li	a0,-1
    80006280:	b7fd                	j	8000626e <sys_mkdir+0x4c>

0000000080006282 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006282:	7135                	addi	sp,sp,-160
    80006284:	ed06                	sd	ra,152(sp)
    80006286:	e922                	sd	s0,144(sp)
    80006288:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000628a:	ffffe097          	auipc	ra,0xffffe
    8000628e:	77c080e7          	jalr	1916(ra) # 80004a06 <begin_op>
  argint(1, &major);
    80006292:	f6c40593          	addi	a1,s0,-148
    80006296:	4505                	li	a0,1
    80006298:	ffffd097          	auipc	ra,0xffffd
    8000629c:	09a080e7          	jalr	154(ra) # 80003332 <argint>
  argint(2, &minor);
    800062a0:	f6840593          	addi	a1,s0,-152
    800062a4:	4509                	li	a0,2
    800062a6:	ffffd097          	auipc	ra,0xffffd
    800062aa:	08c080e7          	jalr	140(ra) # 80003332 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800062ae:	08000613          	li	a2,128
    800062b2:	f7040593          	addi	a1,s0,-144
    800062b6:	4501                	li	a0,0
    800062b8:	ffffd097          	auipc	ra,0xffffd
    800062bc:	0ba080e7          	jalr	186(ra) # 80003372 <argstr>
    800062c0:	02054b63          	bltz	a0,800062f6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800062c4:	f6841683          	lh	a3,-152(s0)
    800062c8:	f6c41603          	lh	a2,-148(s0)
    800062cc:	458d                	li	a1,3
    800062ce:	f7040513          	addi	a0,s0,-144
    800062d2:	fffff097          	auipc	ra,0xfffff
    800062d6:	754080e7          	jalr	1876(ra) # 80005a26 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800062da:	cd11                	beqz	a0,800062f6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800062dc:	ffffe097          	auipc	ra,0xffffe
    800062e0:	fc2080e7          	jalr	-62(ra) # 8000429e <iunlockput>
  end_op();
    800062e4:	ffffe097          	auipc	ra,0xffffe
    800062e8:	79c080e7          	jalr	1948(ra) # 80004a80 <end_op>
  return 0;
    800062ec:	4501                	li	a0,0
}
    800062ee:	60ea                	ld	ra,152(sp)
    800062f0:	644a                	ld	s0,144(sp)
    800062f2:	610d                	addi	sp,sp,160
    800062f4:	8082                	ret
    end_op();
    800062f6:	ffffe097          	auipc	ra,0xffffe
    800062fa:	78a080e7          	jalr	1930(ra) # 80004a80 <end_op>
    return -1;
    800062fe:	557d                	li	a0,-1
    80006300:	b7fd                	j	800062ee <sys_mknod+0x6c>

0000000080006302 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006302:	7135                	addi	sp,sp,-160
    80006304:	ed06                	sd	ra,152(sp)
    80006306:	e922                	sd	s0,144(sp)
    80006308:	e14a                	sd	s2,128(sp)
    8000630a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000630c:	ffffc097          	auipc	ra,0xffffc
    80006310:	8de080e7          	jalr	-1826(ra) # 80001bea <myproc>
    80006314:	892a                	mv	s2,a0
  
  begin_op();
    80006316:	ffffe097          	auipc	ra,0xffffe
    8000631a:	6f0080e7          	jalr	1776(ra) # 80004a06 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000631e:	08000613          	li	a2,128
    80006322:	f6040593          	addi	a1,s0,-160
    80006326:	4501                	li	a0,0
    80006328:	ffffd097          	auipc	ra,0xffffd
    8000632c:	04a080e7          	jalr	74(ra) # 80003372 <argstr>
    80006330:	04054d63          	bltz	a0,8000638a <sys_chdir+0x88>
    80006334:	e526                	sd	s1,136(sp)
    80006336:	f6040513          	addi	a0,s0,-160
    8000633a:	ffffe097          	auipc	ra,0xffffe
    8000633e:	4cc080e7          	jalr	1228(ra) # 80004806 <namei>
    80006342:	84aa                	mv	s1,a0
    80006344:	c131                	beqz	a0,80006388 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006346:	ffffe097          	auipc	ra,0xffffe
    8000634a:	cf2080e7          	jalr	-782(ra) # 80004038 <ilock>
  if(ip->type != T_DIR){
    8000634e:	04449703          	lh	a4,68(s1)
    80006352:	4785                	li	a5,1
    80006354:	04f71163          	bne	a4,a5,80006396 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006358:	8526                	mv	a0,s1
    8000635a:	ffffe097          	auipc	ra,0xffffe
    8000635e:	da4080e7          	jalr	-604(ra) # 800040fe <iunlock>
  iput(p->cwd);
    80006362:	32893503          	ld	a0,808(s2)
    80006366:	ffffe097          	auipc	ra,0xffffe
    8000636a:	e90080e7          	jalr	-368(ra) # 800041f6 <iput>
  end_op();
    8000636e:	ffffe097          	auipc	ra,0xffffe
    80006372:	712080e7          	jalr	1810(ra) # 80004a80 <end_op>
  p->cwd = ip;
    80006376:	32993423          	sd	s1,808(s2)
  return 0;
    8000637a:	4501                	li	a0,0
    8000637c:	64aa                	ld	s1,136(sp)
}
    8000637e:	60ea                	ld	ra,152(sp)
    80006380:	644a                	ld	s0,144(sp)
    80006382:	690a                	ld	s2,128(sp)
    80006384:	610d                	addi	sp,sp,160
    80006386:	8082                	ret
    80006388:	64aa                	ld	s1,136(sp)
    end_op();
    8000638a:	ffffe097          	auipc	ra,0xffffe
    8000638e:	6f6080e7          	jalr	1782(ra) # 80004a80 <end_op>
    return -1;
    80006392:	557d                	li	a0,-1
    80006394:	b7ed                	j	8000637e <sys_chdir+0x7c>
    iunlockput(ip);
    80006396:	8526                	mv	a0,s1
    80006398:	ffffe097          	auipc	ra,0xffffe
    8000639c:	f06080e7          	jalr	-250(ra) # 8000429e <iunlockput>
    end_op();
    800063a0:	ffffe097          	auipc	ra,0xffffe
    800063a4:	6e0080e7          	jalr	1760(ra) # 80004a80 <end_op>
    return -1;
    800063a8:	557d                	li	a0,-1
    800063aa:	64aa                	ld	s1,136(sp)
    800063ac:	bfc9                	j	8000637e <sys_chdir+0x7c>

00000000800063ae <sys_exec>:

uint64
sys_exec(void)
{
    800063ae:	7121                	addi	sp,sp,-448
    800063b0:	ff06                	sd	ra,440(sp)
    800063b2:	fb22                	sd	s0,432(sp)
    800063b4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800063b6:	e4840593          	addi	a1,s0,-440
    800063ba:	4505                	li	a0,1
    800063bc:	ffffd097          	auipc	ra,0xffffd
    800063c0:	f96080e7          	jalr	-106(ra) # 80003352 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800063c4:	08000613          	li	a2,128
    800063c8:	f5040593          	addi	a1,s0,-176
    800063cc:	4501                	li	a0,0
    800063ce:	ffffd097          	auipc	ra,0xffffd
    800063d2:	fa4080e7          	jalr	-92(ra) # 80003372 <argstr>
    800063d6:	87aa                	mv	a5,a0
    return -1;
    800063d8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800063da:	0e07c263          	bltz	a5,800064be <sys_exec+0x110>
    800063de:	f726                	sd	s1,424(sp)
    800063e0:	f34a                	sd	s2,416(sp)
    800063e2:	ef4e                	sd	s3,408(sp)
    800063e4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800063e6:	10000613          	li	a2,256
    800063ea:	4581                	li	a1,0
    800063ec:	e5040513          	addi	a0,s0,-432
    800063f0:	ffffb097          	auipc	ra,0xffffb
    800063f4:	944080e7          	jalr	-1724(ra) # 80000d34 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800063f8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800063fc:	89a6                	mv	s3,s1
    800063fe:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80006400:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006404:	00391513          	slli	a0,s2,0x3
    80006408:	e4040593          	addi	a1,s0,-448
    8000640c:	e4843783          	ld	a5,-440(s0)
    80006410:	953e                	add	a0,a0,a5
    80006412:	ffffd097          	auipc	ra,0xffffd
    80006416:	e7c080e7          	jalr	-388(ra) # 8000328e <fetchaddr>
    8000641a:	02054a63          	bltz	a0,8000644e <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    8000641e:	e4043783          	ld	a5,-448(s0)
    80006422:	c7b9                	beqz	a5,80006470 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006424:	ffffa097          	auipc	ra,0xffffa
    80006428:	724080e7          	jalr	1828(ra) # 80000b48 <kalloc>
    8000642c:	85aa                	mv	a1,a0
    8000642e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80006432:	cd11                	beqz	a0,8000644e <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006434:	6605                	lui	a2,0x1
    80006436:	e4043503          	ld	a0,-448(s0)
    8000643a:	ffffd097          	auipc	ra,0xffffd
    8000643e:	eaa080e7          	jalr	-342(ra) # 800032e4 <fetchstr>
    80006442:	00054663          	bltz	a0,8000644e <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80006446:	0905                	addi	s2,s2,1
    80006448:	09a1                	addi	s3,s3,8
    8000644a:	fb491de3          	bne	s2,s4,80006404 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000644e:	f5040913          	addi	s2,s0,-176
    80006452:	6088                	ld	a0,0(s1)
    80006454:	c125                	beqz	a0,800064b4 <sys_exec+0x106>
    kfree(argv[i]);
    80006456:	ffffa097          	auipc	ra,0xffffa
    8000645a:	5f4080e7          	jalr	1524(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000645e:	04a1                	addi	s1,s1,8
    80006460:	ff2499e3          	bne	s1,s2,80006452 <sys_exec+0xa4>
  return -1;
    80006464:	557d                	li	a0,-1
    80006466:	74ba                	ld	s1,424(sp)
    80006468:	791a                	ld	s2,416(sp)
    8000646a:	69fa                	ld	s3,408(sp)
    8000646c:	6a5a                	ld	s4,400(sp)
    8000646e:	a881                	j	800064be <sys_exec+0x110>
      argv[i] = 0;
    80006470:	0009079b          	sext.w	a5,s2
    80006474:	078e                	slli	a5,a5,0x3
    80006476:	fd078793          	addi	a5,a5,-48
    8000647a:	97a2                	add	a5,a5,s0
    8000647c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80006480:	e5040593          	addi	a1,s0,-432
    80006484:	f5040513          	addi	a0,s0,-176
    80006488:	fffff097          	auipc	ra,0xfffff
    8000648c:	11e080e7          	jalr	286(ra) # 800055a6 <exec>
    80006490:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006492:	f5040993          	addi	s3,s0,-176
    80006496:	6088                	ld	a0,0(s1)
    80006498:	c901                	beqz	a0,800064a8 <sys_exec+0xfa>
    kfree(argv[i]);
    8000649a:	ffffa097          	auipc	ra,0xffffa
    8000649e:	5b0080e7          	jalr	1456(ra) # 80000a4a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800064a2:	04a1                	addi	s1,s1,8
    800064a4:	ff3499e3          	bne	s1,s3,80006496 <sys_exec+0xe8>
  return ret;
    800064a8:	854a                	mv	a0,s2
    800064aa:	74ba                	ld	s1,424(sp)
    800064ac:	791a                	ld	s2,416(sp)
    800064ae:	69fa                	ld	s3,408(sp)
    800064b0:	6a5a                	ld	s4,400(sp)
    800064b2:	a031                	j	800064be <sys_exec+0x110>
  return -1;
    800064b4:	557d                	li	a0,-1
    800064b6:	74ba                	ld	s1,424(sp)
    800064b8:	791a                	ld	s2,416(sp)
    800064ba:	69fa                	ld	s3,408(sp)
    800064bc:	6a5a                	ld	s4,400(sp)
}
    800064be:	70fa                	ld	ra,440(sp)
    800064c0:	745a                	ld	s0,432(sp)
    800064c2:	6139                	addi	sp,sp,448
    800064c4:	8082                	ret

00000000800064c6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800064c6:	7139                	addi	sp,sp,-64
    800064c8:	fc06                	sd	ra,56(sp)
    800064ca:	f822                	sd	s0,48(sp)
    800064cc:	f426                	sd	s1,40(sp)
    800064ce:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800064d0:	ffffb097          	auipc	ra,0xffffb
    800064d4:	71a080e7          	jalr	1818(ra) # 80001bea <myproc>
    800064d8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800064da:	fd840593          	addi	a1,s0,-40
    800064de:	4501                	li	a0,0
    800064e0:	ffffd097          	auipc	ra,0xffffd
    800064e4:	e72080e7          	jalr	-398(ra) # 80003352 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800064e8:	fc840593          	addi	a1,s0,-56
    800064ec:	fd040513          	addi	a0,s0,-48
    800064f0:	fffff097          	auipc	ra,0xfffff
    800064f4:	d4e080e7          	jalr	-690(ra) # 8000523e <pipealloc>
    return -1;
    800064f8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800064fa:	0c054963          	bltz	a0,800065cc <sys_pipe+0x106>
  fd0 = -1;
    800064fe:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006502:	fd043503          	ld	a0,-48(s0)
    80006506:	fffff097          	auipc	ra,0xfffff
    8000650a:	4de080e7          	jalr	1246(ra) # 800059e4 <fdalloc>
    8000650e:	fca42223          	sw	a0,-60(s0)
    80006512:	0a054063          	bltz	a0,800065b2 <sys_pipe+0xec>
    80006516:	fc843503          	ld	a0,-56(s0)
    8000651a:	fffff097          	auipc	ra,0xfffff
    8000651e:	4ca080e7          	jalr	1226(ra) # 800059e4 <fdalloc>
    80006522:	fca42023          	sw	a0,-64(s0)
    80006526:	06054c63          	bltz	a0,8000659e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000652a:	4691                	li	a3,4
    8000652c:	fc440613          	addi	a2,s0,-60
    80006530:	fd843583          	ld	a1,-40(s0)
    80006534:	2284b503          	ld	a0,552(s1)
    80006538:	ffffb097          	auipc	ra,0xffffb
    8000653c:	1aa080e7          	jalr	426(ra) # 800016e2 <copyout>
    80006540:	02054163          	bltz	a0,80006562 <sys_pipe+0x9c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006544:	4691                	li	a3,4
    80006546:	fc040613          	addi	a2,s0,-64
    8000654a:	fd843583          	ld	a1,-40(s0)
    8000654e:	0591                	addi	a1,a1,4
    80006550:	2284b503          	ld	a0,552(s1)
    80006554:	ffffb097          	auipc	ra,0xffffb
    80006558:	18e080e7          	jalr	398(ra) # 800016e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000655c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000655e:	06055763          	bgez	a0,800065cc <sys_pipe+0x106>
    p->ofile[fd0] = 0;
    80006562:	fc442783          	lw	a5,-60(s0)
    80006566:	05478793          	addi	a5,a5,84
    8000656a:	078e                	slli	a5,a5,0x3
    8000656c:	97a6                	add	a5,a5,s1
    8000656e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006572:	fc042783          	lw	a5,-64(s0)
    80006576:	05478793          	addi	a5,a5,84
    8000657a:	078e                	slli	a5,a5,0x3
    8000657c:	94be                	add	s1,s1,a5
    8000657e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80006582:	fd043503          	ld	a0,-48(s0)
    80006586:	fffff097          	auipc	ra,0xfffff
    8000658a:	94a080e7          	jalr	-1718(ra) # 80004ed0 <fileclose>
    fileclose(wf);
    8000658e:	fc843503          	ld	a0,-56(s0)
    80006592:	fffff097          	auipc	ra,0xfffff
    80006596:	93e080e7          	jalr	-1730(ra) # 80004ed0 <fileclose>
    return -1;
    8000659a:	57fd                	li	a5,-1
    8000659c:	a805                	j	800065cc <sys_pipe+0x106>
    if(fd0 >= 0)
    8000659e:	fc442783          	lw	a5,-60(s0)
    800065a2:	0007c863          	bltz	a5,800065b2 <sys_pipe+0xec>
      p->ofile[fd0] = 0;
    800065a6:	05478793          	addi	a5,a5,84
    800065aa:	078e                	slli	a5,a5,0x3
    800065ac:	97a6                	add	a5,a5,s1
    800065ae:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800065b2:	fd043503          	ld	a0,-48(s0)
    800065b6:	fffff097          	auipc	ra,0xfffff
    800065ba:	91a080e7          	jalr	-1766(ra) # 80004ed0 <fileclose>
    fileclose(wf);
    800065be:	fc843503          	ld	a0,-56(s0)
    800065c2:	fffff097          	auipc	ra,0xfffff
    800065c6:	90e080e7          	jalr	-1778(ra) # 80004ed0 <fileclose>
    return -1;
    800065ca:	57fd                	li	a5,-1
}
    800065cc:	853e                	mv	a0,a5
    800065ce:	70e2                	ld	ra,56(sp)
    800065d0:	7442                	ld	s0,48(sp)
    800065d2:	74a2                	ld	s1,40(sp)
    800065d4:	6121                	addi	sp,sp,64
    800065d6:	8082                	ret
	...

00000000800065e0 <kernelvec>:
    800065e0:	7111                	addi	sp,sp,-256
    800065e2:	e006                	sd	ra,0(sp)
    800065e4:	e40a                	sd	sp,8(sp)
    800065e6:	e80e                	sd	gp,16(sp)
    800065e8:	ec12                	sd	tp,24(sp)
    800065ea:	f016                	sd	t0,32(sp)
    800065ec:	f41a                	sd	t1,40(sp)
    800065ee:	f81e                	sd	t2,48(sp)
    800065f0:	fc22                	sd	s0,56(sp)
    800065f2:	e0a6                	sd	s1,64(sp)
    800065f4:	e4aa                	sd	a0,72(sp)
    800065f6:	e8ae                	sd	a1,80(sp)
    800065f8:	ecb2                	sd	a2,88(sp)
    800065fa:	f0b6                	sd	a3,96(sp)
    800065fc:	f4ba                	sd	a4,104(sp)
    800065fe:	f8be                	sd	a5,112(sp)
    80006600:	fcc2                	sd	a6,120(sp)
    80006602:	e146                	sd	a7,128(sp)
    80006604:	e54a                	sd	s2,136(sp)
    80006606:	e94e                	sd	s3,144(sp)
    80006608:	ed52                	sd	s4,152(sp)
    8000660a:	f156                	sd	s5,160(sp)
    8000660c:	f55a                	sd	s6,168(sp)
    8000660e:	f95e                	sd	s7,176(sp)
    80006610:	fd62                	sd	s8,184(sp)
    80006612:	e1e6                	sd	s9,192(sp)
    80006614:	e5ea                	sd	s10,200(sp)
    80006616:	e9ee                	sd	s11,208(sp)
    80006618:	edf2                	sd	t3,216(sp)
    8000661a:	f1f6                	sd	t4,224(sp)
    8000661c:	f5fa                	sd	t5,232(sp)
    8000661e:	f9fe                	sd	t6,240(sp)
    80006620:	b2ffc0ef          	jal	8000314e <kerneltrap>
    80006624:	6082                	ld	ra,0(sp)
    80006626:	6122                	ld	sp,8(sp)
    80006628:	61c2                	ld	gp,16(sp)
    8000662a:	7282                	ld	t0,32(sp)
    8000662c:	7322                	ld	t1,40(sp)
    8000662e:	73c2                	ld	t2,48(sp)
    80006630:	7462                	ld	s0,56(sp)
    80006632:	6486                	ld	s1,64(sp)
    80006634:	6526                	ld	a0,72(sp)
    80006636:	65c6                	ld	a1,80(sp)
    80006638:	6666                	ld	a2,88(sp)
    8000663a:	7686                	ld	a3,96(sp)
    8000663c:	7726                	ld	a4,104(sp)
    8000663e:	77c6                	ld	a5,112(sp)
    80006640:	7866                	ld	a6,120(sp)
    80006642:	688a                	ld	a7,128(sp)
    80006644:	692a                	ld	s2,136(sp)
    80006646:	69ca                	ld	s3,144(sp)
    80006648:	6a6a                	ld	s4,152(sp)
    8000664a:	7a8a                	ld	s5,160(sp)
    8000664c:	7b2a                	ld	s6,168(sp)
    8000664e:	7bca                	ld	s7,176(sp)
    80006650:	7c6a                	ld	s8,184(sp)
    80006652:	6c8e                	ld	s9,192(sp)
    80006654:	6d2e                	ld	s10,200(sp)
    80006656:	6dce                	ld	s11,208(sp)
    80006658:	6e6e                	ld	t3,216(sp)
    8000665a:	7e8e                	ld	t4,224(sp)
    8000665c:	7f2e                	ld	t5,232(sp)
    8000665e:	7fce                	ld	t6,240(sp)
    80006660:	6111                	addi	sp,sp,256
    80006662:	10200073          	sret
    80006666:	00000013          	nop
    8000666a:	00000013          	nop
    8000666e:	0001                	nop

0000000080006670 <timervec>:
    80006670:	34051573          	csrrw	a0,mscratch,a0
    80006674:	e10c                	sd	a1,0(a0)
    80006676:	e510                	sd	a2,8(a0)
    80006678:	e914                	sd	a3,16(a0)
    8000667a:	6d0c                	ld	a1,24(a0)
    8000667c:	7110                	ld	a2,32(a0)
    8000667e:	6194                	ld	a3,0(a1)
    80006680:	96b2                	add	a3,a3,a2
    80006682:	e194                	sd	a3,0(a1)
    80006684:	4589                	li	a1,2
    80006686:	14459073          	csrw	sip,a1
    8000668a:	6914                	ld	a3,16(a0)
    8000668c:	6510                	ld	a2,8(a0)
    8000668e:	610c                	ld	a1,0(a0)
    80006690:	34051573          	csrrw	a0,mscratch,a0
    80006694:	30200073          	mret
	...

000000008000669a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000669a:	1141                	addi	sp,sp,-16
    8000669c:	e422                	sd	s0,8(sp)
    8000669e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800066a0:	0c0007b7          	lui	a5,0xc000
    800066a4:	4705                	li	a4,1
    800066a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800066a8:	0c0007b7          	lui	a5,0xc000
    800066ac:	c3d8                	sw	a4,4(a5)
}
    800066ae:	6422                	ld	s0,8(sp)
    800066b0:	0141                	addi	sp,sp,16
    800066b2:	8082                	ret

00000000800066b4 <plicinithart>:

void
plicinithart(void)
{
    800066b4:	1141                	addi	sp,sp,-16
    800066b6:	e406                	sd	ra,8(sp)
    800066b8:	e022                	sd	s0,0(sp)
    800066ba:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800066bc:	ffffb097          	auipc	ra,0xffffb
    800066c0:	502080e7          	jalr	1282(ra) # 80001bbe <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800066c4:	0085171b          	slliw	a4,a0,0x8
    800066c8:	0c0027b7          	lui	a5,0xc002
    800066cc:	97ba                	add	a5,a5,a4
    800066ce:	40200713          	li	a4,1026
    800066d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800066d6:	00d5151b          	slliw	a0,a0,0xd
    800066da:	0c2017b7          	lui	a5,0xc201
    800066de:	97aa                	add	a5,a5,a0
    800066e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800066e4:	60a2                	ld	ra,8(sp)
    800066e6:	6402                	ld	s0,0(sp)
    800066e8:	0141                	addi	sp,sp,16
    800066ea:	8082                	ret

00000000800066ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800066ec:	1141                	addi	sp,sp,-16
    800066ee:	e406                	sd	ra,8(sp)
    800066f0:	e022                	sd	s0,0(sp)
    800066f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800066f4:	ffffb097          	auipc	ra,0xffffb
    800066f8:	4ca080e7          	jalr	1226(ra) # 80001bbe <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800066fc:	00d5151b          	slliw	a0,a0,0xd
    80006700:	0c2017b7          	lui	a5,0xc201
    80006704:	97aa                	add	a5,a5,a0
  return irq;
}
    80006706:	43c8                	lw	a0,4(a5)
    80006708:	60a2                	ld	ra,8(sp)
    8000670a:	6402                	ld	s0,0(sp)
    8000670c:	0141                	addi	sp,sp,16
    8000670e:	8082                	ret

0000000080006710 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006710:	1101                	addi	sp,sp,-32
    80006712:	ec06                	sd	ra,24(sp)
    80006714:	e822                	sd	s0,16(sp)
    80006716:	e426                	sd	s1,8(sp)
    80006718:	1000                	addi	s0,sp,32
    8000671a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000671c:	ffffb097          	auipc	ra,0xffffb
    80006720:	4a2080e7          	jalr	1186(ra) # 80001bbe <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006724:	00d5151b          	slliw	a0,a0,0xd
    80006728:	0c2017b7          	lui	a5,0xc201
    8000672c:	97aa                	add	a5,a5,a0
    8000672e:	c3c4                	sw	s1,4(a5)
}
    80006730:	60e2                	ld	ra,24(sp)
    80006732:	6442                	ld	s0,16(sp)
    80006734:	64a2                	ld	s1,8(sp)
    80006736:	6105                	addi	sp,sp,32
    80006738:	8082                	ret

000000008000673a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000673a:	1141                	addi	sp,sp,-16
    8000673c:	e406                	sd	ra,8(sp)
    8000673e:	e022                	sd	s0,0(sp)
    80006740:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006742:	479d                	li	a5,7
    80006744:	04a7cc63          	blt	a5,a0,8000679c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006748:	00026797          	auipc	a5,0x26
    8000674c:	39878793          	addi	a5,a5,920 # 8002cae0 <disk>
    80006750:	97aa                	add	a5,a5,a0
    80006752:	0187c783          	lbu	a5,24(a5)
    80006756:	ebb9                	bnez	a5,800067ac <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006758:	00451693          	slli	a3,a0,0x4
    8000675c:	00026797          	auipc	a5,0x26
    80006760:	38478793          	addi	a5,a5,900 # 8002cae0 <disk>
    80006764:	6398                	ld	a4,0(a5)
    80006766:	9736                	add	a4,a4,a3
    80006768:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000676c:	6398                	ld	a4,0(a5)
    8000676e:	9736                	add	a4,a4,a3
    80006770:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006774:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006778:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000677c:	97aa                	add	a5,a5,a0
    8000677e:	4705                	li	a4,1
    80006780:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006784:	00026517          	auipc	a0,0x26
    80006788:	37450513          	addi	a0,a0,884 # 8002caf8 <disk+0x18>
    8000678c:	ffffc097          	auipc	ra,0xffffc
    80006790:	eac080e7          	jalr	-340(ra) # 80002638 <wakeup>
}
    80006794:	60a2                	ld	ra,8(sp)
    80006796:	6402                	ld	s0,0(sp)
    80006798:	0141                	addi	sp,sp,16
    8000679a:	8082                	ret
    panic("free_desc 1");
    8000679c:	00002517          	auipc	a0,0x2
    800067a0:	eb450513          	addi	a0,a0,-332 # 80008650 <etext+0x650>
    800067a4:	ffffa097          	auipc	ra,0xffffa
    800067a8:	dbc080e7          	jalr	-580(ra) # 80000560 <panic>
    panic("free_desc 2");
    800067ac:	00002517          	auipc	a0,0x2
    800067b0:	eb450513          	addi	a0,a0,-332 # 80008660 <etext+0x660>
    800067b4:	ffffa097          	auipc	ra,0xffffa
    800067b8:	dac080e7          	jalr	-596(ra) # 80000560 <panic>

00000000800067bc <virtio_disk_init>:
{
    800067bc:	1101                	addi	sp,sp,-32
    800067be:	ec06                	sd	ra,24(sp)
    800067c0:	e822                	sd	s0,16(sp)
    800067c2:	e426                	sd	s1,8(sp)
    800067c4:	e04a                	sd	s2,0(sp)
    800067c6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800067c8:	00002597          	auipc	a1,0x2
    800067cc:	ea858593          	addi	a1,a1,-344 # 80008670 <etext+0x670>
    800067d0:	00026517          	auipc	a0,0x26
    800067d4:	43850513          	addi	a0,a0,1080 # 8002cc08 <disk+0x128>
    800067d8:	ffffa097          	auipc	ra,0xffffa
    800067dc:	3d0080e7          	jalr	976(ra) # 80000ba8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800067e0:	100017b7          	lui	a5,0x10001
    800067e4:	4398                	lw	a4,0(a5)
    800067e6:	2701                	sext.w	a4,a4
    800067e8:	747277b7          	lui	a5,0x74727
    800067ec:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800067f0:	18f71c63          	bne	a4,a5,80006988 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800067f4:	100017b7          	lui	a5,0x10001
    800067f8:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800067fa:	439c                	lw	a5,0(a5)
    800067fc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800067fe:	4709                	li	a4,2
    80006800:	18e79463          	bne	a5,a4,80006988 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006804:	100017b7          	lui	a5,0x10001
    80006808:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000680a:	439c                	lw	a5,0(a5)
    8000680c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000680e:	16e79d63          	bne	a5,a4,80006988 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006812:	100017b7          	lui	a5,0x10001
    80006816:	47d8                	lw	a4,12(a5)
    80006818:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000681a:	554d47b7          	lui	a5,0x554d4
    8000681e:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006822:	16f71363          	bne	a4,a5,80006988 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006826:	100017b7          	lui	a5,0x10001
    8000682a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000682e:	4705                	li	a4,1
    80006830:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006832:	470d                	li	a4,3
    80006834:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006836:	10001737          	lui	a4,0x10001
    8000683a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000683c:	c7ffe737          	lui	a4,0xc7ffe
    80006840:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd1b3f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006844:	8ef9                	and	a3,a3,a4
    80006846:	10001737          	lui	a4,0x10001
    8000684a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000684c:	472d                	li	a4,11
    8000684e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006850:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006854:	439c                	lw	a5,0(a5)
    80006856:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000685a:	8ba1                	andi	a5,a5,8
    8000685c:	12078e63          	beqz	a5,80006998 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006860:	100017b7          	lui	a5,0x10001
    80006864:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006868:	100017b7          	lui	a5,0x10001
    8000686c:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006870:	439c                	lw	a5,0(a5)
    80006872:	2781                	sext.w	a5,a5
    80006874:	12079a63          	bnez	a5,800069a8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006878:	100017b7          	lui	a5,0x10001
    8000687c:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006880:	439c                	lw	a5,0(a5)
    80006882:	2781                	sext.w	a5,a5
  if(max == 0)
    80006884:	12078a63          	beqz	a5,800069b8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80006888:	471d                	li	a4,7
    8000688a:	12f77f63          	bgeu	a4,a5,800069c8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000688e:	ffffa097          	auipc	ra,0xffffa
    80006892:	2ba080e7          	jalr	698(ra) # 80000b48 <kalloc>
    80006896:	00026497          	auipc	s1,0x26
    8000689a:	24a48493          	addi	s1,s1,586 # 8002cae0 <disk>
    8000689e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800068a0:	ffffa097          	auipc	ra,0xffffa
    800068a4:	2a8080e7          	jalr	680(ra) # 80000b48 <kalloc>
    800068a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800068aa:	ffffa097          	auipc	ra,0xffffa
    800068ae:	29e080e7          	jalr	670(ra) # 80000b48 <kalloc>
    800068b2:	87aa                	mv	a5,a0
    800068b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800068b6:	6088                	ld	a0,0(s1)
    800068b8:	12050063          	beqz	a0,800069d8 <virtio_disk_init+0x21c>
    800068bc:	00026717          	auipc	a4,0x26
    800068c0:	22c73703          	ld	a4,556(a4) # 8002cae8 <disk+0x8>
    800068c4:	10070a63          	beqz	a4,800069d8 <virtio_disk_init+0x21c>
    800068c8:	10078863          	beqz	a5,800069d8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800068cc:	6605                	lui	a2,0x1
    800068ce:	4581                	li	a1,0
    800068d0:	ffffa097          	auipc	ra,0xffffa
    800068d4:	464080e7          	jalr	1124(ra) # 80000d34 <memset>
  memset(disk.avail, 0, PGSIZE);
    800068d8:	00026497          	auipc	s1,0x26
    800068dc:	20848493          	addi	s1,s1,520 # 8002cae0 <disk>
    800068e0:	6605                	lui	a2,0x1
    800068e2:	4581                	li	a1,0
    800068e4:	6488                	ld	a0,8(s1)
    800068e6:	ffffa097          	auipc	ra,0xffffa
    800068ea:	44e080e7          	jalr	1102(ra) # 80000d34 <memset>
  memset(disk.used, 0, PGSIZE);
    800068ee:	6605                	lui	a2,0x1
    800068f0:	4581                	li	a1,0
    800068f2:	6888                	ld	a0,16(s1)
    800068f4:	ffffa097          	auipc	ra,0xffffa
    800068f8:	440080e7          	jalr	1088(ra) # 80000d34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800068fc:	100017b7          	lui	a5,0x10001
    80006900:	4721                	li	a4,8
    80006902:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006904:	4098                	lw	a4,0(s1)
    80006906:	100017b7          	lui	a5,0x10001
    8000690a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000690e:	40d8                	lw	a4,4(s1)
    80006910:	100017b7          	lui	a5,0x10001
    80006914:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006918:	649c                	ld	a5,8(s1)
    8000691a:	0007869b          	sext.w	a3,a5
    8000691e:	10001737          	lui	a4,0x10001
    80006922:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006926:	9781                	srai	a5,a5,0x20
    80006928:	10001737          	lui	a4,0x10001
    8000692c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006930:	689c                	ld	a5,16(s1)
    80006932:	0007869b          	sext.w	a3,a5
    80006936:	10001737          	lui	a4,0x10001
    8000693a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000693e:	9781                	srai	a5,a5,0x20
    80006940:	10001737          	lui	a4,0x10001
    80006944:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006948:	10001737          	lui	a4,0x10001
    8000694c:	4785                	li	a5,1
    8000694e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006950:	00f48c23          	sb	a5,24(s1)
    80006954:	00f48ca3          	sb	a5,25(s1)
    80006958:	00f48d23          	sb	a5,26(s1)
    8000695c:	00f48da3          	sb	a5,27(s1)
    80006960:	00f48e23          	sb	a5,28(s1)
    80006964:	00f48ea3          	sb	a5,29(s1)
    80006968:	00f48f23          	sb	a5,30(s1)
    8000696c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006970:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006974:	100017b7          	lui	a5,0x10001
    80006978:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000697c:	60e2                	ld	ra,24(sp)
    8000697e:	6442                	ld	s0,16(sp)
    80006980:	64a2                	ld	s1,8(sp)
    80006982:	6902                	ld	s2,0(sp)
    80006984:	6105                	addi	sp,sp,32
    80006986:	8082                	ret
    panic("could not find virtio disk");
    80006988:	00002517          	auipc	a0,0x2
    8000698c:	cf850513          	addi	a0,a0,-776 # 80008680 <etext+0x680>
    80006990:	ffffa097          	auipc	ra,0xffffa
    80006994:	bd0080e7          	jalr	-1072(ra) # 80000560 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006998:	00002517          	auipc	a0,0x2
    8000699c:	d0850513          	addi	a0,a0,-760 # 800086a0 <etext+0x6a0>
    800069a0:	ffffa097          	auipc	ra,0xffffa
    800069a4:	bc0080e7          	jalr	-1088(ra) # 80000560 <panic>
    panic("virtio disk should not be ready");
    800069a8:	00002517          	auipc	a0,0x2
    800069ac:	d1850513          	addi	a0,a0,-744 # 800086c0 <etext+0x6c0>
    800069b0:	ffffa097          	auipc	ra,0xffffa
    800069b4:	bb0080e7          	jalr	-1104(ra) # 80000560 <panic>
    panic("virtio disk has no queue 0");
    800069b8:	00002517          	auipc	a0,0x2
    800069bc:	d2850513          	addi	a0,a0,-728 # 800086e0 <etext+0x6e0>
    800069c0:	ffffa097          	auipc	ra,0xffffa
    800069c4:	ba0080e7          	jalr	-1120(ra) # 80000560 <panic>
    panic("virtio disk max queue too short");
    800069c8:	00002517          	auipc	a0,0x2
    800069cc:	d3850513          	addi	a0,a0,-712 # 80008700 <etext+0x700>
    800069d0:	ffffa097          	auipc	ra,0xffffa
    800069d4:	b90080e7          	jalr	-1136(ra) # 80000560 <panic>
    panic("virtio disk kalloc");
    800069d8:	00002517          	auipc	a0,0x2
    800069dc:	d4850513          	addi	a0,a0,-696 # 80008720 <etext+0x720>
    800069e0:	ffffa097          	auipc	ra,0xffffa
    800069e4:	b80080e7          	jalr	-1152(ra) # 80000560 <panic>

00000000800069e8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800069e8:	7159                	addi	sp,sp,-112
    800069ea:	f486                	sd	ra,104(sp)
    800069ec:	f0a2                	sd	s0,96(sp)
    800069ee:	eca6                	sd	s1,88(sp)
    800069f0:	e8ca                	sd	s2,80(sp)
    800069f2:	e4ce                	sd	s3,72(sp)
    800069f4:	e0d2                	sd	s4,64(sp)
    800069f6:	fc56                	sd	s5,56(sp)
    800069f8:	f85a                	sd	s6,48(sp)
    800069fa:	f45e                	sd	s7,40(sp)
    800069fc:	f062                	sd	s8,32(sp)
    800069fe:	ec66                	sd	s9,24(sp)
    80006a00:	1880                	addi	s0,sp,112
    80006a02:	8a2a                	mv	s4,a0
    80006a04:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006a06:	00c52c83          	lw	s9,12(a0)
    80006a0a:	001c9c9b          	slliw	s9,s9,0x1
    80006a0e:	1c82                	slli	s9,s9,0x20
    80006a10:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006a14:	00026517          	auipc	a0,0x26
    80006a18:	1f450513          	addi	a0,a0,500 # 8002cc08 <disk+0x128>
    80006a1c:	ffffa097          	auipc	ra,0xffffa
    80006a20:	21c080e7          	jalr	540(ra) # 80000c38 <acquire>
  for(int i = 0; i < 3; i++){
    80006a24:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006a26:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006a28:	00026b17          	auipc	s6,0x26
    80006a2c:	0b8b0b13          	addi	s6,s6,184 # 8002cae0 <disk>
  for(int i = 0; i < 3; i++){
    80006a30:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006a32:	00026c17          	auipc	s8,0x26
    80006a36:	1d6c0c13          	addi	s8,s8,470 # 8002cc08 <disk+0x128>
    80006a3a:	a0ad                	j	80006aa4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80006a3c:	00fb0733          	add	a4,s6,a5
    80006a40:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006a44:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006a46:	0207c563          	bltz	a5,80006a70 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80006a4a:	2905                	addiw	s2,s2,1
    80006a4c:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006a4e:	05590f63          	beq	s2,s5,80006aac <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006a52:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006a54:	00026717          	auipc	a4,0x26
    80006a58:	08c70713          	addi	a4,a4,140 # 8002cae0 <disk>
    80006a5c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006a5e:	01874683          	lbu	a3,24(a4)
    80006a62:	fee9                	bnez	a3,80006a3c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80006a64:	2785                	addiw	a5,a5,1
    80006a66:	0705                	addi	a4,a4,1
    80006a68:	fe979be3          	bne	a5,s1,80006a5e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80006a6c:	57fd                	li	a5,-1
    80006a6e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006a70:	03205163          	blez	s2,80006a92 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006a74:	f9042503          	lw	a0,-112(s0)
    80006a78:	00000097          	auipc	ra,0x0
    80006a7c:	cc2080e7          	jalr	-830(ra) # 8000673a <free_desc>
      for(int j = 0; j < i; j++)
    80006a80:	4785                	li	a5,1
    80006a82:	0127d863          	bge	a5,s2,80006a92 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80006a86:	f9442503          	lw	a0,-108(s0)
    80006a8a:	00000097          	auipc	ra,0x0
    80006a8e:	cb0080e7          	jalr	-848(ra) # 8000673a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006a92:	85e2                	mv	a1,s8
    80006a94:	00026517          	auipc	a0,0x26
    80006a98:	06450513          	addi	a0,a0,100 # 8002caf8 <disk+0x18>
    80006a9c:	ffffc097          	auipc	ra,0xffffc
    80006aa0:	b38080e7          	jalr	-1224(ra) # 800025d4 <sleep>
  for(int i = 0; i < 3; i++){
    80006aa4:	f9040613          	addi	a2,s0,-112
    80006aa8:	894e                	mv	s2,s3
    80006aaa:	b765                	j	80006a52 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006aac:	f9042503          	lw	a0,-112(s0)
    80006ab0:	00451693          	slli	a3,a0,0x4

  if(write)
    80006ab4:	00026797          	auipc	a5,0x26
    80006ab8:	02c78793          	addi	a5,a5,44 # 8002cae0 <disk>
    80006abc:	00a50713          	addi	a4,a0,10
    80006ac0:	0712                	slli	a4,a4,0x4
    80006ac2:	973e                	add	a4,a4,a5
    80006ac4:	01703633          	snez	a2,s7
    80006ac8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006aca:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006ace:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006ad2:	6398                	ld	a4,0(a5)
    80006ad4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ad6:	0a868613          	addi	a2,a3,168
    80006ada:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006adc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006ade:	6390                	ld	a2,0(a5)
    80006ae0:	00d605b3          	add	a1,a2,a3
    80006ae4:	4741                	li	a4,16
    80006ae6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006ae8:	4805                	li	a6,1
    80006aea:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006aee:	f9442703          	lw	a4,-108(s0)
    80006af2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006af6:	0712                	slli	a4,a4,0x4
    80006af8:	963a                	add	a2,a2,a4
    80006afa:	058a0593          	addi	a1,s4,88
    80006afe:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006b00:	0007b883          	ld	a7,0(a5)
    80006b04:	9746                	add	a4,a4,a7
    80006b06:	40000613          	li	a2,1024
    80006b0a:	c710                	sw	a2,8(a4)
  if(write)
    80006b0c:	001bb613          	seqz	a2,s7
    80006b10:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006b14:	00166613          	ori	a2,a2,1
    80006b18:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006b1c:	f9842583          	lw	a1,-104(s0)
    80006b20:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006b24:	00250613          	addi	a2,a0,2
    80006b28:	0612                	slli	a2,a2,0x4
    80006b2a:	963e                	add	a2,a2,a5
    80006b2c:	577d                	li	a4,-1
    80006b2e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006b32:	0592                	slli	a1,a1,0x4
    80006b34:	98ae                	add	a7,a7,a1
    80006b36:	03068713          	addi	a4,a3,48
    80006b3a:	973e                	add	a4,a4,a5
    80006b3c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006b40:	6398                	ld	a4,0(a5)
    80006b42:	972e                	add	a4,a4,a1
    80006b44:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006b48:	4689                	li	a3,2
    80006b4a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006b4e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006b52:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80006b56:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006b5a:	6794                	ld	a3,8(a5)
    80006b5c:	0026d703          	lhu	a4,2(a3)
    80006b60:	8b1d                	andi	a4,a4,7
    80006b62:	0706                	slli	a4,a4,0x1
    80006b64:	96ba                	add	a3,a3,a4
    80006b66:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006b6a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006b6e:	6798                	ld	a4,8(a5)
    80006b70:	00275783          	lhu	a5,2(a4)
    80006b74:	2785                	addiw	a5,a5,1
    80006b76:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006b7a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006b7e:	100017b7          	lui	a5,0x10001
    80006b82:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006b86:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006b8a:	00026917          	auipc	s2,0x26
    80006b8e:	07e90913          	addi	s2,s2,126 # 8002cc08 <disk+0x128>
  while(b->disk == 1) {
    80006b92:	4485                	li	s1,1
    80006b94:	01079c63          	bne	a5,a6,80006bac <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006b98:	85ca                	mv	a1,s2
    80006b9a:	8552                	mv	a0,s4
    80006b9c:	ffffc097          	auipc	ra,0xffffc
    80006ba0:	a38080e7          	jalr	-1480(ra) # 800025d4 <sleep>
  while(b->disk == 1) {
    80006ba4:	004a2783          	lw	a5,4(s4)
    80006ba8:	fe9788e3          	beq	a5,s1,80006b98 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006bac:	f9042903          	lw	s2,-112(s0)
    80006bb0:	00290713          	addi	a4,s2,2
    80006bb4:	0712                	slli	a4,a4,0x4
    80006bb6:	00026797          	auipc	a5,0x26
    80006bba:	f2a78793          	addi	a5,a5,-214 # 8002cae0 <disk>
    80006bbe:	97ba                	add	a5,a5,a4
    80006bc0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006bc4:	00026997          	auipc	s3,0x26
    80006bc8:	f1c98993          	addi	s3,s3,-228 # 8002cae0 <disk>
    80006bcc:	00491713          	slli	a4,s2,0x4
    80006bd0:	0009b783          	ld	a5,0(s3)
    80006bd4:	97ba                	add	a5,a5,a4
    80006bd6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006bda:	854a                	mv	a0,s2
    80006bdc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006be0:	00000097          	auipc	ra,0x0
    80006be4:	b5a080e7          	jalr	-1190(ra) # 8000673a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006be8:	8885                	andi	s1,s1,1
    80006bea:	f0ed                	bnez	s1,80006bcc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006bec:	00026517          	auipc	a0,0x26
    80006bf0:	01c50513          	addi	a0,a0,28 # 8002cc08 <disk+0x128>
    80006bf4:	ffffa097          	auipc	ra,0xffffa
    80006bf8:	0f8080e7          	jalr	248(ra) # 80000cec <release>
}
    80006bfc:	70a6                	ld	ra,104(sp)
    80006bfe:	7406                	ld	s0,96(sp)
    80006c00:	64e6                	ld	s1,88(sp)
    80006c02:	6946                	ld	s2,80(sp)
    80006c04:	69a6                	ld	s3,72(sp)
    80006c06:	6a06                	ld	s4,64(sp)
    80006c08:	7ae2                	ld	s5,56(sp)
    80006c0a:	7b42                	ld	s6,48(sp)
    80006c0c:	7ba2                	ld	s7,40(sp)
    80006c0e:	7c02                	ld	s8,32(sp)
    80006c10:	6ce2                	ld	s9,24(sp)
    80006c12:	6165                	addi	sp,sp,112
    80006c14:	8082                	ret

0000000080006c16 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006c16:	1101                	addi	sp,sp,-32
    80006c18:	ec06                	sd	ra,24(sp)
    80006c1a:	e822                	sd	s0,16(sp)
    80006c1c:	e426                	sd	s1,8(sp)
    80006c1e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006c20:	00026497          	auipc	s1,0x26
    80006c24:	ec048493          	addi	s1,s1,-320 # 8002cae0 <disk>
    80006c28:	00026517          	auipc	a0,0x26
    80006c2c:	fe050513          	addi	a0,a0,-32 # 8002cc08 <disk+0x128>
    80006c30:	ffffa097          	auipc	ra,0xffffa
    80006c34:	008080e7          	jalr	8(ra) # 80000c38 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006c38:	100017b7          	lui	a5,0x10001
    80006c3c:	53b8                	lw	a4,96(a5)
    80006c3e:	8b0d                	andi	a4,a4,3
    80006c40:	100017b7          	lui	a5,0x10001
    80006c44:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80006c46:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006c4a:	689c                	ld	a5,16(s1)
    80006c4c:	0204d703          	lhu	a4,32(s1)
    80006c50:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006c54:	04f70863          	beq	a4,a5,80006ca4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80006c58:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006c5c:	6898                	ld	a4,16(s1)
    80006c5e:	0204d783          	lhu	a5,32(s1)
    80006c62:	8b9d                	andi	a5,a5,7
    80006c64:	078e                	slli	a5,a5,0x3
    80006c66:	97ba                	add	a5,a5,a4
    80006c68:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006c6a:	00278713          	addi	a4,a5,2
    80006c6e:	0712                	slli	a4,a4,0x4
    80006c70:	9726                	add	a4,a4,s1
    80006c72:	01074703          	lbu	a4,16(a4)
    80006c76:	e721                	bnez	a4,80006cbe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006c78:	0789                	addi	a5,a5,2
    80006c7a:	0792                	slli	a5,a5,0x4
    80006c7c:	97a6                	add	a5,a5,s1
    80006c7e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006c80:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006c84:	ffffc097          	auipc	ra,0xffffc
    80006c88:	9b4080e7          	jalr	-1612(ra) # 80002638 <wakeup>

    disk.used_idx += 1;
    80006c8c:	0204d783          	lhu	a5,32(s1)
    80006c90:	2785                	addiw	a5,a5,1
    80006c92:	17c2                	slli	a5,a5,0x30
    80006c94:	93c1                	srli	a5,a5,0x30
    80006c96:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006c9a:	6898                	ld	a4,16(s1)
    80006c9c:	00275703          	lhu	a4,2(a4)
    80006ca0:	faf71ce3          	bne	a4,a5,80006c58 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006ca4:	00026517          	auipc	a0,0x26
    80006ca8:	f6450513          	addi	a0,a0,-156 # 8002cc08 <disk+0x128>
    80006cac:	ffffa097          	auipc	ra,0xffffa
    80006cb0:	040080e7          	jalr	64(ra) # 80000cec <release>
}
    80006cb4:	60e2                	ld	ra,24(sp)
    80006cb6:	6442                	ld	s0,16(sp)
    80006cb8:	64a2                	ld	s1,8(sp)
    80006cba:	6105                	addi	sp,sp,32
    80006cbc:	8082                	ret
      panic("virtio_disk_intr status");
    80006cbe:	00002517          	auipc	a0,0x2
    80006cc2:	a7a50513          	addi	a0,a0,-1414 # 80008738 <etext+0x738>
    80006cc6:	ffffa097          	auipc	ra,0xffffa
    80006cca:	89a080e7          	jalr	-1894(ra) # 80000560 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...

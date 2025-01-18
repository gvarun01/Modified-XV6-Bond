
user/_syscount:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
    "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open",
    "write", "mknod", "unlink", "link", "mkdir", "close", "waitx",
    "getSysCount" , "sigalarm", "sigreturn", "settickets"};

int main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f04a                	sd	s2,32(sp)
   8:	e852                	sd	s4,16(sp)
   a:	0080                	addi	s0,sp,64
    if (argc < 3)
   c:	4789                	li	a5,2
   e:	08a7de63          	bge	a5,a0,aa <main+0xaa>
  12:	8a2e                	mv	s4,a1
    {
        fprintf(2, "Usage: syscount <mask> command [args]\n");
        exit(1);
    }
    int mask = atoi(argv[1]);
  14:	6588                	ld	a0,8(a1)
  16:	00000097          	auipc	ra,0x0
  1a:	2bc080e7          	jalr	700(ra) # 2d2 <atoi>
    if (mask <= 0 || (mask & (mask - 1)) != 0)
  1e:	0aa05763          	blez	a0,cc <main+0xcc>
  22:	fff5091b          	addiw	s2,a0,-1
  26:	01257933          	and	s2,a0,s2
  2a:	2901                	sext.w	s2,s2
  2c:	0a091063          	bnez	s2,cc <main+0xcc>
  30:	f426                	sd	s1,40(sp)
    {
        printf("Invalid mask!!\n");
        return 0;
    }
    int k = -1;
    while (mask > 1)
  32:	4785                	li	a5,1
    int k = -1;
  34:	54fd                	li	s1,-1
    while (mask > 1)
  36:	4705                	li	a4,1
  38:	0aa7db63          	bge	a5,a0,ee <main+0xee>
  3c:	ec4e                	sd	s3,24(sp)
    {
        mask >>= 1;
  3e:	4015551b          	sraiw	a0,a0,0x1
        k++;
  42:	89a6                	mv	s3,s1
  44:	0014879b          	addiw	a5,s1,1
  48:	0007849b          	sext.w	s1,a5
    while (mask > 1)
  4c:	fea749e3          	blt	a4,a0,3e <main+0x3e>
    }
    if (k < 0 || k >= 26)
  50:	4765                	li	a4,25
  52:	08976d63          	bltu	a4,s1,ec <main+0xec>
  56:	e456                	sd	s5,8(sp)
    {
        printf("Invalid mask!!\n");
        return 0;
    }
    int pid = fork();
  58:	00000097          	auipc	ra,0x0
  5c:	36c080e7          	jalr	876(ra) # 3c4 <fork>
  60:	8aaa                	mv	s5,a0
    if (pid < 0)
  62:	0a054063          	bltz	a0,102 <main+0x102>
    {
        printf("fork");
        return -1;
    }
    else if (pid == 0)
  66:	c95d                	beqz	a0,11c <main+0x11c>
        printf("Exec failed");
        exit(1);
    }
    else
    {
        wait(0);
  68:	4501                	li	a0,0
  6a:	00000097          	auipc	ra,0x0
  6e:	36a080e7          	jalr	874(ra) # 3d4 <wait>
        printf("PID %d called %s %d times.\n", pid, syscall_names[k], getSysCount(k + 1));
  72:	048e                	slli	s1,s1,0x3
  74:	00001797          	auipc	a5,0x1
  78:	3ac78793          	addi	a5,a5,940 # 1420 <syscall_names>
  7c:	97a6                	add	a5,a5,s1
  7e:	6384                	ld	s1,0(a5)
  80:	0029851b          	addiw	a0,s3,2
  84:	00000097          	auipc	ra,0x0
  88:	3f0080e7          	jalr	1008(ra) # 474 <getSysCount>
  8c:	86aa                	mv	a3,a0
  8e:	8626                	mv	a2,s1
  90:	85d6                	mv	a1,s5
  92:	00001517          	auipc	a0,0x1
  96:	8d650513          	addi	a0,a0,-1834 # 968 <malloc+0x15c>
  9a:	00000097          	auipc	ra,0x0
  9e:	6ba080e7          	jalr	1722(ra) # 754 <printf>
  a2:	74a2                	ld	s1,40(sp)
  a4:	69e2                	ld	s3,24(sp)
  a6:	6aa2                	ld	s5,8(sp)
    }
    return 0;
  a8:	a81d                	j	de <main+0xde>
  aa:	f426                	sd	s1,40(sp)
  ac:	ec4e                	sd	s3,24(sp)
  ae:	e456                	sd	s5,8(sp)
        fprintf(2, "Usage: syscount <mask> command [args]\n");
  b0:	00001597          	auipc	a1,0x1
  b4:	86058593          	addi	a1,a1,-1952 # 910 <malloc+0x104>
  b8:	4509                	li	a0,2
  ba:	00000097          	auipc	ra,0x0
  be:	66c080e7          	jalr	1644(ra) # 726 <fprintf>
        exit(1);
  c2:	4505                	li	a0,1
  c4:	00000097          	auipc	ra,0x0
  c8:	308080e7          	jalr	776(ra) # 3cc <exit>
        printf("Invalid mask!!\n");
  cc:	00001517          	auipc	a0,0x1
  d0:	87450513          	addi	a0,a0,-1932 # 940 <malloc+0x134>
  d4:	00000097          	auipc	ra,0x0
  d8:	680080e7          	jalr	1664(ra) # 754 <printf>
        return 0;
  dc:	4901                	li	s2,0
  de:	854a                	mv	a0,s2
  e0:	70e2                	ld	ra,56(sp)
  e2:	7442                	ld	s0,48(sp)
  e4:	7902                	ld	s2,32(sp)
  e6:	6a42                	ld	s4,16(sp)
  e8:	6121                	addi	sp,sp,64
  ea:	8082                	ret
  ec:	69e2                	ld	s3,24(sp)
        printf("Invalid mask!!\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	85250513          	addi	a0,a0,-1966 # 940 <malloc+0x134>
  f6:	00000097          	auipc	ra,0x0
  fa:	65e080e7          	jalr	1630(ra) # 754 <printf>
        return 0;
  fe:	74a2                	ld	s1,40(sp)
 100:	bff9                	j	de <main+0xde>
        printf("fork");
 102:	00001517          	auipc	a0,0x1
 106:	84e50513          	addi	a0,a0,-1970 # 950 <malloc+0x144>
 10a:	00000097          	auipc	ra,0x0
 10e:	64a080e7          	jalr	1610(ra) # 754 <printf>
        return -1;
 112:	597d                	li	s2,-1
 114:	74a2                	ld	s1,40(sp)
 116:	69e2                	ld	s3,24(sp)
 118:	6aa2                	ld	s5,8(sp)
 11a:	b7d1                	j	de <main+0xde>
        exec(argv[2], argv + 2);
 11c:	010a0593          	addi	a1,s4,16
 120:	010a3503          	ld	a0,16(s4)
 124:	00000097          	auipc	ra,0x0
 128:	2e0080e7          	jalr	736(ra) # 404 <exec>
        printf("Exec failed");
 12c:	00001517          	auipc	a0,0x1
 130:	82c50513          	addi	a0,a0,-2004 # 958 <malloc+0x14c>
 134:	00000097          	auipc	ra,0x0
 138:	620080e7          	jalr	1568(ra) # 754 <printf>
        exit(1);
 13c:	4505                	li	a0,1
 13e:	00000097          	auipc	ra,0x0
 142:	28e080e7          	jalr	654(ra) # 3cc <exit>

0000000000000146 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 146:	1141                	addi	sp,sp,-16
 148:	e406                	sd	ra,8(sp)
 14a:	e022                	sd	s0,0(sp)
 14c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 14e:	00000097          	auipc	ra,0x0
 152:	eb2080e7          	jalr	-334(ra) # 0 <main>
  exit(0);
 156:	4501                	li	a0,0
 158:	00000097          	auipc	ra,0x0
 15c:	274080e7          	jalr	628(ra) # 3cc <exit>

0000000000000160 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 166:	87aa                	mv	a5,a0
 168:	0585                	addi	a1,a1,1
 16a:	0785                	addi	a5,a5,1
 16c:	fff5c703          	lbu	a4,-1(a1)
 170:	fee78fa3          	sb	a4,-1(a5)
 174:	fb75                	bnez	a4,168 <strcpy+0x8>
    ;
  return os;
}
 176:	6422                	ld	s0,8(sp)
 178:	0141                	addi	sp,sp,16
 17a:	8082                	ret

000000000000017c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17c:	1141                	addi	sp,sp,-16
 17e:	e422                	sd	s0,8(sp)
 180:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	cb91                	beqz	a5,19a <strcmp+0x1e>
 188:	0005c703          	lbu	a4,0(a1)
 18c:	00f71763          	bne	a4,a5,19a <strcmp+0x1e>
    p++, q++;
 190:	0505                	addi	a0,a0,1
 192:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	fbe5                	bnez	a5,188 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 19a:	0005c503          	lbu	a0,0(a1)
}
 19e:	40a7853b          	subw	a0,a5,a0
 1a2:	6422                	ld	s0,8(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <strlen>:

uint
strlen(const char *s)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	cf91                	beqz	a5,1ce <strlen+0x26>
 1b4:	0505                	addi	a0,a0,1
 1b6:	87aa                	mv	a5,a0
 1b8:	86be                	mv	a3,a5
 1ba:	0785                	addi	a5,a5,1
 1bc:	fff7c703          	lbu	a4,-1(a5)
 1c0:	ff65                	bnez	a4,1b8 <strlen+0x10>
 1c2:	40a6853b          	subw	a0,a3,a0
 1c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  for(n = 0; s[n]; n++)
 1ce:	4501                	li	a0,0
 1d0:	bfe5                	j	1c8 <strlen+0x20>

00000000000001d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e422                	sd	s0,8(sp)
 1d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d8:	ca19                	beqz	a2,1ee <memset+0x1c>
 1da:	87aa                	mv	a5,a0
 1dc:	1602                	slli	a2,a2,0x20
 1de:	9201                	srli	a2,a2,0x20
 1e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e8:	0785                	addi	a5,a5,1
 1ea:	fee79de3          	bne	a5,a4,1e4 <memset+0x12>
  }
  return dst;
}
 1ee:	6422                	ld	s0,8(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cb99                	beqz	a5,214 <strchr+0x20>
    if(*s == c)
 200:	00f58763          	beq	a1,a5,20e <strchr+0x1a>
  for(; *s; s++)
 204:	0505                	addi	a0,a0,1
 206:	00054783          	lbu	a5,0(a0)
 20a:	fbfd                	bnez	a5,200 <strchr+0xc>
      return (char*)s;
  return 0;
 20c:	4501                	li	a0,0
}
 20e:	6422                	ld	s0,8(sp)
 210:	0141                	addi	sp,sp,16
 212:	8082                	ret
  return 0;
 214:	4501                	li	a0,0
 216:	bfe5                	j	20e <strchr+0x1a>

0000000000000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	711d                	addi	sp,sp,-96
 21a:	ec86                	sd	ra,88(sp)
 21c:	e8a2                	sd	s0,80(sp)
 21e:	e4a6                	sd	s1,72(sp)
 220:	e0ca                	sd	s2,64(sp)
 222:	fc4e                	sd	s3,56(sp)
 224:	f852                	sd	s4,48(sp)
 226:	f456                	sd	s5,40(sp)
 228:	f05a                	sd	s6,32(sp)
 22a:	ec5e                	sd	s7,24(sp)
 22c:	1080                	addi	s0,sp,96
 22e:	8baa                	mv	s7,a0
 230:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 232:	892a                	mv	s2,a0
 234:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 236:	4aa9                	li	s5,10
 238:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 23a:	89a6                	mv	s3,s1
 23c:	2485                	addiw	s1,s1,1
 23e:	0344d863          	bge	s1,s4,26e <gets+0x56>
    cc = read(0, &c, 1);
 242:	4605                	li	a2,1
 244:	faf40593          	addi	a1,s0,-81
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	19a080e7          	jalr	410(ra) # 3e4 <read>
    if(cc < 1)
 252:	00a05e63          	blez	a0,26e <gets+0x56>
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	01578763          	beq	a5,s5,26c <gets+0x54>
 262:	0905                	addi	s2,s2,1
 264:	fd679be3          	bne	a5,s6,23a <gets+0x22>
    buf[i++] = c;
 268:	89a6                	mv	s3,s1
 26a:	a011                	j	26e <gets+0x56>
 26c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 26e:	99de                	add	s3,s3,s7
 270:	00098023          	sb	zero,0(s3)
  return buf;
}
 274:	855e                	mv	a0,s7
 276:	60e6                	ld	ra,88(sp)
 278:	6446                	ld	s0,80(sp)
 27a:	64a6                	ld	s1,72(sp)
 27c:	6906                	ld	s2,64(sp)
 27e:	79e2                	ld	s3,56(sp)
 280:	7a42                	ld	s4,48(sp)
 282:	7aa2                	ld	s5,40(sp)
 284:	7b02                	ld	s6,32(sp)
 286:	6be2                	ld	s7,24(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e04a                	sd	s2,0(sp)
 294:	1000                	addi	s0,sp,32
 296:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	00000097          	auipc	ra,0x0
 29e:	172080e7          	jalr	370(ra) # 40c <open>
  if(fd < 0)
 2a2:	02054663          	bltz	a0,2ce <stat+0x42>
 2a6:	e426                	sd	s1,8(sp)
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	178080e7          	jalr	376(ra) # 424 <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	13c080e7          	jalr	316(ra) # 3f4 <close>
  return r;
 2c0:	64a2                	ld	s1,8(sp)
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	597d                	li	s2,-1
 2d0:	bfcd                	j	2c2 <stat+0x36>

00000000000002d2 <atoi>:

int
atoi(const char *s)
{
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d8:	00054683          	lbu	a3,0(a0)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	4625                	li	a2,9
 2e6:	02f66863          	bltu	a2,a5,316 <atoi+0x44>
 2ea:	872a                	mv	a4,a0
  n = 0;
 2ec:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ee:	0705                	addi	a4,a4,1
 2f0:	0025179b          	slliw	a5,a0,0x2
 2f4:	9fa9                	addw	a5,a5,a0
 2f6:	0017979b          	slliw	a5,a5,0x1
 2fa:	9fb5                	addw	a5,a5,a3
 2fc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 300:	00074683          	lbu	a3,0(a4)
 304:	fd06879b          	addiw	a5,a3,-48
 308:	0ff7f793          	zext.b	a5,a5
 30c:	fef671e3          	bgeu	a2,a5,2ee <atoi+0x1c>
  return n;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  n = 0;
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <atoi+0x3e>

000000000000031a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 320:	02b57463          	bgeu	a0,a1,348 <memmove+0x2e>
    while(n-- > 0)
 324:	00c05f63          	blez	a2,342 <memmove+0x28>
 328:	1602                	slli	a2,a2,0x20
 32a:	9201                	srli	a2,a2,0x20
 32c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 330:	872a                	mv	a4,a0
      *dst++ = *src++;
 332:	0585                	addi	a1,a1,1
 334:	0705                	addi	a4,a4,1
 336:	fff5c683          	lbu	a3,-1(a1)
 33a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33e:	fef71ae3          	bne	a4,a5,332 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
    dst += n;
 348:	00c50733          	add	a4,a0,a2
    src += n;
 34c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34e:	fec05ae3          	blez	a2,342 <memmove+0x28>
 352:	fff6079b          	addiw	a5,a2,-1
 356:	1782                	slli	a5,a5,0x20
 358:	9381                	srli	a5,a5,0x20
 35a:	fff7c793          	not	a5,a5
 35e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 360:	15fd                	addi	a1,a1,-1
 362:	177d                	addi	a4,a4,-1
 364:	0005c683          	lbu	a3,0(a1)
 368:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36c:	fee79ae3          	bne	a5,a4,360 <memmove+0x46>
 370:	bfc9                	j	342 <memmove+0x28>

0000000000000372 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 378:	ca05                	beqz	a2,3a8 <memcmp+0x36>
 37a:	fff6069b          	addiw	a3,a2,-1
 37e:	1682                	slli	a3,a3,0x20
 380:	9281                	srli	a3,a3,0x20
 382:	0685                	addi	a3,a3,1
 384:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 386:	00054783          	lbu	a5,0(a0)
 38a:	0005c703          	lbu	a4,0(a1)
 38e:	00e79863          	bne	a5,a4,39e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 392:	0505                	addi	a0,a0,1
    p2++;
 394:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 396:	fed518e3          	bne	a0,a3,386 <memcmp+0x14>
  }
  return 0;
 39a:	4501                	li	a0,0
 39c:	a019                	j	3a2 <memcmp+0x30>
      return *p1 - *p2;
 39e:	40e7853b          	subw	a0,a5,a4
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <memcmp+0x30>

00000000000003ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b4:	00000097          	auipc	ra,0x0
 3b8:	f66080e7          	jalr	-154(ra) # 31a <memmove>
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c4:	4885                	li	a7,1
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3cc:	4889                	li	a7,2
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d4:	488d                	li	a7,3
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3dc:	4891                	li	a7,4
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <read>:
.global read
read:
 li a7, SYS_read
 3e4:	4895                	li	a7,5
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <write>:
.global write
write:
 li a7, SYS_write
 3ec:	48c1                	li	a7,16
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <close>:
.global close
close:
 li a7, SYS_close
 3f4:	48d5                	li	a7,21
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fc:	4899                	li	a7,6
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <exec>:
.global exec
exec:
 li a7, SYS_exec
 404:	489d                	li	a7,7
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <open>:
.global open
open:
 li a7, SYS_open
 40c:	48bd                	li	a7,15
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 414:	48c5                	li	a7,17
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41c:	48c9                	li	a7,18
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 424:	48a1                	li	a7,8
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <link>:
.global link
link:
 li a7, SYS_link
 42c:	48cd                	li	a7,19
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 434:	48d1                	li	a7,20
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43c:	48a5                	li	a7,9
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <dup>:
.global dup
dup:
 li a7, SYS_dup
 444:	48a9                	li	a7,10
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44c:	48ad                	li	a7,11
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 454:	48b1                	li	a7,12
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45c:	48b5                	li	a7,13
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 464:	48b9                	li	a7,14
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 46c:	48d9                	li	a7,22
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getSysCount>:
.global getSysCount
getSysCount:
 li a7, SYS_getSysCount
 474:	48dd                	li	a7,23
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 47c:	48e1                	li	a7,24
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 484:	48e5                	li	a7,25
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	f4e080e7          	jalr	-178(ra) # 3ec <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	0080                	addi	s0,sp,64
 4b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ba:	c299                	beqz	a3,4c0 <printint+0x12>
 4bc:	0805cb63          	bltz	a1,552 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c0:	2581                	sext.w	a1,a1
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	2601                	sext.w	a2,a2
 4cc:	00000517          	auipc	a0,0x0
 4d0:	60450513          	addi	a0,a0,1540 # ad0 <digits>
 4d4:	883a                	mv	a6,a4
 4d6:	2705                	addiw	a4,a4,1
 4d8:	02c5f7bb          	remuw	a5,a1,a2
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	97aa                	add	a5,a5,a0
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	0005879b          	sext.w	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	addi	a3,a3,1
 4f4:	fec7f0e3          	bgeu	a5,a2,4d4 <printint+0x26>
  if(neg)
 4f8:	00088c63          	beqz	a7,510 <printint+0x62>
    buf[i++] = '-';
 4fc:	fd070793          	addi	a5,a4,-48
 500:	00878733          	add	a4,a5,s0
 504:	02d00793          	li	a5,45
 508:	fef70823          	sb	a5,-16(a4)
 50c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 510:	02e05c63          	blez	a4,548 <printint+0x9a>
 514:	f04a                	sd	s2,32(sp)
 516:	ec4e                	sd	s3,24(sp)
 518:	fc040793          	addi	a5,s0,-64
 51c:	00e78933          	add	s2,a5,a4
 520:	fff78993          	addi	s3,a5,-1
 524:	99ba                	add	s3,s3,a4
 526:	377d                	addiw	a4,a4,-1
 528:	1702                	slli	a4,a4,0x20
 52a:	9301                	srli	a4,a4,0x20
 52c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 530:	fff94583          	lbu	a1,-1(s2)
 534:	8526                	mv	a0,s1
 536:	00000097          	auipc	ra,0x0
 53a:	f56080e7          	jalr	-170(ra) # 48c <putc>
  while(--i >= 0)
 53e:	197d                	addi	s2,s2,-1
 540:	ff3918e3          	bne	s2,s3,530 <printint+0x82>
 544:	7902                	ld	s2,32(sp)
 546:	69e2                	ld	s3,24(sp)
}
 548:	70e2                	ld	ra,56(sp)
 54a:	7442                	ld	s0,48(sp)
 54c:	74a2                	ld	s1,40(sp)
 54e:	6121                	addi	sp,sp,64
 550:	8082                	ret
    x = -xx;
 552:	40b005bb          	negw	a1,a1
    neg = 1;
 556:	4885                	li	a7,1
    x = -xx;
 558:	b7b5                	j	4c4 <printint+0x16>

000000000000055a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55a:	715d                	addi	sp,sp,-80
 55c:	e486                	sd	ra,72(sp)
 55e:	e0a2                	sd	s0,64(sp)
 560:	f84a                	sd	s2,48(sp)
 562:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 564:	0005c903          	lbu	s2,0(a1)
 568:	1a090a63          	beqz	s2,71c <vprintf+0x1c2>
 56c:	fc26                	sd	s1,56(sp)
 56e:	f44e                	sd	s3,40(sp)
 570:	f052                	sd	s4,32(sp)
 572:	ec56                	sd	s5,24(sp)
 574:	e85a                	sd	s6,16(sp)
 576:	e45e                	sd	s7,8(sp)
 578:	8aaa                	mv	s5,a0
 57a:	8bb2                	mv	s7,a2
 57c:	00158493          	addi	s1,a1,1
  state = 0;
 580:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 582:	02500a13          	li	s4,37
 586:	4b55                	li	s6,21
 588:	a839                	j	5a6 <vprintf+0x4c>
        putc(fd, c);
 58a:	85ca                	mv	a1,s2
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	efe080e7          	jalr	-258(ra) # 48c <putc>
 596:	a019                	j	59c <vprintf+0x42>
    } else if(state == '%'){
 598:	01498d63          	beq	s3,s4,5b2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 59c:	0485                	addi	s1,s1,1
 59e:	fff4c903          	lbu	s2,-1(s1)
 5a2:	16090763          	beqz	s2,710 <vprintf+0x1b6>
    if(state == 0){
 5a6:	fe0999e3          	bnez	s3,598 <vprintf+0x3e>
      if(c == '%'){
 5aa:	ff4910e3          	bne	s2,s4,58a <vprintf+0x30>
        state = '%';
 5ae:	89d2                	mv	s3,s4
 5b0:	b7f5                	j	59c <vprintf+0x42>
      if(c == 'd'){
 5b2:	13490463          	beq	s2,s4,6da <vprintf+0x180>
 5b6:	f9d9079b          	addiw	a5,s2,-99
 5ba:	0ff7f793          	zext.b	a5,a5
 5be:	12fb6763          	bltu	s6,a5,6ec <vprintf+0x192>
 5c2:	f9d9079b          	addiw	a5,s2,-99
 5c6:	0ff7f713          	zext.b	a4,a5
 5ca:	12eb6163          	bltu	s6,a4,6ec <vprintf+0x192>
 5ce:	00271793          	slli	a5,a4,0x2
 5d2:	00000717          	auipc	a4,0x0
 5d6:	4a670713          	addi	a4,a4,1190 # a78 <malloc+0x26c>
 5da:	97ba                	add	a5,a5,a4
 5dc:	439c                	lw	a5,0(a5)
 5de:	97ba                	add	a5,a5,a4
 5e0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	ebe080e7          	jalr	-322(ra) # 4ae <printint>
 5f8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b745                	j	59c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4681                	li	a3,0
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	ea2080e7          	jalr	-350(ra) # 4ae <printint>
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b751                	j	59c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000ba583          	lw	a1,0(s7)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e86080e7          	jalr	-378(ra) # 4ae <printint>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b7a5                	j	59c <vprintf+0x42>
 636:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 638:	008b8c13          	addi	s8,s7,8
 63c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 640:	03000593          	li	a1,48
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e46080e7          	jalr	-442(ra) # 48c <putc>
  putc(fd, 'x');
 64e:	07800593          	li	a1,120
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e38080e7          	jalr	-456(ra) # 48c <putc>
 65c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	472b8b93          	addi	s7,s7,1138 # ad0 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e1a080e7          	jalr	-486(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67a:	0992                	slli	s3,s3,0x4
 67c:	397d                	addiw	s2,s2,-1
 67e:	fe0914e3          	bnez	s2,666 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 682:	8be2                	mv	s7,s8
      state = 0;
 684:	4981                	li	s3,0
 686:	6c02                	ld	s8,0(sp)
 688:	bf11                	j	59c <vprintf+0x42>
        s = va_arg(ap, char*);
 68a:	008b8993          	addi	s3,s7,8
 68e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 692:	02090163          	beqz	s2,6b4 <vprintf+0x15a>
        while(*s != 0){
 696:	00094583          	lbu	a1,0(s2)
 69a:	c9a5                	beqz	a1,70a <vprintf+0x1b0>
          putc(fd, *s);
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dee080e7          	jalr	-530(ra) # 48c <putc>
          s++;
 6a6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a8:	00094583          	lbu	a1,0(s2)
 6ac:	f9e5                	bnez	a1,69c <vprintf+0x142>
        s = va_arg(ap, char*);
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b5ed                	j	59c <vprintf+0x42>
          s = "(null)";
 6b4:	00000917          	auipc	s2,0x0
 6b8:	3bc90913          	addi	s2,s2,956 # a70 <malloc+0x264>
        while(*s != 0){
 6bc:	02800593          	li	a1,40
 6c0:	bff1                	j	69c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	000bc583          	lbu	a1,0(s7)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dc0080e7          	jalr	-576(ra) # 48c <putc>
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b5d1                	j	59c <vprintf+0x42>
        putc(fd, c);
 6da:	02500593          	li	a1,37
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dac080e7          	jalr	-596(ra) # 48c <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd4d                	j	59c <vprintf+0x42>
        putc(fd, '%');
 6ec:	02500593          	li	a1,37
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	d9a080e7          	jalr	-614(ra) # 48c <putc>
        putc(fd, c);
 6fa:	85ca                	mv	a1,s2
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	d8e080e7          	jalr	-626(ra) # 48c <putc>
      state = 0;
 706:	4981                	li	s3,0
 708:	bd51                	j	59c <vprintf+0x42>
        s = va_arg(ap, char*);
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b579                	j	59c <vprintf+0x42>
 710:	74e2                	ld	s1,56(sp)
 712:	79a2                	ld	s3,40(sp)
 714:	7a02                	ld	s4,32(sp)
 716:	6ae2                	ld	s5,24(sp)
 718:	6b42                	ld	s6,16(sp)
 71a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 71c:	60a6                	ld	ra,72(sp)
 71e:	6406                	ld	s0,64(sp)
 720:	7942                	ld	s2,48(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	00000097          	auipc	ra,0x0
 748:	e16080e7          	jalr	-490(ra) # 55a <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6161                	addi	sp,sp,80
 752:	8082                	ret

0000000000000754 <printf>:

void
printf(const char *fmt, ...)
{
 754:	711d                	addi	sp,sp,-96
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e40c                	sd	a1,8(s0)
 75e:	e810                	sd	a2,16(s0)
 760:	ec14                	sd	a3,24(s0)
 762:	f018                	sd	a4,32(s0)
 764:	f41c                	sd	a5,40(s0)
 766:	03043823          	sd	a6,48(s0)
 76a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	00840613          	addi	a2,s0,8
 772:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 776:	85aa                	mv	a1,a0
 778:	4505                	li	a0,1
 77a:	00000097          	auipc	ra,0x0
 77e:	de0080e7          	jalr	-544(ra) # 55a <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78a:	1141                	addi	sp,sp,-16
 78c:	e422                	sd	s0,8(sp)
 78e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 790:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	00001797          	auipc	a5,0x1
 798:	d5c7b783          	ld	a5,-676(a5) # 14f0 <freep>
 79c:	a02d                	j	7c6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79e:	4618                	lw	a4,8(a2)
 7a0:	9f2d                	addw	a4,a4,a1
 7a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	6310                	ld	a2,0(a4)
 7aa:	a83d                	j	7e8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ac:	ff852703          	lw	a4,-8(a0)
 7b0:	9f31                	addw	a4,a4,a2
 7b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b4:	ff053683          	ld	a3,-16(a0)
 7b8:	a091                	j	7fc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x3a>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x4a>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x30>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60de3          	beq	a2,a4,79e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae68ae3          	beq	a3,a4,7ac <free+0x22>
    p->s.ptr = bp->s.ptr;
 7fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	cef73923          	sd	a5,-782(a4) # 14f0 <freep>
}
 806:	6422                	ld	s0,8(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f426                	sd	s1,40(sp)
 814:	ec4e                	sd	s3,24(sp)
 816:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	02051493          	slli	s1,a0,0x20
 81c:	9081                	srli	s1,s1,0x20
 81e:	04bd                	addi	s1,s1,15
 820:	8091                	srli	s1,s1,0x4
 822:	0014899b          	addiw	s3,s1,1
 826:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 828:	00001517          	auipc	a0,0x1
 82c:	cc853503          	ld	a0,-824(a0) # 14f0 <freep>
 830:	c915                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	08977e63          	bgeu	a4,s1,8d2 <malloc+0xc6>
 83a:	f04a                	sd	s2,32(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00001917          	auipc	s2,0x1
 85c:	c9890913          	addi	s2,s2,-872 # 14f0 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a091                	j	8a6 <malloc+0x9a>
 864:	f04a                	sd	s2,32(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86c:	00001797          	auipc	a5,0x1
 870:	c9478793          	addi	a5,a5,-876 # 1500 <base>
 874:	00001717          	auipc	a4,0x1
 878:	c6f73e23          	sd	a5,-900(a4) # 14f0 <freep>
 87c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 882:	b7c1                	j	842 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	a08d                	j	8ea <malloc+0xde>
  hp->s.size = nu;
 88a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	00000097          	auipc	ra,0x0
 894:	efa080e7          	jalr	-262(ra) # 78a <free>
  return freep;
 898:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89c:	c13d                	beqz	a0,902 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	02977463          	bgeu	a4,s1,8ca <malloc+0xbe>
    if(p == freep)
 8a6:	00093703          	ld	a4,0(s2)
 8aa:	853e                	mv	a0,a5
 8ac:	fef719e3          	bne	a4,a5,89e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	00000097          	auipc	ra,0x0
 8b6:	ba2080e7          	jalr	-1118(ra) # 454 <sbrk>
  if(p == (char*)-1)
 8ba:	fd5518e3          	bne	a0,s5,88a <malloc+0x7e>
        return 0;
 8be:	4501                	li	a0,0
 8c0:	7902                	ld	s2,32(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	a03d                	j	8f6 <malloc+0xea>
 8ca:	7902                	ld	s2,32(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d2:	fae489e3          	beq	s1,a4,884 <malloc+0x78>
        p->s.size -= nunits;
 8d6:	4137073b          	subw	a4,a4,s3
 8da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8dc:	02071693          	slli	a3,a4,0x20
 8e0:	01c6d713          	srli	a4,a3,0x1c
 8e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ea:	00001717          	auipc	a4,0x1
 8ee:	c0a73323          	sd	a0,-1018(a4) # 14f0 <freep>
      return (void*)(p + 1);
 8f2:	01078513          	addi	a0,a5,16
  }
}
 8f6:	70e2                	ld	ra,56(sp)
 8f8:	7442                	ld	s0,48(sp)
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6121                	addi	sp,sp,64
 900:	8082                	ret
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	b7f5                	j	8f6 <malloc+0xea>

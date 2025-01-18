
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c2c080e7          	jalr	-980(ra) # 5c3c <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c1a080e7          	jalr	-998(ra) # 5c3c <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	10250513          	addi	a0,a0,258 # 6140 <malloc+0x104>
      46:	00006097          	auipc	ra,0x6
      4a:	f3e080e7          	jalr	-194(ra) # 5f84 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bac080e7          	jalr	-1108(ra) # 5bfc <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000c797          	auipc	a5,0xc
      5c:	88078793          	addi	a5,a5,-1920 # b8d8 <uninit>
      60:	0000e697          	auipc	a3,0xe
      64:	f8868693          	addi	a3,a3,-120 # dfe8 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0e050513          	addi	a0,a0,224 # 6160 <malloc+0x124>
      88:	00006097          	auipc	ra,0x6
      8c:	efc080e7          	jalr	-260(ra) # 5f84 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b6a080e7          	jalr	-1174(ra) # 5bfc <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0d050513          	addi	a0,a0,208 # 6178 <malloc+0x13c>
      b0:	00006097          	auipc	ra,0x6
      b4:	b8c080e7          	jalr	-1140(ra) # 5c3c <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b68080e7          	jalr	-1176(ra) # 5c24 <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0d250513          	addi	a0,a0,210 # 6198 <malloc+0x15c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b6e080e7          	jalr	-1170(ra) # 5c3c <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	09a50513          	addi	a0,a0,154 # 6180 <malloc+0x144>
      ee:	00006097          	auipc	ra,0x6
      f2:	e96080e7          	jalr	-362(ra) # 5f84 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b04080e7          	jalr	-1276(ra) # 5bfc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0a650513          	addi	a0,a0,166 # 61a8 <malloc+0x16c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e7a080e7          	jalr	-390(ra) # 5f84 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ae8080e7          	jalr	-1304(ra) # 5bfc <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0a450513          	addi	a0,a0,164 # 61d0 <malloc+0x194>
     134:	00006097          	auipc	ra,0x6
     138:	b18080e7          	jalr	-1256(ra) # 5c4c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	09050513          	addi	a0,a0,144 # 61d0 <malloc+0x194>
     148:	00006097          	auipc	ra,0x6
     14c:	af4080e7          	jalr	-1292(ra) # 5c3c <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	08c58593          	addi	a1,a1,140 # 61e0 <malloc+0x1a4>
     15c:	00006097          	auipc	ra,0x6
     160:	ac0080e7          	jalr	-1344(ra) # 5c1c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	06850513          	addi	a0,a0,104 # 61d0 <malloc+0x194>
     170:	00006097          	auipc	ra,0x6
     174:	acc080e7          	jalr	-1332(ra) # 5c3c <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	06c58593          	addi	a1,a1,108 # 61e8 <malloc+0x1ac>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a96080e7          	jalr	-1386(ra) # 5c1c <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	03c50513          	addi	a0,a0,60 # 61d0 <malloc+0x194>
     19c:	00006097          	auipc	ra,0x6
     1a0:	ab0080e7          	jalr	-1360(ra) # 5c4c <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a7e080e7          	jalr	-1410(ra) # 5c24 <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a74080e7          	jalr	-1420(ra) # 5c24 <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	02650513          	addi	a0,a0,38 # 61f0 <malloc+0x1b4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	db2080e7          	jalr	-590(ra) # 5f84 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a20080e7          	jalr	-1504(ra) # 5bfc <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a2c080e7          	jalr	-1492(ra) # 5c3c <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a0c080e7          	jalr	-1524(ra) # 5c24 <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a06080e7          	jalr	-1530(ra) # 5c4c <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f9c50513          	addi	a0,a0,-100 # 6218 <malloc+0x1dc>
     284:	00006097          	auipc	ra,0x6
     288:	9c8080e7          	jalr	-1592(ra) # 5c4c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f88a8a93          	addi	s5,s5,-120 # 6218 <malloc+0x1dc>
      int cc = write(fd, buf, sz);
     298:	0000ea17          	auipc	s4,0xe
     29c:	d50a0a13          	addi	s4,s4,-688 # dfe8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <diskfull+0x21>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	990080e7          	jalr	-1648(ra) # 5c3c <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	95e080e7          	jalr	-1698(ra) # 5c1c <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	94a080e7          	jalr	-1718(ra) # 5c1c <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	944080e7          	jalr	-1724(ra) # 5c24 <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	962080e7          	jalr	-1694(ra) # 5c4c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f1650513          	addi	a0,a0,-234 # 6228 <malloc+0x1ec>
     31a:	00006097          	auipc	ra,0x6
     31e:	c6a080e7          	jalr	-918(ra) # 5f84 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8d8080e7          	jalr	-1832(ra) # 5bfc <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f1450513          	addi	a0,a0,-236 # 6248 <malloc+0x20c>
     33c:	00006097          	auipc	ra,0x6
     340:	c48080e7          	jalr	-952(ra) # 5f84 <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	8b6080e7          	jalr	-1866(ra) # 5bfc <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	addi	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f0250513          	addi	a0,a0,-254 # 6260 <malloc+0x224>
     366:	00006097          	auipc	ra,0x6
     36a:	8e6080e7          	jalr	-1818(ra) # 5c4c <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	eee98993          	addi	s3,s3,-274 # 6260 <malloc+0x224>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	8b6080e7          	jalr	-1866(ra) # 5c3c <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	884080e7          	jalr	-1916(ra) # 5c1c <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	882080e7          	jalr	-1918(ra) # 5c24 <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	8a0080e7          	jalr	-1888(ra) # 5c4c <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addiw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ea250513          	addi	a0,a0,-350 # 6260 <malloc+0x224>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	876080e7          	jalr	-1930(ra) # 5c3c <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e1258593          	addi	a1,a1,-494 # 61e8 <malloc+0x1ac>
     3de:	00006097          	auipc	ra,0x6
     3e2:	83e080e7          	jalr	-1986(ra) # 5c1c <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	e9450513          	addi	a0,a0,-364 # 6280 <malloc+0x244>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	b90080e7          	jalr	-1136(ra) # 5f84 <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00005097          	auipc	ra,0x5
     402:	7fe080e7          	jalr	2046(ra) # 5bfc <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e6250513          	addi	a0,a0,-414 # 6268 <malloc+0x22c>
     40e:	00006097          	auipc	ra,0x6
     412:	b76080e7          	jalr	-1162(ra) # 5f84 <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	7e4080e7          	jalr	2020(ra) # 5bfc <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e4850513          	addi	a0,a0,-440 # 6268 <malloc+0x22c>
     428:	00006097          	auipc	ra,0x6
     42c:	b5c080e7          	jalr	-1188(ra) # 5f84 <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	7ca080e7          	jalr	1994(ra) # 5bfc <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00005097          	auipc	ra,0x5
     440:	7e8080e7          	jalr	2024(ra) # 5c24 <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e1c50513          	addi	a0,a0,-484 # 6260 <malloc+0x224>
     44c:	00006097          	auipc	ra,0x6
     450:	800080e7          	jalr	-2048(ra) # 5c4c <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	7a6080e7          	jalr	1958(ra) # 5bfc <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraiw	a4,s1,0x1f
     482:	01b7571b          	srliw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraiw	a3,a5,0x5
     48e:	0306869b          	addiw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	andi	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addiw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	addi	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	7a2080e7          	jalr	1954(ra) # 5c4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	addi	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	782080e7          	jalr	1922(ra) # 5c3c <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	75e080e7          	jalr	1886(ra) # 5c24 <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addiw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraiw	a4,s1,0x1f
     4ea:	01b7571b          	srliw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraiw	a3,a5,0x5
     4f6:	0306869b          	addiw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	andi	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addiw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	addi	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	73a080e7          	jalr	1850(ra) # 5c4c <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addiw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	addi	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	addi	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	slli	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d40a0a13          	addi	s4,s4,-704 # 6290 <malloc+0x254>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	6da080e7          	jalr	1754(ra) # 5c3c <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	6a8080e7          	jalr	1704(ra) # 5c1c <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	6a2080e7          	jalr	1698(ra) # 5c24 <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	6c0080e7          	jalr	1728(ra) # 5c4c <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	682080e7          	jalr	1666(ra) # 5c1c <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	addi	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	662080e7          	jalr	1634(ra) # 5c0c <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	65e080e7          	jalr	1630(ra) # 5c1c <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	656080e7          	jalr	1622(ra) # 5c24 <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	64a080e7          	jalr	1610(ra) # 5c24 <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	addi	s2,s2,8
     5e4:	fd040793          	addi	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	addi	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	c9c50513          	addi	a0,a0,-868 # 6298 <malloc+0x25c>
     604:	00006097          	auipc	ra,0x6
     608:	980080e7          	jalr	-1664(ra) # 5f84 <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	5ee080e7          	jalr	1518(ra) # 5bfc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	c9650513          	addi	a0,a0,-874 # 62b0 <malloc+0x274>
     622:	00006097          	auipc	ra,0x6
     626:	962080e7          	jalr	-1694(ra) # 5f84 <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	5d0080e7          	jalr	1488(ra) # 5bfc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	ca850513          	addi	a0,a0,-856 # 62e0 <malloc+0x2a4>
     640:	00006097          	auipc	ra,0x6
     644:	944080e7          	jalr	-1724(ra) # 5f84 <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	5b2080e7          	jalr	1458(ra) # 5bfc <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	cbe50513          	addi	a0,a0,-834 # 6310 <malloc+0x2d4>
     65a:	00006097          	auipc	ra,0x6
     65e:	92a080e7          	jalr	-1750(ra) # 5f84 <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	598080e7          	jalr	1432(ra) # 5bfc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	cb050513          	addi	a0,a0,-848 # 6320 <malloc+0x2e4>
     678:	00006097          	auipc	ra,0x6
     67c:	90c080e7          	jalr	-1780(ra) # 5f84 <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	57a080e7          	jalr	1402(ra) # 5bfc <exit>

000000000000068a <copyout>:
{
     68a:	711d                	addi	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	slli	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	ca2a0a13          	addi	s4,s4,-862 # 6350 <malloc+0x314>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	b32a8a93          	addi	s5,s5,-1230 # 61e8 <malloc+0x1ac>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	576080e7          	jalr	1398(ra) # 5c3c <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	53c080e7          	jalr	1340(ra) # 5c14 <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	53e080e7          	jalr	1342(ra) # 5c24 <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	addi	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	51a080e7          	jalr	1306(ra) # 5c0c <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	516080e7          	jalr	1302(ra) # 5c1c <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	4f8080e7          	jalr	1272(ra) # 5c14 <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	4f8080e7          	jalr	1272(ra) # 5c24 <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	4ec080e7          	jalr	1260(ra) # 5c24 <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	addi	s2,s2,8
     742:	fc040793          	addi	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	addi	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	bfc50513          	addi	a0,a0,-1028 # 6358 <malloc+0x31c>
     764:	00006097          	auipc	ra,0x6
     768:	820080e7          	jalr	-2016(ra) # 5f84 <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	48e080e7          	jalr	1166(ra) # 5bfc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	bf650513          	addi	a0,a0,-1034 # 6370 <malloc+0x334>
     782:	00006097          	auipc	ra,0x6
     786:	802080e7          	jalr	-2046(ra) # 5f84 <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	470080e7          	jalr	1136(ra) # 5bfc <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	b7c50513          	addi	a0,a0,-1156 # 6310 <malloc+0x2d4>
     79c:	00005097          	auipc	ra,0x5
     7a0:	7e8080e7          	jalr	2024(ra) # 5f84 <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	456080e7          	jalr	1110(ra) # 5bfc <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	bf250513          	addi	a0,a0,-1038 # 63a0 <malloc+0x364>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	7ce080e7          	jalr	1998(ra) # 5f84 <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	43c080e7          	jalr	1084(ra) # 5bfc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	bec50513          	addi	a0,a0,-1044 # 63b8 <malloc+0x37c>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	7b0080e7          	jalr	1968(ra) # 5f84 <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	41e080e7          	jalr	1054(ra) # 5bfc <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	addi	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	addi	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	9d650513          	addi	a0,a0,-1578 # 61d0 <malloc+0x194>
     802:	00005097          	auipc	ra,0x5
     806:	44a080e7          	jalr	1098(ra) # 5c4c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	9c250513          	addi	a0,a0,-1598 # 61d0 <malloc+0x194>
     816:	00005097          	auipc	ra,0x5
     81a:	426080e7          	jalr	1062(ra) # 5c3c <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	9be58593          	addi	a1,a1,-1602 # 61e0 <malloc+0x1a4>
     82a:	00005097          	auipc	ra,0x5
     82e:	3f2080e7          	jalr	1010(ra) # 5c1c <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	3f0080e7          	jalr	1008(ra) # 5c24 <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	99250513          	addi	a0,a0,-1646 # 61d0 <malloc+0x194>
     846:	00005097          	auipc	ra,0x5
     84a:	3f6080e7          	jalr	1014(ra) # 5c3c <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	addi	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	3bc080e7          	jalr	956(ra) # 5c14 <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	96650513          	addi	a0,a0,-1690 # 61d0 <malloc+0x194>
     872:	00005097          	auipc	ra,0x5
     876:	3ca080e7          	jalr	970(ra) # 5c3c <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	95250513          	addi	a0,a0,-1710 # 61d0 <malloc+0x194>
     886:	00005097          	auipc	ra,0x5
     88a:	3b6080e7          	jalr	950(ra) # 5c3c <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	addi	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	37c080e7          	jalr	892(ra) # 5c14 <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	addi	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	366080e7          	jalr	870(ra) # 5c14 <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	b8c58593          	addi	a1,a1,-1140 # 6448 <malloc+0x40c>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	356080e7          	jalr	854(ra) # 5c1c <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	addi	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	33c080e7          	jalr	828(ra) # 5c14 <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	addi	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	324080e7          	jalr	804(ra) # 5c14 <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	8d250513          	addi	a0,a0,-1838 # 61d0 <malloc+0x194>
     906:	00005097          	auipc	ra,0x5
     90a:	346080e7          	jalr	838(ra) # 5c4c <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	314080e7          	jalr	788(ra) # 5c24 <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	30a080e7          	jalr	778(ra) # 5c24 <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	300080e7          	jalr	768(ra) # 5c24 <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	addi	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	aa650513          	addi	a0,a0,-1370 # 63e8 <malloc+0x3ac>
     94a:	00005097          	auipc	ra,0x5
     94e:	63a080e7          	jalr	1594(ra) # 5f84 <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	2a8080e7          	jalr	680(ra) # 5bfc <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	aaa50513          	addi	a0,a0,-1366 # 6408 <malloc+0x3cc>
     966:	00005097          	auipc	ra,0x5
     96a:	61e080e7          	jalr	1566(ra) # 5f84 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	aa650513          	addi	a0,a0,-1370 # 6418 <malloc+0x3dc>
     97a:	00005097          	auipc	ra,0x5
     97e:	60a080e7          	jalr	1546(ra) # 5f84 <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	278080e7          	jalr	632(ra) # 5bfc <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	aaa50513          	addi	a0,a0,-1366 # 6438 <malloc+0x3fc>
     996:	00005097          	auipc	ra,0x5
     99a:	5ee080e7          	jalr	1518(ra) # 5f84 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a7650513          	addi	a0,a0,-1418 # 6418 <malloc+0x3dc>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	5da080e7          	jalr	1498(ra) # 5f84 <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	248080e7          	jalr	584(ra) # 5bfc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	a9050513          	addi	a0,a0,-1392 # 6450 <malloc+0x414>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	5bc080e7          	jalr	1468(ra) # 5f84 <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	22a080e7          	jalr	554(ra) # 5bfc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	a9250513          	addi	a0,a0,-1390 # 6470 <malloc+0x434>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	59e080e7          	jalr	1438(ra) # 5f84 <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	20c080e7          	jalr	524(ra) # 5bfc <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	addi	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	addi	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	a7e50513          	addi	a0,a0,-1410 # 6490 <malloc+0x454>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	222080e7          	jalr	546(ra) # 5c3c <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	a8e98993          	addi	s3,s3,-1394 # 64b8 <malloc+0x47c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	abea8a93          	addi	s5,s5,-1346 # 64f0 <malloc+0x4b4>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	1d8080e7          	jalr	472(ra) # 5c1c <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	1c4080e7          	jalr	452(ra) # 5c1c <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	1b6080e7          	jalr	438(ra) # 5c24 <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	a1850513          	addi	a0,a0,-1512 # 6490 <malloc+0x454>
     a80:	00005097          	auipc	ra,0x5
     a84:	1bc080e7          	jalr	444(ra) # 5c3c <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000d597          	auipc	a1,0xd
     a96:	55658593          	addi	a1,a1,1366 # dfe8 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	17a080e7          	jalr	378(ra) # 5c14 <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	178080e7          	jalr	376(ra) # 5c24 <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	9dc50513          	addi	a0,a0,-1572 # 6490 <malloc+0x454>
     abc:	00005097          	auipc	ra,0x5
     ac0:	190080e7          	jalr	400(ra) # 5c4c <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	addi	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	9ba50513          	addi	a0,a0,-1606 # 6498 <malloc+0x45c>
     ae6:	00005097          	auipc	ra,0x5
     aea:	49e080e7          	jalr	1182(ra) # 5f84 <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	10c080e7          	jalr	268(ra) # 5bfc <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	9cc50513          	addi	a0,a0,-1588 # 64c8 <malloc+0x48c>
     b04:	00005097          	auipc	ra,0x5
     b08:	480080e7          	jalr	1152(ra) # 5f84 <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	0ee080e7          	jalr	238(ra) # 5bfc <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	9e650513          	addi	a0,a0,-1562 # 6500 <malloc+0x4c4>
     b22:	00005097          	auipc	ra,0x5
     b26:	462080e7          	jalr	1122(ra) # 5f84 <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	0d0080e7          	jalr	208(ra) # 5bfc <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	9f250513          	addi	a0,a0,-1550 # 6528 <malloc+0x4ec>
     b3e:	00005097          	auipc	ra,0x5
     b42:	446080e7          	jalr	1094(ra) # 5f84 <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	0b4080e7          	jalr	180(ra) # 5bfc <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	9f650513          	addi	a0,a0,-1546 # 6548 <malloc+0x50c>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	42a080e7          	jalr	1066(ra) # 5f84 <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	098080e7          	jalr	152(ra) # 5bfc <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	9f250513          	addi	a0,a0,-1550 # 6560 <malloc+0x524>
     b76:	00005097          	auipc	ra,0x5
     b7a:	40e080e7          	jalr	1038(ra) # 5f84 <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	07c080e7          	jalr	124(ra) # 5bfc <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	addi	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	addi	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	9e050513          	addi	a0,a0,-1568 # 6580 <malloc+0x544>
     ba8:	00005097          	auipc	ra,0x5
     bac:	094080e7          	jalr	148(ra) # 5c3c <open>
     bb0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb4:	0000d917          	auipc	s2,0xd
     bb8:	43490913          	addi	s2,s2,1076 # dfe8 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbc:	10c00a13          	li	s4,268
  if(fd < 0){
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	04c080e7          	jalr	76(ra) # 5c1c <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be0:	2485                	addiw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	03c080e7          	jalr	60(ra) # 5c24 <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	98e50513          	addi	a0,a0,-1650 # 6580 <malloc+0x544>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	042080e7          	jalr	66(ra) # 5c3c <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000d917          	auipc	s2,0xd
     c0a:	3e290913          	addi	s2,s2,994 # dfe8 <buf>
  if(fd < 0){
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	ffa080e7          	jalr	-6(ra) # 5c14 <read>
    if(i == 0){
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if(i != BSIZE){
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	94e50513          	addi	a0,a0,-1714 # 6588 <malloc+0x54c>
     c42:	00005097          	auipc	ra,0x5
     c46:	342080e7          	jalr	834(ra) # 5f84 <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	fb0080e7          	jalr	-80(ra) # 5bfc <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	95050513          	addi	a0,a0,-1712 # 65a8 <malloc+0x56c>
     c60:	00005097          	auipc	ra,0x5
     c64:	324080e7          	jalr	804(ra) # 5f84 <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	f92080e7          	jalr	-110(ra) # 5bfc <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	95c50513          	addi	a0,a0,-1700 # 65d0 <malloc+0x594>
     c7c:	00005097          	auipc	ra,0x5
     c80:	308080e7          	jalr	776(ra) # 5f84 <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f76080e7          	jalr	-138(ra) # 5bfc <exit>
      if(n == MAXFILE - 1){
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	f8c080e7          	jalr	-116(ra) # 5c24 <close>
  if(unlink("big") < 0){
     ca0:	00006517          	auipc	a0,0x6
     ca4:	8e050513          	addi	a0,a0,-1824 # 6580 <malloc+0x544>
     ca8:	00005097          	auipc	ra,0x5
     cac:	fa4080e7          	jalr	-92(ra) # 5c4c <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	addi	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	92450513          	addi	a0,a0,-1756 # 65f0 <malloc+0x5b4>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	2b0080e7          	jalr	688(ra) # 5f84 <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	f1e080e7          	jalr	-226(ra) # 5bfc <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	92e50513          	addi	a0,a0,-1746 # 6618 <malloc+0x5dc>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	292080e7          	jalr	658(ra) # 5f84 <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	f00080e7          	jalr	-256(ra) # 5bfc <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	92850513          	addi	a0,a0,-1752 # 6630 <malloc+0x5f4>
     d10:	00005097          	auipc	ra,0x5
     d14:	274080e7          	jalr	628(ra) # 5f84 <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	ee2080e7          	jalr	-286(ra) # 5bfc <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	93450513          	addi	a0,a0,-1740 # 6658 <malloc+0x61c>
     d2c:	00005097          	auipc	ra,0x5
     d30:	258080e7          	jalr	600(ra) # 5f84 <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	ec6080e7          	jalr	-314(ra) # 5bfc <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	addi	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	addi	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	91e50513          	addi	a0,a0,-1762 # 6670 <malloc+0x634>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	ee2080e7          	jalr	-286(ra) # 5c3c <open>
  if(fd < 0){
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	93658593          	addi	a1,a1,-1738 # 66a0 <malloc+0x664>
     d72:	00005097          	auipc	ra,0x5
     d76:	eaa080e7          	jalr	-342(ra) # 5c1c <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	ea8080e7          	jalr	-344(ra) # 5c24 <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	8ea50513          	addi	a0,a0,-1814 # 6670 <malloc+0x634>
     d8e:	00005097          	auipc	ra,0x5
     d92:	eae080e7          	jalr	-338(ra) # 5c3c <open>
     d96:	84aa                	mv	s1,a0
  if(fd < 0){
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9c:	00006517          	auipc	a0,0x6
     da0:	8d450513          	addi	a0,a0,-1836 # 6670 <malloc+0x634>
     da4:	00005097          	auipc	ra,0x5
     da8:	ea8080e7          	jalr	-344(ra) # 5c4c <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	8be50513          	addi	a0,a0,-1858 # 6670 <malloc+0x634>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e82080e7          	jalr	-382(ra) # 5c3c <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	92258593          	addi	a1,a1,-1758 # 66e8 <malloc+0x6ac>
     dce:	00005097          	auipc	ra,0x5
     dd2:	e4e080e7          	jalr	-434(ra) # 5c1c <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	e4c080e7          	jalr	-436(ra) # 5c24 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000d597          	auipc	a1,0xd
     de6:	20658593          	addi	a1,a1,518 # dfe8 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	e28080e7          	jalr	-472(ra) # 5c14 <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfa:	0000d717          	auipc	a4,0xd
     dfe:	1ee74703          	lbu	a4,494(a4) # dfe8 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0a:	4629                	li	a2,10
     e0c:	0000d597          	auipc	a1,0xd
     e10:	1dc58593          	addi	a1,a1,476 # dfe8 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	e06080e7          	jalr	-506(ra) # 5c1c <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	dfe080e7          	jalr	-514(ra) # 5c24 <close>
  unlink("unlinkread");
     e2e:	00006517          	auipc	a0,0x6
     e32:	84250513          	addi	a0,a0,-1982 # 6670 <malloc+0x634>
     e36:	00005097          	auipc	ra,0x5
     e3a:	e16080e7          	jalr	-490(ra) # 5c4c <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00006517          	auipc	a0,0x6
     e52:	83250513          	addi	a0,a0,-1998 # 6680 <malloc+0x644>
     e56:	00005097          	auipc	ra,0x5
     e5a:	12e080e7          	jalr	302(ra) # 5f84 <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	d9c080e7          	jalr	-612(ra) # 5bfc <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00006517          	auipc	a0,0x6
     e6e:	83e50513          	addi	a0,a0,-1986 # 66a8 <malloc+0x66c>
     e72:	00005097          	auipc	ra,0x5
     e76:	112080e7          	jalr	274(ra) # 5f84 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d80080e7          	jalr	-640(ra) # 5bfc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00006517          	auipc	a0,0x6
     e8a:	84250513          	addi	a0,a0,-1982 # 66c8 <malloc+0x68c>
     e8e:	00005097          	auipc	ra,0x5
     e92:	0f6080e7          	jalr	246(ra) # 5f84 <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	d64080e7          	jalr	-668(ra) # 5bfc <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00006517          	auipc	a0,0x6
     ea6:	84e50513          	addi	a0,a0,-1970 # 66f0 <malloc+0x6b4>
     eaa:	00005097          	auipc	ra,0x5
     eae:	0da080e7          	jalr	218(ra) # 5f84 <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	d48080e7          	jalr	-696(ra) # 5bfc <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00006517          	auipc	a0,0x6
     ec2:	85250513          	addi	a0,a0,-1966 # 6710 <malloc+0x6d4>
     ec6:	00005097          	auipc	ra,0x5
     eca:	0be080e7          	jalr	190(ra) # 5f84 <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	d2c080e7          	jalr	-724(ra) # 5bfc <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00006517          	auipc	a0,0x6
     ede:	85650513          	addi	a0,a0,-1962 # 6730 <malloc+0x6f4>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	0a2080e7          	jalr	162(ra) # 5f84 <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	d10080e7          	jalr	-752(ra) # 5bfc <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	addi	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00006517          	auipc	a0,0x6
     f06:	84e50513          	addi	a0,a0,-1970 # 6750 <malloc+0x714>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	d42080e7          	jalr	-702(ra) # 5c4c <unlink>
  unlink("lf2");
     f12:	00006517          	auipc	a0,0x6
     f16:	84650513          	addi	a0,a0,-1978 # 6758 <malloc+0x71c>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	d32080e7          	jalr	-718(ra) # 5c4c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00006517          	auipc	a0,0x6
     f2a:	82a50513          	addi	a0,a0,-2006 # 6750 <malloc+0x714>
     f2e:	00005097          	auipc	ra,0x5
     f32:	d0e080e7          	jalr	-754(ra) # 5c3c <open>
  if(fd < 0){
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	76258593          	addi	a1,a1,1890 # 66a0 <malloc+0x664>
     f46:	00005097          	auipc	ra,0x5
     f4a:	cd6080e7          	jalr	-810(ra) # 5c1c <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	cce080e7          	jalr	-818(ra) # 5c24 <close>
  if(link("lf1", "lf2") < 0){
     f5e:	00005597          	auipc	a1,0x5
     f62:	7fa58593          	addi	a1,a1,2042 # 6758 <malloc+0x71c>
     f66:	00005517          	auipc	a0,0x5
     f6a:	7ea50513          	addi	a0,a0,2026 # 6750 <malloc+0x714>
     f6e:	00005097          	auipc	ra,0x5
     f72:	cee080e7          	jalr	-786(ra) # 5c5c <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	7d650513          	addi	a0,a0,2006 # 6750 <malloc+0x714>
     f82:	00005097          	auipc	ra,0x5
     f86:	cca080e7          	jalr	-822(ra) # 5c4c <unlink>
  if(open("lf1", 0) >= 0){
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	7c450513          	addi	a0,a0,1988 # 6750 <malloc+0x714>
     f94:	00005097          	auipc	ra,0x5
     f98:	ca8080e7          	jalr	-856(ra) # 5c3c <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	7b650513          	addi	a0,a0,1974 # 6758 <malloc+0x71c>
     faa:	00005097          	auipc	ra,0x5
     fae:	c92080e7          	jalr	-878(ra) # 5c3c <open>
     fb2:	84aa                	mv	s1,a0
  if(fd < 0){
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fb8:	660d                	lui	a2,0x3
     fba:	0000d597          	auipc	a1,0xd
     fbe:	02e58593          	addi	a1,a1,46 # dfe8 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	c52080e7          	jalr	-942(ra) # 5c14 <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	c52080e7          	jalr	-942(ra) # 5c24 <close>
  if(link("lf2", "lf2") >= 0){
     fda:	00005597          	auipc	a1,0x5
     fde:	77e58593          	addi	a1,a1,1918 # 6758 <malloc+0x71c>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c78080e7          	jalr	-904(ra) # 5c5c <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	76850513          	addi	a0,a0,1896 # 6758 <malloc+0x71c>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	c54080e7          	jalr	-940(ra) # 5c4c <unlink>
  if(link("lf2", "lf1") >= 0){
    1000:	00005597          	auipc	a1,0x5
    1004:	75058593          	addi	a1,a1,1872 # 6750 <malloc+0x714>
    1008:	00005517          	auipc	a0,0x5
    100c:	75050513          	addi	a0,a0,1872 # 6758 <malloc+0x71c>
    1010:	00005097          	auipc	ra,0x5
    1014:	c4c080e7          	jalr	-948(ra) # 5c5c <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101c:	00005597          	auipc	a1,0x5
    1020:	73458593          	addi	a1,a1,1844 # 6750 <malloc+0x714>
    1024:	00006517          	auipc	a0,0x6
    1028:	83c50513          	addi	a0,a0,-1988 # 6860 <malloc+0x824>
    102c:	00005097          	auipc	ra,0x5
    1030:	c30080e7          	jalr	-976(ra) # 5c5c <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	addi	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	71a50513          	addi	a0,a0,1818 # 6760 <malloc+0x724>
    104e:	00005097          	auipc	ra,0x5
    1052:	f36080e7          	jalr	-202(ra) # 5f84 <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	ba4080e7          	jalr	-1116(ra) # 5bfc <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	71650513          	addi	a0,a0,1814 # 6778 <malloc+0x73c>
    106a:	00005097          	auipc	ra,0x5
    106e:	f1a080e7          	jalr	-230(ra) # 5f84 <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	b88080e7          	jalr	-1144(ra) # 5bfc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	71250513          	addi	a0,a0,1810 # 6790 <malloc+0x754>
    1086:	00005097          	auipc	ra,0x5
    108a:	efe080e7          	jalr	-258(ra) # 5f84 <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	b6c080e7          	jalr	-1172(ra) # 5bfc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	71650513          	addi	a0,a0,1814 # 67b0 <malloc+0x774>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	ee2080e7          	jalr	-286(ra) # 5f84 <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	b50080e7          	jalr	-1200(ra) # 5bfc <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	72a50513          	addi	a0,a0,1834 # 67e0 <malloc+0x7a4>
    10be:	00005097          	auipc	ra,0x5
    10c2:	ec6080e7          	jalr	-314(ra) # 5f84 <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	b34080e7          	jalr	-1228(ra) # 5bfc <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	72650513          	addi	a0,a0,1830 # 67f8 <malloc+0x7bc>
    10da:	00005097          	auipc	ra,0x5
    10de:	eaa080e7          	jalr	-342(ra) # 5f84 <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	b18080e7          	jalr	-1256(ra) # 5bfc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	72250513          	addi	a0,a0,1826 # 6810 <malloc+0x7d4>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	e8e080e7          	jalr	-370(ra) # 5f84 <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	afc080e7          	jalr	-1284(ra) # 5bfc <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	72e50513          	addi	a0,a0,1838 # 6838 <malloc+0x7fc>
    1112:	00005097          	auipc	ra,0x5
    1116:	e72080e7          	jalr	-398(ra) # 5f84 <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	ae0080e7          	jalr	-1312(ra) # 5bfc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	74250513          	addi	a0,a0,1858 # 6868 <malloc+0x82c>
    112e:	00005097          	auipc	ra,0x5
    1132:	e56080e7          	jalr	-426(ra) # 5f84 <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	ac4080e7          	jalr	-1340(ra) # 5bfc <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	addi	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	addi	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1156:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1158:	00005997          	auipc	s3,0x5
    115c:	73098993          	addi	s3,s3,1840 # 6888 <malloc+0x84c>
    1160:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	af0080e7          	jalr	-1296(ra) # 5c5c <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	addi	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	70450513          	addi	a0,a0,1796 # 6898 <malloc+0x85c>
    119c:	00005097          	auipc	ra,0x5
    11a0:	de8080e7          	jalr	-536(ra) # 5f84 <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	a56080e7          	jalr	-1450(ra) # 5bfc <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	addi	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	addi	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	6f450513          	addi	a0,a0,1780 # 68b8 <malloc+0x87c>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	a80080e7          	jalr	-1408(ra) # 5c4c <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	6e050513          	addi	a0,a0,1760 # 68b8 <malloc+0x87c>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	a5c080e7          	jalr	-1444(ra) # 5c3c <open>
  if(fd < 0){
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	a38080e7          	jalr	-1480(ra) # 5c24 <close>
  for(i = 0; i < N; i++){
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	6bea0a13          	addi	s4,s4,1726 # 68b8 <malloc+0x87c>
  for(i = 0; i < N; i++){
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraiw	a4,s2,0x1f
    120e:	01a7571b          	srliw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraiw	a3,a5,0x6
    121a:	0306869b          	addiw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	andi	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addiw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1234:	fb040593          	addi	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	a22080e7          	jalr	-1502(ra) # 5c5c <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1246:	2905                	addiw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	66c50513          	addi	a0,a0,1644 # 68b8 <malloc+0x87c>
    1254:	00005097          	auipc	ra,0x5
    1258:	9f8080e7          	jalr	-1544(ra) # 5c4c <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraiw	a4,s1,0x1f
    126c:	01a7571b          	srliw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraiw	a3,a5,0x6
    1278:	0306869b          	addiw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	andi	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addiw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1292:	fb040513          	addi	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	9b6080e7          	jalr	-1610(ra) # 5c4c <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a0:	2485                	addiw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	addi	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	60450513          	addi	a0,a0,1540 # 68c0 <malloc+0x884>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	cc0080e7          	jalr	-832(ra) # 5f84 <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	92e080e7          	jalr	-1746(ra) # 5bfc <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	addi	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	60450513          	addi	a0,a0,1540 # 68e0 <malloc+0x8a4>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	ca0080e7          	jalr	-864(ra) # 5f84 <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	90e080e7          	jalr	-1778(ra) # 5bfc <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	60850513          	addi	a0,a0,1544 # 6900 <malloc+0x8c4>
    1300:	00005097          	auipc	ra,0x5
    1304:	c84080e7          	jalr	-892(ra) # 5f84 <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	8f2080e7          	jalr	-1806(ra) # 5bfc <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	addi	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00009497          	auipc	s1,0x9
    1324:	06048493          	addi	s1,s1,96 # a380 <big>
    1328:	fd840593          	addi	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	906080e7          	jalr	-1786(ra) # 5c34 <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	8d4080e7          	jalr	-1836(ra) # 5c0c <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	8ba080e7          	jalr	-1862(ra) # 5bfc <exit>

000000000000134a <badarg>:
{
    134a:	7139                	addi	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	addi	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	addi	s1,s1,848 # c350 <uninit+0xa78>
    argv[0] = (char*)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	e1498993          	addi	s3,s3,-492 # 6178 <malloc+0x13c>
    argv[0] = (char*)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	addi	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	8ba080e7          	jalr	-1862(ra) # 5c34 <exec>
  for(int i = 0; i < 50000; i++){
    1382:	34fd                	addiw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	874080e7          	jalr	-1932(ra) # 5bfc <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	addi	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	addi	a5,s0,-152
    139c:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13a8:	0785                	addi	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	addi	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	896080e7          	jalr	-1898(ra) # 5c4c <unlink>
  if(ret != -1){
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	addi	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	870080e7          	jalr	-1936(ra) # 5c3c <open>
  if(fd != -1){
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	addi	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	87c080e7          	jalr	-1924(ra) # 5c5c <link>
  if(ret != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13ee:	00006797          	auipc	a5,0x6
    13f2:	76a78793          	addi	a5,a5,1898 # 7b58 <malloc+0x1b1c>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	addi	a1,s0,-168
    1402:	f6840513          	addi	a0,s0,-152
    1406:	00005097          	auipc	ra,0x5
    140a:	82e080e7          	jalr	-2002(ra) # 5c34 <exec>
  if(ret != -1){
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	7e0080e7          	jalr	2016(ra) # 5bf4 <fork>
  if(pid < 0){
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if(pid == 0){
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00009797          	auipc	a5,0x9
    1428:	4ac78793          	addi	a5,a5,1196 # a8d0 <big.0>
    142c:	0000a697          	auipc	a3,0xa
    1430:	4a468693          	addi	a3,a3,1188 # b8d0 <big.0+0x1000>
      big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143c:	0785                	addi	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	0000a797          	auipc	a5,0xa
    1446:	48078723          	sb	zero,1166(a5) # b8d0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144a:	00007797          	auipc	a5,0x7
    144e:	14678793          	addi	a5,a5,326 # 8590 <malloc+0x2554>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	addi	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	d0a50513          	addi	a0,a0,-758 # 6178 <malloc+0x13c>
    1476:	00004097          	auipc	ra,0x4
    147a:	7be080e7          	jalr	1982(ra) # 5c34 <exec>
    if(ret != -1){
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	52250513          	addi	a0,a0,1314 # 69a8 <malloc+0x96c>
    148e:	00005097          	auipc	ra,0x5
    1492:	af6080e7          	jalr	-1290(ra) # 5f84 <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	764080e7          	jalr	1892(ra) # 5bfc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	addi	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	47a50513          	addi	a0,a0,1146 # 6920 <malloc+0x8e4>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	ad6080e7          	jalr	-1322(ra) # 5f84 <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	744080e7          	jalr	1860(ra) # 5bfc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	addi	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	47a50513          	addi	a0,a0,1146 # 6940 <malloc+0x904>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	ab6080e7          	jalr	-1354(ra) # 5f84 <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	724080e7          	jalr	1828(ra) # 5bfc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	addi	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	47850513          	addi	a0,a0,1144 # 6960 <malloc+0x924>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	a94080e7          	jalr	-1388(ra) # 5f84 <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	702080e7          	jalr	1794(ra) # 5bfc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	addi	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	48050513          	addi	a0,a0,1152 # 6988 <malloc+0x94c>
    1510:	00005097          	auipc	ra,0x5
    1514:	a74080e7          	jalr	-1420(ra) # 5f84 <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	6e2080e7          	jalr	1762(ra) # 5bfc <exit>
    printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	8e650513          	addi	a0,a0,-1818 # 6e08 <malloc+0xdcc>
    152a:	00005097          	auipc	ra,0x5
    152e:	a5a080e7          	jalr	-1446(ra) # 5f84 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	6c8080e7          	jalr	1736(ra) # 5bfc <exit>
    exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	6bc080e7          	jalr	1724(ra) # 5bfc <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	addi	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	6b4080e7          	jalr	1716(ra) # 5c04 <wait>
  if(st != 747){
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	addi	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	46450513          	addi	a0,a0,1124 # 69d0 <malloc+0x994>
    1574:	00005097          	auipc	ra,0x5
    1578:	a10080e7          	jalr	-1520(ra) # 5f84 <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	67e080e7          	jalr	1662(ra) # 5bfc <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	addi	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	e8ca                	sd	s2,80(sp)
    158e:	1880                	addi	s0,sp,112
    1590:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1592:	60100593          	li	a1,1537
    1596:	00005517          	auipc	a0,0x5
    159a:	c3a50513          	addi	a0,a0,-966 # 61d0 <malloc+0x194>
    159e:	00004097          	auipc	ra,0x4
    15a2:	69e080e7          	jalr	1694(ra) # 5c3c <open>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	67e080e7          	jalr	1662(ra) # 5c24 <close>
  pid = fork();
    15ae:	00004097          	auipc	ra,0x4
    15b2:	646080e7          	jalr	1606(ra) # 5bf4 <fork>
  if(pid < 0){
    15b6:	08054463          	bltz	a0,163e <truncate3+0xb8>
  if(pid == 0){
    15ba:	e16d                	bnez	a0,169c <truncate3+0x116>
    15bc:	eca6                	sd	s1,88(sp)
    15be:	e4ce                	sd	s3,72(sp)
    15c0:	e0d2                	sd	s4,64(sp)
    15c2:	fc56                	sd	s5,56(sp)
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	c08a0a13          	addi	s4,s4,-1016 # 61d0 <malloc+0x194>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	460a8a93          	addi	s5,s5,1120 # 6a30 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	660080e7          	jalr	1632(ra) # 5c3c <open>
    15e4:	84aa                	mv	s1,a0
      if(fd < 0){
    15e6:	06054e63          	bltz	a0,1662 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	62e080e7          	jalr	1582(ra) # 5c1c <write>
      if(n != 10){
    15f6:	47a9                	li	a5,10
    15f8:	08f51363          	bne	a0,a5,167e <truncate3+0xf8>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	626080e7          	jalr	1574(ra) # 5c24 <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	632080e7          	jalr	1586(ra) # 5c3c <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	addi	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	5f8080e7          	jalr	1528(ra) # 5c14 <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	5fe080e7          	jalr	1534(ra) # 5c24 <close>
    for(int i = 0; i < 100; i++){
    162e:	39fd                	addiw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	5c6080e7          	jalr	1478(ra) # 5bfc <exit>
    163e:	eca6                	sd	s1,88(sp)
    1640:	e4ce                	sd	s3,72(sp)
    1642:	e0d2                	sd	s4,64(sp)
    1644:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	3b850513          	addi	a0,a0,952 # 6a00 <malloc+0x9c4>
    1650:	00005097          	auipc	ra,0x5
    1654:	934080e7          	jalr	-1740(ra) # 5f84 <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	5a2080e7          	jalr	1442(ra) # 5bfc <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	3b450513          	addi	a0,a0,948 # 6a18 <malloc+0x9dc>
    166c:	00005097          	auipc	ra,0x5
    1670:	918080e7          	jalr	-1768(ra) # 5f84 <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	586080e7          	jalr	1414(ra) # 5bfc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	3be50513          	addi	a0,a0,958 # 6a40 <malloc+0xa04>
    168a:	00005097          	auipc	ra,0x5
    168e:	8fa080e7          	jalr	-1798(ra) # 5f84 <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	568080e7          	jalr	1384(ra) # 5bfc <exit>
    169c:	eca6                	sd	s1,88(sp)
    169e:	e4ce                	sd	s3,72(sp)
    16a0:	e0d2                	sd	s4,64(sp)
    16a2:	fc56                	sd	s5,56(sp)
    16a4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a8:	00005a17          	auipc	s4,0x5
    16ac:	b28a0a13          	addi	s4,s4,-1240 # 61d0 <malloc+0x194>
    int n = write(fd, "xxx", 3);
    16b0:	00005a97          	auipc	s5,0x5
    16b4:	3b0a8a93          	addi	s5,s5,944 # 6a60 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b8:	60100593          	li	a1,1537
    16bc:	8552                	mv	a0,s4
    16be:	00004097          	auipc	ra,0x4
    16c2:	57e080e7          	jalr	1406(ra) # 5c3c <open>
    16c6:	84aa                	mv	s1,a0
    if(fd < 0){
    16c8:	04054763          	bltz	a0,1716 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16cc:	460d                	li	a2,3
    16ce:	85d6                	mv	a1,s5
    16d0:	00004097          	auipc	ra,0x4
    16d4:	54c080e7          	jalr	1356(ra) # 5c1c <write>
    if(n != 3){
    16d8:	478d                	li	a5,3
    16da:	04f51c63          	bne	a0,a5,1732 <truncate3+0x1ac>
    close(fd);
    16de:	8526                	mv	a0,s1
    16e0:	00004097          	auipc	ra,0x4
    16e4:	544080e7          	jalr	1348(ra) # 5c24 <close>
  for(int i = 0; i < 150; i++){
    16e8:	39fd                	addiw	s3,s3,-1
    16ea:	fc0997e3          	bnez	s3,16b8 <truncate3+0x132>
  wait(&xstatus);
    16ee:	fbc40513          	addi	a0,s0,-68
    16f2:	00004097          	auipc	ra,0x4
    16f6:	512080e7          	jalr	1298(ra) # 5c04 <wait>
  unlink("truncfile");
    16fa:	00005517          	auipc	a0,0x5
    16fe:	ad650513          	addi	a0,a0,-1322 # 61d0 <malloc+0x194>
    1702:	00004097          	auipc	ra,0x4
    1706:	54a080e7          	jalr	1354(ra) # 5c4c <unlink>
  exit(xstatus);
    170a:	fbc42503          	lw	a0,-68(s0)
    170e:	00004097          	auipc	ra,0x4
    1712:	4ee080e7          	jalr	1262(ra) # 5bfc <exit>
      printf("%s: open failed\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	30050513          	addi	a0,a0,768 # 6a18 <malloc+0x9dc>
    1720:	00005097          	auipc	ra,0x5
    1724:	864080e7          	jalr	-1948(ra) # 5f84 <printf>
      exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	4d2080e7          	jalr	1234(ra) # 5bfc <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1732:	862a                	mv	a2,a0
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	33250513          	addi	a0,a0,818 # 6a68 <malloc+0xa2c>
    173e:	00005097          	auipc	ra,0x5
    1742:	846080e7          	jalr	-1978(ra) # 5f84 <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	4b4080e7          	jalr	1204(ra) # 5bfc <exit>

0000000000001750 <exectest>:
{
    1750:	715d                	addi	sp,sp,-80
    1752:	e486                	sd	ra,72(sp)
    1754:	e0a2                	sd	s0,64(sp)
    1756:	f84a                	sd	s2,48(sp)
    1758:	0880                	addi	s0,sp,80
    175a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175c:	00005797          	auipc	a5,0x5
    1760:	a1c78793          	addi	a5,a5,-1508 # 6178 <malloc+0x13c>
    1764:	fcf43023          	sd	a5,-64(s0)
    1768:	00005797          	auipc	a5,0x5
    176c:	32078793          	addi	a5,a5,800 # 6a88 <malloc+0xa4c>
    1770:	fcf43423          	sd	a5,-56(s0)
    1774:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1778:	00005517          	auipc	a0,0x5
    177c:	31850513          	addi	a0,a0,792 # 6a90 <malloc+0xa54>
    1780:	00004097          	auipc	ra,0x4
    1784:	4cc080e7          	jalr	1228(ra) # 5c4c <unlink>
  pid = fork();
    1788:	00004097          	auipc	ra,0x4
    178c:	46c080e7          	jalr	1132(ra) # 5bf4 <fork>
  if(pid < 0) {
    1790:	04054763          	bltz	a0,17de <exectest+0x8e>
    1794:	fc26                	sd	s1,56(sp)
    1796:	84aa                	mv	s1,a0
  if(pid == 0) {
    1798:	ed41                	bnez	a0,1830 <exectest+0xe0>
    close(1);
    179a:	4505                	li	a0,1
    179c:	00004097          	auipc	ra,0x4
    17a0:	488080e7          	jalr	1160(ra) # 5c24 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a4:	20100593          	li	a1,513
    17a8:	00005517          	auipc	a0,0x5
    17ac:	2e850513          	addi	a0,a0,744 # 6a90 <malloc+0xa54>
    17b0:	00004097          	auipc	ra,0x4
    17b4:	48c080e7          	jalr	1164(ra) # 5c3c <open>
    if(fd < 0) {
    17b8:	04054263          	bltz	a0,17fc <exectest+0xac>
    if(fd != 1) {
    17bc:	4785                	li	a5,1
    17be:	04f50d63          	beq	a0,a5,1818 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c2:	85ca                	mv	a1,s2
    17c4:	00005517          	auipc	a0,0x5
    17c8:	2ec50513          	addi	a0,a0,748 # 6ab0 <malloc+0xa74>
    17cc:	00004097          	auipc	ra,0x4
    17d0:	7b8080e7          	jalr	1976(ra) # 5f84 <printf>
      exit(1);
    17d4:	4505                	li	a0,1
    17d6:	00004097          	auipc	ra,0x4
    17da:	426080e7          	jalr	1062(ra) # 5bfc <exit>
    17de:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e0:	85ca                	mv	a1,s2
    17e2:	00005517          	auipc	a0,0x5
    17e6:	21e50513          	addi	a0,a0,542 # 6a00 <malloc+0x9c4>
    17ea:	00004097          	auipc	ra,0x4
    17ee:	79a080e7          	jalr	1946(ra) # 5f84 <printf>
     exit(1);
    17f2:	4505                	li	a0,1
    17f4:	00004097          	auipc	ra,0x4
    17f8:	408080e7          	jalr	1032(ra) # 5bfc <exit>
      printf("%s: create failed\n", s);
    17fc:	85ca                	mv	a1,s2
    17fe:	00005517          	auipc	a0,0x5
    1802:	29a50513          	addi	a0,a0,666 # 6a98 <malloc+0xa5c>
    1806:	00004097          	auipc	ra,0x4
    180a:	77e080e7          	jalr	1918(ra) # 5f84 <printf>
      exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	3ec080e7          	jalr	1004(ra) # 5bfc <exit>
    if(exec("echo", echoargv) < 0){
    1818:	fc040593          	addi	a1,s0,-64
    181c:	00005517          	auipc	a0,0x5
    1820:	95c50513          	addi	a0,a0,-1700 # 6178 <malloc+0x13c>
    1824:	00004097          	auipc	ra,0x4
    1828:	410080e7          	jalr	1040(ra) # 5c34 <exec>
    182c:	02054163          	bltz	a0,184e <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1830:	fdc40513          	addi	a0,s0,-36
    1834:	00004097          	auipc	ra,0x4
    1838:	3d0080e7          	jalr	976(ra) # 5c04 <wait>
    183c:	02951763          	bne	a0,s1,186a <exectest+0x11a>
  if(xstatus != 0)
    1840:	fdc42503          	lw	a0,-36(s0)
    1844:	cd0d                	beqz	a0,187e <exectest+0x12e>
    exit(xstatus);
    1846:	00004097          	auipc	ra,0x4
    184a:	3b6080e7          	jalr	950(ra) # 5bfc <exit>
      printf("%s: exec echo failed\n", s);
    184e:	85ca                	mv	a1,s2
    1850:	00005517          	auipc	a0,0x5
    1854:	27050513          	addi	a0,a0,624 # 6ac0 <malloc+0xa84>
    1858:	00004097          	auipc	ra,0x4
    185c:	72c080e7          	jalr	1836(ra) # 5f84 <printf>
      exit(1);
    1860:	4505                	li	a0,1
    1862:	00004097          	auipc	ra,0x4
    1866:	39a080e7          	jalr	922(ra) # 5bfc <exit>
    printf("%s: wait failed!\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00005517          	auipc	a0,0x5
    1870:	26c50513          	addi	a0,a0,620 # 6ad8 <malloc+0xa9c>
    1874:	00004097          	auipc	ra,0x4
    1878:	710080e7          	jalr	1808(ra) # 5f84 <printf>
    187c:	b7d1                	j	1840 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    187e:	4581                	li	a1,0
    1880:	00005517          	auipc	a0,0x5
    1884:	21050513          	addi	a0,a0,528 # 6a90 <malloc+0xa54>
    1888:	00004097          	auipc	ra,0x4
    188c:	3b4080e7          	jalr	948(ra) # 5c3c <open>
  if(fd < 0) {
    1890:	02054a63          	bltz	a0,18c4 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1894:	4609                	li	a2,2
    1896:	fb840593          	addi	a1,s0,-72
    189a:	00004097          	auipc	ra,0x4
    189e:	37a080e7          	jalr	890(ra) # 5c14 <read>
    18a2:	4789                	li	a5,2
    18a4:	02f50e63          	beq	a0,a5,18e0 <exectest+0x190>
    printf("%s: read failed\n", s);
    18a8:	85ca                	mv	a1,s2
    18aa:	00005517          	auipc	a0,0x5
    18ae:	c9e50513          	addi	a0,a0,-866 # 6548 <malloc+0x50c>
    18b2:	00004097          	auipc	ra,0x4
    18b6:	6d2080e7          	jalr	1746(ra) # 5f84 <printf>
    exit(1);
    18ba:	4505                	li	a0,1
    18bc:	00004097          	auipc	ra,0x4
    18c0:	340080e7          	jalr	832(ra) # 5bfc <exit>
    printf("%s: open failed\n", s);
    18c4:	85ca                	mv	a1,s2
    18c6:	00005517          	auipc	a0,0x5
    18ca:	15250513          	addi	a0,a0,338 # 6a18 <malloc+0x9dc>
    18ce:	00004097          	auipc	ra,0x4
    18d2:	6b6080e7          	jalr	1718(ra) # 5f84 <printf>
    exit(1);
    18d6:	4505                	li	a0,1
    18d8:	00004097          	auipc	ra,0x4
    18dc:	324080e7          	jalr	804(ra) # 5bfc <exit>
  unlink("echo-ok");
    18e0:	00005517          	auipc	a0,0x5
    18e4:	1b050513          	addi	a0,a0,432 # 6a90 <malloc+0xa54>
    18e8:	00004097          	auipc	ra,0x4
    18ec:	364080e7          	jalr	868(ra) # 5c4c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f0:	fb844703          	lbu	a4,-72(s0)
    18f4:	04f00793          	li	a5,79
    18f8:	00f71863          	bne	a4,a5,1908 <exectest+0x1b8>
    18fc:	fb944703          	lbu	a4,-71(s0)
    1900:	04b00793          	li	a5,75
    1904:	02f70063          	beq	a4,a5,1924 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00005517          	auipc	a0,0x5
    190e:	1e650513          	addi	a0,a0,486 # 6af0 <malloc+0xab4>
    1912:	00004097          	auipc	ra,0x4
    1916:	672080e7          	jalr	1650(ra) # 5f84 <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00004097          	auipc	ra,0x4
    1920:	2e0080e7          	jalr	736(ra) # 5bfc <exit>
    exit(0);
    1924:	4501                	li	a0,0
    1926:	00004097          	auipc	ra,0x4
    192a:	2d6080e7          	jalr	726(ra) # 5bfc <exit>

000000000000192e <pipe1>:
{
    192e:	711d                	addi	sp,sp,-96
    1930:	ec86                	sd	ra,88(sp)
    1932:	e8a2                	sd	s0,80(sp)
    1934:	fc4e                	sd	s3,56(sp)
    1936:	1080                	addi	s0,sp,96
    1938:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193a:	fa840513          	addi	a0,s0,-88
    193e:	00004097          	auipc	ra,0x4
    1942:	2ce080e7          	jalr	718(ra) # 5c0c <pipe>
    1946:	ed3d                	bnez	a0,19c4 <pipe1+0x96>
    1948:	e4a6                	sd	s1,72(sp)
    194a:	f852                	sd	s4,48(sp)
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	2a6080e7          	jalr	678(ra) # 5bf4 <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c951                	beqz	a0,19ec <pipe1+0xbe>
  } else if(pid > 0){
    195a:	18a05b63          	blez	a0,1af0 <pipe1+0x1c2>
    195e:	e0ca                	sd	s2,64(sp)
    1960:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1962:	fac42503          	lw	a0,-84(s0)
    1966:	00004097          	auipc	ra,0x4
    196a:	2be080e7          	jalr	702(ra) # 5c24 <close>
    total = 0;
    196e:	8a26                	mv	s4,s1
    cc = 1;
    1970:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1972:	0000ca97          	auipc	s5,0xc
    1976:	676a8a93          	addi	s5,s5,1654 # dfe8 <buf>
    197a:	864a                	mv	a2,s2
    197c:	85d6                	mv	a1,s5
    197e:	fa842503          	lw	a0,-88(s0)
    1982:	00004097          	auipc	ra,0x4
    1986:	292080e7          	jalr	658(ra) # 5c14 <read>
    198a:	10a05a63          	blez	a0,1a9e <pipe1+0x170>
      for(i = 0; i < n; i++){
    198e:	0000c717          	auipc	a4,0xc
    1992:	65a70713          	addi	a4,a4,1626 # dfe8 <buf>
    1996:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199a:	00074683          	lbu	a3,0(a4)
    199e:	0ff4f793          	zext.b	a5,s1
    19a2:	2485                	addiw	s1,s1,1
    19a4:	0cf69b63          	bne	a3,a5,1a7a <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19a8:	0705                	addi	a4,a4,1
    19aa:	fec498e3          	bne	s1,a2,199a <pipe1+0x6c>
      total += n;
    19ae:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b2:	0019179b          	slliw	a5,s2,0x1
    19b6:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19ba:	670d                	lui	a4,0x3
    19bc:	fb277fe3          	bgeu	a4,s2,197a <pipe1+0x4c>
        cc = sizeof(buf);
    19c0:	690d                	lui	s2,0x3
    19c2:	bf65                	j	197a <pipe1+0x4c>
    19c4:	e4a6                	sd	s1,72(sp)
    19c6:	e0ca                	sd	s2,64(sp)
    19c8:	f852                	sd	s4,48(sp)
    19ca:	f456                	sd	s5,40(sp)
    19cc:	f05a                	sd	s6,32(sp)
    19ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d0:	85ce                	mv	a1,s3
    19d2:	00005517          	auipc	a0,0x5
    19d6:	13650513          	addi	a0,a0,310 # 6b08 <malloc+0xacc>
    19da:	00004097          	auipc	ra,0x4
    19de:	5aa080e7          	jalr	1450(ra) # 5f84 <printf>
    exit(1);
    19e2:	4505                	li	a0,1
    19e4:	00004097          	auipc	ra,0x4
    19e8:	218080e7          	jalr	536(ra) # 5bfc <exit>
    19ec:	e0ca                	sd	s2,64(sp)
    19ee:	f456                	sd	s5,40(sp)
    19f0:	f05a                	sd	s6,32(sp)
    19f2:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f4:	fa842503          	lw	a0,-88(s0)
    19f8:	00004097          	auipc	ra,0x4
    19fc:	22c080e7          	jalr	556(ra) # 5c24 <close>
    for(n = 0; n < N; n++){
    1a00:	0000cb17          	auipc	s6,0xc
    1a04:	5e8b0b13          	addi	s6,s6,1512 # dfe8 <buf>
    1a08:	416004bb          	negw	s1,s6
    1a0c:	0ff4f493          	zext.b	s1,s1
    1a10:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a14:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a16:	6a85                	lui	s5,0x1
    1a18:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    1a1c:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a1e:	0097873b          	addw	a4,a5,s1
    1a22:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a26:	0785                	addi	a5,a5,1
    1a28:	ff279be3          	bne	a5,s2,1a1e <pipe1+0xf0>
    1a2c:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a30:	40900613          	li	a2,1033
    1a34:	85de                	mv	a1,s7
    1a36:	fac42503          	lw	a0,-84(s0)
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	1e2080e7          	jalr	482(ra) # 5c1c <write>
    1a42:	40900793          	li	a5,1033
    1a46:	00f51c63          	bne	a0,a5,1a5e <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4a:	24a5                	addiw	s1,s1,9
    1a4c:	0ff4f493          	zext.b	s1,s1
    1a50:	fd5a16e3          	bne	s4,s5,1a1c <pipe1+0xee>
    exit(0);
    1a54:	4501                	li	a0,0
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	1a6080e7          	jalr	422(ra) # 5bfc <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a5e:	85ce                	mv	a1,s3
    1a60:	00005517          	auipc	a0,0x5
    1a64:	0c050513          	addi	a0,a0,192 # 6b20 <malloc+0xae4>
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	51c080e7          	jalr	1308(ra) # 5f84 <printf>
        exit(1);
    1a70:	4505                	li	a0,1
    1a72:	00004097          	auipc	ra,0x4
    1a76:	18a080e7          	jalr	394(ra) # 5bfc <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	0bc50513          	addi	a0,a0,188 # 6b38 <malloc+0xafc>
    1a84:	00004097          	auipc	ra,0x4
    1a88:	500080e7          	jalr	1280(ra) # 5f84 <printf>
          return;
    1a8c:	64a6                	ld	s1,72(sp)
    1a8e:	6906                	ld	s2,64(sp)
    1a90:	7a42                	ld	s4,48(sp)
    1a92:	7aa2                	ld	s5,40(sp)
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	79e2                	ld	s3,56(sp)
    1a9a:	6125                	addi	sp,sp,96
    1a9c:	8082                	ret
    if(total != N * SZ){
    1a9e:	6785                	lui	a5,0x1
    1aa0:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1aa4:	02fa0263          	beq	s4,a5,1ac8 <pipe1+0x19a>
    1aa8:	f05a                	sd	s6,32(sp)
    1aaa:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aac:	85d2                	mv	a1,s4
    1aae:	00005517          	auipc	a0,0x5
    1ab2:	0a250513          	addi	a0,a0,162 # 6b50 <malloc+0xb14>
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	4ce080e7          	jalr	1230(ra) # 5f84 <printf>
      exit(1);
    1abe:	4505                	li	a0,1
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	13c080e7          	jalr	316(ra) # 5bfc <exit>
    1ac8:	f05a                	sd	s6,32(sp)
    1aca:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1acc:	fa842503          	lw	a0,-88(s0)
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	154080e7          	jalr	340(ra) # 5c24 <close>
    wait(&xstatus);
    1ad8:	fa440513          	addi	a0,s0,-92
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	128080e7          	jalr	296(ra) # 5c04 <wait>
    exit(xstatus);
    1ae4:	fa442503          	lw	a0,-92(s0)
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	114080e7          	jalr	276(ra) # 5bfc <exit>
    1af0:	e0ca                	sd	s2,64(sp)
    1af2:	f456                	sd	s5,40(sp)
    1af4:	f05a                	sd	s6,32(sp)
    1af6:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1af8:	85ce                	mv	a1,s3
    1afa:	00005517          	auipc	a0,0x5
    1afe:	07650513          	addi	a0,a0,118 # 6b70 <malloc+0xb34>
    1b02:	00004097          	auipc	ra,0x4
    1b06:	482080e7          	jalr	1154(ra) # 5f84 <printf>
    exit(1);
    1b0a:	4505                	li	a0,1
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	0f0080e7          	jalr	240(ra) # 5bfc <exit>

0000000000001b14 <exitwait>:
{
    1b14:	7139                	addi	sp,sp,-64
    1b16:	fc06                	sd	ra,56(sp)
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f426                	sd	s1,40(sp)
    1b1c:	f04a                	sd	s2,32(sp)
    1b1e:	ec4e                	sd	s3,24(sp)
    1b20:	e852                	sd	s4,16(sp)
    1b22:	0080                	addi	s0,sp,64
    1b24:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b26:	4901                	li	s2,0
    1b28:	06400993          	li	s3,100
    pid = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	0c8080e7          	jalr	200(ra) # 5bf4 <fork>
    1b34:	84aa                	mv	s1,a0
    if(pid < 0){
    1b36:	02054a63          	bltz	a0,1b6a <exitwait+0x56>
    if(pid){
    1b3a:	c151                	beqz	a0,1bbe <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3c:	fcc40513          	addi	a0,s0,-52
    1b40:	00004097          	auipc	ra,0x4
    1b44:	0c4080e7          	jalr	196(ra) # 5c04 <wait>
    1b48:	02951f63          	bne	a0,s1,1b86 <exitwait+0x72>
      if(i != xstate) {
    1b4c:	fcc42783          	lw	a5,-52(s0)
    1b50:	05279963          	bne	a5,s2,1ba2 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b54:	2905                	addiw	s2,s2,1 # 3001 <execout+0xc1>
    1b56:	fd391be3          	bne	s2,s3,1b2c <exitwait+0x18>
}
    1b5a:	70e2                	ld	ra,56(sp)
    1b5c:	7442                	ld	s0,48(sp)
    1b5e:	74a2                	ld	s1,40(sp)
    1b60:	7902                	ld	s2,32(sp)
    1b62:	69e2                	ld	s3,24(sp)
    1b64:	6a42                	ld	s4,16(sp)
    1b66:	6121                	addi	sp,sp,64
    1b68:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6a:	85d2                	mv	a1,s4
    1b6c:	00005517          	auipc	a0,0x5
    1b70:	e9450513          	addi	a0,a0,-364 # 6a00 <malloc+0x9c4>
    1b74:	00004097          	auipc	ra,0x4
    1b78:	410080e7          	jalr	1040(ra) # 5f84 <printf>
      exit(1);
    1b7c:	4505                	li	a0,1
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	07e080e7          	jalr	126(ra) # 5bfc <exit>
        printf("%s: wait wrong pid\n", s);
    1b86:	85d2                	mv	a1,s4
    1b88:	00005517          	auipc	a0,0x5
    1b8c:	00050513          	mv	a0,a0
    1b90:	00004097          	auipc	ra,0x4
    1b94:	3f4080e7          	jalr	1012(ra) # 5f84 <printf>
        exit(1);
    1b98:	4505                	li	a0,1
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	062080e7          	jalr	98(ra) # 5bfc <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba2:	85d2                	mv	a1,s4
    1ba4:	00005517          	auipc	a0,0x5
    1ba8:	ffc50513          	addi	a0,a0,-4 # 6ba0 <malloc+0xb64>
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	3d8080e7          	jalr	984(ra) # 5f84 <printf>
        exit(1);
    1bb4:	4505                	li	a0,1
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	046080e7          	jalr	70(ra) # 5bfc <exit>
      exit(i);
    1bbe:	854a                	mv	a0,s2
    1bc0:	00004097          	auipc	ra,0x4
    1bc4:	03c080e7          	jalr	60(ra) # 5bfc <exit>

0000000000001bc8 <twochildren>:
{
    1bc8:	1101                	addi	sp,sp,-32
    1bca:	ec06                	sd	ra,24(sp)
    1bcc:	e822                	sd	s0,16(sp)
    1bce:	e426                	sd	s1,8(sp)
    1bd0:	e04a                	sd	s2,0(sp)
    1bd2:	1000                	addi	s0,sp,32
    1bd4:	892a                	mv	s2,a0
    1bd6:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bda:	00004097          	auipc	ra,0x4
    1bde:	01a080e7          	jalr	26(ra) # 5bf4 <fork>
    if(pid1 < 0){
    1be2:	02054c63          	bltz	a0,1c1a <twochildren+0x52>
    if(pid1 == 0){
    1be6:	c921                	beqz	a0,1c36 <twochildren+0x6e>
      int pid2 = fork();
    1be8:	00004097          	auipc	ra,0x4
    1bec:	00c080e7          	jalr	12(ra) # 5bf4 <fork>
      if(pid2 < 0){
    1bf0:	04054763          	bltz	a0,1c3e <twochildren+0x76>
      if(pid2 == 0){
    1bf4:	c13d                	beqz	a0,1c5a <twochildren+0x92>
        wait(0);
    1bf6:	4501                	li	a0,0
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	00c080e7          	jalr	12(ra) # 5c04 <wait>
        wait(0);
    1c00:	4501                	li	a0,0
    1c02:	00004097          	auipc	ra,0x4
    1c06:	002080e7          	jalr	2(ra) # 5c04 <wait>
  for(int i = 0; i < 1000; i++){
    1c0a:	34fd                	addiw	s1,s1,-1
    1c0c:	f4f9                	bnez	s1,1bda <twochildren+0x12>
}
    1c0e:	60e2                	ld	ra,24(sp)
    1c10:	6442                	ld	s0,16(sp)
    1c12:	64a2                	ld	s1,8(sp)
    1c14:	6902                	ld	s2,0(sp)
    1c16:	6105                	addi	sp,sp,32
    1c18:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1a:	85ca                	mv	a1,s2
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	de450513          	addi	a0,a0,-540 # 6a00 <malloc+0x9c4>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	360080e7          	jalr	864(ra) # 5f84 <printf>
      exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	fce080e7          	jalr	-50(ra) # 5bfc <exit>
      exit(0);
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	fc6080e7          	jalr	-58(ra) # 5bfc <exit>
        printf("%s: fork failed\n", s);
    1c3e:	85ca                	mv	a1,s2
    1c40:	00005517          	auipc	a0,0x5
    1c44:	dc050513          	addi	a0,a0,-576 # 6a00 <malloc+0x9c4>
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	33c080e7          	jalr	828(ra) # 5f84 <printf>
        exit(1);
    1c50:	4505                	li	a0,1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	faa080e7          	jalr	-86(ra) # 5bfc <exit>
        exit(0);
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	fa2080e7          	jalr	-94(ra) # 5bfc <exit>

0000000000001c62 <forkfork>:
{
    1c62:	7179                	addi	sp,sp,-48
    1c64:	f406                	sd	ra,40(sp)
    1c66:	f022                	sd	s0,32(sp)
    1c68:	ec26                	sd	s1,24(sp)
    1c6a:	1800                	addi	s0,sp,48
    1c6c:	84aa                	mv	s1,a0
    int pid = fork();
    1c6e:	00004097          	auipc	ra,0x4
    1c72:	f86080e7          	jalr	-122(ra) # 5bf4 <fork>
    if(pid < 0){
    1c76:	04054163          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c7a:	cd29                	beqz	a0,1cd4 <forkfork+0x72>
    int pid = fork();
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	f78080e7          	jalr	-136(ra) # 5bf4 <fork>
    if(pid < 0){
    1c84:	02054a63          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c88:	c531                	beqz	a0,1cd4 <forkfork+0x72>
    wait(&xstatus);
    1c8a:	fdc40513          	addi	a0,s0,-36
    1c8e:	00004097          	auipc	ra,0x4
    1c92:	f76080e7          	jalr	-138(ra) # 5c04 <wait>
    if(xstatus != 0) {
    1c96:	fdc42783          	lw	a5,-36(s0)
    1c9a:	ebbd                	bnez	a5,1d10 <forkfork+0xae>
    wait(&xstatus);
    1c9c:	fdc40513          	addi	a0,s0,-36
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	f64080e7          	jalr	-156(ra) # 5c04 <wait>
    if(xstatus != 0) {
    1ca8:	fdc42783          	lw	a5,-36(s0)
    1cac:	e3b5                	bnez	a5,1d10 <forkfork+0xae>
}
    1cae:	70a2                	ld	ra,40(sp)
    1cb0:	7402                	ld	s0,32(sp)
    1cb2:	64e2                	ld	s1,24(sp)
    1cb4:	6145                	addi	sp,sp,48
    1cb6:	8082                	ret
      printf("%s: fork failed", s);
    1cb8:	85a6                	mv	a1,s1
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	f0650513          	addi	a0,a0,-250 # 6bc0 <malloc+0xb84>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	2c2080e7          	jalr	706(ra) # 5f84 <printf>
      exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	f30080e7          	jalr	-208(ra) # 5bfc <exit>
{
    1cd4:	0c800493          	li	s1,200
        int pid1 = fork();
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	f1c080e7          	jalr	-228(ra) # 5bf4 <fork>
        if(pid1 < 0){
    1ce0:	00054f63          	bltz	a0,1cfe <forkfork+0x9c>
        if(pid1 == 0){
    1ce4:	c115                	beqz	a0,1d08 <forkfork+0xa6>
        wait(0);
    1ce6:	4501                	li	a0,0
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	f1c080e7          	jalr	-228(ra) # 5c04 <wait>
      for(int j = 0; j < 200; j++){
    1cf0:	34fd                	addiw	s1,s1,-1
    1cf2:	f0fd                	bnez	s1,1cd8 <forkfork+0x76>
      exit(0);
    1cf4:	4501                	li	a0,0
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	f06080e7          	jalr	-250(ra) # 5bfc <exit>
          exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00004097          	auipc	ra,0x4
    1d04:	efc080e7          	jalr	-260(ra) # 5bfc <exit>
          exit(0);
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	ef4080e7          	jalr	-268(ra) # 5bfc <exit>
      printf("%s: fork in child failed", s);
    1d10:	85a6                	mv	a1,s1
    1d12:	00005517          	auipc	a0,0x5
    1d16:	ebe50513          	addi	a0,a0,-322 # 6bd0 <malloc+0xb94>
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	26a080e7          	jalr	618(ra) # 5f84 <printf>
      exit(1);
    1d22:	4505                	li	a0,1
    1d24:	00004097          	auipc	ra,0x4
    1d28:	ed8080e7          	jalr	-296(ra) # 5bfc <exit>

0000000000001d2c <reparent2>:
{
    1d2c:	1101                	addi	sp,sp,-32
    1d2e:	ec06                	sd	ra,24(sp)
    1d30:	e822                	sd	s0,16(sp)
    1d32:	e426                	sd	s1,8(sp)
    1d34:	1000                	addi	s0,sp,32
    1d36:	32000493          	li	s1,800
    int pid1 = fork();
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	eba080e7          	jalr	-326(ra) # 5bf4 <fork>
    if(pid1 < 0){
    1d42:	00054f63          	bltz	a0,1d60 <reparent2+0x34>
    if(pid1 == 0){
    1d46:	c915                	beqz	a0,1d7a <reparent2+0x4e>
    wait(0);
    1d48:	4501                	li	a0,0
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	eba080e7          	jalr	-326(ra) # 5c04 <wait>
  for(int i = 0; i < 800; i++){
    1d52:	34fd                	addiw	s1,s1,-1
    1d54:	f0fd                	bnez	s1,1d3a <reparent2+0xe>
  exit(0);
    1d56:	4501                	li	a0,0
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	ea4080e7          	jalr	-348(ra) # 5bfc <exit>
      printf("fork failed\n");
    1d60:	00005517          	auipc	a0,0x5
    1d64:	0a850513          	addi	a0,a0,168 # 6e08 <malloc+0xdcc>
    1d68:	00004097          	auipc	ra,0x4
    1d6c:	21c080e7          	jalr	540(ra) # 5f84 <printf>
      exit(1);
    1d70:	4505                	li	a0,1
    1d72:	00004097          	auipc	ra,0x4
    1d76:	e8a080e7          	jalr	-374(ra) # 5bfc <exit>
      fork();
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	e7a080e7          	jalr	-390(ra) # 5bf4 <fork>
      fork();
    1d82:	00004097          	auipc	ra,0x4
    1d86:	e72080e7          	jalr	-398(ra) # 5bf4 <fork>
      exit(0);
    1d8a:	4501                	li	a0,0
    1d8c:	00004097          	auipc	ra,0x4
    1d90:	e70080e7          	jalr	-400(ra) # 5bfc <exit>

0000000000001d94 <createdelete>:
{
    1d94:	7175                	addi	sp,sp,-144
    1d96:	e506                	sd	ra,136(sp)
    1d98:	e122                	sd	s0,128(sp)
    1d9a:	fca6                	sd	s1,120(sp)
    1d9c:	f8ca                	sd	s2,112(sp)
    1d9e:	f4ce                	sd	s3,104(sp)
    1da0:	f0d2                	sd	s4,96(sp)
    1da2:	ecd6                	sd	s5,88(sp)
    1da4:	e8da                	sd	s6,80(sp)
    1da6:	e4de                	sd	s7,72(sp)
    1da8:	e0e2                	sd	s8,64(sp)
    1daa:	fc66                	sd	s9,56(sp)
    1dac:	0900                	addi	s0,sp,144
    1dae:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    pid = fork();
    1db4:	00004097          	auipc	ra,0x4
    1db8:	e40080e7          	jalr	-448(ra) # 5bf4 <fork>
    1dbc:	84aa                	mv	s1,a0
    if(pid < 0){
    1dbe:	02054f63          	bltz	a0,1dfc <createdelete+0x68>
    if(pid == 0){
    1dc2:	c939                	beqz	a0,1e18 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc4:	2905                	addiw	s2,s2,1
    1dc6:	ff3917e3          	bne	s2,s3,1db4 <createdelete+0x20>
    1dca:	4491                	li	s1,4
    wait(&xstatus);
    1dcc:	f7c40513          	addi	a0,s0,-132
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	e34080e7          	jalr	-460(ra) # 5c04 <wait>
    if(xstatus != 0)
    1dd8:	f7c42903          	lw	s2,-132(s0)
    1ddc:	0e091263          	bnez	s2,1ec0 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de0:	34fd                	addiw	s1,s1,-1
    1de2:	f4ed                	bnez	s1,1dcc <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de4:	f8040123          	sb	zero,-126(s0)
    1de8:	03000993          	li	s3,48
    1dec:	5a7d                	li	s4,-1
    1dee:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df2:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df6:	07400a93          	li	s5,116
    1dfa:	a28d                	j	1f5c <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	00a50513          	addi	a0,a0,10 # 6e08 <malloc+0xdcc>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	17e080e7          	jalr	382(ra) # 5f84 <printf>
      exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	dec080e7          	jalr	-532(ra) # 5bfc <exit>
      name[0] = 'p' + pi;
    1e18:	0709091b          	addiw	s2,s2,112
    1e1c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e20:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e24:	4951                	li	s2,20
    1e26:	a015                	j	1e4a <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e28:	85e6                	mv	a1,s9
    1e2a:	00005517          	auipc	a0,0x5
    1e2e:	c6e50513          	addi	a0,a0,-914 # 6a98 <malloc+0xa5c>
    1e32:	00004097          	auipc	ra,0x4
    1e36:	152080e7          	jalr	338(ra) # 5f84 <printf>
          exit(1);
    1e3a:	4505                	li	a0,1
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	dc0080e7          	jalr	-576(ra) # 5bfc <exit>
      for(i = 0; i < N; i++){
    1e44:	2485                	addiw	s1,s1,1
    1e46:	07248863          	beq	s1,s2,1eb6 <createdelete+0x122>
        name[1] = '0' + i;
    1e4a:	0304879b          	addiw	a5,s1,48
    1e4e:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	f8040513          	addi	a0,s0,-128
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	de2080e7          	jalr	-542(ra) # 5c3c <open>
        if(fd < 0){
    1e62:	fc0543e3          	bltz	a0,1e28 <createdelete+0x94>
        close(fd);
    1e66:	00004097          	auipc	ra,0x4
    1e6a:	dbe080e7          	jalr	-578(ra) # 5c24 <close>
        if(i > 0 && (i % 2 ) == 0){
    1e6e:	12905763          	blez	s1,1f9c <createdelete+0x208>
    1e72:	0014f793          	andi	a5,s1,1
    1e76:	f7f9                	bnez	a5,1e44 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e78:	01f4d79b          	srliw	a5,s1,0x1f
    1e7c:	9fa5                	addw	a5,a5,s1
    1e7e:	4017d79b          	sraiw	a5,a5,0x1
    1e82:	0307879b          	addiw	a5,a5,48
    1e86:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8a:	f8040513          	addi	a0,s0,-128
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	dbe080e7          	jalr	-578(ra) # 5c4c <unlink>
    1e96:	fa0557e3          	bgez	a0,1e44 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9a:	85e6                	mv	a1,s9
    1e9c:	00005517          	auipc	a0,0x5
    1ea0:	d5450513          	addi	a0,a0,-684 # 6bf0 <malloc+0xbb4>
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	0e0080e7          	jalr	224(ra) # 5f84 <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	d4e080e7          	jalr	-690(ra) # 5bfc <exit>
      exit(0);
    1eb6:	4501                	li	a0,0
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d44080e7          	jalr	-700(ra) # 5bfc <exit>
      exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	d3a080e7          	jalr	-710(ra) # 5bfc <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eca:	f8040613          	addi	a2,s0,-128
    1ece:	85e6                	mv	a1,s9
    1ed0:	00005517          	auipc	a0,0x5
    1ed4:	d3850513          	addi	a0,a0,-712 # 6c08 <malloc+0xbcc>
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	0ac080e7          	jalr	172(ra) # 5f84 <printf>
        exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	d1a080e7          	jalr	-742(ra) # 5bfc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eea:	034bff63          	bgeu	s7,s4,1f28 <createdelete+0x194>
      if(fd >= 0)
    1eee:	02055863          	bgez	a0,1f1e <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef2:	2485                	addiw	s1,s1,1
    1ef4:	0ff4f493          	zext.b	s1,s1
    1ef8:	05548a63          	beq	s1,s5,1f4c <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f00:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f04:	4581                	li	a1,0
    1f06:	f8040513          	addi	a0,s0,-128
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	d32080e7          	jalr	-718(ra) # 5c3c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f12:	00090463          	beqz	s2,1f1a <createdelete+0x186>
    1f16:	fd2b5ae3          	bge	s6,s2,1eea <createdelete+0x156>
    1f1a:	fa0548e3          	bltz	a0,1eca <createdelete+0x136>
        close(fd);
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	d06080e7          	jalr	-762(ra) # 5c24 <close>
    1f26:	b7f1                	j	1ef2 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f28:	fc0545e3          	bltz	a0,1ef2 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2c:	f8040613          	addi	a2,s0,-128
    1f30:	85e6                	mv	a1,s9
    1f32:	00005517          	auipc	a0,0x5
    1f36:	cfe50513          	addi	a0,a0,-770 # 6c30 <malloc+0xbf4>
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	04a080e7          	jalr	74(ra) # 5f84 <printf>
        exit(1);
    1f42:	4505                	li	a0,1
    1f44:	00004097          	auipc	ra,0x4
    1f48:	cb8080e7          	jalr	-840(ra) # 5bfc <exit>
  for(i = 0; i < N; i++){
    1f4c:	2905                	addiw	s2,s2,1
    1f4e:	2a05                	addiw	s4,s4,1
    1f50:	2985                	addiw	s3,s3,1
    1f52:	0ff9f993          	zext.b	s3,s3
    1f56:	47d1                	li	a5,20
    1f58:	02f90a63          	beq	s2,a5,1f8c <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5c:	84e2                	mv	s1,s8
    1f5e:	bf79                	j	1efc <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f60:	2905                	addiw	s2,s2,1
    1f62:	0ff97913          	zext.b	s2,s2
    1f66:	2985                	addiw	s3,s3,1
    1f68:	0ff9f993          	zext.b	s3,s3
    1f6c:	03490a63          	beq	s2,s4,1fa0 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f70:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f72:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f76:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7a:	f8040513          	addi	a0,s0,-128
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	cce080e7          	jalr	-818(ra) # 5c4c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f86:	34fd                	addiw	s1,s1,-1
    1f88:	f4ed                	bnez	s1,1f72 <createdelete+0x1de>
    1f8a:	bfd9                	j	1f60 <createdelete+0x1cc>
    1f8c:	03000993          	li	s3,48
    1f90:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f94:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f96:	08400a13          	li	s4,132
    1f9a:	bfd9                	j	1f70 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9c:	2485                	addiw	s1,s1,1
    1f9e:	b575                	j	1e4a <createdelete+0xb6>
}
    1fa0:	60aa                	ld	ra,136(sp)
    1fa2:	640a                	ld	s0,128(sp)
    1fa4:	74e6                	ld	s1,120(sp)
    1fa6:	7946                	ld	s2,112(sp)
    1fa8:	79a6                	ld	s3,104(sp)
    1faa:	7a06                	ld	s4,96(sp)
    1fac:	6ae6                	ld	s5,88(sp)
    1fae:	6b46                	ld	s6,80(sp)
    1fb0:	6ba6                	ld	s7,72(sp)
    1fb2:	6c06                	ld	s8,64(sp)
    1fb4:	7ce2                	ld	s9,56(sp)
    1fb6:	6149                	addi	sp,sp,144
    1fb8:	8082                	ret

0000000000001fba <linkunlink>:
{
    1fba:	711d                	addi	sp,sp,-96
    1fbc:	ec86                	sd	ra,88(sp)
    1fbe:	e8a2                	sd	s0,80(sp)
    1fc0:	e4a6                	sd	s1,72(sp)
    1fc2:	e0ca                	sd	s2,64(sp)
    1fc4:	fc4e                	sd	s3,56(sp)
    1fc6:	f852                	sd	s4,48(sp)
    1fc8:	f456                	sd	s5,40(sp)
    1fca:	f05a                	sd	s6,32(sp)
    1fcc:	ec5e                	sd	s7,24(sp)
    1fce:	e862                	sd	s8,16(sp)
    1fd0:	e466                	sd	s9,8(sp)
    1fd2:	1080                	addi	s0,sp,96
    1fd4:	84aa                	mv	s1,a0
  unlink("x");
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	21250513          	addi	a0,a0,530 # 61e8 <malloc+0x1ac>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	c6e080e7          	jalr	-914(ra) # 5c4c <unlink>
  pid = fork();
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	c0e080e7          	jalr	-1010(ra) # 5bf4 <fork>
  if(pid < 0){
    1fee:	02054b63          	bltz	a0,2024 <linkunlink+0x6a>
    1ff2:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff4:	06100913          	li	s2,97
    1ff8:	c111                	beqz	a0,1ffc <linkunlink+0x42>
    1ffa:	4905                	li	s2,1
    1ffc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2000:	41c65a37          	lui	s4,0x41c65
    2004:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c53e85>
    2008:	698d                	lui	s3,0x3
    200a:	0399899b          	addiw	s3,s3,57 # 3039 <fourteen+0x35>
    if((x % 3) == 0){
    200e:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2010:	4b85                	li	s7,1
      unlink("x");
    2012:	00004b17          	auipc	s6,0x4
    2016:	1d6b0b13          	addi	s6,s6,470 # 61e8 <malloc+0x1ac>
      link("cat", "x");
    201a:	00005c17          	auipc	s8,0x5
    201e:	c3ec0c13          	addi	s8,s8,-962 # 6c58 <malloc+0xc1c>
    2022:	a825                	j	205a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	9da50513          	addi	a0,a0,-1574 # 6a00 <malloc+0x9c4>
    202e:	00004097          	auipc	ra,0x4
    2032:	f56080e7          	jalr	-170(ra) # 5f84 <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00004097          	auipc	ra,0x4
    203c:	bc4080e7          	jalr	-1084(ra) # 5bfc <exit>
      close(open("x", O_RDWR | O_CREATE));
    2040:	20200593          	li	a1,514
    2044:	855a                	mv	a0,s6
    2046:	00004097          	auipc	ra,0x4
    204a:	bf6080e7          	jalr	-1034(ra) # 5c3c <open>
    204e:	00004097          	auipc	ra,0x4
    2052:	bd6080e7          	jalr	-1066(ra) # 5c24 <close>
  for(i = 0; i < 100; i++){
    2056:	34fd                	addiw	s1,s1,-1
    2058:	c895                	beqz	s1,208c <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205a:	034907bb          	mulw	a5,s2,s4
    205e:	013787bb          	addw	a5,a5,s3
    2062:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2066:	0357f7bb          	remuw	a5,a5,s5
    206a:	2781                	sext.w	a5,a5
    206c:	dbf1                	beqz	a5,2040 <linkunlink+0x86>
    } else if((x % 3) == 1){
    206e:	01778863          	beq	a5,s7,207e <linkunlink+0xc4>
      unlink("x");
    2072:	855a                	mv	a0,s6
    2074:	00004097          	auipc	ra,0x4
    2078:	bd8080e7          	jalr	-1064(ra) # 5c4c <unlink>
    207c:	bfe9                	j	2056 <linkunlink+0x9c>
      link("cat", "x");
    207e:	85da                	mv	a1,s6
    2080:	8562                	mv	a0,s8
    2082:	00004097          	auipc	ra,0x4
    2086:	bda080e7          	jalr	-1062(ra) # 5c5c <link>
    208a:	b7f1                	j	2056 <linkunlink+0x9c>
  if(pid)
    208c:	020c8463          	beqz	s9,20b4 <linkunlink+0xfa>
    wait(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	b72080e7          	jalr	-1166(ra) # 5c04 <wait>
}
    209a:	60e6                	ld	ra,88(sp)
    209c:	6446                	ld	s0,80(sp)
    209e:	64a6                	ld	s1,72(sp)
    20a0:	6906                	ld	s2,64(sp)
    20a2:	79e2                	ld	s3,56(sp)
    20a4:	7a42                	ld	s4,48(sp)
    20a6:	7aa2                	ld	s5,40(sp)
    20a8:	7b02                	ld	s6,32(sp)
    20aa:	6be2                	ld	s7,24(sp)
    20ac:	6c42                	ld	s8,16(sp)
    20ae:	6ca2                	ld	s9,8(sp)
    20b0:	6125                	addi	sp,sp,96
    20b2:	8082                	ret
    exit(0);
    20b4:	4501                	li	a0,0
    20b6:	00004097          	auipc	ra,0x4
    20ba:	b46080e7          	jalr	-1210(ra) # 5bfc <exit>

00000000000020be <forktest>:
{
    20be:	7179                	addi	sp,sp,-48
    20c0:	f406                	sd	ra,40(sp)
    20c2:	f022                	sd	s0,32(sp)
    20c4:	ec26                	sd	s1,24(sp)
    20c6:	e84a                	sd	s2,16(sp)
    20c8:	e44e                	sd	s3,8(sp)
    20ca:	1800                	addi	s0,sp,48
    20cc:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20ce:	4481                	li	s1,0
    20d0:	3e800913          	li	s2,1000
    pid = fork();
    20d4:	00004097          	auipc	ra,0x4
    20d8:	b20080e7          	jalr	-1248(ra) # 5bf4 <fork>
    if(pid < 0)
    20dc:	08054263          	bltz	a0,2160 <forktest+0xa2>
    if(pid == 0)
    20e0:	c115                	beqz	a0,2104 <forktest+0x46>
  for(n=0; n<N; n++){
    20e2:	2485                	addiw	s1,s1,1
    20e4:	ff2498e3          	bne	s1,s2,20d4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20e8:	85ce                	mv	a1,s3
    20ea:	00005517          	auipc	a0,0x5
    20ee:	bbe50513          	addi	a0,a0,-1090 # 6ca8 <malloc+0xc6c>
    20f2:	00004097          	auipc	ra,0x4
    20f6:	e92080e7          	jalr	-366(ra) # 5f84 <printf>
    exit(1);
    20fa:	4505                	li	a0,1
    20fc:	00004097          	auipc	ra,0x4
    2100:	b00080e7          	jalr	-1280(ra) # 5bfc <exit>
      exit(0);
    2104:	00004097          	auipc	ra,0x4
    2108:	af8080e7          	jalr	-1288(ra) # 5bfc <exit>
    printf("%s: no fork at all!\n", s);
    210c:	85ce                	mv	a1,s3
    210e:	00005517          	auipc	a0,0x5
    2112:	b5250513          	addi	a0,a0,-1198 # 6c60 <malloc+0xc24>
    2116:	00004097          	auipc	ra,0x4
    211a:	e6e080e7          	jalr	-402(ra) # 5f84 <printf>
    exit(1);
    211e:	4505                	li	a0,1
    2120:	00004097          	auipc	ra,0x4
    2124:	adc080e7          	jalr	-1316(ra) # 5bfc <exit>
      printf("%s: wait stopped early\n", s);
    2128:	85ce                	mv	a1,s3
    212a:	00005517          	auipc	a0,0x5
    212e:	b4e50513          	addi	a0,a0,-1202 # 6c78 <malloc+0xc3c>
    2132:	00004097          	auipc	ra,0x4
    2136:	e52080e7          	jalr	-430(ra) # 5f84 <printf>
      exit(1);
    213a:	4505                	li	a0,1
    213c:	00004097          	auipc	ra,0x4
    2140:	ac0080e7          	jalr	-1344(ra) # 5bfc <exit>
    printf("%s: wait got too many\n", s);
    2144:	85ce                	mv	a1,s3
    2146:	00005517          	auipc	a0,0x5
    214a:	b4a50513          	addi	a0,a0,-1206 # 6c90 <malloc+0xc54>
    214e:	00004097          	auipc	ra,0x4
    2152:	e36080e7          	jalr	-458(ra) # 5f84 <printf>
    exit(1);
    2156:	4505                	li	a0,1
    2158:	00004097          	auipc	ra,0x4
    215c:	aa4080e7          	jalr	-1372(ra) # 5bfc <exit>
  if (n == 0) {
    2160:	d4d5                	beqz	s1,210c <forktest+0x4e>
  for(; n > 0; n--){
    2162:	00905b63          	blez	s1,2178 <forktest+0xba>
    if(wait(0) < 0){
    2166:	4501                	li	a0,0
    2168:	00004097          	auipc	ra,0x4
    216c:	a9c080e7          	jalr	-1380(ra) # 5c04 <wait>
    2170:	fa054ce3          	bltz	a0,2128 <forktest+0x6a>
  for(; n > 0; n--){
    2174:	34fd                	addiw	s1,s1,-1
    2176:	f8e5                	bnez	s1,2166 <forktest+0xa8>
  if(wait(0) != -1){
    2178:	4501                	li	a0,0
    217a:	00004097          	auipc	ra,0x4
    217e:	a8a080e7          	jalr	-1398(ra) # 5c04 <wait>
    2182:	57fd                	li	a5,-1
    2184:	fcf510e3          	bne	a0,a5,2144 <forktest+0x86>
}
    2188:	70a2                	ld	ra,40(sp)
    218a:	7402                	ld	s0,32(sp)
    218c:	64e2                	ld	s1,24(sp)
    218e:	6942                	ld	s2,16(sp)
    2190:	69a2                	ld	s3,8(sp)
    2192:	6145                	addi	sp,sp,48
    2194:	8082                	ret

0000000000002196 <kernmem>:
{
    2196:	715d                	addi	sp,sp,-80
    2198:	e486                	sd	ra,72(sp)
    219a:	e0a2                	sd	s0,64(sp)
    219c:	fc26                	sd	s1,56(sp)
    219e:	f84a                	sd	s2,48(sp)
    21a0:	f44e                	sd	s3,40(sp)
    21a2:	f052                	sd	s4,32(sp)
    21a4:	ec56                	sd	s5,24(sp)
    21a6:	0880                	addi	s0,sp,80
    21a8:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21aa:	4485                	li	s1,1
    21ac:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21ae:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b0:	69b1                	lui	s3,0xc
    21b2:	35098993          	addi	s3,s3,848 # c350 <uninit+0xa78>
    21b6:	1003d937          	lui	s2,0x1003d
    21ba:	090e                	slli	s2,s2,0x3
    21bc:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c498>
    pid = fork();
    21c0:	00004097          	auipc	ra,0x4
    21c4:	a34080e7          	jalr	-1484(ra) # 5bf4 <fork>
    if(pid < 0){
    21c8:	02054963          	bltz	a0,21fa <kernmem+0x64>
    if(pid == 0){
    21cc:	c529                	beqz	a0,2216 <kernmem+0x80>
    wait(&xstatus);
    21ce:	fbc40513          	addi	a0,s0,-68
    21d2:	00004097          	auipc	ra,0x4
    21d6:	a32080e7          	jalr	-1486(ra) # 5c04 <wait>
    if(xstatus != -1)  // did kernel kill child?
    21da:	fbc42783          	lw	a5,-68(s0)
    21de:	05479d63          	bne	a5,s4,2238 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e2:	94ce                	add	s1,s1,s3
    21e4:	fd249ee3          	bne	s1,s2,21c0 <kernmem+0x2a>
}
    21e8:	60a6                	ld	ra,72(sp)
    21ea:	6406                	ld	s0,64(sp)
    21ec:	74e2                	ld	s1,56(sp)
    21ee:	7942                	ld	s2,48(sp)
    21f0:	79a2                	ld	s3,40(sp)
    21f2:	7a02                	ld	s4,32(sp)
    21f4:	6ae2                	ld	s5,24(sp)
    21f6:	6161                	addi	sp,sp,80
    21f8:	8082                	ret
      printf("%s: fork failed\n", s);
    21fa:	85d6                	mv	a1,s5
    21fc:	00005517          	auipc	a0,0x5
    2200:	80450513          	addi	a0,a0,-2044 # 6a00 <malloc+0x9c4>
    2204:	00004097          	auipc	ra,0x4
    2208:	d80080e7          	jalr	-640(ra) # 5f84 <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	9ee080e7          	jalr	-1554(ra) # 5bfc <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2216:	0004c683          	lbu	a3,0(s1)
    221a:	8626                	mv	a2,s1
    221c:	85d6                	mv	a1,s5
    221e:	00005517          	auipc	a0,0x5
    2222:	ab250513          	addi	a0,a0,-1358 # 6cd0 <malloc+0xc94>
    2226:	00004097          	auipc	ra,0x4
    222a:	d5e080e7          	jalr	-674(ra) # 5f84 <printf>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00004097          	auipc	ra,0x4
    2234:	9cc080e7          	jalr	-1588(ra) # 5bfc <exit>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00004097          	auipc	ra,0x4
    223e:	9c2080e7          	jalr	-1598(ra) # 5bfc <exit>

0000000000002242 <MAXVAplus>:
{
    2242:	7179                	addi	sp,sp,-48
    2244:	f406                	sd	ra,40(sp)
    2246:	f022                	sd	s0,32(sp)
    2248:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    224a:	4785                	li	a5,1
    224c:	179a                	slli	a5,a5,0x26
    224e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2252:	fd843783          	ld	a5,-40(s0)
    2256:	c3a1                	beqz	a5,2296 <MAXVAplus+0x54>
    2258:	ec26                	sd	s1,24(sp)
    225a:	e84a                	sd	s2,16(sp)
    225c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    225e:	54fd                	li	s1,-1
    pid = fork();
    2260:	00004097          	auipc	ra,0x4
    2264:	994080e7          	jalr	-1644(ra) # 5bf4 <fork>
    if(pid < 0){
    2268:	02054b63          	bltz	a0,229e <MAXVAplus+0x5c>
    if(pid == 0){
    226c:	c539                	beqz	a0,22ba <MAXVAplus+0x78>
    wait(&xstatus);
    226e:	fd440513          	addi	a0,s0,-44
    2272:	00004097          	auipc	ra,0x4
    2276:	992080e7          	jalr	-1646(ra) # 5c04 <wait>
    if(xstatus != -1)  // did kernel kill child?
    227a:	fd442783          	lw	a5,-44(s0)
    227e:	06979463          	bne	a5,s1,22e6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2282:	fd843783          	ld	a5,-40(s0)
    2286:	0786                	slli	a5,a5,0x1
    2288:	fcf43c23          	sd	a5,-40(s0)
    228c:	fd843783          	ld	a5,-40(s0)
    2290:	fbe1                	bnez	a5,2260 <MAXVAplus+0x1e>
    2292:	64e2                	ld	s1,24(sp)
    2294:	6942                	ld	s2,16(sp)
}
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	addi	sp,sp,48
    229c:	8082                	ret
      printf("%s: fork failed\n", s);
    229e:	85ca                	mv	a1,s2
    22a0:	00004517          	auipc	a0,0x4
    22a4:	76050513          	addi	a0,a0,1888 # 6a00 <malloc+0x9c4>
    22a8:	00004097          	auipc	ra,0x4
    22ac:	cdc080e7          	jalr	-804(ra) # 5f84 <printf>
      exit(1);
    22b0:	4505                	li	a0,1
    22b2:	00004097          	auipc	ra,0x4
    22b6:	94a080e7          	jalr	-1718(ra) # 5bfc <exit>
      *(char*)a = 99;
    22ba:	fd843783          	ld	a5,-40(s0)
    22be:	06300713          	li	a4,99
    22c2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c6:	fd843603          	ld	a2,-40(s0)
    22ca:	85ca                	mv	a1,s2
    22cc:	00005517          	auipc	a0,0x5
    22d0:	a2450513          	addi	a0,a0,-1500 # 6cf0 <malloc+0xcb4>
    22d4:	00004097          	auipc	ra,0x4
    22d8:	cb0080e7          	jalr	-848(ra) # 5f84 <printf>
      exit(1);
    22dc:	4505                	li	a0,1
    22de:	00004097          	auipc	ra,0x4
    22e2:	91e080e7          	jalr	-1762(ra) # 5bfc <exit>
      exit(1);
    22e6:	4505                	li	a0,1
    22e8:	00004097          	auipc	ra,0x4
    22ec:	914080e7          	jalr	-1772(ra) # 5bfc <exit>

00000000000022f0 <bigargtest>:
{
    22f0:	7179                	addi	sp,sp,-48
    22f2:	f406                	sd	ra,40(sp)
    22f4:	f022                	sd	s0,32(sp)
    22f6:	ec26                	sd	s1,24(sp)
    22f8:	1800                	addi	s0,sp,48
    22fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fc:	00005517          	auipc	a0,0x5
    2300:	a0c50513          	addi	a0,a0,-1524 # 6d08 <malloc+0xccc>
    2304:	00004097          	auipc	ra,0x4
    2308:	948080e7          	jalr	-1720(ra) # 5c4c <unlink>
  pid = fork();
    230c:	00004097          	auipc	ra,0x4
    2310:	8e8080e7          	jalr	-1816(ra) # 5bf4 <fork>
  if(pid == 0){
    2314:	c121                	beqz	a0,2354 <bigargtest+0x64>
  } else if(pid < 0){
    2316:	0a054063          	bltz	a0,23b6 <bigargtest+0xc6>
  wait(&xstatus);
    231a:	fdc40513          	addi	a0,s0,-36
    231e:	00004097          	auipc	ra,0x4
    2322:	8e6080e7          	jalr	-1818(ra) # 5c04 <wait>
  if(xstatus != 0)
    2326:	fdc42503          	lw	a0,-36(s0)
    232a:	e545                	bnez	a0,23d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232c:	4581                	li	a1,0
    232e:	00005517          	auipc	a0,0x5
    2332:	9da50513          	addi	a0,a0,-1574 # 6d08 <malloc+0xccc>
    2336:	00004097          	auipc	ra,0x4
    233a:	906080e7          	jalr	-1786(ra) # 5c3c <open>
  if(fd < 0){
    233e:	08054e63          	bltz	a0,23da <bigargtest+0xea>
  close(fd);
    2342:	00004097          	auipc	ra,0x4
    2346:	8e2080e7          	jalr	-1822(ra) # 5c24 <close>
}
    234a:	70a2                	ld	ra,40(sp)
    234c:	7402                	ld	s0,32(sp)
    234e:	64e2                	ld	s1,24(sp)
    2350:	6145                	addi	sp,sp,48
    2352:	8082                	ret
    2354:	00008797          	auipc	a5,0x8
    2358:	47c78793          	addi	a5,a5,1148 # a7d0 <args.1>
    235c:	00008697          	auipc	a3,0x8
    2360:	56c68693          	addi	a3,a3,1388 # a8c8 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2364:	00005717          	auipc	a4,0x5
    2368:	9b470713          	addi	a4,a4,-1612 # 6d18 <malloc+0xcdc>
    236c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    236e:	07a1                	addi	a5,a5,8
    2370:	fed79ee3          	bne	a5,a3,236c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2374:	00008597          	auipc	a1,0x8
    2378:	45c58593          	addi	a1,a1,1116 # a7d0 <args.1>
    237c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2380:	00004517          	auipc	a0,0x4
    2384:	df850513          	addi	a0,a0,-520 # 6178 <malloc+0x13c>
    2388:	00004097          	auipc	ra,0x4
    238c:	8ac080e7          	jalr	-1876(ra) # 5c34 <exec>
    fd = open("bigarg-ok", O_CREATE);
    2390:	20000593          	li	a1,512
    2394:	00005517          	auipc	a0,0x5
    2398:	97450513          	addi	a0,a0,-1676 # 6d08 <malloc+0xccc>
    239c:	00004097          	auipc	ra,0x4
    23a0:	8a0080e7          	jalr	-1888(ra) # 5c3c <open>
    close(fd);
    23a4:	00004097          	auipc	ra,0x4
    23a8:	880080e7          	jalr	-1920(ra) # 5c24 <close>
    exit(0);
    23ac:	4501                	li	a0,0
    23ae:	00004097          	auipc	ra,0x4
    23b2:	84e080e7          	jalr	-1970(ra) # 5bfc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a4050513          	addi	a0,a0,-1472 # 6df8 <malloc+0xdbc>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	bc4080e7          	jalr	-1084(ra) # 5f84 <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	832080e7          	jalr	-1998(ra) # 5bfc <exit>
    exit(xstatus);
    23d2:	00004097          	auipc	ra,0x4
    23d6:	82a080e7          	jalr	-2006(ra) # 5bfc <exit>
    printf("%s: bigarg test failed!\n", s);
    23da:	85a6                	mv	a1,s1
    23dc:	00005517          	auipc	a0,0x5
    23e0:	a3c50513          	addi	a0,a0,-1476 # 6e18 <malloc+0xddc>
    23e4:	00004097          	auipc	ra,0x4
    23e8:	ba0080e7          	jalr	-1120(ra) # 5f84 <printf>
    exit(1);
    23ec:	4505                	li	a0,1
    23ee:	00004097          	auipc	ra,0x4
    23f2:	80e080e7          	jalr	-2034(ra) # 5bfc <exit>

00000000000023f6 <stacktest>:
{
    23f6:	7179                	addi	sp,sp,-48
    23f8:	f406                	sd	ra,40(sp)
    23fa:	f022                	sd	s0,32(sp)
    23fc:	ec26                	sd	s1,24(sp)
    23fe:	1800                	addi	s0,sp,48
    2400:	84aa                	mv	s1,a0
  pid = fork();
    2402:	00003097          	auipc	ra,0x3
    2406:	7f2080e7          	jalr	2034(ra) # 5bf4 <fork>
  if(pid == 0) {
    240a:	c115                	beqz	a0,242e <stacktest+0x38>
  } else if(pid < 0){
    240c:	04054463          	bltz	a0,2454 <stacktest+0x5e>
  wait(&xstatus);
    2410:	fdc40513          	addi	a0,s0,-36
    2414:	00003097          	auipc	ra,0x3
    2418:	7f0080e7          	jalr	2032(ra) # 5c04 <wait>
  if(xstatus == -1)  // kernel killed child?
    241c:	fdc42503          	lw	a0,-36(s0)
    2420:	57fd                	li	a5,-1
    2422:	04f50763          	beq	a0,a5,2470 <stacktest+0x7a>
    exit(xstatus);
    2426:	00003097          	auipc	ra,0x3
    242a:	7d6080e7          	jalr	2006(ra) # 5bfc <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    242e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2430:	77fd                	lui	a5,0xfffff
    2432:	97ba                	add	a5,a5,a4
    2434:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee018>
    2438:	85a6                	mv	a1,s1
    243a:	00005517          	auipc	a0,0x5
    243e:	9fe50513          	addi	a0,a0,-1538 # 6e38 <malloc+0xdfc>
    2442:	00004097          	auipc	ra,0x4
    2446:	b42080e7          	jalr	-1214(ra) # 5f84 <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	7b0080e7          	jalr	1968(ra) # 5bfc <exit>
    printf("%s: fork failed\n", s);
    2454:	85a6                	mv	a1,s1
    2456:	00004517          	auipc	a0,0x4
    245a:	5aa50513          	addi	a0,a0,1450 # 6a00 <malloc+0x9c4>
    245e:	00004097          	auipc	ra,0x4
    2462:	b26080e7          	jalr	-1242(ra) # 5f84 <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	00003097          	auipc	ra,0x3
    246c:	794080e7          	jalr	1940(ra) # 5bfc <exit>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	78a080e7          	jalr	1930(ra) # 5bfc <exit>

000000000000247a <manywrites>:
{
    247a:	711d                	addi	sp,sp,-96
    247c:	ec86                	sd	ra,88(sp)
    247e:	e8a2                	sd	s0,80(sp)
    2480:	e4a6                	sd	s1,72(sp)
    2482:	e0ca                	sd	s2,64(sp)
    2484:	fc4e                	sd	s3,56(sp)
    2486:	f456                	sd	s5,40(sp)
    2488:	1080                	addi	s0,sp,96
    248a:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    248c:	4981                	li	s3,0
    248e:	4911                	li	s2,4
    int pid = fork();
    2490:	00003097          	auipc	ra,0x3
    2494:	764080e7          	jalr	1892(ra) # 5bf4 <fork>
    2498:	84aa                	mv	s1,a0
    if(pid < 0){
    249a:	02054d63          	bltz	a0,24d4 <manywrites+0x5a>
    if(pid == 0){
    249e:	c939                	beqz	a0,24f4 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    24a0:	2985                	addiw	s3,s3,1
    24a2:	ff2997e3          	bne	s3,s2,2490 <manywrites+0x16>
    24a6:	f852                	sd	s4,48(sp)
    24a8:	f05a                	sd	s6,32(sp)
    24aa:	ec5e                	sd	s7,24(sp)
    24ac:	4491                	li	s1,4
    int st = 0;
    24ae:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24b2:	fa840513          	addi	a0,s0,-88
    24b6:	00003097          	auipc	ra,0x3
    24ba:	74e080e7          	jalr	1870(ra) # 5c04 <wait>
    if(st != 0)
    24be:	fa842503          	lw	a0,-88(s0)
    24c2:	10051463          	bnez	a0,25ca <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    24c6:	34fd                	addiw	s1,s1,-1
    24c8:	f0fd                	bnez	s1,24ae <manywrites+0x34>
  exit(0);
    24ca:	4501                	li	a0,0
    24cc:	00003097          	auipc	ra,0x3
    24d0:	730080e7          	jalr	1840(ra) # 5bfc <exit>
    24d4:	f852                	sd	s4,48(sp)
    24d6:	f05a                	sd	s6,32(sp)
    24d8:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    24da:	00005517          	auipc	a0,0x5
    24de:	92e50513          	addi	a0,a0,-1746 # 6e08 <malloc+0xdcc>
    24e2:	00004097          	auipc	ra,0x4
    24e6:	aa2080e7          	jalr	-1374(ra) # 5f84 <printf>
      exit(1);
    24ea:	4505                	li	a0,1
    24ec:	00003097          	auipc	ra,0x3
    24f0:	710080e7          	jalr	1808(ra) # 5bfc <exit>
    24f4:	f852                	sd	s4,48(sp)
    24f6:	f05a                	sd	s6,32(sp)
    24f8:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    24fa:	06200793          	li	a5,98
    24fe:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2502:	0619879b          	addiw	a5,s3,97
    2506:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    250a:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    250e:	fa840513          	addi	a0,s0,-88
    2512:	00003097          	auipc	ra,0x3
    2516:	73a080e7          	jalr	1850(ra) # 5c4c <unlink>
    251a:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    251c:	0000cb17          	auipc	s6,0xc
    2520:	accb0b13          	addi	s6,s6,-1332 # dfe8 <buf>
        for(int i = 0; i < ci+1; i++){
    2524:	8a26                	mv	s4,s1
    2526:	0209ce63          	bltz	s3,2562 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    252a:	20200593          	li	a1,514
    252e:	fa840513          	addi	a0,s0,-88
    2532:	00003097          	auipc	ra,0x3
    2536:	70a080e7          	jalr	1802(ra) # 5c3c <open>
    253a:	892a                	mv	s2,a0
          if(fd < 0){
    253c:	04054763          	bltz	a0,258a <manywrites+0x110>
          int cc = write(fd, buf, sz);
    2540:	660d                	lui	a2,0x3
    2542:	85da                	mv	a1,s6
    2544:	00003097          	auipc	ra,0x3
    2548:	6d8080e7          	jalr	1752(ra) # 5c1c <write>
          if(cc != sz){
    254c:	678d                	lui	a5,0x3
    254e:	04f51e63          	bne	a0,a5,25aa <manywrites+0x130>
          close(fd);
    2552:	854a                	mv	a0,s2
    2554:	00003097          	auipc	ra,0x3
    2558:	6d0080e7          	jalr	1744(ra) # 5c24 <close>
        for(int i = 0; i < ci+1; i++){
    255c:	2a05                	addiw	s4,s4,1
    255e:	fd49d6e3          	bge	s3,s4,252a <manywrites+0xb0>
        unlink(name);
    2562:	fa840513          	addi	a0,s0,-88
    2566:	00003097          	auipc	ra,0x3
    256a:	6e6080e7          	jalr	1766(ra) # 5c4c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    256e:	3bfd                	addiw	s7,s7,-1
    2570:	fa0b9ae3          	bnez	s7,2524 <manywrites+0xaa>
      unlink(name);
    2574:	fa840513          	addi	a0,s0,-88
    2578:	00003097          	auipc	ra,0x3
    257c:	6d4080e7          	jalr	1748(ra) # 5c4c <unlink>
      exit(0);
    2580:	4501                	li	a0,0
    2582:	00003097          	auipc	ra,0x3
    2586:	67a080e7          	jalr	1658(ra) # 5bfc <exit>
            printf("%s: cannot create %s\n", s, name);
    258a:	fa840613          	addi	a2,s0,-88
    258e:	85d6                	mv	a1,s5
    2590:	00005517          	auipc	a0,0x5
    2594:	8d050513          	addi	a0,a0,-1840 # 6e60 <malloc+0xe24>
    2598:	00004097          	auipc	ra,0x4
    259c:	9ec080e7          	jalr	-1556(ra) # 5f84 <printf>
            exit(1);
    25a0:	4505                	li	a0,1
    25a2:	00003097          	auipc	ra,0x3
    25a6:	65a080e7          	jalr	1626(ra) # 5bfc <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25aa:	86aa                	mv	a3,a0
    25ac:	660d                	lui	a2,0x3
    25ae:	85d6                	mv	a1,s5
    25b0:	00004517          	auipc	a0,0x4
    25b4:	c9850513          	addi	a0,a0,-872 # 6248 <malloc+0x20c>
    25b8:	00004097          	auipc	ra,0x4
    25bc:	9cc080e7          	jalr	-1588(ra) # 5f84 <printf>
            exit(1);
    25c0:	4505                	li	a0,1
    25c2:	00003097          	auipc	ra,0x3
    25c6:	63a080e7          	jalr	1594(ra) # 5bfc <exit>
      exit(st);
    25ca:	00003097          	auipc	ra,0x3
    25ce:	632080e7          	jalr	1586(ra) # 5bfc <exit>

00000000000025d2 <copyinstr3>:
{
    25d2:	7179                	addi	sp,sp,-48
    25d4:	f406                	sd	ra,40(sp)
    25d6:	f022                	sd	s0,32(sp)
    25d8:	ec26                	sd	s1,24(sp)
    25da:	1800                	addi	s0,sp,48
  sbrk(8192);
    25dc:	6509                	lui	a0,0x2
    25de:	00003097          	auipc	ra,0x3
    25e2:	6a6080e7          	jalr	1702(ra) # 5c84 <sbrk>
  uint64 top = (uint64) sbrk(0);
    25e6:	4501                	li	a0,0
    25e8:	00003097          	auipc	ra,0x3
    25ec:	69c080e7          	jalr	1692(ra) # 5c84 <sbrk>
  if((top % PGSIZE) != 0){
    25f0:	03451793          	slli	a5,a0,0x34
    25f4:	e3c9                	bnez	a5,2676 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    25f6:	4501                	li	a0,0
    25f8:	00003097          	auipc	ra,0x3
    25fc:	68c080e7          	jalr	1676(ra) # 5c84 <sbrk>
  if(top % PGSIZE){
    2600:	03451793          	slli	a5,a0,0x34
    2604:	e3d9                	bnez	a5,268a <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2606:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x45>
  *b = 'x';
    260a:	07800793          	li	a5,120
    260e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2612:	8526                	mv	a0,s1
    2614:	00003097          	auipc	ra,0x3
    2618:	638080e7          	jalr	1592(ra) # 5c4c <unlink>
  if(ret != -1){
    261c:	57fd                	li	a5,-1
    261e:	08f51363          	bne	a0,a5,26a4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2622:	20100593          	li	a1,513
    2626:	8526                	mv	a0,s1
    2628:	00003097          	auipc	ra,0x3
    262c:	614080e7          	jalr	1556(ra) # 5c3c <open>
  if(fd != -1){
    2630:	57fd                	li	a5,-1
    2632:	08f51863          	bne	a0,a5,26c2 <copyinstr3+0xf0>
  ret = link(b, b);
    2636:	85a6                	mv	a1,s1
    2638:	8526                	mv	a0,s1
    263a:	00003097          	auipc	ra,0x3
    263e:	622080e7          	jalr	1570(ra) # 5c5c <link>
  if(ret != -1){
    2642:	57fd                	li	a5,-1
    2644:	08f51e63          	bne	a0,a5,26e0 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2648:	00005797          	auipc	a5,0x5
    264c:	51078793          	addi	a5,a5,1296 # 7b58 <malloc+0x1b1c>
    2650:	fcf43823          	sd	a5,-48(s0)
    2654:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2658:	fd040593          	addi	a1,s0,-48
    265c:	8526                	mv	a0,s1
    265e:	00003097          	auipc	ra,0x3
    2662:	5d6080e7          	jalr	1494(ra) # 5c34 <exec>
  if(ret != -1){
    2666:	57fd                	li	a5,-1
    2668:	08f51c63          	bne	a0,a5,2700 <copyinstr3+0x12e>
}
    266c:	70a2                	ld	ra,40(sp)
    266e:	7402                	ld	s0,32(sp)
    2670:	64e2                	ld	s1,24(sp)
    2672:	6145                	addi	sp,sp,48
    2674:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2676:	0347d513          	srli	a0,a5,0x34
    267a:	6785                	lui	a5,0x1
    267c:	40a7853b          	subw	a0,a5,a0
    2680:	00003097          	auipc	ra,0x3
    2684:	604080e7          	jalr	1540(ra) # 5c84 <sbrk>
    2688:	b7bd                	j	25f6 <copyinstr3+0x24>
    printf("oops\n");
    268a:	00004517          	auipc	a0,0x4
    268e:	7ee50513          	addi	a0,a0,2030 # 6e78 <malloc+0xe3c>
    2692:	00004097          	auipc	ra,0x4
    2696:	8f2080e7          	jalr	-1806(ra) # 5f84 <printf>
    exit(1);
    269a:	4505                	li	a0,1
    269c:	00003097          	auipc	ra,0x3
    26a0:	560080e7          	jalr	1376(ra) # 5bfc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26a4:	862a                	mv	a2,a0
    26a6:	85a6                	mv	a1,s1
    26a8:	00004517          	auipc	a0,0x4
    26ac:	27850513          	addi	a0,a0,632 # 6920 <malloc+0x8e4>
    26b0:	00004097          	auipc	ra,0x4
    26b4:	8d4080e7          	jalr	-1836(ra) # 5f84 <printf>
    exit(1);
    26b8:	4505                	li	a0,1
    26ba:	00003097          	auipc	ra,0x3
    26be:	542080e7          	jalr	1346(ra) # 5bfc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26c2:	862a                	mv	a2,a0
    26c4:	85a6                	mv	a1,s1
    26c6:	00004517          	auipc	a0,0x4
    26ca:	27a50513          	addi	a0,a0,634 # 6940 <malloc+0x904>
    26ce:	00004097          	auipc	ra,0x4
    26d2:	8b6080e7          	jalr	-1866(ra) # 5f84 <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	524080e7          	jalr	1316(ra) # 5bfc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    26e0:	86aa                	mv	a3,a0
    26e2:	8626                	mv	a2,s1
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	27a50513          	addi	a0,a0,634 # 6960 <malloc+0x924>
    26ee:	00004097          	auipc	ra,0x4
    26f2:	896080e7          	jalr	-1898(ra) # 5f84 <printf>
    exit(1);
    26f6:	4505                	li	a0,1
    26f8:	00003097          	auipc	ra,0x3
    26fc:	504080e7          	jalr	1284(ra) # 5bfc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2700:	567d                	li	a2,-1
    2702:	85a6                	mv	a1,s1
    2704:	00004517          	auipc	a0,0x4
    2708:	28450513          	addi	a0,a0,644 # 6988 <malloc+0x94c>
    270c:	00004097          	auipc	ra,0x4
    2710:	878080e7          	jalr	-1928(ra) # 5f84 <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	00003097          	auipc	ra,0x3
    271a:	4e6080e7          	jalr	1254(ra) # 5bfc <exit>

000000000000271e <rwsbrk>:
{
    271e:	1101                	addi	sp,sp,-32
    2720:	ec06                	sd	ra,24(sp)
    2722:	e822                	sd	s0,16(sp)
    2724:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2726:	6509                	lui	a0,0x2
    2728:	00003097          	auipc	ra,0x3
    272c:	55c080e7          	jalr	1372(ra) # 5c84 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2730:	57fd                	li	a5,-1
    2732:	06f50463          	beq	a0,a5,279a <rwsbrk+0x7c>
    2736:	e426                	sd	s1,8(sp)
    2738:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    273a:	7579                	lui	a0,0xffffe
    273c:	00003097          	auipc	ra,0x3
    2740:	548080e7          	jalr	1352(ra) # 5c84 <sbrk>
    2744:	57fd                	li	a5,-1
    2746:	06f50963          	beq	a0,a5,27b8 <rwsbrk+0x9a>
    274a:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    274c:	20100593          	li	a1,513
    2750:	00004517          	auipc	a0,0x4
    2754:	76850513          	addi	a0,a0,1896 # 6eb8 <malloc+0xe7c>
    2758:	00003097          	auipc	ra,0x3
    275c:	4e4080e7          	jalr	1252(ra) # 5c3c <open>
    2760:	892a                	mv	s2,a0
  if(fd < 0){
    2762:	06054963          	bltz	a0,27d4 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    2766:	6785                	lui	a5,0x1
    2768:	94be                	add	s1,s1,a5
    276a:	40000613          	li	a2,1024
    276e:	85a6                	mv	a1,s1
    2770:	00003097          	auipc	ra,0x3
    2774:	4ac080e7          	jalr	1196(ra) # 5c1c <write>
    2778:	862a                	mv	a2,a0
  if(n >= 0){
    277a:	06054a63          	bltz	a0,27ee <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    277e:	85a6                	mv	a1,s1
    2780:	00004517          	auipc	a0,0x4
    2784:	75850513          	addi	a0,a0,1880 # 6ed8 <malloc+0xe9c>
    2788:	00003097          	auipc	ra,0x3
    278c:	7fc080e7          	jalr	2044(ra) # 5f84 <printf>
    exit(1);
    2790:	4505                	li	a0,1
    2792:	00003097          	auipc	ra,0x3
    2796:	46a080e7          	jalr	1130(ra) # 5bfc <exit>
    279a:	e426                	sd	s1,8(sp)
    279c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    279e:	00004517          	auipc	a0,0x4
    27a2:	6e250513          	addi	a0,a0,1762 # 6e80 <malloc+0xe44>
    27a6:	00003097          	auipc	ra,0x3
    27aa:	7de080e7          	jalr	2014(ra) # 5f84 <printf>
    exit(1);
    27ae:	4505                	li	a0,1
    27b0:	00003097          	auipc	ra,0x3
    27b4:	44c080e7          	jalr	1100(ra) # 5bfc <exit>
    27b8:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    27ba:	00004517          	auipc	a0,0x4
    27be:	6de50513          	addi	a0,a0,1758 # 6e98 <malloc+0xe5c>
    27c2:	00003097          	auipc	ra,0x3
    27c6:	7c2080e7          	jalr	1986(ra) # 5f84 <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	00003097          	auipc	ra,0x3
    27d0:	430080e7          	jalr	1072(ra) # 5bfc <exit>
    printf("open(rwsbrk) failed\n");
    27d4:	00004517          	auipc	a0,0x4
    27d8:	6ec50513          	addi	a0,a0,1772 # 6ec0 <malloc+0xe84>
    27dc:	00003097          	auipc	ra,0x3
    27e0:	7a8080e7          	jalr	1960(ra) # 5f84 <printf>
    exit(1);
    27e4:	4505                	li	a0,1
    27e6:	00003097          	auipc	ra,0x3
    27ea:	416080e7          	jalr	1046(ra) # 5bfc <exit>
  close(fd);
    27ee:	854a                	mv	a0,s2
    27f0:	00003097          	auipc	ra,0x3
    27f4:	434080e7          	jalr	1076(ra) # 5c24 <close>
  unlink("rwsbrk");
    27f8:	00004517          	auipc	a0,0x4
    27fc:	6c050513          	addi	a0,a0,1728 # 6eb8 <malloc+0xe7c>
    2800:	00003097          	auipc	ra,0x3
    2804:	44c080e7          	jalr	1100(ra) # 5c4c <unlink>
  fd = open("README", O_RDONLY);
    2808:	4581                	li	a1,0
    280a:	00004517          	auipc	a0,0x4
    280e:	b4650513          	addi	a0,a0,-1210 # 6350 <malloc+0x314>
    2812:	00003097          	auipc	ra,0x3
    2816:	42a080e7          	jalr	1066(ra) # 5c3c <open>
    281a:	892a                	mv	s2,a0
  if(fd < 0){
    281c:	02054963          	bltz	a0,284e <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2820:	4629                	li	a2,10
    2822:	85a6                	mv	a1,s1
    2824:	00003097          	auipc	ra,0x3
    2828:	3f0080e7          	jalr	1008(ra) # 5c14 <read>
    282c:	862a                	mv	a2,a0
  if(n >= 0){
    282e:	02054d63          	bltz	a0,2868 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2832:	85a6                	mv	a1,s1
    2834:	00004517          	auipc	a0,0x4
    2838:	6d450513          	addi	a0,a0,1748 # 6f08 <malloc+0xecc>
    283c:	00003097          	auipc	ra,0x3
    2840:	748080e7          	jalr	1864(ra) # 5f84 <printf>
    exit(1);
    2844:	4505                	li	a0,1
    2846:	00003097          	auipc	ra,0x3
    284a:	3b6080e7          	jalr	950(ra) # 5bfc <exit>
    printf("open(rwsbrk) failed\n");
    284e:	00004517          	auipc	a0,0x4
    2852:	67250513          	addi	a0,a0,1650 # 6ec0 <malloc+0xe84>
    2856:	00003097          	auipc	ra,0x3
    285a:	72e080e7          	jalr	1838(ra) # 5f84 <printf>
    exit(1);
    285e:	4505                	li	a0,1
    2860:	00003097          	auipc	ra,0x3
    2864:	39c080e7          	jalr	924(ra) # 5bfc <exit>
  close(fd);
    2868:	854a                	mv	a0,s2
    286a:	00003097          	auipc	ra,0x3
    286e:	3ba080e7          	jalr	954(ra) # 5c24 <close>
  exit(0);
    2872:	4501                	li	a0,0
    2874:	00003097          	auipc	ra,0x3
    2878:	388080e7          	jalr	904(ra) # 5bfc <exit>

000000000000287c <sbrkbasic>:
{
    287c:	7139                	addi	sp,sp,-64
    287e:	fc06                	sd	ra,56(sp)
    2880:	f822                	sd	s0,48(sp)
    2882:	ec4e                	sd	s3,24(sp)
    2884:	0080                	addi	s0,sp,64
    2886:	89aa                	mv	s3,a0
  pid = fork();
    2888:	00003097          	auipc	ra,0x3
    288c:	36c080e7          	jalr	876(ra) # 5bf4 <fork>
  if(pid < 0){
    2890:	02054f63          	bltz	a0,28ce <sbrkbasic+0x52>
  if(pid == 0){
    2894:	e52d                	bnez	a0,28fe <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2896:	40000537          	lui	a0,0x40000
    289a:	00003097          	auipc	ra,0x3
    289e:	3ea080e7          	jalr	1002(ra) # 5c84 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28a2:	57fd                	li	a5,-1
    28a4:	04f50563          	beq	a0,a5,28ee <sbrkbasic+0x72>
    28a8:	f426                	sd	s1,40(sp)
    28aa:	f04a                	sd	s2,32(sp)
    28ac:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    28ae:	400007b7          	lui	a5,0x40000
    28b2:	97aa                	add	a5,a5,a0
      *b = 99;
    28b4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28b8:	6705                	lui	a4,0x1
      *b = 99;
    28ba:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef018>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28be:	953a                	add	a0,a0,a4
    28c0:	fef51de3          	bne	a0,a5,28ba <sbrkbasic+0x3e>
    exit(1);
    28c4:	4505                	li	a0,1
    28c6:	00003097          	auipc	ra,0x3
    28ca:	336080e7          	jalr	822(ra) # 5bfc <exit>
    28ce:	f426                	sd	s1,40(sp)
    28d0:	f04a                	sd	s2,32(sp)
    28d2:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    28d4:	00004517          	auipc	a0,0x4
    28d8:	65c50513          	addi	a0,a0,1628 # 6f30 <malloc+0xef4>
    28dc:	00003097          	auipc	ra,0x3
    28e0:	6a8080e7          	jalr	1704(ra) # 5f84 <printf>
    exit(1);
    28e4:	4505                	li	a0,1
    28e6:	00003097          	auipc	ra,0x3
    28ea:	316080e7          	jalr	790(ra) # 5bfc <exit>
    28ee:	f426                	sd	s1,40(sp)
    28f0:	f04a                	sd	s2,32(sp)
    28f2:	e852                	sd	s4,16(sp)
      exit(0);
    28f4:	4501                	li	a0,0
    28f6:	00003097          	auipc	ra,0x3
    28fa:	306080e7          	jalr	774(ra) # 5bfc <exit>
  wait(&xstatus);
    28fe:	fcc40513          	addi	a0,s0,-52
    2902:	00003097          	auipc	ra,0x3
    2906:	302080e7          	jalr	770(ra) # 5c04 <wait>
  if(xstatus == 1){
    290a:	fcc42703          	lw	a4,-52(s0)
    290e:	4785                	li	a5,1
    2910:	02f70063          	beq	a4,a5,2930 <sbrkbasic+0xb4>
    2914:	f426                	sd	s1,40(sp)
    2916:	f04a                	sd	s2,32(sp)
    2918:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    291a:	4501                	li	a0,0
    291c:	00003097          	auipc	ra,0x3
    2920:	368080e7          	jalr	872(ra) # 5c84 <sbrk>
    2924:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2926:	4901                	li	s2,0
    2928:	6a05                	lui	s4,0x1
    292a:	388a0a13          	addi	s4,s4,904 # 1388 <badarg+0x3e>
    292e:	a01d                	j	2954 <sbrkbasic+0xd8>
    2930:	f426                	sd	s1,40(sp)
    2932:	f04a                	sd	s2,32(sp)
    2934:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2936:	85ce                	mv	a1,s3
    2938:	00004517          	auipc	a0,0x4
    293c:	61850513          	addi	a0,a0,1560 # 6f50 <malloc+0xf14>
    2940:	00003097          	auipc	ra,0x3
    2944:	644080e7          	jalr	1604(ra) # 5f84 <printf>
    exit(1);
    2948:	4505                	li	a0,1
    294a:	00003097          	auipc	ra,0x3
    294e:	2b2080e7          	jalr	690(ra) # 5bfc <exit>
    2952:	84be                	mv	s1,a5
    b = sbrk(1);
    2954:	4505                	li	a0,1
    2956:	00003097          	auipc	ra,0x3
    295a:	32e080e7          	jalr	814(ra) # 5c84 <sbrk>
    if(b != a){
    295e:	04951c63          	bne	a0,s1,29b6 <sbrkbasic+0x13a>
    *b = 1;
    2962:	4785                	li	a5,1
    2964:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2968:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    296c:	2905                	addiw	s2,s2,1
    296e:	ff4912e3          	bne	s2,s4,2952 <sbrkbasic+0xd6>
  pid = fork();
    2972:	00003097          	auipc	ra,0x3
    2976:	282080e7          	jalr	642(ra) # 5bf4 <fork>
    297a:	892a                	mv	s2,a0
  if(pid < 0){
    297c:	04054e63          	bltz	a0,29d8 <sbrkbasic+0x15c>
  c = sbrk(1);
    2980:	4505                	li	a0,1
    2982:	00003097          	auipc	ra,0x3
    2986:	302080e7          	jalr	770(ra) # 5c84 <sbrk>
  c = sbrk(1);
    298a:	4505                	li	a0,1
    298c:	00003097          	auipc	ra,0x3
    2990:	2f8080e7          	jalr	760(ra) # 5c84 <sbrk>
  if(c != a + 1){
    2994:	0489                	addi	s1,s1,2
    2996:	04a48f63          	beq	s1,a0,29f4 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    299a:	85ce                	mv	a1,s3
    299c:	00004517          	auipc	a0,0x4
    29a0:	61450513          	addi	a0,a0,1556 # 6fb0 <malloc+0xf74>
    29a4:	00003097          	auipc	ra,0x3
    29a8:	5e0080e7          	jalr	1504(ra) # 5f84 <printf>
    exit(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	24e080e7          	jalr	590(ra) # 5bfc <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29b6:	872a                	mv	a4,a0
    29b8:	86a6                	mv	a3,s1
    29ba:	864a                	mv	a2,s2
    29bc:	85ce                	mv	a1,s3
    29be:	00004517          	auipc	a0,0x4
    29c2:	5b250513          	addi	a0,a0,1458 # 6f70 <malloc+0xf34>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	5be080e7          	jalr	1470(ra) # 5f84 <printf>
      exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	22c080e7          	jalr	556(ra) # 5bfc <exit>
    printf("%s: sbrk test fork failed\n", s);
    29d8:	85ce                	mv	a1,s3
    29da:	00004517          	auipc	a0,0x4
    29de:	5b650513          	addi	a0,a0,1462 # 6f90 <malloc+0xf54>
    29e2:	00003097          	auipc	ra,0x3
    29e6:	5a2080e7          	jalr	1442(ra) # 5f84 <printf>
    exit(1);
    29ea:	4505                	li	a0,1
    29ec:	00003097          	auipc	ra,0x3
    29f0:	210080e7          	jalr	528(ra) # 5bfc <exit>
  if(pid == 0)
    29f4:	00091763          	bnez	s2,2a02 <sbrkbasic+0x186>
    exit(0);
    29f8:	4501                	li	a0,0
    29fa:	00003097          	auipc	ra,0x3
    29fe:	202080e7          	jalr	514(ra) # 5bfc <exit>
  wait(&xstatus);
    2a02:	fcc40513          	addi	a0,s0,-52
    2a06:	00003097          	auipc	ra,0x3
    2a0a:	1fe080e7          	jalr	510(ra) # 5c04 <wait>
  exit(xstatus);
    2a0e:	fcc42503          	lw	a0,-52(s0)
    2a12:	00003097          	auipc	ra,0x3
    2a16:	1ea080e7          	jalr	490(ra) # 5bfc <exit>

0000000000002a1a <sbrkmuch>:
{
    2a1a:	7179                	addi	sp,sp,-48
    2a1c:	f406                	sd	ra,40(sp)
    2a1e:	f022                	sd	s0,32(sp)
    2a20:	ec26                	sd	s1,24(sp)
    2a22:	e84a                	sd	s2,16(sp)
    2a24:	e44e                	sd	s3,8(sp)
    2a26:	e052                	sd	s4,0(sp)
    2a28:	1800                	addi	s0,sp,48
    2a2a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a2c:	4501                	li	a0,0
    2a2e:	00003097          	auipc	ra,0x3
    2a32:	256080e7          	jalr	598(ra) # 5c84 <sbrk>
    2a36:	892a                	mv	s2,a0
  a = sbrk(0);
    2a38:	4501                	li	a0,0
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	24a080e7          	jalr	586(ra) # 5c84 <sbrk>
    2a42:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a44:	06400537          	lui	a0,0x6400
    2a48:	9d05                	subw	a0,a0,s1
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	23a080e7          	jalr	570(ra) # 5c84 <sbrk>
  if (p != a) {
    2a52:	0ca49863          	bne	s1,a0,2b22 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a56:	4501                	li	a0,0
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	22c080e7          	jalr	556(ra) # 5c84 <sbrk>
    2a60:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a62:	00a4f963          	bgeu	s1,a0,2a74 <sbrkmuch+0x5a>
    *pp = 1;
    2a66:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a68:	6705                	lui	a4,0x1
    *pp = 1;
    2a6a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a6e:	94ba                	add	s1,s1,a4
    2a70:	fef4ede3          	bltu	s1,a5,2a6a <sbrkmuch+0x50>
  *lastaddr = 99;
    2a74:	064007b7          	lui	a5,0x6400
    2a78:	06300713          	li	a4,99
    2a7c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef017>
  a = sbrk(0);
    2a80:	4501                	li	a0,0
    2a82:	00003097          	auipc	ra,0x3
    2a86:	202080e7          	jalr	514(ra) # 5c84 <sbrk>
    2a8a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2a8c:	757d                	lui	a0,0xfffff
    2a8e:	00003097          	auipc	ra,0x3
    2a92:	1f6080e7          	jalr	502(ra) # 5c84 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2a96:	57fd                	li	a5,-1
    2a98:	0af50363          	beq	a0,a5,2b3e <sbrkmuch+0x124>
  c = sbrk(0);
    2a9c:	4501                	li	a0,0
    2a9e:	00003097          	auipc	ra,0x3
    2aa2:	1e6080e7          	jalr	486(ra) # 5c84 <sbrk>
  if(c != a - PGSIZE){
    2aa6:	77fd                	lui	a5,0xfffff
    2aa8:	97a6                	add	a5,a5,s1
    2aaa:	0af51863          	bne	a0,a5,2b5a <sbrkmuch+0x140>
  a = sbrk(0);
    2aae:	4501                	li	a0,0
    2ab0:	00003097          	auipc	ra,0x3
    2ab4:	1d4080e7          	jalr	468(ra) # 5c84 <sbrk>
    2ab8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2aba:	6505                	lui	a0,0x1
    2abc:	00003097          	auipc	ra,0x3
    2ac0:	1c8080e7          	jalr	456(ra) # 5c84 <sbrk>
    2ac4:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ac6:	0aa49a63          	bne	s1,a0,2b7a <sbrkmuch+0x160>
    2aca:	4501                	li	a0,0
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	1b8080e7          	jalr	440(ra) # 5c84 <sbrk>
    2ad4:	6785                	lui	a5,0x1
    2ad6:	97a6                	add	a5,a5,s1
    2ad8:	0af51163          	bne	a0,a5,2b7a <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2adc:	064007b7          	lui	a5,0x6400
    2ae0:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef017>
    2ae4:	06300793          	li	a5,99
    2ae8:	0af70963          	beq	a4,a5,2b9a <sbrkmuch+0x180>
  a = sbrk(0);
    2aec:	4501                	li	a0,0
    2aee:	00003097          	auipc	ra,0x3
    2af2:	196080e7          	jalr	406(ra) # 5c84 <sbrk>
    2af6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2af8:	4501                	li	a0,0
    2afa:	00003097          	auipc	ra,0x3
    2afe:	18a080e7          	jalr	394(ra) # 5c84 <sbrk>
    2b02:	40a9053b          	subw	a0,s2,a0
    2b06:	00003097          	auipc	ra,0x3
    2b0a:	17e080e7          	jalr	382(ra) # 5c84 <sbrk>
  if(c != a){
    2b0e:	0aa49463          	bne	s1,a0,2bb6 <sbrkmuch+0x19c>
}
    2b12:	70a2                	ld	ra,40(sp)
    2b14:	7402                	ld	s0,32(sp)
    2b16:	64e2                	ld	s1,24(sp)
    2b18:	6942                	ld	s2,16(sp)
    2b1a:	69a2                	ld	s3,8(sp)
    2b1c:	6a02                	ld	s4,0(sp)
    2b1e:	6145                	addi	sp,sp,48
    2b20:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b22:	85ce                	mv	a1,s3
    2b24:	00004517          	auipc	a0,0x4
    2b28:	4ac50513          	addi	a0,a0,1196 # 6fd0 <malloc+0xf94>
    2b2c:	00003097          	auipc	ra,0x3
    2b30:	458080e7          	jalr	1112(ra) # 5f84 <printf>
    exit(1);
    2b34:	4505                	li	a0,1
    2b36:	00003097          	auipc	ra,0x3
    2b3a:	0c6080e7          	jalr	198(ra) # 5bfc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b3e:	85ce                	mv	a1,s3
    2b40:	00004517          	auipc	a0,0x4
    2b44:	4d850513          	addi	a0,a0,1240 # 7018 <malloc+0xfdc>
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	43c080e7          	jalr	1084(ra) # 5f84 <printf>
    exit(1);
    2b50:	4505                	li	a0,1
    2b52:	00003097          	auipc	ra,0x3
    2b56:	0aa080e7          	jalr	170(ra) # 5bfc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b5a:	86aa                	mv	a3,a0
    2b5c:	8626                	mv	a2,s1
    2b5e:	85ce                	mv	a1,s3
    2b60:	00004517          	auipc	a0,0x4
    2b64:	4d850513          	addi	a0,a0,1240 # 7038 <malloc+0xffc>
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	41c080e7          	jalr	1052(ra) # 5f84 <printf>
    exit(1);
    2b70:	4505                	li	a0,1
    2b72:	00003097          	auipc	ra,0x3
    2b76:	08a080e7          	jalr	138(ra) # 5bfc <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b7a:	86d2                	mv	a3,s4
    2b7c:	8626                	mv	a2,s1
    2b7e:	85ce                	mv	a1,s3
    2b80:	00004517          	auipc	a0,0x4
    2b84:	4f850513          	addi	a0,a0,1272 # 7078 <malloc+0x103c>
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	3fc080e7          	jalr	1020(ra) # 5f84 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	00003097          	auipc	ra,0x3
    2b96:	06a080e7          	jalr	106(ra) # 5bfc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2b9a:	85ce                	mv	a1,s3
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	50c50513          	addi	a0,a0,1292 # 70a8 <malloc+0x106c>
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	3e0080e7          	jalr	992(ra) # 5f84 <printf>
    exit(1);
    2bac:	4505                	li	a0,1
    2bae:	00003097          	auipc	ra,0x3
    2bb2:	04e080e7          	jalr	78(ra) # 5bfc <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bb6:	86aa                	mv	a3,a0
    2bb8:	8626                	mv	a2,s1
    2bba:	85ce                	mv	a1,s3
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	52450513          	addi	a0,a0,1316 # 70e0 <malloc+0x10a4>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	3c0080e7          	jalr	960(ra) # 5f84 <printf>
    exit(1);
    2bcc:	4505                	li	a0,1
    2bce:	00003097          	auipc	ra,0x3
    2bd2:	02e080e7          	jalr	46(ra) # 5bfc <exit>

0000000000002bd6 <sbrkarg>:
{
    2bd6:	7179                	addi	sp,sp,-48
    2bd8:	f406                	sd	ra,40(sp)
    2bda:	f022                	sd	s0,32(sp)
    2bdc:	ec26                	sd	s1,24(sp)
    2bde:	e84a                	sd	s2,16(sp)
    2be0:	e44e                	sd	s3,8(sp)
    2be2:	1800                	addi	s0,sp,48
    2be4:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2be6:	6505                	lui	a0,0x1
    2be8:	00003097          	auipc	ra,0x3
    2bec:	09c080e7          	jalr	156(ra) # 5c84 <sbrk>
    2bf0:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2bf2:	20100593          	li	a1,513
    2bf6:	00004517          	auipc	a0,0x4
    2bfa:	51250513          	addi	a0,a0,1298 # 7108 <malloc+0x10cc>
    2bfe:	00003097          	auipc	ra,0x3
    2c02:	03e080e7          	jalr	62(ra) # 5c3c <open>
    2c06:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c08:	00004517          	auipc	a0,0x4
    2c0c:	50050513          	addi	a0,a0,1280 # 7108 <malloc+0x10cc>
    2c10:	00003097          	auipc	ra,0x3
    2c14:	03c080e7          	jalr	60(ra) # 5c4c <unlink>
  if(fd < 0)  {
    2c18:	0404c163          	bltz	s1,2c5a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c1c:	6605                	lui	a2,0x1
    2c1e:	85ca                	mv	a1,s2
    2c20:	8526                	mv	a0,s1
    2c22:	00003097          	auipc	ra,0x3
    2c26:	ffa080e7          	jalr	-6(ra) # 5c1c <write>
    2c2a:	04054663          	bltz	a0,2c76 <sbrkarg+0xa0>
  close(fd);
    2c2e:	8526                	mv	a0,s1
    2c30:	00003097          	auipc	ra,0x3
    2c34:	ff4080e7          	jalr	-12(ra) # 5c24 <close>
  a = sbrk(PGSIZE);
    2c38:	6505                	lui	a0,0x1
    2c3a:	00003097          	auipc	ra,0x3
    2c3e:	04a080e7          	jalr	74(ra) # 5c84 <sbrk>
  if(pipe((int *) a) != 0){
    2c42:	00003097          	auipc	ra,0x3
    2c46:	fca080e7          	jalr	-54(ra) # 5c0c <pipe>
    2c4a:	e521                	bnez	a0,2c92 <sbrkarg+0xbc>
}
    2c4c:	70a2                	ld	ra,40(sp)
    2c4e:	7402                	ld	s0,32(sp)
    2c50:	64e2                	ld	s1,24(sp)
    2c52:	6942                	ld	s2,16(sp)
    2c54:	69a2                	ld	s3,8(sp)
    2c56:	6145                	addi	sp,sp,48
    2c58:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c5a:	85ce                	mv	a1,s3
    2c5c:	00004517          	auipc	a0,0x4
    2c60:	4b450513          	addi	a0,a0,1204 # 7110 <malloc+0x10d4>
    2c64:	00003097          	auipc	ra,0x3
    2c68:	320080e7          	jalr	800(ra) # 5f84 <printf>
    exit(1);
    2c6c:	4505                	li	a0,1
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	f8e080e7          	jalr	-114(ra) # 5bfc <exit>
    printf("%s: write sbrk failed\n", s);
    2c76:	85ce                	mv	a1,s3
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	4b050513          	addi	a0,a0,1200 # 7128 <malloc+0x10ec>
    2c80:	00003097          	auipc	ra,0x3
    2c84:	304080e7          	jalr	772(ra) # 5f84 <printf>
    exit(1);
    2c88:	4505                	li	a0,1
    2c8a:	00003097          	auipc	ra,0x3
    2c8e:	f72080e7          	jalr	-142(ra) # 5bfc <exit>
    printf("%s: pipe() failed\n", s);
    2c92:	85ce                	mv	a1,s3
    2c94:	00004517          	auipc	a0,0x4
    2c98:	e7450513          	addi	a0,a0,-396 # 6b08 <malloc+0xacc>
    2c9c:	00003097          	auipc	ra,0x3
    2ca0:	2e8080e7          	jalr	744(ra) # 5f84 <printf>
    exit(1);
    2ca4:	4505                	li	a0,1
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	f56080e7          	jalr	-170(ra) # 5bfc <exit>

0000000000002cae <argptest>:
{
    2cae:	1101                	addi	sp,sp,-32
    2cb0:	ec06                	sd	ra,24(sp)
    2cb2:	e822                	sd	s0,16(sp)
    2cb4:	e426                	sd	s1,8(sp)
    2cb6:	e04a                	sd	s2,0(sp)
    2cb8:	1000                	addi	s0,sp,32
    2cba:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cbc:	4581                	li	a1,0
    2cbe:	00004517          	auipc	a0,0x4
    2cc2:	48250513          	addi	a0,a0,1154 # 7140 <malloc+0x1104>
    2cc6:	00003097          	auipc	ra,0x3
    2cca:	f76080e7          	jalr	-138(ra) # 5c3c <open>
  if (fd < 0) {
    2cce:	02054b63          	bltz	a0,2d04 <argptest+0x56>
    2cd2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cd4:	4501                	li	a0,0
    2cd6:	00003097          	auipc	ra,0x3
    2cda:	fae080e7          	jalr	-82(ra) # 5c84 <sbrk>
    2cde:	567d                	li	a2,-1
    2ce0:	fff50593          	addi	a1,a0,-1
    2ce4:	8526                	mv	a0,s1
    2ce6:	00003097          	auipc	ra,0x3
    2cea:	f2e080e7          	jalr	-210(ra) # 5c14 <read>
  close(fd);
    2cee:	8526                	mv	a0,s1
    2cf0:	00003097          	auipc	ra,0x3
    2cf4:	f34080e7          	jalr	-204(ra) # 5c24 <close>
}
    2cf8:	60e2                	ld	ra,24(sp)
    2cfa:	6442                	ld	s0,16(sp)
    2cfc:	64a2                	ld	s1,8(sp)
    2cfe:	6902                	ld	s2,0(sp)
    2d00:	6105                	addi	sp,sp,32
    2d02:	8082                	ret
    printf("%s: open failed\n", s);
    2d04:	85ca                	mv	a1,s2
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	d1250513          	addi	a0,a0,-750 # 6a18 <malloc+0x9dc>
    2d0e:	00003097          	auipc	ra,0x3
    2d12:	276080e7          	jalr	630(ra) # 5f84 <printf>
    exit(1);
    2d16:	4505                	li	a0,1
    2d18:	00003097          	auipc	ra,0x3
    2d1c:	ee4080e7          	jalr	-284(ra) # 5bfc <exit>

0000000000002d20 <sbrkbugs>:
{
    2d20:	1141                	addi	sp,sp,-16
    2d22:	e406                	sd	ra,8(sp)
    2d24:	e022                	sd	s0,0(sp)
    2d26:	0800                	addi	s0,sp,16
  int pid = fork();
    2d28:	00003097          	auipc	ra,0x3
    2d2c:	ecc080e7          	jalr	-308(ra) # 5bf4 <fork>
  if(pid < 0){
    2d30:	02054263          	bltz	a0,2d54 <sbrkbugs+0x34>
  if(pid == 0){
    2d34:	ed0d                	bnez	a0,2d6e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d36:	00003097          	auipc	ra,0x3
    2d3a:	f4e080e7          	jalr	-178(ra) # 5c84 <sbrk>
    sbrk(-sz);
    2d3e:	40a0053b          	negw	a0,a0
    2d42:	00003097          	auipc	ra,0x3
    2d46:	f42080e7          	jalr	-190(ra) # 5c84 <sbrk>
    exit(0);
    2d4a:	4501                	li	a0,0
    2d4c:	00003097          	auipc	ra,0x3
    2d50:	eb0080e7          	jalr	-336(ra) # 5bfc <exit>
    printf("fork failed\n");
    2d54:	00004517          	auipc	a0,0x4
    2d58:	0b450513          	addi	a0,a0,180 # 6e08 <malloc+0xdcc>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	228080e7          	jalr	552(ra) # 5f84 <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	e96080e7          	jalr	-362(ra) # 5bfc <exit>
  wait(0);
    2d6e:	4501                	li	a0,0
    2d70:	00003097          	auipc	ra,0x3
    2d74:	e94080e7          	jalr	-364(ra) # 5c04 <wait>
  pid = fork();
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	e7c080e7          	jalr	-388(ra) # 5bf4 <fork>
  if(pid < 0){
    2d80:	02054563          	bltz	a0,2daa <sbrkbugs+0x8a>
  if(pid == 0){
    2d84:	e121                	bnez	a0,2dc4 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	efe080e7          	jalr	-258(ra) # 5c84 <sbrk>
    sbrk(-(sz - 3500));
    2d8e:	6785                	lui	a5,0x1
    2d90:	dac7879b          	addiw	a5,a5,-596 # dac <unlinkread+0x6e>
    2d94:	40a7853b          	subw	a0,a5,a0
    2d98:	00003097          	auipc	ra,0x3
    2d9c:	eec080e7          	jalr	-276(ra) # 5c84 <sbrk>
    exit(0);
    2da0:	4501                	li	a0,0
    2da2:	00003097          	auipc	ra,0x3
    2da6:	e5a080e7          	jalr	-422(ra) # 5bfc <exit>
    printf("fork failed\n");
    2daa:	00004517          	auipc	a0,0x4
    2dae:	05e50513          	addi	a0,a0,94 # 6e08 <malloc+0xdcc>
    2db2:	00003097          	auipc	ra,0x3
    2db6:	1d2080e7          	jalr	466(ra) # 5f84 <printf>
    exit(1);
    2dba:	4505                	li	a0,1
    2dbc:	00003097          	auipc	ra,0x3
    2dc0:	e40080e7          	jalr	-448(ra) # 5bfc <exit>
  wait(0);
    2dc4:	4501                	li	a0,0
    2dc6:	00003097          	auipc	ra,0x3
    2dca:	e3e080e7          	jalr	-450(ra) # 5c04 <wait>
  pid = fork();
    2dce:	00003097          	auipc	ra,0x3
    2dd2:	e26080e7          	jalr	-474(ra) # 5bf4 <fork>
  if(pid < 0){
    2dd6:	02054a63          	bltz	a0,2e0a <sbrkbugs+0xea>
  if(pid == 0){
    2dda:	e529                	bnez	a0,2e24 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2ddc:	00003097          	auipc	ra,0x3
    2de0:	ea8080e7          	jalr	-344(ra) # 5c84 <sbrk>
    2de4:	67ad                	lui	a5,0xb
    2de6:	8007879b          	addiw	a5,a5,-2048 # a800 <args.1+0x30>
    2dea:	40a7853b          	subw	a0,a5,a0
    2dee:	00003097          	auipc	ra,0x3
    2df2:	e96080e7          	jalr	-362(ra) # 5c84 <sbrk>
    sbrk(-10);
    2df6:	5559                	li	a0,-10
    2df8:	00003097          	auipc	ra,0x3
    2dfc:	e8c080e7          	jalr	-372(ra) # 5c84 <sbrk>
    exit(0);
    2e00:	4501                	li	a0,0
    2e02:	00003097          	auipc	ra,0x3
    2e06:	dfa080e7          	jalr	-518(ra) # 5bfc <exit>
    printf("fork failed\n");
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	ffe50513          	addi	a0,a0,-2 # 6e08 <malloc+0xdcc>
    2e12:	00003097          	auipc	ra,0x3
    2e16:	172080e7          	jalr	370(ra) # 5f84 <printf>
    exit(1);
    2e1a:	4505                	li	a0,1
    2e1c:	00003097          	auipc	ra,0x3
    2e20:	de0080e7          	jalr	-544(ra) # 5bfc <exit>
  wait(0);
    2e24:	4501                	li	a0,0
    2e26:	00003097          	auipc	ra,0x3
    2e2a:	dde080e7          	jalr	-546(ra) # 5c04 <wait>
  exit(0);
    2e2e:	4501                	li	a0,0
    2e30:	00003097          	auipc	ra,0x3
    2e34:	dcc080e7          	jalr	-564(ra) # 5bfc <exit>

0000000000002e38 <sbrklast>:
{
    2e38:	7179                	addi	sp,sp,-48
    2e3a:	f406                	sd	ra,40(sp)
    2e3c:	f022                	sd	s0,32(sp)
    2e3e:	ec26                	sd	s1,24(sp)
    2e40:	e84a                	sd	s2,16(sp)
    2e42:	e44e                	sd	s3,8(sp)
    2e44:	e052                	sd	s4,0(sp)
    2e46:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e48:	4501                	li	a0,0
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	e3a080e7          	jalr	-454(ra) # 5c84 <sbrk>
  if((top % 4096) != 0)
    2e52:	03451793          	slli	a5,a0,0x34
    2e56:	ebd9                	bnez	a5,2eec <sbrklast+0xb4>
  sbrk(4096);
    2e58:	6505                	lui	a0,0x1
    2e5a:	00003097          	auipc	ra,0x3
    2e5e:	e2a080e7          	jalr	-470(ra) # 5c84 <sbrk>
  sbrk(10);
    2e62:	4529                	li	a0,10
    2e64:	00003097          	auipc	ra,0x3
    2e68:	e20080e7          	jalr	-480(ra) # 5c84 <sbrk>
  sbrk(-20);
    2e6c:	5531                	li	a0,-20
    2e6e:	00003097          	auipc	ra,0x3
    2e72:	e16080e7          	jalr	-490(ra) # 5c84 <sbrk>
  top = (uint64) sbrk(0);
    2e76:	4501                	li	a0,0
    2e78:	00003097          	auipc	ra,0x3
    2e7c:	e0c080e7          	jalr	-500(ra) # 5c84 <sbrk>
    2e80:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2e82:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2e86:	07800a13          	li	s4,120
    2e8a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2e8e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2e92:	20200593          	li	a1,514
    2e96:	854a                	mv	a0,s2
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	da4080e7          	jalr	-604(ra) # 5c3c <open>
    2ea0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ea2:	4605                	li	a2,1
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00003097          	auipc	ra,0x3
    2eaa:	d76080e7          	jalr	-650(ra) # 5c1c <write>
  close(fd);
    2eae:	854e                	mv	a0,s3
    2eb0:	00003097          	auipc	ra,0x3
    2eb4:	d74080e7          	jalr	-652(ra) # 5c24 <close>
  fd = open(p, O_RDWR);
    2eb8:	4589                	li	a1,2
    2eba:	854a                	mv	a0,s2
    2ebc:	00003097          	auipc	ra,0x3
    2ec0:	d80080e7          	jalr	-640(ra) # 5c3c <open>
  p[0] = '\0';
    2ec4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ec8:	4605                	li	a2,1
    2eca:	85ca                	mv	a1,s2
    2ecc:	00003097          	auipc	ra,0x3
    2ed0:	d48080e7          	jalr	-696(ra) # 5c14 <read>
  if(p[0] != 'x')
    2ed4:	fc04c783          	lbu	a5,-64(s1)
    2ed8:	03479463          	bne	a5,s4,2f00 <sbrklast+0xc8>
}
    2edc:	70a2                	ld	ra,40(sp)
    2ede:	7402                	ld	s0,32(sp)
    2ee0:	64e2                	ld	s1,24(sp)
    2ee2:	6942                	ld	s2,16(sp)
    2ee4:	69a2                	ld	s3,8(sp)
    2ee6:	6a02                	ld	s4,0(sp)
    2ee8:	6145                	addi	sp,sp,48
    2eea:	8082                	ret
    sbrk(4096 - (top % 4096));
    2eec:	0347d513          	srli	a0,a5,0x34
    2ef0:	6785                	lui	a5,0x1
    2ef2:	40a7853b          	subw	a0,a5,a0
    2ef6:	00003097          	auipc	ra,0x3
    2efa:	d8e080e7          	jalr	-626(ra) # 5c84 <sbrk>
    2efe:	bfa9                	j	2e58 <sbrklast+0x20>
    exit(1);
    2f00:	4505                	li	a0,1
    2f02:	00003097          	auipc	ra,0x3
    2f06:	cfa080e7          	jalr	-774(ra) # 5bfc <exit>

0000000000002f0a <sbrk8000>:
{
    2f0a:	1141                	addi	sp,sp,-16
    2f0c:	e406                	sd	ra,8(sp)
    2f0e:	e022                	sd	s0,0(sp)
    2f10:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f12:	80000537          	lui	a0,0x80000
    2f16:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef01c>
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	d6c080e7          	jalr	-660(ra) # 5c84 <sbrk>
  volatile char *top = sbrk(0);
    2f20:	4501                	li	a0,0
    2f22:	00003097          	auipc	ra,0x3
    2f26:	d62080e7          	jalr	-670(ra) # 5c84 <sbrk>
  *(top-1) = *(top-1) + 1;
    2f2a:	fff54783          	lbu	a5,-1(a0)
    2f2e:	2785                	addiw	a5,a5,1 # 1001 <linktest+0x10d>
    2f30:	0ff7f793          	zext.b	a5,a5
    2f34:	fef50fa3          	sb	a5,-1(a0)
}
    2f38:	60a2                	ld	ra,8(sp)
    2f3a:	6402                	ld	s0,0(sp)
    2f3c:	0141                	addi	sp,sp,16
    2f3e:	8082                	ret

0000000000002f40 <execout>:
{
    2f40:	715d                	addi	sp,sp,-80
    2f42:	e486                	sd	ra,72(sp)
    2f44:	e0a2                	sd	s0,64(sp)
    2f46:	fc26                	sd	s1,56(sp)
    2f48:	f84a                	sd	s2,48(sp)
    2f4a:	f44e                	sd	s3,40(sp)
    2f4c:	f052                	sd	s4,32(sp)
    2f4e:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f50:	4901                	li	s2,0
    2f52:	49bd                	li	s3,15
    int pid = fork();
    2f54:	00003097          	auipc	ra,0x3
    2f58:	ca0080e7          	jalr	-864(ra) # 5bf4 <fork>
    2f5c:	84aa                	mv	s1,a0
    if(pid < 0){
    2f5e:	02054063          	bltz	a0,2f7e <execout+0x3e>
    } else if(pid == 0){
    2f62:	c91d                	beqz	a0,2f98 <execout+0x58>
      wait((int*)0);
    2f64:	4501                	li	a0,0
    2f66:	00003097          	auipc	ra,0x3
    2f6a:	c9e080e7          	jalr	-866(ra) # 5c04 <wait>
  for(int avail = 0; avail < 15; avail++){
    2f6e:	2905                	addiw	s2,s2,1
    2f70:	ff3912e3          	bne	s2,s3,2f54 <execout+0x14>
  exit(0);
    2f74:	4501                	li	a0,0
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	c86080e7          	jalr	-890(ra) # 5bfc <exit>
      printf("fork failed\n");
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	e8a50513          	addi	a0,a0,-374 # 6e08 <malloc+0xdcc>
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	ffe080e7          	jalr	-2(ra) # 5f84 <printf>
      exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	00003097          	auipc	ra,0x3
    2f94:	c6c080e7          	jalr	-916(ra) # 5bfc <exit>
        if(a == 0xffffffffffffffffLL)
    2f98:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2f9a:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2f9c:	6505                	lui	a0,0x1
    2f9e:	00003097          	auipc	ra,0x3
    2fa2:	ce6080e7          	jalr	-794(ra) # 5c84 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fa6:	01350763          	beq	a0,s3,2fb4 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2faa:	6785                	lui	a5,0x1
    2fac:	97aa                	add	a5,a5,a0
    2fae:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while(1){
    2fb2:	b7ed                	j	2f9c <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fb4:	01205a63          	blez	s2,2fc8 <execout+0x88>
        sbrk(-4096);
    2fb8:	757d                	lui	a0,0xfffff
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	cca080e7          	jalr	-822(ra) # 5c84 <sbrk>
      for(int i = 0; i < avail; i++)
    2fc2:	2485                	addiw	s1,s1,1
    2fc4:	ff249ae3          	bne	s1,s2,2fb8 <execout+0x78>
      close(1);
    2fc8:	4505                	li	a0,1
    2fca:	00003097          	auipc	ra,0x3
    2fce:	c5a080e7          	jalr	-934(ra) # 5c24 <close>
      char *args[] = { "echo", "x", 0 };
    2fd2:	00003517          	auipc	a0,0x3
    2fd6:	1a650513          	addi	a0,a0,422 # 6178 <malloc+0x13c>
    2fda:	faa43c23          	sd	a0,-72(s0)
    2fde:	00003797          	auipc	a5,0x3
    2fe2:	20a78793          	addi	a5,a5,522 # 61e8 <malloc+0x1ac>
    2fe6:	fcf43023          	sd	a5,-64(s0)
    2fea:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2fee:	fb840593          	addi	a1,s0,-72
    2ff2:	00003097          	auipc	ra,0x3
    2ff6:	c42080e7          	jalr	-958(ra) # 5c34 <exec>
      exit(0);
    2ffa:	4501                	li	a0,0
    2ffc:	00003097          	auipc	ra,0x3
    3000:	c00080e7          	jalr	-1024(ra) # 5bfc <exit>

0000000000003004 <fourteen>:
{
    3004:	1101                	addi	sp,sp,-32
    3006:	ec06                	sd	ra,24(sp)
    3008:	e822                	sd	s0,16(sp)
    300a:	e426                	sd	s1,8(sp)
    300c:	1000                	addi	s0,sp,32
    300e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3010:	00004517          	auipc	a0,0x4
    3014:	30850513          	addi	a0,a0,776 # 7318 <malloc+0x12dc>
    3018:	00003097          	auipc	ra,0x3
    301c:	c4c080e7          	jalr	-948(ra) # 5c64 <mkdir>
    3020:	e165                	bnez	a0,3100 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3022:	00004517          	auipc	a0,0x4
    3026:	14e50513          	addi	a0,a0,334 # 7170 <malloc+0x1134>
    302a:	00003097          	auipc	ra,0x3
    302e:	c3a080e7          	jalr	-966(ra) # 5c64 <mkdir>
    3032:	e56d                	bnez	a0,311c <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3034:	20000593          	li	a1,512
    3038:	00004517          	auipc	a0,0x4
    303c:	19050513          	addi	a0,a0,400 # 71c8 <malloc+0x118c>
    3040:	00003097          	auipc	ra,0x3
    3044:	bfc080e7          	jalr	-1028(ra) # 5c3c <open>
  if(fd < 0){
    3048:	0e054863          	bltz	a0,3138 <fourteen+0x134>
  close(fd);
    304c:	00003097          	auipc	ra,0x3
    3050:	bd8080e7          	jalr	-1064(ra) # 5c24 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3054:	4581                	li	a1,0
    3056:	00004517          	auipc	a0,0x4
    305a:	1ea50513          	addi	a0,a0,490 # 7240 <malloc+0x1204>
    305e:	00003097          	auipc	ra,0x3
    3062:	bde080e7          	jalr	-1058(ra) # 5c3c <open>
  if(fd < 0){
    3066:	0e054763          	bltz	a0,3154 <fourteen+0x150>
  close(fd);
    306a:	00003097          	auipc	ra,0x3
    306e:	bba080e7          	jalr	-1094(ra) # 5c24 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3072:	00004517          	auipc	a0,0x4
    3076:	23e50513          	addi	a0,a0,574 # 72b0 <malloc+0x1274>
    307a:	00003097          	auipc	ra,0x3
    307e:	bea080e7          	jalr	-1046(ra) # 5c64 <mkdir>
    3082:	c57d                	beqz	a0,3170 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    3084:	00004517          	auipc	a0,0x4
    3088:	28450513          	addi	a0,a0,644 # 7308 <malloc+0x12cc>
    308c:	00003097          	auipc	ra,0x3
    3090:	bd8080e7          	jalr	-1064(ra) # 5c64 <mkdir>
    3094:	cd65                	beqz	a0,318c <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3096:	00004517          	auipc	a0,0x4
    309a:	27250513          	addi	a0,a0,626 # 7308 <malloc+0x12cc>
    309e:	00003097          	auipc	ra,0x3
    30a2:	bae080e7          	jalr	-1106(ra) # 5c4c <unlink>
  unlink("12345678901234/12345678901234");
    30a6:	00004517          	auipc	a0,0x4
    30aa:	20a50513          	addi	a0,a0,522 # 72b0 <malloc+0x1274>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	b9e080e7          	jalr	-1122(ra) # 5c4c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30b6:	00004517          	auipc	a0,0x4
    30ba:	18a50513          	addi	a0,a0,394 # 7240 <malloc+0x1204>
    30be:	00003097          	auipc	ra,0x3
    30c2:	b8e080e7          	jalr	-1138(ra) # 5c4c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30c6:	00004517          	auipc	a0,0x4
    30ca:	10250513          	addi	a0,a0,258 # 71c8 <malloc+0x118c>
    30ce:	00003097          	auipc	ra,0x3
    30d2:	b7e080e7          	jalr	-1154(ra) # 5c4c <unlink>
  unlink("12345678901234/123456789012345");
    30d6:	00004517          	auipc	a0,0x4
    30da:	09a50513          	addi	a0,a0,154 # 7170 <malloc+0x1134>
    30de:	00003097          	auipc	ra,0x3
    30e2:	b6e080e7          	jalr	-1170(ra) # 5c4c <unlink>
  unlink("12345678901234");
    30e6:	00004517          	auipc	a0,0x4
    30ea:	23250513          	addi	a0,a0,562 # 7318 <malloc+0x12dc>
    30ee:	00003097          	auipc	ra,0x3
    30f2:	b5e080e7          	jalr	-1186(ra) # 5c4c <unlink>
}
    30f6:	60e2                	ld	ra,24(sp)
    30f8:	6442                	ld	s0,16(sp)
    30fa:	64a2                	ld	s1,8(sp)
    30fc:	6105                	addi	sp,sp,32
    30fe:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3100:	85a6                	mv	a1,s1
    3102:	00004517          	auipc	a0,0x4
    3106:	04650513          	addi	a0,a0,70 # 7148 <malloc+0x110c>
    310a:	00003097          	auipc	ra,0x3
    310e:	e7a080e7          	jalr	-390(ra) # 5f84 <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	00003097          	auipc	ra,0x3
    3118:	ae8080e7          	jalr	-1304(ra) # 5bfc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    311c:	85a6                	mv	a1,s1
    311e:	00004517          	auipc	a0,0x4
    3122:	07250513          	addi	a0,a0,114 # 7190 <malloc+0x1154>
    3126:	00003097          	auipc	ra,0x3
    312a:	e5e080e7          	jalr	-418(ra) # 5f84 <printf>
    exit(1);
    312e:	4505                	li	a0,1
    3130:	00003097          	auipc	ra,0x3
    3134:	acc080e7          	jalr	-1332(ra) # 5bfc <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3138:	85a6                	mv	a1,s1
    313a:	00004517          	auipc	a0,0x4
    313e:	0be50513          	addi	a0,a0,190 # 71f8 <malloc+0x11bc>
    3142:	00003097          	auipc	ra,0x3
    3146:	e42080e7          	jalr	-446(ra) # 5f84 <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	00003097          	auipc	ra,0x3
    3150:	ab0080e7          	jalr	-1360(ra) # 5bfc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3154:	85a6                	mv	a1,s1
    3156:	00004517          	auipc	a0,0x4
    315a:	11a50513          	addi	a0,a0,282 # 7270 <malloc+0x1234>
    315e:	00003097          	auipc	ra,0x3
    3162:	e26080e7          	jalr	-474(ra) # 5f84 <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	00003097          	auipc	ra,0x3
    316c:	a94080e7          	jalr	-1388(ra) # 5bfc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3170:	85a6                	mv	a1,s1
    3172:	00004517          	auipc	a0,0x4
    3176:	15e50513          	addi	a0,a0,350 # 72d0 <malloc+0x1294>
    317a:	00003097          	auipc	ra,0x3
    317e:	e0a080e7          	jalr	-502(ra) # 5f84 <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	00003097          	auipc	ra,0x3
    3188:	a78080e7          	jalr	-1416(ra) # 5bfc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    318c:	85a6                	mv	a1,s1
    318e:	00004517          	auipc	a0,0x4
    3192:	19a50513          	addi	a0,a0,410 # 7328 <malloc+0x12ec>
    3196:	00003097          	auipc	ra,0x3
    319a:	dee080e7          	jalr	-530(ra) # 5f84 <printf>
    exit(1);
    319e:	4505                	li	a0,1
    31a0:	00003097          	auipc	ra,0x3
    31a4:	a5c080e7          	jalr	-1444(ra) # 5bfc <exit>

00000000000031a8 <diskfull>:
{
    31a8:	b9010113          	addi	sp,sp,-1136
    31ac:	46113423          	sd	ra,1128(sp)
    31b0:	46813023          	sd	s0,1120(sp)
    31b4:	44913c23          	sd	s1,1112(sp)
    31b8:	45213823          	sd	s2,1104(sp)
    31bc:	45313423          	sd	s3,1096(sp)
    31c0:	45413023          	sd	s4,1088(sp)
    31c4:	43513c23          	sd	s5,1080(sp)
    31c8:	43613823          	sd	s6,1072(sp)
    31cc:	43713423          	sd	s7,1064(sp)
    31d0:	43813023          	sd	s8,1056(sp)
    31d4:	47010413          	addi	s0,sp,1136
    31d8:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31da:	00004517          	auipc	a0,0x4
    31de:	18650513          	addi	a0,a0,390 # 7360 <malloc+0x1324>
    31e2:	00003097          	auipc	ra,0x3
    31e6:	a6a080e7          	jalr	-1430(ra) # 5c4c <unlink>
  for(fi = 0; done == 0; fi++){
    31ea:	4a01                	li	s4,0
    name[0] = 'b';
    31ec:	06200b13          	li	s6,98
    name[1] = 'i';
    31f0:	06900a93          	li	s5,105
    name[2] = 'g';
    31f4:	06700993          	li	s3,103
    31f8:	10c00b93          	li	s7,268
    31fc:	aabd                	j	337a <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    31fe:	b9040613          	addi	a2,s0,-1136
    3202:	85e2                	mv	a1,s8
    3204:	00004517          	auipc	a0,0x4
    3208:	16c50513          	addi	a0,a0,364 # 7370 <malloc+0x1334>
    320c:	00003097          	auipc	ra,0x3
    3210:	d78080e7          	jalr	-648(ra) # 5f84 <printf>
      break;
    3214:	a821                	j	322c <diskfull+0x84>
        close(fd);
    3216:	854a                	mv	a0,s2
    3218:	00003097          	auipc	ra,0x3
    321c:	a0c080e7          	jalr	-1524(ra) # 5c24 <close>
    close(fd);
    3220:	854a                	mv	a0,s2
    3222:	00003097          	auipc	ra,0x3
    3226:	a02080e7          	jalr	-1534(ra) # 5c24 <close>
  for(fi = 0; done == 0; fi++){
    322a:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    322c:	4481                	li	s1,0
    name[0] = 'z';
    322e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3232:	08000993          	li	s3,128
    name[0] = 'z';
    3236:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    323a:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    323e:	41f4d71b          	sraiw	a4,s1,0x1f
    3242:	01b7571b          	srliw	a4,a4,0x1b
    3246:	009707bb          	addw	a5,a4,s1
    324a:	4057d69b          	sraiw	a3,a5,0x5
    324e:	0306869b          	addiw	a3,a3,48
    3252:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3256:	8bfd                	andi	a5,a5,31
    3258:	9f99                	subw	a5,a5,a4
    325a:	0307879b          	addiw	a5,a5,48
    325e:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3262:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3266:	bb040513          	addi	a0,s0,-1104
    326a:	00003097          	auipc	ra,0x3
    326e:	9e2080e7          	jalr	-1566(ra) # 5c4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3272:	60200593          	li	a1,1538
    3276:	bb040513          	addi	a0,s0,-1104
    327a:	00003097          	auipc	ra,0x3
    327e:	9c2080e7          	jalr	-1598(ra) # 5c3c <open>
    if(fd < 0)
    3282:	00054963          	bltz	a0,3294 <diskfull+0xec>
    close(fd);
    3286:	00003097          	auipc	ra,0x3
    328a:	99e080e7          	jalr	-1634(ra) # 5c24 <close>
  for(int i = 0; i < nzz; i++){
    328e:	2485                	addiw	s1,s1,1
    3290:	fb3493e3          	bne	s1,s3,3236 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3294:	00004517          	auipc	a0,0x4
    3298:	0cc50513          	addi	a0,a0,204 # 7360 <malloc+0x1324>
    329c:	00003097          	auipc	ra,0x3
    32a0:	9c8080e7          	jalr	-1592(ra) # 5c64 <mkdir>
    32a4:	12050963          	beqz	a0,33d6 <diskfull+0x22e>
  unlink("diskfulldir");
    32a8:	00004517          	auipc	a0,0x4
    32ac:	0b850513          	addi	a0,a0,184 # 7360 <malloc+0x1324>
    32b0:	00003097          	auipc	ra,0x3
    32b4:	99c080e7          	jalr	-1636(ra) # 5c4c <unlink>
  for(int i = 0; i < nzz; i++){
    32b8:	4481                	li	s1,0
    name[0] = 'z';
    32ba:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32be:	08000993          	li	s3,128
    name[0] = 'z';
    32c2:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32c6:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ca:	41f4d71b          	sraiw	a4,s1,0x1f
    32ce:	01b7571b          	srliw	a4,a4,0x1b
    32d2:	009707bb          	addw	a5,a4,s1
    32d6:	4057d69b          	sraiw	a3,a5,0x5
    32da:	0306869b          	addiw	a3,a3,48
    32de:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    32e2:	8bfd                	andi	a5,a5,31
    32e4:	9f99                	subw	a5,a5,a4
    32e6:	0307879b          	addiw	a5,a5,48
    32ea:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32ee:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32f2:	bb040513          	addi	a0,s0,-1104
    32f6:	00003097          	auipc	ra,0x3
    32fa:	956080e7          	jalr	-1706(ra) # 5c4c <unlink>
  for(int i = 0; i < nzz; i++){
    32fe:	2485                	addiw	s1,s1,1
    3300:	fd3491e3          	bne	s1,s3,32c2 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3304:	03405e63          	blez	s4,3340 <diskfull+0x198>
    3308:	4481                	li	s1,0
    name[0] = 'b';
    330a:	06200a93          	li	s5,98
    name[1] = 'i';
    330e:	06900993          	li	s3,105
    name[2] = 'g';
    3312:	06700913          	li	s2,103
    name[0] = 'b';
    3316:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    331a:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    331e:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3322:	0304879b          	addiw	a5,s1,48
    3326:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    332a:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    332e:	bb040513          	addi	a0,s0,-1104
    3332:	00003097          	auipc	ra,0x3
    3336:	91a080e7          	jalr	-1766(ra) # 5c4c <unlink>
  for(int i = 0; i < fi; i++){
    333a:	2485                	addiw	s1,s1,1
    333c:	fd449de3          	bne	s1,s4,3316 <diskfull+0x16e>
}
    3340:	46813083          	ld	ra,1128(sp)
    3344:	46013403          	ld	s0,1120(sp)
    3348:	45813483          	ld	s1,1112(sp)
    334c:	45013903          	ld	s2,1104(sp)
    3350:	44813983          	ld	s3,1096(sp)
    3354:	44013a03          	ld	s4,1088(sp)
    3358:	43813a83          	ld	s5,1080(sp)
    335c:	43013b03          	ld	s6,1072(sp)
    3360:	42813b83          	ld	s7,1064(sp)
    3364:	42013c03          	ld	s8,1056(sp)
    3368:	47010113          	addi	sp,sp,1136
    336c:	8082                	ret
    close(fd);
    336e:	854a                	mv	a0,s2
    3370:	00003097          	auipc	ra,0x3
    3374:	8b4080e7          	jalr	-1868(ra) # 5c24 <close>
  for(fi = 0; done == 0; fi++){
    3378:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    337a:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    337e:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    3382:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    3386:	030a079b          	addiw	a5,s4,48
    338a:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    338e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3392:	b9040513          	addi	a0,s0,-1136
    3396:	00003097          	auipc	ra,0x3
    339a:	8b6080e7          	jalr	-1866(ra) # 5c4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    339e:	60200593          	li	a1,1538
    33a2:	b9040513          	addi	a0,s0,-1136
    33a6:	00003097          	auipc	ra,0x3
    33aa:	896080e7          	jalr	-1898(ra) # 5c3c <open>
    33ae:	892a                	mv	s2,a0
    if(fd < 0){
    33b0:	e40547e3          	bltz	a0,31fe <diskfull+0x56>
    33b4:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33b6:	40000613          	li	a2,1024
    33ba:	bb040593          	addi	a1,s0,-1104
    33be:	854a                	mv	a0,s2
    33c0:	00003097          	auipc	ra,0x3
    33c4:	85c080e7          	jalr	-1956(ra) # 5c1c <write>
    33c8:	40000793          	li	a5,1024
    33cc:	e4f515e3          	bne	a0,a5,3216 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    33d0:	34fd                	addiw	s1,s1,-1
    33d2:	f0f5                	bnez	s1,33b6 <diskfull+0x20e>
    33d4:	bf69                	j	336e <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33d6:	00004517          	auipc	a0,0x4
    33da:	fba50513          	addi	a0,a0,-70 # 7390 <malloc+0x1354>
    33de:	00003097          	auipc	ra,0x3
    33e2:	ba6080e7          	jalr	-1114(ra) # 5f84 <printf>
    33e6:	b5c9                	j	32a8 <diskfull+0x100>

00000000000033e8 <iputtest>:
{
    33e8:	1101                	addi	sp,sp,-32
    33ea:	ec06                	sd	ra,24(sp)
    33ec:	e822                	sd	s0,16(sp)
    33ee:	e426                	sd	s1,8(sp)
    33f0:	1000                	addi	s0,sp,32
    33f2:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    33f4:	00004517          	auipc	a0,0x4
    33f8:	fcc50513          	addi	a0,a0,-52 # 73c0 <malloc+0x1384>
    33fc:	00003097          	auipc	ra,0x3
    3400:	868080e7          	jalr	-1944(ra) # 5c64 <mkdir>
    3404:	04054563          	bltz	a0,344e <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3408:	00004517          	auipc	a0,0x4
    340c:	fb850513          	addi	a0,a0,-72 # 73c0 <malloc+0x1384>
    3410:	00003097          	auipc	ra,0x3
    3414:	85c080e7          	jalr	-1956(ra) # 5c6c <chdir>
    3418:	04054963          	bltz	a0,346a <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    341c:	00004517          	auipc	a0,0x4
    3420:	fe450513          	addi	a0,a0,-28 # 7400 <malloc+0x13c4>
    3424:	00003097          	auipc	ra,0x3
    3428:	828080e7          	jalr	-2008(ra) # 5c4c <unlink>
    342c:	04054d63          	bltz	a0,3486 <iputtest+0x9e>
  if(chdir("/") < 0){
    3430:	00004517          	auipc	a0,0x4
    3434:	00050513          	mv	a0,a0
    3438:	00003097          	auipc	ra,0x3
    343c:	834080e7          	jalr	-1996(ra) # 5c6c <chdir>
    3440:	06054163          	bltz	a0,34a2 <iputtest+0xba>
}
    3444:	60e2                	ld	ra,24(sp)
    3446:	6442                	ld	s0,16(sp)
    3448:	64a2                	ld	s1,8(sp)
    344a:	6105                	addi	sp,sp,32
    344c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    344e:	85a6                	mv	a1,s1
    3450:	00004517          	auipc	a0,0x4
    3454:	f7850513          	addi	a0,a0,-136 # 73c8 <malloc+0x138c>
    3458:	00003097          	auipc	ra,0x3
    345c:	b2c080e7          	jalr	-1236(ra) # 5f84 <printf>
    exit(1);
    3460:	4505                	li	a0,1
    3462:	00002097          	auipc	ra,0x2
    3466:	79a080e7          	jalr	1946(ra) # 5bfc <exit>
    printf("%s: chdir iputdir failed\n", s);
    346a:	85a6                	mv	a1,s1
    346c:	00004517          	auipc	a0,0x4
    3470:	f7450513          	addi	a0,a0,-140 # 73e0 <malloc+0x13a4>
    3474:	00003097          	auipc	ra,0x3
    3478:	b10080e7          	jalr	-1264(ra) # 5f84 <printf>
    exit(1);
    347c:	4505                	li	a0,1
    347e:	00002097          	auipc	ra,0x2
    3482:	77e080e7          	jalr	1918(ra) # 5bfc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3486:	85a6                	mv	a1,s1
    3488:	00004517          	auipc	a0,0x4
    348c:	f8850513          	addi	a0,a0,-120 # 7410 <malloc+0x13d4>
    3490:	00003097          	auipc	ra,0x3
    3494:	af4080e7          	jalr	-1292(ra) # 5f84 <printf>
    exit(1);
    3498:	4505                	li	a0,1
    349a:	00002097          	auipc	ra,0x2
    349e:	762080e7          	jalr	1890(ra) # 5bfc <exit>
    printf("%s: chdir / failed\n", s);
    34a2:	85a6                	mv	a1,s1
    34a4:	00004517          	auipc	a0,0x4
    34a8:	f9450513          	addi	a0,a0,-108 # 7438 <malloc+0x13fc>
    34ac:	00003097          	auipc	ra,0x3
    34b0:	ad8080e7          	jalr	-1320(ra) # 5f84 <printf>
    exit(1);
    34b4:	4505                	li	a0,1
    34b6:	00002097          	auipc	ra,0x2
    34ba:	746080e7          	jalr	1862(ra) # 5bfc <exit>

00000000000034be <exitiputtest>:
{
    34be:	7179                	addi	sp,sp,-48
    34c0:	f406                	sd	ra,40(sp)
    34c2:	f022                	sd	s0,32(sp)
    34c4:	ec26                	sd	s1,24(sp)
    34c6:	1800                	addi	s0,sp,48
    34c8:	84aa                	mv	s1,a0
  pid = fork();
    34ca:	00002097          	auipc	ra,0x2
    34ce:	72a080e7          	jalr	1834(ra) # 5bf4 <fork>
  if(pid < 0){
    34d2:	04054663          	bltz	a0,351e <exitiputtest+0x60>
  if(pid == 0){
    34d6:	ed45                	bnez	a0,358e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34d8:	00004517          	auipc	a0,0x4
    34dc:	ee850513          	addi	a0,a0,-280 # 73c0 <malloc+0x1384>
    34e0:	00002097          	auipc	ra,0x2
    34e4:	784080e7          	jalr	1924(ra) # 5c64 <mkdir>
    34e8:	04054963          	bltz	a0,353a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    34ec:	00004517          	auipc	a0,0x4
    34f0:	ed450513          	addi	a0,a0,-300 # 73c0 <malloc+0x1384>
    34f4:	00002097          	auipc	ra,0x2
    34f8:	778080e7          	jalr	1912(ra) # 5c6c <chdir>
    34fc:	04054d63          	bltz	a0,3556 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3500:	00004517          	auipc	a0,0x4
    3504:	f0050513          	addi	a0,a0,-256 # 7400 <malloc+0x13c4>
    3508:	00002097          	auipc	ra,0x2
    350c:	744080e7          	jalr	1860(ra) # 5c4c <unlink>
    3510:	06054163          	bltz	a0,3572 <exitiputtest+0xb4>
    exit(0);
    3514:	4501                	li	a0,0
    3516:	00002097          	auipc	ra,0x2
    351a:	6e6080e7          	jalr	1766(ra) # 5bfc <exit>
    printf("%s: fork failed\n", s);
    351e:	85a6                	mv	a1,s1
    3520:	00003517          	auipc	a0,0x3
    3524:	4e050513          	addi	a0,a0,1248 # 6a00 <malloc+0x9c4>
    3528:	00003097          	auipc	ra,0x3
    352c:	a5c080e7          	jalr	-1444(ra) # 5f84 <printf>
    exit(1);
    3530:	4505                	li	a0,1
    3532:	00002097          	auipc	ra,0x2
    3536:	6ca080e7          	jalr	1738(ra) # 5bfc <exit>
      printf("%s: mkdir failed\n", s);
    353a:	85a6                	mv	a1,s1
    353c:	00004517          	auipc	a0,0x4
    3540:	e8c50513          	addi	a0,a0,-372 # 73c8 <malloc+0x138c>
    3544:	00003097          	auipc	ra,0x3
    3548:	a40080e7          	jalr	-1472(ra) # 5f84 <printf>
      exit(1);
    354c:	4505                	li	a0,1
    354e:	00002097          	auipc	ra,0x2
    3552:	6ae080e7          	jalr	1710(ra) # 5bfc <exit>
      printf("%s: child chdir failed\n", s);
    3556:	85a6                	mv	a1,s1
    3558:	00004517          	auipc	a0,0x4
    355c:	ef850513          	addi	a0,a0,-264 # 7450 <malloc+0x1414>
    3560:	00003097          	auipc	ra,0x3
    3564:	a24080e7          	jalr	-1500(ra) # 5f84 <printf>
      exit(1);
    3568:	4505                	li	a0,1
    356a:	00002097          	auipc	ra,0x2
    356e:	692080e7          	jalr	1682(ra) # 5bfc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3572:	85a6                	mv	a1,s1
    3574:	00004517          	auipc	a0,0x4
    3578:	e9c50513          	addi	a0,a0,-356 # 7410 <malloc+0x13d4>
    357c:	00003097          	auipc	ra,0x3
    3580:	a08080e7          	jalr	-1528(ra) # 5f84 <printf>
      exit(1);
    3584:	4505                	li	a0,1
    3586:	00002097          	auipc	ra,0x2
    358a:	676080e7          	jalr	1654(ra) # 5bfc <exit>
  wait(&xstatus);
    358e:	fdc40513          	addi	a0,s0,-36
    3592:	00002097          	auipc	ra,0x2
    3596:	672080e7          	jalr	1650(ra) # 5c04 <wait>
  exit(xstatus);
    359a:	fdc42503          	lw	a0,-36(s0)
    359e:	00002097          	auipc	ra,0x2
    35a2:	65e080e7          	jalr	1630(ra) # 5bfc <exit>

00000000000035a6 <dirtest>:
{
    35a6:	1101                	addi	sp,sp,-32
    35a8:	ec06                	sd	ra,24(sp)
    35aa:	e822                	sd	s0,16(sp)
    35ac:	e426                	sd	s1,8(sp)
    35ae:	1000                	addi	s0,sp,32
    35b0:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35b2:	00004517          	auipc	a0,0x4
    35b6:	eb650513          	addi	a0,a0,-330 # 7468 <malloc+0x142c>
    35ba:	00002097          	auipc	ra,0x2
    35be:	6aa080e7          	jalr	1706(ra) # 5c64 <mkdir>
    35c2:	04054563          	bltz	a0,360c <dirtest+0x66>
  if(chdir("dir0") < 0){
    35c6:	00004517          	auipc	a0,0x4
    35ca:	ea250513          	addi	a0,a0,-350 # 7468 <malloc+0x142c>
    35ce:	00002097          	auipc	ra,0x2
    35d2:	69e080e7          	jalr	1694(ra) # 5c6c <chdir>
    35d6:	04054963          	bltz	a0,3628 <dirtest+0x82>
  if(chdir("..") < 0){
    35da:	00004517          	auipc	a0,0x4
    35de:	eae50513          	addi	a0,a0,-338 # 7488 <malloc+0x144c>
    35e2:	00002097          	auipc	ra,0x2
    35e6:	68a080e7          	jalr	1674(ra) # 5c6c <chdir>
    35ea:	04054d63          	bltz	a0,3644 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    35ee:	00004517          	auipc	a0,0x4
    35f2:	e7a50513          	addi	a0,a0,-390 # 7468 <malloc+0x142c>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	656080e7          	jalr	1622(ra) # 5c4c <unlink>
    35fe:	06054163          	bltz	a0,3660 <dirtest+0xba>
}
    3602:	60e2                	ld	ra,24(sp)
    3604:	6442                	ld	s0,16(sp)
    3606:	64a2                	ld	s1,8(sp)
    3608:	6105                	addi	sp,sp,32
    360a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    360c:	85a6                	mv	a1,s1
    360e:	00004517          	auipc	a0,0x4
    3612:	dba50513          	addi	a0,a0,-582 # 73c8 <malloc+0x138c>
    3616:	00003097          	auipc	ra,0x3
    361a:	96e080e7          	jalr	-1682(ra) # 5f84 <printf>
    exit(1);
    361e:	4505                	li	a0,1
    3620:	00002097          	auipc	ra,0x2
    3624:	5dc080e7          	jalr	1500(ra) # 5bfc <exit>
    printf("%s: chdir dir0 failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00004517          	auipc	a0,0x4
    362e:	e4650513          	addi	a0,a0,-442 # 7470 <malloc+0x1434>
    3632:	00003097          	auipc	ra,0x3
    3636:	952080e7          	jalr	-1710(ra) # 5f84 <printf>
    exit(1);
    363a:	4505                	li	a0,1
    363c:	00002097          	auipc	ra,0x2
    3640:	5c0080e7          	jalr	1472(ra) # 5bfc <exit>
    printf("%s: chdir .. failed\n", s);
    3644:	85a6                	mv	a1,s1
    3646:	00004517          	auipc	a0,0x4
    364a:	e4a50513          	addi	a0,a0,-438 # 7490 <malloc+0x1454>
    364e:	00003097          	auipc	ra,0x3
    3652:	936080e7          	jalr	-1738(ra) # 5f84 <printf>
    exit(1);
    3656:	4505                	li	a0,1
    3658:	00002097          	auipc	ra,0x2
    365c:	5a4080e7          	jalr	1444(ra) # 5bfc <exit>
    printf("%s: unlink dir0 failed\n", s);
    3660:	85a6                	mv	a1,s1
    3662:	00004517          	auipc	a0,0x4
    3666:	e4650513          	addi	a0,a0,-442 # 74a8 <malloc+0x146c>
    366a:	00003097          	auipc	ra,0x3
    366e:	91a080e7          	jalr	-1766(ra) # 5f84 <printf>
    exit(1);
    3672:	4505                	li	a0,1
    3674:	00002097          	auipc	ra,0x2
    3678:	588080e7          	jalr	1416(ra) # 5bfc <exit>

000000000000367c <subdir>:
{
    367c:	1101                	addi	sp,sp,-32
    367e:	ec06                	sd	ra,24(sp)
    3680:	e822                	sd	s0,16(sp)
    3682:	e426                	sd	s1,8(sp)
    3684:	e04a                	sd	s2,0(sp)
    3686:	1000                	addi	s0,sp,32
    3688:	892a                	mv	s2,a0
  unlink("ff");
    368a:	00004517          	auipc	a0,0x4
    368e:	f6650513          	addi	a0,a0,-154 # 75f0 <malloc+0x15b4>
    3692:	00002097          	auipc	ra,0x2
    3696:	5ba080e7          	jalr	1466(ra) # 5c4c <unlink>
  if(mkdir("dd") != 0){
    369a:	00004517          	auipc	a0,0x4
    369e:	e2650513          	addi	a0,a0,-474 # 74c0 <malloc+0x1484>
    36a2:	00002097          	auipc	ra,0x2
    36a6:	5c2080e7          	jalr	1474(ra) # 5c64 <mkdir>
    36aa:	38051663          	bnez	a0,3a36 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36ae:	20200593          	li	a1,514
    36b2:	00004517          	auipc	a0,0x4
    36b6:	e2e50513          	addi	a0,a0,-466 # 74e0 <malloc+0x14a4>
    36ba:	00002097          	auipc	ra,0x2
    36be:	582080e7          	jalr	1410(ra) # 5c3c <open>
    36c2:	84aa                	mv	s1,a0
  if(fd < 0){
    36c4:	38054763          	bltz	a0,3a52 <subdir+0x3d6>
  write(fd, "ff", 2);
    36c8:	4609                	li	a2,2
    36ca:	00004597          	auipc	a1,0x4
    36ce:	f2658593          	addi	a1,a1,-218 # 75f0 <malloc+0x15b4>
    36d2:	00002097          	auipc	ra,0x2
    36d6:	54a080e7          	jalr	1354(ra) # 5c1c <write>
  close(fd);
    36da:	8526                	mv	a0,s1
    36dc:	00002097          	auipc	ra,0x2
    36e0:	548080e7          	jalr	1352(ra) # 5c24 <close>
  if(unlink("dd") >= 0){
    36e4:	00004517          	auipc	a0,0x4
    36e8:	ddc50513          	addi	a0,a0,-548 # 74c0 <malloc+0x1484>
    36ec:	00002097          	auipc	ra,0x2
    36f0:	560080e7          	jalr	1376(ra) # 5c4c <unlink>
    36f4:	36055d63          	bgez	a0,3a6e <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    36f8:	00004517          	auipc	a0,0x4
    36fc:	e4050513          	addi	a0,a0,-448 # 7538 <malloc+0x14fc>
    3700:	00002097          	auipc	ra,0x2
    3704:	564080e7          	jalr	1380(ra) # 5c64 <mkdir>
    3708:	38051163          	bnez	a0,3a8a <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    370c:	20200593          	li	a1,514
    3710:	00004517          	auipc	a0,0x4
    3714:	e5050513          	addi	a0,a0,-432 # 7560 <malloc+0x1524>
    3718:	00002097          	auipc	ra,0x2
    371c:	524080e7          	jalr	1316(ra) # 5c3c <open>
    3720:	84aa                	mv	s1,a0
  if(fd < 0){
    3722:	38054263          	bltz	a0,3aa6 <subdir+0x42a>
  write(fd, "FF", 2);
    3726:	4609                	li	a2,2
    3728:	00004597          	auipc	a1,0x4
    372c:	e6858593          	addi	a1,a1,-408 # 7590 <malloc+0x1554>
    3730:	00002097          	auipc	ra,0x2
    3734:	4ec080e7          	jalr	1260(ra) # 5c1c <write>
  close(fd);
    3738:	8526                	mv	a0,s1
    373a:	00002097          	auipc	ra,0x2
    373e:	4ea080e7          	jalr	1258(ra) # 5c24 <close>
  fd = open("dd/dd/../ff", 0);
    3742:	4581                	li	a1,0
    3744:	00004517          	auipc	a0,0x4
    3748:	e5450513          	addi	a0,a0,-428 # 7598 <malloc+0x155c>
    374c:	00002097          	auipc	ra,0x2
    3750:	4f0080e7          	jalr	1264(ra) # 5c3c <open>
    3754:	84aa                	mv	s1,a0
  if(fd < 0){
    3756:	36054663          	bltz	a0,3ac2 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    375a:	660d                	lui	a2,0x3
    375c:	0000b597          	auipc	a1,0xb
    3760:	88c58593          	addi	a1,a1,-1908 # dfe8 <buf>
    3764:	00002097          	auipc	ra,0x2
    3768:	4b0080e7          	jalr	1200(ra) # 5c14 <read>
  if(cc != 2 || buf[0] != 'f'){
    376c:	4789                	li	a5,2
    376e:	36f51863          	bne	a0,a5,3ade <subdir+0x462>
    3772:	0000b717          	auipc	a4,0xb
    3776:	87674703          	lbu	a4,-1930(a4) # dfe8 <buf>
    377a:	06600793          	li	a5,102
    377e:	36f71063          	bne	a4,a5,3ade <subdir+0x462>
  close(fd);
    3782:	8526                	mv	a0,s1
    3784:	00002097          	auipc	ra,0x2
    3788:	4a0080e7          	jalr	1184(ra) # 5c24 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    378c:	00004597          	auipc	a1,0x4
    3790:	e5c58593          	addi	a1,a1,-420 # 75e8 <malloc+0x15ac>
    3794:	00004517          	auipc	a0,0x4
    3798:	dcc50513          	addi	a0,a0,-564 # 7560 <malloc+0x1524>
    379c:	00002097          	auipc	ra,0x2
    37a0:	4c0080e7          	jalr	1216(ra) # 5c5c <link>
    37a4:	34051b63          	bnez	a0,3afa <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37a8:	00004517          	auipc	a0,0x4
    37ac:	db850513          	addi	a0,a0,-584 # 7560 <malloc+0x1524>
    37b0:	00002097          	auipc	ra,0x2
    37b4:	49c080e7          	jalr	1180(ra) # 5c4c <unlink>
    37b8:	34051f63          	bnez	a0,3b16 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37bc:	4581                	li	a1,0
    37be:	00004517          	auipc	a0,0x4
    37c2:	da250513          	addi	a0,a0,-606 # 7560 <malloc+0x1524>
    37c6:	00002097          	auipc	ra,0x2
    37ca:	476080e7          	jalr	1142(ra) # 5c3c <open>
    37ce:	36055263          	bgez	a0,3b32 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37d2:	00004517          	auipc	a0,0x4
    37d6:	cee50513          	addi	a0,a0,-786 # 74c0 <malloc+0x1484>
    37da:	00002097          	auipc	ra,0x2
    37de:	492080e7          	jalr	1170(ra) # 5c6c <chdir>
    37e2:	36051663          	bnez	a0,3b4e <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    37e6:	00004517          	auipc	a0,0x4
    37ea:	e9a50513          	addi	a0,a0,-358 # 7680 <malloc+0x1644>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	47e080e7          	jalr	1150(ra) # 5c6c <chdir>
    37f6:	36051a63          	bnez	a0,3b6a <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    37fa:	00004517          	auipc	a0,0x4
    37fe:	eb650513          	addi	a0,a0,-330 # 76b0 <malloc+0x1674>
    3802:	00002097          	auipc	ra,0x2
    3806:	46a080e7          	jalr	1130(ra) # 5c6c <chdir>
    380a:	36051e63          	bnez	a0,3b86 <subdir+0x50a>
  if(chdir("./..") != 0){
    380e:	00004517          	auipc	a0,0x4
    3812:	ed250513          	addi	a0,a0,-302 # 76e0 <malloc+0x16a4>
    3816:	00002097          	auipc	ra,0x2
    381a:	456080e7          	jalr	1110(ra) # 5c6c <chdir>
    381e:	38051263          	bnez	a0,3ba2 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3822:	4581                	li	a1,0
    3824:	00004517          	auipc	a0,0x4
    3828:	dc450513          	addi	a0,a0,-572 # 75e8 <malloc+0x15ac>
    382c:	00002097          	auipc	ra,0x2
    3830:	410080e7          	jalr	1040(ra) # 5c3c <open>
    3834:	84aa                	mv	s1,a0
  if(fd < 0){
    3836:	38054463          	bltz	a0,3bbe <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    383a:	660d                	lui	a2,0x3
    383c:	0000a597          	auipc	a1,0xa
    3840:	7ac58593          	addi	a1,a1,1964 # dfe8 <buf>
    3844:	00002097          	auipc	ra,0x2
    3848:	3d0080e7          	jalr	976(ra) # 5c14 <read>
    384c:	4789                	li	a5,2
    384e:	38f51663          	bne	a0,a5,3bda <subdir+0x55e>
  close(fd);
    3852:	8526                	mv	a0,s1
    3854:	00002097          	auipc	ra,0x2
    3858:	3d0080e7          	jalr	976(ra) # 5c24 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    385c:	4581                	li	a1,0
    385e:	00004517          	auipc	a0,0x4
    3862:	d0250513          	addi	a0,a0,-766 # 7560 <malloc+0x1524>
    3866:	00002097          	auipc	ra,0x2
    386a:	3d6080e7          	jalr	982(ra) # 5c3c <open>
    386e:	38055463          	bgez	a0,3bf6 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3872:	20200593          	li	a1,514
    3876:	00004517          	auipc	a0,0x4
    387a:	efa50513          	addi	a0,a0,-262 # 7770 <malloc+0x1734>
    387e:	00002097          	auipc	ra,0x2
    3882:	3be080e7          	jalr	958(ra) # 5c3c <open>
    3886:	38055663          	bgez	a0,3c12 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    388a:	20200593          	li	a1,514
    388e:	00004517          	auipc	a0,0x4
    3892:	f1250513          	addi	a0,a0,-238 # 77a0 <malloc+0x1764>
    3896:	00002097          	auipc	ra,0x2
    389a:	3a6080e7          	jalr	934(ra) # 5c3c <open>
    389e:	38055863          	bgez	a0,3c2e <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38a2:	20000593          	li	a1,512
    38a6:	00004517          	auipc	a0,0x4
    38aa:	c1a50513          	addi	a0,a0,-998 # 74c0 <malloc+0x1484>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	38e080e7          	jalr	910(ra) # 5c3c <open>
    38b6:	38055a63          	bgez	a0,3c4a <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38ba:	4589                	li	a1,2
    38bc:	00004517          	auipc	a0,0x4
    38c0:	c0450513          	addi	a0,a0,-1020 # 74c0 <malloc+0x1484>
    38c4:	00002097          	auipc	ra,0x2
    38c8:	378080e7          	jalr	888(ra) # 5c3c <open>
    38cc:	38055d63          	bgez	a0,3c66 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38d0:	4585                	li	a1,1
    38d2:	00004517          	auipc	a0,0x4
    38d6:	bee50513          	addi	a0,a0,-1042 # 74c0 <malloc+0x1484>
    38da:	00002097          	auipc	ra,0x2
    38de:	362080e7          	jalr	866(ra) # 5c3c <open>
    38e2:	3a055063          	bgez	a0,3c82 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    38e6:	00004597          	auipc	a1,0x4
    38ea:	f4a58593          	addi	a1,a1,-182 # 7830 <malloc+0x17f4>
    38ee:	00004517          	auipc	a0,0x4
    38f2:	e8250513          	addi	a0,a0,-382 # 7770 <malloc+0x1734>
    38f6:	00002097          	auipc	ra,0x2
    38fa:	366080e7          	jalr	870(ra) # 5c5c <link>
    38fe:	3a050063          	beqz	a0,3c9e <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3902:	00004597          	auipc	a1,0x4
    3906:	f2e58593          	addi	a1,a1,-210 # 7830 <malloc+0x17f4>
    390a:	00004517          	auipc	a0,0x4
    390e:	e9650513          	addi	a0,a0,-362 # 77a0 <malloc+0x1764>
    3912:	00002097          	auipc	ra,0x2
    3916:	34a080e7          	jalr	842(ra) # 5c5c <link>
    391a:	3a050063          	beqz	a0,3cba <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    391e:	00004597          	auipc	a1,0x4
    3922:	cca58593          	addi	a1,a1,-822 # 75e8 <malloc+0x15ac>
    3926:	00004517          	auipc	a0,0x4
    392a:	bba50513          	addi	a0,a0,-1094 # 74e0 <malloc+0x14a4>
    392e:	00002097          	auipc	ra,0x2
    3932:	32e080e7          	jalr	814(ra) # 5c5c <link>
    3936:	3a050063          	beqz	a0,3cd6 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    393a:	00004517          	auipc	a0,0x4
    393e:	e3650513          	addi	a0,a0,-458 # 7770 <malloc+0x1734>
    3942:	00002097          	auipc	ra,0x2
    3946:	322080e7          	jalr	802(ra) # 5c64 <mkdir>
    394a:	3a050463          	beqz	a0,3cf2 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    394e:	00004517          	auipc	a0,0x4
    3952:	e5250513          	addi	a0,a0,-430 # 77a0 <malloc+0x1764>
    3956:	00002097          	auipc	ra,0x2
    395a:	30e080e7          	jalr	782(ra) # 5c64 <mkdir>
    395e:	3a050863          	beqz	a0,3d0e <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3962:	00004517          	auipc	a0,0x4
    3966:	c8650513          	addi	a0,a0,-890 # 75e8 <malloc+0x15ac>
    396a:	00002097          	auipc	ra,0x2
    396e:	2fa080e7          	jalr	762(ra) # 5c64 <mkdir>
    3972:	3a050c63          	beqz	a0,3d2a <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3976:	00004517          	auipc	a0,0x4
    397a:	e2a50513          	addi	a0,a0,-470 # 77a0 <malloc+0x1764>
    397e:	00002097          	auipc	ra,0x2
    3982:	2ce080e7          	jalr	718(ra) # 5c4c <unlink>
    3986:	3c050063          	beqz	a0,3d46 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    398a:	00004517          	auipc	a0,0x4
    398e:	de650513          	addi	a0,a0,-538 # 7770 <malloc+0x1734>
    3992:	00002097          	auipc	ra,0x2
    3996:	2ba080e7          	jalr	698(ra) # 5c4c <unlink>
    399a:	3c050463          	beqz	a0,3d62 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    399e:	00004517          	auipc	a0,0x4
    39a2:	b4250513          	addi	a0,a0,-1214 # 74e0 <malloc+0x14a4>
    39a6:	00002097          	auipc	ra,0x2
    39aa:	2c6080e7          	jalr	710(ra) # 5c6c <chdir>
    39ae:	3c050863          	beqz	a0,3d7e <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39b2:	00004517          	auipc	a0,0x4
    39b6:	fce50513          	addi	a0,a0,-50 # 7980 <malloc+0x1944>
    39ba:	00002097          	auipc	ra,0x2
    39be:	2b2080e7          	jalr	690(ra) # 5c6c <chdir>
    39c2:	3c050c63          	beqz	a0,3d9a <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39c6:	00004517          	auipc	a0,0x4
    39ca:	c2250513          	addi	a0,a0,-990 # 75e8 <malloc+0x15ac>
    39ce:	00002097          	auipc	ra,0x2
    39d2:	27e080e7          	jalr	638(ra) # 5c4c <unlink>
    39d6:	3e051063          	bnez	a0,3db6 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39da:	00004517          	auipc	a0,0x4
    39de:	b0650513          	addi	a0,a0,-1274 # 74e0 <malloc+0x14a4>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	26a080e7          	jalr	618(ra) # 5c4c <unlink>
    39ea:	3e051463          	bnez	a0,3dd2 <subdir+0x756>
  if(unlink("dd") == 0){
    39ee:	00004517          	auipc	a0,0x4
    39f2:	ad250513          	addi	a0,a0,-1326 # 74c0 <malloc+0x1484>
    39f6:	00002097          	auipc	ra,0x2
    39fa:	256080e7          	jalr	598(ra) # 5c4c <unlink>
    39fe:	3e050863          	beqz	a0,3dee <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a02:	00004517          	auipc	a0,0x4
    3a06:	fee50513          	addi	a0,a0,-18 # 79f0 <malloc+0x19b4>
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	242080e7          	jalr	578(ra) # 5c4c <unlink>
    3a12:	3e054c63          	bltz	a0,3e0a <subdir+0x78e>
  if(unlink("dd") < 0){
    3a16:	00004517          	auipc	a0,0x4
    3a1a:	aaa50513          	addi	a0,a0,-1366 # 74c0 <malloc+0x1484>
    3a1e:	00002097          	auipc	ra,0x2
    3a22:	22e080e7          	jalr	558(ra) # 5c4c <unlink>
    3a26:	40054063          	bltz	a0,3e26 <subdir+0x7aa>
}
    3a2a:	60e2                	ld	ra,24(sp)
    3a2c:	6442                	ld	s0,16(sp)
    3a2e:	64a2                	ld	s1,8(sp)
    3a30:	6902                	ld	s2,0(sp)
    3a32:	6105                	addi	sp,sp,32
    3a34:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a36:	85ca                	mv	a1,s2
    3a38:	00004517          	auipc	a0,0x4
    3a3c:	a9050513          	addi	a0,a0,-1392 # 74c8 <malloc+0x148c>
    3a40:	00002097          	auipc	ra,0x2
    3a44:	544080e7          	jalr	1348(ra) # 5f84 <printf>
    exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	00002097          	auipc	ra,0x2
    3a4e:	1b2080e7          	jalr	434(ra) # 5bfc <exit>
    printf("%s: create dd/ff failed\n", s);
    3a52:	85ca                	mv	a1,s2
    3a54:	00004517          	auipc	a0,0x4
    3a58:	a9450513          	addi	a0,a0,-1388 # 74e8 <malloc+0x14ac>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	528080e7          	jalr	1320(ra) # 5f84 <printf>
    exit(1);
    3a64:	4505                	li	a0,1
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	196080e7          	jalr	406(ra) # 5bfc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a6e:	85ca                	mv	a1,s2
    3a70:	00004517          	auipc	a0,0x4
    3a74:	a9850513          	addi	a0,a0,-1384 # 7508 <malloc+0x14cc>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	50c080e7          	jalr	1292(ra) # 5f84 <printf>
    exit(1);
    3a80:	4505                	li	a0,1
    3a82:	00002097          	auipc	ra,0x2
    3a86:	17a080e7          	jalr	378(ra) # 5bfc <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3a8a:	85ca                	mv	a1,s2
    3a8c:	00004517          	auipc	a0,0x4
    3a90:	ab450513          	addi	a0,a0,-1356 # 7540 <malloc+0x1504>
    3a94:	00002097          	auipc	ra,0x2
    3a98:	4f0080e7          	jalr	1264(ra) # 5f84 <printf>
    exit(1);
    3a9c:	4505                	li	a0,1
    3a9e:	00002097          	auipc	ra,0x2
    3aa2:	15e080e7          	jalr	350(ra) # 5bfc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3aa6:	85ca                	mv	a1,s2
    3aa8:	00004517          	auipc	a0,0x4
    3aac:	ac850513          	addi	a0,a0,-1336 # 7570 <malloc+0x1534>
    3ab0:	00002097          	auipc	ra,0x2
    3ab4:	4d4080e7          	jalr	1236(ra) # 5f84 <printf>
    exit(1);
    3ab8:	4505                	li	a0,1
    3aba:	00002097          	auipc	ra,0x2
    3abe:	142080e7          	jalr	322(ra) # 5bfc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ac2:	85ca                	mv	a1,s2
    3ac4:	00004517          	auipc	a0,0x4
    3ac8:	ae450513          	addi	a0,a0,-1308 # 75a8 <malloc+0x156c>
    3acc:	00002097          	auipc	ra,0x2
    3ad0:	4b8080e7          	jalr	1208(ra) # 5f84 <printf>
    exit(1);
    3ad4:	4505                	li	a0,1
    3ad6:	00002097          	auipc	ra,0x2
    3ada:	126080e7          	jalr	294(ra) # 5bfc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3ade:	85ca                	mv	a1,s2
    3ae0:	00004517          	auipc	a0,0x4
    3ae4:	ae850513          	addi	a0,a0,-1304 # 75c8 <malloc+0x158c>
    3ae8:	00002097          	auipc	ra,0x2
    3aec:	49c080e7          	jalr	1180(ra) # 5f84 <printf>
    exit(1);
    3af0:	4505                	li	a0,1
    3af2:	00002097          	auipc	ra,0x2
    3af6:	10a080e7          	jalr	266(ra) # 5bfc <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3afa:	85ca                	mv	a1,s2
    3afc:	00004517          	auipc	a0,0x4
    3b00:	afc50513          	addi	a0,a0,-1284 # 75f8 <malloc+0x15bc>
    3b04:	00002097          	auipc	ra,0x2
    3b08:	480080e7          	jalr	1152(ra) # 5f84 <printf>
    exit(1);
    3b0c:	4505                	li	a0,1
    3b0e:	00002097          	auipc	ra,0x2
    3b12:	0ee080e7          	jalr	238(ra) # 5bfc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b16:	85ca                	mv	a1,s2
    3b18:	00004517          	auipc	a0,0x4
    3b1c:	b0850513          	addi	a0,a0,-1272 # 7620 <malloc+0x15e4>
    3b20:	00002097          	auipc	ra,0x2
    3b24:	464080e7          	jalr	1124(ra) # 5f84 <printf>
    exit(1);
    3b28:	4505                	li	a0,1
    3b2a:	00002097          	auipc	ra,0x2
    3b2e:	0d2080e7          	jalr	210(ra) # 5bfc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b32:	85ca                	mv	a1,s2
    3b34:	00004517          	auipc	a0,0x4
    3b38:	b0c50513          	addi	a0,a0,-1268 # 7640 <malloc+0x1604>
    3b3c:	00002097          	auipc	ra,0x2
    3b40:	448080e7          	jalr	1096(ra) # 5f84 <printf>
    exit(1);
    3b44:	4505                	li	a0,1
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	0b6080e7          	jalr	182(ra) # 5bfc <exit>
    printf("%s: chdir dd failed\n", s);
    3b4e:	85ca                	mv	a1,s2
    3b50:	00004517          	auipc	a0,0x4
    3b54:	b1850513          	addi	a0,a0,-1256 # 7668 <malloc+0x162c>
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	42c080e7          	jalr	1068(ra) # 5f84 <printf>
    exit(1);
    3b60:	4505                	li	a0,1
    3b62:	00002097          	auipc	ra,0x2
    3b66:	09a080e7          	jalr	154(ra) # 5bfc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b6a:	85ca                	mv	a1,s2
    3b6c:	00004517          	auipc	a0,0x4
    3b70:	b2450513          	addi	a0,a0,-1244 # 7690 <malloc+0x1654>
    3b74:	00002097          	auipc	ra,0x2
    3b78:	410080e7          	jalr	1040(ra) # 5f84 <printf>
    exit(1);
    3b7c:	4505                	li	a0,1
    3b7e:	00002097          	auipc	ra,0x2
    3b82:	07e080e7          	jalr	126(ra) # 5bfc <exit>
    printf("chdir dd/../../dd failed\n", s);
    3b86:	85ca                	mv	a1,s2
    3b88:	00004517          	auipc	a0,0x4
    3b8c:	b3850513          	addi	a0,a0,-1224 # 76c0 <malloc+0x1684>
    3b90:	00002097          	auipc	ra,0x2
    3b94:	3f4080e7          	jalr	1012(ra) # 5f84 <printf>
    exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	00002097          	auipc	ra,0x2
    3b9e:	062080e7          	jalr	98(ra) # 5bfc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3ba2:	85ca                	mv	a1,s2
    3ba4:	00004517          	auipc	a0,0x4
    3ba8:	b4450513          	addi	a0,a0,-1212 # 76e8 <malloc+0x16ac>
    3bac:	00002097          	auipc	ra,0x2
    3bb0:	3d8080e7          	jalr	984(ra) # 5f84 <printf>
    exit(1);
    3bb4:	4505                	li	a0,1
    3bb6:	00002097          	auipc	ra,0x2
    3bba:	046080e7          	jalr	70(ra) # 5bfc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3bbe:	85ca                	mv	a1,s2
    3bc0:	00004517          	auipc	a0,0x4
    3bc4:	b4050513          	addi	a0,a0,-1216 # 7700 <malloc+0x16c4>
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	3bc080e7          	jalr	956(ra) # 5f84 <printf>
    exit(1);
    3bd0:	4505                	li	a0,1
    3bd2:	00002097          	auipc	ra,0x2
    3bd6:	02a080e7          	jalr	42(ra) # 5bfc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bda:	85ca                	mv	a1,s2
    3bdc:	00004517          	auipc	a0,0x4
    3be0:	b4450513          	addi	a0,a0,-1212 # 7720 <malloc+0x16e4>
    3be4:	00002097          	auipc	ra,0x2
    3be8:	3a0080e7          	jalr	928(ra) # 5f84 <printf>
    exit(1);
    3bec:	4505                	li	a0,1
    3bee:	00002097          	auipc	ra,0x2
    3bf2:	00e080e7          	jalr	14(ra) # 5bfc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3bf6:	85ca                	mv	a1,s2
    3bf8:	00004517          	auipc	a0,0x4
    3bfc:	b4850513          	addi	a0,a0,-1208 # 7740 <malloc+0x1704>
    3c00:	00002097          	auipc	ra,0x2
    3c04:	384080e7          	jalr	900(ra) # 5f84 <printf>
    exit(1);
    3c08:	4505                	li	a0,1
    3c0a:	00002097          	auipc	ra,0x2
    3c0e:	ff2080e7          	jalr	-14(ra) # 5bfc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c12:	85ca                	mv	a1,s2
    3c14:	00004517          	auipc	a0,0x4
    3c18:	b6c50513          	addi	a0,a0,-1172 # 7780 <malloc+0x1744>
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	368080e7          	jalr	872(ra) # 5f84 <printf>
    exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00002097          	auipc	ra,0x2
    3c2a:	fd6080e7          	jalr	-42(ra) # 5bfc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c2e:	85ca                	mv	a1,s2
    3c30:	00004517          	auipc	a0,0x4
    3c34:	b8050513          	addi	a0,a0,-1152 # 77b0 <malloc+0x1774>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	34c080e7          	jalr	844(ra) # 5f84 <printf>
    exit(1);
    3c40:	4505                	li	a0,1
    3c42:	00002097          	auipc	ra,0x2
    3c46:	fba080e7          	jalr	-70(ra) # 5bfc <exit>
    printf("%s: create dd succeeded!\n", s);
    3c4a:	85ca                	mv	a1,s2
    3c4c:	00004517          	auipc	a0,0x4
    3c50:	b8450513          	addi	a0,a0,-1148 # 77d0 <malloc+0x1794>
    3c54:	00002097          	auipc	ra,0x2
    3c58:	330080e7          	jalr	816(ra) # 5f84 <printf>
    exit(1);
    3c5c:	4505                	li	a0,1
    3c5e:	00002097          	auipc	ra,0x2
    3c62:	f9e080e7          	jalr	-98(ra) # 5bfc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c66:	85ca                	mv	a1,s2
    3c68:	00004517          	auipc	a0,0x4
    3c6c:	b8850513          	addi	a0,a0,-1144 # 77f0 <malloc+0x17b4>
    3c70:	00002097          	auipc	ra,0x2
    3c74:	314080e7          	jalr	788(ra) # 5f84 <printf>
    exit(1);
    3c78:	4505                	li	a0,1
    3c7a:	00002097          	auipc	ra,0x2
    3c7e:	f82080e7          	jalr	-126(ra) # 5bfc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3c82:	85ca                	mv	a1,s2
    3c84:	00004517          	auipc	a0,0x4
    3c88:	b8c50513          	addi	a0,a0,-1140 # 7810 <malloc+0x17d4>
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	2f8080e7          	jalr	760(ra) # 5f84 <printf>
    exit(1);
    3c94:	4505                	li	a0,1
    3c96:	00002097          	auipc	ra,0x2
    3c9a:	f66080e7          	jalr	-154(ra) # 5bfc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3c9e:	85ca                	mv	a1,s2
    3ca0:	00004517          	auipc	a0,0x4
    3ca4:	ba050513          	addi	a0,a0,-1120 # 7840 <malloc+0x1804>
    3ca8:	00002097          	auipc	ra,0x2
    3cac:	2dc080e7          	jalr	732(ra) # 5f84 <printf>
    exit(1);
    3cb0:	4505                	li	a0,1
    3cb2:	00002097          	auipc	ra,0x2
    3cb6:	f4a080e7          	jalr	-182(ra) # 5bfc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cba:	85ca                	mv	a1,s2
    3cbc:	00004517          	auipc	a0,0x4
    3cc0:	bac50513          	addi	a0,a0,-1108 # 7868 <malloc+0x182c>
    3cc4:	00002097          	auipc	ra,0x2
    3cc8:	2c0080e7          	jalr	704(ra) # 5f84 <printf>
    exit(1);
    3ccc:	4505                	li	a0,1
    3cce:	00002097          	auipc	ra,0x2
    3cd2:	f2e080e7          	jalr	-210(ra) # 5bfc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cd6:	85ca                	mv	a1,s2
    3cd8:	00004517          	auipc	a0,0x4
    3cdc:	bb850513          	addi	a0,a0,-1096 # 7890 <malloc+0x1854>
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	2a4080e7          	jalr	676(ra) # 5f84 <printf>
    exit(1);
    3ce8:	4505                	li	a0,1
    3cea:	00002097          	auipc	ra,0x2
    3cee:	f12080e7          	jalr	-238(ra) # 5bfc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3cf2:	85ca                	mv	a1,s2
    3cf4:	00004517          	auipc	a0,0x4
    3cf8:	bc450513          	addi	a0,a0,-1084 # 78b8 <malloc+0x187c>
    3cfc:	00002097          	auipc	ra,0x2
    3d00:	288080e7          	jalr	648(ra) # 5f84 <printf>
    exit(1);
    3d04:	4505                	li	a0,1
    3d06:	00002097          	auipc	ra,0x2
    3d0a:	ef6080e7          	jalr	-266(ra) # 5bfc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d0e:	85ca                	mv	a1,s2
    3d10:	00004517          	auipc	a0,0x4
    3d14:	bc850513          	addi	a0,a0,-1080 # 78d8 <malloc+0x189c>
    3d18:	00002097          	auipc	ra,0x2
    3d1c:	26c080e7          	jalr	620(ra) # 5f84 <printf>
    exit(1);
    3d20:	4505                	li	a0,1
    3d22:	00002097          	auipc	ra,0x2
    3d26:	eda080e7          	jalr	-294(ra) # 5bfc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d2a:	85ca                	mv	a1,s2
    3d2c:	00004517          	auipc	a0,0x4
    3d30:	bcc50513          	addi	a0,a0,-1076 # 78f8 <malloc+0x18bc>
    3d34:	00002097          	auipc	ra,0x2
    3d38:	250080e7          	jalr	592(ra) # 5f84 <printf>
    exit(1);
    3d3c:	4505                	li	a0,1
    3d3e:	00002097          	auipc	ra,0x2
    3d42:	ebe080e7          	jalr	-322(ra) # 5bfc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d46:	85ca                	mv	a1,s2
    3d48:	00004517          	auipc	a0,0x4
    3d4c:	bd850513          	addi	a0,a0,-1064 # 7920 <malloc+0x18e4>
    3d50:	00002097          	auipc	ra,0x2
    3d54:	234080e7          	jalr	564(ra) # 5f84 <printf>
    exit(1);
    3d58:	4505                	li	a0,1
    3d5a:	00002097          	auipc	ra,0x2
    3d5e:	ea2080e7          	jalr	-350(ra) # 5bfc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d62:	85ca                	mv	a1,s2
    3d64:	00004517          	auipc	a0,0x4
    3d68:	bdc50513          	addi	a0,a0,-1060 # 7940 <malloc+0x1904>
    3d6c:	00002097          	auipc	ra,0x2
    3d70:	218080e7          	jalr	536(ra) # 5f84 <printf>
    exit(1);
    3d74:	4505                	li	a0,1
    3d76:	00002097          	auipc	ra,0x2
    3d7a:	e86080e7          	jalr	-378(ra) # 5bfc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3d7e:	85ca                	mv	a1,s2
    3d80:	00004517          	auipc	a0,0x4
    3d84:	be050513          	addi	a0,a0,-1056 # 7960 <malloc+0x1924>
    3d88:	00002097          	auipc	ra,0x2
    3d8c:	1fc080e7          	jalr	508(ra) # 5f84 <printf>
    exit(1);
    3d90:	4505                	li	a0,1
    3d92:	00002097          	auipc	ra,0x2
    3d96:	e6a080e7          	jalr	-406(ra) # 5bfc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3d9a:	85ca                	mv	a1,s2
    3d9c:	00004517          	auipc	a0,0x4
    3da0:	bec50513          	addi	a0,a0,-1044 # 7988 <malloc+0x194c>
    3da4:	00002097          	auipc	ra,0x2
    3da8:	1e0080e7          	jalr	480(ra) # 5f84 <printf>
    exit(1);
    3dac:	4505                	li	a0,1
    3dae:	00002097          	auipc	ra,0x2
    3db2:	e4e080e7          	jalr	-434(ra) # 5bfc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3db6:	85ca                	mv	a1,s2
    3db8:	00004517          	auipc	a0,0x4
    3dbc:	86850513          	addi	a0,a0,-1944 # 7620 <malloc+0x15e4>
    3dc0:	00002097          	auipc	ra,0x2
    3dc4:	1c4080e7          	jalr	452(ra) # 5f84 <printf>
    exit(1);
    3dc8:	4505                	li	a0,1
    3dca:	00002097          	auipc	ra,0x2
    3dce:	e32080e7          	jalr	-462(ra) # 5bfc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3dd2:	85ca                	mv	a1,s2
    3dd4:	00004517          	auipc	a0,0x4
    3dd8:	bd450513          	addi	a0,a0,-1068 # 79a8 <malloc+0x196c>
    3ddc:	00002097          	auipc	ra,0x2
    3de0:	1a8080e7          	jalr	424(ra) # 5f84 <printf>
    exit(1);
    3de4:	4505                	li	a0,1
    3de6:	00002097          	auipc	ra,0x2
    3dea:	e16080e7          	jalr	-490(ra) # 5bfc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3dee:	85ca                	mv	a1,s2
    3df0:	00004517          	auipc	a0,0x4
    3df4:	bd850513          	addi	a0,a0,-1064 # 79c8 <malloc+0x198c>
    3df8:	00002097          	auipc	ra,0x2
    3dfc:	18c080e7          	jalr	396(ra) # 5f84 <printf>
    exit(1);
    3e00:	4505                	li	a0,1
    3e02:	00002097          	auipc	ra,0x2
    3e06:	dfa080e7          	jalr	-518(ra) # 5bfc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e0a:	85ca                	mv	a1,s2
    3e0c:	00004517          	auipc	a0,0x4
    3e10:	bec50513          	addi	a0,a0,-1044 # 79f8 <malloc+0x19bc>
    3e14:	00002097          	auipc	ra,0x2
    3e18:	170080e7          	jalr	368(ra) # 5f84 <printf>
    exit(1);
    3e1c:	4505                	li	a0,1
    3e1e:	00002097          	auipc	ra,0x2
    3e22:	dde080e7          	jalr	-546(ra) # 5bfc <exit>
    printf("%s: unlink dd failed\n", s);
    3e26:	85ca                	mv	a1,s2
    3e28:	00004517          	auipc	a0,0x4
    3e2c:	bf050513          	addi	a0,a0,-1040 # 7a18 <malloc+0x19dc>
    3e30:	00002097          	auipc	ra,0x2
    3e34:	154080e7          	jalr	340(ra) # 5f84 <printf>
    exit(1);
    3e38:	4505                	li	a0,1
    3e3a:	00002097          	auipc	ra,0x2
    3e3e:	dc2080e7          	jalr	-574(ra) # 5bfc <exit>

0000000000003e42 <rmdot>:
{
    3e42:	1101                	addi	sp,sp,-32
    3e44:	ec06                	sd	ra,24(sp)
    3e46:	e822                	sd	s0,16(sp)
    3e48:	e426                	sd	s1,8(sp)
    3e4a:	1000                	addi	s0,sp,32
    3e4c:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e4e:	00004517          	auipc	a0,0x4
    3e52:	be250513          	addi	a0,a0,-1054 # 7a30 <malloc+0x19f4>
    3e56:	00002097          	auipc	ra,0x2
    3e5a:	e0e080e7          	jalr	-498(ra) # 5c64 <mkdir>
    3e5e:	e549                	bnez	a0,3ee8 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e60:	00004517          	auipc	a0,0x4
    3e64:	bd050513          	addi	a0,a0,-1072 # 7a30 <malloc+0x19f4>
    3e68:	00002097          	auipc	ra,0x2
    3e6c:	e04080e7          	jalr	-508(ra) # 5c6c <chdir>
    3e70:	e951                	bnez	a0,3f04 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e72:	00003517          	auipc	a0,0x3
    3e76:	9ee50513          	addi	a0,a0,-1554 # 6860 <malloc+0x824>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	dd2080e7          	jalr	-558(ra) # 5c4c <unlink>
    3e82:	cd59                	beqz	a0,3f20 <rmdot+0xde>
  if(unlink("..") == 0){
    3e84:	00003517          	auipc	a0,0x3
    3e88:	60450513          	addi	a0,a0,1540 # 7488 <malloc+0x144c>
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	dc0080e7          	jalr	-576(ra) # 5c4c <unlink>
    3e94:	c545                	beqz	a0,3f3c <rmdot+0xfa>
  if(chdir("/") != 0){
    3e96:	00003517          	auipc	a0,0x3
    3e9a:	59a50513          	addi	a0,a0,1434 # 7430 <malloc+0x13f4>
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	dce080e7          	jalr	-562(ra) # 5c6c <chdir>
    3ea6:	e94d                	bnez	a0,3f58 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3ea8:	00004517          	auipc	a0,0x4
    3eac:	bf050513          	addi	a0,a0,-1040 # 7a98 <malloc+0x1a5c>
    3eb0:	00002097          	auipc	ra,0x2
    3eb4:	d9c080e7          	jalr	-612(ra) # 5c4c <unlink>
    3eb8:	cd55                	beqz	a0,3f74 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3eba:	00004517          	auipc	a0,0x4
    3ebe:	c0650513          	addi	a0,a0,-1018 # 7ac0 <malloc+0x1a84>
    3ec2:	00002097          	auipc	ra,0x2
    3ec6:	d8a080e7          	jalr	-630(ra) # 5c4c <unlink>
    3eca:	c179                	beqz	a0,3f90 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3ecc:	00004517          	auipc	a0,0x4
    3ed0:	b6450513          	addi	a0,a0,-1180 # 7a30 <malloc+0x19f4>
    3ed4:	00002097          	auipc	ra,0x2
    3ed8:	d78080e7          	jalr	-648(ra) # 5c4c <unlink>
    3edc:	e961                	bnez	a0,3fac <rmdot+0x16a>
}
    3ede:	60e2                	ld	ra,24(sp)
    3ee0:	6442                	ld	s0,16(sp)
    3ee2:	64a2                	ld	s1,8(sp)
    3ee4:	6105                	addi	sp,sp,32
    3ee6:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3ee8:	85a6                	mv	a1,s1
    3eea:	00004517          	auipc	a0,0x4
    3eee:	b4e50513          	addi	a0,a0,-1202 # 7a38 <malloc+0x19fc>
    3ef2:	00002097          	auipc	ra,0x2
    3ef6:	092080e7          	jalr	146(ra) # 5f84 <printf>
    exit(1);
    3efa:	4505                	li	a0,1
    3efc:	00002097          	auipc	ra,0x2
    3f00:	d00080e7          	jalr	-768(ra) # 5bfc <exit>
    printf("%s: chdir dots failed\n", s);
    3f04:	85a6                	mv	a1,s1
    3f06:	00004517          	auipc	a0,0x4
    3f0a:	b4a50513          	addi	a0,a0,-1206 # 7a50 <malloc+0x1a14>
    3f0e:	00002097          	auipc	ra,0x2
    3f12:	076080e7          	jalr	118(ra) # 5f84 <printf>
    exit(1);
    3f16:	4505                	li	a0,1
    3f18:	00002097          	auipc	ra,0x2
    3f1c:	ce4080e7          	jalr	-796(ra) # 5bfc <exit>
    printf("%s: rm . worked!\n", s);
    3f20:	85a6                	mv	a1,s1
    3f22:	00004517          	auipc	a0,0x4
    3f26:	b4650513          	addi	a0,a0,-1210 # 7a68 <malloc+0x1a2c>
    3f2a:	00002097          	auipc	ra,0x2
    3f2e:	05a080e7          	jalr	90(ra) # 5f84 <printf>
    exit(1);
    3f32:	4505                	li	a0,1
    3f34:	00002097          	auipc	ra,0x2
    3f38:	cc8080e7          	jalr	-824(ra) # 5bfc <exit>
    printf("%s: rm .. worked!\n", s);
    3f3c:	85a6                	mv	a1,s1
    3f3e:	00004517          	auipc	a0,0x4
    3f42:	b4250513          	addi	a0,a0,-1214 # 7a80 <malloc+0x1a44>
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	03e080e7          	jalr	62(ra) # 5f84 <printf>
    exit(1);
    3f4e:	4505                	li	a0,1
    3f50:	00002097          	auipc	ra,0x2
    3f54:	cac080e7          	jalr	-852(ra) # 5bfc <exit>
    printf("%s: chdir / failed\n", s);
    3f58:	85a6                	mv	a1,s1
    3f5a:	00003517          	auipc	a0,0x3
    3f5e:	4de50513          	addi	a0,a0,1246 # 7438 <malloc+0x13fc>
    3f62:	00002097          	auipc	ra,0x2
    3f66:	022080e7          	jalr	34(ra) # 5f84 <printf>
    exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	00002097          	auipc	ra,0x2
    3f70:	c90080e7          	jalr	-880(ra) # 5bfc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f74:	85a6                	mv	a1,s1
    3f76:	00004517          	auipc	a0,0x4
    3f7a:	b2a50513          	addi	a0,a0,-1238 # 7aa0 <malloc+0x1a64>
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	006080e7          	jalr	6(ra) # 5f84 <printf>
    exit(1);
    3f86:	4505                	li	a0,1
    3f88:	00002097          	auipc	ra,0x2
    3f8c:	c74080e7          	jalr	-908(ra) # 5bfc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3f90:	85a6                	mv	a1,s1
    3f92:	00004517          	auipc	a0,0x4
    3f96:	b3650513          	addi	a0,a0,-1226 # 7ac8 <malloc+0x1a8c>
    3f9a:	00002097          	auipc	ra,0x2
    3f9e:	fea080e7          	jalr	-22(ra) # 5f84 <printf>
    exit(1);
    3fa2:	4505                	li	a0,1
    3fa4:	00002097          	auipc	ra,0x2
    3fa8:	c58080e7          	jalr	-936(ra) # 5bfc <exit>
    printf("%s: unlink dots failed!\n", s);
    3fac:	85a6                	mv	a1,s1
    3fae:	00004517          	auipc	a0,0x4
    3fb2:	b3a50513          	addi	a0,a0,-1222 # 7ae8 <malloc+0x1aac>
    3fb6:	00002097          	auipc	ra,0x2
    3fba:	fce080e7          	jalr	-50(ra) # 5f84 <printf>
    exit(1);
    3fbe:	4505                	li	a0,1
    3fc0:	00002097          	auipc	ra,0x2
    3fc4:	c3c080e7          	jalr	-964(ra) # 5bfc <exit>

0000000000003fc8 <dirfile>:
{
    3fc8:	1101                	addi	sp,sp,-32
    3fca:	ec06                	sd	ra,24(sp)
    3fcc:	e822                	sd	s0,16(sp)
    3fce:	e426                	sd	s1,8(sp)
    3fd0:	e04a                	sd	s2,0(sp)
    3fd2:	1000                	addi	s0,sp,32
    3fd4:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3fd6:	20000593          	li	a1,512
    3fda:	00004517          	auipc	a0,0x4
    3fde:	b2e50513          	addi	a0,a0,-1234 # 7b08 <malloc+0x1acc>
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	c5a080e7          	jalr	-934(ra) # 5c3c <open>
  if(fd < 0){
    3fea:	0e054d63          	bltz	a0,40e4 <dirfile+0x11c>
  close(fd);
    3fee:	00002097          	auipc	ra,0x2
    3ff2:	c36080e7          	jalr	-970(ra) # 5c24 <close>
  if(chdir("dirfile") == 0){
    3ff6:	00004517          	auipc	a0,0x4
    3ffa:	b1250513          	addi	a0,a0,-1262 # 7b08 <malloc+0x1acc>
    3ffe:	00002097          	auipc	ra,0x2
    4002:	c6e080e7          	jalr	-914(ra) # 5c6c <chdir>
    4006:	cd6d                	beqz	a0,4100 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4008:	4581                	li	a1,0
    400a:	00004517          	auipc	a0,0x4
    400e:	b4650513          	addi	a0,a0,-1210 # 7b50 <malloc+0x1b14>
    4012:	00002097          	auipc	ra,0x2
    4016:	c2a080e7          	jalr	-982(ra) # 5c3c <open>
  if(fd >= 0){
    401a:	10055163          	bgez	a0,411c <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    401e:	20000593          	li	a1,512
    4022:	00004517          	auipc	a0,0x4
    4026:	b2e50513          	addi	a0,a0,-1234 # 7b50 <malloc+0x1b14>
    402a:	00002097          	auipc	ra,0x2
    402e:	c12080e7          	jalr	-1006(ra) # 5c3c <open>
  if(fd >= 0){
    4032:	10055363          	bgez	a0,4138 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4036:	00004517          	auipc	a0,0x4
    403a:	b1a50513          	addi	a0,a0,-1254 # 7b50 <malloc+0x1b14>
    403e:	00002097          	auipc	ra,0x2
    4042:	c26080e7          	jalr	-986(ra) # 5c64 <mkdir>
    4046:	10050763          	beqz	a0,4154 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    404a:	00004517          	auipc	a0,0x4
    404e:	b0650513          	addi	a0,a0,-1274 # 7b50 <malloc+0x1b14>
    4052:	00002097          	auipc	ra,0x2
    4056:	bfa080e7          	jalr	-1030(ra) # 5c4c <unlink>
    405a:	10050b63          	beqz	a0,4170 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    405e:	00004597          	auipc	a1,0x4
    4062:	af258593          	addi	a1,a1,-1294 # 7b50 <malloc+0x1b14>
    4066:	00002517          	auipc	a0,0x2
    406a:	2ea50513          	addi	a0,a0,746 # 6350 <malloc+0x314>
    406e:	00002097          	auipc	ra,0x2
    4072:	bee080e7          	jalr	-1042(ra) # 5c5c <link>
    4076:	10050b63          	beqz	a0,418c <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    407a:	00004517          	auipc	a0,0x4
    407e:	a8e50513          	addi	a0,a0,-1394 # 7b08 <malloc+0x1acc>
    4082:	00002097          	auipc	ra,0x2
    4086:	bca080e7          	jalr	-1078(ra) # 5c4c <unlink>
    408a:	10051f63          	bnez	a0,41a8 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    408e:	4589                	li	a1,2
    4090:	00002517          	auipc	a0,0x2
    4094:	7d050513          	addi	a0,a0,2000 # 6860 <malloc+0x824>
    4098:	00002097          	auipc	ra,0x2
    409c:	ba4080e7          	jalr	-1116(ra) # 5c3c <open>
  if(fd >= 0){
    40a0:	12055263          	bgez	a0,41c4 <dirfile+0x1fc>
  fd = open(".", 0);
    40a4:	4581                	li	a1,0
    40a6:	00002517          	auipc	a0,0x2
    40aa:	7ba50513          	addi	a0,a0,1978 # 6860 <malloc+0x824>
    40ae:	00002097          	auipc	ra,0x2
    40b2:	b8e080e7          	jalr	-1138(ra) # 5c3c <open>
    40b6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40b8:	4605                	li	a2,1
    40ba:	00002597          	auipc	a1,0x2
    40be:	12e58593          	addi	a1,a1,302 # 61e8 <malloc+0x1ac>
    40c2:	00002097          	auipc	ra,0x2
    40c6:	b5a080e7          	jalr	-1190(ra) # 5c1c <write>
    40ca:	10a04b63          	bgtz	a0,41e0 <dirfile+0x218>
  close(fd);
    40ce:	8526                	mv	a0,s1
    40d0:	00002097          	auipc	ra,0x2
    40d4:	b54080e7          	jalr	-1196(ra) # 5c24 <close>
}
    40d8:	60e2                	ld	ra,24(sp)
    40da:	6442                	ld	s0,16(sp)
    40dc:	64a2                	ld	s1,8(sp)
    40de:	6902                	ld	s2,0(sp)
    40e0:	6105                	addi	sp,sp,32
    40e2:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    40e4:	85ca                	mv	a1,s2
    40e6:	00004517          	auipc	a0,0x4
    40ea:	a2a50513          	addi	a0,a0,-1494 # 7b10 <malloc+0x1ad4>
    40ee:	00002097          	auipc	ra,0x2
    40f2:	e96080e7          	jalr	-362(ra) # 5f84 <printf>
    exit(1);
    40f6:	4505                	li	a0,1
    40f8:	00002097          	auipc	ra,0x2
    40fc:	b04080e7          	jalr	-1276(ra) # 5bfc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4100:	85ca                	mv	a1,s2
    4102:	00004517          	auipc	a0,0x4
    4106:	a2e50513          	addi	a0,a0,-1490 # 7b30 <malloc+0x1af4>
    410a:	00002097          	auipc	ra,0x2
    410e:	e7a080e7          	jalr	-390(ra) # 5f84 <printf>
    exit(1);
    4112:	4505                	li	a0,1
    4114:	00002097          	auipc	ra,0x2
    4118:	ae8080e7          	jalr	-1304(ra) # 5bfc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    411c:	85ca                	mv	a1,s2
    411e:	00004517          	auipc	a0,0x4
    4122:	a4250513          	addi	a0,a0,-1470 # 7b60 <malloc+0x1b24>
    4126:	00002097          	auipc	ra,0x2
    412a:	e5e080e7          	jalr	-418(ra) # 5f84 <printf>
    exit(1);
    412e:	4505                	li	a0,1
    4130:	00002097          	auipc	ra,0x2
    4134:	acc080e7          	jalr	-1332(ra) # 5bfc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4138:	85ca                	mv	a1,s2
    413a:	00004517          	auipc	a0,0x4
    413e:	a2650513          	addi	a0,a0,-1498 # 7b60 <malloc+0x1b24>
    4142:	00002097          	auipc	ra,0x2
    4146:	e42080e7          	jalr	-446(ra) # 5f84 <printf>
    exit(1);
    414a:	4505                	li	a0,1
    414c:	00002097          	auipc	ra,0x2
    4150:	ab0080e7          	jalr	-1360(ra) # 5bfc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4154:	85ca                	mv	a1,s2
    4156:	00004517          	auipc	a0,0x4
    415a:	a3250513          	addi	a0,a0,-1486 # 7b88 <malloc+0x1b4c>
    415e:	00002097          	auipc	ra,0x2
    4162:	e26080e7          	jalr	-474(ra) # 5f84 <printf>
    exit(1);
    4166:	4505                	li	a0,1
    4168:	00002097          	auipc	ra,0x2
    416c:	a94080e7          	jalr	-1388(ra) # 5bfc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4170:	85ca                	mv	a1,s2
    4172:	00004517          	auipc	a0,0x4
    4176:	a3e50513          	addi	a0,a0,-1474 # 7bb0 <malloc+0x1b74>
    417a:	00002097          	auipc	ra,0x2
    417e:	e0a080e7          	jalr	-502(ra) # 5f84 <printf>
    exit(1);
    4182:	4505                	li	a0,1
    4184:	00002097          	auipc	ra,0x2
    4188:	a78080e7          	jalr	-1416(ra) # 5bfc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    418c:	85ca                	mv	a1,s2
    418e:	00004517          	auipc	a0,0x4
    4192:	a4a50513          	addi	a0,a0,-1462 # 7bd8 <malloc+0x1b9c>
    4196:	00002097          	auipc	ra,0x2
    419a:	dee080e7          	jalr	-530(ra) # 5f84 <printf>
    exit(1);
    419e:	4505                	li	a0,1
    41a0:	00002097          	auipc	ra,0x2
    41a4:	a5c080e7          	jalr	-1444(ra) # 5bfc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41a8:	85ca                	mv	a1,s2
    41aa:	00004517          	auipc	a0,0x4
    41ae:	a5650513          	addi	a0,a0,-1450 # 7c00 <malloc+0x1bc4>
    41b2:	00002097          	auipc	ra,0x2
    41b6:	dd2080e7          	jalr	-558(ra) # 5f84 <printf>
    exit(1);
    41ba:	4505                	li	a0,1
    41bc:	00002097          	auipc	ra,0x2
    41c0:	a40080e7          	jalr	-1472(ra) # 5bfc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41c4:	85ca                	mv	a1,s2
    41c6:	00004517          	auipc	a0,0x4
    41ca:	a5a50513          	addi	a0,a0,-1446 # 7c20 <malloc+0x1be4>
    41ce:	00002097          	auipc	ra,0x2
    41d2:	db6080e7          	jalr	-586(ra) # 5f84 <printf>
    exit(1);
    41d6:	4505                	li	a0,1
    41d8:	00002097          	auipc	ra,0x2
    41dc:	a24080e7          	jalr	-1500(ra) # 5bfc <exit>
    printf("%s: write . succeeded!\n", s);
    41e0:	85ca                	mv	a1,s2
    41e2:	00004517          	auipc	a0,0x4
    41e6:	a6650513          	addi	a0,a0,-1434 # 7c48 <malloc+0x1c0c>
    41ea:	00002097          	auipc	ra,0x2
    41ee:	d9a080e7          	jalr	-614(ra) # 5f84 <printf>
    exit(1);
    41f2:	4505                	li	a0,1
    41f4:	00002097          	auipc	ra,0x2
    41f8:	a08080e7          	jalr	-1528(ra) # 5bfc <exit>

00000000000041fc <iref>:
{
    41fc:	7139                	addi	sp,sp,-64
    41fe:	fc06                	sd	ra,56(sp)
    4200:	f822                	sd	s0,48(sp)
    4202:	f426                	sd	s1,40(sp)
    4204:	f04a                	sd	s2,32(sp)
    4206:	ec4e                	sd	s3,24(sp)
    4208:	e852                	sd	s4,16(sp)
    420a:	e456                	sd	s5,8(sp)
    420c:	e05a                	sd	s6,0(sp)
    420e:	0080                	addi	s0,sp,64
    4210:	8b2a                	mv	s6,a0
    4212:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4216:	00004a17          	auipc	s4,0x4
    421a:	a4aa0a13          	addi	s4,s4,-1462 # 7c60 <malloc+0x1c24>
    mkdir("");
    421e:	00003497          	auipc	s1,0x3
    4222:	54a48493          	addi	s1,s1,1354 # 7768 <malloc+0x172c>
    link("README", "");
    4226:	00002a97          	auipc	s5,0x2
    422a:	12aa8a93          	addi	s5,s5,298 # 6350 <malloc+0x314>
    fd = open("xx", O_CREATE);
    422e:	00004997          	auipc	s3,0x4
    4232:	92a98993          	addi	s3,s3,-1750 # 7b58 <malloc+0x1b1c>
    4236:	a891                	j	428a <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    4238:	85da                	mv	a1,s6
    423a:	00004517          	auipc	a0,0x4
    423e:	a2e50513          	addi	a0,a0,-1490 # 7c68 <malloc+0x1c2c>
    4242:	00002097          	auipc	ra,0x2
    4246:	d42080e7          	jalr	-702(ra) # 5f84 <printf>
      exit(1);
    424a:	4505                	li	a0,1
    424c:	00002097          	auipc	ra,0x2
    4250:	9b0080e7          	jalr	-1616(ra) # 5bfc <exit>
      printf("%s: chdir irefd failed\n", s);
    4254:	85da                	mv	a1,s6
    4256:	00004517          	auipc	a0,0x4
    425a:	a2a50513          	addi	a0,a0,-1494 # 7c80 <malloc+0x1c44>
    425e:	00002097          	auipc	ra,0x2
    4262:	d26080e7          	jalr	-730(ra) # 5f84 <printf>
      exit(1);
    4266:	4505                	li	a0,1
    4268:	00002097          	auipc	ra,0x2
    426c:	994080e7          	jalr	-1644(ra) # 5bfc <exit>
      close(fd);
    4270:	00002097          	auipc	ra,0x2
    4274:	9b4080e7          	jalr	-1612(ra) # 5c24 <close>
    4278:	a889                	j	42ca <iref+0xce>
    unlink("xx");
    427a:	854e                	mv	a0,s3
    427c:	00002097          	auipc	ra,0x2
    4280:	9d0080e7          	jalr	-1584(ra) # 5c4c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4284:	397d                	addiw	s2,s2,-1
    4286:	06090063          	beqz	s2,42e6 <iref+0xea>
    if(mkdir("irefd") != 0){
    428a:	8552                	mv	a0,s4
    428c:	00002097          	auipc	ra,0x2
    4290:	9d8080e7          	jalr	-1576(ra) # 5c64 <mkdir>
    4294:	f155                	bnez	a0,4238 <iref+0x3c>
    if(chdir("irefd") != 0){
    4296:	8552                	mv	a0,s4
    4298:	00002097          	auipc	ra,0x2
    429c:	9d4080e7          	jalr	-1580(ra) # 5c6c <chdir>
    42a0:	f955                	bnez	a0,4254 <iref+0x58>
    mkdir("");
    42a2:	8526                	mv	a0,s1
    42a4:	00002097          	auipc	ra,0x2
    42a8:	9c0080e7          	jalr	-1600(ra) # 5c64 <mkdir>
    link("README", "");
    42ac:	85a6                	mv	a1,s1
    42ae:	8556                	mv	a0,s5
    42b0:	00002097          	auipc	ra,0x2
    42b4:	9ac080e7          	jalr	-1620(ra) # 5c5c <link>
    fd = open("", O_CREATE);
    42b8:	20000593          	li	a1,512
    42bc:	8526                	mv	a0,s1
    42be:	00002097          	auipc	ra,0x2
    42c2:	97e080e7          	jalr	-1666(ra) # 5c3c <open>
    if(fd >= 0)
    42c6:	fa0555e3          	bgez	a0,4270 <iref+0x74>
    fd = open("xx", O_CREATE);
    42ca:	20000593          	li	a1,512
    42ce:	854e                	mv	a0,s3
    42d0:	00002097          	auipc	ra,0x2
    42d4:	96c080e7          	jalr	-1684(ra) # 5c3c <open>
    if(fd >= 0)
    42d8:	fa0541e3          	bltz	a0,427a <iref+0x7e>
      close(fd);
    42dc:	00002097          	auipc	ra,0x2
    42e0:	948080e7          	jalr	-1720(ra) # 5c24 <close>
    42e4:	bf59                	j	427a <iref+0x7e>
    42e6:	03300493          	li	s1,51
    chdir("..");
    42ea:	00003997          	auipc	s3,0x3
    42ee:	19e98993          	addi	s3,s3,414 # 7488 <malloc+0x144c>
    unlink("irefd");
    42f2:	00004917          	auipc	s2,0x4
    42f6:	96e90913          	addi	s2,s2,-1682 # 7c60 <malloc+0x1c24>
    chdir("..");
    42fa:	854e                	mv	a0,s3
    42fc:	00002097          	auipc	ra,0x2
    4300:	970080e7          	jalr	-1680(ra) # 5c6c <chdir>
    unlink("irefd");
    4304:	854a                	mv	a0,s2
    4306:	00002097          	auipc	ra,0x2
    430a:	946080e7          	jalr	-1722(ra) # 5c4c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    430e:	34fd                	addiw	s1,s1,-1
    4310:	f4ed                	bnez	s1,42fa <iref+0xfe>
  chdir("/");
    4312:	00003517          	auipc	a0,0x3
    4316:	11e50513          	addi	a0,a0,286 # 7430 <malloc+0x13f4>
    431a:	00002097          	auipc	ra,0x2
    431e:	952080e7          	jalr	-1710(ra) # 5c6c <chdir>
}
    4322:	70e2                	ld	ra,56(sp)
    4324:	7442                	ld	s0,48(sp)
    4326:	74a2                	ld	s1,40(sp)
    4328:	7902                	ld	s2,32(sp)
    432a:	69e2                	ld	s3,24(sp)
    432c:	6a42                	ld	s4,16(sp)
    432e:	6aa2                	ld	s5,8(sp)
    4330:	6b02                	ld	s6,0(sp)
    4332:	6121                	addi	sp,sp,64
    4334:	8082                	ret

0000000000004336 <openiputtest>:
{
    4336:	7179                	addi	sp,sp,-48
    4338:	f406                	sd	ra,40(sp)
    433a:	f022                	sd	s0,32(sp)
    433c:	ec26                	sd	s1,24(sp)
    433e:	1800                	addi	s0,sp,48
    4340:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4342:	00004517          	auipc	a0,0x4
    4346:	95650513          	addi	a0,a0,-1706 # 7c98 <malloc+0x1c5c>
    434a:	00002097          	auipc	ra,0x2
    434e:	91a080e7          	jalr	-1766(ra) # 5c64 <mkdir>
    4352:	04054263          	bltz	a0,4396 <openiputtest+0x60>
  pid = fork();
    4356:	00002097          	auipc	ra,0x2
    435a:	89e080e7          	jalr	-1890(ra) # 5bf4 <fork>
  if(pid < 0){
    435e:	04054a63          	bltz	a0,43b2 <openiputtest+0x7c>
  if(pid == 0){
    4362:	e93d                	bnez	a0,43d8 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4364:	4589                	li	a1,2
    4366:	00004517          	auipc	a0,0x4
    436a:	93250513          	addi	a0,a0,-1742 # 7c98 <malloc+0x1c5c>
    436e:	00002097          	auipc	ra,0x2
    4372:	8ce080e7          	jalr	-1842(ra) # 5c3c <open>
    if(fd >= 0){
    4376:	04054c63          	bltz	a0,43ce <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    437a:	85a6                	mv	a1,s1
    437c:	00004517          	auipc	a0,0x4
    4380:	93c50513          	addi	a0,a0,-1732 # 7cb8 <malloc+0x1c7c>
    4384:	00002097          	auipc	ra,0x2
    4388:	c00080e7          	jalr	-1024(ra) # 5f84 <printf>
      exit(1);
    438c:	4505                	li	a0,1
    438e:	00002097          	auipc	ra,0x2
    4392:	86e080e7          	jalr	-1938(ra) # 5bfc <exit>
    printf("%s: mkdir oidir failed\n", s);
    4396:	85a6                	mv	a1,s1
    4398:	00004517          	auipc	a0,0x4
    439c:	90850513          	addi	a0,a0,-1784 # 7ca0 <malloc+0x1c64>
    43a0:	00002097          	auipc	ra,0x2
    43a4:	be4080e7          	jalr	-1052(ra) # 5f84 <printf>
    exit(1);
    43a8:	4505                	li	a0,1
    43aa:	00002097          	auipc	ra,0x2
    43ae:	852080e7          	jalr	-1966(ra) # 5bfc <exit>
    printf("%s: fork failed\n", s);
    43b2:	85a6                	mv	a1,s1
    43b4:	00002517          	auipc	a0,0x2
    43b8:	64c50513          	addi	a0,a0,1612 # 6a00 <malloc+0x9c4>
    43bc:	00002097          	auipc	ra,0x2
    43c0:	bc8080e7          	jalr	-1080(ra) # 5f84 <printf>
    exit(1);
    43c4:	4505                	li	a0,1
    43c6:	00002097          	auipc	ra,0x2
    43ca:	836080e7          	jalr	-1994(ra) # 5bfc <exit>
    exit(0);
    43ce:	4501                	li	a0,0
    43d0:	00002097          	auipc	ra,0x2
    43d4:	82c080e7          	jalr	-2004(ra) # 5bfc <exit>
  sleep(1);
    43d8:	4505                	li	a0,1
    43da:	00002097          	auipc	ra,0x2
    43de:	8b2080e7          	jalr	-1870(ra) # 5c8c <sleep>
  if(unlink("oidir") != 0){
    43e2:	00004517          	auipc	a0,0x4
    43e6:	8b650513          	addi	a0,a0,-1866 # 7c98 <malloc+0x1c5c>
    43ea:	00002097          	auipc	ra,0x2
    43ee:	862080e7          	jalr	-1950(ra) # 5c4c <unlink>
    43f2:	cd19                	beqz	a0,4410 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    43f4:	85a6                	mv	a1,s1
    43f6:	00002517          	auipc	a0,0x2
    43fa:	7fa50513          	addi	a0,a0,2042 # 6bf0 <malloc+0xbb4>
    43fe:	00002097          	auipc	ra,0x2
    4402:	b86080e7          	jalr	-1146(ra) # 5f84 <printf>
    exit(1);
    4406:	4505                	li	a0,1
    4408:	00001097          	auipc	ra,0x1
    440c:	7f4080e7          	jalr	2036(ra) # 5bfc <exit>
  wait(&xstatus);
    4410:	fdc40513          	addi	a0,s0,-36
    4414:	00001097          	auipc	ra,0x1
    4418:	7f0080e7          	jalr	2032(ra) # 5c04 <wait>
  exit(xstatus);
    441c:	fdc42503          	lw	a0,-36(s0)
    4420:	00001097          	auipc	ra,0x1
    4424:	7dc080e7          	jalr	2012(ra) # 5bfc <exit>

0000000000004428 <forkforkfork>:
{
    4428:	1101                	addi	sp,sp,-32
    442a:	ec06                	sd	ra,24(sp)
    442c:	e822                	sd	s0,16(sp)
    442e:	e426                	sd	s1,8(sp)
    4430:	1000                	addi	s0,sp,32
    4432:	84aa                	mv	s1,a0
  unlink("stopforking");
    4434:	00004517          	auipc	a0,0x4
    4438:	8ac50513          	addi	a0,a0,-1876 # 7ce0 <malloc+0x1ca4>
    443c:	00002097          	auipc	ra,0x2
    4440:	810080e7          	jalr	-2032(ra) # 5c4c <unlink>
  int pid = fork();
    4444:	00001097          	auipc	ra,0x1
    4448:	7b0080e7          	jalr	1968(ra) # 5bf4 <fork>
  if(pid < 0){
    444c:	04054563          	bltz	a0,4496 <forkforkfork+0x6e>
  if(pid == 0){
    4450:	c12d                	beqz	a0,44b2 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4452:	4551                	li	a0,20
    4454:	00002097          	auipc	ra,0x2
    4458:	838080e7          	jalr	-1992(ra) # 5c8c <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    445c:	20200593          	li	a1,514
    4460:	00004517          	auipc	a0,0x4
    4464:	88050513          	addi	a0,a0,-1920 # 7ce0 <malloc+0x1ca4>
    4468:	00001097          	auipc	ra,0x1
    446c:	7d4080e7          	jalr	2004(ra) # 5c3c <open>
    4470:	00001097          	auipc	ra,0x1
    4474:	7b4080e7          	jalr	1972(ra) # 5c24 <close>
  wait(0);
    4478:	4501                	li	a0,0
    447a:	00001097          	auipc	ra,0x1
    447e:	78a080e7          	jalr	1930(ra) # 5c04 <wait>
  sleep(10); // one second
    4482:	4529                	li	a0,10
    4484:	00002097          	auipc	ra,0x2
    4488:	808080e7          	jalr	-2040(ra) # 5c8c <sleep>
}
    448c:	60e2                	ld	ra,24(sp)
    448e:	6442                	ld	s0,16(sp)
    4490:	64a2                	ld	s1,8(sp)
    4492:	6105                	addi	sp,sp,32
    4494:	8082                	ret
    printf("%s: fork failed", s);
    4496:	85a6                	mv	a1,s1
    4498:	00002517          	auipc	a0,0x2
    449c:	72850513          	addi	a0,a0,1832 # 6bc0 <malloc+0xb84>
    44a0:	00002097          	auipc	ra,0x2
    44a4:	ae4080e7          	jalr	-1308(ra) # 5f84 <printf>
    exit(1);
    44a8:	4505                	li	a0,1
    44aa:	00001097          	auipc	ra,0x1
    44ae:	752080e7          	jalr	1874(ra) # 5bfc <exit>
      int fd = open("stopforking", 0);
    44b2:	00004497          	auipc	s1,0x4
    44b6:	82e48493          	addi	s1,s1,-2002 # 7ce0 <malloc+0x1ca4>
    44ba:	4581                	li	a1,0
    44bc:	8526                	mv	a0,s1
    44be:	00001097          	auipc	ra,0x1
    44c2:	77e080e7          	jalr	1918(ra) # 5c3c <open>
      if(fd >= 0){
    44c6:	02055763          	bgez	a0,44f4 <forkforkfork+0xcc>
      if(fork() < 0){
    44ca:	00001097          	auipc	ra,0x1
    44ce:	72a080e7          	jalr	1834(ra) # 5bf4 <fork>
    44d2:	fe0554e3          	bgez	a0,44ba <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44d6:	20200593          	li	a1,514
    44da:	00004517          	auipc	a0,0x4
    44de:	80650513          	addi	a0,a0,-2042 # 7ce0 <malloc+0x1ca4>
    44e2:	00001097          	auipc	ra,0x1
    44e6:	75a080e7          	jalr	1882(ra) # 5c3c <open>
    44ea:	00001097          	auipc	ra,0x1
    44ee:	73a080e7          	jalr	1850(ra) # 5c24 <close>
    44f2:	b7e1                	j	44ba <forkforkfork+0x92>
        exit(0);
    44f4:	4501                	li	a0,0
    44f6:	00001097          	auipc	ra,0x1
    44fa:	706080e7          	jalr	1798(ra) # 5bfc <exit>

00000000000044fe <killstatus>:
{
    44fe:	7139                	addi	sp,sp,-64
    4500:	fc06                	sd	ra,56(sp)
    4502:	f822                	sd	s0,48(sp)
    4504:	f426                	sd	s1,40(sp)
    4506:	f04a                	sd	s2,32(sp)
    4508:	ec4e                	sd	s3,24(sp)
    450a:	e852                	sd	s4,16(sp)
    450c:	0080                	addi	s0,sp,64
    450e:	8a2a                	mv	s4,a0
    4510:	06400913          	li	s2,100
    if(xst != -1) {
    4514:	59fd                	li	s3,-1
    int pid1 = fork();
    4516:	00001097          	auipc	ra,0x1
    451a:	6de080e7          	jalr	1758(ra) # 5bf4 <fork>
    451e:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4520:	02054f63          	bltz	a0,455e <killstatus+0x60>
    if(pid1 == 0){
    4524:	c939                	beqz	a0,457a <killstatus+0x7c>
    sleep(1);
    4526:	4505                	li	a0,1
    4528:	00001097          	auipc	ra,0x1
    452c:	764080e7          	jalr	1892(ra) # 5c8c <sleep>
    kill(pid1);
    4530:	8526                	mv	a0,s1
    4532:	00001097          	auipc	ra,0x1
    4536:	6fa080e7          	jalr	1786(ra) # 5c2c <kill>
    wait(&xst);
    453a:	fcc40513          	addi	a0,s0,-52
    453e:	00001097          	auipc	ra,0x1
    4542:	6c6080e7          	jalr	1734(ra) # 5c04 <wait>
    if(xst != -1) {
    4546:	fcc42783          	lw	a5,-52(s0)
    454a:	03379d63          	bne	a5,s3,4584 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    454e:	397d                	addiw	s2,s2,-1
    4550:	fc0913e3          	bnez	s2,4516 <killstatus+0x18>
  exit(0);
    4554:	4501                	li	a0,0
    4556:	00001097          	auipc	ra,0x1
    455a:	6a6080e7          	jalr	1702(ra) # 5bfc <exit>
      printf("%s: fork failed\n", s);
    455e:	85d2                	mv	a1,s4
    4560:	00002517          	auipc	a0,0x2
    4564:	4a050513          	addi	a0,a0,1184 # 6a00 <malloc+0x9c4>
    4568:	00002097          	auipc	ra,0x2
    456c:	a1c080e7          	jalr	-1508(ra) # 5f84 <printf>
      exit(1);
    4570:	4505                	li	a0,1
    4572:	00001097          	auipc	ra,0x1
    4576:	68a080e7          	jalr	1674(ra) # 5bfc <exit>
        getpid();
    457a:	00001097          	auipc	ra,0x1
    457e:	702080e7          	jalr	1794(ra) # 5c7c <getpid>
      while(1) {
    4582:	bfe5                	j	457a <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    4584:	85d2                	mv	a1,s4
    4586:	00003517          	auipc	a0,0x3
    458a:	76a50513          	addi	a0,a0,1898 # 7cf0 <malloc+0x1cb4>
    458e:	00002097          	auipc	ra,0x2
    4592:	9f6080e7          	jalr	-1546(ra) # 5f84 <printf>
       exit(1);
    4596:	4505                	li	a0,1
    4598:	00001097          	auipc	ra,0x1
    459c:	664080e7          	jalr	1636(ra) # 5bfc <exit>

00000000000045a0 <preempt>:
{
    45a0:	7139                	addi	sp,sp,-64
    45a2:	fc06                	sd	ra,56(sp)
    45a4:	f822                	sd	s0,48(sp)
    45a6:	f426                	sd	s1,40(sp)
    45a8:	f04a                	sd	s2,32(sp)
    45aa:	ec4e                	sd	s3,24(sp)
    45ac:	e852                	sd	s4,16(sp)
    45ae:	0080                	addi	s0,sp,64
    45b0:	892a                	mv	s2,a0
  pid1 = fork();
    45b2:	00001097          	auipc	ra,0x1
    45b6:	642080e7          	jalr	1602(ra) # 5bf4 <fork>
  if(pid1 < 0) {
    45ba:	00054563          	bltz	a0,45c4 <preempt+0x24>
    45be:	84aa                	mv	s1,a0
  if(pid1 == 0)
    45c0:	e105                	bnez	a0,45e0 <preempt+0x40>
    for(;;)
    45c2:	a001                	j	45c2 <preempt+0x22>
    printf("%s: fork failed", s);
    45c4:	85ca                	mv	a1,s2
    45c6:	00002517          	auipc	a0,0x2
    45ca:	5fa50513          	addi	a0,a0,1530 # 6bc0 <malloc+0xb84>
    45ce:	00002097          	auipc	ra,0x2
    45d2:	9b6080e7          	jalr	-1610(ra) # 5f84 <printf>
    exit(1);
    45d6:	4505                	li	a0,1
    45d8:	00001097          	auipc	ra,0x1
    45dc:	624080e7          	jalr	1572(ra) # 5bfc <exit>
  pid2 = fork();
    45e0:	00001097          	auipc	ra,0x1
    45e4:	614080e7          	jalr	1556(ra) # 5bf4 <fork>
    45e8:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    45ea:	00054463          	bltz	a0,45f2 <preempt+0x52>
  if(pid2 == 0)
    45ee:	e105                	bnez	a0,460e <preempt+0x6e>
    for(;;)
    45f0:	a001                	j	45f0 <preempt+0x50>
    printf("%s: fork failed\n", s);
    45f2:	85ca                	mv	a1,s2
    45f4:	00002517          	auipc	a0,0x2
    45f8:	40c50513          	addi	a0,a0,1036 # 6a00 <malloc+0x9c4>
    45fc:	00002097          	auipc	ra,0x2
    4600:	988080e7          	jalr	-1656(ra) # 5f84 <printf>
    exit(1);
    4604:	4505                	li	a0,1
    4606:	00001097          	auipc	ra,0x1
    460a:	5f6080e7          	jalr	1526(ra) # 5bfc <exit>
  pipe(pfds);
    460e:	fc840513          	addi	a0,s0,-56
    4612:	00001097          	auipc	ra,0x1
    4616:	5fa080e7          	jalr	1530(ra) # 5c0c <pipe>
  pid3 = fork();
    461a:	00001097          	auipc	ra,0x1
    461e:	5da080e7          	jalr	1498(ra) # 5bf4 <fork>
    4622:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4624:	02054e63          	bltz	a0,4660 <preempt+0xc0>
  if(pid3 == 0){
    4628:	e525                	bnez	a0,4690 <preempt+0xf0>
    close(pfds[0]);
    462a:	fc842503          	lw	a0,-56(s0)
    462e:	00001097          	auipc	ra,0x1
    4632:	5f6080e7          	jalr	1526(ra) # 5c24 <close>
    if(write(pfds[1], "x", 1) != 1)
    4636:	4605                	li	a2,1
    4638:	00002597          	auipc	a1,0x2
    463c:	bb058593          	addi	a1,a1,-1104 # 61e8 <malloc+0x1ac>
    4640:	fcc42503          	lw	a0,-52(s0)
    4644:	00001097          	auipc	ra,0x1
    4648:	5d8080e7          	jalr	1496(ra) # 5c1c <write>
    464c:	4785                	li	a5,1
    464e:	02f51763          	bne	a0,a5,467c <preempt+0xdc>
    close(pfds[1]);
    4652:	fcc42503          	lw	a0,-52(s0)
    4656:	00001097          	auipc	ra,0x1
    465a:	5ce080e7          	jalr	1486(ra) # 5c24 <close>
    for(;;)
    465e:	a001                	j	465e <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4660:	85ca                	mv	a1,s2
    4662:	00002517          	auipc	a0,0x2
    4666:	39e50513          	addi	a0,a0,926 # 6a00 <malloc+0x9c4>
    466a:	00002097          	auipc	ra,0x2
    466e:	91a080e7          	jalr	-1766(ra) # 5f84 <printf>
     exit(1);
    4672:	4505                	li	a0,1
    4674:	00001097          	auipc	ra,0x1
    4678:	588080e7          	jalr	1416(ra) # 5bfc <exit>
      printf("%s: preempt write error", s);
    467c:	85ca                	mv	a1,s2
    467e:	00003517          	auipc	a0,0x3
    4682:	69250513          	addi	a0,a0,1682 # 7d10 <malloc+0x1cd4>
    4686:	00002097          	auipc	ra,0x2
    468a:	8fe080e7          	jalr	-1794(ra) # 5f84 <printf>
    468e:	b7d1                	j	4652 <preempt+0xb2>
  close(pfds[1]);
    4690:	fcc42503          	lw	a0,-52(s0)
    4694:	00001097          	auipc	ra,0x1
    4698:	590080e7          	jalr	1424(ra) # 5c24 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    469c:	660d                	lui	a2,0x3
    469e:	0000a597          	auipc	a1,0xa
    46a2:	94a58593          	addi	a1,a1,-1718 # dfe8 <buf>
    46a6:	fc842503          	lw	a0,-56(s0)
    46aa:	00001097          	auipc	ra,0x1
    46ae:	56a080e7          	jalr	1386(ra) # 5c14 <read>
    46b2:	4785                	li	a5,1
    46b4:	02f50363          	beq	a0,a5,46da <preempt+0x13a>
    printf("%s: preempt read error", s);
    46b8:	85ca                	mv	a1,s2
    46ba:	00003517          	auipc	a0,0x3
    46be:	66e50513          	addi	a0,a0,1646 # 7d28 <malloc+0x1cec>
    46c2:	00002097          	auipc	ra,0x2
    46c6:	8c2080e7          	jalr	-1854(ra) # 5f84 <printf>
}
    46ca:	70e2                	ld	ra,56(sp)
    46cc:	7442                	ld	s0,48(sp)
    46ce:	74a2                	ld	s1,40(sp)
    46d0:	7902                	ld	s2,32(sp)
    46d2:	69e2                	ld	s3,24(sp)
    46d4:	6a42                	ld	s4,16(sp)
    46d6:	6121                	addi	sp,sp,64
    46d8:	8082                	ret
  close(pfds[0]);
    46da:	fc842503          	lw	a0,-56(s0)
    46de:	00001097          	auipc	ra,0x1
    46e2:	546080e7          	jalr	1350(ra) # 5c24 <close>
  printf("kill... ");
    46e6:	00003517          	auipc	a0,0x3
    46ea:	65a50513          	addi	a0,a0,1626 # 7d40 <malloc+0x1d04>
    46ee:	00002097          	auipc	ra,0x2
    46f2:	896080e7          	jalr	-1898(ra) # 5f84 <printf>
  kill(pid1);
    46f6:	8526                	mv	a0,s1
    46f8:	00001097          	auipc	ra,0x1
    46fc:	534080e7          	jalr	1332(ra) # 5c2c <kill>
  kill(pid2);
    4700:	854e                	mv	a0,s3
    4702:	00001097          	auipc	ra,0x1
    4706:	52a080e7          	jalr	1322(ra) # 5c2c <kill>
  kill(pid3);
    470a:	8552                	mv	a0,s4
    470c:	00001097          	auipc	ra,0x1
    4710:	520080e7          	jalr	1312(ra) # 5c2c <kill>
  printf("wait... ");
    4714:	00003517          	auipc	a0,0x3
    4718:	63c50513          	addi	a0,a0,1596 # 7d50 <malloc+0x1d14>
    471c:	00002097          	auipc	ra,0x2
    4720:	868080e7          	jalr	-1944(ra) # 5f84 <printf>
  wait(0);
    4724:	4501                	li	a0,0
    4726:	00001097          	auipc	ra,0x1
    472a:	4de080e7          	jalr	1246(ra) # 5c04 <wait>
  wait(0);
    472e:	4501                	li	a0,0
    4730:	00001097          	auipc	ra,0x1
    4734:	4d4080e7          	jalr	1236(ra) # 5c04 <wait>
  wait(0);
    4738:	4501                	li	a0,0
    473a:	00001097          	auipc	ra,0x1
    473e:	4ca080e7          	jalr	1226(ra) # 5c04 <wait>
    4742:	b761                	j	46ca <preempt+0x12a>

0000000000004744 <reparent>:
{
    4744:	7179                	addi	sp,sp,-48
    4746:	f406                	sd	ra,40(sp)
    4748:	f022                	sd	s0,32(sp)
    474a:	ec26                	sd	s1,24(sp)
    474c:	e84a                	sd	s2,16(sp)
    474e:	e44e                	sd	s3,8(sp)
    4750:	e052                	sd	s4,0(sp)
    4752:	1800                	addi	s0,sp,48
    4754:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4756:	00001097          	auipc	ra,0x1
    475a:	526080e7          	jalr	1318(ra) # 5c7c <getpid>
    475e:	8a2a                	mv	s4,a0
    4760:	0c800913          	li	s2,200
    int pid = fork();
    4764:	00001097          	auipc	ra,0x1
    4768:	490080e7          	jalr	1168(ra) # 5bf4 <fork>
    476c:	84aa                	mv	s1,a0
    if(pid < 0){
    476e:	02054263          	bltz	a0,4792 <reparent+0x4e>
    if(pid){
    4772:	cd21                	beqz	a0,47ca <reparent+0x86>
      if(wait(0) != pid){
    4774:	4501                	li	a0,0
    4776:	00001097          	auipc	ra,0x1
    477a:	48e080e7          	jalr	1166(ra) # 5c04 <wait>
    477e:	02951863          	bne	a0,s1,47ae <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4782:	397d                	addiw	s2,s2,-1
    4784:	fe0910e3          	bnez	s2,4764 <reparent+0x20>
  exit(0);
    4788:	4501                	li	a0,0
    478a:	00001097          	auipc	ra,0x1
    478e:	472080e7          	jalr	1138(ra) # 5bfc <exit>
      printf("%s: fork failed\n", s);
    4792:	85ce                	mv	a1,s3
    4794:	00002517          	auipc	a0,0x2
    4798:	26c50513          	addi	a0,a0,620 # 6a00 <malloc+0x9c4>
    479c:	00001097          	auipc	ra,0x1
    47a0:	7e8080e7          	jalr	2024(ra) # 5f84 <printf>
      exit(1);
    47a4:	4505                	li	a0,1
    47a6:	00001097          	auipc	ra,0x1
    47aa:	456080e7          	jalr	1110(ra) # 5bfc <exit>
        printf("%s: wait wrong pid\n", s);
    47ae:	85ce                	mv	a1,s3
    47b0:	00002517          	auipc	a0,0x2
    47b4:	3d850513          	addi	a0,a0,984 # 6b88 <malloc+0xb4c>
    47b8:	00001097          	auipc	ra,0x1
    47bc:	7cc080e7          	jalr	1996(ra) # 5f84 <printf>
        exit(1);
    47c0:	4505                	li	a0,1
    47c2:	00001097          	auipc	ra,0x1
    47c6:	43a080e7          	jalr	1082(ra) # 5bfc <exit>
      int pid2 = fork();
    47ca:	00001097          	auipc	ra,0x1
    47ce:	42a080e7          	jalr	1066(ra) # 5bf4 <fork>
      if(pid2 < 0){
    47d2:	00054763          	bltz	a0,47e0 <reparent+0x9c>
      exit(0);
    47d6:	4501                	li	a0,0
    47d8:	00001097          	auipc	ra,0x1
    47dc:	424080e7          	jalr	1060(ra) # 5bfc <exit>
        kill(master_pid);
    47e0:	8552                	mv	a0,s4
    47e2:	00001097          	auipc	ra,0x1
    47e6:	44a080e7          	jalr	1098(ra) # 5c2c <kill>
        exit(1);
    47ea:	4505                	li	a0,1
    47ec:	00001097          	auipc	ra,0x1
    47f0:	410080e7          	jalr	1040(ra) # 5bfc <exit>

00000000000047f4 <sbrkfail>:
{
    47f4:	7119                	addi	sp,sp,-128
    47f6:	fc86                	sd	ra,120(sp)
    47f8:	f8a2                	sd	s0,112(sp)
    47fa:	f4a6                	sd	s1,104(sp)
    47fc:	f0ca                	sd	s2,96(sp)
    47fe:	ecce                	sd	s3,88(sp)
    4800:	e8d2                	sd	s4,80(sp)
    4802:	e4d6                	sd	s5,72(sp)
    4804:	0100                	addi	s0,sp,128
    4806:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4808:	fb040513          	addi	a0,s0,-80
    480c:	00001097          	auipc	ra,0x1
    4810:	400080e7          	jalr	1024(ra) # 5c0c <pipe>
    4814:	e901                	bnez	a0,4824 <sbrkfail+0x30>
    4816:	f8040493          	addi	s1,s0,-128
    481a:	fa840993          	addi	s3,s0,-88
    481e:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4820:	5a7d                	li	s4,-1
    4822:	a085                	j	4882 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4824:	85d6                	mv	a1,s5
    4826:	00002517          	auipc	a0,0x2
    482a:	2e250513          	addi	a0,a0,738 # 6b08 <malloc+0xacc>
    482e:	00001097          	auipc	ra,0x1
    4832:	756080e7          	jalr	1878(ra) # 5f84 <printf>
    exit(1);
    4836:	4505                	li	a0,1
    4838:	00001097          	auipc	ra,0x1
    483c:	3c4080e7          	jalr	964(ra) # 5bfc <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4840:	00001097          	auipc	ra,0x1
    4844:	444080e7          	jalr	1092(ra) # 5c84 <sbrk>
    4848:	064007b7          	lui	a5,0x6400
    484c:	40a7853b          	subw	a0,a5,a0
    4850:	00001097          	auipc	ra,0x1
    4854:	434080e7          	jalr	1076(ra) # 5c84 <sbrk>
      write(fds[1], "x", 1);
    4858:	4605                	li	a2,1
    485a:	00002597          	auipc	a1,0x2
    485e:	98e58593          	addi	a1,a1,-1650 # 61e8 <malloc+0x1ac>
    4862:	fb442503          	lw	a0,-76(s0)
    4866:	00001097          	auipc	ra,0x1
    486a:	3b6080e7          	jalr	950(ra) # 5c1c <write>
      for(;;) sleep(1000);
    486e:	3e800513          	li	a0,1000
    4872:	00001097          	auipc	ra,0x1
    4876:	41a080e7          	jalr	1050(ra) # 5c8c <sleep>
    487a:	bfd5                	j	486e <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    487c:	0911                	addi	s2,s2,4
    487e:	03390563          	beq	s2,s3,48a8 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4882:	00001097          	auipc	ra,0x1
    4886:	372080e7          	jalr	882(ra) # 5bf4 <fork>
    488a:	00a92023          	sw	a0,0(s2)
    488e:	d94d                	beqz	a0,4840 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4890:	ff4506e3          	beq	a0,s4,487c <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4894:	4605                	li	a2,1
    4896:	faf40593          	addi	a1,s0,-81
    489a:	fb042503          	lw	a0,-80(s0)
    489e:	00001097          	auipc	ra,0x1
    48a2:	376080e7          	jalr	886(ra) # 5c14 <read>
    48a6:	bfd9                	j	487c <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    48a8:	6505                	lui	a0,0x1
    48aa:	00001097          	auipc	ra,0x1
    48ae:	3da080e7          	jalr	986(ra) # 5c84 <sbrk>
    48b2:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    48b4:	597d                	li	s2,-1
    48b6:	a021                	j	48be <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48b8:	0491                	addi	s1,s1,4
    48ba:	01348f63          	beq	s1,s3,48d8 <sbrkfail+0xe4>
    if(pids[i] == -1)
    48be:	4088                	lw	a0,0(s1)
    48c0:	ff250ce3          	beq	a0,s2,48b8 <sbrkfail+0xc4>
    kill(pids[i]);
    48c4:	00001097          	auipc	ra,0x1
    48c8:	368080e7          	jalr	872(ra) # 5c2c <kill>
    wait(0);
    48cc:	4501                	li	a0,0
    48ce:	00001097          	auipc	ra,0x1
    48d2:	336080e7          	jalr	822(ra) # 5c04 <wait>
    48d6:	b7cd                	j	48b8 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    48d8:	57fd                	li	a5,-1
    48da:	04fa0163          	beq	s4,a5,491c <sbrkfail+0x128>
  pid = fork();
    48de:	00001097          	auipc	ra,0x1
    48e2:	316080e7          	jalr	790(ra) # 5bf4 <fork>
    48e6:	84aa                	mv	s1,a0
  if(pid < 0){
    48e8:	04054863          	bltz	a0,4938 <sbrkfail+0x144>
  if(pid == 0){
    48ec:	c525                	beqz	a0,4954 <sbrkfail+0x160>
  wait(&xstatus);
    48ee:	fbc40513          	addi	a0,s0,-68
    48f2:	00001097          	auipc	ra,0x1
    48f6:	312080e7          	jalr	786(ra) # 5c04 <wait>
  if(xstatus != -1 && xstatus != 2)
    48fa:	fbc42783          	lw	a5,-68(s0)
    48fe:	577d                	li	a4,-1
    4900:	00e78563          	beq	a5,a4,490a <sbrkfail+0x116>
    4904:	4709                	li	a4,2
    4906:	08e79d63          	bne	a5,a4,49a0 <sbrkfail+0x1ac>
}
    490a:	70e6                	ld	ra,120(sp)
    490c:	7446                	ld	s0,112(sp)
    490e:	74a6                	ld	s1,104(sp)
    4910:	7906                	ld	s2,96(sp)
    4912:	69e6                	ld	s3,88(sp)
    4914:	6a46                	ld	s4,80(sp)
    4916:	6aa6                	ld	s5,72(sp)
    4918:	6109                	addi	sp,sp,128
    491a:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    491c:	85d6                	mv	a1,s5
    491e:	00003517          	auipc	a0,0x3
    4922:	44250513          	addi	a0,a0,1090 # 7d60 <malloc+0x1d24>
    4926:	00001097          	auipc	ra,0x1
    492a:	65e080e7          	jalr	1630(ra) # 5f84 <printf>
    exit(1);
    492e:	4505                	li	a0,1
    4930:	00001097          	auipc	ra,0x1
    4934:	2cc080e7          	jalr	716(ra) # 5bfc <exit>
    printf("%s: fork failed\n", s);
    4938:	85d6                	mv	a1,s5
    493a:	00002517          	auipc	a0,0x2
    493e:	0c650513          	addi	a0,a0,198 # 6a00 <malloc+0x9c4>
    4942:	00001097          	auipc	ra,0x1
    4946:	642080e7          	jalr	1602(ra) # 5f84 <printf>
    exit(1);
    494a:	4505                	li	a0,1
    494c:	00001097          	auipc	ra,0x1
    4950:	2b0080e7          	jalr	688(ra) # 5bfc <exit>
    a = sbrk(0);
    4954:	4501                	li	a0,0
    4956:	00001097          	auipc	ra,0x1
    495a:	32e080e7          	jalr	814(ra) # 5c84 <sbrk>
    495e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4960:	3e800537          	lui	a0,0x3e800
    4964:	00001097          	auipc	ra,0x1
    4968:	320080e7          	jalr	800(ra) # 5c84 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    496c:	87ca                	mv	a5,s2
    496e:	3e800737          	lui	a4,0x3e800
    4972:	993a                	add	s2,s2,a4
    4974:	6705                	lui	a4,0x1
      n += *(a+i);
    4976:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63ef018>
    497a:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    497c:	97ba                	add	a5,a5,a4
    497e:	fef91ce3          	bne	s2,a5,4976 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4982:	8626                	mv	a2,s1
    4984:	85d6                	mv	a1,s5
    4986:	00003517          	auipc	a0,0x3
    498a:	3fa50513          	addi	a0,a0,1018 # 7d80 <malloc+0x1d44>
    498e:	00001097          	auipc	ra,0x1
    4992:	5f6080e7          	jalr	1526(ra) # 5f84 <printf>
    exit(1);
    4996:	4505                	li	a0,1
    4998:	00001097          	auipc	ra,0x1
    499c:	264080e7          	jalr	612(ra) # 5bfc <exit>
    exit(1);
    49a0:	4505                	li	a0,1
    49a2:	00001097          	auipc	ra,0x1
    49a6:	25a080e7          	jalr	602(ra) # 5bfc <exit>

00000000000049aa <mem>:
{
    49aa:	7139                	addi	sp,sp,-64
    49ac:	fc06                	sd	ra,56(sp)
    49ae:	f822                	sd	s0,48(sp)
    49b0:	f426                	sd	s1,40(sp)
    49b2:	f04a                	sd	s2,32(sp)
    49b4:	ec4e                	sd	s3,24(sp)
    49b6:	0080                	addi	s0,sp,64
    49b8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49ba:	00001097          	auipc	ra,0x1
    49be:	23a080e7          	jalr	570(ra) # 5bf4 <fork>
    m1 = 0;
    49c2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49c4:	6909                	lui	s2,0x2
    49c6:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x13f>
  if((pid = fork()) == 0){
    49ca:	c115                	beqz	a0,49ee <mem+0x44>
    wait(&xstatus);
    49cc:	fcc40513          	addi	a0,s0,-52
    49d0:	00001097          	auipc	ra,0x1
    49d4:	234080e7          	jalr	564(ra) # 5c04 <wait>
    if(xstatus == -1){
    49d8:	fcc42503          	lw	a0,-52(s0)
    49dc:	57fd                	li	a5,-1
    49de:	06f50363          	beq	a0,a5,4a44 <mem+0x9a>
    exit(xstatus);
    49e2:	00001097          	auipc	ra,0x1
    49e6:	21a080e7          	jalr	538(ra) # 5bfc <exit>
      *(char**)m2 = m1;
    49ea:	e104                	sd	s1,0(a0)
      m1 = m2;
    49ec:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    49ee:	854a                	mv	a0,s2
    49f0:	00001097          	auipc	ra,0x1
    49f4:	64c080e7          	jalr	1612(ra) # 603c <malloc>
    49f8:	f96d                	bnez	a0,49ea <mem+0x40>
    while(m1){
    49fa:	c881                	beqz	s1,4a0a <mem+0x60>
      m2 = *(char**)m1;
    49fc:	8526                	mv	a0,s1
    49fe:	6084                	ld	s1,0(s1)
      free(m1);
    4a00:	00001097          	auipc	ra,0x1
    4a04:	5ba080e7          	jalr	1466(ra) # 5fba <free>
    while(m1){
    4a08:	f8f5                	bnez	s1,49fc <mem+0x52>
    m1 = malloc(1024*20);
    4a0a:	6515                	lui	a0,0x5
    4a0c:	00001097          	auipc	ra,0x1
    4a10:	630080e7          	jalr	1584(ra) # 603c <malloc>
    if(m1 == 0){
    4a14:	c911                	beqz	a0,4a28 <mem+0x7e>
    free(m1);
    4a16:	00001097          	auipc	ra,0x1
    4a1a:	5a4080e7          	jalr	1444(ra) # 5fba <free>
    exit(0);
    4a1e:	4501                	li	a0,0
    4a20:	00001097          	auipc	ra,0x1
    4a24:	1dc080e7          	jalr	476(ra) # 5bfc <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a28:	85ce                	mv	a1,s3
    4a2a:	00003517          	auipc	a0,0x3
    4a2e:	38650513          	addi	a0,a0,902 # 7db0 <malloc+0x1d74>
    4a32:	00001097          	auipc	ra,0x1
    4a36:	552080e7          	jalr	1362(ra) # 5f84 <printf>
      exit(1);
    4a3a:	4505                	li	a0,1
    4a3c:	00001097          	auipc	ra,0x1
    4a40:	1c0080e7          	jalr	448(ra) # 5bfc <exit>
      exit(0);
    4a44:	4501                	li	a0,0
    4a46:	00001097          	auipc	ra,0x1
    4a4a:	1b6080e7          	jalr	438(ra) # 5bfc <exit>

0000000000004a4e <sharedfd>:
{
    4a4e:	7159                	addi	sp,sp,-112
    4a50:	f486                	sd	ra,104(sp)
    4a52:	f0a2                	sd	s0,96(sp)
    4a54:	e0d2                	sd	s4,64(sp)
    4a56:	1880                	addi	s0,sp,112
    4a58:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a5a:	00003517          	auipc	a0,0x3
    4a5e:	37650513          	addi	a0,a0,886 # 7dd0 <malloc+0x1d94>
    4a62:	00001097          	auipc	ra,0x1
    4a66:	1ea080e7          	jalr	490(ra) # 5c4c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a6a:	20200593          	li	a1,514
    4a6e:	00003517          	auipc	a0,0x3
    4a72:	36250513          	addi	a0,a0,866 # 7dd0 <malloc+0x1d94>
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	1c6080e7          	jalr	454(ra) # 5c3c <open>
  if(fd < 0){
    4a7e:	06054063          	bltz	a0,4ade <sharedfd+0x90>
    4a82:	eca6                	sd	s1,88(sp)
    4a84:	e8ca                	sd	s2,80(sp)
    4a86:	e4ce                	sd	s3,72(sp)
    4a88:	fc56                	sd	s5,56(sp)
    4a8a:	f85a                	sd	s6,48(sp)
    4a8c:	f45e                	sd	s7,40(sp)
    4a8e:	892a                	mv	s2,a0
  pid = fork();
    4a90:	00001097          	auipc	ra,0x1
    4a94:	164080e7          	jalr	356(ra) # 5bf4 <fork>
    4a98:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4a9a:	07000593          	li	a1,112
    4a9e:	e119                	bnez	a0,4aa4 <sharedfd+0x56>
    4aa0:	06300593          	li	a1,99
    4aa4:	4629                	li	a2,10
    4aa6:	fa040513          	addi	a0,s0,-96
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	f58080e7          	jalr	-168(ra) # 5a02 <memset>
    4ab2:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ab6:	4629                	li	a2,10
    4ab8:	fa040593          	addi	a1,s0,-96
    4abc:	854a                	mv	a0,s2
    4abe:	00001097          	auipc	ra,0x1
    4ac2:	15e080e7          	jalr	350(ra) # 5c1c <write>
    4ac6:	47a9                	li	a5,10
    4ac8:	02f51f63          	bne	a0,a5,4b06 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4acc:	34fd                	addiw	s1,s1,-1
    4ace:	f4e5                	bnez	s1,4ab6 <sharedfd+0x68>
  if(pid == 0) {
    4ad0:	04099963          	bnez	s3,4b22 <sharedfd+0xd4>
    exit(0);
    4ad4:	4501                	li	a0,0
    4ad6:	00001097          	auipc	ra,0x1
    4ada:	126080e7          	jalr	294(ra) # 5bfc <exit>
    4ade:	eca6                	sd	s1,88(sp)
    4ae0:	e8ca                	sd	s2,80(sp)
    4ae2:	e4ce                	sd	s3,72(sp)
    4ae4:	fc56                	sd	s5,56(sp)
    4ae6:	f85a                	sd	s6,48(sp)
    4ae8:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4aea:	85d2                	mv	a1,s4
    4aec:	00003517          	auipc	a0,0x3
    4af0:	2f450513          	addi	a0,a0,756 # 7de0 <malloc+0x1da4>
    4af4:	00001097          	auipc	ra,0x1
    4af8:	490080e7          	jalr	1168(ra) # 5f84 <printf>
    exit(1);
    4afc:	4505                	li	a0,1
    4afe:	00001097          	auipc	ra,0x1
    4b02:	0fe080e7          	jalr	254(ra) # 5bfc <exit>
      printf("%s: write sharedfd failed\n", s);
    4b06:	85d2                	mv	a1,s4
    4b08:	00003517          	auipc	a0,0x3
    4b0c:	30050513          	addi	a0,a0,768 # 7e08 <malloc+0x1dcc>
    4b10:	00001097          	auipc	ra,0x1
    4b14:	474080e7          	jalr	1140(ra) # 5f84 <printf>
      exit(1);
    4b18:	4505                	li	a0,1
    4b1a:	00001097          	auipc	ra,0x1
    4b1e:	0e2080e7          	jalr	226(ra) # 5bfc <exit>
    wait(&xstatus);
    4b22:	f9c40513          	addi	a0,s0,-100
    4b26:	00001097          	auipc	ra,0x1
    4b2a:	0de080e7          	jalr	222(ra) # 5c04 <wait>
    if(xstatus != 0)
    4b2e:	f9c42983          	lw	s3,-100(s0)
    4b32:	00098763          	beqz	s3,4b40 <sharedfd+0xf2>
      exit(xstatus);
    4b36:	854e                	mv	a0,s3
    4b38:	00001097          	auipc	ra,0x1
    4b3c:	0c4080e7          	jalr	196(ra) # 5bfc <exit>
  close(fd);
    4b40:	854a                	mv	a0,s2
    4b42:	00001097          	auipc	ra,0x1
    4b46:	0e2080e7          	jalr	226(ra) # 5c24 <close>
  fd = open("sharedfd", 0);
    4b4a:	4581                	li	a1,0
    4b4c:	00003517          	auipc	a0,0x3
    4b50:	28450513          	addi	a0,a0,644 # 7dd0 <malloc+0x1d94>
    4b54:	00001097          	auipc	ra,0x1
    4b58:	0e8080e7          	jalr	232(ra) # 5c3c <open>
    4b5c:	8baa                	mv	s7,a0
  nc = np = 0;
    4b5e:	8ace                	mv	s5,s3
  if(fd < 0){
    4b60:	02054563          	bltz	a0,4b8a <sharedfd+0x13c>
    4b64:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b68:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b6c:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b70:	4629                	li	a2,10
    4b72:	fa040593          	addi	a1,s0,-96
    4b76:	855e                	mv	a0,s7
    4b78:	00001097          	auipc	ra,0x1
    4b7c:	09c080e7          	jalr	156(ra) # 5c14 <read>
    4b80:	02a05f63          	blez	a0,4bbe <sharedfd+0x170>
    4b84:	fa040793          	addi	a5,s0,-96
    4b88:	a01d                	j	4bae <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b8a:	85d2                	mv	a1,s4
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	29c50513          	addi	a0,a0,668 # 7e28 <malloc+0x1dec>
    4b94:	00001097          	auipc	ra,0x1
    4b98:	3f0080e7          	jalr	1008(ra) # 5f84 <printf>
    exit(1);
    4b9c:	4505                	li	a0,1
    4b9e:	00001097          	auipc	ra,0x1
    4ba2:	05e080e7          	jalr	94(ra) # 5bfc <exit>
        nc++;
    4ba6:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4ba8:	0785                	addi	a5,a5,1
    4baa:	fd2783e3          	beq	a5,s2,4b70 <sharedfd+0x122>
      if(buf[i] == 'c')
    4bae:	0007c703          	lbu	a4,0(a5)
    4bb2:	fe970ae3          	beq	a4,s1,4ba6 <sharedfd+0x158>
      if(buf[i] == 'p')
    4bb6:	ff6719e3          	bne	a4,s6,4ba8 <sharedfd+0x15a>
        np++;
    4bba:	2a85                	addiw	s5,s5,1
    4bbc:	b7f5                	j	4ba8 <sharedfd+0x15a>
  close(fd);
    4bbe:	855e                	mv	a0,s7
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	064080e7          	jalr	100(ra) # 5c24 <close>
  unlink("sharedfd");
    4bc8:	00003517          	auipc	a0,0x3
    4bcc:	20850513          	addi	a0,a0,520 # 7dd0 <malloc+0x1d94>
    4bd0:	00001097          	auipc	ra,0x1
    4bd4:	07c080e7          	jalr	124(ra) # 5c4c <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bd8:	6789                	lui	a5,0x2
    4bda:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x13e>
    4bde:	00f99763          	bne	s3,a5,4bec <sharedfd+0x19e>
    4be2:	6789                	lui	a5,0x2
    4be4:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x13e>
    4be8:	02fa8063          	beq	s5,a5,4c08 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4bec:	85d2                	mv	a1,s4
    4bee:	00003517          	auipc	a0,0x3
    4bf2:	26250513          	addi	a0,a0,610 # 7e50 <malloc+0x1e14>
    4bf6:	00001097          	auipc	ra,0x1
    4bfa:	38e080e7          	jalr	910(ra) # 5f84 <printf>
    exit(1);
    4bfe:	4505                	li	a0,1
    4c00:	00001097          	auipc	ra,0x1
    4c04:	ffc080e7          	jalr	-4(ra) # 5bfc <exit>
    exit(0);
    4c08:	4501                	li	a0,0
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	ff2080e7          	jalr	-14(ra) # 5bfc <exit>

0000000000004c12 <fourfiles>:
{
    4c12:	7135                	addi	sp,sp,-160
    4c14:	ed06                	sd	ra,152(sp)
    4c16:	e922                	sd	s0,144(sp)
    4c18:	e526                	sd	s1,136(sp)
    4c1a:	e14a                	sd	s2,128(sp)
    4c1c:	fcce                	sd	s3,120(sp)
    4c1e:	f8d2                	sd	s4,112(sp)
    4c20:	f4d6                	sd	s5,104(sp)
    4c22:	f0da                	sd	s6,96(sp)
    4c24:	ecde                	sd	s7,88(sp)
    4c26:	e8e2                	sd	s8,80(sp)
    4c28:	e4e6                	sd	s9,72(sp)
    4c2a:	e0ea                	sd	s10,64(sp)
    4c2c:	fc6e                	sd	s11,56(sp)
    4c2e:	1100                	addi	s0,sp,160
    4c30:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c32:	00003797          	auipc	a5,0x3
    4c36:	23678793          	addi	a5,a5,566 # 7e68 <malloc+0x1e2c>
    4c3a:	f6f43823          	sd	a5,-144(s0)
    4c3e:	00003797          	auipc	a5,0x3
    4c42:	23278793          	addi	a5,a5,562 # 7e70 <malloc+0x1e34>
    4c46:	f6f43c23          	sd	a5,-136(s0)
    4c4a:	00003797          	auipc	a5,0x3
    4c4e:	22e78793          	addi	a5,a5,558 # 7e78 <malloc+0x1e3c>
    4c52:	f8f43023          	sd	a5,-128(s0)
    4c56:	00003797          	auipc	a5,0x3
    4c5a:	22a78793          	addi	a5,a5,554 # 7e80 <malloc+0x1e44>
    4c5e:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c62:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c66:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c68:	4481                	li	s1,0
    4c6a:	4a11                	li	s4,4
    fname = names[pi];
    4c6c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c70:	854e                	mv	a0,s3
    4c72:	00001097          	auipc	ra,0x1
    4c76:	fda080e7          	jalr	-38(ra) # 5c4c <unlink>
    pid = fork();
    4c7a:	00001097          	auipc	ra,0x1
    4c7e:	f7a080e7          	jalr	-134(ra) # 5bf4 <fork>
    if(pid < 0){
    4c82:	04054063          	bltz	a0,4cc2 <fourfiles+0xb0>
    if(pid == 0){
    4c86:	cd21                	beqz	a0,4cde <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4c88:	2485                	addiw	s1,s1,1
    4c8a:	0921                	addi	s2,s2,8
    4c8c:	ff4490e3          	bne	s1,s4,4c6c <fourfiles+0x5a>
    4c90:	4491                	li	s1,4
    wait(&xstatus);
    4c92:	f6c40513          	addi	a0,s0,-148
    4c96:	00001097          	auipc	ra,0x1
    4c9a:	f6e080e7          	jalr	-146(ra) # 5c04 <wait>
    if(xstatus != 0)
    4c9e:	f6c42a83          	lw	s5,-148(s0)
    4ca2:	0c0a9863          	bnez	s5,4d72 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4ca6:	34fd                	addiw	s1,s1,-1
    4ca8:	f4ed                	bnez	s1,4c92 <fourfiles+0x80>
    4caa:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cae:	00009a17          	auipc	s4,0x9
    4cb2:	33aa0a13          	addi	s4,s4,826 # dfe8 <buf>
    if(total != N*SZ){
    4cb6:	6d05                	lui	s10,0x1
    4cb8:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x20>
  for(i = 0; i < NCHILD; i++){
    4cbc:	03400d93          	li	s11,52
    4cc0:	a22d                	j	4dea <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4cc2:	85e6                	mv	a1,s9
    4cc4:	00002517          	auipc	a0,0x2
    4cc8:	14450513          	addi	a0,a0,324 # 6e08 <malloc+0xdcc>
    4ccc:	00001097          	auipc	ra,0x1
    4cd0:	2b8080e7          	jalr	696(ra) # 5f84 <printf>
      exit(1);
    4cd4:	4505                	li	a0,1
    4cd6:	00001097          	auipc	ra,0x1
    4cda:	f26080e7          	jalr	-218(ra) # 5bfc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cde:	20200593          	li	a1,514
    4ce2:	854e                	mv	a0,s3
    4ce4:	00001097          	auipc	ra,0x1
    4ce8:	f58080e7          	jalr	-168(ra) # 5c3c <open>
    4cec:	892a                	mv	s2,a0
      if(fd < 0){
    4cee:	04054763          	bltz	a0,4d3c <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4cf2:	1f400613          	li	a2,500
    4cf6:	0304859b          	addiw	a1,s1,48
    4cfa:	00009517          	auipc	a0,0x9
    4cfe:	2ee50513          	addi	a0,a0,750 # dfe8 <buf>
    4d02:	00001097          	auipc	ra,0x1
    4d06:	d00080e7          	jalr	-768(ra) # 5a02 <memset>
    4d0a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d0c:	00009997          	auipc	s3,0x9
    4d10:	2dc98993          	addi	s3,s3,732 # dfe8 <buf>
    4d14:	1f400613          	li	a2,500
    4d18:	85ce                	mv	a1,s3
    4d1a:	854a                	mv	a0,s2
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	f00080e7          	jalr	-256(ra) # 5c1c <write>
    4d24:	85aa                	mv	a1,a0
    4d26:	1f400793          	li	a5,500
    4d2a:	02f51763          	bne	a0,a5,4d58 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d2e:	34fd                	addiw	s1,s1,-1
    4d30:	f0f5                	bnez	s1,4d14 <fourfiles+0x102>
      exit(0);
    4d32:	4501                	li	a0,0
    4d34:	00001097          	auipc	ra,0x1
    4d38:	ec8080e7          	jalr	-312(ra) # 5bfc <exit>
        printf("create failed\n", s);
    4d3c:	85e6                	mv	a1,s9
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	14a50513          	addi	a0,a0,330 # 7e88 <malloc+0x1e4c>
    4d46:	00001097          	auipc	ra,0x1
    4d4a:	23e080e7          	jalr	574(ra) # 5f84 <printf>
        exit(1);
    4d4e:	4505                	li	a0,1
    4d50:	00001097          	auipc	ra,0x1
    4d54:	eac080e7          	jalr	-340(ra) # 5bfc <exit>
          printf("write failed %d\n", n);
    4d58:	00003517          	auipc	a0,0x3
    4d5c:	14050513          	addi	a0,a0,320 # 7e98 <malloc+0x1e5c>
    4d60:	00001097          	auipc	ra,0x1
    4d64:	224080e7          	jalr	548(ra) # 5f84 <printf>
          exit(1);
    4d68:	4505                	li	a0,1
    4d6a:	00001097          	auipc	ra,0x1
    4d6e:	e92080e7          	jalr	-366(ra) # 5bfc <exit>
      exit(xstatus);
    4d72:	8556                	mv	a0,s5
    4d74:	00001097          	auipc	ra,0x1
    4d78:	e88080e7          	jalr	-376(ra) # 5bfc <exit>
          printf("wrong char\n", s);
    4d7c:	85e6                	mv	a1,s9
    4d7e:	00003517          	auipc	a0,0x3
    4d82:	13250513          	addi	a0,a0,306 # 7eb0 <malloc+0x1e74>
    4d86:	00001097          	auipc	ra,0x1
    4d8a:	1fe080e7          	jalr	510(ra) # 5f84 <printf>
          exit(1);
    4d8e:	4505                	li	a0,1
    4d90:	00001097          	auipc	ra,0x1
    4d94:	e6c080e7          	jalr	-404(ra) # 5bfc <exit>
      total += n;
    4d98:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d9c:	660d                	lui	a2,0x3
    4d9e:	85d2                	mv	a1,s4
    4da0:	854e                	mv	a0,s3
    4da2:	00001097          	auipc	ra,0x1
    4da6:	e72080e7          	jalr	-398(ra) # 5c14 <read>
    4daa:	02a05063          	blez	a0,4dca <fourfiles+0x1b8>
    4dae:	00009797          	auipc	a5,0x9
    4db2:	23a78793          	addi	a5,a5,570 # dfe8 <buf>
    4db6:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4dba:	0007c703          	lbu	a4,0(a5)
    4dbe:	fa971fe3          	bne	a4,s1,4d7c <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4dc2:	0785                	addi	a5,a5,1
    4dc4:	fed79be3          	bne	a5,a3,4dba <fourfiles+0x1a8>
    4dc8:	bfc1                	j	4d98 <fourfiles+0x186>
    close(fd);
    4dca:	854e                	mv	a0,s3
    4dcc:	00001097          	auipc	ra,0x1
    4dd0:	e58080e7          	jalr	-424(ra) # 5c24 <close>
    if(total != N*SZ){
    4dd4:	03a91863          	bne	s2,s10,4e04 <fourfiles+0x1f2>
    unlink(fname);
    4dd8:	8562                	mv	a0,s8
    4dda:	00001097          	auipc	ra,0x1
    4dde:	e72080e7          	jalr	-398(ra) # 5c4c <unlink>
  for(i = 0; i < NCHILD; i++){
    4de2:	0ba1                	addi	s7,s7,8
    4de4:	2b05                	addiw	s6,s6,1
    4de6:	03bb0d63          	beq	s6,s11,4e20 <fourfiles+0x20e>
    fname = names[i];
    4dea:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4dee:	4581                	li	a1,0
    4df0:	8562                	mv	a0,s8
    4df2:	00001097          	auipc	ra,0x1
    4df6:	e4a080e7          	jalr	-438(ra) # 5c3c <open>
    4dfa:	89aa                	mv	s3,a0
    total = 0;
    4dfc:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4dfe:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e02:	bf69                	j	4d9c <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e04:	85ca                	mv	a1,s2
    4e06:	00003517          	auipc	a0,0x3
    4e0a:	0ba50513          	addi	a0,a0,186 # 7ec0 <malloc+0x1e84>
    4e0e:	00001097          	auipc	ra,0x1
    4e12:	176080e7          	jalr	374(ra) # 5f84 <printf>
      exit(1);
    4e16:	4505                	li	a0,1
    4e18:	00001097          	auipc	ra,0x1
    4e1c:	de4080e7          	jalr	-540(ra) # 5bfc <exit>
}
    4e20:	60ea                	ld	ra,152(sp)
    4e22:	644a                	ld	s0,144(sp)
    4e24:	64aa                	ld	s1,136(sp)
    4e26:	690a                	ld	s2,128(sp)
    4e28:	79e6                	ld	s3,120(sp)
    4e2a:	7a46                	ld	s4,112(sp)
    4e2c:	7aa6                	ld	s5,104(sp)
    4e2e:	7b06                	ld	s6,96(sp)
    4e30:	6be6                	ld	s7,88(sp)
    4e32:	6c46                	ld	s8,80(sp)
    4e34:	6ca6                	ld	s9,72(sp)
    4e36:	6d06                	ld	s10,64(sp)
    4e38:	7de2                	ld	s11,56(sp)
    4e3a:	610d                	addi	sp,sp,160
    4e3c:	8082                	ret

0000000000004e3e <concreate>:
{
    4e3e:	7135                	addi	sp,sp,-160
    4e40:	ed06                	sd	ra,152(sp)
    4e42:	e922                	sd	s0,144(sp)
    4e44:	e526                	sd	s1,136(sp)
    4e46:	e14a                	sd	s2,128(sp)
    4e48:	fcce                	sd	s3,120(sp)
    4e4a:	f8d2                	sd	s4,112(sp)
    4e4c:	f4d6                	sd	s5,104(sp)
    4e4e:	f0da                	sd	s6,96(sp)
    4e50:	ecde                	sd	s7,88(sp)
    4e52:	1100                	addi	s0,sp,160
    4e54:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e56:	04300793          	li	a5,67
    4e5a:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e5e:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e62:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e64:	4b0d                	li	s6,3
    4e66:	4a85                	li	s5,1
      link("C0", file);
    4e68:	00003b97          	auipc	s7,0x3
    4e6c:	070b8b93          	addi	s7,s7,112 # 7ed8 <malloc+0x1e9c>
  for(i = 0; i < N; i++){
    4e70:	02800a13          	li	s4,40
    4e74:	acc9                	j	5146 <concreate+0x308>
      link("C0", file);
    4e76:	fa840593          	addi	a1,s0,-88
    4e7a:	855e                	mv	a0,s7
    4e7c:	00001097          	auipc	ra,0x1
    4e80:	de0080e7          	jalr	-544(ra) # 5c5c <link>
    if(pid == 0) {
    4e84:	a465                	j	512c <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4e86:	4795                	li	a5,5
    4e88:	02f9693b          	remw	s2,s2,a5
    4e8c:	4785                	li	a5,1
    4e8e:	02f90b63          	beq	s2,a5,4ec4 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4e92:	20200593          	li	a1,514
    4e96:	fa840513          	addi	a0,s0,-88
    4e9a:	00001097          	auipc	ra,0x1
    4e9e:	da2080e7          	jalr	-606(ra) # 5c3c <open>
      if(fd < 0){
    4ea2:	26055c63          	bgez	a0,511a <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4ea6:	fa840593          	addi	a1,s0,-88
    4eaa:	00003517          	auipc	a0,0x3
    4eae:	03650513          	addi	a0,a0,54 # 7ee0 <malloc+0x1ea4>
    4eb2:	00001097          	auipc	ra,0x1
    4eb6:	0d2080e7          	jalr	210(ra) # 5f84 <printf>
        exit(1);
    4eba:	4505                	li	a0,1
    4ebc:	00001097          	auipc	ra,0x1
    4ec0:	d40080e7          	jalr	-704(ra) # 5bfc <exit>
      link("C0", file);
    4ec4:	fa840593          	addi	a1,s0,-88
    4ec8:	00003517          	auipc	a0,0x3
    4ecc:	01050513          	addi	a0,a0,16 # 7ed8 <malloc+0x1e9c>
    4ed0:	00001097          	auipc	ra,0x1
    4ed4:	d8c080e7          	jalr	-628(ra) # 5c5c <link>
      exit(0);
    4ed8:	4501                	li	a0,0
    4eda:	00001097          	auipc	ra,0x1
    4ede:	d22080e7          	jalr	-734(ra) # 5bfc <exit>
        exit(1);
    4ee2:	4505                	li	a0,1
    4ee4:	00001097          	auipc	ra,0x1
    4ee8:	d18080e7          	jalr	-744(ra) # 5bfc <exit>
  memset(fa, 0, sizeof(fa));
    4eec:	02800613          	li	a2,40
    4ef0:	4581                	li	a1,0
    4ef2:	f8040513          	addi	a0,s0,-128
    4ef6:	00001097          	auipc	ra,0x1
    4efa:	b0c080e7          	jalr	-1268(ra) # 5a02 <memset>
  fd = open(".", 0);
    4efe:	4581                	li	a1,0
    4f00:	00002517          	auipc	a0,0x2
    4f04:	96050513          	addi	a0,a0,-1696 # 6860 <malloc+0x824>
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	d34080e7          	jalr	-716(ra) # 5c3c <open>
    4f10:	892a                	mv	s2,a0
  n = 0;
    4f12:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f14:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f18:	02700b13          	li	s6,39
      fa[i] = 1;
    4f1c:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f1e:	4641                	li	a2,16
    4f20:	f7040593          	addi	a1,s0,-144
    4f24:	854a                	mv	a0,s2
    4f26:	00001097          	auipc	ra,0x1
    4f2a:	cee080e7          	jalr	-786(ra) # 5c14 <read>
    4f2e:	08a05263          	blez	a0,4fb2 <concreate+0x174>
    if(de.inum == 0)
    4f32:	f7045783          	lhu	a5,-144(s0)
    4f36:	d7e5                	beqz	a5,4f1e <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f38:	f7244783          	lbu	a5,-142(s0)
    4f3c:	ff4791e3          	bne	a5,s4,4f1e <concreate+0xe0>
    4f40:	f7444783          	lbu	a5,-140(s0)
    4f44:	ffe9                	bnez	a5,4f1e <concreate+0xe0>
      i = de.name[1] - '0';
    4f46:	f7344783          	lbu	a5,-141(s0)
    4f4a:	fd07879b          	addiw	a5,a5,-48
    4f4e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f52:	02eb6063          	bltu	s6,a4,4f72 <concreate+0x134>
      if(fa[i]){
    4f56:	fb070793          	addi	a5,a4,-80 # fb0 <linktest+0xbc>
    4f5a:	97a2                	add	a5,a5,s0
    4f5c:	fd07c783          	lbu	a5,-48(a5)
    4f60:	eb8d                	bnez	a5,4f92 <concreate+0x154>
      fa[i] = 1;
    4f62:	fb070793          	addi	a5,a4,-80
    4f66:	00878733          	add	a4,a5,s0
    4f6a:	fd770823          	sb	s7,-48(a4)
      n++;
    4f6e:	2a85                	addiw	s5,s5,1
    4f70:	b77d                	j	4f1e <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f72:	f7240613          	addi	a2,s0,-142
    4f76:	85ce                	mv	a1,s3
    4f78:	00003517          	auipc	a0,0x3
    4f7c:	f8850513          	addi	a0,a0,-120 # 7f00 <malloc+0x1ec4>
    4f80:	00001097          	auipc	ra,0x1
    4f84:	004080e7          	jalr	4(ra) # 5f84 <printf>
        exit(1);
    4f88:	4505                	li	a0,1
    4f8a:	00001097          	auipc	ra,0x1
    4f8e:	c72080e7          	jalr	-910(ra) # 5bfc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4f92:	f7240613          	addi	a2,s0,-142
    4f96:	85ce                	mv	a1,s3
    4f98:	00003517          	auipc	a0,0x3
    4f9c:	f8850513          	addi	a0,a0,-120 # 7f20 <malloc+0x1ee4>
    4fa0:	00001097          	auipc	ra,0x1
    4fa4:	fe4080e7          	jalr	-28(ra) # 5f84 <printf>
        exit(1);
    4fa8:	4505                	li	a0,1
    4faa:	00001097          	auipc	ra,0x1
    4fae:	c52080e7          	jalr	-942(ra) # 5bfc <exit>
  close(fd);
    4fb2:	854a                	mv	a0,s2
    4fb4:	00001097          	auipc	ra,0x1
    4fb8:	c70080e7          	jalr	-912(ra) # 5c24 <close>
  if(n != N){
    4fbc:	02800793          	li	a5,40
    4fc0:	00fa9763          	bne	s5,a5,4fce <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    4fc4:	4a8d                	li	s5,3
    4fc6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fc8:	02800a13          	li	s4,40
    4fcc:	a8c9                	j	509e <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    4fce:	85ce                	mv	a1,s3
    4fd0:	00003517          	auipc	a0,0x3
    4fd4:	f7850513          	addi	a0,a0,-136 # 7f48 <malloc+0x1f0c>
    4fd8:	00001097          	auipc	ra,0x1
    4fdc:	fac080e7          	jalr	-84(ra) # 5f84 <printf>
    exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00001097          	auipc	ra,0x1
    4fe6:	c1a080e7          	jalr	-998(ra) # 5bfc <exit>
      printf("%s: fork failed\n", s);
    4fea:	85ce                	mv	a1,s3
    4fec:	00002517          	auipc	a0,0x2
    4ff0:	a1450513          	addi	a0,a0,-1516 # 6a00 <malloc+0x9c4>
    4ff4:	00001097          	auipc	ra,0x1
    4ff8:	f90080e7          	jalr	-112(ra) # 5f84 <printf>
      exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00001097          	auipc	ra,0x1
    5002:	bfe080e7          	jalr	-1026(ra) # 5bfc <exit>
      close(open(file, 0));
    5006:	4581                	li	a1,0
    5008:	fa840513          	addi	a0,s0,-88
    500c:	00001097          	auipc	ra,0x1
    5010:	c30080e7          	jalr	-976(ra) # 5c3c <open>
    5014:	00001097          	auipc	ra,0x1
    5018:	c10080e7          	jalr	-1008(ra) # 5c24 <close>
      close(open(file, 0));
    501c:	4581                	li	a1,0
    501e:	fa840513          	addi	a0,s0,-88
    5022:	00001097          	auipc	ra,0x1
    5026:	c1a080e7          	jalr	-998(ra) # 5c3c <open>
    502a:	00001097          	auipc	ra,0x1
    502e:	bfa080e7          	jalr	-1030(ra) # 5c24 <close>
      close(open(file, 0));
    5032:	4581                	li	a1,0
    5034:	fa840513          	addi	a0,s0,-88
    5038:	00001097          	auipc	ra,0x1
    503c:	c04080e7          	jalr	-1020(ra) # 5c3c <open>
    5040:	00001097          	auipc	ra,0x1
    5044:	be4080e7          	jalr	-1052(ra) # 5c24 <close>
      close(open(file, 0));
    5048:	4581                	li	a1,0
    504a:	fa840513          	addi	a0,s0,-88
    504e:	00001097          	auipc	ra,0x1
    5052:	bee080e7          	jalr	-1042(ra) # 5c3c <open>
    5056:	00001097          	auipc	ra,0x1
    505a:	bce080e7          	jalr	-1074(ra) # 5c24 <close>
      close(open(file, 0));
    505e:	4581                	li	a1,0
    5060:	fa840513          	addi	a0,s0,-88
    5064:	00001097          	auipc	ra,0x1
    5068:	bd8080e7          	jalr	-1064(ra) # 5c3c <open>
    506c:	00001097          	auipc	ra,0x1
    5070:	bb8080e7          	jalr	-1096(ra) # 5c24 <close>
      close(open(file, 0));
    5074:	4581                	li	a1,0
    5076:	fa840513          	addi	a0,s0,-88
    507a:	00001097          	auipc	ra,0x1
    507e:	bc2080e7          	jalr	-1086(ra) # 5c3c <open>
    5082:	00001097          	auipc	ra,0x1
    5086:	ba2080e7          	jalr	-1118(ra) # 5c24 <close>
    if(pid == 0)
    508a:	08090363          	beqz	s2,5110 <concreate+0x2d2>
      wait(0);
    508e:	4501                	li	a0,0
    5090:	00001097          	auipc	ra,0x1
    5094:	b74080e7          	jalr	-1164(ra) # 5c04 <wait>
  for(i = 0; i < N; i++){
    5098:	2485                	addiw	s1,s1,1
    509a:	0f448563          	beq	s1,s4,5184 <concreate+0x346>
    file[1] = '0' + i;
    509e:	0304879b          	addiw	a5,s1,48
    50a2:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50a6:	00001097          	auipc	ra,0x1
    50aa:	b4e080e7          	jalr	-1202(ra) # 5bf4 <fork>
    50ae:	892a                	mv	s2,a0
    if(pid < 0){
    50b0:	f2054de3          	bltz	a0,4fea <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    50b4:	0354e73b          	remw	a4,s1,s5
    50b8:	00a767b3          	or	a5,a4,a0
    50bc:	2781                	sext.w	a5,a5
    50be:	d7a1                	beqz	a5,5006 <concreate+0x1c8>
    50c0:	01671363          	bne	a4,s6,50c6 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    50c4:	f129                	bnez	a0,5006 <concreate+0x1c8>
      unlink(file);
    50c6:	fa840513          	addi	a0,s0,-88
    50ca:	00001097          	auipc	ra,0x1
    50ce:	b82080e7          	jalr	-1150(ra) # 5c4c <unlink>
      unlink(file);
    50d2:	fa840513          	addi	a0,s0,-88
    50d6:	00001097          	auipc	ra,0x1
    50da:	b76080e7          	jalr	-1162(ra) # 5c4c <unlink>
      unlink(file);
    50de:	fa840513          	addi	a0,s0,-88
    50e2:	00001097          	auipc	ra,0x1
    50e6:	b6a080e7          	jalr	-1174(ra) # 5c4c <unlink>
      unlink(file);
    50ea:	fa840513          	addi	a0,s0,-88
    50ee:	00001097          	auipc	ra,0x1
    50f2:	b5e080e7          	jalr	-1186(ra) # 5c4c <unlink>
      unlink(file);
    50f6:	fa840513          	addi	a0,s0,-88
    50fa:	00001097          	auipc	ra,0x1
    50fe:	b52080e7          	jalr	-1198(ra) # 5c4c <unlink>
      unlink(file);
    5102:	fa840513          	addi	a0,s0,-88
    5106:	00001097          	auipc	ra,0x1
    510a:	b46080e7          	jalr	-1210(ra) # 5c4c <unlink>
    510e:	bfb5                	j	508a <concreate+0x24c>
      exit(0);
    5110:	4501                	li	a0,0
    5112:	00001097          	auipc	ra,0x1
    5116:	aea080e7          	jalr	-1302(ra) # 5bfc <exit>
      close(fd);
    511a:	00001097          	auipc	ra,0x1
    511e:	b0a080e7          	jalr	-1270(ra) # 5c24 <close>
    if(pid == 0) {
    5122:	bb5d                	j	4ed8 <concreate+0x9a>
      close(fd);
    5124:	00001097          	auipc	ra,0x1
    5128:	b00080e7          	jalr	-1280(ra) # 5c24 <close>
      wait(&xstatus);
    512c:	f6c40513          	addi	a0,s0,-148
    5130:	00001097          	auipc	ra,0x1
    5134:	ad4080e7          	jalr	-1324(ra) # 5c04 <wait>
      if(xstatus != 0)
    5138:	f6c42483          	lw	s1,-148(s0)
    513c:	da0493e3          	bnez	s1,4ee2 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5140:	2905                	addiw	s2,s2,1
    5142:	db4905e3          	beq	s2,s4,4eec <concreate+0xae>
    file[1] = '0' + i;
    5146:	0309079b          	addiw	a5,s2,48
    514a:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    514e:	fa840513          	addi	a0,s0,-88
    5152:	00001097          	auipc	ra,0x1
    5156:	afa080e7          	jalr	-1286(ra) # 5c4c <unlink>
    pid = fork();
    515a:	00001097          	auipc	ra,0x1
    515e:	a9a080e7          	jalr	-1382(ra) # 5bf4 <fork>
    if(pid && (i % 3) == 1){
    5162:	d20502e3          	beqz	a0,4e86 <concreate+0x48>
    5166:	036967bb          	remw	a5,s2,s6
    516a:	d15786e3          	beq	a5,s5,4e76 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    516e:	20200593          	li	a1,514
    5172:	fa840513          	addi	a0,s0,-88
    5176:	00001097          	auipc	ra,0x1
    517a:	ac6080e7          	jalr	-1338(ra) # 5c3c <open>
      if(fd < 0){
    517e:	fa0553e3          	bgez	a0,5124 <concreate+0x2e6>
    5182:	b315                	j	4ea6 <concreate+0x68>
}
    5184:	60ea                	ld	ra,152(sp)
    5186:	644a                	ld	s0,144(sp)
    5188:	64aa                	ld	s1,136(sp)
    518a:	690a                	ld	s2,128(sp)
    518c:	79e6                	ld	s3,120(sp)
    518e:	7a46                	ld	s4,112(sp)
    5190:	7aa6                	ld	s5,104(sp)
    5192:	7b06                	ld	s6,96(sp)
    5194:	6be6                	ld	s7,88(sp)
    5196:	610d                	addi	sp,sp,160
    5198:	8082                	ret

000000000000519a <bigfile>:
{
    519a:	7139                	addi	sp,sp,-64
    519c:	fc06                	sd	ra,56(sp)
    519e:	f822                	sd	s0,48(sp)
    51a0:	f426                	sd	s1,40(sp)
    51a2:	f04a                	sd	s2,32(sp)
    51a4:	ec4e                	sd	s3,24(sp)
    51a6:	e852                	sd	s4,16(sp)
    51a8:	e456                	sd	s5,8(sp)
    51aa:	0080                	addi	s0,sp,64
    51ac:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51ae:	00003517          	auipc	a0,0x3
    51b2:	dd250513          	addi	a0,a0,-558 # 7f80 <malloc+0x1f44>
    51b6:	00001097          	auipc	ra,0x1
    51ba:	a96080e7          	jalr	-1386(ra) # 5c4c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51be:	20200593          	li	a1,514
    51c2:	00003517          	auipc	a0,0x3
    51c6:	dbe50513          	addi	a0,a0,-578 # 7f80 <malloc+0x1f44>
    51ca:	00001097          	auipc	ra,0x1
    51ce:	a72080e7          	jalr	-1422(ra) # 5c3c <open>
    51d2:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51d4:	4481                	li	s1,0
    memset(buf, i, SZ);
    51d6:	00009917          	auipc	s2,0x9
    51da:	e1290913          	addi	s2,s2,-494 # dfe8 <buf>
  for(i = 0; i < N; i++){
    51de:	4a51                	li	s4,20
  if(fd < 0){
    51e0:	0a054063          	bltz	a0,5280 <bigfile+0xe6>
    memset(buf, i, SZ);
    51e4:	25800613          	li	a2,600
    51e8:	85a6                	mv	a1,s1
    51ea:	854a                	mv	a0,s2
    51ec:	00001097          	auipc	ra,0x1
    51f0:	816080e7          	jalr	-2026(ra) # 5a02 <memset>
    if(write(fd, buf, SZ) != SZ){
    51f4:	25800613          	li	a2,600
    51f8:	85ca                	mv	a1,s2
    51fa:	854e                	mv	a0,s3
    51fc:	00001097          	auipc	ra,0x1
    5200:	a20080e7          	jalr	-1504(ra) # 5c1c <write>
    5204:	25800793          	li	a5,600
    5208:	08f51a63          	bne	a0,a5,529c <bigfile+0x102>
  for(i = 0; i < N; i++){
    520c:	2485                	addiw	s1,s1,1
    520e:	fd449be3          	bne	s1,s4,51e4 <bigfile+0x4a>
  close(fd);
    5212:	854e                	mv	a0,s3
    5214:	00001097          	auipc	ra,0x1
    5218:	a10080e7          	jalr	-1520(ra) # 5c24 <close>
  fd = open("bigfile.dat", 0);
    521c:	4581                	li	a1,0
    521e:	00003517          	auipc	a0,0x3
    5222:	d6250513          	addi	a0,a0,-670 # 7f80 <malloc+0x1f44>
    5226:	00001097          	auipc	ra,0x1
    522a:	a16080e7          	jalr	-1514(ra) # 5c3c <open>
    522e:	8a2a                	mv	s4,a0
  total = 0;
    5230:	4981                	li	s3,0
  for(i = 0; ; i++){
    5232:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5234:	00009917          	auipc	s2,0x9
    5238:	db490913          	addi	s2,s2,-588 # dfe8 <buf>
  if(fd < 0){
    523c:	06054e63          	bltz	a0,52b8 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5240:	12c00613          	li	a2,300
    5244:	85ca                	mv	a1,s2
    5246:	8552                	mv	a0,s4
    5248:	00001097          	auipc	ra,0x1
    524c:	9cc080e7          	jalr	-1588(ra) # 5c14 <read>
    if(cc < 0){
    5250:	08054263          	bltz	a0,52d4 <bigfile+0x13a>
    if(cc == 0)
    5254:	c971                	beqz	a0,5328 <bigfile+0x18e>
    if(cc != SZ/2){
    5256:	12c00793          	li	a5,300
    525a:	08f51b63          	bne	a0,a5,52f0 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    525e:	01f4d79b          	srliw	a5,s1,0x1f
    5262:	9fa5                	addw	a5,a5,s1
    5264:	4017d79b          	sraiw	a5,a5,0x1
    5268:	00094703          	lbu	a4,0(s2)
    526c:	0af71063          	bne	a4,a5,530c <bigfile+0x172>
    5270:	12b94703          	lbu	a4,299(s2)
    5274:	08f71c63          	bne	a4,a5,530c <bigfile+0x172>
    total += cc;
    5278:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    527c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    527e:	b7c9                	j	5240 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    5280:	85d6                	mv	a1,s5
    5282:	00003517          	auipc	a0,0x3
    5286:	d0e50513          	addi	a0,a0,-754 # 7f90 <malloc+0x1f54>
    528a:	00001097          	auipc	ra,0x1
    528e:	cfa080e7          	jalr	-774(ra) # 5f84 <printf>
    exit(1);
    5292:	4505                	li	a0,1
    5294:	00001097          	auipc	ra,0x1
    5298:	968080e7          	jalr	-1688(ra) # 5bfc <exit>
      printf("%s: write bigfile failed\n", s);
    529c:	85d6                	mv	a1,s5
    529e:	00003517          	auipc	a0,0x3
    52a2:	d1250513          	addi	a0,a0,-750 # 7fb0 <malloc+0x1f74>
    52a6:	00001097          	auipc	ra,0x1
    52aa:	cde080e7          	jalr	-802(ra) # 5f84 <printf>
      exit(1);
    52ae:	4505                	li	a0,1
    52b0:	00001097          	auipc	ra,0x1
    52b4:	94c080e7          	jalr	-1716(ra) # 5bfc <exit>
    printf("%s: cannot open bigfile\n", s);
    52b8:	85d6                	mv	a1,s5
    52ba:	00003517          	auipc	a0,0x3
    52be:	d1650513          	addi	a0,a0,-746 # 7fd0 <malloc+0x1f94>
    52c2:	00001097          	auipc	ra,0x1
    52c6:	cc2080e7          	jalr	-830(ra) # 5f84 <printf>
    exit(1);
    52ca:	4505                	li	a0,1
    52cc:	00001097          	auipc	ra,0x1
    52d0:	930080e7          	jalr	-1744(ra) # 5bfc <exit>
      printf("%s: read bigfile failed\n", s);
    52d4:	85d6                	mv	a1,s5
    52d6:	00003517          	auipc	a0,0x3
    52da:	d1a50513          	addi	a0,a0,-742 # 7ff0 <malloc+0x1fb4>
    52de:	00001097          	auipc	ra,0x1
    52e2:	ca6080e7          	jalr	-858(ra) # 5f84 <printf>
      exit(1);
    52e6:	4505                	li	a0,1
    52e8:	00001097          	auipc	ra,0x1
    52ec:	914080e7          	jalr	-1772(ra) # 5bfc <exit>
      printf("%s: short read bigfile\n", s);
    52f0:	85d6                	mv	a1,s5
    52f2:	00003517          	auipc	a0,0x3
    52f6:	d1e50513          	addi	a0,a0,-738 # 8010 <malloc+0x1fd4>
    52fa:	00001097          	auipc	ra,0x1
    52fe:	c8a080e7          	jalr	-886(ra) # 5f84 <printf>
      exit(1);
    5302:	4505                	li	a0,1
    5304:	00001097          	auipc	ra,0x1
    5308:	8f8080e7          	jalr	-1800(ra) # 5bfc <exit>
      printf("%s: read bigfile wrong data\n", s);
    530c:	85d6                	mv	a1,s5
    530e:	00003517          	auipc	a0,0x3
    5312:	d1a50513          	addi	a0,a0,-742 # 8028 <malloc+0x1fec>
    5316:	00001097          	auipc	ra,0x1
    531a:	c6e080e7          	jalr	-914(ra) # 5f84 <printf>
      exit(1);
    531e:	4505                	li	a0,1
    5320:	00001097          	auipc	ra,0x1
    5324:	8dc080e7          	jalr	-1828(ra) # 5bfc <exit>
  close(fd);
    5328:	8552                	mv	a0,s4
    532a:	00001097          	auipc	ra,0x1
    532e:	8fa080e7          	jalr	-1798(ra) # 5c24 <close>
  if(total != N*SZ){
    5332:	678d                	lui	a5,0x3
    5334:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0xa8>
    5338:	02f99363          	bne	s3,a5,535e <bigfile+0x1c4>
  unlink("bigfile.dat");
    533c:	00003517          	auipc	a0,0x3
    5340:	c4450513          	addi	a0,a0,-956 # 7f80 <malloc+0x1f44>
    5344:	00001097          	auipc	ra,0x1
    5348:	908080e7          	jalr	-1784(ra) # 5c4c <unlink>
}
    534c:	70e2                	ld	ra,56(sp)
    534e:	7442                	ld	s0,48(sp)
    5350:	74a2                	ld	s1,40(sp)
    5352:	7902                	ld	s2,32(sp)
    5354:	69e2                	ld	s3,24(sp)
    5356:	6a42                	ld	s4,16(sp)
    5358:	6aa2                	ld	s5,8(sp)
    535a:	6121                	addi	sp,sp,64
    535c:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    535e:	85d6                	mv	a1,s5
    5360:	00003517          	auipc	a0,0x3
    5364:	ce850513          	addi	a0,a0,-792 # 8048 <malloc+0x200c>
    5368:	00001097          	auipc	ra,0x1
    536c:	c1c080e7          	jalr	-996(ra) # 5f84 <printf>
    exit(1);
    5370:	4505                	li	a0,1
    5372:	00001097          	auipc	ra,0x1
    5376:	88a080e7          	jalr	-1910(ra) # 5bfc <exit>

000000000000537a <fsfull>:
{
    537a:	7135                	addi	sp,sp,-160
    537c:	ed06                	sd	ra,152(sp)
    537e:	e922                	sd	s0,144(sp)
    5380:	e526                	sd	s1,136(sp)
    5382:	e14a                	sd	s2,128(sp)
    5384:	fcce                	sd	s3,120(sp)
    5386:	f8d2                	sd	s4,112(sp)
    5388:	f4d6                	sd	s5,104(sp)
    538a:	f0da                	sd	s6,96(sp)
    538c:	ecde                	sd	s7,88(sp)
    538e:	e8e2                	sd	s8,80(sp)
    5390:	e4e6                	sd	s9,72(sp)
    5392:	e0ea                	sd	s10,64(sp)
    5394:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    5396:	00003517          	auipc	a0,0x3
    539a:	cd250513          	addi	a0,a0,-814 # 8068 <malloc+0x202c>
    539e:	00001097          	auipc	ra,0x1
    53a2:	be6080e7          	jalr	-1050(ra) # 5f84 <printf>
  for(nfiles = 0; ; nfiles++){
    53a6:	4481                	li	s1,0
    name[0] = 'f';
    53a8:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53ac:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53b0:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53b4:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53b6:	00003c97          	auipc	s9,0x3
    53ba:	cc2c8c93          	addi	s9,s9,-830 # 8078 <malloc+0x203c>
    name[0] = 'f';
    53be:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53c2:	0384c7bb          	divw	a5,s1,s8
    53c6:	0307879b          	addiw	a5,a5,48
    53ca:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53ce:	0384e7bb          	remw	a5,s1,s8
    53d2:	0377c7bb          	divw	a5,a5,s7
    53d6:	0307879b          	addiw	a5,a5,48
    53da:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    53de:	0374e7bb          	remw	a5,s1,s7
    53e2:	0367c7bb          	divw	a5,a5,s6
    53e6:	0307879b          	addiw	a5,a5,48
    53ea:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    53ee:	0364e7bb          	remw	a5,s1,s6
    53f2:	0307879b          	addiw	a5,a5,48
    53f6:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    53fa:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    53fe:	f6040593          	addi	a1,s0,-160
    5402:	8566                	mv	a0,s9
    5404:	00001097          	auipc	ra,0x1
    5408:	b80080e7          	jalr	-1152(ra) # 5f84 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    540c:	20200593          	li	a1,514
    5410:	f6040513          	addi	a0,s0,-160
    5414:	00001097          	auipc	ra,0x1
    5418:	828080e7          	jalr	-2008(ra) # 5c3c <open>
    541c:	892a                	mv	s2,a0
    if(fd < 0){
    541e:	0a055563          	bgez	a0,54c8 <fsfull+0x14e>
      printf("open %s failed\n", name);
    5422:	f6040593          	addi	a1,s0,-160
    5426:	00003517          	auipc	a0,0x3
    542a:	c6250513          	addi	a0,a0,-926 # 8088 <malloc+0x204c>
    542e:	00001097          	auipc	ra,0x1
    5432:	b56080e7          	jalr	-1194(ra) # 5f84 <printf>
  while(nfiles >= 0){
    5436:	0604c363          	bltz	s1,549c <fsfull+0x122>
    name[0] = 'f';
    543a:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    543e:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5442:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5446:	4929                	li	s2,10
  while(nfiles >= 0){
    5448:	5afd                	li	s5,-1
    name[0] = 'f';
    544a:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    544e:	0344c7bb          	divw	a5,s1,s4
    5452:	0307879b          	addiw	a5,a5,48
    5456:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    545a:	0344e7bb          	remw	a5,s1,s4
    545e:	0337c7bb          	divw	a5,a5,s3
    5462:	0307879b          	addiw	a5,a5,48
    5466:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    546a:	0334e7bb          	remw	a5,s1,s3
    546e:	0327c7bb          	divw	a5,a5,s2
    5472:	0307879b          	addiw	a5,a5,48
    5476:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    547a:	0324e7bb          	remw	a5,s1,s2
    547e:	0307879b          	addiw	a5,a5,48
    5482:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5486:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    548a:	f6040513          	addi	a0,s0,-160
    548e:	00000097          	auipc	ra,0x0
    5492:	7be080e7          	jalr	1982(ra) # 5c4c <unlink>
    nfiles--;
    5496:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5498:	fb5499e3          	bne	s1,s5,544a <fsfull+0xd0>
  printf("fsfull test finished\n");
    549c:	00003517          	auipc	a0,0x3
    54a0:	c0c50513          	addi	a0,a0,-1012 # 80a8 <malloc+0x206c>
    54a4:	00001097          	auipc	ra,0x1
    54a8:	ae0080e7          	jalr	-1312(ra) # 5f84 <printf>
}
    54ac:	60ea                	ld	ra,152(sp)
    54ae:	644a                	ld	s0,144(sp)
    54b0:	64aa                	ld	s1,136(sp)
    54b2:	690a                	ld	s2,128(sp)
    54b4:	79e6                	ld	s3,120(sp)
    54b6:	7a46                	ld	s4,112(sp)
    54b8:	7aa6                	ld	s5,104(sp)
    54ba:	7b06                	ld	s6,96(sp)
    54bc:	6be6                	ld	s7,88(sp)
    54be:	6c46                	ld	s8,80(sp)
    54c0:	6ca6                	ld	s9,72(sp)
    54c2:	6d06                	ld	s10,64(sp)
    54c4:	610d                	addi	sp,sp,160
    54c6:	8082                	ret
    int total = 0;
    54c8:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    54ca:	00009a97          	auipc	s5,0x9
    54ce:	b1ea8a93          	addi	s5,s5,-1250 # dfe8 <buf>
      if(cc < BSIZE)
    54d2:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    54d6:	40000613          	li	a2,1024
    54da:	85d6                	mv	a1,s5
    54dc:	854a                	mv	a0,s2
    54de:	00000097          	auipc	ra,0x0
    54e2:	73e080e7          	jalr	1854(ra) # 5c1c <write>
      if(cc < BSIZE)
    54e6:	00aa5563          	bge	s4,a0,54f0 <fsfull+0x176>
      total += cc;
    54ea:	00a989bb          	addw	s3,s3,a0
    while(1){
    54ee:	b7e5                	j	54d6 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    54f0:	85ce                	mv	a1,s3
    54f2:	00003517          	auipc	a0,0x3
    54f6:	ba650513          	addi	a0,a0,-1114 # 8098 <malloc+0x205c>
    54fa:	00001097          	auipc	ra,0x1
    54fe:	a8a080e7          	jalr	-1398(ra) # 5f84 <printf>
    close(fd);
    5502:	854a                	mv	a0,s2
    5504:	00000097          	auipc	ra,0x0
    5508:	720080e7          	jalr	1824(ra) # 5c24 <close>
    if(total == 0)
    550c:	f20985e3          	beqz	s3,5436 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    5510:	2485                	addiw	s1,s1,1
    5512:	b575                	j	53be <fsfull+0x44>

0000000000005514 <textwrite>:
{
    5514:	7179                	addi	sp,sp,-48
    5516:	f406                	sd	ra,40(sp)
    5518:	f022                	sd	s0,32(sp)
    551a:	ec26                	sd	s1,24(sp)
    551c:	1800                	addi	s0,sp,48
    551e:	84aa                	mv	s1,a0
  pid = fork();
    5520:	00000097          	auipc	ra,0x0
    5524:	6d4080e7          	jalr	1748(ra) # 5bf4 <fork>
  if(pid == 0) {
    5528:	c115                	beqz	a0,554c <textwrite+0x38>
  } else if(pid < 0){
    552a:	02054963          	bltz	a0,555c <textwrite+0x48>
  wait(&xstatus);
    552e:	fdc40513          	addi	a0,s0,-36
    5532:	00000097          	auipc	ra,0x0
    5536:	6d2080e7          	jalr	1746(ra) # 5c04 <wait>
  if(xstatus == -1)  // kernel killed child?
    553a:	fdc42503          	lw	a0,-36(s0)
    553e:	57fd                	li	a5,-1
    5540:	02f50c63          	beq	a0,a5,5578 <textwrite+0x64>
    exit(xstatus);
    5544:	00000097          	auipc	ra,0x0
    5548:	6b8080e7          	jalr	1720(ra) # 5bfc <exit>
    *addr = 10;
    554c:	47a9                	li	a5,10
    554e:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    5552:	4505                	li	a0,1
    5554:	00000097          	auipc	ra,0x0
    5558:	6a8080e7          	jalr	1704(ra) # 5bfc <exit>
    printf("%s: fork failed\n", s);
    555c:	85a6                	mv	a1,s1
    555e:	00001517          	auipc	a0,0x1
    5562:	4a250513          	addi	a0,a0,1186 # 6a00 <malloc+0x9c4>
    5566:	00001097          	auipc	ra,0x1
    556a:	a1e080e7          	jalr	-1506(ra) # 5f84 <printf>
    exit(1);
    556e:	4505                	li	a0,1
    5570:	00000097          	auipc	ra,0x0
    5574:	68c080e7          	jalr	1676(ra) # 5bfc <exit>
    exit(0);
    5578:	4501                	li	a0,0
    557a:	00000097          	auipc	ra,0x0
    557e:	682080e7          	jalr	1666(ra) # 5bfc <exit>

0000000000005582 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5582:	7179                	addi	sp,sp,-48
    5584:	f406                	sd	ra,40(sp)
    5586:	f022                	sd	s0,32(sp)
    5588:	ec26                	sd	s1,24(sp)
    558a:	e84a                	sd	s2,16(sp)
    558c:	1800                	addi	s0,sp,48
    558e:	84aa                	mv	s1,a0
    5590:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5592:	00003517          	auipc	a0,0x3
    5596:	b2e50513          	addi	a0,a0,-1234 # 80c0 <malloc+0x2084>
    559a:	00001097          	auipc	ra,0x1
    559e:	9ea080e7          	jalr	-1558(ra) # 5f84 <printf>
  if((pid = fork()) < 0) {
    55a2:	00000097          	auipc	ra,0x0
    55a6:	652080e7          	jalr	1618(ra) # 5bf4 <fork>
    55aa:	02054e63          	bltz	a0,55e6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    55ae:	c929                	beqz	a0,5600 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    55b0:	fdc40513          	addi	a0,s0,-36
    55b4:	00000097          	auipc	ra,0x0
    55b8:	650080e7          	jalr	1616(ra) # 5c04 <wait>
    if(xstatus != 0) 
    55bc:	fdc42783          	lw	a5,-36(s0)
    55c0:	c7b9                	beqz	a5,560e <run+0x8c>
      printf("FAILED\n");
    55c2:	00003517          	auipc	a0,0x3
    55c6:	b2650513          	addi	a0,a0,-1242 # 80e8 <malloc+0x20ac>
    55ca:	00001097          	auipc	ra,0x1
    55ce:	9ba080e7          	jalr	-1606(ra) # 5f84 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55d2:	fdc42503          	lw	a0,-36(s0)
  }
}
    55d6:	00153513          	seqz	a0,a0
    55da:	70a2                	ld	ra,40(sp)
    55dc:	7402                	ld	s0,32(sp)
    55de:	64e2                	ld	s1,24(sp)
    55e0:	6942                	ld	s2,16(sp)
    55e2:	6145                	addi	sp,sp,48
    55e4:	8082                	ret
    printf("runtest: fork error\n");
    55e6:	00003517          	auipc	a0,0x3
    55ea:	aea50513          	addi	a0,a0,-1302 # 80d0 <malloc+0x2094>
    55ee:	00001097          	auipc	ra,0x1
    55f2:	996080e7          	jalr	-1642(ra) # 5f84 <printf>
    exit(1);
    55f6:	4505                	li	a0,1
    55f8:	00000097          	auipc	ra,0x0
    55fc:	604080e7          	jalr	1540(ra) # 5bfc <exit>
    f(s);
    5600:	854a                	mv	a0,s2
    5602:	9482                	jalr	s1
    exit(0);
    5604:	4501                	li	a0,0
    5606:	00000097          	auipc	ra,0x0
    560a:	5f6080e7          	jalr	1526(ra) # 5bfc <exit>
      printf("OK\n");
    560e:	00003517          	auipc	a0,0x3
    5612:	ae250513          	addi	a0,a0,-1310 # 80f0 <malloc+0x20b4>
    5616:	00001097          	auipc	ra,0x1
    561a:	96e080e7          	jalr	-1682(ra) # 5f84 <printf>
    561e:	bf55                	j	55d2 <run+0x50>

0000000000005620 <runtests>:

int
runtests(struct test *tests, char *justone) {
    5620:	1101                	addi	sp,sp,-32
    5622:	ec06                	sd	ra,24(sp)
    5624:	e822                	sd	s0,16(sp)
    5626:	e426                	sd	s1,8(sp)
    5628:	e04a                	sd	s2,0(sp)
    562a:	1000                	addi	s0,sp,32
    562c:	84aa                	mv	s1,a0
    562e:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5630:	6508                	ld	a0,8(a0)
    5632:	ed09                	bnez	a0,564c <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5634:	4501                	li	a0,0
    5636:	a82d                	j	5670 <runtests+0x50>
      if(!run(t->f, t->s)){
    5638:	648c                	ld	a1,8(s1)
    563a:	6088                	ld	a0,0(s1)
    563c:	00000097          	auipc	ra,0x0
    5640:	f46080e7          	jalr	-186(ra) # 5582 <run>
    5644:	cd09                	beqz	a0,565e <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5646:	04c1                	addi	s1,s1,16
    5648:	6488                	ld	a0,8(s1)
    564a:	c11d                	beqz	a0,5670 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    564c:	fe0906e3          	beqz	s2,5638 <runtests+0x18>
    5650:	85ca                	mv	a1,s2
    5652:	00000097          	auipc	ra,0x0
    5656:	35a080e7          	jalr	858(ra) # 59ac <strcmp>
    565a:	f575                	bnez	a0,5646 <runtests+0x26>
    565c:	bff1                	j	5638 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    565e:	00003517          	auipc	a0,0x3
    5662:	a9a50513          	addi	a0,a0,-1382 # 80f8 <malloc+0x20bc>
    5666:	00001097          	auipc	ra,0x1
    566a:	91e080e7          	jalr	-1762(ra) # 5f84 <printf>
        return 1;
    566e:	4505                	li	a0,1
}
    5670:	60e2                	ld	ra,24(sp)
    5672:	6442                	ld	s0,16(sp)
    5674:	64a2                	ld	s1,8(sp)
    5676:	6902                	ld	s2,0(sp)
    5678:	6105                	addi	sp,sp,32
    567a:	8082                	ret

000000000000567c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    567c:	7139                	addi	sp,sp,-64
    567e:	fc06                	sd	ra,56(sp)
    5680:	f822                	sd	s0,48(sp)
    5682:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5684:	fc840513          	addi	a0,s0,-56
    5688:	00000097          	auipc	ra,0x0
    568c:	584080e7          	jalr	1412(ra) # 5c0c <pipe>
    5690:	06054a63          	bltz	a0,5704 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5694:	00000097          	auipc	ra,0x0
    5698:	560080e7          	jalr	1376(ra) # 5bf4 <fork>

  if(pid < 0){
    569c:	08054463          	bltz	a0,5724 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    56a0:	e55d                	bnez	a0,574e <countfree+0xd2>
    56a2:	f426                	sd	s1,40(sp)
    56a4:	f04a                	sd	s2,32(sp)
    56a6:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    56a8:	fc842503          	lw	a0,-56(s0)
    56ac:	00000097          	auipc	ra,0x0
    56b0:	578080e7          	jalr	1400(ra) # 5c24 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    56b4:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    56b6:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    56b8:	00001997          	auipc	s3,0x1
    56bc:	b3098993          	addi	s3,s3,-1232 # 61e8 <malloc+0x1ac>
      uint64 a = (uint64) sbrk(4096);
    56c0:	6505                	lui	a0,0x1
    56c2:	00000097          	auipc	ra,0x0
    56c6:	5c2080e7          	jalr	1474(ra) # 5c84 <sbrk>
      if(a == 0xffffffffffffffff){
    56ca:	07250d63          	beq	a0,s2,5744 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    56ce:	6785                	lui	a5,0x1
    56d0:	97aa                	add	a5,a5,a0
    56d2:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if(write(fds[1], "x", 1) != 1){
    56d6:	8626                	mv	a2,s1
    56d8:	85ce                	mv	a1,s3
    56da:	fcc42503          	lw	a0,-52(s0)
    56de:	00000097          	auipc	ra,0x0
    56e2:	53e080e7          	jalr	1342(ra) # 5c1c <write>
    56e6:	fc950de3          	beq	a0,s1,56c0 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56ea:	00003517          	auipc	a0,0x3
    56ee:	a6650513          	addi	a0,a0,-1434 # 8150 <malloc+0x2114>
    56f2:	00001097          	auipc	ra,0x1
    56f6:	892080e7          	jalr	-1902(ra) # 5f84 <printf>
        exit(1);
    56fa:	4505                	li	a0,1
    56fc:	00000097          	auipc	ra,0x0
    5700:	500080e7          	jalr	1280(ra) # 5bfc <exit>
    5704:	f426                	sd	s1,40(sp)
    5706:	f04a                	sd	s2,32(sp)
    5708:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    570a:	00003517          	auipc	a0,0x3
    570e:	a0650513          	addi	a0,a0,-1530 # 8110 <malloc+0x20d4>
    5712:	00001097          	auipc	ra,0x1
    5716:	872080e7          	jalr	-1934(ra) # 5f84 <printf>
    exit(1);
    571a:	4505                	li	a0,1
    571c:	00000097          	auipc	ra,0x0
    5720:	4e0080e7          	jalr	1248(ra) # 5bfc <exit>
    5724:	f426                	sd	s1,40(sp)
    5726:	f04a                	sd	s2,32(sp)
    5728:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    572a:	00003517          	auipc	a0,0x3
    572e:	a0650513          	addi	a0,a0,-1530 # 8130 <malloc+0x20f4>
    5732:	00001097          	auipc	ra,0x1
    5736:	852080e7          	jalr	-1966(ra) # 5f84 <printf>
    exit(1);
    573a:	4505                	li	a0,1
    573c:	00000097          	auipc	ra,0x0
    5740:	4c0080e7          	jalr	1216(ra) # 5bfc <exit>
      }
    }

    exit(0);
    5744:	4501                	li	a0,0
    5746:	00000097          	auipc	ra,0x0
    574a:	4b6080e7          	jalr	1206(ra) # 5bfc <exit>
    574e:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    5750:	fcc42503          	lw	a0,-52(s0)
    5754:	00000097          	auipc	ra,0x0
    5758:	4d0080e7          	jalr	1232(ra) # 5c24 <close>

  int n = 0;
    575c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    575e:	4605                	li	a2,1
    5760:	fc740593          	addi	a1,s0,-57
    5764:	fc842503          	lw	a0,-56(s0)
    5768:	00000097          	auipc	ra,0x0
    576c:	4ac080e7          	jalr	1196(ra) # 5c14 <read>
    if(cc < 0){
    5770:	00054563          	bltz	a0,577a <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5774:	c115                	beqz	a0,5798 <countfree+0x11c>
      break;
    n += 1;
    5776:	2485                	addiw	s1,s1,1
  while(1){
    5778:	b7dd                	j	575e <countfree+0xe2>
    577a:	f04a                	sd	s2,32(sp)
    577c:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    577e:	00003517          	auipc	a0,0x3
    5782:	9f250513          	addi	a0,a0,-1550 # 8170 <malloc+0x2134>
    5786:	00000097          	auipc	ra,0x0
    578a:	7fe080e7          	jalr	2046(ra) # 5f84 <printf>
      exit(1);
    578e:	4505                	li	a0,1
    5790:	00000097          	auipc	ra,0x0
    5794:	46c080e7          	jalr	1132(ra) # 5bfc <exit>
  }

  close(fds[0]);
    5798:	fc842503          	lw	a0,-56(s0)
    579c:	00000097          	auipc	ra,0x0
    57a0:	488080e7          	jalr	1160(ra) # 5c24 <close>
  wait((int*)0);
    57a4:	4501                	li	a0,0
    57a6:	00000097          	auipc	ra,0x0
    57aa:	45e080e7          	jalr	1118(ra) # 5c04 <wait>
  
  return n;
}
    57ae:	8526                	mv	a0,s1
    57b0:	74a2                	ld	s1,40(sp)
    57b2:	70e2                	ld	ra,56(sp)
    57b4:	7442                	ld	s0,48(sp)
    57b6:	6121                	addi	sp,sp,64
    57b8:	8082                	ret

00000000000057ba <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    57ba:	711d                	addi	sp,sp,-96
    57bc:	ec86                	sd	ra,88(sp)
    57be:	e8a2                	sd	s0,80(sp)
    57c0:	e4a6                	sd	s1,72(sp)
    57c2:	e0ca                	sd	s2,64(sp)
    57c4:	fc4e                	sd	s3,56(sp)
    57c6:	f852                	sd	s4,48(sp)
    57c8:	f456                	sd	s5,40(sp)
    57ca:	f05a                	sd	s6,32(sp)
    57cc:	ec5e                	sd	s7,24(sp)
    57ce:	e862                	sd	s8,16(sp)
    57d0:	e466                	sd	s9,8(sp)
    57d2:	e06a                	sd	s10,0(sp)
    57d4:	1080                	addi	s0,sp,96
    57d6:	8aaa                	mv	s5,a0
    57d8:	89ae                	mv	s3,a1
    57da:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    57dc:	00003b97          	auipc	s7,0x3
    57e0:	9b4b8b93          	addi	s7,s7,-1612 # 8190 <malloc+0x2154>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    57e4:	00005b17          	auipc	s6,0x5
    57e8:	bacb0b13          	addi	s6,s6,-1108 # a390 <quicktests>
      if(continuous != 2) {
    57ec:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    57ee:	00005c17          	auipc	s8,0x5
    57f2:	f62c0c13          	addi	s8,s8,-158 # a750 <slowtests>
        printf("usertests slow tests starting\n");
    57f6:	00003d17          	auipc	s10,0x3
    57fa:	9b2d0d13          	addi	s10,s10,-1614 # 81a8 <malloc+0x216c>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57fe:	00003c97          	auipc	s9,0x3
    5802:	9cac8c93          	addi	s9,s9,-1590 # 81c8 <malloc+0x218c>
    5806:	a839                	j	5824 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5808:	856a                	mv	a0,s10
    580a:	00000097          	auipc	ra,0x0
    580e:	77a080e7          	jalr	1914(ra) # 5f84 <printf>
    5812:	a081                	j	5852 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    5814:	00000097          	auipc	ra,0x0
    5818:	e68080e7          	jalr	-408(ra) # 567c <countfree>
    581c:	04954663          	blt	a0,s1,5868 <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5820:	06098163          	beqz	s3,5882 <drivetests+0xc8>
    printf("usertests starting\n");
    5824:	855e                	mv	a0,s7
    5826:	00000097          	auipc	ra,0x0
    582a:	75e080e7          	jalr	1886(ra) # 5f84 <printf>
    int free0 = countfree();
    582e:	00000097          	auipc	ra,0x0
    5832:	e4e080e7          	jalr	-434(ra) # 567c <countfree>
    5836:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5838:	85ca                	mv	a1,s2
    583a:	855a                	mv	a0,s6
    583c:	00000097          	auipc	ra,0x0
    5840:	de4080e7          	jalr	-540(ra) # 5620 <runtests>
    5844:	c119                	beqz	a0,584a <drivetests+0x90>
      if(continuous != 2) {
    5846:	03499c63          	bne	s3,s4,587e <drivetests+0xc4>
    if(!quick) {
    584a:	fc0a95e3          	bnez	s5,5814 <drivetests+0x5a>
      if (justone == 0)
    584e:	fa090de3          	beqz	s2,5808 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5852:	85ca                	mv	a1,s2
    5854:	8562                	mv	a0,s8
    5856:	00000097          	auipc	ra,0x0
    585a:	dca080e7          	jalr	-566(ra) # 5620 <runtests>
    585e:	d95d                	beqz	a0,5814 <drivetests+0x5a>
        if(continuous != 2) {
    5860:	fb498ae3          	beq	s3,s4,5814 <drivetests+0x5a>
          return 1;
    5864:	4505                	li	a0,1
    5866:	a839                	j	5884 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5868:	8626                	mv	a2,s1
    586a:	85aa                	mv	a1,a0
    586c:	8566                	mv	a0,s9
    586e:	00000097          	auipc	ra,0x0
    5872:	716080e7          	jalr	1814(ra) # 5f84 <printf>
      if(continuous != 2) {
    5876:	fb4987e3          	beq	s3,s4,5824 <drivetests+0x6a>
        return 1;
    587a:	4505                	li	a0,1
    587c:	a021                	j	5884 <drivetests+0xca>
        return 1;
    587e:	4505                	li	a0,1
    5880:	a011                	j	5884 <drivetests+0xca>
  return 0;
    5882:	854e                	mv	a0,s3
}
    5884:	60e6                	ld	ra,88(sp)
    5886:	6446                	ld	s0,80(sp)
    5888:	64a6                	ld	s1,72(sp)
    588a:	6906                	ld	s2,64(sp)
    588c:	79e2                	ld	s3,56(sp)
    588e:	7a42                	ld	s4,48(sp)
    5890:	7aa2                	ld	s5,40(sp)
    5892:	7b02                	ld	s6,32(sp)
    5894:	6be2                	ld	s7,24(sp)
    5896:	6c42                	ld	s8,16(sp)
    5898:	6ca2                	ld	s9,8(sp)
    589a:	6d02                	ld	s10,0(sp)
    589c:	6125                	addi	sp,sp,96
    589e:	8082                	ret

00000000000058a0 <main>:

int
main(int argc, char *argv[])
{
    58a0:	1101                	addi	sp,sp,-32
    58a2:	ec06                	sd	ra,24(sp)
    58a4:	e822                	sd	s0,16(sp)
    58a6:	e426                	sd	s1,8(sp)
    58a8:	e04a                	sd	s2,0(sp)
    58aa:	1000                	addi	s0,sp,32
    58ac:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58ae:	4789                	li	a5,2
    58b0:	02f50263          	beq	a0,a5,58d4 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58b4:	4785                	li	a5,1
    58b6:	08a7c063          	blt	a5,a0,5936 <main+0x96>
  char *justone = 0;
    58ba:	4601                	li	a2,0
  int quick = 0;
    58bc:	4501                	li	a0,0
  int continuous = 0;
    58be:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58c0:	00000097          	auipc	ra,0x0
    58c4:	efa080e7          	jalr	-262(ra) # 57ba <drivetests>
    58c8:	c951                	beqz	a0,595c <main+0xbc>
    exit(1);
    58ca:	4505                	li	a0,1
    58cc:	00000097          	auipc	ra,0x0
    58d0:	330080e7          	jalr	816(ra) # 5bfc <exit>
    58d4:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58d6:	00003597          	auipc	a1,0x3
    58da:	92258593          	addi	a1,a1,-1758 # 81f8 <malloc+0x21bc>
    58de:	00893503          	ld	a0,8(s2)
    58e2:	00000097          	auipc	ra,0x0
    58e6:	0ca080e7          	jalr	202(ra) # 59ac <strcmp>
    58ea:	85aa                	mv	a1,a0
    58ec:	e501                	bnez	a0,58f4 <main+0x54>
  char *justone = 0;
    58ee:	4601                	li	a2,0
    quick = 1;
    58f0:	4505                	li	a0,1
    58f2:	b7f9                	j	58c0 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58f4:	00003597          	auipc	a1,0x3
    58f8:	90c58593          	addi	a1,a1,-1780 # 8200 <malloc+0x21c4>
    58fc:	00893503          	ld	a0,8(s2)
    5900:	00000097          	auipc	ra,0x0
    5904:	0ac080e7          	jalr	172(ra) # 59ac <strcmp>
    5908:	c521                	beqz	a0,5950 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    590a:	00003597          	auipc	a1,0x3
    590e:	94658593          	addi	a1,a1,-1722 # 8250 <malloc+0x2214>
    5912:	00893503          	ld	a0,8(s2)
    5916:	00000097          	auipc	ra,0x0
    591a:	096080e7          	jalr	150(ra) # 59ac <strcmp>
    591e:	cd05                	beqz	a0,5956 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5920:	00893603          	ld	a2,8(s2)
    5924:	00064703          	lbu	a4,0(a2) # 3000 <execout+0xc0>
    5928:	02d00793          	li	a5,45
    592c:	00f70563          	beq	a4,a5,5936 <main+0x96>
  int quick = 0;
    5930:	4501                	li	a0,0
  int continuous = 0;
    5932:	4581                	li	a1,0
    5934:	b771                	j	58c0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5936:	00003517          	auipc	a0,0x3
    593a:	8d250513          	addi	a0,a0,-1838 # 8208 <malloc+0x21cc>
    593e:	00000097          	auipc	ra,0x0
    5942:	646080e7          	jalr	1606(ra) # 5f84 <printf>
    exit(1);
    5946:	4505                	li	a0,1
    5948:	00000097          	auipc	ra,0x0
    594c:	2b4080e7          	jalr	692(ra) # 5bfc <exit>
  char *justone = 0;
    5950:	4601                	li	a2,0
    continuous = 1;
    5952:	4585                	li	a1,1
    5954:	b7b5                	j	58c0 <main+0x20>
    continuous = 2;
    5956:	85a6                	mv	a1,s1
  char *justone = 0;
    5958:	4601                	li	a2,0
    595a:	b79d                	j	58c0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    595c:	00003517          	auipc	a0,0x3
    5960:	8dc50513          	addi	a0,a0,-1828 # 8238 <malloc+0x21fc>
    5964:	00000097          	auipc	ra,0x0
    5968:	620080e7          	jalr	1568(ra) # 5f84 <printf>
  exit(0);
    596c:	4501                	li	a0,0
    596e:	00000097          	auipc	ra,0x0
    5972:	28e080e7          	jalr	654(ra) # 5bfc <exit>

0000000000005976 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5976:	1141                	addi	sp,sp,-16
    5978:	e406                	sd	ra,8(sp)
    597a:	e022                	sd	s0,0(sp)
    597c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    597e:	00000097          	auipc	ra,0x0
    5982:	f22080e7          	jalr	-222(ra) # 58a0 <main>
  exit(0);
    5986:	4501                	li	a0,0
    5988:	00000097          	auipc	ra,0x0
    598c:	274080e7          	jalr	628(ra) # 5bfc <exit>

0000000000005990 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5990:	1141                	addi	sp,sp,-16
    5992:	e422                	sd	s0,8(sp)
    5994:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5996:	87aa                	mv	a5,a0
    5998:	0585                	addi	a1,a1,1
    599a:	0785                	addi	a5,a5,1
    599c:	fff5c703          	lbu	a4,-1(a1)
    59a0:	fee78fa3          	sb	a4,-1(a5)
    59a4:	fb75                	bnez	a4,5998 <strcpy+0x8>
    ;
  return os;
}
    59a6:	6422                	ld	s0,8(sp)
    59a8:	0141                	addi	sp,sp,16
    59aa:	8082                	ret

00000000000059ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59ac:	1141                	addi	sp,sp,-16
    59ae:	e422                	sd	s0,8(sp)
    59b0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    59b2:	00054783          	lbu	a5,0(a0)
    59b6:	cb91                	beqz	a5,59ca <strcmp+0x1e>
    59b8:	0005c703          	lbu	a4,0(a1)
    59bc:	00f71763          	bne	a4,a5,59ca <strcmp+0x1e>
    p++, q++;
    59c0:	0505                	addi	a0,a0,1
    59c2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    59c4:	00054783          	lbu	a5,0(a0)
    59c8:	fbe5                	bnez	a5,59b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59ca:	0005c503          	lbu	a0,0(a1)
}
    59ce:	40a7853b          	subw	a0,a5,a0
    59d2:	6422                	ld	s0,8(sp)
    59d4:	0141                	addi	sp,sp,16
    59d6:	8082                	ret

00000000000059d8 <strlen>:

uint
strlen(const char *s)
{
    59d8:	1141                	addi	sp,sp,-16
    59da:	e422                	sd	s0,8(sp)
    59dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59de:	00054783          	lbu	a5,0(a0)
    59e2:	cf91                	beqz	a5,59fe <strlen+0x26>
    59e4:	0505                	addi	a0,a0,1
    59e6:	87aa                	mv	a5,a0
    59e8:	86be                	mv	a3,a5
    59ea:	0785                	addi	a5,a5,1
    59ec:	fff7c703          	lbu	a4,-1(a5)
    59f0:	ff65                	bnez	a4,59e8 <strlen+0x10>
    59f2:	40a6853b          	subw	a0,a3,a0
    59f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    59f8:	6422                	ld	s0,8(sp)
    59fa:	0141                	addi	sp,sp,16
    59fc:	8082                	ret
  for(n = 0; s[n]; n++)
    59fe:	4501                	li	a0,0
    5a00:	bfe5                	j	59f8 <strlen+0x20>

0000000000005a02 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5a02:	1141                	addi	sp,sp,-16
    5a04:	e422                	sd	s0,8(sp)
    5a06:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a08:	ca19                	beqz	a2,5a1e <memset+0x1c>
    5a0a:	87aa                	mv	a5,a0
    5a0c:	1602                	slli	a2,a2,0x20
    5a0e:	9201                	srli	a2,a2,0x20
    5a10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a14:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a18:	0785                	addi	a5,a5,1
    5a1a:	fee79de3          	bne	a5,a4,5a14 <memset+0x12>
  }
  return dst;
}
    5a1e:	6422                	ld	s0,8(sp)
    5a20:	0141                	addi	sp,sp,16
    5a22:	8082                	ret

0000000000005a24 <strchr>:

char*
strchr(const char *s, char c)
{
    5a24:	1141                	addi	sp,sp,-16
    5a26:	e422                	sd	s0,8(sp)
    5a28:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5a2a:	00054783          	lbu	a5,0(a0)
    5a2e:	cb99                	beqz	a5,5a44 <strchr+0x20>
    if(*s == c)
    5a30:	00f58763          	beq	a1,a5,5a3e <strchr+0x1a>
  for(; *s; s++)
    5a34:	0505                	addi	a0,a0,1
    5a36:	00054783          	lbu	a5,0(a0)
    5a3a:	fbfd                	bnez	a5,5a30 <strchr+0xc>
      return (char*)s;
  return 0;
    5a3c:	4501                	li	a0,0
}
    5a3e:	6422                	ld	s0,8(sp)
    5a40:	0141                	addi	sp,sp,16
    5a42:	8082                	ret
  return 0;
    5a44:	4501                	li	a0,0
    5a46:	bfe5                	j	5a3e <strchr+0x1a>

0000000000005a48 <gets>:

char*
gets(char *buf, int max)
{
    5a48:	711d                	addi	sp,sp,-96
    5a4a:	ec86                	sd	ra,88(sp)
    5a4c:	e8a2                	sd	s0,80(sp)
    5a4e:	e4a6                	sd	s1,72(sp)
    5a50:	e0ca                	sd	s2,64(sp)
    5a52:	fc4e                	sd	s3,56(sp)
    5a54:	f852                	sd	s4,48(sp)
    5a56:	f456                	sd	s5,40(sp)
    5a58:	f05a                	sd	s6,32(sp)
    5a5a:	ec5e                	sd	s7,24(sp)
    5a5c:	1080                	addi	s0,sp,96
    5a5e:	8baa                	mv	s7,a0
    5a60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a62:	892a                	mv	s2,a0
    5a64:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a66:	4aa9                	li	s5,10
    5a68:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a6a:	89a6                	mv	s3,s1
    5a6c:	2485                	addiw	s1,s1,1
    5a6e:	0344d863          	bge	s1,s4,5a9e <gets+0x56>
    cc = read(0, &c, 1);
    5a72:	4605                	li	a2,1
    5a74:	faf40593          	addi	a1,s0,-81
    5a78:	4501                	li	a0,0
    5a7a:	00000097          	auipc	ra,0x0
    5a7e:	19a080e7          	jalr	410(ra) # 5c14 <read>
    if(cc < 1)
    5a82:	00a05e63          	blez	a0,5a9e <gets+0x56>
    buf[i++] = c;
    5a86:	faf44783          	lbu	a5,-81(s0)
    5a8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a8e:	01578763          	beq	a5,s5,5a9c <gets+0x54>
    5a92:	0905                	addi	s2,s2,1
    5a94:	fd679be3          	bne	a5,s6,5a6a <gets+0x22>
    buf[i++] = c;
    5a98:	89a6                	mv	s3,s1
    5a9a:	a011                	j	5a9e <gets+0x56>
    5a9c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a9e:	99de                	add	s3,s3,s7
    5aa0:	00098023          	sb	zero,0(s3)
  return buf;
}
    5aa4:	855e                	mv	a0,s7
    5aa6:	60e6                	ld	ra,88(sp)
    5aa8:	6446                	ld	s0,80(sp)
    5aaa:	64a6                	ld	s1,72(sp)
    5aac:	6906                	ld	s2,64(sp)
    5aae:	79e2                	ld	s3,56(sp)
    5ab0:	7a42                	ld	s4,48(sp)
    5ab2:	7aa2                	ld	s5,40(sp)
    5ab4:	7b02                	ld	s6,32(sp)
    5ab6:	6be2                	ld	s7,24(sp)
    5ab8:	6125                	addi	sp,sp,96
    5aba:	8082                	ret

0000000000005abc <stat>:

int
stat(const char *n, struct stat *st)
{
    5abc:	1101                	addi	sp,sp,-32
    5abe:	ec06                	sd	ra,24(sp)
    5ac0:	e822                	sd	s0,16(sp)
    5ac2:	e04a                	sd	s2,0(sp)
    5ac4:	1000                	addi	s0,sp,32
    5ac6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ac8:	4581                	li	a1,0
    5aca:	00000097          	auipc	ra,0x0
    5ace:	172080e7          	jalr	370(ra) # 5c3c <open>
  if(fd < 0)
    5ad2:	02054663          	bltz	a0,5afe <stat+0x42>
    5ad6:	e426                	sd	s1,8(sp)
    5ad8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5ada:	85ca                	mv	a1,s2
    5adc:	00000097          	auipc	ra,0x0
    5ae0:	178080e7          	jalr	376(ra) # 5c54 <fstat>
    5ae4:	892a                	mv	s2,a0
  close(fd);
    5ae6:	8526                	mv	a0,s1
    5ae8:	00000097          	auipc	ra,0x0
    5aec:	13c080e7          	jalr	316(ra) # 5c24 <close>
  return r;
    5af0:	64a2                	ld	s1,8(sp)
}
    5af2:	854a                	mv	a0,s2
    5af4:	60e2                	ld	ra,24(sp)
    5af6:	6442                	ld	s0,16(sp)
    5af8:	6902                	ld	s2,0(sp)
    5afa:	6105                	addi	sp,sp,32
    5afc:	8082                	ret
    return -1;
    5afe:	597d                	li	s2,-1
    5b00:	bfcd                	j	5af2 <stat+0x36>

0000000000005b02 <atoi>:

int
atoi(const char *s)
{
    5b02:	1141                	addi	sp,sp,-16
    5b04:	e422                	sd	s0,8(sp)
    5b06:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5b08:	00054683          	lbu	a3,0(a0)
    5b0c:	fd06879b          	addiw	a5,a3,-48
    5b10:	0ff7f793          	zext.b	a5,a5
    5b14:	4625                	li	a2,9
    5b16:	02f66863          	bltu	a2,a5,5b46 <atoi+0x44>
    5b1a:	872a                	mv	a4,a0
  n = 0;
    5b1c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5b1e:	0705                	addi	a4,a4,1
    5b20:	0025179b          	slliw	a5,a0,0x2
    5b24:	9fa9                	addw	a5,a5,a0
    5b26:	0017979b          	slliw	a5,a5,0x1
    5b2a:	9fb5                	addw	a5,a5,a3
    5b2c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b30:	00074683          	lbu	a3,0(a4)
    5b34:	fd06879b          	addiw	a5,a3,-48
    5b38:	0ff7f793          	zext.b	a5,a5
    5b3c:	fef671e3          	bgeu	a2,a5,5b1e <atoi+0x1c>
  return n;
}
    5b40:	6422                	ld	s0,8(sp)
    5b42:	0141                	addi	sp,sp,16
    5b44:	8082                	ret
  n = 0;
    5b46:	4501                	li	a0,0
    5b48:	bfe5                	j	5b40 <atoi+0x3e>

0000000000005b4a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b4a:	1141                	addi	sp,sp,-16
    5b4c:	e422                	sd	s0,8(sp)
    5b4e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b50:	02b57463          	bgeu	a0,a1,5b78 <memmove+0x2e>
    while(n-- > 0)
    5b54:	00c05f63          	blez	a2,5b72 <memmove+0x28>
    5b58:	1602                	slli	a2,a2,0x20
    5b5a:	9201                	srli	a2,a2,0x20
    5b5c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b60:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b62:	0585                	addi	a1,a1,1
    5b64:	0705                	addi	a4,a4,1
    5b66:	fff5c683          	lbu	a3,-1(a1)
    5b6a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b6e:	fef71ae3          	bne	a4,a5,5b62 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b72:	6422                	ld	s0,8(sp)
    5b74:	0141                	addi	sp,sp,16
    5b76:	8082                	ret
    dst += n;
    5b78:	00c50733          	add	a4,a0,a2
    src += n;
    5b7c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b7e:	fec05ae3          	blez	a2,5b72 <memmove+0x28>
    5b82:	fff6079b          	addiw	a5,a2,-1
    5b86:	1782                	slli	a5,a5,0x20
    5b88:	9381                	srli	a5,a5,0x20
    5b8a:	fff7c793          	not	a5,a5
    5b8e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b90:	15fd                	addi	a1,a1,-1
    5b92:	177d                	addi	a4,a4,-1
    5b94:	0005c683          	lbu	a3,0(a1)
    5b98:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b9c:	fee79ae3          	bne	a5,a4,5b90 <memmove+0x46>
    5ba0:	bfc9                	j	5b72 <memmove+0x28>

0000000000005ba2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5ba2:	1141                	addi	sp,sp,-16
    5ba4:	e422                	sd	s0,8(sp)
    5ba6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5ba8:	ca05                	beqz	a2,5bd8 <memcmp+0x36>
    5baa:	fff6069b          	addiw	a3,a2,-1
    5bae:	1682                	slli	a3,a3,0x20
    5bb0:	9281                	srli	a3,a3,0x20
    5bb2:	0685                	addi	a3,a3,1
    5bb4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5bb6:	00054783          	lbu	a5,0(a0)
    5bba:	0005c703          	lbu	a4,0(a1)
    5bbe:	00e79863          	bne	a5,a4,5bce <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bc2:	0505                	addi	a0,a0,1
    p2++;
    5bc4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5bc6:	fed518e3          	bne	a0,a3,5bb6 <memcmp+0x14>
  }
  return 0;
    5bca:	4501                	li	a0,0
    5bcc:	a019                	j	5bd2 <memcmp+0x30>
      return *p1 - *p2;
    5bce:	40e7853b          	subw	a0,a5,a4
}
    5bd2:	6422                	ld	s0,8(sp)
    5bd4:	0141                	addi	sp,sp,16
    5bd6:	8082                	ret
  return 0;
    5bd8:	4501                	li	a0,0
    5bda:	bfe5                	j	5bd2 <memcmp+0x30>

0000000000005bdc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bdc:	1141                	addi	sp,sp,-16
    5bde:	e406                	sd	ra,8(sp)
    5be0:	e022                	sd	s0,0(sp)
    5be2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5be4:	00000097          	auipc	ra,0x0
    5be8:	f66080e7          	jalr	-154(ra) # 5b4a <memmove>
}
    5bec:	60a2                	ld	ra,8(sp)
    5bee:	6402                	ld	s0,0(sp)
    5bf0:	0141                	addi	sp,sp,16
    5bf2:	8082                	ret

0000000000005bf4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bf4:	4885                	li	a7,1
 ecall
    5bf6:	00000073          	ecall
 ret
    5bfa:	8082                	ret

0000000000005bfc <exit>:
.global exit
exit:
 li a7, SYS_exit
    5bfc:	4889                	li	a7,2
 ecall
    5bfe:	00000073          	ecall
 ret
    5c02:	8082                	ret

0000000000005c04 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c04:	488d                	li	a7,3
 ecall
    5c06:	00000073          	ecall
 ret
    5c0a:	8082                	ret

0000000000005c0c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c0c:	4891                	li	a7,4
 ecall
    5c0e:	00000073          	ecall
 ret
    5c12:	8082                	ret

0000000000005c14 <read>:
.global read
read:
 li a7, SYS_read
    5c14:	4895                	li	a7,5
 ecall
    5c16:	00000073          	ecall
 ret
    5c1a:	8082                	ret

0000000000005c1c <write>:
.global write
write:
 li a7, SYS_write
    5c1c:	48c1                	li	a7,16
 ecall
    5c1e:	00000073          	ecall
 ret
    5c22:	8082                	ret

0000000000005c24 <close>:
.global close
close:
 li a7, SYS_close
    5c24:	48d5                	li	a7,21
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c2c:	4899                	li	a7,6
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c34:	489d                	li	a7,7
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <open>:
.global open
open:
 li a7, SYS_open
    5c3c:	48bd                	li	a7,15
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c44:	48c5                	li	a7,17
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c4c:	48c9                	li	a7,18
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c54:	48a1                	li	a7,8
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <link>:
.global link
link:
 li a7, SYS_link
    5c5c:	48cd                	li	a7,19
 ecall
    5c5e:	00000073          	ecall
 ret
    5c62:	8082                	ret

0000000000005c64 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c64:	48d1                	li	a7,20
 ecall
    5c66:	00000073          	ecall
 ret
    5c6a:	8082                	ret

0000000000005c6c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c6c:	48a5                	li	a7,9
 ecall
    5c6e:	00000073          	ecall
 ret
    5c72:	8082                	ret

0000000000005c74 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c74:	48a9                	li	a7,10
 ecall
    5c76:	00000073          	ecall
 ret
    5c7a:	8082                	ret

0000000000005c7c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c7c:	48ad                	li	a7,11
 ecall
    5c7e:	00000073          	ecall
 ret
    5c82:	8082                	ret

0000000000005c84 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c84:	48b1                	li	a7,12
 ecall
    5c86:	00000073          	ecall
 ret
    5c8a:	8082                	ret

0000000000005c8c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c8c:	48b5                	li	a7,13
 ecall
    5c8e:	00000073          	ecall
 ret
    5c92:	8082                	ret

0000000000005c94 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c94:	48b9                	li	a7,14
 ecall
    5c96:	00000073          	ecall
 ret
    5c9a:	8082                	ret

0000000000005c9c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
    5c9c:	48d9                	li	a7,22
 ecall
    5c9e:	00000073          	ecall
 ret
    5ca2:	8082                	ret

0000000000005ca4 <getSysCount>:
.global getSysCount
getSysCount:
 li a7, SYS_getSysCount
    5ca4:	48dd                	li	a7,23
 ecall
    5ca6:	00000073          	ecall
 ret
    5caa:	8082                	ret

0000000000005cac <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5cac:	48e1                	li	a7,24
 ecall
    5cae:	00000073          	ecall
 ret
    5cb2:	8082                	ret

0000000000005cb4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5cb4:	48e5                	li	a7,25
 ecall
    5cb6:	00000073          	ecall
 ret
    5cba:	8082                	ret

0000000000005cbc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5cbc:	1101                	addi	sp,sp,-32
    5cbe:	ec06                	sd	ra,24(sp)
    5cc0:	e822                	sd	s0,16(sp)
    5cc2:	1000                	addi	s0,sp,32
    5cc4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5cc8:	4605                	li	a2,1
    5cca:	fef40593          	addi	a1,s0,-17
    5cce:	00000097          	auipc	ra,0x0
    5cd2:	f4e080e7          	jalr	-178(ra) # 5c1c <write>
}
    5cd6:	60e2                	ld	ra,24(sp)
    5cd8:	6442                	ld	s0,16(sp)
    5cda:	6105                	addi	sp,sp,32
    5cdc:	8082                	ret

0000000000005cde <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cde:	7139                	addi	sp,sp,-64
    5ce0:	fc06                	sd	ra,56(sp)
    5ce2:	f822                	sd	s0,48(sp)
    5ce4:	f426                	sd	s1,40(sp)
    5ce6:	0080                	addi	s0,sp,64
    5ce8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cea:	c299                	beqz	a3,5cf0 <printint+0x12>
    5cec:	0805cb63          	bltz	a1,5d82 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cf0:	2581                	sext.w	a1,a1
  neg = 0;
    5cf2:	4881                	li	a7,0
    5cf4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cf8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cfa:	2601                	sext.w	a2,a2
    5cfc:	00003517          	auipc	a0,0x3
    5d00:	90c50513          	addi	a0,a0,-1780 # 8608 <digits>
    5d04:	883a                	mv	a6,a4
    5d06:	2705                	addiw	a4,a4,1
    5d08:	02c5f7bb          	remuw	a5,a1,a2
    5d0c:	1782                	slli	a5,a5,0x20
    5d0e:	9381                	srli	a5,a5,0x20
    5d10:	97aa                	add	a5,a5,a0
    5d12:	0007c783          	lbu	a5,0(a5)
    5d16:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d1a:	0005879b          	sext.w	a5,a1
    5d1e:	02c5d5bb          	divuw	a1,a1,a2
    5d22:	0685                	addi	a3,a3,1
    5d24:	fec7f0e3          	bgeu	a5,a2,5d04 <printint+0x26>
  if(neg)
    5d28:	00088c63          	beqz	a7,5d40 <printint+0x62>
    buf[i++] = '-';
    5d2c:	fd070793          	addi	a5,a4,-48
    5d30:	00878733          	add	a4,a5,s0
    5d34:	02d00793          	li	a5,45
    5d38:	fef70823          	sb	a5,-16(a4)
    5d3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d40:	02e05c63          	blez	a4,5d78 <printint+0x9a>
    5d44:	f04a                	sd	s2,32(sp)
    5d46:	ec4e                	sd	s3,24(sp)
    5d48:	fc040793          	addi	a5,s0,-64
    5d4c:	00e78933          	add	s2,a5,a4
    5d50:	fff78993          	addi	s3,a5,-1
    5d54:	99ba                	add	s3,s3,a4
    5d56:	377d                	addiw	a4,a4,-1
    5d58:	1702                	slli	a4,a4,0x20
    5d5a:	9301                	srli	a4,a4,0x20
    5d5c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d60:	fff94583          	lbu	a1,-1(s2)
    5d64:	8526                	mv	a0,s1
    5d66:	00000097          	auipc	ra,0x0
    5d6a:	f56080e7          	jalr	-170(ra) # 5cbc <putc>
  while(--i >= 0)
    5d6e:	197d                	addi	s2,s2,-1
    5d70:	ff3918e3          	bne	s2,s3,5d60 <printint+0x82>
    5d74:	7902                	ld	s2,32(sp)
    5d76:	69e2                	ld	s3,24(sp)
}
    5d78:	70e2                	ld	ra,56(sp)
    5d7a:	7442                	ld	s0,48(sp)
    5d7c:	74a2                	ld	s1,40(sp)
    5d7e:	6121                	addi	sp,sp,64
    5d80:	8082                	ret
    x = -xx;
    5d82:	40b005bb          	negw	a1,a1
    neg = 1;
    5d86:	4885                	li	a7,1
    x = -xx;
    5d88:	b7b5                	j	5cf4 <printint+0x16>

0000000000005d8a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d8a:	715d                	addi	sp,sp,-80
    5d8c:	e486                	sd	ra,72(sp)
    5d8e:	e0a2                	sd	s0,64(sp)
    5d90:	f84a                	sd	s2,48(sp)
    5d92:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d94:	0005c903          	lbu	s2,0(a1)
    5d98:	1a090a63          	beqz	s2,5f4c <vprintf+0x1c2>
    5d9c:	fc26                	sd	s1,56(sp)
    5d9e:	f44e                	sd	s3,40(sp)
    5da0:	f052                	sd	s4,32(sp)
    5da2:	ec56                	sd	s5,24(sp)
    5da4:	e85a                	sd	s6,16(sp)
    5da6:	e45e                	sd	s7,8(sp)
    5da8:	8aaa                	mv	s5,a0
    5daa:	8bb2                	mv	s7,a2
    5dac:	00158493          	addi	s1,a1,1
  state = 0;
    5db0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5db2:	02500a13          	li	s4,37
    5db6:	4b55                	li	s6,21
    5db8:	a839                	j	5dd6 <vprintf+0x4c>
        putc(fd, c);
    5dba:	85ca                	mv	a1,s2
    5dbc:	8556                	mv	a0,s5
    5dbe:	00000097          	auipc	ra,0x0
    5dc2:	efe080e7          	jalr	-258(ra) # 5cbc <putc>
    5dc6:	a019                	j	5dcc <vprintf+0x42>
    } else if(state == '%'){
    5dc8:	01498d63          	beq	s3,s4,5de2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5dcc:	0485                	addi	s1,s1,1
    5dce:	fff4c903          	lbu	s2,-1(s1)
    5dd2:	16090763          	beqz	s2,5f40 <vprintf+0x1b6>
    if(state == 0){
    5dd6:	fe0999e3          	bnez	s3,5dc8 <vprintf+0x3e>
      if(c == '%'){
    5dda:	ff4910e3          	bne	s2,s4,5dba <vprintf+0x30>
        state = '%';
    5dde:	89d2                	mv	s3,s4
    5de0:	b7f5                	j	5dcc <vprintf+0x42>
      if(c == 'd'){
    5de2:	13490463          	beq	s2,s4,5f0a <vprintf+0x180>
    5de6:	f9d9079b          	addiw	a5,s2,-99
    5dea:	0ff7f793          	zext.b	a5,a5
    5dee:	12fb6763          	bltu	s6,a5,5f1c <vprintf+0x192>
    5df2:	f9d9079b          	addiw	a5,s2,-99
    5df6:	0ff7f713          	zext.b	a4,a5
    5dfa:	12eb6163          	bltu	s6,a4,5f1c <vprintf+0x192>
    5dfe:	00271793          	slli	a5,a4,0x2
    5e02:	00002717          	auipc	a4,0x2
    5e06:	7ae70713          	addi	a4,a4,1966 # 85b0 <malloc+0x2574>
    5e0a:	97ba                	add	a5,a5,a4
    5e0c:	439c                	lw	a5,0(a5)
    5e0e:	97ba                	add	a5,a5,a4
    5e10:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e12:	008b8913          	addi	s2,s7,8
    5e16:	4685                	li	a3,1
    5e18:	4629                	li	a2,10
    5e1a:	000ba583          	lw	a1,0(s7)
    5e1e:	8556                	mv	a0,s5
    5e20:	00000097          	auipc	ra,0x0
    5e24:	ebe080e7          	jalr	-322(ra) # 5cde <printint>
    5e28:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e2a:	4981                	li	s3,0
    5e2c:	b745                	j	5dcc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e2e:	008b8913          	addi	s2,s7,8
    5e32:	4681                	li	a3,0
    5e34:	4629                	li	a2,10
    5e36:	000ba583          	lw	a1,0(s7)
    5e3a:	8556                	mv	a0,s5
    5e3c:	00000097          	auipc	ra,0x0
    5e40:	ea2080e7          	jalr	-350(ra) # 5cde <printint>
    5e44:	8bca                	mv	s7,s2
      state = 0;
    5e46:	4981                	li	s3,0
    5e48:	b751                	j	5dcc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5e4a:	008b8913          	addi	s2,s7,8
    5e4e:	4681                	li	a3,0
    5e50:	4641                	li	a2,16
    5e52:	000ba583          	lw	a1,0(s7)
    5e56:	8556                	mv	a0,s5
    5e58:	00000097          	auipc	ra,0x0
    5e5c:	e86080e7          	jalr	-378(ra) # 5cde <printint>
    5e60:	8bca                	mv	s7,s2
      state = 0;
    5e62:	4981                	li	s3,0
    5e64:	b7a5                	j	5dcc <vprintf+0x42>
    5e66:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e68:	008b8c13          	addi	s8,s7,8
    5e6c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e70:	03000593          	li	a1,48
    5e74:	8556                	mv	a0,s5
    5e76:	00000097          	auipc	ra,0x0
    5e7a:	e46080e7          	jalr	-442(ra) # 5cbc <putc>
  putc(fd, 'x');
    5e7e:	07800593          	li	a1,120
    5e82:	8556                	mv	a0,s5
    5e84:	00000097          	auipc	ra,0x0
    5e88:	e38080e7          	jalr	-456(ra) # 5cbc <putc>
    5e8c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e8e:	00002b97          	auipc	s7,0x2
    5e92:	77ab8b93          	addi	s7,s7,1914 # 8608 <digits>
    5e96:	03c9d793          	srli	a5,s3,0x3c
    5e9a:	97de                	add	a5,a5,s7
    5e9c:	0007c583          	lbu	a1,0(a5)
    5ea0:	8556                	mv	a0,s5
    5ea2:	00000097          	auipc	ra,0x0
    5ea6:	e1a080e7          	jalr	-486(ra) # 5cbc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eaa:	0992                	slli	s3,s3,0x4
    5eac:	397d                	addiw	s2,s2,-1
    5eae:	fe0914e3          	bnez	s2,5e96 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5eb2:	8be2                	mv	s7,s8
      state = 0;
    5eb4:	4981                	li	s3,0
    5eb6:	6c02                	ld	s8,0(sp)
    5eb8:	bf11                	j	5dcc <vprintf+0x42>
        s = va_arg(ap, char*);
    5eba:	008b8993          	addi	s3,s7,8
    5ebe:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5ec2:	02090163          	beqz	s2,5ee4 <vprintf+0x15a>
        while(*s != 0){
    5ec6:	00094583          	lbu	a1,0(s2)
    5eca:	c9a5                	beqz	a1,5f3a <vprintf+0x1b0>
          putc(fd, *s);
    5ecc:	8556                	mv	a0,s5
    5ece:	00000097          	auipc	ra,0x0
    5ed2:	dee080e7          	jalr	-530(ra) # 5cbc <putc>
          s++;
    5ed6:	0905                	addi	s2,s2,1
        while(*s != 0){
    5ed8:	00094583          	lbu	a1,0(s2)
    5edc:	f9e5                	bnez	a1,5ecc <vprintf+0x142>
        s = va_arg(ap, char*);
    5ede:	8bce                	mv	s7,s3
      state = 0;
    5ee0:	4981                	li	s3,0
    5ee2:	b5ed                	j	5dcc <vprintf+0x42>
          s = "(null)";
    5ee4:	00002917          	auipc	s2,0x2
    5ee8:	6a490913          	addi	s2,s2,1700 # 8588 <malloc+0x254c>
        while(*s != 0){
    5eec:	02800593          	li	a1,40
    5ef0:	bff1                	j	5ecc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5ef2:	008b8913          	addi	s2,s7,8
    5ef6:	000bc583          	lbu	a1,0(s7)
    5efa:	8556                	mv	a0,s5
    5efc:	00000097          	auipc	ra,0x0
    5f00:	dc0080e7          	jalr	-576(ra) # 5cbc <putc>
    5f04:	8bca                	mv	s7,s2
      state = 0;
    5f06:	4981                	li	s3,0
    5f08:	b5d1                	j	5dcc <vprintf+0x42>
        putc(fd, c);
    5f0a:	02500593          	li	a1,37
    5f0e:	8556                	mv	a0,s5
    5f10:	00000097          	auipc	ra,0x0
    5f14:	dac080e7          	jalr	-596(ra) # 5cbc <putc>
      state = 0;
    5f18:	4981                	li	s3,0
    5f1a:	bd4d                	j	5dcc <vprintf+0x42>
        putc(fd, '%');
    5f1c:	02500593          	li	a1,37
    5f20:	8556                	mv	a0,s5
    5f22:	00000097          	auipc	ra,0x0
    5f26:	d9a080e7          	jalr	-614(ra) # 5cbc <putc>
        putc(fd, c);
    5f2a:	85ca                	mv	a1,s2
    5f2c:	8556                	mv	a0,s5
    5f2e:	00000097          	auipc	ra,0x0
    5f32:	d8e080e7          	jalr	-626(ra) # 5cbc <putc>
      state = 0;
    5f36:	4981                	li	s3,0
    5f38:	bd51                	j	5dcc <vprintf+0x42>
        s = va_arg(ap, char*);
    5f3a:	8bce                	mv	s7,s3
      state = 0;
    5f3c:	4981                	li	s3,0
    5f3e:	b579                	j	5dcc <vprintf+0x42>
    5f40:	74e2                	ld	s1,56(sp)
    5f42:	79a2                	ld	s3,40(sp)
    5f44:	7a02                	ld	s4,32(sp)
    5f46:	6ae2                	ld	s5,24(sp)
    5f48:	6b42                	ld	s6,16(sp)
    5f4a:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5f4c:	60a6                	ld	ra,72(sp)
    5f4e:	6406                	ld	s0,64(sp)
    5f50:	7942                	ld	s2,48(sp)
    5f52:	6161                	addi	sp,sp,80
    5f54:	8082                	ret

0000000000005f56 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f56:	715d                	addi	sp,sp,-80
    5f58:	ec06                	sd	ra,24(sp)
    5f5a:	e822                	sd	s0,16(sp)
    5f5c:	1000                	addi	s0,sp,32
    5f5e:	e010                	sd	a2,0(s0)
    5f60:	e414                	sd	a3,8(s0)
    5f62:	e818                	sd	a4,16(s0)
    5f64:	ec1c                	sd	a5,24(s0)
    5f66:	03043023          	sd	a6,32(s0)
    5f6a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f6e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f72:	8622                	mv	a2,s0
    5f74:	00000097          	auipc	ra,0x0
    5f78:	e16080e7          	jalr	-490(ra) # 5d8a <vprintf>
}
    5f7c:	60e2                	ld	ra,24(sp)
    5f7e:	6442                	ld	s0,16(sp)
    5f80:	6161                	addi	sp,sp,80
    5f82:	8082                	ret

0000000000005f84 <printf>:

void
printf(const char *fmt, ...)
{
    5f84:	711d                	addi	sp,sp,-96
    5f86:	ec06                	sd	ra,24(sp)
    5f88:	e822                	sd	s0,16(sp)
    5f8a:	1000                	addi	s0,sp,32
    5f8c:	e40c                	sd	a1,8(s0)
    5f8e:	e810                	sd	a2,16(s0)
    5f90:	ec14                	sd	a3,24(s0)
    5f92:	f018                	sd	a4,32(s0)
    5f94:	f41c                	sd	a5,40(s0)
    5f96:	03043823          	sd	a6,48(s0)
    5f9a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f9e:	00840613          	addi	a2,s0,8
    5fa2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fa6:	85aa                	mv	a1,a0
    5fa8:	4505                	li	a0,1
    5faa:	00000097          	auipc	ra,0x0
    5fae:	de0080e7          	jalr	-544(ra) # 5d8a <vprintf>
}
    5fb2:	60e2                	ld	ra,24(sp)
    5fb4:	6442                	ld	s0,16(sp)
    5fb6:	6125                	addi	sp,sp,96
    5fb8:	8082                	ret

0000000000005fba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fba:	1141                	addi	sp,sp,-16
    5fbc:	e422                	sd	s0,8(sp)
    5fbe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fc0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fc4:	00004797          	auipc	a5,0x4
    5fc8:	7fc7b783          	ld	a5,2044(a5) # a7c0 <freep>
    5fcc:	a02d                	j	5ff6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fce:	4618                	lw	a4,8(a2)
    5fd0:	9f2d                	addw	a4,a4,a1
    5fd2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fd6:	6398                	ld	a4,0(a5)
    5fd8:	6310                	ld	a2,0(a4)
    5fda:	a83d                	j	6018 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fdc:	ff852703          	lw	a4,-8(a0)
    5fe0:	9f31                	addw	a4,a4,a2
    5fe2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5fe4:	ff053683          	ld	a3,-16(a0)
    5fe8:	a091                	j	602c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fea:	6398                	ld	a4,0(a5)
    5fec:	00e7e463          	bltu	a5,a4,5ff4 <free+0x3a>
    5ff0:	00e6ea63          	bltu	a3,a4,6004 <free+0x4a>
{
    5ff4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ff6:	fed7fae3          	bgeu	a5,a3,5fea <free+0x30>
    5ffa:	6398                	ld	a4,0(a5)
    5ffc:	00e6e463          	bltu	a3,a4,6004 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6000:	fee7eae3          	bltu	a5,a4,5ff4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    6004:	ff852583          	lw	a1,-8(a0)
    6008:	6390                	ld	a2,0(a5)
    600a:	02059813          	slli	a6,a1,0x20
    600e:	01c85713          	srli	a4,a6,0x1c
    6012:	9736                	add	a4,a4,a3
    6014:	fae60de3          	beq	a2,a4,5fce <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6018:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    601c:	4790                	lw	a2,8(a5)
    601e:	02061593          	slli	a1,a2,0x20
    6022:	01c5d713          	srli	a4,a1,0x1c
    6026:	973e                	add	a4,a4,a5
    6028:	fae68ae3          	beq	a3,a4,5fdc <free+0x22>
    p->s.ptr = bp->s.ptr;
    602c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    602e:	00004717          	auipc	a4,0x4
    6032:	78f73923          	sd	a5,1938(a4) # a7c0 <freep>
}
    6036:	6422                	ld	s0,8(sp)
    6038:	0141                	addi	sp,sp,16
    603a:	8082                	ret

000000000000603c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    603c:	7139                	addi	sp,sp,-64
    603e:	fc06                	sd	ra,56(sp)
    6040:	f822                	sd	s0,48(sp)
    6042:	f426                	sd	s1,40(sp)
    6044:	ec4e                	sd	s3,24(sp)
    6046:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6048:	02051493          	slli	s1,a0,0x20
    604c:	9081                	srli	s1,s1,0x20
    604e:	04bd                	addi	s1,s1,15
    6050:	8091                	srli	s1,s1,0x4
    6052:	0014899b          	addiw	s3,s1,1
    6056:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6058:	00004517          	auipc	a0,0x4
    605c:	76853503          	ld	a0,1896(a0) # a7c0 <freep>
    6060:	c915                	beqz	a0,6094 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6062:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6064:	4798                	lw	a4,8(a5)
    6066:	08977e63          	bgeu	a4,s1,6102 <malloc+0xc6>
    606a:	f04a                	sd	s2,32(sp)
    606c:	e852                	sd	s4,16(sp)
    606e:	e456                	sd	s5,8(sp)
    6070:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    6072:	8a4e                	mv	s4,s3
    6074:	0009871b          	sext.w	a4,s3
    6078:	6685                	lui	a3,0x1
    607a:	00d77363          	bgeu	a4,a3,6080 <malloc+0x44>
    607e:	6a05                	lui	s4,0x1
    6080:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6084:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6088:	00004917          	auipc	s2,0x4
    608c:	73890913          	addi	s2,s2,1848 # a7c0 <freep>
  if(p == (char*)-1)
    6090:	5afd                	li	s5,-1
    6092:	a091                	j	60d6 <malloc+0x9a>
    6094:	f04a                	sd	s2,32(sp)
    6096:	e852                	sd	s4,16(sp)
    6098:	e456                	sd	s5,8(sp)
    609a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    609c:	0000b797          	auipc	a5,0xb
    60a0:	f4c78793          	addi	a5,a5,-180 # 10fe8 <base>
    60a4:	00004717          	auipc	a4,0x4
    60a8:	70f73e23          	sd	a5,1820(a4) # a7c0 <freep>
    60ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60b2:	b7c1                	j	6072 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    60b4:	6398                	ld	a4,0(a5)
    60b6:	e118                	sd	a4,0(a0)
    60b8:	a08d                	j	611a <malloc+0xde>
  hp->s.size = nu;
    60ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60be:	0541                	addi	a0,a0,16
    60c0:	00000097          	auipc	ra,0x0
    60c4:	efa080e7          	jalr	-262(ra) # 5fba <free>
  return freep;
    60c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60cc:	c13d                	beqz	a0,6132 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60d0:	4798                	lw	a4,8(a5)
    60d2:	02977463          	bgeu	a4,s1,60fa <malloc+0xbe>
    if(p == freep)
    60d6:	00093703          	ld	a4,0(s2)
    60da:	853e                	mv	a0,a5
    60dc:	fef719e3          	bne	a4,a5,60ce <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    60e0:	8552                	mv	a0,s4
    60e2:	00000097          	auipc	ra,0x0
    60e6:	ba2080e7          	jalr	-1118(ra) # 5c84 <sbrk>
  if(p == (char*)-1)
    60ea:	fd5518e3          	bne	a0,s5,60ba <malloc+0x7e>
        return 0;
    60ee:	4501                	li	a0,0
    60f0:	7902                	ld	s2,32(sp)
    60f2:	6a42                	ld	s4,16(sp)
    60f4:	6aa2                	ld	s5,8(sp)
    60f6:	6b02                	ld	s6,0(sp)
    60f8:	a03d                	j	6126 <malloc+0xea>
    60fa:	7902                	ld	s2,32(sp)
    60fc:	6a42                	ld	s4,16(sp)
    60fe:	6aa2                	ld	s5,8(sp)
    6100:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    6102:	fae489e3          	beq	s1,a4,60b4 <malloc+0x78>
        p->s.size -= nunits;
    6106:	4137073b          	subw	a4,a4,s3
    610a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    610c:	02071693          	slli	a3,a4,0x20
    6110:	01c6d713          	srli	a4,a3,0x1c
    6114:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6116:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    611a:	00004717          	auipc	a4,0x4
    611e:	6aa73323          	sd	a0,1702(a4) # a7c0 <freep>
      return (void*)(p + 1);
    6122:	01078513          	addi	a0,a5,16
  }
}
    6126:	70e2                	ld	ra,56(sp)
    6128:	7442                	ld	s0,48(sp)
    612a:	74a2                	ld	s1,40(sp)
    612c:	69e2                	ld	s3,24(sp)
    612e:	6121                	addi	sp,sp,64
    6130:	8082                	ret
    6132:	7902                	ld	s2,32(sp)
    6134:	6a42                	ld	s4,16(sp)
    6136:	6aa2                	ld	s5,8(sp)
    6138:	6b02                	ld	s6,0(sp)
    613a:	b7f5                	j	6126 <malloc+0xea>

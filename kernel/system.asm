
kernel/system:     file format elf32-i386


Disassembly of section .text:

00100000 <_start>:

.globl _start

.text
_start:
	movw	$0x1234,0x472			# warm boot
  100000:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
  100007:	34 12 

	# Setup kernel stack
	movl $0, %ebp
  100009:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
  10000e:	bc 20 b3 10 00       	mov    $0x10b320,%esp

	call kernel_main
  100013:	e8 04 00 00 00       	call   10001c <kernel_main>

00100018 <die>:
die:
	jmp die
  100018:	eb fe                	jmp    100018 <die>
	...

0010001c <kernel_main>:
#include <kernel/trap.h>
#include <kernel/picirq.h>

extern void init_video(void);
void kernel_main(void)
{
  10001c:	83 ec 0c             	sub    $0xc,%esp
	init_video();
  10001f:	e8 53 04 00 00       	call   100477 <init_video>

	pic_init();
  100024:	e8 3f 00 00 00       	call   100068 <pic_init>
  /* TODO: You should uncomment them
   */
	 kbd_init();
  100029:	e8 08 02 00 00       	call   100236 <kbd_init>
	 timer_init();
  10002e:	e8 c4 09 00 00       	call   1009f7 <timer_init>
	 trap_init();
  100033:	e8 6b 06 00 00       	call   1006a3 <trap_init>

	/* Enable interrupt */
	__asm __volatile("sti");
  100038:	fb                   	sti    

	shell();
}
  100039:	83 c4 0c             	add    $0xc,%esp
	 trap_init();

	/* Enable interrupt */
	__asm __volatile("sti");

	shell();
  10003c:	e9 7a 08 00 00       	jmp    1008bb <shell>
  100041:	00 00                	add    %al,(%eax)
	...

00100044 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  100044:	8b 54 24 04          	mov    0x4(%esp),%edx
	int i;
	irq_mask_8259A = mask;
	if (!didinit)
  100048:	80 3d 20 b3 10 00 00 	cmpb   $0x0,0x10b320
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
  10004f:	89 d0                	mov    %edx,%eax
	int i;
	irq_mask_8259A = mask;
  100051:	66 89 15 00 30 10 00 	mov    %dx,0x103000
	if (!didinit)
  100058:	74 0d                	je     100067 <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  10005a:	ba 21 00 00 00       	mov    $0x21,%edx
  10005f:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
  100060:	66 c1 e8 08          	shr    $0x8,%ax
  100064:	b2 a1                	mov    $0xa1,%dl
  100066:	ee                   	out    %al,(%dx)
  100067:	c3                   	ret    

00100068 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
  100068:	57                   	push   %edi
  100069:	b9 21 00 00 00       	mov    $0x21,%ecx
  10006e:	56                   	push   %esi
  10006f:	b0 ff                	mov    $0xff,%al
  100071:	53                   	push   %ebx
  100072:	89 ca                	mov    %ecx,%edx
  100074:	ee                   	out    %al,(%dx)
  100075:	be a1 00 00 00       	mov    $0xa1,%esi
  10007a:	89 f2                	mov    %esi,%edx
  10007c:	ee                   	out    %al,(%dx)
  10007d:	bf 11 00 00 00       	mov    $0x11,%edi
  100082:	bb 20 00 00 00       	mov    $0x20,%ebx
  100087:	89 f8                	mov    %edi,%eax
  100089:	89 da                	mov    %ebx,%edx
  10008b:	ee                   	out    %al,(%dx)
  10008c:	b0 20                	mov    $0x20,%al
  10008e:	89 ca                	mov    %ecx,%edx
  100090:	ee                   	out    %al,(%dx)
  100091:	b0 04                	mov    $0x4,%al
  100093:	ee                   	out    %al,(%dx)
  100094:	b0 03                	mov    $0x3,%al
  100096:	ee                   	out    %al,(%dx)
  100097:	b1 a0                	mov    $0xa0,%cl
  100099:	89 f8                	mov    %edi,%eax
  10009b:	89 ca                	mov    %ecx,%edx
  10009d:	ee                   	out    %al,(%dx)
  10009e:	b0 28                	mov    $0x28,%al
  1000a0:	89 f2                	mov    %esi,%edx
  1000a2:	ee                   	out    %al,(%dx)
  1000a3:	b0 02                	mov    $0x2,%al
  1000a5:	ee                   	out    %al,(%dx)
  1000a6:	b0 01                	mov    $0x1,%al
  1000a8:	ee                   	out    %al,(%dx)
  1000a9:	bf 68 00 00 00       	mov    $0x68,%edi
  1000ae:	89 da                	mov    %ebx,%edx
  1000b0:	89 f8                	mov    %edi,%eax
  1000b2:	ee                   	out    %al,(%dx)
  1000b3:	be 0a 00 00 00       	mov    $0xa,%esi
  1000b8:	89 f0                	mov    %esi,%eax
  1000ba:	ee                   	out    %al,(%dx)
  1000bb:	89 f8                	mov    %edi,%eax
  1000bd:	89 ca                	mov    %ecx,%edx
  1000bf:	ee                   	out    %al,(%dx)
  1000c0:	89 f0                	mov    %esi,%eax
  1000c2:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000c3:	66 a1 00 30 10 00    	mov    0x103000,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
  1000c9:	c6 05 20 b3 10 00 01 	movb   $0x1,0x10b320
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
  1000d0:	66 83 f8 ff          	cmp    $0xffffffff,%ax
  1000d4:	74 0a                	je     1000e0 <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
  1000d6:	0f b7 c0             	movzwl %ax,%eax
  1000d9:	50                   	push   %eax
  1000da:	e8 65 ff ff ff       	call   100044 <irq_setmask_8259A>
  1000df:	58                   	pop    %eax
}
  1000e0:	5b                   	pop    %ebx
  1000e1:	5e                   	pop    %esi
  1000e2:	5f                   	pop    %edi
  1000e3:	c3                   	ret    

001000e4 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
  1000e4:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  1000e5:	ba 64 00 00 00       	mov    $0x64,%edx
  1000ea:	83 ec 08             	sub    $0x8,%esp
  1000ed:	ec                   	in     (%dx),%al
  1000ee:	88 c2                	mov    %al,%dl
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
  1000f0:	83 c8 ff             	or     $0xffffffff,%eax
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  1000f3:	80 e2 01             	and    $0x1,%dl
  1000f6:	0f 84 d2 00 00 00    	je     1001ce <kbd_proc_data+0xea>
  1000fc:	ba 60 00 00 00       	mov    $0x60,%edx
  100101:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
  100102:	3c e0                	cmp    $0xe0,%al
  100104:	88 c1                	mov    %al,%cl
  100106:	75 09                	jne    100111 <kbd_proc_data+0x2d>
		// E0 escape character
		shift |= E0ESC;
  100108:	83 0d 2c b5 10 00 40 	orl    $0x40,0x10b52c
  10010f:	eb 2d                	jmp    10013e <kbd_proc_data+0x5a>
		return 0;
	} else if (data & 0x80) {
  100111:	84 c0                	test   %al,%al
  100113:	8b 15 2c b5 10 00    	mov    0x10b52c,%edx
  100119:	79 2a                	jns    100145 <kbd_proc_data+0x61>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
  10011b:	88 c1                	mov    %al,%cl
  10011d:	83 e1 7f             	and    $0x7f,%ecx
  100120:	f6 c2 40             	test   $0x40,%dl
  100123:	0f 45 c8             	cmovne %eax,%ecx
		shift &= ~(shiftcode[data] | E0ESC);
  100126:	0f b6 c9             	movzbl %cl,%ecx
  100129:	8a 81 ec 17 10 00    	mov    0x1017ec(%ecx),%al
  10012f:	83 c8 40             	or     $0x40,%eax
  100132:	0f b6 c0             	movzbl %al,%eax
  100135:	f7 d0                	not    %eax
  100137:	21 d0                	and    %edx,%eax
  100139:	a3 2c b5 10 00       	mov    %eax,0x10b52c
		return 0;
  10013e:	31 c0                	xor    %eax,%eax
  100140:	e9 89 00 00 00       	jmp    1001ce <kbd_proc_data+0xea>
	} else if (shift & E0ESC) {
  100145:	f6 c2 40             	test   $0x40,%dl
  100148:	74 0c                	je     100156 <kbd_proc_data+0x72>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
  10014a:	83 e2 bf             	and    $0xffffffbf,%edx
		data = (shift & E0ESC ? data : data & 0x7F);
		shift &= ~(shiftcode[data] | E0ESC);
		return 0;
	} else if (shift & E0ESC) {
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
  10014d:	83 c9 80             	or     $0xffffff80,%ecx
		shift &= ~E0ESC;
  100150:	89 15 2c b5 10 00    	mov    %edx,0x10b52c
	}

	shift |= shiftcode[data];
  100156:	0f b6 c9             	movzbl %cl,%ecx
	shift ^= togglecode[data];
  100159:	0f b6 81 ec 18 10 00 	movzbl 0x1018ec(%ecx),%eax
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
  100160:	0f b6 91 ec 17 10 00 	movzbl 0x1017ec(%ecx),%edx
  100167:	0b 15 2c b5 10 00    	or     0x10b52c,%edx
	shift ^= togglecode[data];
  10016d:	31 c2                	xor    %eax,%edx

	c = charcode[shift & (CTL | SHIFT)][data];
  10016f:	89 d0                	mov    %edx,%eax
  100171:	83 e0 03             	and    $0x3,%eax
	if (shift & CAPSLOCK) {
  100174:	f6 c2 08             	test   $0x8,%dl
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];

	c = charcode[shift & (CTL | SHIFT)][data];
  100177:	8b 04 85 ec 19 10 00 	mov    0x1019ec(,%eax,4),%eax
		data |= 0x80;
		shift &= ~E0ESC;
	}

	shift |= shiftcode[data];
	shift ^= togglecode[data];
  10017e:	89 15 2c b5 10 00    	mov    %edx,0x10b52c

	c = charcode[shift & (CTL | SHIFT)][data];
  100184:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
	if (shift & CAPSLOCK) {
  100188:	74 19                	je     1001a3 <kbd_proc_data+0xbf>
		if ('a' <= c && c <= 'z')
  10018a:	8d 48 9f             	lea    -0x61(%eax),%ecx
  10018d:	83 f9 19             	cmp    $0x19,%ecx
  100190:	77 05                	ja     100197 <kbd_proc_data+0xb3>
			c += 'A' - 'a';
  100192:	83 e8 20             	sub    $0x20,%eax
  100195:	eb 0c                	jmp    1001a3 <kbd_proc_data+0xbf>
		else if ('A' <= c && c <= 'Z')
  100197:	8d 58 bf             	lea    -0x41(%eax),%ebx
			c += 'a' - 'A';
  10019a:	8d 48 20             	lea    0x20(%eax),%ecx
  10019d:	83 fb 19             	cmp    $0x19,%ebx
  1001a0:	0f 46 c1             	cmovbe %ecx,%eax
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1001a3:	3d e9 00 00 00       	cmp    $0xe9,%eax
  1001a8:	75 24                	jne    1001ce <kbd_proc_data+0xea>
  1001aa:	f7 d2                	not    %edx
  1001ac:	80 e2 06             	and    $0x6,%dl
  1001af:	75 1d                	jne    1001ce <kbd_proc_data+0xea>
		cprintf("Rebooting!\n");
  1001b1:	83 ec 0c             	sub    $0xc,%esp
  1001b4:	68 e0 17 10 00       	push   $0x1017e0
  1001b9:	e8 90 05 00 00       	call   10074e <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1001be:	ba 92 00 00 00       	mov    $0x92,%edx
  1001c3:	b0 03                	mov    $0x3,%al
  1001c5:	ee                   	out    %al,(%dx)
  1001c6:	b8 e9 00 00 00       	mov    $0xe9,%eax
  1001cb:	83 c4 10             	add    $0x10,%esp
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
  1001ce:	83 c4 08             	add    $0x8,%esp
  1001d1:	5b                   	pop    %ebx
  1001d2:	c3                   	ret    

001001d3 <cons_getc>:
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001d3:	8b 15 24 b5 10 00    	mov    0x10b524,%edx
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
	}
	return 0;
  1001d9:	31 c0                	xor    %eax,%eax
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	//kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
  1001db:	3b 15 28 b5 10 00    	cmp    0x10b528,%edx
  1001e1:	74 1b                	je     1001fe <cons_getc+0x2b>
		c = cons.buf[cons.rpos++];
  1001e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  1001e6:	0f b6 82 24 b3 10 00 	movzbl 0x10b324(%edx),%eax
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
  1001ed:	31 d2                	xor    %edx,%edx
  1001ef:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
  1001f5:	0f 45 d1             	cmovne %ecx,%edx
  1001f8:	89 15 24 b5 10 00    	mov    %edx,0x10b524
		return c;
	}
	return 0;
}
  1001fe:	c3                   	ret    

001001ff <kbd_intr>:
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  1001ff:	53                   	push   %ebx
	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  100200:	31 db                	xor    %ebx,%ebx
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(void)
{
  100202:	83 ec 08             	sub    $0x8,%esp
  100205:	eb 20                	jmp    100227 <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
  100207:	85 c0                	test   %eax,%eax
  100209:	74 1c                	je     100227 <kbd_intr+0x28>
			continue;
		cons.buf[cons.wpos++] = c;
  10020b:	8b 15 28 b5 10 00    	mov    0x10b528,%edx
  100211:	88 82 24 b3 10 00    	mov    %al,0x10b324(%edx)
  100217:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
  10021a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10021f:	0f 44 c3             	cmove  %ebx,%eax
  100222:	a3 28 b5 10 00       	mov    %eax,0x10b528
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
  100227:	e8 b8 fe ff ff       	call   1000e4 <kbd_proc_data>
  10022c:	83 f8 ff             	cmp    $0xffffffff,%eax
  10022f:	75 d6                	jne    100207 <kbd_intr+0x8>
 */
void
kbd_intr(void)
{
	cons_intr(kbd_proc_data);
}
  100231:	83 c4 08             	add    $0x8,%esp
  100234:	5b                   	pop    %ebx
  100235:	c3                   	ret    

00100236 <kbd_init>:

void kbd_init(void)
{
  100236:	83 ec 0c             	sub    $0xc,%esp
	// Drain the kbd buffer so that Bochs generates interrupts.
  cons.rpos = 0;
  100239:	c7 05 24 b5 10 00 00 	movl   $0x0,0x10b524
  100240:	00 00 00 
  cons.wpos = 0;
  100243:	c7 05 28 b5 10 00 00 	movl   $0x0,0x10b528
  10024a:	00 00 00 
	kbd_intr();
  10024d:	e8 ad ff ff ff       	call   1001ff <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
  100252:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  100259:	83 ec 0c             	sub    $0xc,%esp
  10025c:	25 fd ff 00 00       	and    $0xfffd,%eax
  100261:	50                   	push   %eax
  100262:	e8 dd fd ff ff       	call   100044 <irq_setmask_8259A>
}
  100267:	83 c4 1c             	add    $0x1c,%esp
  10026a:	c3                   	ret    

0010026b <getc>:
/* high-level console I/O */
int getc(void)
{
	int c;

	while ((c = cons_getc()) == 0)
  10026b:	e8 63 ff ff ff       	call   1001d3 <cons_getc>
  100270:	85 c0                	test   %eax,%eax
  100272:	74 f7                	je     10026b <getc>
		/* do nothing */;
	return c;
}
  100274:	c3                   	ret    
  100275:	00 00                	add    %al,(%eax)
	...

00100278 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
  100278:	56                   	push   %esi
  100279:	53                   	push   %ebx
  10027a:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  10027d:	8b 1d 34 b5 10 00    	mov    0x10b534,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  100283:	8b 35 04 33 10 00    	mov    0x103304,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
  100289:	83 fb 18             	cmp    $0x18,%ebx
  10028c:	7e 58                	jle    1002e6 <scroll+0x6e>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
  10028e:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  100291:	a1 40 c1 10 00       	mov    0x10c140,%eax
  100296:	0f b7 db             	movzwl %bx,%ebx
  100299:	52                   	push   %edx
  10029a:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
  1002a0:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002a3:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002a6:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
  1002ac:	52                   	push   %edx
  1002ad:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002b3:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
  1002b6:	8d 14 10             	lea    (%eax,%edx,1),%edx
  1002b9:	52                   	push   %edx
  1002ba:	50                   	push   %eax
  1002bb:	e8 19 11 00 00       	call   1013d9 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80);
  1002c0:	83 c4 0c             	add    $0xc,%esp
  1002c3:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
  1002ca:	03 05 40 c1 10 00    	add    0x10c140,%eax
  1002d0:	6a 50                	push   $0x50
  1002d2:	56                   	push   %esi
  1002d3:	50                   	push   %eax
  1002d4:	e8 26 10 00 00       	call   1012ff <memset>
        csr_y = 25 - 1;
  1002d9:	83 c4 10             	add    $0x10,%esp
  1002dc:	c7 05 34 b5 10 00 18 	movl   $0x18,0x10b534
  1002e3:	00 00 00 
    }
}
  1002e6:	83 c4 04             	add    $0x4,%esp
  1002e9:	5b                   	pop    %ebx
  1002ea:	5e                   	pop    %esi
  1002eb:	c3                   	ret    

001002ec <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
  1002ec:	66 6b 0d 34 b5 10 00 	imul   $0x50,0x10b534,%cx
  1002f3:	50 
  1002f4:	ba d4 03 00 00       	mov    $0x3d4,%edx
  1002f9:	03 0d 30 b5 10 00    	add    0x10b530,%ecx
  1002ff:	b0 0e                	mov    $0xe,%al
  100301:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
  100302:	89 c8                	mov    %ecx,%eax
  100304:	b2 d5                	mov    $0xd5,%dl
  100306:	66 c1 e8 08          	shr    $0x8,%ax
  10030a:	ee                   	out    %al,(%dx)
  10030b:	b0 0f                	mov    $0xf,%al
  10030d:	b2 d4                	mov    $0xd4,%dl
  10030f:	ee                   	out    %al,(%dx)
  100310:	b2 d5                	mov    $0xd5,%dl
  100312:	88 c8                	mov    %cl,%al
  100314:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
  100315:	c3                   	ret    

00100316 <cls>:

/* Clears the screen */
void cls()
{
  100316:	56                   	push   %esi
  100317:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  100318:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void cls()
{
  10031a:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
  10031d:	8b 35 04 33 10 00    	mov    0x103304,%esi
  100323:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80);
  100326:	0f b7 f6             	movzwl %si,%esi
  100329:	a1 40 c1 10 00       	mov    0x10c140,%eax
  10032e:	51                   	push   %ecx
  10032f:	6a 50                	push   $0x50
  100331:	56                   	push   %esi
  100332:	01 d8                	add    %ebx,%eax
  100334:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
  10033a:	50                   	push   %eax
  10033b:	e8 bf 0f 00 00       	call   1012ff <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
  100340:	83 c4 10             	add    $0x10,%esp
  100343:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
  100349:	75 de                	jne    100329 <cls+0x13>
        memset (textmemptr + i * 80, blank, 80);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
  10034b:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  100352:	00 00 00 
    csr_y = 0;
  100355:	c7 05 34 b5 10 00 00 	movl   $0x0,0x10b534
  10035c:	00 00 00 
    move_csr();
}
  10035f:	83 c4 04             	add    $0x4,%esp
  100362:	5b                   	pop    %ebx
  100363:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
  100364:	e9 83 ff ff ff       	jmp    1002ec <move_csr>

00100369 <putch>:
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100369:	53                   	push   %ebx
  10036a:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
  10036d:	8b 0d 04 33 10 00    	mov    0x103304,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void putch(unsigned char c)
{
  100373:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
  100377:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
  10037a:	3c 08                	cmp    $0x8,%al
  10037c:	75 21                	jne    10039f <putch+0x36>
    {
        if(csr_x != 0) {
  10037e:	a1 30 b5 10 00       	mov    0x10b530,%eax
  100383:	85 c0                	test   %eax,%eax
  100385:	74 7d                	je     100404 <putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
  100387:	6b 15 34 b5 10 00 50 	imul   $0x50,0x10b534,%edx
  10038e:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
  100392:	8b 15 40 c1 10 00    	mov    0x10c140,%edx
          csr_x--;
  100398:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
  100399:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
  10039d:	eb 0f                	jmp    1003ae <putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
  10039f:	3c 09                	cmp    $0x9,%al
  1003a1:	75 12                	jne    1003b5 <putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
  1003a3:	a1 30 b5 10 00       	mov    0x10b530,%eax
  1003a8:	83 c0 08             	add    $0x8,%eax
  1003ab:	83 e0 f8             	and    $0xfffffff8,%eax
  1003ae:	a3 30 b5 10 00       	mov    %eax,0x10b530
  1003b3:	eb 4f                	jmp    100404 <putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
  1003b5:	3c 0d                	cmp    $0xd,%al
  1003b7:	75 0c                	jne    1003c5 <putch+0x5c>
    {
        csr_x = 0;
  1003b9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003c0:	00 00 00 
  1003c3:	eb 3f                	jmp    100404 <putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
  1003c5:	3c 0a                	cmp    $0xa,%al
  1003c7:	75 12                	jne    1003db <putch+0x72>
    {
        csr_x = 0;
  1003c9:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  1003d0:	00 00 00 
        csr_y++;
  1003d3:	ff 05 34 b5 10 00    	incl   0x10b534
  1003d9:	eb 29                	jmp    100404 <putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
  1003db:	3c 1f                	cmp    $0x1f,%al
  1003dd:	76 25                	jbe    100404 <putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003df:	8b 15 30 b5 10 00    	mov    0x10b530,%edx
        *where = c | att;	/* Character AND attributes: color */
  1003e5:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003e8:	6b 1d 34 b5 10 00 50 	imul   $0x50,0x10b534,%ebx
        *where = c | att;	/* Character AND attributes: color */
  1003ef:	09 c8                	or     %ecx,%eax
  1003f1:	8b 0d 40 c1 10 00    	mov    0x10c140,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
  1003f7:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
  1003f9:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
  1003fa:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
  1003fe:	89 15 30 b5 10 00    	mov    %edx,0x10b530
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
  100404:	83 3d 30 b5 10 00 4f 	cmpl   $0x4f,0x10b530
  10040b:	7e 10                	jle    10041d <putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
  10040d:	ff 05 34 b5 10 00    	incl   0x10b534

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
  100413:	c7 05 30 b5 10 00 00 	movl   $0x0,0x10b530
  10041a:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
  10041d:	e8 56 fe ff ff       	call   100278 <scroll>
    move_csr();
}
  100422:	83 c4 08             	add    $0x8,%esp
  100425:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
  100426:	e9 c1 fe ff ff       	jmp    1002ec <move_csr>

0010042b <puts>:
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042b:	56                   	push   %esi
  10042c:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen(text); i++)
  10042d:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
  10042f:	83 ec 04             	sub    $0x4,%esp
  100432:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen(text); i++)
  100436:	eb 11                	jmp    100449 <puts+0x1e>
    {
        putch(text[i]);
  100438:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
  10043c:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  10043f:	43                   	inc    %ebx
    {
        putch(text[i]);
  100440:	50                   	push   %eax
  100441:	e8 23 ff ff ff       	call   100369 <putch>
/* Uses the above routine to output a string... */
void puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen(text); i++)
  100446:	83 c4 10             	add    $0x10,%esp
  100449:	83 ec 0c             	sub    $0xc,%esp
  10044c:	56                   	push   %esi
  10044d:	e8 de 0c 00 00       	call   101130 <strlen>
  100452:	83 c4 10             	add    $0x10,%esp
  100455:	39 c3                	cmp    %eax,%ebx
  100457:	7c df                	jl     100438 <puts+0xd>
    {
        putch(text[i]);
    }
}
  100459:	83 c4 04             	add    $0x4,%esp
  10045c:	5b                   	pop    %ebx
  10045d:	5e                   	pop    %esi
  10045e:	c3                   	ret    

0010045f <settextcolor>:
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    /* Lab3: Use this function */
    /* Top 4 bit are the background, bottom 4 bytes
    *  are the foreground color */
    attrib = (backcolor << 4) | (forecolor & 0x0F);
  10045f:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
  100464:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
  100469:	c1 e0 04             	shl    $0x4,%eax
  10046c:	83 e2 0f             	and    $0xf,%edx
  10046f:	09 d0                	or     %edx,%eax
  100471:	a3 04 33 10 00       	mov    %eax,0x103304
}
  100476:	c3                   	ret    

00100477 <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
  100477:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
  10047a:	c7 05 40 c1 10 00 00 	movl   $0xb8000,0x10c140
  100481:	80 0b 00 
    cls();
}
  100484:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    cls();
  100487:	e9 8a fe ff ff       	jmp    100316 <cls>

0010048c <print_regs>:
}

/* For debugging */
void
print_regs(struct PushRegs *regs)
{
  10048c:	53                   	push   %ebx
  10048d:	83 ec 10             	sub    $0x10,%esp
  100490:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
  100494:	ff 33                	pushl  (%ebx)
  100496:	68 fc 19 10 00       	push   $0x1019fc
  10049b:	e8 ae 02 00 00       	call   10074e <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
  1004a0:	58                   	pop    %eax
  1004a1:	5a                   	pop    %edx
  1004a2:	ff 73 04             	pushl  0x4(%ebx)
  1004a5:	68 0b 1a 10 00       	push   $0x101a0b
  1004aa:	e8 9f 02 00 00       	call   10074e <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  1004af:	5a                   	pop    %edx
  1004b0:	59                   	pop    %ecx
  1004b1:	ff 73 08             	pushl  0x8(%ebx)
  1004b4:	68 1a 1a 10 00       	push   $0x101a1a
  1004b9:	e8 90 02 00 00       	call   10074e <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  1004be:	59                   	pop    %ecx
  1004bf:	58                   	pop    %eax
  1004c0:	ff 73 0c             	pushl  0xc(%ebx)
  1004c3:	68 29 1a 10 00       	push   $0x101a29
  1004c8:	e8 81 02 00 00       	call   10074e <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  1004cd:	58                   	pop    %eax
  1004ce:	5a                   	pop    %edx
  1004cf:	ff 73 10             	pushl  0x10(%ebx)
  1004d2:	68 38 1a 10 00       	push   $0x101a38
  1004d7:	e8 72 02 00 00       	call   10074e <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
  1004dc:	5a                   	pop    %edx
  1004dd:	59                   	pop    %ecx
  1004de:	ff 73 14             	pushl  0x14(%ebx)
  1004e1:	68 47 1a 10 00       	push   $0x101a47
  1004e6:	e8 63 02 00 00       	call   10074e <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  1004eb:	59                   	pop    %ecx
  1004ec:	58                   	pop    %eax
  1004ed:	ff 73 18             	pushl  0x18(%ebx)
  1004f0:	68 56 1a 10 00       	push   $0x101a56
  1004f5:	e8 54 02 00 00       	call   10074e <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
  1004fa:	58                   	pop    %eax
  1004fb:	5a                   	pop    %edx
  1004fc:	ff 73 1c             	pushl  0x1c(%ebx)
  1004ff:	68 65 1a 10 00       	push   $0x101a65
  100504:	e8 45 02 00 00       	call   10074e <cprintf>
}
  100509:	83 c4 18             	add    $0x18,%esp
  10050c:	5b                   	pop    %ebx
  10050d:	c3                   	ret    

0010050e <print_trapframe>:
}

/* For debugging */
void
print_trapframe(struct Trapframe *tf)
{
  10050e:	56                   	push   %esi
  10050f:	53                   	push   %ebx
  100510:	83 ec 10             	sub    $0x10,%esp
  100513:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
	cprintf("TRAP frame at %p \n");
  100517:	68 c9 1a 10 00       	push   $0x101ac9
  10051c:	e8 2d 02 00 00       	call   10074e <cprintf>
	print_regs(&tf->tf_regs);
  100521:	89 1c 24             	mov    %ebx,(%esp)
  100524:	e8 63 ff ff ff       	call   10048c <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
  100529:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
  10052d:	5a                   	pop    %edx
  10052e:	59                   	pop    %ecx
  10052f:	50                   	push   %eax
  100530:	68 dc 1a 10 00       	push   $0x101adc
  100535:	e8 14 02 00 00       	call   10074e <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
  10053a:	5e                   	pop    %esi
  10053b:	58                   	pop    %eax
  10053c:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
  100540:	50                   	push   %eax
  100541:	68 ef 1a 10 00       	push   $0x101aef
  100546:	e8 03 02 00 00       	call   10074e <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10054b:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
  10054e:	83 c4 10             	add    $0x10,%esp
  100551:	83 f8 13             	cmp    $0x13,%eax
  100554:	77 09                	ja     10055f <print_trapframe+0x51>
		return excnames[trapno];
  100556:	8b 14 85 d8 1c 10 00 	mov    0x101cd8(,%eax,4),%edx
  10055d:	eb 1d                	jmp    10057c <print_trapframe+0x6e>
	if (trapno == T_SYSCALL)
  10055f:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
  100562:	ba 74 1a 10 00       	mov    $0x101a74,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
  100567:	74 13                	je     10057c <print_trapframe+0x6e>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
  100569:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
  10056c:	ba 80 1a 10 00       	mov    $0x101a80,%edx
  100571:	83 f9 0f             	cmp    $0xf,%ecx
  100574:	b9 93 1a 10 00       	mov    $0x101a93,%ecx
  100579:	0f 47 d1             	cmova  %ecx,%edx
{
	cprintf("TRAP frame at %p \n");
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10057c:	51                   	push   %ecx
  10057d:	52                   	push   %edx
  10057e:	50                   	push   %eax
  10057f:	68 02 1b 10 00       	push   $0x101b02
  100584:	e8 c5 01 00 00       	call   10074e <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
  100589:	83 c4 10             	add    $0x10,%esp
  10058c:	3b 1d 38 bd 10 00    	cmp    0x10bd38,%ebx
  100592:	75 19                	jne    1005ad <print_trapframe+0x9f>
  100594:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  100598:	75 13                	jne    1005ad <print_trapframe+0x9f>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
  10059a:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
  10059d:	52                   	push   %edx
  10059e:	52                   	push   %edx
  10059f:	50                   	push   %eax
  1005a0:	68 14 1b 10 00       	push   $0x101b14
  1005a5:	e8 a4 01 00 00       	call   10074e <cprintf>
  1005aa:	83 c4 10             	add    $0x10,%esp
	cprintf("  err  0x%08x", tf->tf_err);
  1005ad:	56                   	push   %esi
  1005ae:	56                   	push   %esi
  1005af:	ff 73 2c             	pushl  0x2c(%ebx)
  1005b2:	68 23 1b 10 00       	push   $0x101b23
  1005b7:	e8 92 01 00 00       	call   10074e <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
  1005bc:	83 c4 10             	add    $0x10,%esp
  1005bf:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
  1005c3:	75 43                	jne    100608 <print_trapframe+0xfa>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
  1005c5:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
  1005c8:	b8 ad 1a 10 00       	mov    $0x101aad,%eax
  1005cd:	b9 a2 1a 10 00       	mov    $0x101aa2,%ecx
  1005d2:	ba b9 1a 10 00       	mov    $0x101ab9,%edx
  1005d7:	f7 c6 01 00 00 00    	test   $0x1,%esi
  1005dd:	0f 44 c8             	cmove  %eax,%ecx
  1005e0:	f7 c6 02 00 00 00    	test   $0x2,%esi
  1005e6:	b8 bf 1a 10 00       	mov    $0x101abf,%eax
  1005eb:	0f 44 d0             	cmove  %eax,%edx
  1005ee:	83 e6 04             	and    $0x4,%esi
  1005f1:	51                   	push   %ecx
  1005f2:	b8 c4 1a 10 00       	mov    $0x101ac4,%eax
  1005f7:	be f1 1d 10 00       	mov    $0x101df1,%esi
  1005fc:	52                   	push   %edx
  1005fd:	0f 44 c6             	cmove  %esi,%eax
  100600:	50                   	push   %eax
  100601:	68 31 1b 10 00       	push   $0x101b31
  100606:	eb 08                	jmp    100610 <print_trapframe+0x102>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
  100608:	83 ec 0c             	sub    $0xc,%esp
  10060b:	68 da 1a 10 00       	push   $0x101ada
  100610:	e8 39 01 00 00       	call   10074e <cprintf>
  100615:	5a                   	pop    %edx
  100616:	59                   	pop    %ecx
	cprintf("  eip  0x%08x\n", tf->tf_eip);
  100617:	ff 73 30             	pushl  0x30(%ebx)
  10061a:	68 40 1b 10 00       	push   $0x101b40
  10061f:	e8 2a 01 00 00       	call   10074e <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
  100624:	5e                   	pop    %esi
  100625:	58                   	pop    %eax
  100626:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
  10062a:	50                   	push   %eax
  10062b:	68 4f 1b 10 00       	push   $0x101b4f
  100630:	e8 19 01 00 00       	call   10074e <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
  100635:	5a                   	pop    %edx
  100636:	59                   	pop    %ecx
  100637:	ff 73 38             	pushl  0x38(%ebx)
  10063a:	68 62 1b 10 00       	push   $0x101b62
  10063f:	e8 0a 01 00 00       	call   10074e <cprintf>
	if ((tf->tf_cs & 3) != 0) {
  100644:	83 c4 10             	add    $0x10,%esp
  100647:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
  10064b:	74 23                	je     100670 <print_trapframe+0x162>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
  10064d:	50                   	push   %eax
  10064e:	50                   	push   %eax
  10064f:	ff 73 3c             	pushl  0x3c(%ebx)
  100652:	68 71 1b 10 00       	push   $0x101b71
  100657:	e8 f2 00 00 00       	call   10074e <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
  10065c:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
  100660:	59                   	pop    %ecx
  100661:	5e                   	pop    %esi
  100662:	50                   	push   %eax
  100663:	68 80 1b 10 00       	push   $0x101b80
  100668:	e8 e1 00 00 00       	call   10074e <cprintf>
  10066d:	83 c4 10             	add    $0x10,%esp
	}
}
  100670:	83 c4 04             	add    $0x4,%esp
  100673:	5b                   	pop    %ebx
  100674:	5e                   	pop    %esi
  100675:	c3                   	ret    

00100676 <default_trap_handler>:

/* 
 * Note: This is the called for every interrupt.
 */
void default_trap_handler(struct Trapframe *tf)
{
  100676:	53                   	push   %ebx
  100677:	83 ec 08             	sub    $0x8,%esp
  10067a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	}*/

	extern void timer_handler();
	extern void kbd_intr();

	if(tf->tf_trapno == IRQ_OFFSET+IRQ_TIMER){
  10067e:	83 7b 28 20          	cmpl   $0x20,0x28(%ebx)
 */
void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
  100682:	89 1d 38 bd 10 00    	mov    %ebx,0x10bd38
	}*/

	extern void timer_handler();
	extern void kbd_intr();

	if(tf->tf_trapno == IRQ_OFFSET+IRQ_TIMER){
  100688:	75 05                	jne    10068f <default_trap_handler+0x19>
		timer_handler();
  10068a:	e8 5b 03 00 00       	call   1009ea <timer_handler>
	}

	if(tf->tf_trapno == IRQ_OFFSET+IRQ_KBD){
  10068f:	83 7b 28 21          	cmpl   $0x21,0x28(%ebx)
  100693:	75 09                	jne    10069e <default_trap_handler+0x28>
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
  100695:	83 c4 08             	add    $0x8,%esp
  100698:	5b                   	pop    %ebx
	if(tf->tf_trapno == IRQ_OFFSET+IRQ_TIMER){
		timer_handler();
	}

	if(tf->tf_trapno == IRQ_OFFSET+IRQ_KBD){
		kbd_intr();
  100699:	e9 61 fb ff ff       	jmp    1001ff <kbd_intr>
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
  10069e:	83 c4 08             	add    $0x8,%esp
  1006a1:	5b                   	pop    %ebx
  1006a2:	c3                   	ret    

001006a3 <trap_init>:
	/* Timer Trap setup */
  /* Load IDT */
	extern void irq_timer();
	extern void irq_kbd();

	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER],0, GD_KT, irq_timer ,0);
  1006a3:	b8 04 07 10 00       	mov    $0x100704,%eax
  1006a8:	66 a3 38 b6 10 00    	mov    %ax,0x10b638
  1006ae:	c1 e8 10             	shr    $0x10,%eax
  1006b1:	66 a3 3e b6 10 00    	mov    %ax,0x10b63e
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD], 0, GD_KT, irq_kbd,0 );
  1006b7:	b8 0a 07 10 00       	mov    $0x10070a,%eax
  1006bc:	66 a3 40 b6 10 00    	mov    %ax,0x10b640
  1006c2:	c1 e8 10             	shr    $0x10,%eax
  1006c5:	66 a3 46 b6 10 00    	mov    %ax,0x10b646
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
  1006cb:	b8 08 33 10 00       	mov    $0x103308,%eax
	/* Timer Trap setup */
  /* Load IDT */
	extern void irq_timer();
	extern void irq_kbd();

	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER],0, GD_KT, irq_timer ,0);
  1006d0:	66 c7 05 3a b6 10 00 	movw   $0x8,0x10b63a
  1006d7:	08 00 
  1006d9:	c6 05 3c b6 10 00 00 	movb   $0x0,0x10b63c
  1006e0:	c6 05 3d b6 10 00 8e 	movb   $0x8e,0x10b63d
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD], 0, GD_KT, irq_kbd,0 );
  1006e7:	66 c7 05 42 b6 10 00 	movw   $0x8,0x10b642
  1006ee:	08 00 
  1006f0:	c6 05 44 b6 10 00 00 	movb   $0x0,0x10b644
  1006f7:	c6 05 45 b6 10 00 8e 	movb   $0x8e,0x10b645
  1006fe:	0f 01 18             	lidtl  (%eax)

//	idt_pd.pd_lim = sizeof(idt)-1;
//	idt_pd.pd_base = (uint32_t)idt;

	lidt(&idt_pd);
}
  100701:	c3                   	ret    
	...

00100704 <irq_timer>:
 *       The Trap number are declared in inc/trap.h which might come in handy
 *       when declaring interface for ISRs.
 */

#TRAPHANDLER_NOEC(Default_ISR, T_DEFAULT);
TRAPHANDLER_NOEC(irq_timer, IRQ_OFFSET+IRQ_TIMER);
  100704:	6a 00                	push   $0x0
  100706:	6a 20                	push   $0x20
  100708:	eb 06                	jmp    100710 <_alltraps>

0010070a <irq_kbd>:
TRAPHANDLER_NOEC(irq_kbd, IRQ_OFFSET+IRQ_KBD);
  10070a:	6a 00                	push   $0x0
  10070c:	6a 21                	push   $0x21
  10070e:	eb 00                	jmp    100710 <_alltraps>

00100710 <_alltraps>:
   *       CPU.
   *       You may want to leverage the "pusha" instructions to reduce your work of
   *       pushing all the general purpose registers into the stack.
	 */

	pushl %ds
  100710:	1e                   	push   %ds
	pushl %es
  100711:	06                   	push   %es
	pushal		# EAX EBX ECX EDX ESP EBP ESI EDI
  100712:	60                   	pusha  
	
	pushl %esp # Pass a pointer which points to the Trapframe as an argument to default_trap_handler()
  100713:	54                   	push   %esp
	call default_trap_handler
  100714:	e8 5d ff ff ff       	call   100676 <default_trap_handler>
	popl %esp
  100719:	5c                   	pop    %esp

	popal
  10071a:	61                   	popa   
	popl %es
  10071b:	07                   	pop    %es
	popl %ds
  10071c:	1f                   	pop    %ds

	add $8, %esp # Cleans up the pushed error code and pushed ISR number
  10071d:	83 c4 08             	add    $0x8,%esp
	iret # pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP!
  100720:	cf                   	iret   
  100721:	00 00                	add    %al,(%eax)
	...

00100724 <vcprintf>:
#include <inc/stdio.h>


int
vcprintf(const char *fmt, va_list ap)
{
  100724:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
  100727:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10072e:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
  10072f:	ff 74 24 24          	pushl  0x24(%esp)
  100733:	ff 74 24 24          	pushl  0x24(%esp)
  100737:	8d 44 24 14          	lea    0x14(%esp),%eax
  10073b:	50                   	push   %eax
  10073c:	68 69 03 10 00       	push   $0x100369
  100741:	e8 49 04 00 00       	call   100b8f <vprintfmt>
	return cnt;
}
  100746:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  10074a:	83 c4 2c             	add    $0x2c,%esp
  10074d:	c3                   	ret    

0010074e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  10074e:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  100751:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vcprintf(fmt, ap);
  100755:	52                   	push   %edx
  100756:	52                   	push   %edx
  100757:	50                   	push   %eax
  100758:	ff 74 24 1c          	pushl  0x1c(%esp)
  10075c:	e8 c3 ff ff ff       	call   100724 <vcprintf>
	va_end(ap);

	return cnt;
}
  100761:	83 c4 1c             	add    $0x1c,%esp
  100764:	c3                   	ret    
  100765:	00 00                	add    %al,(%eax)
	...

00100768 <mon_kerninfo>:
   *       provide you with those information.
   *       Use PROVIDE inside linker script and calculate the
   *       offset.
   */

   cprintf("Kernel code base start = 0x%x, size = %d\n", &code_start, &etext-&code_start);
  100768:	b8 c5 17 10 00       	mov    $0x1017c5,%eax
extern uint32_t etext;
extern uint32_t data_start;
extern uint32_t end;

int mon_kerninfo(int argc, char **argv)
{
  10076d:	53                   	push   %ebx
   *       provide you with those information.
   *       Use PROVIDE inside linker script and calculate the
   *       offset.
   */

   cprintf("Kernel code base start = 0x%x, size = %d\n", &code_start, &etext-&code_start);
  10076e:	2d 00 00 10 00       	sub    $0x100000,%eax
extern uint32_t etext;
extern uint32_t data_start;
extern uint32_t end;

int mon_kerninfo(int argc, char **argv)
{
  100773:	83 ec 0c             	sub    $0xc,%esp
   *       Use PROVIDE inside linker script and calculate the
   *       offset.
   */

   cprintf("Kernel code base start = 0x%x, size = %d\n", &code_start, &etext-&code_start);
   cprintf("Kernel data base start = 0x%x, size = %d\n", &data_start, &end-&data_start);
  100776:	bb 44 c1 10 00       	mov    $0x10c144,%ebx
   *       provide you with those information.
   *       Use PROVIDE inside linker script and calculate the
   *       offset.
   */

   cprintf("Kernel code base start = 0x%x, size = %d\n", &code_start, &etext-&code_start);
  10077b:	c1 f8 02             	sar    $0x2,%eax
  10077e:	50                   	push   %eax
  10077f:	68 00 00 10 00       	push   $0x100000
  100784:	68 28 1d 10 00       	push   $0x101d28
  100789:	e8 c0 ff ff ff       	call   10074e <cprintf>
   cprintf("Kernel data base start = 0x%x, size = %d\n", &data_start, &end-&data_start);
  10078e:	89 d8                	mov    %ebx,%eax
  100790:	83 c4 0c             	add    $0xc,%esp
  100793:	2d 00 30 10 00       	sub    $0x103000,%eax
  100798:	c1 f8 02             	sar    $0x2,%eax
  10079b:	50                   	push   %eax
  10079c:	68 00 30 10 00       	push   $0x103000
  1007a1:	68 52 1d 10 00       	push   $0x101d52
  1007a6:	e8 a3 ff ff ff       	call   10074e <cprintf>
   cprintf("Kernel executable memory footprint = %dKB\n", (&end-&code_start)/1024);
  1007ab:	b9 00 04 00 00       	mov    $0x400,%ecx
  1007b0:	58                   	pop    %eax
  1007b1:	89 d8                	mov    %ebx,%eax
  1007b3:	2d 00 00 10 00       	sub    $0x100000,%eax
  1007b8:	c1 f8 02             	sar    $0x2,%eax
  1007bb:	5a                   	pop    %edx
  1007bc:	99                   	cltd   
  1007bd:	f7 f9                	idiv   %ecx
  1007bf:	50                   	push   %eax
  1007c0:	68 7c 1d 10 00       	push   $0x101d7c
  1007c5:	e8 84 ff ff ff       	call   10074e <cprintf>

	return 0;
}
  1007ca:	31 c0                	xor    %eax,%eax
  1007cc:	83 c4 18             	add    $0x18,%esp
  1007cf:	5b                   	pop    %ebx
  1007d0:	c3                   	ret    

001007d1 <mon_help>:
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))


int mon_help(int argc, char **argv)
{
  1007d1:	83 ec 10             	sub    $0x10,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  1007d4:	68 a7 1d 10 00       	push   $0x101da7
  1007d9:	68 c5 1d 10 00       	push   $0x101dc5
  1007de:	68 ca 1d 10 00       	push   $0x101dca
  1007e3:	e8 66 ff ff ff       	call   10074e <cprintf>
  1007e8:	83 c4 0c             	add    $0xc,%esp
  1007eb:	68 d3 1d 10 00       	push   $0x101dd3
  1007f0:	68 f8 1d 10 00       	push   $0x101df8
  1007f5:	68 ca 1d 10 00       	push   $0x101dca
  1007fa:	e8 4f ff ff ff       	call   10074e <cprintf>
  1007ff:	83 c4 0c             	add    $0xc,%esp
  100802:	68 01 1e 10 00       	push   $0x101e01
  100807:	68 15 1e 10 00       	push   $0x101e15
  10080c:	68 ca 1d 10 00       	push   $0x101dca
  100811:	e8 38 ff ff ff       	call   10074e <cprintf>
  100816:	83 c4 0c             	add    $0xc,%esp
  100819:	68 20 1e 10 00       	push   $0x101e20
  10081e:	68 31 1e 10 00       	push   $0x101e31
  100823:	68 ca 1d 10 00       	push   $0x101dca
  100828:	e8 21 ff ff ff       	call   10074e <cprintf>
	return 0;
}
  10082d:	31 c0                	xor    %eax,%eax
  10082f:	83 c4 1c             	add    $0x1c,%esp
  100832:	c3                   	ret    

00100833 <chgcolor>:
	cprintf("Now tick = %d\n", get_tick());
}

extern void settextcolor();

int chgcolor(int argc, char **argv){
  100833:	53                   	push   %ebx
  100834:	83 ec 08             	sub    $0x8,%esp
	if(argc < 2){
  100837:	83 7c 24 10 01       	cmpl   $0x1,0x10(%esp)
  10083c:	7f 0a                	jg     100848 <chgcolor+0x15>
		cprintf("No input text color!\n");
  10083e:	83 ec 0c             	sub    $0xc,%esp
  100841:	68 3a 1e 10 00       	push   $0x101e3a
  100846:	eb 4b                	jmp    100893 <chgcolor+0x60>
	}
	else{
		int forecolor;
		if(argv[1][0]>=48 && argv[1][0]<=58) forecolor = argv[1][0] - 48;
  100848:	8b 44 24 14          	mov    0x14(%esp),%eax
  10084c:	8b 40 04             	mov    0x4(%eax),%eax
  10084f:	8a 00                	mov    (%eax),%al
  100851:	8d 50 d0             	lea    -0x30(%eax),%edx
  100854:	80 fa 0a             	cmp    $0xa,%dl
  100857:	77 08                	ja     100861 <chgcolor+0x2e>
  100859:	0f be c0             	movsbl %al,%eax
  10085c:	8d 58 d0             	lea    -0x30(%eax),%ebx
  10085f:	eb 20                	jmp    100881 <chgcolor+0x4e>
		else if(argv[1][0]>=65 && argv[1][0]<=70) forecolor = argv[1][0] - 55;
  100861:	8d 50 bf             	lea    -0x41(%eax),%edx
  100864:	80 fa 05             	cmp    $0x5,%dl
  100867:	77 08                	ja     100871 <chgcolor+0x3e>
  100869:	0f be c0             	movsbl %al,%eax
  10086c:	8d 58 c9             	lea    -0x37(%eax),%ebx
  10086f:	eb 10                	jmp    100881 <chgcolor+0x4e>
		else if(argv[1][0]>=97 && argv[1][0]<=102) forecolor = argv[1][0] - 87;
  100871:	8d 50 9f             	lea    -0x61(%eax),%edx
		else forecolor = 0;
  100874:	31 db                	xor    %ebx,%ebx
	}
	else{
		int forecolor;
		if(argv[1][0]>=48 && argv[1][0]<=58) forecolor = argv[1][0] - 48;
		else if(argv[1][0]>=65 && argv[1][0]<=70) forecolor = argv[1][0] - 55;
		else if(argv[1][0]>=97 && argv[1][0]<=102) forecolor = argv[1][0] - 87;
  100876:	80 fa 05             	cmp    $0x5,%dl
  100879:	77 06                	ja     100881 <chgcolor+0x4e>
  10087b:	0f be c0             	movsbl %al,%eax
  10087e:	8d 58 a9             	lea    -0x57(%eax),%ebx
		else forecolor = 0;

		settextcolor(forecolor,0);
  100881:	52                   	push   %edx
  100882:	52                   	push   %edx
  100883:	6a 00                	push   $0x0
  100885:	53                   	push   %ebx
  100886:	e8 d4 fb ff ff       	call   10045f <settextcolor>
		cprintf("Change color %d\n",forecolor);
  10088b:	59                   	pop    %ecx
  10088c:	58                   	pop    %eax
  10088d:	53                   	push   %ebx
  10088e:	68 50 1e 10 00       	push   $0x101e50
  100893:	e8 b6 fe ff ff       	call   10074e <cprintf>
	}
	return 0;
}
  100898:	31 c0                	xor    %eax,%eax
  10089a:	83 c4 18             	add    $0x18,%esp
  10089d:	5b                   	pop    %ebx
  10089e:	c3                   	ret    

0010089f <print_tick>:
   cprintf("Kernel executable memory footprint = %dKB\n", (&end-&code_start)/1024);

	return 0;
}
int print_tick(int argc, char **argv)
{
  10089f:	83 ec 0c             	sub    $0xc,%esp
	cprintf("Now tick = %d\n", get_tick());
  1008a2:	e8 4a 01 00 00       	call   1009f1 <get_tick>
  1008a7:	c7 44 24 10 61 1e 10 	movl   $0x101e61,0x10(%esp)
  1008ae:	00 
  1008af:	89 44 24 14          	mov    %eax,0x14(%esp)
}
  1008b3:	83 c4 0c             	add    $0xc,%esp

	return 0;
}
int print_tick(int argc, char **argv)
{
	cprintf("Now tick = %d\n", get_tick());
  1008b6:	e9 93 fe ff ff       	jmp    10074e <cprintf>

001008bb <shell>:
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}
void shell()
{
  1008bb:	55                   	push   %ebp
  1008bc:	57                   	push   %edi
  1008bd:	56                   	push   %esi
  1008be:	53                   	push   %ebx
  1008bf:	83 ec 58             	sub    $0x58,%esp
	char *buf;
	cprintf("Welcome to the OSDI course!\n");
  1008c2:	68 70 1e 10 00       	push   $0x101e70
  1008c7:	e8 82 fe ff ff       	call   10074e <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
  1008cc:	c7 04 24 8d 1e 10 00 	movl   $0x101e8d,(%esp)
  1008d3:	e8 76 fe ff ff       	call   10074e <cprintf>
  1008d8:	83 c4 10             	add    $0x10,%esp
	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
  1008db:	89 e5                	mov    %esp,%ebp
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008dd:	83 ec 0c             	sub    $0xc,%esp
  1008e0:	68 b2 1e 10 00       	push   $0x101eb2
  1008e5:	e8 96 07 00 00       	call   101080 <readline>
		if (buf != NULL)
  1008ea:	83 c4 10             	add    $0x10,%esp
  1008ed:	85 c0                	test   %eax,%eax
	cprintf("Welcome to the OSDI course!\n");
	cprintf("Type 'help' for a list of commands.\n");

	while(1)
	{
		buf = readline("OSDI> ");
  1008ef:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
  1008f1:	74 ea                	je     1008dd <shell+0x22>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
  1008f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
  1008fa:	31 f6                	xor    %esi,%esi
  1008fc:	eb 04                	jmp    100902 <shell+0x47>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
  1008fe:	c6 03 00             	movb   $0x0,(%ebx)
  100901:	43                   	inc    %ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
  100902:	8a 03                	mov    (%ebx),%al
  100904:	84 c0                	test   %al,%al
  100906:	74 17                	je     10091f <shell+0x64>
  100908:	57                   	push   %edi
  100909:	0f be c0             	movsbl %al,%eax
  10090c:	57                   	push   %edi
  10090d:	50                   	push   %eax
  10090e:	68 b9 1e 10 00       	push   $0x101eb9
  100913:	e8 89 09 00 00       	call   1012a1 <strchr>
  100918:	83 c4 10             	add    $0x10,%esp
  10091b:	85 c0                	test   %eax,%eax
  10091d:	75 df                	jne    1008fe <shell+0x43>
			*buf++ = 0;
		if (*buf == 0)
  10091f:	80 3b 00             	cmpb   $0x0,(%ebx)
  100922:	74 36                	je     10095a <shell+0x9f>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
  100924:	83 fe 0f             	cmp    $0xf,%esi
  100927:	75 0b                	jne    100934 <shell+0x79>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
  100929:	51                   	push   %ecx
  10092a:	51                   	push   %ecx
  10092b:	6a 10                	push   $0x10
  10092d:	68 be 1e 10 00       	push   $0x101ebe
  100932:	eb 7d                	jmp    1009b1 <shell+0xf6>
			return 0;
		}
		argv[argc++] = buf;
  100934:	89 1c b4             	mov    %ebx,(%esp,%esi,4)
  100937:	46                   	inc    %esi
  100938:	eb 01                	jmp    10093b <shell+0x80>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
  10093a:	43                   	inc    %ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
  10093b:	8a 03                	mov    (%ebx),%al
  10093d:	84 c0                	test   %al,%al
  10093f:	74 c1                	je     100902 <shell+0x47>
  100941:	52                   	push   %edx
  100942:	0f be c0             	movsbl %al,%eax
  100945:	52                   	push   %edx
  100946:	50                   	push   %eax
  100947:	68 b9 1e 10 00       	push   $0x101eb9
  10094c:	e8 50 09 00 00       	call   1012a1 <strchr>
  100951:	83 c4 10             	add    $0x10,%esp
  100954:	85 c0                	test   %eax,%eax
  100956:	74 e2                	je     10093a <shell+0x7f>
  100958:	eb a8                	jmp    100902 <shell+0x47>
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
  10095a:	85 f6                	test   %esi,%esi
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;
  10095c:	c7 04 b4 00 00 00 00 	movl   $0x0,(%esp,%esi,4)

	// Lookup and invoke the command
	if (argc == 0)
  100963:	0f 84 74 ff ff ff    	je     1008dd <shell+0x22>
  100969:	bf f4 1e 10 00       	mov    $0x101ef4,%edi
  10096e:	31 db                	xor    %ebx,%ebx
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
  100970:	50                   	push   %eax
  100971:	50                   	push   %eax
  100972:	ff 37                	pushl  (%edi)
  100974:	83 c7 0c             	add    $0xc,%edi
  100977:	ff 74 24 0c          	pushl  0xc(%esp)
  10097b:	e8 aa 08 00 00       	call   10122a <strcmp>
  100980:	83 c4 10             	add    $0x10,%esp
  100983:	85 c0                	test   %eax,%eax
  100985:	75 19                	jne    1009a0 <shell+0xe5>
			return commands[i].func(argc, argv);
  100987:	6b db 0c             	imul   $0xc,%ebx,%ebx
  10098a:	57                   	push   %edi
  10098b:	57                   	push   %edi
  10098c:	55                   	push   %ebp
  10098d:	56                   	push   %esi
  10098e:	ff 93 fc 1e 10 00    	call   *0x101efc(%ebx)
	while(1)
	{
		buf = readline("OSDI> ");
		if (buf != NULL)
		{
			if (runcmd(buf) < 0)
  100994:	83 c4 10             	add    $0x10,%esp
  100997:	85 c0                	test   %eax,%eax
  100999:	78 23                	js     1009be <shell+0x103>
  10099b:	e9 3d ff ff ff       	jmp    1008dd <shell+0x22>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
  1009a0:	43                   	inc    %ebx
  1009a1:	83 fb 04             	cmp    $0x4,%ebx
  1009a4:	75 ca                	jne    100970 <shell+0xb5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
  1009a6:	51                   	push   %ecx
  1009a7:	51                   	push   %ecx
  1009a8:	ff 74 24 08          	pushl  0x8(%esp)
  1009ac:	68 db 1e 10 00       	push   $0x101edb
  1009b1:	e8 98 fd ff ff       	call   10074e <cprintf>
  1009b6:	83 c4 10             	add    $0x10,%esp
  1009b9:	e9 1f ff ff ff       	jmp    1008dd <shell+0x22>
		{
			if (runcmd(buf) < 0)
				break;
		}
	}
}
  1009be:	83 c4 4c             	add    $0x4c,%esp
  1009c1:	5b                   	pop    %ebx
  1009c2:	5e                   	pop    %esi
  1009c3:	5f                   	pop    %edi
  1009c4:	5d                   	pop    %ebp
  1009c5:	c3                   	ret    
	...

001009c8 <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
  1009c8:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
  1009cd:	89 c8                	mov    %ecx,%eax
  1009cf:	99                   	cltd   
  1009d0:	f7 7c 24 04          	idivl  0x4(%esp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  1009d4:	ba 43 00 00 00       	mov    $0x43,%edx
  1009d9:	89 c1                	mov    %eax,%ecx
  1009db:	b0 36                	mov    $0x36,%al
  1009dd:	ee                   	out    %al,(%dx)
  1009de:	b2 40                	mov    $0x40,%dl
  1009e0:	88 c8                	mov    %cl,%al
  1009e2:	ee                   	out    %al,(%dx)
    outb(0x43, 0x36);             /* Set our command byte 0x36 */
    outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    outb(0x40, divisor >> 8);     /* Set high byte of divisor */
  1009e3:	89 c8                	mov    %ecx,%eax
  1009e5:	c1 f8 08             	sar    $0x8,%eax
  1009e8:	ee                   	out    %al,(%dx)
}
  1009e9:	c3                   	ret    

001009ea <timer_handler>:
/* 
 * Timer interrupt handler
 */
void timer_handler()
{
	jiffies++;
  1009ea:	ff 05 3c bd 10 00    	incl   0x10bd3c
}
  1009f0:	c3                   	ret    

001009f1 <get_tick>:

unsigned long get_tick()
{
	return jiffies;
}
  1009f1:	a1 3c bd 10 00       	mov    0x10bd3c,%eax
  1009f6:	c3                   	ret    

001009f7 <timer_init>:
void timer_init()
{
  1009f7:	83 ec 0c             	sub    $0xc,%esp
	set_timer(TIME_HZ);
  1009fa:	6a 64                	push   $0x64
  1009fc:	e8 c7 ff ff ff       	call   1009c8 <set_timer>

	/* Enable interrupt */
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
  100a01:	50                   	push   %eax
  100a02:	50                   	push   %eax
  100a03:	0f b7 05 00 30 10 00 	movzwl 0x103000,%eax
  100a0a:	25 fe ff 00 00       	and    $0xfffe,%eax
  100a0f:	50                   	push   %eax
  100a10:	e8 2f f6 ff ff       	call   100044 <irq_setmask_8259A>
}
  100a15:	83 c4 1c             	add    $0x1c,%esp
  100a18:	c3                   	ret    
  100a19:	00 00                	add    %al,(%eax)
  100a1b:	00 00                	add    %al,(%eax)
  100a1d:	00 00                	add    %al,(%eax)
	...

00100a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  100a20:	55                   	push   %ebp
  100a21:	57                   	push   %edi
  100a22:	56                   	push   %esi
  100a23:	53                   	push   %ebx
  100a24:	83 ec 3c             	sub    $0x3c,%esp
  100a27:	89 c5                	mov    %eax,%ebp
  100a29:	89 d6                	mov    %edx,%esi
  100a2b:	8b 44 24 50          	mov    0x50(%esp),%eax
  100a2f:	89 44 24 24          	mov    %eax,0x24(%esp)
  100a33:	8b 54 24 54          	mov    0x54(%esp),%edx
  100a37:	89 54 24 20          	mov    %edx,0x20(%esp)
  100a3b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
  100a3f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  100a43:	b8 00 00 00 00       	mov    $0x0,%eax
  100a48:	39 d0                	cmp    %edx,%eax
  100a4a:	72 13                	jb     100a5f <printnum+0x3f>
  100a4c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  100a50:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
  100a54:	76 09                	jbe    100a5f <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100a56:	83 eb 01             	sub    $0x1,%ebx
  100a59:	85 db                	test   %ebx,%ebx
  100a5b:	7f 63                	jg     100ac0 <printnum+0xa0>
  100a5d:	eb 71                	jmp    100ad0 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  100a5f:	89 7c 24 10          	mov    %edi,0x10(%esp)
  100a63:	83 eb 01             	sub    $0x1,%ebx
  100a66:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100a6a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
  100a6e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  100a72:	8b 44 24 08          	mov    0x8(%esp),%eax
  100a76:	8b 54 24 0c          	mov    0xc(%esp),%edx
  100a7a:	89 44 24 28          	mov    %eax,0x28(%esp)
  100a7e:	89 54 24 2c          	mov    %edx,0x2c(%esp)
  100a82:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100a89:	00 
  100a8a:	8b 54 24 24          	mov    0x24(%esp),%edx
  100a8e:	89 14 24             	mov    %edx,(%esp)
  100a91:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  100a95:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100a99:	e8 d2 0a 00 00       	call   101570 <__udivdi3>
  100a9e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
  100aa2:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
  100aa6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100aaa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  100aae:	89 04 24             	mov    %eax,(%esp)
  100ab1:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ab5:	89 f2                	mov    %esi,%edx
  100ab7:	89 e8                	mov    %ebp,%eax
  100ab9:	e8 62 ff ff ff       	call   100a20 <printnum>
  100abe:	eb 10                	jmp    100ad0 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  100ac0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100ac4:	89 3c 24             	mov    %edi,(%esp)
  100ac7:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  100ac9:	83 eb 01             	sub    $0x1,%ebx
  100acc:	85 db                	test   %ebx,%ebx
  100ace:	7f f0                	jg     100ac0 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  100ad0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100ad4:	8b 74 24 04          	mov    0x4(%esp),%esi
  100ad8:	8b 44 24 58          	mov    0x58(%esp),%eax
  100adc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100ae7:	00 
  100ae8:	8b 54 24 24          	mov    0x24(%esp),%edx
  100aec:	89 14 24             	mov    %edx,(%esp)
  100aef:	8b 4c 24 20          	mov    0x20(%esp),%ecx
  100af3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100af7:	e8 84 0b 00 00       	call   101680 <__umoddi3>
  100afc:	89 74 24 04          	mov    %esi,0x4(%esp)
  100b00:	0f be 80 24 1f 10 00 	movsbl 0x101f24(%eax),%eax
  100b07:	89 04 24             	mov    %eax,(%esp)
  100b0a:	ff d5                	call   *%ebp
}
  100b0c:	83 c4 3c             	add    $0x3c,%esp
  100b0f:	5b                   	pop    %ebx
  100b10:	5e                   	pop    %esi
  100b11:	5f                   	pop    %edi
  100b12:	5d                   	pop    %ebp
  100b13:	c3                   	ret    

00100b14 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100b14:	83 fa 01             	cmp    $0x1,%edx
  100b17:	7e 0d                	jle    100b26 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
  100b19:	8b 10                	mov    (%eax),%edx
  100b1b:	8d 4a 08             	lea    0x8(%edx),%ecx
  100b1e:	89 08                	mov    %ecx,(%eax)
  100b20:	8b 02                	mov    (%edx),%eax
  100b22:	8b 52 04             	mov    0x4(%edx),%edx
  100b25:	c3                   	ret    
	else if (lflag)
  100b26:	85 d2                	test   %edx,%edx
  100b28:	74 0f                	je     100b39 <getuint+0x25>
		return va_arg(*ap, unsigned long);
  100b2a:	8b 10                	mov    (%eax),%edx
  100b2c:	8d 4a 04             	lea    0x4(%edx),%ecx
  100b2f:	89 08                	mov    %ecx,(%eax)
  100b31:	8b 02                	mov    (%edx),%eax
  100b33:	ba 00 00 00 00       	mov    $0x0,%edx
  100b38:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
  100b39:	8b 10                	mov    (%eax),%edx
  100b3b:	8d 4a 04             	lea    0x4(%edx),%ecx
  100b3e:	89 08                	mov    %ecx,(%eax)
  100b40:	8b 02                	mov    (%edx),%eax
  100b42:	ba 00 00 00 00       	mov    $0x0,%edx
}
  100b47:	c3                   	ret    

00100b48 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  100b48:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
  100b4c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  100b50:	8b 10                	mov    (%eax),%edx
  100b52:	3b 50 04             	cmp    0x4(%eax),%edx
  100b55:	73 0b                	jae    100b62 <sprintputch+0x1a>
		*b->buf++ = ch;
  100b57:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  100b5b:	88 0a                	mov    %cl,(%edx)
  100b5d:	83 c2 01             	add    $0x1,%edx
  100b60:	89 10                	mov    %edx,(%eax)
  100b62:	f3 c3                	repz ret 

00100b64 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  100b64:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
  100b67:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  100b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100b6f:	8b 44 24 28          	mov    0x28(%esp),%eax
  100b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b77:	8b 44 24 24          	mov    0x24(%esp),%eax
  100b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b7f:	8b 44 24 20          	mov    0x20(%esp),%eax
  100b83:	89 04 24             	mov    %eax,(%esp)
  100b86:	e8 04 00 00 00       	call   100b8f <vprintfmt>
	va_end(ap);
}
  100b8b:	83 c4 1c             	add    $0x1c,%esp
  100b8e:	c3                   	ret    

00100b8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  100b8f:	55                   	push   %ebp
  100b90:	57                   	push   %edi
  100b91:	56                   	push   %esi
  100b92:	53                   	push   %ebx
  100b93:	83 ec 4c             	sub    $0x4c,%esp
  100b96:	8b 6c 24 60          	mov    0x60(%esp),%ebp
  100b9a:	8b 7c 24 64          	mov    0x64(%esp),%edi
  100b9e:	8b 5c 24 68          	mov    0x68(%esp),%ebx
  100ba2:	eb 11                	jmp    100bb5 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  100ba4:	85 c0                	test   %eax,%eax
  100ba6:	0f 84 40 04 00 00    	je     100fec <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
  100bac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100bb0:	89 04 24             	mov    %eax,(%esp)
  100bb3:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  100bb5:	0f b6 03             	movzbl (%ebx),%eax
  100bb8:	83 c3 01             	add    $0x1,%ebx
  100bbb:	83 f8 25             	cmp    $0x25,%eax
  100bbe:	75 e4                	jne    100ba4 <vprintfmt+0x15>
  100bc0:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
  100bc5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
  100bcc:	00 
  100bcd:	be ff ff ff ff       	mov    $0xffffffff,%esi
  100bd2:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
  100bd9:	ff 
  100bda:	b9 00 00 00 00       	mov    $0x0,%ecx
  100bdf:	89 74 24 34          	mov    %esi,0x34(%esp)
  100be3:	eb 34                	jmp    100c19 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100be5:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
  100be9:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
  100bee:	eb 29                	jmp    100c19 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100bf0:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  100bf4:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
  100bf9:	eb 1e                	jmp    100c19 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100bfb:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
  100bff:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100c06:	00 
  100c07:	eb 10                	jmp    100c19 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  100c09:	8b 44 24 34          	mov    0x34(%esp),%eax
  100c0d:	89 44 24 30          	mov    %eax,0x30(%esp)
  100c11:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
  100c18:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c19:	0f b6 03             	movzbl (%ebx),%eax
  100c1c:	0f b6 d0             	movzbl %al,%edx
  100c1f:	8d 73 01             	lea    0x1(%ebx),%esi
  100c22:	89 74 24 24          	mov    %esi,0x24(%esp)
  100c26:	83 e8 23             	sub    $0x23,%eax
  100c29:	3c 55                	cmp    $0x55,%al
  100c2b:	0f 87 9c 03 00 00    	ja     100fcd <vprintfmt+0x43e>
  100c31:	0f b6 c0             	movzbl %al,%eax
  100c34:	ff 24 85 e0 1f 10 00 	jmp    *0x101fe0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  100c3b:	83 ea 30             	sub    $0x30,%edx
  100c3e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
  100c42:	8b 54 24 24          	mov    0x24(%esp),%edx
  100c46:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
  100c49:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c4c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
  100c50:	83 fa 09             	cmp    $0x9,%edx
  100c53:	77 5b                	ja     100cb0 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c55:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  100c59:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
  100c5c:	8d 14 b6             	lea    (%esi,%esi,4),%edx
  100c5f:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
  100c63:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
  100c66:	8d 50 d0             	lea    -0x30(%eax),%edx
  100c69:	83 fa 09             	cmp    $0x9,%edx
  100c6c:	76 eb                	jbe    100c59 <vprintfmt+0xca>
  100c6e:	89 74 24 34          	mov    %esi,0x34(%esp)
  100c72:	eb 3c                	jmp    100cb0 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  100c74:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100c78:	8d 50 04             	lea    0x4(%eax),%edx
  100c7b:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100c7f:	8b 00                	mov    (%eax),%eax
  100c81:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c85:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  100c89:	eb 25                	jmp    100cb0 <vprintfmt+0x121>

		case '.':
			if (width < 0)
  100c8b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100c90:	0f 88 65 ff ff ff    	js     100bfb <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100c96:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100c9a:	e9 7a ff ff ff       	jmp    100c19 <vprintfmt+0x8a>
  100c9f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  100ca3:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
  100caa:	00 
			goto reswitch;
  100cab:	e9 69 ff ff ff       	jmp    100c19 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
  100cb0:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100cb5:	0f 89 5e ff ff ff    	jns    100c19 <vprintfmt+0x8a>
  100cbb:	e9 49 ff ff ff       	jmp    100c09 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  100cc0:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100cc3:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100cc7:	e9 4d ff ff ff       	jmp    100c19 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  100ccc:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100cd0:	8d 50 04             	lea    0x4(%eax),%edx
  100cd3:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100cd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100cdb:	8b 00                	mov    (%eax),%eax
  100cdd:	89 04 24             	mov    %eax,(%esp)
  100ce0:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100ce2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
  100ce6:	e9 ca fe ff ff       	jmp    100bb5 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
  100ceb:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100cef:	8d 50 04             	lea    0x4(%eax),%edx
  100cf2:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100cf6:	8b 00                	mov    (%eax),%eax
  100cf8:	89 c2                	mov    %eax,%edx
  100cfa:	c1 fa 1f             	sar    $0x1f,%edx
  100cfd:	31 d0                	xor    %edx,%eax
  100cff:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  100d01:	83 f8 08             	cmp    $0x8,%eax
  100d04:	7f 0b                	jg     100d11 <vprintfmt+0x182>
  100d06:	8b 14 85 40 21 10 00 	mov    0x102140(,%eax,4),%edx
  100d0d:	85 d2                	test   %edx,%edx
  100d0f:	75 21                	jne    100d32 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
  100d11:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100d15:	c7 44 24 08 3c 1f 10 	movl   $0x101f3c,0x8(%esp)
  100d1c:	00 
  100d1d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d21:	89 2c 24             	mov    %ebp,(%esp)
  100d24:	e8 3b fe ff ff       	call   100b64 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100d29:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
  100d2d:	e9 83 fe ff ff       	jmp    100bb5 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
  100d32:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100d36:	c7 44 24 08 45 1f 10 	movl   $0x101f45,0x8(%esp)
  100d3d:	00 
  100d3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100d42:	89 2c 24             	mov    %ebp,(%esp)
  100d45:	e8 1a fe ff ff       	call   100b64 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100d4a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100d4e:	e9 62 fe ff ff       	jmp    100bb5 <vprintfmt+0x26>
  100d53:	8b 74 24 34          	mov    0x34(%esp),%esi
  100d57:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100d5b:	8b 44 24 30          	mov    0x30(%esp),%eax
  100d5f:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  100d63:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100d67:	8d 50 04             	lea    0x4(%eax),%edx
  100d6a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100d6e:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  100d70:	85 c0                	test   %eax,%eax
  100d72:	ba 35 1f 10 00       	mov    $0x101f35,%edx
  100d77:	0f 45 d0             	cmovne %eax,%edx
  100d7a:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
  100d7e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
  100d83:	7e 07                	jle    100d8c <vprintfmt+0x1fd>
  100d85:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
  100d8a:	75 14                	jne    100da0 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100d8c:	8b 54 24 34          	mov    0x34(%esp),%edx
  100d90:	0f be 02             	movsbl (%edx),%eax
  100d93:	85 c0                	test   %eax,%eax
  100d95:	0f 85 ac 00 00 00    	jne    100e47 <vprintfmt+0x2b8>
  100d9b:	e9 97 00 00 00       	jmp    100e37 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100da0:	89 74 24 04          	mov    %esi,0x4(%esp)
  100da4:	8b 44 24 34          	mov    0x34(%esp),%eax
  100da8:	89 04 24             	mov    %eax,(%esp)
  100dab:	e8 99 03 00 00       	call   101149 <strnlen>
  100db0:	8b 54 24 38          	mov    0x38(%esp),%edx
  100db4:	29 c2                	sub    %eax,%edx
  100db6:	89 54 24 30          	mov    %edx,0x30(%esp)
  100dba:	85 d2                	test   %edx,%edx
  100dbc:	7e ce                	jle    100d8c <vprintfmt+0x1fd>
					putch(padc, putdat);
  100dbe:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
  100dc3:	89 74 24 38          	mov    %esi,0x38(%esp)
  100dc7:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
  100dcb:	89 d3                	mov    %edx,%ebx
  100dcd:	89 c6                	mov    %eax,%esi
  100dcf:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100dd3:	89 34 24             	mov    %esi,(%esp)
  100dd6:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  100dd8:	83 eb 01             	sub    $0x1,%ebx
  100ddb:	85 db                	test   %ebx,%ebx
  100ddd:	7f f0                	jg     100dcf <vprintfmt+0x240>
  100ddf:	8b 74 24 38          	mov    0x38(%esp),%esi
  100de3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
  100de7:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
  100dee:	00 
  100def:	eb 9b                	jmp    100d8c <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  100df1:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
  100df6:	74 19                	je     100e11 <vprintfmt+0x282>
  100df8:	8d 50 e0             	lea    -0x20(%eax),%edx
  100dfb:	83 fa 5e             	cmp    $0x5e,%edx
  100dfe:	76 11                	jbe    100e11 <vprintfmt+0x282>
					putch('?', putdat);
  100e00:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e04:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  100e0b:	ff 54 24 28          	call   *0x28(%esp)
  100e0f:	eb 0b                	jmp    100e1c <vprintfmt+0x28d>
				else
					putch(ch, putdat);
  100e11:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e15:	89 04 24             	mov    %eax,(%esp)
  100e18:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100e1c:	83 ed 01             	sub    $0x1,%ebp
  100e1f:	0f be 03             	movsbl (%ebx),%eax
  100e22:	85 c0                	test   %eax,%eax
  100e24:	74 05                	je     100e2b <vprintfmt+0x29c>
  100e26:	83 c3 01             	add    $0x1,%ebx
  100e29:	eb 31                	jmp    100e5c <vprintfmt+0x2cd>
  100e2b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100e2f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100e33:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e37:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
  100e3c:	7f 35                	jg     100e73 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100e3e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100e42:	e9 6e fd ff ff       	jmp    100bb5 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  100e47:	8b 54 24 34          	mov    0x34(%esp),%edx
  100e4b:	83 c2 01             	add    $0x1,%edx
  100e4e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
  100e52:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  100e56:	89 5c 24 38          	mov    %ebx,0x38(%esp)
  100e5a:	89 d3                	mov    %edx,%ebx
  100e5c:	85 f6                	test   %esi,%esi
  100e5e:	78 91                	js     100df1 <vprintfmt+0x262>
  100e60:	83 ee 01             	sub    $0x1,%esi
  100e63:	79 8c                	jns    100df1 <vprintfmt+0x262>
  100e65:	89 6c 24 30          	mov    %ebp,0x30(%esp)
  100e69:	8b 6c 24 28          	mov    0x28(%esp),%ebp
  100e6d:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  100e71:	eb c4                	jmp    100e37 <vprintfmt+0x2a8>
  100e73:	89 de                	mov    %ebx,%esi
  100e75:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  100e79:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100e7d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  100e84:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  100e86:	83 eb 01             	sub    $0x1,%ebx
  100e89:	85 db                	test   %ebx,%ebx
  100e8b:	7f ec                	jg     100e79 <vprintfmt+0x2ea>
  100e8d:	89 f3                	mov    %esi,%ebx
  100e8f:	e9 21 fd ff ff       	jmp    100bb5 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  100e94:	83 f9 01             	cmp    $0x1,%ecx
  100e97:	7e 12                	jle    100eab <vprintfmt+0x31c>
		return va_arg(*ap, long long);
  100e99:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100e9d:	8d 50 08             	lea    0x8(%eax),%edx
  100ea0:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100ea4:	8b 18                	mov    (%eax),%ebx
  100ea6:	8b 70 04             	mov    0x4(%eax),%esi
  100ea9:	eb 2a                	jmp    100ed5 <vprintfmt+0x346>
	else if (lflag)
  100eab:	85 c9                	test   %ecx,%ecx
  100ead:	74 14                	je     100ec3 <vprintfmt+0x334>
		return va_arg(*ap, long);
  100eaf:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100eb3:	8d 50 04             	lea    0x4(%eax),%edx
  100eb6:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100eba:	8b 18                	mov    (%eax),%ebx
  100ebc:	89 de                	mov    %ebx,%esi
  100ebe:	c1 fe 1f             	sar    $0x1f,%esi
  100ec1:	eb 12                	jmp    100ed5 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
  100ec3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100ec7:	8d 50 04             	lea    0x4(%eax),%edx
  100eca:	89 54 24 6c          	mov    %edx,0x6c(%esp)
  100ece:	8b 18                	mov    (%eax),%ebx
  100ed0:	89 de                	mov    %ebx,%esi
  100ed2:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  100ed5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  100eda:	85 f6                	test   %esi,%esi
  100edc:	0f 89 ab 00 00 00    	jns    100f8d <vprintfmt+0x3fe>
				putch('-', putdat);
  100ee2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100ee6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  100eed:	ff d5                	call   *%ebp
				num = -(long long) num;
  100eef:	f7 db                	neg    %ebx
  100ef1:	83 d6 00             	adc    $0x0,%esi
  100ef4:	f7 de                	neg    %esi
			}
			base = 10;
  100ef6:	b8 0a 00 00 00       	mov    $0xa,%eax
  100efb:	e9 8d 00 00 00       	jmp    100f8d <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  100f00:	89 ca                	mov    %ecx,%edx
  100f02:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100f06:	e8 09 fc ff ff       	call   100b14 <getuint>
  100f0b:	89 c3                	mov    %eax,%ebx
  100f0d:	89 d6                	mov    %edx,%esi
			base = 10;
  100f0f:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
  100f14:	eb 77                	jmp    100f8d <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  100f16:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f1a:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f21:	ff d5                	call   *%ebp
			putch('X', putdat);
  100f23:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f27:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f2e:	ff d5                	call   *%ebp
			putch('X', putdat);
  100f30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f34:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  100f3b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100f3d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
  100f41:	e9 6f fc ff ff       	jmp    100bb5 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
  100f46:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f4a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  100f51:	ff d5                	call   *%ebp
			putch('x', putdat);
  100f53:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100f57:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  100f5e:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  100f60:	8b 44 24 6c          	mov    0x6c(%esp),%eax
  100f64:	8d 50 04             	lea    0x4(%eax),%edx
  100f67:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  100f6b:	8b 18                	mov    (%eax),%ebx
  100f6d:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  100f72:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
  100f77:	eb 14                	jmp    100f8d <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  100f79:	89 ca                	mov    %ecx,%edx
  100f7b:	8d 44 24 6c          	lea    0x6c(%esp),%eax
  100f7f:	e8 90 fb ff ff       	call   100b14 <getuint>
  100f84:	89 c3                	mov    %eax,%ebx
  100f86:	89 d6                	mov    %edx,%esi
			base = 16;
  100f88:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
  100f8d:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
  100f92:	89 54 24 10          	mov    %edx,0x10(%esp)
  100f96:	8b 54 24 30          	mov    0x30(%esp),%edx
  100f9a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  100f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100fa2:	89 1c 24             	mov    %ebx,(%esp)
  100fa5:	89 74 24 04          	mov    %esi,0x4(%esp)
  100fa9:	89 fa                	mov    %edi,%edx
  100fab:	89 e8                	mov    %ebp,%eax
  100fad:	e8 6e fa ff ff       	call   100a20 <printnum>
			break;
  100fb2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
  100fb6:	e9 fa fb ff ff       	jmp    100bb5 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  100fbb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100fbf:	89 14 24             	mov    %edx,(%esp)
  100fc2:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  100fc4:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
  100fc8:	e9 e8 fb ff ff       	jmp    100bb5 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  100fcd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  100fd1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  100fd8:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
  100fda:	eb 02                	jmp    100fde <vprintfmt+0x44f>
  100fdc:	89 c3                	mov    %eax,%ebx
  100fde:	8d 43 ff             	lea    -0x1(%ebx),%eax
  100fe1:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  100fe5:	75 f5                	jne    100fdc <vprintfmt+0x44d>
  100fe7:	e9 c9 fb ff ff       	jmp    100bb5 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
  100fec:	83 c4 4c             	add    $0x4c,%esp
  100fef:	5b                   	pop    %ebx
  100ff0:	5e                   	pop    %esi
  100ff1:	5f                   	pop    %edi
  100ff2:	5d                   	pop    %ebp
  100ff3:	c3                   	ret    

00100ff4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  100ff4:	83 ec 2c             	sub    $0x2c,%esp
  100ff7:	8b 44 24 30          	mov    0x30(%esp),%eax
  100ffb:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  100fff:	89 44 24 14          	mov    %eax,0x14(%esp)
  101003:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  101007:	89 4c 24 18          	mov    %ecx,0x18(%esp)
  10100b:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  101012:	00 

	if (buf == NULL || n < 1)
  101013:	85 c0                	test   %eax,%eax
  101015:	74 35                	je     10104c <vsnprintf+0x58>
  101017:	85 d2                	test   %edx,%edx
  101019:	7e 31                	jle    10104c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  10101b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  10101f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101023:	8b 44 24 38          	mov    0x38(%esp),%eax
  101027:	89 44 24 08          	mov    %eax,0x8(%esp)
  10102b:	8d 44 24 14          	lea    0x14(%esp),%eax
  10102f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101033:	c7 04 24 48 0b 10 00 	movl   $0x100b48,(%esp)
  10103a:	e8 50 fb ff ff       	call   100b8f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  10103f:	8b 44 24 14          	mov    0x14(%esp),%eax
  101043:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  101046:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  10104a:	eb 05                	jmp    101051 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  10104c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  101051:	83 c4 2c             	add    $0x2c,%esp
  101054:	c3                   	ret    

00101055 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  101055:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  101058:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  10105c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  101060:	8b 44 24 28          	mov    0x28(%esp),%eax
  101064:	89 44 24 08          	mov    %eax,0x8(%esp)
  101068:	8b 44 24 24          	mov    0x24(%esp),%eax
  10106c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101070:	8b 44 24 20          	mov    0x20(%esp),%eax
  101074:	89 04 24             	mov    %eax,(%esp)
  101077:	e8 78 ff ff ff       	call   100ff4 <vsnprintf>
	va_end(ap);

	return rc;
}
  10107c:	83 c4 1c             	add    $0x1c,%esp
  10107f:	c3                   	ret    

00101080 <readline>:

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  101080:	56                   	push   %esi
  101081:	53                   	push   %ebx
  101082:	83 ec 14             	sub    $0x14,%esp
  101085:	8b 44 24 20          	mov    0x20(%esp),%eax
	int i, c, echoing;

	if (prompt != NULL)
  101089:	85 c0                	test   %eax,%eax
  10108b:	74 10                	je     10109d <readline+0x1d>
		cprintf("%s", prompt);
  10108d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101091:	c7 04 24 45 1f 10 00 	movl   $0x101f45,(%esp)
  101098:	e8 b1 f6 ff ff       	call   10074e <cprintf>

#define BUFLEN 1024
static char buf[BUFLEN];

char *readline(const char *prompt)
{
  10109d:	be 00 00 00 00       	mov    $0x0,%esi
	if (prompt != NULL)
		cprintf("%s", prompt);

	i = 0;
	while (1) {
		c = getc();
  1010a2:	e8 c4 f1 ff ff       	call   10026b <getc>
  1010a7:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  1010a9:	85 c0                	test   %eax,%eax
  1010ab:	79 17                	jns    1010c4 <readline+0x44>
			cprintf("read error: %e\n", c);
  1010ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1010b1:	c7 04 24 64 21 10 00 	movl   $0x102164,(%esp)
  1010b8:	e8 91 f6 ff ff       	call   10074e <cprintf>
			return NULL;
  1010bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1010c2:	eb 64                	jmp    101128 <readline+0xa8>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  1010c4:	83 f8 08             	cmp    $0x8,%eax
  1010c7:	74 05                	je     1010ce <readline+0x4e>
  1010c9:	83 f8 7f             	cmp    $0x7f,%eax
  1010cc:	75 15                	jne    1010e3 <readline+0x63>
  1010ce:	85 f6                	test   %esi,%esi
  1010d0:	7e 11                	jle    1010e3 <readline+0x63>
			putch('\b');
  1010d2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d9:	e8 8b f2 ff ff       	call   100369 <putch>
			i--;
  1010de:	83 ee 01             	sub    $0x1,%esi
  1010e1:	eb bf                	jmp    1010a2 <readline+0x22>
		} else if (c >= ' ' && i < BUFLEN-1) {
  1010e3:	83 fb 1f             	cmp    $0x1f,%ebx
  1010e6:	7e 1e                	jle    101106 <readline+0x86>
  1010e8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  1010ee:	7f 16                	jg     101106 <readline+0x86>
			putch(c);
  1010f0:	0f b6 c3             	movzbl %bl,%eax
  1010f3:	89 04 24             	mov    %eax,(%esp)
  1010f6:	e8 6e f2 ff ff       	call   100369 <putch>
			buf[i++] = c;
  1010fb:	88 9e 40 bd 10 00    	mov    %bl,0x10bd40(%esi)
  101101:	83 c6 01             	add    $0x1,%esi
  101104:	eb 9c                	jmp    1010a2 <readline+0x22>
		} else if (c == '\n' || c == '\r') {
  101106:	83 fb 0a             	cmp    $0xa,%ebx
  101109:	74 05                	je     101110 <readline+0x90>
  10110b:	83 fb 0d             	cmp    $0xd,%ebx
  10110e:	75 92                	jne    1010a2 <readline+0x22>
			putch('\n');
  101110:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  101117:	e8 4d f2 ff ff       	call   100369 <putch>
			buf[i] = 0;
  10111c:	c6 86 40 bd 10 00 00 	movb   $0x0,0x10bd40(%esi)
			return buf;
  101123:	b8 40 bd 10 00       	mov    $0x10bd40,%eax
		}
	}
}
  101128:	83 c4 14             	add    $0x14,%esp
  10112b:	5b                   	pop    %ebx
  10112c:	5e                   	pop    %esi
  10112d:	c3                   	ret    
	...

00101130 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  101130:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  101134:	b8 00 00 00 00       	mov    $0x0,%eax
  101139:	80 3a 00             	cmpb   $0x0,(%edx)
  10113c:	74 09                	je     101147 <strlen+0x17>
		n++;
  10113e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  101141:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  101145:	75 f7                	jne    10113e <strlen+0xe>
		n++;
	return n;
}
  101147:	f3 c3                	repz ret 

00101149 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  101149:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10114d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101151:	b8 00 00 00 00       	mov    $0x0,%eax
  101156:	85 d2                	test   %edx,%edx
  101158:	74 12                	je     10116c <strnlen+0x23>
  10115a:	80 39 00             	cmpb   $0x0,(%ecx)
  10115d:	74 0d                	je     10116c <strnlen+0x23>
		n++;
  10115f:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  101162:	39 d0                	cmp    %edx,%eax
  101164:	74 06                	je     10116c <strnlen+0x23>
  101166:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  10116a:	75 f3                	jne    10115f <strnlen+0x16>
		n++;
	return n;
}
  10116c:	f3 c3                	repz ret 

0010116e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  10116e:	53                   	push   %ebx
  10116f:	8b 44 24 08          	mov    0x8(%esp),%eax
  101173:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  101177:	ba 00 00 00 00       	mov    $0x0,%edx
  10117c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  101180:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  101183:	83 c2 01             	add    $0x1,%edx
  101186:	84 c9                	test   %cl,%cl
  101188:	75 f2                	jne    10117c <strcpy+0xe>
		/* do nothing */;
	return ret;
}
  10118a:	5b                   	pop    %ebx
  10118b:	c3                   	ret    

0010118c <strcat>:

char *
strcat(char *dst, const char *src)
{
  10118c:	53                   	push   %ebx
  10118d:	83 ec 08             	sub    $0x8,%esp
  101190:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
  101194:	89 1c 24             	mov    %ebx,(%esp)
  101197:	e8 94 ff ff ff       	call   101130 <strlen>
	strcpy(dst + len, src);
  10119c:	8b 54 24 14          	mov    0x14(%esp),%edx
  1011a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a4:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  1011a7:	89 04 24             	mov    %eax,(%esp)
  1011aa:	e8 bf ff ff ff       	call   10116e <strcpy>
	return dst;
}
  1011af:	89 d8                	mov    %ebx,%eax
  1011b1:	83 c4 08             	add    $0x8,%esp
  1011b4:	5b                   	pop    %ebx
  1011b5:	c3                   	ret    

001011b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  1011b6:	56                   	push   %esi
  1011b7:	53                   	push   %ebx
  1011b8:	8b 44 24 0c          	mov    0xc(%esp),%eax
  1011bc:	8b 54 24 10          	mov    0x10(%esp),%edx
  1011c0:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  1011c4:	85 f6                	test   %esi,%esi
  1011c6:	74 18                	je     1011e0 <strncpy+0x2a>
  1011c8:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  1011cd:	0f b6 1a             	movzbl (%edx),%ebx
  1011d0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  1011d3:	80 3a 01             	cmpb   $0x1,(%edx)
  1011d6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  1011d9:	83 c1 01             	add    $0x1,%ecx
  1011dc:	39 ce                	cmp    %ecx,%esi
  1011de:	77 ed                	ja     1011cd <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  1011e0:	5b                   	pop    %ebx
  1011e1:	5e                   	pop    %esi
  1011e2:	c3                   	ret    

001011e3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  1011e3:	57                   	push   %edi
  1011e4:	56                   	push   %esi
  1011e5:	53                   	push   %ebx
  1011e6:	8b 7c 24 10          	mov    0x10(%esp),%edi
  1011ea:	8b 5c 24 14          	mov    0x14(%esp),%ebx
  1011ee:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  1011f2:	89 f8                	mov    %edi,%eax
  1011f4:	85 f6                	test   %esi,%esi
  1011f6:	74 2c                	je     101224 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
  1011f8:	83 fe 01             	cmp    $0x1,%esi
  1011fb:	74 24                	je     101221 <strlcpy+0x3e>
  1011fd:	0f b6 0b             	movzbl (%ebx),%ecx
  101200:	84 c9                	test   %cl,%cl
  101202:	74 1d                	je     101221 <strlcpy+0x3e>
  101204:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
  101209:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  10120c:	88 08                	mov    %cl,(%eax)
  10120e:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  101211:	39 f2                	cmp    %esi,%edx
  101213:	74 0c                	je     101221 <strlcpy+0x3e>
  101215:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
  10121a:	83 c2 01             	add    $0x1,%edx
  10121d:	84 c9                	test   %cl,%cl
  10121f:	75 eb                	jne    10120c <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
  101221:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  101224:	29 f8                	sub    %edi,%eax
}
  101226:	5b                   	pop    %ebx
  101227:	5e                   	pop    %esi
  101228:	5f                   	pop    %edi
  101229:	c3                   	ret    

0010122a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  10122a:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  10122e:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
  101232:	0f b6 01             	movzbl (%ecx),%eax
  101235:	84 c0                	test   %al,%al
  101237:	74 15                	je     10124e <strcmp+0x24>
  101239:	3a 02                	cmp    (%edx),%al
  10123b:	75 11                	jne    10124e <strcmp+0x24>
		p++, q++;
  10123d:	83 c1 01             	add    $0x1,%ecx
  101240:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  101243:	0f b6 01             	movzbl (%ecx),%eax
  101246:	84 c0                	test   %al,%al
  101248:	74 04                	je     10124e <strcmp+0x24>
  10124a:	3a 02                	cmp    (%edx),%al
  10124c:	74 ef                	je     10123d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  10124e:	0f b6 c0             	movzbl %al,%eax
  101251:	0f b6 12             	movzbl (%edx),%edx
  101254:	29 d0                	sub    %edx,%eax
}
  101256:	c3                   	ret    

00101257 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  101257:	53                   	push   %ebx
  101258:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  10125c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  101260:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  101264:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101269:	85 d2                	test   %edx,%edx
  10126b:	74 28                	je     101295 <strncmp+0x3e>
  10126d:	0f b6 01             	movzbl (%ecx),%eax
  101270:	84 c0                	test   %al,%al
  101272:	74 23                	je     101297 <strncmp+0x40>
  101274:	3a 03                	cmp    (%ebx),%al
  101276:	75 1f                	jne    101297 <strncmp+0x40>
  101278:	83 ea 01             	sub    $0x1,%edx
  10127b:	74 13                	je     101290 <strncmp+0x39>
		n--, p++, q++;
  10127d:	83 c1 01             	add    $0x1,%ecx
  101280:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  101283:	0f b6 01             	movzbl (%ecx),%eax
  101286:	84 c0                	test   %al,%al
  101288:	74 0d                	je     101297 <strncmp+0x40>
  10128a:	3a 03                	cmp    (%ebx),%al
  10128c:	74 ea                	je     101278 <strncmp+0x21>
  10128e:	eb 07                	jmp    101297 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
  101290:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  101295:	5b                   	pop    %ebx
  101296:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  101297:	0f b6 01             	movzbl (%ecx),%eax
  10129a:	0f b6 13             	movzbl (%ebx),%edx
  10129d:	29 d0                	sub    %edx,%eax
  10129f:	eb f4                	jmp    101295 <strncmp+0x3e>

001012a1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  1012a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  1012a5:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  1012aa:	0f b6 10             	movzbl (%eax),%edx
  1012ad:	84 d2                	test   %dl,%dl
  1012af:	74 21                	je     1012d2 <strchr+0x31>
		if (*s == c)
  1012b1:	38 ca                	cmp    %cl,%dl
  1012b3:	75 0d                	jne    1012c2 <strchr+0x21>
  1012b5:	f3 c3                	repz ret 
  1012b7:	38 ca                	cmp    %cl,%dl
  1012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  1012c0:	74 15                	je     1012d7 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  1012c2:	83 c0 01             	add    $0x1,%eax
  1012c5:	0f b6 10             	movzbl (%eax),%edx
  1012c8:	84 d2                	test   %dl,%dl
  1012ca:	75 eb                	jne    1012b7 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
  1012cc:	b8 00 00 00 00       	mov    $0x0,%eax
  1012d1:	c3                   	ret    
  1012d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1012d7:	f3 c3                	repz ret 

001012d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  1012d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  1012dd:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
  1012e2:	0f b6 10             	movzbl (%eax),%edx
  1012e5:	84 d2                	test   %dl,%dl
  1012e7:	74 14                	je     1012fd <strfind+0x24>
		if (*s == c)
  1012e9:	38 ca                	cmp    %cl,%dl
  1012eb:	75 06                	jne    1012f3 <strfind+0x1a>
  1012ed:	f3 c3                	repz ret 
  1012ef:	38 ca                	cmp    %cl,%dl
  1012f1:	74 0a                	je     1012fd <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  1012f3:	83 c0 01             	add    $0x1,%eax
  1012f6:	0f b6 10             	movzbl (%eax),%edx
  1012f9:	84 d2                	test   %dl,%dl
  1012fb:	75 f2                	jne    1012ef <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
  1012fd:	f3 c3                	repz ret 

001012ff <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  1012ff:	83 ec 0c             	sub    $0xc,%esp
  101302:	89 1c 24             	mov    %ebx,(%esp)
  101305:	89 74 24 04          	mov    %esi,0x4(%esp)
  101309:	89 7c 24 08          	mov    %edi,0x8(%esp)
  10130d:	8b 7c 24 10          	mov    0x10(%esp),%edi
  101311:	8b 44 24 14          	mov    0x14(%esp),%eax
  101315:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	char *p;

	if (n == 0)
  101319:	85 c9                	test   %ecx,%ecx
  10131b:	74 30                	je     10134d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  10131d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  101323:	75 25                	jne    10134a <memset+0x4b>
  101325:	f6 c1 03             	test   $0x3,%cl
  101328:	75 20                	jne    10134a <memset+0x4b>
		c &= 0xFF;
  10132a:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  10132d:	89 d3                	mov    %edx,%ebx
  10132f:	c1 e3 08             	shl    $0x8,%ebx
  101332:	89 d6                	mov    %edx,%esi
  101334:	c1 e6 18             	shl    $0x18,%esi
  101337:	89 d0                	mov    %edx,%eax
  101339:	c1 e0 10             	shl    $0x10,%eax
  10133c:	09 f0                	or     %esi,%eax
  10133e:	09 d0                	or     %edx,%eax
  101340:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  101342:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  101345:	fc                   	cld    
  101346:	f3 ab                	rep stos %eax,%es:(%edi)
  101348:	eb 03                	jmp    10134d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  10134a:	fc                   	cld    
  10134b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  10134d:	89 f8                	mov    %edi,%eax
  10134f:	8b 1c 24             	mov    (%esp),%ebx
  101352:	8b 74 24 04          	mov    0x4(%esp),%esi
  101356:	8b 7c 24 08          	mov    0x8(%esp),%edi
  10135a:	83 c4 0c             	add    $0xc,%esp
  10135d:	c3                   	ret    

0010135e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  10135e:	83 ec 08             	sub    $0x8,%esp
  101361:	89 34 24             	mov    %esi,(%esp)
  101364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  101368:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10136c:	8b 74 24 10          	mov    0x10(%esp),%esi
  101370:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  101374:	39 c6                	cmp    %eax,%esi
  101376:	73 36                	jae    1013ae <memmove+0x50>
  101378:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  10137b:	39 d0                	cmp    %edx,%eax
  10137d:	73 2f                	jae    1013ae <memmove+0x50>
		s += n;
		d += n;
  10137f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  101382:	f6 c2 03             	test   $0x3,%dl
  101385:	75 1b                	jne    1013a2 <memmove+0x44>
  101387:	f7 c7 03 00 00 00    	test   $0x3,%edi
  10138d:	75 13                	jne    1013a2 <memmove+0x44>
  10138f:	f6 c1 03             	test   $0x3,%cl
  101392:	75 0e                	jne    1013a2 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  101394:	83 ef 04             	sub    $0x4,%edi
  101397:	8d 72 fc             	lea    -0x4(%edx),%esi
  10139a:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  10139d:	fd                   	std    
  10139e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1013a0:	eb 09                	jmp    1013ab <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  1013a2:	83 ef 01             	sub    $0x1,%edi
  1013a5:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  1013a8:	fd                   	std    
  1013a9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  1013ab:	fc                   	cld    
  1013ac:	eb 20                	jmp    1013ce <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  1013ae:	f7 c6 03 00 00 00    	test   $0x3,%esi
  1013b4:	75 13                	jne    1013c9 <memmove+0x6b>
  1013b6:	a8 03                	test   $0x3,%al
  1013b8:	75 0f                	jne    1013c9 <memmove+0x6b>
  1013ba:	f6 c1 03             	test   $0x3,%cl
  1013bd:	75 0a                	jne    1013c9 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  1013bf:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  1013c2:	89 c7                	mov    %eax,%edi
  1013c4:	fc                   	cld    
  1013c5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1013c7:	eb 05                	jmp    1013ce <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  1013c9:	89 c7                	mov    %eax,%edi
  1013cb:	fc                   	cld    
  1013cc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  1013ce:	8b 34 24             	mov    (%esp),%esi
  1013d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  1013d5:	83 c4 08             	add    $0x8,%esp
  1013d8:	c3                   	ret    

001013d9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  1013d9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  1013dc:	8b 44 24 18          	mov    0x18(%esp),%eax
  1013e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1013e4:	8b 44 24 14          	mov    0x14(%esp),%eax
  1013e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1013ec:	8b 44 24 10          	mov    0x10(%esp),%eax
  1013f0:	89 04 24             	mov    %eax,(%esp)
  1013f3:	e8 66 ff ff ff       	call   10135e <memmove>
}
  1013f8:	83 c4 0c             	add    $0xc,%esp
  1013fb:	c3                   	ret    

001013fc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  1013fc:	57                   	push   %edi
  1013fd:	56                   	push   %esi
  1013fe:	53                   	push   %ebx
  1013ff:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  101403:	8b 74 24 14          	mov    0x14(%esp),%esi
  101407:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  10140b:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  101410:	85 ff                	test   %edi,%edi
  101412:	74 38                	je     10144c <memcmp+0x50>
		if (*s1 != *s2)
  101414:	0f b6 03             	movzbl (%ebx),%eax
  101417:	0f b6 0e             	movzbl (%esi),%ecx
  10141a:	38 c8                	cmp    %cl,%al
  10141c:	74 1d                	je     10143b <memcmp+0x3f>
  10141e:	eb 11                	jmp    101431 <memcmp+0x35>
  101420:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  101425:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
  10142a:	83 c2 01             	add    $0x1,%edx
  10142d:	38 c8                	cmp    %cl,%al
  10142f:	74 12                	je     101443 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
  101431:	0f b6 c0             	movzbl %al,%eax
  101434:	0f b6 c9             	movzbl %cl,%ecx
  101437:	29 c8                	sub    %ecx,%eax
  101439:	eb 11                	jmp    10144c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  10143b:	83 ef 01             	sub    $0x1,%edi
  10143e:	ba 00 00 00 00       	mov    $0x0,%edx
  101443:	39 fa                	cmp    %edi,%edx
  101445:	75 d9                	jne    101420 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  101447:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10144c:	5b                   	pop    %ebx
  10144d:	5e                   	pop    %esi
  10144e:	5f                   	pop    %edi
  10144f:	c3                   	ret    

00101450 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  101450:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
  101454:	89 c2                	mov    %eax,%edx
  101456:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
  10145a:	39 d0                	cmp    %edx,%eax
  10145c:	73 16                	jae    101474 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  10145e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
  101463:	38 08                	cmp    %cl,(%eax)
  101465:	75 06                	jne    10146d <memfind+0x1d>
  101467:	f3 c3                	repz ret 
  101469:	38 08                	cmp    %cl,(%eax)
  10146b:	74 07                	je     101474 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  10146d:	83 c0 01             	add    $0x1,%eax
  101470:	39 c2                	cmp    %eax,%edx
  101472:	77 f5                	ja     101469 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  101474:	f3 c3                	repz ret 

00101476 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  101476:	55                   	push   %ebp
  101477:	57                   	push   %edi
  101478:	56                   	push   %esi
  101479:	53                   	push   %ebx
  10147a:	8b 54 24 14          	mov    0x14(%esp),%edx
  10147e:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101482:	0f b6 02             	movzbl (%edx),%eax
  101485:	3c 20                	cmp    $0x20,%al
  101487:	74 04                	je     10148d <strtol+0x17>
  101489:	3c 09                	cmp    $0x9,%al
  10148b:	75 0e                	jne    10149b <strtol+0x25>
		s++;
  10148d:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  101490:	0f b6 02             	movzbl (%edx),%eax
  101493:	3c 20                	cmp    $0x20,%al
  101495:	74 f6                	je     10148d <strtol+0x17>
  101497:	3c 09                	cmp    $0x9,%al
  101499:	74 f2                	je     10148d <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
  10149b:	3c 2b                	cmp    $0x2b,%al
  10149d:	75 0a                	jne    1014a9 <strtol+0x33>
		s++;
  10149f:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  1014a2:	bf 00 00 00 00       	mov    $0x0,%edi
  1014a7:	eb 10                	jmp    1014b9 <strtol+0x43>
  1014a9:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  1014ae:	3c 2d                	cmp    $0x2d,%al
  1014b0:	75 07                	jne    1014b9 <strtol+0x43>
		s++, neg = 1;
  1014b2:	83 c2 01             	add    $0x1,%edx
  1014b5:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  1014b9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  1014be:	0f 94 c0             	sete   %al
  1014c1:	74 07                	je     1014ca <strtol+0x54>
  1014c3:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
  1014c8:	75 18                	jne    1014e2 <strtol+0x6c>
  1014ca:	80 3a 30             	cmpb   $0x30,(%edx)
  1014cd:	75 13                	jne    1014e2 <strtol+0x6c>
  1014cf:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  1014d3:	75 0d                	jne    1014e2 <strtol+0x6c>
		s += 2, base = 16;
  1014d5:	83 c2 02             	add    $0x2,%edx
  1014d8:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
  1014df:	00 
  1014e0:	eb 1c                	jmp    1014fe <strtol+0x88>
	else if (base == 0 && s[0] == '0')
  1014e2:	84 c0                	test   %al,%al
  1014e4:	74 18                	je     1014fe <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  1014e6:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
  1014ed:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  1014ee:	80 3a 30             	cmpb   $0x30,(%edx)
  1014f1:	75 0b                	jne    1014fe <strtol+0x88>
		s++, base = 8;
  1014f3:	83 c2 01             	add    $0x1,%edx
  1014f6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
  1014fd:	00 
	else if (base == 0)
		base = 10;
  1014fe:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  101503:	0f b6 0a             	movzbl (%edx),%ecx
  101506:	8d 69 d0             	lea    -0x30(%ecx),%ebp
  101509:	89 eb                	mov    %ebp,%ebx
  10150b:	80 fb 09             	cmp    $0x9,%bl
  10150e:	77 08                	ja     101518 <strtol+0xa2>
			dig = *s - '0';
  101510:	0f be c9             	movsbl %cl,%ecx
  101513:	83 e9 30             	sub    $0x30,%ecx
  101516:	eb 22                	jmp    10153a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
  101518:	8d 69 9f             	lea    -0x61(%ecx),%ebp
  10151b:	89 eb                	mov    %ebp,%ebx
  10151d:	80 fb 19             	cmp    $0x19,%bl
  101520:	77 08                	ja     10152a <strtol+0xb4>
			dig = *s - 'a' + 10;
  101522:	0f be c9             	movsbl %cl,%ecx
  101525:	83 e9 57             	sub    $0x57,%ecx
  101528:	eb 10                	jmp    10153a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
  10152a:	8d 69 bf             	lea    -0x41(%ecx),%ebp
  10152d:	89 eb                	mov    %ebp,%ebx
  10152f:	80 fb 19             	cmp    $0x19,%bl
  101532:	77 19                	ja     10154d <strtol+0xd7>
			dig = *s - 'A' + 10;
  101534:	0f be c9             	movsbl %cl,%ecx
  101537:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  10153a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
  10153e:	7d 11                	jge    101551 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
  101540:	83 c2 01             	add    $0x1,%edx
  101543:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
  101548:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  10154b:	eb b6                	jmp    101503 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
  10154d:	89 c1                	mov    %eax,%ecx
  10154f:	eb 02                	jmp    101553 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  101551:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  101553:	85 f6                	test   %esi,%esi
  101555:	74 02                	je     101559 <strtol+0xe3>
		*endptr = (char *) s;
  101557:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  101559:	89 ca                	mov    %ecx,%edx
  10155b:	f7 da                	neg    %edx
  10155d:	85 ff                	test   %edi,%edi
  10155f:	0f 45 c2             	cmovne %edx,%eax
}
  101562:	5b                   	pop    %ebx
  101563:	5e                   	pop    %esi
  101564:	5f                   	pop    %edi
  101565:	5d                   	pop    %ebp
  101566:	c3                   	ret    
	...

00101570 <__udivdi3>:
  101570:	55                   	push   %ebp
  101571:	89 e5                	mov    %esp,%ebp
  101573:	57                   	push   %edi
  101574:	56                   	push   %esi
  101575:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  101579:	8b 45 14             	mov    0x14(%ebp),%eax
  10157c:	8b 75 08             	mov    0x8(%ebp),%esi
  10157f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  101582:	85 c0                	test   %eax,%eax
  101584:	89 75 e8             	mov    %esi,-0x18(%ebp)
  101587:	8b 7d 0c             	mov    0xc(%ebp),%edi
  10158a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  10158d:	75 39                	jne    1015c8 <__udivdi3+0x58>
  10158f:	39 f9                	cmp    %edi,%ecx
  101591:	77 65                	ja     1015f8 <__udivdi3+0x88>
  101593:	85 c9                	test   %ecx,%ecx
  101595:	75 0b                	jne    1015a2 <__udivdi3+0x32>
  101597:	b8 01 00 00 00       	mov    $0x1,%eax
  10159c:	31 d2                	xor    %edx,%edx
  10159e:	f7 f1                	div    %ecx
  1015a0:	89 c1                	mov    %eax,%ecx
  1015a2:	89 f8                	mov    %edi,%eax
  1015a4:	31 d2                	xor    %edx,%edx
  1015a6:	f7 f1                	div    %ecx
  1015a8:	89 c7                	mov    %eax,%edi
  1015aa:	89 f0                	mov    %esi,%eax
  1015ac:	f7 f1                	div    %ecx
  1015ae:	89 fa                	mov    %edi,%edx
  1015b0:	89 c6                	mov    %eax,%esi
  1015b2:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1015b5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1015be:	8d 64 24 20          	lea    0x20(%esp),%esp
  1015c2:	5e                   	pop    %esi
  1015c3:	5f                   	pop    %edi
  1015c4:	5d                   	pop    %ebp
  1015c5:	c3                   	ret    
  1015c6:	66 90                	xchg   %ax,%ax
  1015c8:	31 d2                	xor    %edx,%edx
  1015ca:	31 f6                	xor    %esi,%esi
  1015cc:	39 f8                	cmp    %edi,%eax
  1015ce:	77 e2                	ja     1015b2 <__udivdi3+0x42>
  1015d0:	0f bd d0             	bsr    %eax,%edx
  1015d3:	83 f2 1f             	xor    $0x1f,%edx
  1015d6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1015d9:	75 2d                	jne    101608 <__udivdi3+0x98>
  1015db:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1015de:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
  1015e1:	76 06                	jbe    1015e9 <__udivdi3+0x79>
  1015e3:	39 f8                	cmp    %edi,%eax
  1015e5:	89 f2                	mov    %esi,%edx
  1015e7:	73 c9                	jae    1015b2 <__udivdi3+0x42>
  1015e9:	31 d2                	xor    %edx,%edx
  1015eb:	be 01 00 00 00       	mov    $0x1,%esi
  1015f0:	eb c0                	jmp    1015b2 <__udivdi3+0x42>
  1015f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  1015f8:	89 f0                	mov    %esi,%eax
  1015fa:	89 fa                	mov    %edi,%edx
  1015fc:	f7 f1                	div    %ecx
  1015fe:	31 d2                	xor    %edx,%edx
  101600:	89 c6                	mov    %eax,%esi
  101602:	eb ae                	jmp    1015b2 <__udivdi3+0x42>
  101604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101608:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10160c:	89 c2                	mov    %eax,%edx
  10160e:	b8 20 00 00 00       	mov    $0x20,%eax
  101613:	2b 45 ec             	sub    -0x14(%ebp),%eax
  101616:	d3 e2                	shl    %cl,%edx
  101618:	89 c1                	mov    %eax,%ecx
  10161a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10161d:	d3 ee                	shr    %cl,%esi
  10161f:	09 d6                	or     %edx,%esi
  101621:	89 fa                	mov    %edi,%edx
  101623:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101627:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  10162a:	8b 75 f0             	mov    -0x10(%ebp),%esi
  10162d:	d3 e6                	shl    %cl,%esi
  10162f:	89 c1                	mov    %eax,%ecx
  101631:	89 75 f0             	mov    %esi,-0x10(%ebp)
  101634:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101637:	d3 ea                	shr    %cl,%edx
  101639:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10163d:	d3 e7                	shl    %cl,%edi
  10163f:	89 c1                	mov    %eax,%ecx
  101641:	d3 ee                	shr    %cl,%esi
  101643:	09 fe                	or     %edi,%esi
  101645:	89 f0                	mov    %esi,%eax
  101647:	f7 75 e4             	divl   -0x1c(%ebp)
  10164a:	89 d7                	mov    %edx,%edi
  10164c:	89 c6                	mov    %eax,%esi
  10164e:	f7 65 f0             	mull   -0x10(%ebp)
  101651:	39 d7                	cmp    %edx,%edi
  101653:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  101656:	72 12                	jb     10166a <__udivdi3+0xfa>
  101658:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10165c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10165f:	d3 e2                	shl    %cl,%edx
  101661:	39 c2                	cmp    %eax,%edx
  101663:	73 08                	jae    10166d <__udivdi3+0xfd>
  101665:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
  101668:	75 03                	jne    10166d <__udivdi3+0xfd>
  10166a:	8d 76 ff             	lea    -0x1(%esi),%esi
  10166d:	31 d2                	xor    %edx,%edx
  10166f:	e9 3e ff ff ff       	jmp    1015b2 <__udivdi3+0x42>
	...

00101680 <__umoddi3>:
  101680:	55                   	push   %ebp
  101681:	89 e5                	mov    %esp,%ebp
  101683:	57                   	push   %edi
  101684:	56                   	push   %esi
  101685:	8d 64 24 e0          	lea    -0x20(%esp),%esp
  101689:	8b 7d 14             	mov    0x14(%ebp),%edi
  10168c:	8b 45 08             	mov    0x8(%ebp),%eax
  10168f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  101692:	8b 75 0c             	mov    0xc(%ebp),%esi
  101695:	85 ff                	test   %edi,%edi
  101697:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10169a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  10169d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1016a0:	89 f2                	mov    %esi,%edx
  1016a2:	75 14                	jne    1016b8 <__umoddi3+0x38>
  1016a4:	39 f1                	cmp    %esi,%ecx
  1016a6:	76 40                	jbe    1016e8 <__umoddi3+0x68>
  1016a8:	f7 f1                	div    %ecx
  1016aa:	89 d0                	mov    %edx,%eax
  1016ac:	31 d2                	xor    %edx,%edx
  1016ae:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016b2:	5e                   	pop    %esi
  1016b3:	5f                   	pop    %edi
  1016b4:	5d                   	pop    %ebp
  1016b5:	c3                   	ret    
  1016b6:	66 90                	xchg   %ax,%ax
  1016b8:	39 f7                	cmp    %esi,%edi
  1016ba:	77 4c                	ja     101708 <__umoddi3+0x88>
  1016bc:	0f bd c7             	bsr    %edi,%eax
  1016bf:	83 f0 1f             	xor    $0x1f,%eax
  1016c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1016c5:	75 51                	jne    101718 <__umoddi3+0x98>
  1016c7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
  1016ca:	0f 87 e8 00 00 00    	ja     1017b8 <__umoddi3+0x138>
  1016d0:	89 f2                	mov    %esi,%edx
  1016d2:	8b 75 f0             	mov    -0x10(%ebp),%esi
  1016d5:	29 ce                	sub    %ecx,%esi
  1016d7:	19 fa                	sbb    %edi,%edx
  1016d9:	89 75 f0             	mov    %esi,-0x10(%ebp)
  1016dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016df:	8d 64 24 20          	lea    0x20(%esp),%esp
  1016e3:	5e                   	pop    %esi
  1016e4:	5f                   	pop    %edi
  1016e5:	5d                   	pop    %ebp
  1016e6:	c3                   	ret    
  1016e7:	90                   	nop
  1016e8:	85 c9                	test   %ecx,%ecx
  1016ea:	75 0b                	jne    1016f7 <__umoddi3+0x77>
  1016ec:	b8 01 00 00 00       	mov    $0x1,%eax
  1016f1:	31 d2                	xor    %edx,%edx
  1016f3:	f7 f1                	div    %ecx
  1016f5:	89 c1                	mov    %eax,%ecx
  1016f7:	89 f0                	mov    %esi,%eax
  1016f9:	31 d2                	xor    %edx,%edx
  1016fb:	f7 f1                	div    %ecx
  1016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101700:	f7 f1                	div    %ecx
  101702:	eb a6                	jmp    1016aa <__umoddi3+0x2a>
  101704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  101708:	89 f2                	mov    %esi,%edx
  10170a:	8d 64 24 20          	lea    0x20(%esp),%esp
  10170e:	5e                   	pop    %esi
  10170f:	5f                   	pop    %edi
  101710:	5d                   	pop    %ebp
  101711:	c3                   	ret    
  101712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  101718:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10171c:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  101723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101726:	29 45 f0             	sub    %eax,-0x10(%ebp)
  101729:	d3 e7                	shl    %cl,%edi
  10172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10172e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101732:	89 f2                	mov    %esi,%edx
  101734:	d3 e8                	shr    %cl,%eax
  101736:	09 f8                	or     %edi,%eax
  101738:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10173c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101742:	d3 e0                	shl    %cl,%eax
  101744:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10174b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10174e:	d3 ea                	shr    %cl,%edx
  101750:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101754:	d3 e6                	shl    %cl,%esi
  101756:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  10175a:	d3 e8                	shr    %cl,%eax
  10175c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  101760:	09 f0                	or     %esi,%eax
  101762:	8b 75 e8             	mov    -0x18(%ebp),%esi
  101765:	d3 e6                	shl    %cl,%esi
  101767:	f7 75 e4             	divl   -0x1c(%ebp)
  10176a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  10176d:	89 d6                	mov    %edx,%esi
  10176f:	f7 65 f4             	mull   -0xc(%ebp)
  101772:	89 d7                	mov    %edx,%edi
  101774:	89 c2                	mov    %eax,%edx
  101776:	39 fe                	cmp    %edi,%esi
  101778:	89 f9                	mov    %edi,%ecx
  10177a:	72 30                	jb     1017ac <__umoddi3+0x12c>
  10177c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10177f:	72 27                	jb     1017a8 <__umoddi3+0x128>
  101781:	8b 45 e8             	mov    -0x18(%ebp),%eax
  101784:	29 d0                	sub    %edx,%eax
  101786:	19 ce                	sbb    %ecx,%esi
  101788:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10178c:	89 f2                	mov    %esi,%edx
  10178e:	d3 e8                	shr    %cl,%eax
  101790:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  101794:	d3 e2                	shl    %cl,%edx
  101796:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  10179a:	09 d0                	or     %edx,%eax
  10179c:	89 f2                	mov    %esi,%edx
  10179e:	d3 ea                	shr    %cl,%edx
  1017a0:	8d 64 24 20          	lea    0x20(%esp),%esp
  1017a4:	5e                   	pop    %esi
  1017a5:	5f                   	pop    %edi
  1017a6:	5d                   	pop    %ebp
  1017a7:	c3                   	ret    
  1017a8:	39 fe                	cmp    %edi,%esi
  1017aa:	75 d5                	jne    101781 <__umoddi3+0x101>
  1017ac:	89 f9                	mov    %edi,%ecx
  1017ae:	89 c2                	mov    %eax,%edx
  1017b0:	2b 55 f4             	sub    -0xc(%ebp),%edx
  1017b3:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
  1017b6:	eb c9                	jmp    101781 <__umoddi3+0x101>
  1017b8:	39 f7                	cmp    %esi,%edi
  1017ba:	0f 82 10 ff ff ff    	jb     1016d0 <__umoddi3+0x50>
  1017c0:	e9 17 ff ff ff       	jmp    1016dc <__umoddi3+0x5c>

<<<<<<< HEAD
# Lab2

### 实验目的

1.熟悉MITJOS的内存组织结构

2.实现JOS的内存分配

3.理解虚拟内存和物理内存，理解两者的映射关系

4.实现JOS的页式内存管理

### Lab2介绍

通过该Lab，我们将为操作系统编写内存管理代码。内存管理包含两部分。

+ 第⼀部分是为操作系统内核(kernel)进⾏物理内存分配。物理内存分配以⻚页为单位，每⻚页4096个字 节。
+ 第⼆部分是虚拟内存管理，虚拟内存将内核和⽤户使⽤的虚拟地址映射到物理地址。x86系统通过 内存管理单元 MMU(memory management unit)实现映射。

## Part 1: Physical Page Management

JOS在boot loader中实现了分段，在kernel中实现了分页，在lab1中采用的分页是极其简单的分页，只是个单级的页表结构，所以在lab2中主要目的就是构建二级页表结构。

其中JOS的虚拟内存分布如下：

![img](https://pic3.zhimg.com/80/v2-f7e564b152a66eff35d6af8a3f3a4c2e_720w.jpg)

其分页机制如下：

![img](https://pic3.zhimg.com/80/v2-9fa694b8b23373b09702a1217ff5f4a3_720w.jpg)

操作系统需要知道RAM上物理地址哪⼀块是 free的 哪⼀块正在被使⽤。操作系统通过把物理地址按照页为单位做最⼩划分,⽤上MMU(内存管理单元位于CPU上)进⾏管理.

在这⼀部分，我们要实现物理页的分配(allocator),要使⽤ struct PageInfo 的链表结构，链表每⼀项 ⼀⼀对应⼀个物理地址。

### Exexcise 1

> Exercise 1. In the file kern/pmap.c, you must implement code for the following functions (probably in the order given).
>
> boot_alloc() mem_init() (only up to the call to check_page_free_list(1)) page_init() page_alloc() page_free()
>
> check_page_free_list() and check_page_alloc() test your physical page allocator. You should boot JOS and see whether check_page_alloc() reports success. Fix your code so that it passes. You may find it helpful to add your own assert()s to verify that your assumptions are correct.

我们需要实现 `kern/pmap.c` 中的下列函数

```c
boot_alloc() 
mem_init() (only up to the call to check_page_free_list(1)) 
page_init() 
page_alloc() 
page_free()
```

`check_page_free_list()` 和 `check_page_alloc()` ⽤于测试正确性。

#### boot_alloc()

`boot_alloc()` 为物理地址的allocator

函数 `static void * boot_alloc(n)` 接受参数n

+ 如果n>0且能分配n bytes的连续空间,则分配,不需要初始化,返回⼀个内核虚拟地址 
+ 如果n==0 返回下⼀个空闲⻚页的地址 但不进⾏allocte 
+ 如果越界 则panic 
+ 该函数在初始化时执⾏

整个逻辑实现为

```c
static void *boot_alloc(uint32_t n){
  static char *netxfree;//virtual address of next byte of free memory
  char *result;
  
  // Initialize nextfree if this is the first time.
  // 'end' is a magic symbol automatically generated by the linker, // which points to the end of the kernel's bss segment:
  // the first virtual address that the linker did *not* assign // to any kernel code or global variables.
  if(!netxfree){
    extern char end[];
    nextfree = ROUNDUP((char*)end,PGSIZE);
  }
  
  // Allocate a chunk large enough to hold 'n' bytes, then update // nextfree. Make sure nextfree is kept aligned 
  // to a multiple of PGSIZE.
  // LAB 2: Your code here.
  if(n > 0) {
    result = nextfree; 
    nextfree = ROUNDUP((char*)(nextfree+n), PGSIZE); 
    if((uint32_t)nextfree - KERNBASE > (npages*PGSIZE)) {
      panic("Out Of Memory!\n");
    } 
    return result;
} else if(n == 0) 
    return nextfree; 
  return NULL;
}
```

#### mem_init()

根据待完成部分的注释，完成如下：

```c
////////////////////////////////////////////////////////////////////// 
// Allocate an array of npages 'struct PageInfo's and store it in 'pages'. 
// The kernel uses this array to keep track of physical pages: for 
// each physical page, there is a corresponding struct PageInfo in this 
// array. 'npages' is the number of physical pages in memory.

// Your code goes here:

pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo) * npages);
```

#### page_init()

开始实现 `page_init()` 我们要⽤PageInfo链表pages来记录哪些物理地址是空闲的，我们需要按照注 释中所说的按不同段进⾏初始化。

 来看⼀下分层 

+ `0x000000~0x0A0000(npages_basemem*PGSIZE or IOPHYSMEM)` ,basemem，是可⽤ 的。 `npages_basemem` 记录basemem的页数 
+ `0x0A0000(IOPHYSMEM)~0x100000(EXTPHYSMEM)` ，这部分叫做IO hole，是不可⽤的，主要被⽤ 来分配给外部设备了。
+ `0x100000(EXTPHYSMEM)~0x???` 部分空闲，部分已被使⽤。 `npages_extmem` 记录extmem的⻚页 数。 

整个逻辑实现为

```c
void page_init(void) {
  // The example code here marks all physical pages as free.
  // However this is not truly the case.  What memory is free?
  //  1) Mark physical page 0 as in use.
  //     This way we preserve the real-mode IDT and BIOS structures
  //     in case we ever need them.  (Currently we don't, but...)
  //  2) The rest of base memory, [PGSIZE, npages_basemem * PGSIZE)
  //     is free.
  //  3) Then comes the IO hole [IOPHYSMEM, EXTPHYSMEM), which must
  //     never be allocated.
  //  4) Then extended memory [EXTPHYSMEM, ...).
  //     Some of it is in use, some is free. Where is the kernel
  //     in physical memory?  Which pages are already in use for
  //     page tables and other data structures?
  //
  // Change the code to reflect this.
  // NB: DO NOT actually touch the physical memory corresponding to
  // free pages!
  size_t i;
  for (i = 1; i < npages_basemem; i++) {
    pages[i].pp_ref = 0;
    pages[i].pp_link = page_free_list;
    page_free_list = &pages[i];
  }
  int med = (int)ROUNDUP(((char *)pages) + (sizeof(struct PageInfo) * npages) -
                             0xf0000000,
                         PGSIZE) /
            PGSIZE;
  //cprintf("pageinfo size: %d\n", sizeof(struct PageInfo));
  //cprintf("%x\n", ((char *)pages) + (sizeof(struct PageInfo) * npages));
  //cprintf("med=%d\n", med);
  for (i = med; i < npages; i++) {
    pages[i].pp_ref = 0;
    pages[i].pp_link = page_free_list;
    page_free_list = &pages[i];
  }
}
```

#### Page_alloc()

下面开始实现`page_alloc()`注释中有清零条件`(alloc_flags & ALLOC_ZERO)`，以及超界返回NULL 思路为从链表上取头部如果⾮空且需要初始化，则通过辅助函数初始化为零。对 `free_list` 移动并返 回申请到的`PageInfo`。 

实现如下

```c
// Allocates a physical page.  If (alloc_flags & ALLOC_ZERO), fills the entire
// returned physical page with '\0' bytes.  Does NOT increment the reference
// count of the page - the caller must do these if necessary (either explicitly
// or via page_insert).
//
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *page_alloc(int alloc_flags) {
  if (page_free_list) {
    struct PageInfo *ret = page_free_list;
    page_free_list = page_free_list->pp_link;
    if (alloc_flags & ALLOC_ZERO)
      memset(page2kva(ret), 0, PGSIZE);
    return ret;
  }
  return NULL;
}
```

#### page_free

free 和alloc对应，需要把⼀⻚页 重新加⼊ `free_list` 

实现如下

```c
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void page_free(struct PageInfo *pp) {
  pp->pp_link = page_free_list;
  page_free_list = pp;
}
```

测试`make grade`可以得到：

```bash
Physical page allocator: OK
```

## Part 2: Virtual Memory

### Exercise 2

>  Look at chapters 5 and 6 of the [Intel 80386 Reference Manual](https://pdos.csail.mit.edu/6.828/2018/readings/i386/toc.htm), if you haven't done so already. Read the sections about page translation and page-based protection closely (5.2 and 6.4). We recommend that you also skim the sections about segmentation; while JOS uses the paging hardware for virtual memory and protection, segment translation and segment-based protection cannot be disabled on the x86, so you will need a basic understanding of it.

x86保护模式下的内存管理结构有：逻辑地址->线性地址->物理地址

通常，线性地址 = 逻辑地址 + 段首地址

在x86中，线性地址 = 逻辑地址 + 0x00000000，逻辑地址和线性地址相等，因此该部分的关注点在于利用页来做转换，看作虚拟地址 = 线性地址即可。

接下来是实现线性地址到物理地址部分的转换：

+ 首先CPU得到一个地址，看看页的开关有没有开（该开关在CR0上，见entry.S的设置）没有的话就直接视为物理地址访问
+ 打开了的话则需要把这个地址给MMU
+ MMU去TL寻找，如果找到就访问对应物理地址
+ 没有的话，就告诉CPU，CPU安排虚拟地址对应的物理地址，安排好了写入TLB，返回MMU

对于一个具体的地址32位[31...22]为DIR，[21...12]为page，[11...0]为offset偏移量

+ 第一步通过CR3存的地址（entry.S中设置）找到PAGE DISRECTION页目录
+ 通过DIR作为偏移量，定位到PAGE TABLE页表
+ 通过page作为偏移量，定位到页表的具体一个项，PAGE TABLE ENTRY
+ 以该项的值定位到物理页
+ 以offset定位到该物理页的物理地址

页表的每一项是一个32位数，页表本身也是一个页，因此4KB页能存4KB/32bit=1024项，一项对应一页，一共可以映射1024*4KB=4MB的虚拟内存

上面的DIR、page、offset分化则[31...12]就算分为2层也是共同确定一页，可以确定$2^{20}$页，也就是一共可以映射4GB虚拟内存，就是1M页，和4GB虚拟内存相关。

### Exercise 3

=======
# 操作系统课程设计
>>>>>>> 5749bec1d2c6ae03905803c71353d1d3c0a25966


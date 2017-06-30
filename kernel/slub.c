#include <kernel/slub.h>
#include <inc/list.h>
#include <inc/types.h>
#include <inc/string.h>
#include <inc/stdio.h>
#include <kernel/mem.h>

struct slab_t {
    int ref;                       
    struct kmem_cache_t *cachep;              
    uint16_t inuse;
    uint16_t free;
    struct slab_t *next; 
}; 

// The number of sized cache : 16, 32, 64, 128, 256, 512, 1024, 2048
#define SIZED_CACHE_NUM     8
#define SIZED_CACHE_MIN     16
#define SIZED_CACHE_MAX     2048

#define le2slab(le,link)    ((struct slab_t*)le2page((struct PageInfo*)le,link))
#define slab2kva(slab)      (page2kva((struct PageInfo*)slab))

static struct kmem_cache_t *cache_chain;
static struct kmem_cache_t cache_cache;
static struct kmem_cache_t *sized_caches[SIZED_CACHE_NUM];
static char *cache_cache_name = "cache";
static char *sized_cache_name = "sized";

void add_before(struct slab_t *a, struct slab_t *b){
	b->next = a;
	a=b;
}

// kmem_cache_grow - add a free slab
static void *
kmem_cache_grow(struct kmem_cache_t *cachep) {
    struct PageInfo *page = page_alloc(1);
    void *kva = page2kva(page);
    // Init slub meta data
    struct slab_t *slab = (struct slab_t *) page;
    slab->cachep = cachep;
    slab->inuse = slab->free = 0;
//    add_before(cachep->slabs_free, slab);
	slab->next = cachep->slabs_free;
	cachep->slabs_free = slab;

	// Init bufctl
    int16_t *bufctl = kva;
    int i;
	for (i = 1; i < cachep->num; i++)
        bufctl[i-1] = i;
    bufctl[cachep->num-1] = -1;
    // Init cache 
    void *buf = bufctl + cachep->num;
    void *p;
	if (cachep->ctor)
		for (p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
            cachep->ctor(p, cachep, cachep->objsize);
    return slab;
}

// kmem_slab_destroy - destroy a slab
static void
kmem_slab_destroy(struct kmem_cache_t *cachep, struct slab_t *slab) {
    // Destruct cache
    struct PageInfo *page = (struct PageInfo *) slab;
    int16_t *bufctl = page2kva(page);
    void *buf = bufctl + cachep->num;
    void *p;
	if (cachep->dtor)
        for (p = buf; p < buf + cachep->objsize * cachep->num; p += cachep->objsize)
            cachep->dtor(p, cachep, cachep->objsize);
    // Return slub page 
    //list_del(&(page->page_link));
    page_free(page);
}

static int 
kmem_sized_index(size_t size) {
    // Round up 
    size_t rsize = ROUNDUP(size, 2);
    if (rsize < SIZED_CACHE_MIN)
        rsize = SIZED_CACHE_MIN;
    // Find index
    int index = 0;
	int t;
    for (t = rsize / 32; t; t /= 2)
        index ++;
    return index;
}

// ! Test code
#define TEST_OBJECT_LENTH 2046
#define TEST_OBJECT_CTVAL 0x22
#define TEST_OBJECT_DTVAL 0x11

static const char *test_object_name = "test";

struct test_object {
    char test_member[TEST_OBJECT_LENTH];
};

static void
test_ctor(void* objp, struct kmem_cache_t * cachep, size_t size) {
    char *p = objp;
    int i;
	for (i = 0; i < size; i++)
        p[i] = TEST_OBJECT_CTVAL;
}

static void
test_dtor(void* objp, struct kmem_cache_t * cachep, size_t size) {
    char *p = objp;
    int i;
	for (i = 0; i < size; i++)
        p[i] = TEST_OBJECT_DTVAL;
}

static size_t 
list_length(list_entry_t *listelm) {
    size_t len = 0;
    list_entry_t *le = listelm;
    while ((le = list_next(le)) != listelm)
        len ++;
    return len;
}

static void 
check_kmem() {

    //assert(sizeof(struct PageInfo) == sizeof(struct slab_t));

    size_t fp = sys_get_num_free_page();

    // Create a cache 
    struct kmem_cache_t *cp0 = kmem_cache_create(test_object_name, sizeof(struct test_object), test_ctor, test_dtor);
    assert(cp0 != NULL);
    assert(kmem_cache_size(cp0) == sizeof(struct test_object));
    assert(strcmp(kmem_cache_name(cp0), test_object_name) == 0);
    // Allocate six objects
    struct test_object *p0, *p1, *p2, *p3, *p4, *p5;
    char *p;
    assert((p0 = kmem_cache_alloc(cp0)) != NULL);
    assert((p1 = kmem_cache_alloc(cp0)) != NULL);
    assert((p2 = kmem_cache_alloc(cp0)) != NULL);
    assert((p3 = kmem_cache_alloc(cp0)) != NULL);
    assert((p4 = kmem_cache_alloc(cp0)) != NULL);
    p = (char *) p4;
    int i;
	for (i = 0; i < sizeof(struct test_object); i++)
        assert(p[i] == TEST_OBJECT_CTVAL);
    assert((p5 = kmem_cache_zalloc(cp0)) != NULL);
    p = (char *) p5;
    for (i = 0; i < sizeof(struct test_object); i++)
        assert(p[i] == 0);
    assert(sys_get_num_free_page()+3 == fp);
    assert(cp0->slabs_free == NULL);
    assert(cp0->slabs_partial == NULL);
    assert(cp0->slabs_full == NULL);
    // Free three objects 
    kmem_cache_free(cp0, p3);
    kmem_cache_free(cp0, p4);
    kmem_cache_free(cp0, p5);
    //assert(list_length(&(cp0->slabs_free)) == 1);
    //assert(list_length(&(cp0->slabs_partial)) == 1);
    //assert(list_length(&(cp0->slabs_full)) == 1);
    // Shrink cache 
    assert(kmem_cache_shrink(cp0) == 1);
    assert(sys_get_num_free_page()+2 == fp);
    assert(cp0->slabs_free == NULL);
    p = (char *) p4;
    for (i = 0; i < sizeof(struct test_object); i++)
        assert(p[i] == TEST_OBJECT_DTVAL);
    // Reap cache 
    kmem_cache_free(cp0, p0);
    kmem_cache_free(cp0, p1);
    kmem_cache_free(cp0, p2);
    assert(kmem_cache_reap() == 2);
    assert(sys_get_num_free_page() == fp);
    // Destory a cache 
    kmem_cache_destroy(cp0);

    // Sized alloc 
    assert((p0 = kmalloc(2048)) != NULL);
    assert(sys_get_num_free_page()+1 == fp);
    kfree(p0);
    assert(kmem_cache_reap() == 1);
    assert(sys_get_num_free_page() == fp);

    cprintf("check_kmem() succeeded!\n");

}
// ! End of test code

// kmem_cache_create - create a kmem_cache
struct kmem_cache_t *
kmem_cache_create(const char *name, size_t size,
                       void (*ctor)(void*, struct kmem_cache_t *, size_t),
                       void (*dtor)(void*, struct kmem_cache_t *, size_t)) {
    assert(size <= (PGSIZE - 2));
    struct kmem_cache_t *cachep = kmem_cache_alloc(&(cache_cache));
    if (cachep != NULL) {
        cachep->objsize = size;
        cachep->num = PGSIZE / (sizeof(int16_t) + size);
        cachep->ctor = ctor;
        cachep->dtor = dtor;
        memcpy(cachep->name, name, CACHE_NAMELEN);
		cachep->slabs_full = NULL;
		cachep->slabs_partial = NULL;
		cachep->slabs_free = NULL;

		cachep->cache_link = cache_chain;
		cache_chain = cachep;
    }
    return cachep;
}

// kmem_cache_destroy - destroy a kmem_cache
void 
kmem_cache_destroy(struct kmem_cache_t *cachep) {
    list_entry_t *head, *le;
    // Destory full slabs
    le = cachep->slabs_full;
    while (le != NULL) {
        struct slab_t *temp = le;
        le = le->next;
        kmem_slab_destroy(cachep, temp);
    }
    // Destory partial slabs 
    le = cachep->slabs_partial;
    while (le != NULL) {
        struct slab_t *temp = le;
        le = le->next;
        kmem_slab_destroy(cachep, temp);
    }
    // Destory free slabs 
    le = cachep->slabs_free;
    while (le != NULL) {
        struct slab_t *temp = le;
        le = le->next;
        kmem_slab_destroy(cachep, temp);
    }
    // Free kmem_cache 
    kmem_cache_free(&(cache_cache), cachep);
}   

// kmem_cache_alloc - allocate an object
void *
kmem_cache_alloc(struct kmem_cache_t *cachep) {
    struct slab_t *le = NULL;
    // Find in partial list 
    if (cachep->slabs_partial != NULL){
        le = cachep->slabs_partial;
		cachep->slabs_partial = cachep->slabs_partial->next;
	}
    // Find in empty list 
    else {
		if ((cachep->slabs_free == NULL) && kmem_cache_grow(cachep) == NULL)
            return NULL;
        le = cachep->slabs_free;
		cachep->slabs_free = cachep->slabs_free->next;
    }
    // Alloc 
    struct slab_t *slab = le;
	struct PageInfo *p = le;
    void *kva = page2kva(p);
    int16_t *bufctl = kva;
    void *buf = bufctl + cachep->num;
    void *objp = buf + slab->free * cachep->objsize;
    // Update slab
    slab->inuse ++;
    slab->free = bufctl[slab->free];
    if (slab->inuse == cachep->num)
        add_before(cachep->slabs_full, slab);
    else 
        add_before(cachep->slabs_partial, slab);
    return objp;
}

// kmem_cache_zalloc - allocate an object and fill it with zero
void *
kmem_cache_zalloc(struct kmem_cache_t *cachep) {
    void *objp = kmem_cache_alloc(cachep);
    memset(objp, 0, cachep->objsize);
    return objp;
}

// kmem_cache_free - free an object
void 
kmem_cache_free(struct kmem_cache_t *cachep, void *objp) {
    // Get slab of object 
    //void *base = page2kva(pages);
    //void *kva = ROUNDDOWN(objp, PGSIZE);
    struct slab_t *slab = (struct slab_t *)pa2page(PADDR(objp));
    // Get offset in slab
    struct PageInfo *p = slab;
	int16_t *bufctl = page2kva(p);
    void *buf = bufctl + cachep->num;
    int offset = (objp - buf) / cachep->objsize;
    
	// delete slab 
    struct slab_t *temp, *pre;
   	int flag=1;
	while(flag){
		// check slabs_full
		temp = cachep->slabs_full;
		pre = NULL;
		while(temp != NULL){
			if(temp == slab){
				flag = 0;
				pre->next = temp->next;
				break;
			}
			pre = temp;
			temp = temp->next;
		}

		if(flag == 0) break;
		
		// check slabs_partial
		temp = cachep->slabs_partial;
		pre = NULL;
		while(temp != NULL){
			if(temp == slab){
				flag = 0;
				pre->next = temp->next;
				break;
			}
			pre = temp;
			temp = temp->next;
		}

	}
    // Update slab 
	bufctl[offset] = slab->free;
    slab->inuse --;
    slab->free = offset;
    if (slab->inuse == 0)
        add_before(cachep->slabs_free, slab);
    else 
        add_before(cachep->slabs_partial, slab);
}

// kmem_cache_size - get object size
size_t 
kmem_cache_size(struct kmem_cache_t *cachep) {
    return cachep->objsize;
}

// kmem_cache_name - get cache name
const char *
kmem_cache_name(struct kmem_cache_t *cachep) {
    return cachep->name;
}

// kmem_cache_shrink - destroy all slabs in free list 
int 
kmem_cache_shrink(struct kmem_cache_t *cachep) {
    int count = 0;
    struct slab_t *le = cachep->slabs_free;
    while (le != NULL) {
        struct slab_t *temp = le;
        le = le->next;
        kmem_slab_destroy(cachep, temp);
        count ++;
    }
    return count;
}

// kmem_cache_reap - reap all free slabs 
int 
kmem_cache_reap() {
    int count = 0;
    struct kmem_cache_t *le = cache_chain;
    while ((le = cache_chain->cache_link) != NULL)
        count += kmem_cache_shrink(le);
    return count;
}

void *
kmalloc(size_t size) {
    assert(size <= SIZED_CACHE_MAX);
    return kmem_cache_alloc(sized_caches[kmem_sized_index(size)]);
}

void 
kfree(void *objp) {
	struct slab_t *slab = (struct slab_t *)pa2page(PADDR(objp));
    kmem_cache_free(slab->cachep, objp);
}

void
kmem_init() {

    // Init cache for kmem_cache
	cache_cache.objsize = sizeof(struct kmem_cache_t);
	cache_cache.num = PGSIZE / (sizeof(int16_t) + sizeof(struct kmem_cache_t));
    cache_cache.ctor = NULL;
    cache_cache.dtor = NULL;
    memcpy(cache_cache.name, cache_cache_name, CACHE_NAMELEN);
	cache_cache.slabs_full = NULL;
	cache_cache.slabs_partial = NULL;
	cache_cache.slabs_free = NULL;
	cache_chain = NULL;

	int i,size;
    // Init sized cache 
    for (i = 0, size = 16; i < SIZED_CACHE_NUM; i++, size *= 2)
        sized_caches[i] = kmem_cache_create(sized_cache_name, size, NULL, NULL); 

}

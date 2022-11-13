#define main HariMain
void io_hlt(void);
void main(void)
{
fin:
	io_hlt();
	goto fin;
}
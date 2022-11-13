#define main HariMain

void io_hlt();
void write_mem8(int addr, int data);

int main()
{
	int i;
	for (i = 0xa0000; i <= 0xaffff; ++i)
	{
		write_mem8(i, 15);
	}
	while (1)
	{
		io_hlt();
	}
}
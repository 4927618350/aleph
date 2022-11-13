#define main HariMain

void io_hlt();

int main()
{
	int i;
	char *p = 0xa0000;
	for (i = 0; i <= 0xffff; ++i)
	{
		p[i] = i & 0x0f;
	}
	while (1)
	{
		io_hlt();
	}
}
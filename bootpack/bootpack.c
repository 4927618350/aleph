#define main HariMain

typedef struct
{
	unsigned char r, g, b;

} rgb;
rgb table_rgb[16];

void io_hlt();
void io_cli();
void io_out8(int port, int data);
int io_load_eflags();
void io_store_eflags(int eflags);
void init_palette();
void set_palette(int start, int end, rgb *_rgb);
void io_hlt();

int main()
{
	int i;
	char *p;
	init_palette();
	p = (char *)0xa0000;
	for (i = 0; i <= 0xffff; ++i)
	{
		p[i] = i % 64;
	}
	while (1)
	{
		io_hlt();
	}
}

void init_palette()
{
	table_rgb[0] = (rgb){0x00, 0x00, 0x00};	 // 黑
	table_rgb[1] = (rgb){0xff, 0x00, 0x00};	 // 红
	table_rgb[2] = (rgb){0x00, 0xff, 0x00};	 // 绿
	table_rgb[3] = (rgb){0xff, 0xff, 0x00};	 // 黄
	table_rgb[4] = (rgb){0x00, 0x00, 0xff};	 // 蓝
	table_rgb[5] = (rgb){0xff, 0x00, 0xff};	 // 紫
	table_rgb[6] = (rgb){0x00, 0xff, 0xff};	 // 青
	table_rgb[7] = (rgb){0xff, 0xff, 0xff};	 // 白
	table_rgb[8] = (rgb){0xc6, 0xc6, 0xc6};	 // 灰
	table_rgb[9] = (rgb){0x84, 0x00, 0x00};	 // 暗红
	table_rgb[10] = (rgb){0x00, 0x84, 0x00}; // 暗绿
	table_rgb[11] = (rgb){0x84, 0x84, 0x00}; // 暗黄
	table_rgb[12] = (rgb){0x00, 0x00, 0x84}; // 暗蓝
	table_rgb[13] = (rgb){0x84, 0x00, 0x84}; // 暗紫
	table_rgb[14] = (rgb){0x00, 0x84, 0x84}; // 暗青
	table_rgb[15] = (rgb){0x84, 0x84, 0x84}; // 暗灰
	set_palette(0, 15, table_rgb);
	return;
}

void set_palette(int start, int end, rgb *_rgb)
{
	int i, eflag;
	eflag = io_load_eflags();				// 记录中断许可标志
	io_cli();								// 中断许可标志为0 禁止中断
	io_out8(0x03c8, start);
	for (i = start; i <= end; ++i)
	{
		io_out8(0x03c9, _rgb[i].r / 4);
		io_out8(0x03c9, _rgb[i].g / 4);
		io_out8(0x03c9, _rgb[i].b / 4);
	}
	io_store_eflags(eflag);					// 恢复中断许可标志
	return;
}

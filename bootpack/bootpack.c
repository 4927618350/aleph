#define main HariMain

#define COL8_000000 0
#define COL8_FF0000 1
#define COL8_00FF00 2
#define COL8_FFFF00 3
#define COL8_0000FF 4
#define COL8_FF00FF 5
#define COL8_00FFFF 6
#define COL8_FFFFFF 7
#define COL8_C6C6C6 8
#define COL8_840000 9
#define COL8_008400 10
#define COL8_848400 11
#define COL8_000084 12
#define COL8_840084 13
#define COL8_008484 14
#define COL8_848484 15

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
void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x1, int y1, int x2, int y2);

int main()
{
	char *vram;
	int xsize, ysize;

	init_palette();

	vram = (char *)0xa0000;
	xsize = 320;
	ysize = 200;

	boxfill8(vram, xsize, COL8_008484, 0, 0, xsize - 1, ysize - 29);
	boxfill8(vram, xsize, COL8_C6C6C6, 0, ysize - 28, xsize - 1, ysize - 28);
	boxfill8(vram, xsize, COL8_FFFFFF, 0, ysize - 27, xsize - 1, ysize - 27);
	boxfill8(vram, xsize, COL8_C6C6C6, 0, ysize - 26, xsize - 1, ysize - 1);

	boxfill8(vram, xsize, COL8_FFFFFF, 3, ysize - 24, 59, ysize - 24);
	boxfill8(vram, xsize, COL8_FFFFFF, 2, ysize - 24, 2, ysize - 4);
	boxfill8(vram, xsize, COL8_848484, 3, ysize - 4, 59, ysize - 4);
	boxfill8(vram, xsize, COL8_848484, 59, ysize - 23, 59, ysize - 5);
	boxfill8(vram, xsize, COL8_000000, 2, ysize - 3, 59, ysize - 3);
	boxfill8(vram, xsize, COL8_000000, 60, ysize - 24, 60, ysize - 3);

	boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 24, xsize - 4, ysize - 24);
	boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 23, xsize - 47, ysize - 4);
	boxfill8(vram, xsize, COL8_FFFFFF, xsize - 47, ysize - 3, xsize - 4, ysize - 3);
	boxfill8(vram, xsize, COL8_FFFFFF, xsize - 3, ysize - 24, xsize - 3, ysize - 3);

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
	eflag = io_load_eflags(); // 记录中断许可标志
	io_cli();				  // 中断许可标志为0 禁止中断
	io_out8(0x03c8, start);
	for (i = start; i <= end; ++i)
	{
		io_out8(0x03c9, _rgb[i].r / 4);
		io_out8(0x03c9, _rgb[i].g / 4);
		io_out8(0x03c9, _rgb[i].b / 4);
	}
	io_store_eflags(eflag); // 恢复中断许可标志
	return;
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x1, int y1, int x2, int y2)
{
	int x, y;
	for (y = y1; y <= y2; ++y)
	{
		for (x = x1; x <= x2; ++x)
			vram[y * xsize + x] = c;
	}
	return;
}

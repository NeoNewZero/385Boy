/*---------------------------------------------------------------------------
  --      hello_world.c                                                    --
  --      Christine Chen                                                   --
  --      Fall 2013														   --
  --																	   --
  --      Updated Spring 2015 											   --
  --	  Yi Liang														   --
  --																	   --
  --      For use with ECE 385 Experiment 9                                --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/


#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"

// TODO: AES Encryption related function calls

#define red 0xe0
#define green 0x1c
#define blue 0x03
#define yellow 0xfc
#define cyan 0x1f
#define magenta 0xe3
#define white 0xff
#define black 0x0000
#define uchar unsigned char
#define RGB2COLOR(r, g, b) ((((r>>3)<<11) | ((g>>2)<<5) | (b>>3)));


  	volatile short * pixel_buffer = (short *) 0x10000000;
  	unsigned short ** back_buffer_reg = (short **) 0x10203094;
  	unsigned short ** buffer_reg = (short **) 0x10203090;
  	volatile short * back_buffer = (short *) (0x00096000);
  	volatile unsigned short * address = (unsigned short *) 0x10203020;
  	volatile uchar * data_in = (uchar *) 0x10203030;
  	volatile uchar * line = (uchar *)0x0;
	short gbDisplay[65536];

int n;
uchar getGbMem(unsigned short addr)
{
	int i;
	IOWR_ALTERA_AVALON_PIO_DATA(0x10203020, addr);
	return (uchar) IORD_ALTERA_AVALON_PIO_DATA(0x10203030);

}
int main(void)
{
	int i,j;
	printf("STARTEd");
	for(i=0;i<320;i++)
			for(j=0;j<240;j++)
				pixel_buffer[i+j*320]=RGB2COLOR(0x00,0x00,0x00);
	while(1)
	{

		int ad;
	//	scanf("%x",&ad);
		//uchar val = getGbMem((unsigned short)ad);
		//printf("\naddr: %x \nval:%x\n",(unsigned short)ad,val);
		build_gb_screen();

		for(i=0;i<160;i++)
			for(j=0;j<144;j++)
				pixel_buffer[i+j*320]=gbDisplay[i+j*256];
	}
}
short getColorBG(uchar gbidx)
{
	switch(gbidx)
	{
	case 0x00:
		return RGB2COLOR(0xFF,0xff,0xff);


	break;
	case 0x01:
		return RGB2COLOR(100,100,100);
	break;
	case 0x02:
		return RGB2COLOR(50,50,50);
	break;
	case 0x03:
		return RGB2COLOR(0,0,0);

	break;
	}
}
short getColorSprite(uchar gbid,uchar x,uchar y,uchar pallet_num)
{
	switch(gbid)
	{
	case 0:
		return gbDisplay[x+y*256];

	break;
	case 1:
		return RGB2COLOR(200,200,200);
	break;
	case 2:
		return RGB2COLOR(70,70,70);
	break;
	case 3:
		return RGB2COLOR(0,0,0);
	break;
	}
}
void build_gb_screen()
{
	int i,j,k,l;
	unsigned short tilePtr;
	tilePtr = 0x8800;
	unsigned short bgTileMap = 0x9800;
	unsigned short windowTileMap = 0x9800;
	unsigned short bgWindowTileData = 0x8800;
	uchar LCDC = getGbMem(0xff40);
	uchar dispBackground = LCDC & 0x01; //b0
	uchar dispSprite = LCDC & 0x02;  //b1
	uchar spriteSize = LCDC &0x04; //b2
	uchar signedIndex = LCDC & 0x08;
	if(LCDC & 0x08)
		bgTileMap = 0x9800;
	if(LCDC & 0x10)
		bgWindowTileData = 0x8000;
	uchar dispWindow = LCDC &0x20;
	if(LCDC & 0x40)   //b
		windowTileMap = 0x9C00;
	uchar doLcd = LCDC & 0x80;


		if(dispBackground)
		{
			printf("bg\n");

			for(i=0;i<32;i++)
				for(j=0;j<32;j++)
				{
					short bgtileoffset;
					if(signedIndex)
						bgtileoffset = (char) (getGbMem(bgTileMap+i+32*j))+128;
					else
						bgtileoffset = (getGbMem(bgTileMap+i+32*j));
				//	printf("%d X %d : %x\n",i,j,bgTileMap+bgtileoffset);
					int baseOffset=bgWindowTileData+bgtileoffset*16;
					for(k=0;k<8;k++)
						for(l=0;l<8;l++)
						{
							int shiftidx=7-k;

							uchar lb = ((getGbMem(baseOffset+l*2))>>shiftidx)&0x01;
							uchar hb = ((getGbMem(baseOffset+l*2+1))>>shiftidx)&0x01;
							uchar thecolor = ((hb<<1)&0x02) | lb;

						//	printf("\n%x\n\n",getGbMem(baseOffset));

							gbDisplay[(i*8+k)+(l+j*8)*256] = getColorBG(thecolor);
					}
				}
		}
		if(dispSprite)
		{
			printf("sprite\n");

			for(i=0;i<40;i++)
			{
				uchar x,y,tileNum,attributes,priority,x_flip,y_flip,pallet_num;
				short spriteBase = 0x8000;
				 x = getGbMem(0xFE00+4*i);
				 y = getGbMem(0xFE00+4*i+1);
				 if((x+y)==0)  //sprite is hidden
					 continue;
				 x-=8;
				 y-=16;
				 if(getGbMem(0xFE00+4*i+2))
					 tileNum = getGbMem(0xFE00+4*i+2) & 0xFFFE;
				 else
					 tileNum = getGbMem(0xFE00+4*i+2);

				 attributes = getGbMem(0xFE00+4*i+3);

				 priority = attributes & 0x80;
				 y_flip = attributes & 0x40;
				 x_flip = attributes & 0x20;
				 pallet_num = attributes &0x10;
				 short sprite_base = spriteBase + tileNum*16;
				 if(spriteSize)
				 {
					 for(j=0;j<8;j++)
							 for(k=0;k<8;k++)
								 {
									int shiftidx=7-k;

						uchar lb = ((getGbMem(spriteBase+l*2))>>shiftidx)&0x01;
						uchar hb = ((getGbMem(spriteBase+l*2+1))>>shiftidx)&0x01;
						uchar thecolor = ((hb<<1)&0x02) | lb;

						gbDisplay[(x+j)+(y+k)*256] = getColorSprite(thecolor,(x+j),y+k,pallet_num);
											 }
				 }
				 else
				 {
					 for(j=0;j<8;j++)
						 for(k=0;k<8;k++)
						 {

							 gbDisplay[(x+j)+(y+k)*256] = getColorSprite(((getGbMem( sprite_base + (k+8*l)/4) >> (6-((k+8*l)%4)*2))&0x03),(x+j),y+k,pallet_num);
						 }

				 }

			}
		}
		if(dispWindow)
		{
			printf("window\n");
		}

}

//memory access handler. This way NIOS Will always handle memory accesses even if its in the middle of a write
//void mem_access(void* context, alt_u32 id)
//{
//	int i;
//	uchar rd = *r;
//	uchar wr = *w;
//    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE, 0x1);
//
//	// volatile int* edge_capture_ptr = (volatile int*) context;
////	    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE);
////	    *edge_capture_ptr = 0;
////	     n++;
////	     IOWR_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE, 0);
////	   volatile int* edge_capture_ptr = (volatile int*) context; // volatile variable to avoid optimization...
////	    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE);    // Store edge capture register in *context.
////	    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE, 0);
////
//
//
//			 if(*address >= 0xFF00 && *address <= 0xFF7F)
//			{
//			//handle register accesses and special case
//				switch(*address)
//				{
//	//			case 0xFF00: //read button presses  *Removed so that it could be handled in hardware.
//	//
//	//			break;
//				case 0xFF40:
//					//LCDC
//
//				break;
//				case 0xFF41:	//LCDC STAT
//
//				break;
//				case 0xFF42:	//SCROLL Y
//					if(*w)
//					{
//						scrolly = *data_in;
//					}
//					if(*r)
//					{
//						*data_out = scrolly;
//					}
//				break;
//				case 0xFF43:	//SCROLL X
//					if(*w)
//					{
//						scrollx = *data_in;
//					}
//					if(*r)
//					{
//						*data_out = scrollx;
//					}
//					//do_ack();
//				break;
//				case 0xFF44:	//LCD_Y
//
//				break;
//				case 0xFF45:	//LY COMPARE
//
//				break;
//				case 0xFF46:	//DMA  on write we need to copy from src address to
//
//
//
//				break;
//				case 0xFF47:	// BG & Window Palette Data
//
//				break;
//				case 0xFF48:	//Object Palette 0 Data (R/W)
//
//				break;
//				case 0xFF49:	//Object Palette 1 Data (R/W)
//
//				break;
//				case 0xFF4A:	//Window Y
//
//				break;
//				case 0xFF4B:	//Window X
//
//				break;
//				default://unhandled register
//
//				break;
//			}
//				mem_ack();
//
//			}
//			else  //regular memory
//			{
////				if(*address > 256)
////					while(1);
//				int i;
//				if(rd)
//				{
//					*data_out = memory[*address];
//					mem_ack();
//
//						//*ready = (*ready)&0xFE;
//
//					printf("R: 0x%x at 0x%x\n",memory[*address],(unsigned short)(*address));
//
//
//				}
//				else if(wr)
//				{
//					memory[*address] = *data_in;
//					mem_ack();
//					printf("\nW: 0x%x at 0x%x\n",memory[*address],(unsigned short)(*address));
//
//				}
//
//			}
//			}
//void mem_ack()
//{
//						int i;
//						IOWR_ALTERA_AVALON_PIO_SET_BITS(READYBASE,1);
//						for(i=0;i<10000005;i++);
//						IOWR_ALTERA_AVALON_PIO_CLEAR_BITS(READYBASE,1);
//						//printf("hh");
//}
//		 volatile int* edge_capture_ptr = (volatile int*) context; // volatile variable to avoid optimization...
//		    *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE);    // Store edge capture register in *context.
//		    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE, 0);     // Reset edge capture register
//	IOWR_ALTERA_AVALON_PIO_EDGE_CAP(MEM_WR_BASE, 0);



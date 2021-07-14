
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _period=R4
	.DEF _period_msb=R5
	.DEF _new_angle=R6
	.DEF _new_angle_msb=R7
	.DEF _current_angle=R8
	.DEF _current_angle_msb=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x64,0x0,0x0,0x0
	.DB  0x0,0x0

_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/23/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;#include <stdlib.h>
;// #include <stddef.h>
;// Declare your global variables here
;int period = 100;
;int new_angle = 0;
;int current_angle = 0;
;// External Interrupt 2 service routine
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0023 {

	.CSEG
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0024     PORTD = 0b00001111;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0025     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0026 
; 0000 0027 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;void steer(int pot_val);
;void accelerate(int pot_value);
;
;void rotate_l_cw(int seq);
;void rotate_l_ccw(int seq);
;void rotate_r_cw(int seq);
;void rotate_r_ccw(int seq);
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (1<<ADLAR))
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char channel)
; 0000 0035 {
_read_adc:
; .FSTART _read_adc
; 0000 0036 
; 0000 0037     ADMUX = 0x40 | (1 << ADLAR) | (channel & 0x07);
	ST   -Y,R26
;	channel -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x7)
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0038 
; 0000 0039     ADCSRA |= (1<<ADSC);
	SBI  0x6,6
; 0000 003A 
; 0000 003B     while ((ADCSRA & (1 << ADSC)));
_0x3:
	SBIC 0x6,6
	RJMP _0x3
; 0000 003C 
; 0000 003D     delay_ms(60);
	LDI  R26,LOW(60)
	LDI  R27,0
	CALL _delay_ms
; 0000 003E 
; 0000 003F     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0040 }
; .FEND
;
;void main(void)
; 0000 0043 {
_main:
; .FSTART _main
; 0000 0044 // Declare your local variables here
; 0000 0045 
; 0000 0046 // Input/Output Ports initialization
; 0000 0047 // Port A initialization
; 0000 0048 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0049 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 004A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 004B PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 004C 
; 0000 004D // Port B initialization
; 0000 004E // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 004F DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(24)
	OUT  0x17,R30
; 0000 0050 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 0051 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0052 
; 0000 0053 // Port C initialization
; 0000 0054 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0055 DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0056 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0057 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0058 
; 0000 0059 // Port D initialization
; 0000 005A // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 005B DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 005C // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 005D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 005E 
; 0000 005F // Timer/Counter 0 initialization
; 0000 0060 // Clock source: System Clock
; 0000 0061 // Clock value: 125.000 kHz
; 0000 0062 // Mode: Fast PWM top=0xFF
; 0000 0063 // OC0 output: Non-Inverted PWM
; 0000 0064 // Timer Period: 2.048 ms
; 0000 0065 // Output Pulse(s):
; 0000 0066 // OC0 Period: 2.048 ms Width: 1.028 ms
; 0000 0067 TCCR0=(1<<WGM00) | (1<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(107)
	OUT  0x33,R30
; 0000 0068 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0069 OCR0=0x80;
	LDI  R30,LOW(128)
	OUT  0x3C,R30
; 0000 006A 
; 0000 006B // Timer/Counter 1 initialization
; 0000 006C // Clock source: System Clock
; 0000 006D // Clock value: Timer1 Stopped
; 0000 006E // Mode: Normal top=0xFFFF
; 0000 006F // OC1A output: Disconnected
; 0000 0070 // OC1B output: Disconnected
; 0000 0071 // Noise Canceler: Off
; 0000 0072 // Input Capture on Falling Edge
; 0000 0073 // Timer1 Overflow Interrupt: Off
; 0000 0074 // Input Capture Interrupt: Off
; 0000 0075 // Compare A Match Interrupt: Off
; 0000 0076 // Compare B Match Interrupt: Off
; 0000 0077 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0078 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0079 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 007A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 007B ICR1H=0x00;
	OUT  0x27,R30
; 0000 007C ICR1L=0x00;
	OUT  0x26,R30
; 0000 007D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 007E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 007F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0080 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0081 
; 0000 0082 // Timer/Counter 2 initialization
; 0000 0083 // Clock source: System Clock
; 0000 0084 // Clock value: Timer2 Stopped
; 0000 0085 // Mode: Normal top=0xFF
; 0000 0086 // OC2 output: Disconnected
; 0000 0087 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0088 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0089 TCNT2=0x00;
	OUT  0x24,R30
; 0000 008A OCR2=0x00;
	OUT  0x23,R30
; 0000 008B 
; 0000 008C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 008D TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 008E 
; 0000 008F // External Interrupt(s) initialization
; 0000 0090 // INT0: Off
; 0000 0091 // INT1: Off
; 0000 0092 // INT2: On
; 0000 0093 // INT2 Mode: Rising Edge
; 0000 0094 GICR|=(0<<INT1) | (0<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 0095 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0096 MCUCSR=(1<<ISC2);
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 0097 GIFR=(0<<INTF1) | (0<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 0098 
; 0000 0099 // USART initialization
; 0000 009A // USART disabled
; 0000 009B UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 009C 
; 0000 009D // Analog Comparator initialization
; 0000 009E // Analog Comparator: Off
; 0000 009F // The Analog Comparator's positive input is
; 0000 00A0 // connected to the AIN0 pin
; 0000 00A1 // The Analog Comparator's negative input is
; 0000 00A2 // connected to the AIN1 pin
; 0000 00A3 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A4 
; 0000 00A5 // ADC initialization
; 0000 00A6 // ADC Clock frequency: 1000.000 kHz
; 0000 00A7 // ADC Voltage Reference: AREF pin
; 0000 00A8 // ADC Auto Trigger Source: ADC Stopped
; 0000 00A9 // Only the 8 most significant bits of
; 0000 00AA // the AD conversion result are used
; 0000 00AB ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 00AC ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00AD SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AE 
; 0000 00AF // SPI initialization
; 0000 00B0 // SPI disabled
; 0000 00B1 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B2 
; 0000 00B3 // TWI initialization
; 0000 00B4 // TWI disabled
; 0000 00B5 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00B6 
; 0000 00B7 // Global enable interrupts
; 0000 00B8 #asm("sei")
	sei
; 0000 00B9 
; 0000 00BA while (1)
_0x6:
; 0000 00BB       {
; 0000 00BC 
; 0000 00BD           int engine = read_adc(1);
; 0000 00BE           int degree = read_adc(0);
; 0000 00BF 
; 0000 00C0           accelerate(engine);
	SBIW R28,4
;	engine -> Y+2
;	degree -> Y+0
	LDI  R26,LOW(1)
	RCALL _read_adc
	LDI  R31,0
	STD  Y+2,R30
	STD  Y+2+1,R31
	LDI  R26,LOW(0)
	RCALL _read_adc
	LDI  R31,0
	ST   Y,R30
	STD  Y+1,R31
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RCALL _accelerate
; 0000 00C1           steer(degree);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _steer
; 0000 00C2 
; 0000 00C3 
; 0000 00C4       }
	ADIW R28,4
	RJMP _0x6
; 0000 00C5 }
_0x9:
	RJMP _0x9
; .FEND
;void steer(int pot_val){
; 0000 00C6 void steer(int pot_val){
_steer:
; .FSTART _steer
; 0000 00C7     int n;
; 0000 00C8 
; 0000 00C9     switch (pot_val) {
	CALL SUBOPT_0x0
;	pot_val -> Y+2
;	n -> R16,R17
	LDD  R30,Y+2
	LDD  R31,Y+2+1
; 0000 00CA         case 0:
	SBIW R30,0
	BRNE _0xD
; 0000 00CB         new_angle = -180;
	LDI  R30,LOW(65356)
	LDI  R31,HIGH(65356)
	RJMP _0x39
; 0000 00CC         break;
; 0000 00CD 
; 0000 00CE         case 10:
_0xD:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0xE
; 0000 00CF         new_angle = -144;
	LDI  R30,LOW(65392)
	LDI  R31,HIGH(65392)
	RJMP _0x39
; 0000 00D0         break;
; 0000 00D1 
; 0000 00D2         case 21:
_0xE:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0xF
; 0000 00D3         new_angle = -108;
	LDI  R30,LOW(65428)
	LDI  R31,HIGH(65428)
	RJMP _0x39
; 0000 00D4         break;
; 0000 00D5 
; 0000 00D6         case 32:
_0xF:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x10
; 0000 00D7         new_angle = -72;
	LDI  R30,LOW(65464)
	LDI  R31,HIGH(65464)
	RJMP _0x39
; 0000 00D8         break;
; 0000 00D9 
; 0000 00DA         case 42:
_0x10:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x11
; 0000 00DB         new_angle = -36;
	LDI  R30,LOW(65500)
	LDI  R31,HIGH(65500)
	RJMP _0x39
; 0000 00DC         break;
; 0000 00DD 
; 0000 00DE         case 53:
_0x11:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x12
; 0000 00DF         new_angle = 0;
	CLR  R6
	CLR  R7
; 0000 00E0         break;
	RJMP _0xC
; 0000 00E1 
; 0000 00E2         case 64:
_0x12:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x13
; 0000 00E3         new_angle = 36;
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	RJMP _0x39
; 0000 00E4         break;
; 0000 00E5 
; 0000 00E6         case 74:
_0x13:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0x14
; 0000 00E7         new_angle = 72;
	LDI  R30,LOW(72)
	LDI  R31,HIGH(72)
	RJMP _0x39
; 0000 00E8         break;
; 0000 00E9 
; 0000 00EA         case 85:
_0x14:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x15
; 0000 00EB         new_angle = 108;
	LDI  R30,LOW(108)
	LDI  R31,HIGH(108)
	RJMP _0x39
; 0000 00EC         break;
; 0000 00ED 
; 0000 00EE         case 96:
_0x15:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x16
; 0000 00EF         new_angle = 144;
	LDI  R30,LOW(144)
	LDI  R31,HIGH(144)
	RJMP _0x39
; 0000 00F0         break;
; 0000 00F1 
; 0000 00F2         case 106:
_0x16:
	CPI  R30,LOW(0x6A)
	LDI  R26,HIGH(0x6A)
	CPC  R31,R26
	BRNE _0xC
; 0000 00F3         new_angle = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
_0x39:
	MOVW R6,R30
; 0000 00F4         break;
; 0000 00F5     }
_0xC:
; 0000 00F6 
; 0000 00F7     n = (new_angle - current_angle) / 36;
	MOVW R26,R6
	SUB  R26,R8
	SBC  R27,R9
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL __DIVW21
	MOVW R16,R30
; 0000 00F8 
; 0000 00F9 
; 0000 00FA     if (new_angle > 0) {
	CLR  R0
	CP   R0,R6
	CPC  R0,R7
	BRGE _0x18
; 0000 00FB         if (n > 0) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x19
; 0000 00FC             rotate_r_cw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_r_cw
; 0000 00FD         } else {
	RJMP _0x1A
_0x19:
; 0000 00FE             rotate_r_ccw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_r_ccw
; 0000 00FF         }
_0x1A:
; 0000 0100 
; 0000 0101     } else if (new_angle == 0) {
	RJMP _0x1B
_0x18:
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x1C
; 0000 0102 
; 0000 0103         if (current_angle > 0) {
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BRGE _0x1D
; 0000 0104             rotate_r_ccw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_r_ccw
; 0000 0105         } else {
	RJMP _0x1E
_0x1D:
; 0000 0106             rotate_l_cw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_l_cw
; 0000 0107         }
_0x1E:
; 0000 0108 
; 0000 0109     } else if (new_angle < 0){
	RJMP _0x1F
_0x1C:
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x20
; 0000 010A 
; 0000 010B         if (n > 0) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x21
; 0000 010C             rotate_l_cw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_l_cw
; 0000 010D         } else {
	RJMP _0x22
_0x21:
; 0000 010E             rotate_l_ccw(abs(n));
	CALL SUBOPT_0x1
	RCALL _rotate_l_ccw
; 0000 010F         }
_0x22:
; 0000 0110     }
; 0000 0111     current_angle = new_angle;
_0x20:
_0x1F:
_0x1B:
	MOVW R8,R6
; 0000 0112 }
	RJMP _0x2080001
; .FEND
;
;void rotate_l_cw(int seq){
; 0000 0114 void rotate_l_cw(int seq){
_rotate_l_cw:
; .FSTART _rotate_l_cw
; 0000 0115     int i;
; 0000 0116     for (i = 0; i < seq; i++) {
	CALL SUBOPT_0x0
;	seq -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x24:
	CALL SUBOPT_0x2
	BRGE _0x25
; 0000 0117         PORTC = 0b00000011;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
; 0000 0118         delay_ms(period);
; 0000 0119         PORTC = 0b00000110;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
; 0000 011A         delay_ms(period);
; 0000 011B         PORTC = 0b00001100;
	LDI  R30,LOW(12)
	CALL SUBOPT_0x3
; 0000 011C         delay_ms(period);
; 0000 011D         PORTC = 0b00001001;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x3
; 0000 011E         delay_ms(period);
; 0000 011F     }
	__ADDWRN 16,17,1
	RJMP _0x24
_0x25:
; 0000 0120 }
	RJMP _0x2080001
; .FEND
;//
;void rotate_l_ccw(int seq){
; 0000 0122 void rotate_l_ccw(int seq){
_rotate_l_ccw:
; .FSTART _rotate_l_ccw
; 0000 0123     int i;
; 0000 0124     for (i = 0; i < seq; i++) {
	CALL SUBOPT_0x0
;	seq -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x27:
	CALL SUBOPT_0x2
	BRGE _0x28
; 0000 0125         PORTC = 0b00001100;
	LDI  R30,LOW(12)
	CALL SUBOPT_0x3
; 0000 0126         delay_ms(period);
; 0000 0127         PORTC = 0b00000110;
	LDI  R30,LOW(6)
	CALL SUBOPT_0x3
; 0000 0128         delay_ms(period);
; 0000 0129         PORTC = 0b00000011;
	LDI  R30,LOW(3)
	CALL SUBOPT_0x3
; 0000 012A         delay_ms(period);
; 0000 012B         PORTC = 0b00001001;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x3
; 0000 012C         delay_ms(period);
; 0000 012D     }
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 012E }
	RJMP _0x2080001
; .FEND
;//
;void rotate_r_cw(int seq){
; 0000 0130 void rotate_r_cw(int seq){
_rotate_r_cw:
; .FSTART _rotate_r_cw
; 0000 0131     int i;
; 0000 0132     for (i = 0; i < seq; i++) {
	CALL SUBOPT_0x0
;	seq -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x2A:
	CALL SUBOPT_0x2
	BRGE _0x2B
; 0000 0133         PORTC = 0b00110000;
	LDI  R30,LOW(48)
	CALL SUBOPT_0x3
; 0000 0134         delay_ms(period);
; 0000 0135         PORTC = 0b01100000;
	LDI  R30,LOW(96)
	CALL SUBOPT_0x3
; 0000 0136         delay_ms(period);
; 0000 0137         PORTC = 0b11000000;
	LDI  R30,LOW(192)
	CALL SUBOPT_0x3
; 0000 0138         delay_ms(period);
; 0000 0139         PORTC = 0b10010000;
	LDI  R30,LOW(144)
	CALL SUBOPT_0x3
; 0000 013A         delay_ms(period);
; 0000 013B     }
	__ADDWRN 16,17,1
	RJMP _0x2A
_0x2B:
; 0000 013C }
	RJMP _0x2080001
; .FEND
;void rotate_r_ccw(int seq){
; 0000 013D void rotate_r_ccw(int seq){
_rotate_r_ccw:
; .FSTART _rotate_r_ccw
; 0000 013E     int i;
; 0000 013F     for (i = 0; i < seq; i++) {
	CALL SUBOPT_0x0
;	seq -> Y+2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x2D:
	CALL SUBOPT_0x2
	BRGE _0x2E
; 0000 0140         PORTC = 0b11000000;
	LDI  R30,LOW(192)
	CALL SUBOPT_0x3
; 0000 0141         delay_ms(period);
; 0000 0142         PORTC = 0b01100000;
	LDI  R30,LOW(96)
	CALL SUBOPT_0x3
; 0000 0143         delay_ms(period);
; 0000 0144         PORTC = 0b00110000;
	LDI  R30,LOW(48)
	CALL SUBOPT_0x3
; 0000 0145         delay_ms(period);
; 0000 0146         PORTC = 0b10010000;
	LDI  R30,LOW(144)
	CALL SUBOPT_0x3
; 0000 0147         delay_ms(period);
; 0000 0148     }
	__ADDWRN 16,17,1
	RJMP _0x2D
_0x2E:
; 0000 0149 }
_0x2080001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;void accelerate(int pot_value){
; 0000 014A void accelerate(int pot_value){
_accelerate:
; .FSTART _accelerate
; 0000 014B 
; 0000 014C     OCR0 = abs(pot_value - 53);
	ST   -Y,R27
	ST   -Y,R26
;	pot_value -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,53
	RCALL _abs
	OUT  0x3C,R30
; 0000 014D 
; 0000 014E     if (pot_value > 53) {
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,54
	BRLT _0x2F
; 0000 014F         PORTB.4 = 1;
	SBI  0x18,4
; 0000 0150         PORTD = 0b00000111;
	LDI  R30,LOW(7)
	RJMP _0x3A
; 0000 0151 
; 0000 0152 
; 0000 0153     } else if (pot_value == 53){
_0x2F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,53
	BRNE _0x33
; 0000 0154         PORTB.4 = 0;
	CBI  0x18,4
; 0000 0155         PORTD = 0b00001111;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0156         OCR0 = 0;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0157 
; 0000 0158     } else {
	RJMP _0x36
_0x33:
; 0000 0159         PORTB.4 = 0;
	CBI  0x18,4
; 0000 015A         PORTD = 0b00001110;
	LDI  R30,LOW(14)
_0x3A:
	OUT  0x12,R30
; 0000 015B     }
_0x36:
; 0000 015C }
	ADIW R28,2
	RET
; .FEND

	.CSEG
_abs:
; .FSTART _abs
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	MOVW R26,R16
	CALL _abs
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x3:
	OUT  0x15,R30
	MOVW R26,R4
	JMP  _delay_ms


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

;END OF CODE MARKER
__END_OF_CODE:

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
	.DEF _second=R4
	.DEF _second_msb=R5
	.DEF _minute=R6
	.DEF _minute_msb=R7
	.DEF _hour=R8
	.DEF _hour_msb=R9
	.DEF _day=R10
	.DEF _day_msb=R11
	.DEF _month=R12
	.DEF _month_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
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
	.DB  0x0,0x0,0x31,0x0
	.DB  0x5,0x0,0x15,0x0
	.DB  0x9,0x0

_0x3:
	.DB  0x63
_0x4:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F
_0x5:
	.DB  0xA

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _year
	.DW  _0x3*2

	.DW  0x0A
	.DW  _segments
	.DW  _0x4*2

	.DW  0x01
	.DW  _blink_cycle
	.DW  _0x5*2

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
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/11/2020
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
;#include <delay.h>
;#include <stdbool.h>
;
;#define _BV(bit)( 1<<(bit))
;
;// Declare your global variables here
;int second = 0;
;int minute = 49;
;int hour = 5;
;int day = 21;
;int month = 9;
;int year = 99;

	.DSEG
;
;bool is_setting = false;
;int setting_pos = 0;
;unsigned char segments[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};
;
;int blink = 0;
;int blink_cycle = 10;
;void update_time();
;void get_next_setting();
;void increase();
;void decrease();
;void write();
;void write_setting_mode();
;// External Interrupt 0 service routine -> Setting Button
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0034 {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0035     is_setting = !is_setting;
	LDS  R30,_is_setting
	CALL __LNEGB1
	STS  _is_setting,R30
; 0000 0036     setting_pos = 0;
	LDI  R30,LOW(0)
	STS  _setting_pos,R30
	STS  _setting_pos+1,R30
; 0000 0037     PORTD = 0x00;
	OUT  0x12,R30
; 0000 0038 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// External Interrupt 1 service routine -> Change Setting Pos Button
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 003C {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	RCALL SUBOPT_0x0
; 0000 003D     if (is_setting) {
	BREQ _0x6
; 0000 003E         get_next_setting();
	RCALL _get_next_setting
; 0000 003F         blink = 1;
	RCALL SUBOPT_0x1
; 0000 0040     }
; 0000 0041 
; 0000 0042 }
_0x6:
	RJMP _0x4F
; .FEND
;
;// External Interrupt 2 service routine -> Increase and Decrease
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 0046 {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	RCALL SUBOPT_0x0
; 0000 0047     if (is_setting) {
	BREQ _0x7
; 0000 0048         if (PINB & _BV(7)) {
	SBIS 0x16,7
	RJMP _0x8
; 0000 0049             decrease();
	RCALL _decrease
; 0000 004A         } else {
	RJMP _0x9
_0x8:
; 0000 004B             increase();
	RCALL _increase
; 0000 004C         }
_0x9:
; 0000 004D     }
; 0000 004E }
_0x7:
	RJMP _0x4F
; .FEND
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0052 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	RCALL SUBOPT_0x0
; 0000 0053 
; 0000 0054     if (!is_setting) {
	BRNE _0xA
; 0000 0055         PORTD ^= 0x01;
	IN   R30,0x12
	LDI  R26,LOW(1)
	EOR  R30,R26
	OUT  0x12,R30
; 0000 0056         update_time();
	RCALL _update_time
; 0000 0057     }
; 0000 0058 }
_0xA:
_0x4F:
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
;void increase(){
; 0000 0059 void increase(){
_increase:
; .FSTART _increase
; 0000 005A     switch (setting_pos) {
	RCALL SUBOPT_0x2
; 0000 005B         case 0:
	BRNE _0xE
; 0000 005C             hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 005D             if (hour >= 24) {
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0xF
; 0000 005E                 hour = 0;
	CLR  R8
	CLR  R9
; 0000 005F             }
; 0000 0060             break;
_0xF:
	RJMP _0xD
; 0000 0061         case 1:
_0xE:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x10
; 0000 0062             minute++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0063             if (minute >= 60) {
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x11
; 0000 0064                 minute = 0;
	CLR  R6
	CLR  R7
; 0000 0065             }
; 0000 0066             break;
_0x11:
	RJMP _0xD
; 0000 0067         case 2:
_0x10:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12
; 0000 0068             year++;
	RCALL SUBOPT_0x3
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0069             if (year >= 100) {
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x13
; 0000 006A                 year = 0;
	LDI  R30,LOW(0)
	STS  _year,R30
	STS  _year+1,R30
; 0000 006B             }
; 0000 006C             break;
_0x13:
	RJMP _0xD
; 0000 006D         case 3:
_0x12:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x14
; 0000 006E             month++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 006F             if (month >= 13) {
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x15
; 0000 0070                 month = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0071             }
; 0000 0072             break;
_0x15:
	RJMP _0xD
; 0000 0073         case 4:
_0x14:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xD
; 0000 0074             day++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0075             if (day >= 31) {
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x17
; 0000 0076                 day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 0077             }
; 0000 0078             break;
_0x17:
; 0000 0079     }
_0xD:
; 0000 007A 
; 0000 007B }
	RET
; .FEND
;void decrease(){
; 0000 007C void decrease(){
_decrease:
; .FSTART _decrease
; 0000 007D     switch (setting_pos) {
	RCALL SUBOPT_0x2
; 0000 007E         case 0:
	BRNE _0x1B
; 0000 007F             hour--;
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
; 0000 0080             if (hour < 0) {
	CLR  R0
	CP   R8,R0
	CPC  R9,R0
	BRGE _0x1C
; 0000 0081                 hour = 23;
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	MOVW R8,R30
; 0000 0082             }
; 0000 0083             break;
_0x1C:
	RJMP _0x1A
; 0000 0084         case 1:
_0x1B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
; 0000 0085             minute--;
	MOVW R30,R6
	SBIW R30,1
	MOVW R6,R30
; 0000 0086             if (minute < 0) {
	CLR  R0
	CP   R6,R0
	CPC  R7,R0
	BRGE _0x1E
; 0000 0087                 minute = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	MOVW R6,R30
; 0000 0088             }
; 0000 0089             break;
_0x1E:
	RJMP _0x1A
; 0000 008A         case 2:
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 008B             year--;
	RCALL SUBOPT_0x3
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 008C             if (year < 0) {
	LDS  R26,_year+1
	TST  R26
	BRPL _0x20
; 0000 008D                 year = 99;
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	STS  _year,R30
	STS  _year+1,R31
; 0000 008E             }
; 0000 008F             break;
_0x20:
	RJMP _0x1A
; 0000 0090         case 3:
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x21
; 0000 0091             month--;
	MOVW R30,R12
	SBIW R30,1
	MOVW R12,R30
; 0000 0092             if (month < 0) {
	CLR  R0
	CP   R12,R0
	CPC  R13,R0
	BRGE _0x22
; 0000 0093                 month = 12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	MOVW R12,R30
; 0000 0094             }
; 0000 0095             break;
_0x22:
	RJMP _0x1A
; 0000 0096         case 4:
_0x21:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1A
; 0000 0097             day--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0000 0098             if (day < 0) {
	CLR  R0
	CP   R10,R0
	CPC  R11,R0
	BRGE _0x24
; 0000 0099                 day = 30;
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	MOVW R10,R30
; 0000 009A             }
; 0000 009B             break;
_0x24:
; 0000 009C     }
_0x1A:
; 0000 009D 
; 0000 009E }
	RET
; .FEND
;void get_next_setting(){
; 0000 009F void get_next_setting(){
_get_next_setting:
; .FSTART _get_next_setting
; 0000 00A0     setting_pos++;
	LDI  R26,LOW(_setting_pos)
	LDI  R27,HIGH(_setting_pos)
	RCALL SUBOPT_0x5
; 0000 00A1     if (setting_pos >= 5) {
	RCALL SUBOPT_0x6
	SBIW R26,5
	BRLT _0x25
; 0000 00A2         setting_pos = 0;
	LDI  R30,LOW(0)
	STS  _setting_pos,R30
	STS  _setting_pos+1,R30
; 0000 00A3     }
; 0000 00A4 }
_0x25:
	RET
; .FEND
;void update_time(){
; 0000 00A5 void update_time(){
_update_time:
; .FSTART _update_time
; 0000 00A6     second++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00A7     if (second >= 60) {
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x26
; 0000 00A8         minute++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00A9         second = 0;
	CLR  R4
	CLR  R5
; 0000 00AA     }
; 0000 00AB     if (minute >= 60) {
_0x26:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0x27
; 0000 00AC         hour++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 00AD         minute = 0;
	CLR  R6
	CLR  R7
; 0000 00AE     }
; 0000 00AF     if (hour >= 24) {
_0x27:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CP   R8,R30
	CPC  R9,R31
	BRLT _0x28
; 0000 00B0         day++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00B1         hour = 0;
	CLR  R8
	CLR  R9
; 0000 00B2     }
; 0000 00B3     if (day >= 31) {
_0x28:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x29
; 0000 00B4         month++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00B5         day = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0000 00B6     }
; 0000 00B7     if (month >= 13) {
_0x29:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R12,R30
	CPC  R13,R31
	BRLT _0x2A
; 0000 00B8         year++;
	RCALL SUBOPT_0x3
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00B9         month = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 00BA     }
; 0000 00BB }
_0x2A:
	RET
; .FEND
;void write(){
; 0000 00BC void write(){
_write:
; .FSTART _write
; 0000 00BD     int year_l = year / 10;
; 0000 00BE     int year_r = year % 10;
; 0000 00BF     int month_l = month / 10;
; 0000 00C0     int month_r = month % 10;
; 0000 00C1     int day_l = day / 10;
; 0000 00C2     int day_r = day % 10;
; 0000 00C3     int hour_l = hour / 10;
; 0000 00C4     int hour_r = hour % 10;
; 0000 00C5     int minute_l = minute / 10;
; 0000 00C6     int minute_r = minute % 10;
; 0000 00C7 
; 0000 00C8     //Minute Right
; 0000 00C9     PORTC = 0b11110111;
	RCALL SUBOPT_0x7
;	year_l -> R16,R17
;	year_r -> R18,R19
;	month_l -> R20,R21
;	month_r -> Y+18
;	day_l -> Y+16
;	day_r -> Y+14
;	hour_l -> Y+12
;	hour_r -> Y+10
;	minute_l -> Y+8
;	minute_r -> Y+6
	RCALL SUBOPT_0x8
; 0000 00CA     PORTA = segments[minute_r];
; 0000 00CB     delay_ms(2);
; 0000 00CC 
; 0000 00CD     // Minute Left
; 0000 00CE     PORTC = 0b11111011;
; 0000 00CF     PORTA = segments[minute_l];
; 0000 00D0     delay_ms(2);
; 0000 00D1 
; 0000 00D2     // Hour Right
; 0000 00D3     PORTC = 0b11111101;
	RCALL SUBOPT_0x9
; 0000 00D4     PORTA = segments[hour_r];
; 0000 00D5     delay_ms(2);
; 0000 00D6 
; 0000 00D7     // Hour Left
; 0000 00D8     PORTC = 0b11111110;
; 0000 00D9     PORTA = segments[hour_l];
; 0000 00DA     delay_ms(2);
; 0000 00DB 
; 0000 00DC     PORTC = 0b01111111;
; 0000 00DD 
; 0000 00DE     // Day Right
; 0000 00DF     PORTB = 0b10111111;
	RCALL SUBOPT_0xA
; 0000 00E0     PORTA = segments[day_r];
; 0000 00E1     delay_ms(2);
; 0000 00E2 
; 0000 00E3     // Day Left
; 0000 00E4     PORTB = 0b11011111;
; 0000 00E5     PORTA = segments[day_l];
; 0000 00E6     delay_ms(2);
; 0000 00E7 
; 0000 00E8     // Month Right
; 0000 00E9     PORTB = 0b11101111;
	RCALL SUBOPT_0xB
; 0000 00EA     PORTA = segments[month_r];
; 0000 00EB     delay_ms(2);
; 0000 00EC     // Month Left
; 0000 00ED     PORTB = 0b11110111;
; 0000 00EE     PORTA = segments[month_l];
; 0000 00EF     delay_ms(2);
; 0000 00F0 
; 0000 00F1     // Year Right
; 0000 00F2     PORTB = 0b11111101;
	RCALL SUBOPT_0xC
; 0000 00F3     PORTA = segments[year_r];
; 0000 00F4     delay_ms(2);
; 0000 00F5 
; 0000 00F6     // Year Left
; 0000 00F7     PORTB = 0b11111110;
; 0000 00F8     PORTA = segments[year_l];
; 0000 00F9     delay_ms(2);
; 0000 00FA 
; 0000 00FB     PORTB = 0b01111111;
; 0000 00FC }
	RJMP _0x2000001
; .FEND
;void write_setting_mode(){
; 0000 00FD void write_setting_mode(){
_write_setting_mode:
; .FSTART _write_setting_mode
; 0000 00FE     int year_l = year / 10;
; 0000 00FF     int year_r = year % 10;
; 0000 0100     int month_l = month / 10;
; 0000 0101     int month_r = month % 10;
; 0000 0102     int day_l = day / 10;
; 0000 0103     int day_r = day % 10;
; 0000 0104     int hour_l = hour / 10;
; 0000 0105     int hour_r = hour % 10;
; 0000 0106     int minute_l = minute / 10;
; 0000 0107     int minute_r = minute % 10;
; 0000 0108 
; 0000 0109     // Minute
; 0000 010A     if (setting_pos == 1) {
	RCALL SUBOPT_0x7
;	year_l -> R16,R17
;	year_r -> R18,R19
;	month_l -> R20,R21
;	month_r -> Y+18
;	day_l -> Y+16
;	day_r -> Y+14
;	hour_l -> Y+12
;	hour_r -> Y+10
;	minute_l -> Y+8
;	minute_r -> Y+6
	RCALL SUBOPT_0x6
	SBIW R26,1
	BRNE _0x2B
; 0000 010B         if (blink > 0) {
	RCALL SUBOPT_0xD
	CALL __CPW02
	BRGE _0x2C
; 0000 010C             //Minute Right
; 0000 010D             PORTC = 0b11110111;
	LDI  R30,LOW(247)
	RCALL SUBOPT_0xE
; 0000 010E             PORTA = 0x00;
; 0000 010F             delay_ms(2);
; 0000 0110 
; 0000 0111             // Minute Left
; 0000 0112             PORTC = 0b11111011;
	LDI  R30,LOW(251)
	RCALL SUBOPT_0xE
; 0000 0113             PORTA = 0x00;
; 0000 0114             delay_ms(2);
; 0000 0115             blink++;
	RCALL SUBOPT_0xF
; 0000 0116             if (blink >= blink_cycle) {
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	BRLT _0x2D
; 0000 0117                 blink = -1;
	RCALL SUBOPT_0x12
; 0000 0118             }
; 0000 0119         } else {
_0x2D:
	RJMP _0x2E
_0x2C:
; 0000 011A             //Minute Right
; 0000 011B             PORTC = 0b11110111;
	RCALL SUBOPT_0x8
; 0000 011C             PORTA = segments[minute_r];
; 0000 011D             delay_ms(2);
; 0000 011E 
; 0000 011F             // Minute Left
; 0000 0120             PORTC = 0b11111011;
; 0000 0121             PORTA = segments[minute_l];
; 0000 0122             delay_ms(2);
; 0000 0123             blink--;
	RCALL SUBOPT_0x13
; 0000 0124             if (blink <= -blink_cycle) {
	BRLT _0x2F
; 0000 0125                 blink = 1;
	RCALL SUBOPT_0x1
; 0000 0126             }
; 0000 0127         }
_0x2F:
_0x2E:
; 0000 0128     } else {
	RJMP _0x30
_0x2B:
; 0000 0129         //Minute Right
; 0000 012A         PORTC = 0b11110111;
	RCALL SUBOPT_0x8
; 0000 012B         PORTA = segments[minute_r];
; 0000 012C         delay_ms(2);
; 0000 012D 
; 0000 012E         // Minute Left
; 0000 012F         PORTC = 0b11111011;
; 0000 0130         PORTA = segments[minute_l];
; 0000 0131         delay_ms(2);
; 0000 0132     }
_0x30:
; 0000 0133 
; 0000 0134     // Hour
; 0000 0135     if (setting_pos == 0) {
	RCALL SUBOPT_0x2
	BRNE _0x31
; 0000 0136         if (blink > 0) {
	RCALL SUBOPT_0x14
	BRGE _0x32
; 0000 0137             // Hour Right
; 0000 0138             PORTC = 0b11111101;
	LDI  R30,LOW(253)
	RCALL SUBOPT_0xE
; 0000 0139             PORTA = 0x00;
; 0000 013A             delay_ms(2);
; 0000 013B 
; 0000 013C             // Hour Left
; 0000 013D             PORTC = 0b11111110;
	LDI  R30,LOW(254)
	RCALL SUBOPT_0xE
; 0000 013E             PORTA = 0x00;
; 0000 013F             delay_ms(2);
; 0000 0140 
; 0000 0141             PORTC = 0b01111111;
	LDI  R30,LOW(127)
	OUT  0x15,R30
; 0000 0142 
; 0000 0143             blink++;
	RCALL SUBOPT_0xF
; 0000 0144             if (blink >= blink_cycle) {
	RCALL SUBOPT_0x15
	BRLT _0x33
; 0000 0145                 blink = -1;
	RCALL SUBOPT_0x12
; 0000 0146             }
; 0000 0147         } else {
_0x33:
	RJMP _0x34
_0x32:
; 0000 0148             // Hour Right
; 0000 0149             PORTC = 0b11111101;
	RCALL SUBOPT_0x9
; 0000 014A             PORTA = segments[hour_r];
; 0000 014B             delay_ms(2);
; 0000 014C 
; 0000 014D             // Hour Left
; 0000 014E             PORTC = 0b11111110;
; 0000 014F             PORTA = segments[hour_l];
; 0000 0150             delay_ms(2);
; 0000 0151 
; 0000 0152             PORTC = 0b01111111;
; 0000 0153 
; 0000 0154             blink--;
	RCALL SUBOPT_0x13
; 0000 0155             if (blink <= -blink_cycle) {
	BRLT _0x35
; 0000 0156                 blink = 1;
	RCALL SUBOPT_0x1
; 0000 0157             }
; 0000 0158         }
_0x35:
_0x34:
; 0000 0159     } else {
	RJMP _0x36
_0x31:
; 0000 015A         // Hour Right
; 0000 015B         PORTC = 0b11111101;
	RCALL SUBOPT_0x9
; 0000 015C         PORTA = segments[hour_r];
; 0000 015D         delay_ms(2);
; 0000 015E 
; 0000 015F         // Hour Left
; 0000 0160         PORTC = 0b11111110;
; 0000 0161         PORTA = segments[hour_l];
; 0000 0162         delay_ms(2);
; 0000 0163 
; 0000 0164         PORTC = 0b01111111;
; 0000 0165     }
_0x36:
; 0000 0166     //
; 0000 0167     // Day
; 0000 0168     if (setting_pos == 4) {
	RCALL SUBOPT_0x6
	SBIW R26,4
	BRNE _0x37
; 0000 0169         if (blink > 0) {
	RCALL SUBOPT_0x14
	BRGE _0x38
; 0000 016A             // Day Right
; 0000 016B             PORTB = 0b10111111;
	LDI  R30,LOW(191)
	RCALL SUBOPT_0x16
; 0000 016C             PORTA = 0x00;
; 0000 016D             delay_ms(2);
; 0000 016E 
; 0000 016F             // Day Left
; 0000 0170             PORTB = 0b11011111;
	LDI  R30,LOW(223)
	RCALL SUBOPT_0x16
; 0000 0171             PORTA = 0x00;
; 0000 0172             delay_ms(2);
; 0000 0173 
; 0000 0174             blink++;
	RCALL SUBOPT_0xF
; 0000 0175             if (blink >= blink_cycle) {
	RCALL SUBOPT_0x15
	BRLT _0x39
; 0000 0176                 blink = -1;
	RCALL SUBOPT_0x12
; 0000 0177             }
; 0000 0178         } else {
_0x39:
	RJMP _0x3A
_0x38:
; 0000 0179             // Day Right
; 0000 017A             PORTB = 0b10111111;
	RCALL SUBOPT_0xA
; 0000 017B             PORTA = segments[day_r];
; 0000 017C             delay_ms(2);
; 0000 017D 
; 0000 017E             // Day Left
; 0000 017F             PORTB = 0b11011111;
; 0000 0180             PORTA = segments[day_l];
; 0000 0181             delay_ms(2);
; 0000 0182 
; 0000 0183             blink--;
	RCALL SUBOPT_0x13
; 0000 0184             if (blink <= -blink_cycle) {
	BRLT _0x3B
; 0000 0185                 blink = 1;
	RCALL SUBOPT_0x1
; 0000 0186             }
; 0000 0187         }
_0x3B:
_0x3A:
; 0000 0188     } else {
	RJMP _0x3C
_0x37:
; 0000 0189         // Day Right
; 0000 018A         PORTB = 0b10111111;
	RCALL SUBOPT_0xA
; 0000 018B         PORTA = segments[day_r];
; 0000 018C         delay_ms(2);
; 0000 018D 
; 0000 018E         // Day Left
; 0000 018F         PORTB = 0b11011111;
; 0000 0190         PORTA = segments[day_l];
; 0000 0191         delay_ms(2);
; 0000 0192     }
_0x3C:
; 0000 0193     //Month
; 0000 0194     if (setting_pos == 3) {
	RCALL SUBOPT_0x6
	SBIW R26,3
	BRNE _0x3D
; 0000 0195         if (blink > 0) {
	RCALL SUBOPT_0x14
	BRGE _0x3E
; 0000 0196             // Month Right
; 0000 0197             PORTB = 0b11101111;
	LDI  R30,LOW(239)
	RCALL SUBOPT_0x16
; 0000 0198             PORTA = 0x00;
; 0000 0199             delay_ms(2);
; 0000 019A             // Month Left
; 0000 019B             PORTB = 0b11110111;
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x16
; 0000 019C             PORTA = 0x00;
; 0000 019D             delay_ms(2);
; 0000 019E 
; 0000 019F             blink++;
	RCALL SUBOPT_0xF
; 0000 01A0             if (blink >= blink_cycle) {
	RCALL SUBOPT_0x15
	BRLT _0x3F
; 0000 01A1                 blink = -1;
	RCALL SUBOPT_0x12
; 0000 01A2             }
; 0000 01A3         } else {
_0x3F:
	RJMP _0x40
_0x3E:
; 0000 01A4             // Month Right
; 0000 01A5             PORTB = 0b11101111;
	RCALL SUBOPT_0xB
; 0000 01A6             PORTA = segments[month_r];
; 0000 01A7             delay_ms(2);
; 0000 01A8             // Month Left
; 0000 01A9             PORTB = 0b11110111;
; 0000 01AA             PORTA = segments[month_l];
; 0000 01AB             delay_ms(2);
; 0000 01AC 
; 0000 01AD             blink--;
	RCALL SUBOPT_0x13
; 0000 01AE             if (blink <= -blink_cycle) {
	BRLT _0x41
; 0000 01AF                 blink = 1;
	RCALL SUBOPT_0x1
; 0000 01B0             }
; 0000 01B1         }
_0x41:
_0x40:
; 0000 01B2     } else {
	RJMP _0x42
_0x3D:
; 0000 01B3         // Month Right
; 0000 01B4         PORTB = 0b11101111;
	RCALL SUBOPT_0xB
; 0000 01B5         PORTA = segments[month_r];
; 0000 01B6         delay_ms(2);
; 0000 01B7         // Month Left
; 0000 01B8         PORTB = 0b11110111;
; 0000 01B9         PORTA = segments[month_l];
; 0000 01BA         delay_ms(2);
; 0000 01BB     }
_0x42:
; 0000 01BC 
; 0000 01BD     //Year
; 0000 01BE     if (setting_pos == 2) {
	RCALL SUBOPT_0x6
	SBIW R26,2
	BRNE _0x43
; 0000 01BF         if (blink > 0) {
	RCALL SUBOPT_0x14
	BRGE _0x44
; 0000 01C0             // Year Right
; 0000 01C1             PORTB = 0b11111101;
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x16
; 0000 01C2             PORTA = 0x00;
; 0000 01C3             delay_ms(2);
; 0000 01C4 
; 0000 01C5             // Year Left
; 0000 01C6             PORTB = 0b11111110;
	LDI  R30,LOW(254)
	RCALL SUBOPT_0x16
; 0000 01C7             PORTA = 0x00;
; 0000 01C8             delay_ms(2);
; 0000 01C9 
; 0000 01CA             PORTB = 0b01111111;
	LDI  R30,LOW(127)
	OUT  0x18,R30
; 0000 01CB 
; 0000 01CC             blink++;
	RCALL SUBOPT_0xF
; 0000 01CD             if (blink >= blink_cycle) {
	RCALL SUBOPT_0x15
	BRLT _0x45
; 0000 01CE                 blink = -1;
	RCALL SUBOPT_0x12
; 0000 01CF             }
; 0000 01D0         } else {
_0x45:
	RJMP _0x46
_0x44:
; 0000 01D1             // Year Right
; 0000 01D2             PORTB = 0b11111101;
	RCALL SUBOPT_0xC
; 0000 01D3             PORTA = segments[year_r];
; 0000 01D4             delay_ms(2);
; 0000 01D5 
; 0000 01D6             // Year Left
; 0000 01D7             PORTB = 0b11111110;
; 0000 01D8             PORTA = segments[year_l];
; 0000 01D9             delay_ms(2);
; 0000 01DA 
; 0000 01DB             PORTB = 0b01111111;
; 0000 01DC 
; 0000 01DD             blink--;
	RCALL SUBOPT_0x13
; 0000 01DE             if (blink <= -blink_cycle) {
	BRLT _0x47
; 0000 01DF                 blink = 1;
	RCALL SUBOPT_0x1
; 0000 01E0             }
; 0000 01E1         }
_0x47:
_0x46:
; 0000 01E2     } else {
	RJMP _0x48
_0x43:
; 0000 01E3         // Year Right
; 0000 01E4         PORTB = 0b11111101;
	RCALL SUBOPT_0xC
; 0000 01E5         PORTA = segments[year_r];
; 0000 01E6         delay_ms(2);
; 0000 01E7 
; 0000 01E8         // Year Left
; 0000 01E9         PORTB = 0b11111110;
; 0000 01EA         PORTA = segments[year_l];
; 0000 01EB         delay_ms(2);
; 0000 01EC 
; 0000 01ED         PORTB = 0b01111111;
; 0000 01EE     }
_0x48:
; 0000 01EF }
_0x2000001:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
;void main(void)
; 0000 01F1 {
_main:
; .FSTART _main
; 0000 01F2 // Declare your local variables here
; 0000 01F3 
; 0000 01F4 // Input/Output Ports initialization
; 0000 01F5 // Port A initialization
; 0000 01F6 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 01F7 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 01F8 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 01F9 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01FA 
; 0000 01FB // Port B initialization
; 0000 01FC // Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=In Bit1=Out Bit0=Out
; 0000 01FD DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(123)
	OUT  0x17,R30
; 0000 01FE // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=0 Bit0=0
; 0000 01FF PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0200 
; 0000 0201 // Port C initialization
; 0000 0202 // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0203 DDRC=(1<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(143)
	OUT  0x14,R30
; 0000 0204 // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0205 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0206 
; 0000 0207 // Port D initialization
; 0000 0208 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0209 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(1)
	OUT  0x11,R30
; 0000 020A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 020B PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 020C 
; 0000 020D // Timer/Counter 0 initialization
; 0000 020E // Clock source: System Clock
; 0000 020F // Clock value: Timer 0 Stopped
; 0000 0210 // Mode: Normal top=0xFF
; 0000 0211 // OC0 output: Disconnected
; 0000 0212 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0213 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0214 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0215 
; 0000 0216 // Timer/Counter 1 initialization
; 0000 0217 // Clock source: System Clock
; 0000 0218 // Clock value: 31.250 kHz
; 0000 0219 // Mode: CTC top=OCR1A
; 0000 021A // OC1A output: Disconnected
; 0000 021B // OC1B output: Disconnected
; 0000 021C // Noise Canceler: Off
; 0000 021D // Input Capture on Falling Edge
; 0000 021E // Timer Period: 1 s
; 0000 021F // Timer1 Overflow Interrupt: Off
; 0000 0220 // Input Capture Interrupt: Off
; 0000 0221 // Compare A Match Interrupt: On
; 0000 0222 // Compare B Match Interrupt: Off
; 0000 0223 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0224 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0225 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0226 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0227 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0228 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0229 OCR1AH=0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 022A OCR1AL=0x12;
	LDI  R30,LOW(18)
	OUT  0x2A,R30
; 0000 022B OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 022C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 022D 
; 0000 022E // Timer/Counter 2 initialization
; 0000 022F // Clock source: System Clock
; 0000 0230 // Clock value: Timer2 Stopped
; 0000 0231 // Mode: Normal top=0xFF
; 0000 0232 // OC2 output: Disconnected
; 0000 0233 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0234 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0235 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0236 OCR2=0x00;
	OUT  0x23,R30
; 0000 0237 
; 0000 0238 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0239 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 023A 
; 0000 023B // External Interrupt(s) initialization
; 0000 023C // INT0: On
; 0000 023D // INT0 Mode: Falling Edge
; 0000 023E // INT1: On
; 0000 023F // INT1 Mode: Falling Edge
; 0000 0240 // INT2: On
; 0000 0241 // INT2 Mode: Falling Edge
; 0000 0242 GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 0243 MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0244 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0245 GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 0246 
; 0000 0247 // USART initialization
; 0000 0248 // USART disabled
; 0000 0249 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 024A 
; 0000 024B // Analog Comparator initialization
; 0000 024C // Analog Comparator: Off
; 0000 024D // The Analog Comparator's positive input is
; 0000 024E // connected to the AIN0 pin
; 0000 024F // The Analog Comparator's negative input is
; 0000 0250 // connected to the AIN1 pin
; 0000 0251 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0252 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0253 
; 0000 0254 // ADC initialization
; 0000 0255 // ADC disabled
; 0000 0256 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0257 
; 0000 0258 // SPI initialization
; 0000 0259 // SPI disabled
; 0000 025A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 025B 
; 0000 025C // TWI initialization
; 0000 025D // TWI disabled
; 0000 025E TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 025F 
; 0000 0260 // Global enable interrupts
; 0000 0261 #asm("sei")
	sei
; 0000 0262 
; 0000 0263 while (1){
_0x49:
; 0000 0264     if (is_setting) {
	LDS  R30,_is_setting
	CPI  R30,0
	BREQ _0x4C
; 0000 0265         write_setting_mode();
	RCALL _write_setting_mode
; 0000 0266     } else {
	RJMP _0x4D
_0x4C:
; 0000 0267         write();
	RCALL _write
; 0000 0268     }
_0x4D:
; 0000 0269 
; 0000 026A }
	RJMP _0x49
; 0000 026B }
_0x4E:
	RJMP _0x4E
; .FEND

	.DSEG
_year:
	.BYTE 0x2
_is_setting:
	.BYTE 0x1
_setting_pos:
	.BYTE 0x2
_segments:
	.BYTE 0xA
_blink:
	.BYTE 0x2
_blink_cycle:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x0:
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
	LDS  R30,_is_setting
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _blink,R30
	STS  _blink+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R30,_setting_pos
	LDS  R31,_setting_pos+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_year)
	LDI  R27,HIGH(_year)
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDS  R26,_year
	LDS  R27,_year+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x5:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDS  R26,_setting_pos
	LDS  R27,_setting_pos+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x7:
	SBIW R28,14
	CALL __SAVELOCR6
	RCALL SUBOPT_0x4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R16,R30
	RCALL SUBOPT_0x4
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R18,R30
	MOVW R26,R12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R20,R30
	MOVW R26,R12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+18,R30
	STD  Y+18+1,R31
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+16,R30
	STD  Y+16+1,R31
	MOVW R26,R10
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+14,R30
	STD  Y+14+1,R31
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+12,R30
	STD  Y+12+1,R31
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+10,R30
	STD  Y+10+1,R31
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOVW R26,R6
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(247)
	OUT  0x15,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(251)
	OUT  0x15,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(253)
	OUT  0x15,R30
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(254)
	OUT  0x15,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(127)
	OUT  0x15,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(191)
	OUT  0x18,R30
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(223)
	OUT  0x18,R30
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(239)
	OUT  0x18,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	SUBI R30,LOW(-_segments)
	SBCI R31,HIGH(-_segments)
	LD   R30,Z
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(247)
	OUT  0x18,R30
	LDI  R26,LOW(_segments)
	LDI  R27,HIGH(_segments)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(253)
	OUT  0x18,R30
	LDI  R26,LOW(_segments)
	LDI  R27,HIGH(_segments)
	ADD  R26,R18
	ADC  R27,R19
	LD   R30,X
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(254)
	OUT  0x18,R30
	LDI  R26,LOW(_segments)
	LDI  R27,HIGH(_segments)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(127)
	OUT  0x18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xD:
	LDS  R26,_blink
	LDS  R27,_blink+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	OUT  0x15,R30
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_blink)
	LDI  R27,HIGH(_blink)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	LDS  R30,_blink_cycle
	LDS  R31,_blink_cycle+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xD
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _blink,R30
	STS  _blink+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_blink)
	LDI  R27,HIGH(_blink)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL SUBOPT_0x10
	CALL __ANEGW1
	RCALL SUBOPT_0xD
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0xD
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x16:
	OUT  0x18,R30
	LDI  R30,LOW(0)
	OUT  0x1B,R30
	LDI  R26,LOW(2)
	LDI  R27,0
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

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

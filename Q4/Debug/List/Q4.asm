
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
	.DEF _ones=R4
	.DEF _ones_msb=R5
	.DEF _zeros=R6
	.DEF _zeros_msb=R7
	.DEF _write=R9
	.DEF _ready=R8
	.DEF _decode=R10
	.DEF _decode_msb=R11
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x2E,0x0,0x2D,0x0,0x2E,0x2D,0x0,0x2D
	.DB  0x2E,0x2E,0x2E,0x0,0x2D,0x2E,0x2D,0x2E
	.DB  0x0,0x2D,0x2E,0x2E,0x0,0x2E,0x2E,0x2D
	.DB  0x2E,0x0,0x2D,0x2D,0x2E,0x0,0x2E,0x2E
	.DB  0x2E,0x2E,0x0,0x2E,0x2D,0x2D,0x2D,0x0
	.DB  0x2D,0x2E,0x2D,0x0,0x2E,0x2D,0x2E,0x2E
	.DB  0x0,0x2E,0x2D,0x2D,0x2E,0x0,0x2D,0x2D
	.DB  0x2E,0x2D,0x0,0x2E,0x2E,0x2D,0x0,0x2E
	.DB  0x2E,0x2E,0x2D,0x0,0x2E,0x2D,0x2D,0x0
	.DB  0x2D,0x2E,0x2E,0x2D,0x0,0x2D,0x2E,0x2D
	.DB  0x2D,0x0,0x2D,0x2D,0x2E,0x2E,0x0,0x2E
	.DB  0x2D,0x2E,0x2D,0x2E,0x2D,0x0,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x0,0x49,0x6E,0x70,0x75
	.DB  0x74,0x20,0x59,0x6F,0x75,0x72,0x20,0x4D
	.DB  0x6F,0x72,0x73,0x65,0x20,0x43,0x6F,0x64
	.DB  0x65,0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x6+2
	.DW  _0x0*2+2

	.DW  0x03
	.DW  _0xD
	.DW  _0x0*2+4

	.DW  0x05
	.DW  _0xD+3
	.DW  _0x0*2+7

	.DW  0x05
	.DW  _0xD+8
	.DW  _0x0*2+12

	.DW  0x04
	.DW  _0xD+13
	.DW  _0x0*2+17

	.DW  0x02
	.DW  _0xD+17
	.DW  _0x0*2

	.DW  0x05
	.DW  _0xD+19
	.DW  _0x0*2+21

	.DW  0x04
	.DW  _0xD+24
	.DW  _0x0*2+26

	.DW  0x05
	.DW  _0xD+28
	.DW  _0x0*2+30

	.DW  0x03
	.DW  _0xD+33
	.DW  _0x0*2+9

	.DW  0x05
	.DW  _0xD+36
	.DW  _0x0*2+35

	.DW  0x04
	.DW  _0xD+41
	.DW  _0x0*2+40

	.DW  0x05
	.DW  _0xD+45
	.DW  _0x0*2+44

	.DW  0x03
	.DW  _0xD+50
	.DW  _0x0*2+37

	.DW  0x03
	.DW  _0xD+53
	.DW  _0x0*2+14

	.DW  0x04
	.DW  _0xD+56
	.DW  _0x0*2+36

	.DW  0x05
	.DW  _0xD+60
	.DW  _0x0*2+49

	.DW  0x05
	.DW  _0xD+65
	.DW  _0x0*2+54

	.DW  0x04
	.DW  _0xD+70
	.DW  _0x0*2+13

	.DW  0x04
	.DW  _0xD+74
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0xD+78
	.DW  _0x0*2+2

	.DW  0x04
	.DW  _0xD+80
	.DW  _0x0*2+59

	.DW  0x05
	.DW  _0xD+84
	.DW  _0x0*2+63

	.DW  0x04
	.DW  _0xD+89
	.DW  _0x0*2+68

	.DW  0x05
	.DW  _0xD+93
	.DW  _0x0*2+72

	.DW  0x05
	.DW  _0xD+98
	.DW  _0x0*2+77

	.DW  0x05
	.DW  _0xD+103
	.DW  _0x0*2+82

	.DW  0x07
	.DW  _0xD+108
	.DW  _0x0*2+87

	.DW  0x06
	.DW  _0xD+115
	.DW  _0x0*2+94

	.DW  0x16
	.DW  _0x44
	.DW  _0x0*2+100

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

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
;? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/9/2020
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
;#include <stdio.h>
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
;#include <string.h>
;#include <mega32.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <stdbool.h>
;// Declare your global variables here
;int ones = 0;
;int zeros = 0;
;char cum[50] = "";
;bool write = false;
;bool ready = false;
;
;char letters[30] = "";
;char* decode;
;// char last;
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 002A {

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
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
; 0000 002B     if (PINB & (1<<PINB0)) {
	SBIS 0x16,0
	RJMP _0x3
; 0000 002C         zeros = 0;
	CLR  R6
	CLR  R7
; 0000 002D         ones++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 002E         ready = true;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 002F     } else {
	RJMP _0x4
_0x3:
; 0000 0030         if (ones >= 6000) {
	LDI  R30,LOW(6000)
	LDI  R31,HIGH(6000)
	CP   R4,R30
	CPC  R5,R31
	BRLT _0x5
; 0000 0031             strcat(cum, ".");
	CALL SUBOPT_0x0
	__POINTW2MN _0x6,0
	RJMP _0x4A
; 0000 0032         } else if(ones > 0){
_0x5:
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRGE _0x8
; 0000 0033             strcat(cum, "-");
	CALL SUBOPT_0x0
	__POINTW2MN _0x6,2
_0x4A:
	CALL _strcat
; 0000 0034         }
; 0000 0035         ones = 0;
_0x8:
	CLR  R4
	CLR  R5
; 0000 0036         zeros++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0037         if (zeros >= 10000 && ready) {
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CP   R6,R30
	CPC  R7,R31
	BRLT _0xA
	TST  R8
	BRNE _0xB
_0xA:
	RJMP _0x9
_0xB:
; 0000 0038             write = true;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0039             zeros = 0;
	CLR  R6
	CLR  R7
; 0000 003A         }
; 0000 003B     }
_0x9:
_0x4:
; 0000 003C }
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

	.DSEG
_0x6:
	.BYTE 0x4
;void make_char(){
; 0000 003D void make_char(){

	.CSEG
_make_char:
; .FSTART _make_char
; 0000 003E     if (!strcmp(cum, ".-")) {
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,0
	CALL _strcmp
	CPI  R30,0
	BRNE _0xC
; 0000 003F         *decode = 'A';
	MOVW R26,R10
	LDI  R30,LOW(65)
	ST   X,R30
; 0000 0040     } else if (!strcmp(cum, "-...")) {
	RJMP _0xE
_0xC:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,3
	CALL _strcmp
	CPI  R30,0
	BRNE _0xF
; 0000 0041         *decode = 'B';
	MOVW R26,R10
	LDI  R30,LOW(66)
	ST   X,R30
; 0000 0042     } else if (!strcmp(cum, "-.-.")) {
	RJMP _0x10
_0xF:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,8
	CALL _strcmp
	CPI  R30,0
	BRNE _0x11
; 0000 0043         *decode = 'C';
	MOVW R26,R10
	LDI  R30,LOW(67)
	ST   X,R30
; 0000 0044     }else if (!strcmp(cum, "-..")) {
	RJMP _0x12
_0x11:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,13
	CALL _strcmp
	CPI  R30,0
	BRNE _0x13
; 0000 0045         *decode = 'D';
	MOVW R26,R10
	LDI  R30,LOW(68)
	ST   X,R30
; 0000 0046     }else if (!strcmp(cum, ".")) {
	RJMP _0x14
_0x13:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,17
	CALL _strcmp
	CPI  R30,0
	BRNE _0x15
; 0000 0047         *decode = 'E';
	MOVW R26,R10
	LDI  R30,LOW(69)
	ST   X,R30
; 0000 0048     }else if (!strcmp(cum, "..-.")) {
	RJMP _0x16
_0x15:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,19
	CALL _strcmp
	CPI  R30,0
	BRNE _0x17
; 0000 0049         *decode = 'F';
	MOVW R26,R10
	LDI  R30,LOW(70)
	ST   X,R30
; 0000 004A     }else if (!strcmp(cum, "--.")) {
	RJMP _0x18
_0x17:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,24
	CALL _strcmp
	CPI  R30,0
	BRNE _0x19
; 0000 004B         *decode = 'G';
	MOVW R26,R10
	LDI  R30,LOW(71)
	ST   X,R30
; 0000 004C     }else if (!strcmp(cum, "....")) {
	RJMP _0x1A
_0x19:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,28
	CALL _strcmp
	CPI  R30,0
	BRNE _0x1B
; 0000 004D         *decode = 'H';
	MOVW R26,R10
	LDI  R30,LOW(72)
	ST   X,R30
; 0000 004E     }else if (!strcmp(cum, "..")) {
	RJMP _0x1C
_0x1B:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,33
	CALL _strcmp
	CPI  R30,0
	BRNE _0x1D
; 0000 004F         *decode = 'I';
	MOVW R26,R10
	LDI  R30,LOW(73)
	ST   X,R30
; 0000 0050     }else if (!strcmp(cum, ".---")) {
	RJMP _0x1E
_0x1D:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,36
	CALL _strcmp
	CPI  R30,0
	BRNE _0x1F
; 0000 0051         *decode = 'J';
	MOVW R26,R10
	LDI  R30,LOW(74)
	ST   X,R30
; 0000 0052     }else if (!strcmp(cum, "-.-")) {
	RJMP _0x20
_0x1F:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,41
	CALL _strcmp
	CPI  R30,0
	BRNE _0x21
; 0000 0053         *decode = 'K';
	MOVW R26,R10
	LDI  R30,LOW(75)
	ST   X,R30
; 0000 0054     }else if (!strcmp(cum, ".-..")) {
	RJMP _0x22
_0x21:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,45
	CALL _strcmp
	CPI  R30,0
	BRNE _0x23
; 0000 0055         *decode = 'L';
	MOVW R26,R10
	LDI  R30,LOW(76)
	ST   X,R30
; 0000 0056     }else if (!strcmp(cum, "--")) {
	RJMP _0x24
_0x23:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,50
	CALL _strcmp
	CPI  R30,0
	BRNE _0x25
; 0000 0057         *decode = 'M';
	MOVW R26,R10
	LDI  R30,LOW(77)
	ST   X,R30
; 0000 0058     }else if (!strcmp(cum, "-.")) {
	RJMP _0x26
_0x25:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,53
	CALL _strcmp
	CPI  R30,0
	BRNE _0x27
; 0000 0059         *decode = 'N';
	MOVW R26,R10
	LDI  R30,LOW(78)
	ST   X,R30
; 0000 005A     }else if (!strcmp(cum, "---")) {
	RJMP _0x28
_0x27:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,56
	CALL _strcmp
	CPI  R30,0
	BRNE _0x29
; 0000 005B         *decode = 'O';
	MOVW R26,R10
	LDI  R30,LOW(79)
	ST   X,R30
; 0000 005C     }else if (!strcmp(cum, ".--.")) {
	RJMP _0x2A
_0x29:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,60
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2B
; 0000 005D         *decode = 'P';
	MOVW R26,R10
	LDI  R30,LOW(80)
	ST   X,R30
; 0000 005E     }else if (!strcmp(cum, "--.-")) {
	RJMP _0x2C
_0x2B:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,65
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2D
; 0000 005F         *decode = 'Q';
	MOVW R26,R10
	LDI  R30,LOW(81)
	ST   X,R30
; 0000 0060     }else if (!strcmp(cum, ".-.")) {
	RJMP _0x2E
_0x2D:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,70
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2F
; 0000 0061         *decode = 'R';
	MOVW R26,R10
	LDI  R30,LOW(82)
	ST   X,R30
; 0000 0062     }else if (!strcmp(cum, "...")) {
	RJMP _0x30
_0x2F:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,74
	CALL _strcmp
	CPI  R30,0
	BRNE _0x31
; 0000 0063         *decode = 'S';
	MOVW R26,R10
	LDI  R30,LOW(83)
	ST   X,R30
; 0000 0064     }else if (!strcmp(cum, "-")) {
	RJMP _0x32
_0x31:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,78
	CALL _strcmp
	CPI  R30,0
	BRNE _0x33
; 0000 0065         *decode = 'T';
	MOVW R26,R10
	LDI  R30,LOW(84)
	ST   X,R30
; 0000 0066     }else if (!strcmp(cum, "..-")) {
	RJMP _0x34
_0x33:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,80
	CALL _strcmp
	CPI  R30,0
	BRNE _0x35
; 0000 0067         *decode = 'U';
	MOVW R26,R10
	LDI  R30,LOW(85)
	ST   X,R30
; 0000 0068     }else if (!strcmp(cum, "...-")) {
	RJMP _0x36
_0x35:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,84
	CALL _strcmp
	CPI  R30,0
	BRNE _0x37
; 0000 0069         *decode = 'V';
	MOVW R26,R10
	LDI  R30,LOW(86)
	ST   X,R30
; 0000 006A     }else if (!strcmp(cum, ".--")) {
	RJMP _0x38
_0x37:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,89
	CALL _strcmp
	CPI  R30,0
	BRNE _0x39
; 0000 006B         *decode = 'W';
	MOVW R26,R10
	LDI  R30,LOW(87)
	ST   X,R30
; 0000 006C     }else if (!strcmp(cum, "-..-")) {
	RJMP _0x3A
_0x39:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,93
	CALL _strcmp
	CPI  R30,0
	BRNE _0x3B
; 0000 006D         *decode = 'X';
	MOVW R26,R10
	LDI  R30,LOW(88)
	ST   X,R30
; 0000 006E     }else if (!strcmp(cum, "-.--")) {
	RJMP _0x3C
_0x3B:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,98
	CALL _strcmp
	CPI  R30,0
	BRNE _0x3D
; 0000 006F         *decode = 'Y';
	MOVW R26,R10
	LDI  R30,LOW(89)
	ST   X,R30
; 0000 0070     }else if (!strcmp(cum, "--..")) {
	RJMP _0x3E
_0x3D:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,103
	CALL _strcmp
	CPI  R30,0
	BRNE _0x3F
; 0000 0071         *decode = 'Z';
	MOVW R26,R10
	LDI  R30,LOW(90)
	ST   X,R30
; 0000 0072     }else if (!strcmp(cum, ".-.-.-")) {
	RJMP _0x40
_0x3F:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,108
	CALL _strcmp
	CPI  R30,0
	BRNE _0x41
; 0000 0073         *decode = '.';
	MOVW R26,R10
	LDI  R30,LOW(46)
	ST   X,R30
; 0000 0074     } else if (!strcmp(cum, "-----")) {
	RJMP _0x42
_0x41:
	CALL SUBOPT_0x0
	__POINTW2MN _0xD,115
	CALL _strcmp
	CPI  R30,0
	BRNE _0x43
; 0000 0075         *decode = 0;
	MOVW R26,R10
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0076         letters[0] = 0;
	STS  _letters,R30
; 0000 0077     }
; 0000 0078 }
_0x43:
_0x42:
_0x40:
_0x3E:
_0x3C:
_0x3A:
_0x38:
_0x36:
_0x34:
_0x32:
_0x30:
_0x2E:
_0x2C:
_0x2A:
_0x28:
_0x26:
_0x24:
_0x22:
_0x20:
_0x1E:
_0x1C:
_0x1A:
_0x18:
_0x16:
_0x14:
_0x12:
_0x10:
_0xE:
	RET
; .FEND

	.DSEG
_0xD:
	.BYTE 0x79
;void main(void)
; 0000 007A {

	.CSEG
_main:
; .FSTART _main
; 0000 007B // Declare your local variables here
; 0000 007C 
; 0000 007D // Input/Output Ports initialization
; 0000 007E // Port A initialization
; 0000 007F // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0080 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0081 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0082 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0083 
; 0000 0084 // Port B initialization
; 0000 0085 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0086 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0087 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0088 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0089 
; 0000 008A // Port C initialization
; 0000 008B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 008C DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 008D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 008E PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 008F 
; 0000 0090 // Port D initialization
; 0000 0091 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0092 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0093 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0094 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0095 
; 0000 0096 // Timer/Counter 0 initialization
; 0000 0097 // Clock source: System Clock
; 0000 0098 // Clock value: 1000.000 kHz
; 0000 0099 // Mode: CTC top=OCR0
; 0000 009A // OC0 output: Disconnected
; 0000 009B // Timer Period: 0.1 ms
; 0000 009C TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(10)
	OUT  0x33,R30
; 0000 009D TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 009E OCR0=0x63;
	LDI  R30,LOW(99)
	OUT  0x3C,R30
; 0000 009F 
; 0000 00A0 // Timer/Counter 1 initialization
; 0000 00A1 // Clock source: System Clock
; 0000 00A2 // Clock value: Timer1 Stopped
; 0000 00A3 // Mode: CTC top=OCR1A
; 0000 00A4 // OC1A output: Disconnected
; 0000 00A5 // OC1B output: Disconnected
; 0000 00A6 // Noise Canceler: Off
; 0000 00A7 // Input Capture on Falling Edge
; 0000 00A8 // Timer1 Overflow Interrupt: Off
; 0000 00A9 // Input Capture Interrupt: Off
; 0000 00AA // Compare A Match Interrupt: Off
; 0000 00AB // Compare B Match Interrupt: Off
; 0000 00AC TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00AD TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 00AE TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00AF TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B0 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00B1 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00B2 OCR1AH=0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 00B3 OCR1AL=0x12;
	LDI  R30,LOW(18)
	OUT  0x2A,R30
; 0000 00B4 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00B5 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00B6 
; 0000 00B7 // Timer/Counter 2 initialization
; 0000 00B8 // Clock source: System Clock
; 0000 00B9 // Clock value: Timer2 Stopped
; 0000 00BA // Mode: Normal top=0xFF
; 0000 00BB // OC2 output: Disconnected
; 0000 00BC ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00BD TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00BE TCNT2=0x00;
	OUT  0x24,R30
; 0000 00BF OCR2=0x00;
	OUT  0x23,R30
; 0000 00C0 
; 0000 00C1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C2 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 00C3 
; 0000 00C4 // External Interrupt(s) initialization
; 0000 00C5 // INT0: Off
; 0000 00C6 // INT1: Off
; 0000 00C7 // INT2: Off
; 0000 00C8 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00C9 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00CA 
; 0000 00CB // USART initialization
; 0000 00CC // USART disabled
; 0000 00CD UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00CE 
; 0000 00CF // Analog Comparator initialization
; 0000 00D0 // Analog Comparator: Off
; 0000 00D1 // The Analog Comparator's positive input is
; 0000 00D2 // connected to the AIN0 pin
; 0000 00D3 // The Analog Comparator's negative input is
; 0000 00D4 // connected to the AIN1 pin
; 0000 00D5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D7 
; 0000 00D8 // ADC initialization
; 0000 00D9 // ADC disabled
; 0000 00DA ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00DB 
; 0000 00DC // SPI initialization
; 0000 00DD // SPI disabled
; 0000 00DE SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00DF 
; 0000 00E0 // TWI initialization
; 0000 00E1 // TWI disabled
; 0000 00E2 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00E3 
; 0000 00E4 // Alphanumeric LCD initialization
; 0000 00E5 // Connections are specified in the
; 0000 00E6 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00E7 // RS - PORTA Bit 0
; 0000 00E8 // RD - PORTA Bit 1
; 0000 00E9 // EN - PORTA Bit 2
; 0000 00EA // D4 - PORTA Bit 4
; 0000 00EB // D5 - PORTA Bit 5
; 0000 00EC // D6 - PORTA Bit 6
; 0000 00ED // D7 - PORTA Bit 7
; 0000 00EE // Characters/line: 16
; 0000 00EF lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00F0 
; 0000 00F1 // Global enable interrupts
; 0000 00F2 #asm("sei")
	sei
; 0000 00F3 lcd_puts("Input Your Morse Code");
	__POINTW2MN _0x44,0
	CALL _lcd_puts
; 0000 00F4 while (1)
_0x45:
; 0000 00F5       {
; 0000 00F6       if (write) {
	TST  R9
	BREQ _0x48
; 0000 00F7           make_char();
	RCALL _make_char
; 0000 00F8 
; 0000 00F9           strcat(letters, decode);
	LDI  R30,LOW(_letters)
	LDI  R31,HIGH(_letters)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R10
	CALL _strcat
; 0000 00FA 
; 0000 00FB           lcd_clear();
	CALL _lcd_clear
; 0000 00FC 
; 0000 00FD 
; 0000 00FE           lcd_puts(letters);
	LDI  R26,LOW(_letters)
	LDI  R27,HIGH(_letters)
	CALL _lcd_puts
; 0000 00FF 
; 0000 0100           cum[0] = 0;
	LDI  R30,LOW(0)
	STS  _cum,R30
; 0000 0101           write = false;
	CLR  R9
; 0000 0102           ready = false;
	CLR  R8
; 0000 0103       }
; 0000 0104 
; 0000 0105       }
_0x48:
	RJMP _0x45
; 0000 0106 }
_0x49:
	RJMP _0x49
; .FEND

	.DSEG
_0x44:
	.BYTE 0x16
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

	.CSEG

	.CSEG
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2040004
_0x2040005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x2080001
_0x2040007:
_0x2040004:
	INC  R13
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.DSEG
_cum:
	.BYTE 0x32
_letters:
	.BYTE 0x1E
__base_y_G102:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_cum)
	LDI  R31,HIGH(_cum)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET


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

;END OF CODE MARKER
__END_OF_CODE:

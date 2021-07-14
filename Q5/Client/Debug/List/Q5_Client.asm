
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
	.DEF _key=R5
	.DEF _index=R4
	.DEF _calced=R7
	.DEF _first_num=R6
	.DEF __lcd_x=R9
	.DEF __lcd_y=R8
	.DEF __lcd_maxx=R11

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

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0

_0x0:
	.DB  0x35,0x0,0x36,0x0,0x37,0x0,0x38,0x0
	.DB  0x39,0x0,0x30,0x0,0x30,0x3A,0x31,0x2C
	.DB  0x20,0x31,0x3A,0x2B,0x0,0x31,0x0,0x30
	.DB  0x3A,0x32,0x2C,0x20,0x31,0x3A,0x2D,0x0
	.DB  0x32,0x0,0x30,0x3A,0x33,0x2C,0x20,0x31
	.DB  0x3A,0x78,0x0,0x33,0x0,0x30,0x3A,0x34
	.DB  0x2C,0x20,0x31,0x3A,0x2F,0x0,0x34,0x0
	.DB  0x30,0x3A,0x3D,0x2C,0x20,0x31,0x3A,0x2E
	.DB  0x0,0x3D,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _0x12
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x12+2
	.DW  _0x0*2+2

	.DW  0x02
	.DW  _0x12+4
	.DW  _0x0*2+4

	.DW  0x02
	.DW  _0x12+6
	.DW  _0x0*2+6

	.DW  0x02
	.DW  _0x12+8
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x12+10
	.DW  _0x0*2+10

	.DW  0x09
	.DW  _0x12+12
	.DW  _0x0*2+12

	.DW  0x02
	.DW  _0x12+21
	.DW  _0x0*2+21

	.DW  0x02
	.DW  _0x12+23
	.DW  _0x0*2+19

	.DW  0x09
	.DW  _0x12+25
	.DW  _0x0*2+23

	.DW  0x02
	.DW  _0x12+34
	.DW  _0x0*2+32

	.DW  0x02
	.DW  _0x12+36
	.DW  _0x0*2+30

	.DW  0x09
	.DW  _0x12+38
	.DW  _0x0*2+34

	.DW  0x02
	.DW  _0x12+47
	.DW  _0x0*2+43

	.DW  0x02
	.DW  _0x12+49
	.DW  _0x0*2+41

	.DW  0x09
	.DW  _0x12+51
	.DW  _0x0*2+45

	.DW  0x02
	.DW  _0x12+60
	.DW  _0x0*2+54

	.DW  0x02
	.DW  _0x12+62
	.DW  _0x0*2+52

	.DW  0x09
	.DW  _0x12+64
	.DW  _0x0*2+56

	.DW  0x02
	.DW  _0x12+73
	.DW  _0x0*2+63

	.DW  0x02
	.DW  _0x82
	.DW  _0x0*2+65

	.DW  0x01
	.DW  _0x82+2
	.DW  _0x0*2+1

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;// SPI functions
;#include <spi.h>
;
;#include <delay.h>
;#include <stdlib.h>
;#include <stdio.h>
;#include <string.h>
;#include <stdbool.h>
;
;#define KEYPAD_R1 PORTC.0
;#define KEYPAD_R2 PORTC.1
;#define KEYPAD_R3 PORTC.2
;#define KEYPAD_R4 PORTC.3
;#define KEYPAD_C1 PINC.4
;#define KEYPAD_C2 PINC.5
;#define KEYPAD_C3 PINC.6
;
;#define KEYPAD_NUM0 0
;#define KEYPAD_NUM1 1
;#define KEYPAD_NUM2 2
;#define KEYPAD_NUM3 3
;#define KEYPAD_NUM4 4
;#define KEYPAD_NUM5 5
;#define KEYPAD_NUM6 6
;#define KEYPAD_NUM7 7
;#define KEYPAD_NUM8 8
;#define KEYPAD_NUM9 9
;#define KEYPAD_STAR  10
;#define KEYPAD_HASH  11
;
;// Declare your global variables here
;char data[20] = "";
;
;unsigned char key;
;unsigned char index;
;
;bool calced = false;
;bool first_num = true;
;
;
;unsigned char keypad_input();
;char read();
;void calculate();
;void send_data(char* d);
;
;void main(void)
; 0000 004B {

	.CSEG
_main:
; .FSTART _main
; 0000 004C // Declare your local variables here
; 0000 004D 
; 0000 004E // Input/Output Ports initialization
; 0000 004F // Port A initialization
; 0000 0050 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0051 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0052 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0053 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0054 
; 0000 0055 // Port B initialization
; 0000 0056 // Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0057 DDRB=(1<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(176)
	OUT  0x17,R30
; 0000 0058 // State: Bit7=0 Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0059 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005A 
; 0000 005B // Port C initialization
; 0000 005C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 005D DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 005E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 005F PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0060 
; 0000 0061 // Port D initialization
; 0000 0062 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0063 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 0064 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0065 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0066 
; 0000 0067 // Timer/Counter 0 initialization
; 0000 0068 // Clock source: System Clock
; 0000 0069 // Clock value: Timer 0 Stopped
; 0000 006A // Mode: Normal top=0xFF
; 0000 006B // OC0 output: Disconnected
; 0000 006C TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 006D TCNT0=0x00;
	OUT  0x32,R30
; 0000 006E OCR0=0x00;
	OUT  0x3C,R30
; 0000 006F 
; 0000 0070 // Timer/Counter 1 initialization
; 0000 0071 // Clock source: System Clock
; 0000 0072 // Clock value: Timer1 Stopped
; 0000 0073 // Mode: Normal top=0xFFFF
; 0000 0074 // OC1A output: Disconnected
; 0000 0075 // OC1B output: Disconnected
; 0000 0076 // Noise Canceler: Off
; 0000 0077 // Input Capture on Falling Edge
; 0000 0078 // Timer1 Overflow Interrupt: Off
; 0000 0079 // Input Capture Interrupt: Off
; 0000 007A // Compare A Match Interrupt: Off
; 0000 007B // Compare B Match Interrupt: Off
; 0000 007C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 007D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 007E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 007F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0080 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0081 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0082 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0083 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0084 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0085 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0086 
; 0000 0087 // Timer/Counter 2 initialization
; 0000 0088 // Clock source: System Clock
; 0000 0089 // Clock value: Timer2 Stopped
; 0000 008A // Mode: Normal top=0xFF
; 0000 008B // OC2 output: Disconnected
; 0000 008C ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 008D TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 008E TCNT2=0x00;
	OUT  0x24,R30
; 0000 008F OCR2=0x00;
	OUT  0x23,R30
; 0000 0090 
; 0000 0091 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0092 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 0093 
; 0000 0094 // External Interrupt(s) initialization
; 0000 0095 // INT0: Off
; 0000 0096 // INT1: Off
; 0000 0097 // INT2: Off
; 0000 0098 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0099 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 009A 
; 0000 009B // USART initialization
; 0000 009C // USART disabled
; 0000 009D UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 009E 
; 0000 009F // Analog Comparator initialization
; 0000 00A0 // Analog Comparator: Off
; 0000 00A1 // The Analog Comparator's positive input is
; 0000 00A2 // connected to the AIN0 pin
; 0000 00A3 // The Analog Comparator's negative input is
; 0000 00A4 // connected to the AIN1 pin
; 0000 00A5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A6 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00A7 
; 0000 00A8 // ADC initialization
; 0000 00A9 // ADC disabled
; 0000 00AA ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00AB 
; 0000 00AC // SPI initialization
; 0000 00AD // SPI Type: Master
; 0000 00AE // SPI Clock Rate: 2000.000 kHz
; 0000 00AF // SPI Clock Phase: Cycle Start
; 0000 00B0 // SPI Clock Polarity: Low
; 0000 00B1 // SPI Data Order: MSB First
; 0000 00B2 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 00B3 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 00B4 
; 0000 00B5 // TWI initialization
; 0000 00B6 // TWI disabled
; 0000 00B7 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00B8 
; 0000 00B9 // Alphanumeric LCD initialization
; 0000 00BA // Connections are specified in the
; 0000 00BB // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00BC // RS - PORTA Bit 0
; 0000 00BD // RD - PORTA Bit 1
; 0000 00BE // EN - PORTA Bit 2
; 0000 00BF // D4 - PORTA Bit 4
; 0000 00C0 // D5 - PORTA Bit 5
; 0000 00C1 // D6 - PORTA Bit 6
; 0000 00C2 // D7 - PORTA Bit 7
; 0000 00C3 // Characters/line: 16
; 0000 00C4 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00C5 
; 0000 00C6 while (1)
_0x3:
; 0000 00C7       {
; 0000 00C8 
; 0000 00C9           key = keypad_input();
	RCALL _keypad_input
	MOV  R5,R30
; 0000 00CA           if (key != 255) {
	LDI  R30,LOW(255)
	CP   R30,R5
	BRNE PC+2
	RJMP _0x6
; 0000 00CB               if (calced) {
	TST  R7
	BREQ _0x7
; 0000 00CC                   lcd_clear();
	CALL _lcd_clear
; 0000 00CD                   data[0] = 0;
	LDI  R30,LOW(0)
	STS  _data,R30
; 0000 00CE                   calced = false;
	CLR  R7
; 0000 00CF               }
; 0000 00D0               while(keypad_input() != 255);
_0x7:
_0x8:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BRNE _0x8
; 0000 00D1               delay_ms(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D2 
; 0000 00D3               if (key >= 5 && key <= 9) {
	LDI  R30,LOW(5)
	CP   R5,R30
	BRLO _0xC
	LDI  R30,LOW(9)
	CP   R30,R5
	BRSH _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 00D4                   first_num = true;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00D5                   switch (key) {
	MOV  R30,R5
	LDI  R31,0
; 0000 00D6                       case 5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x11
; 0000 00D7                       strcat(data, "5");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,0
	RJMP _0x94
; 0000 00D8                       first_num = false;
; 0000 00D9                       break;
; 0000 00DA                       case 6:
_0x11:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x13
; 0000 00DB                       strcat(data, "6");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,2
	RJMP _0x94
; 0000 00DC                       first_num = false;
; 0000 00DD                       break;
; 0000 00DE                       case 7:
_0x13:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x14
; 0000 00DF                       strcat(data, "7");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,4
	RJMP _0x94
; 0000 00E0                       first_num = false;
; 0000 00E1                       break;
; 0000 00E2                       case 8:
_0x14:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x15
; 0000 00E3                       strcat(data, "8");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,6
	RJMP _0x94
; 0000 00E4                       first_num = false;
; 0000 00E5                       break;
; 0000 00E6                       case 9:
_0x15:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x10
; 0000 00E7                       strcat(data, "9");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,8
_0x94:
	CALL _strcat
; 0000 00E8                       first_num = false;
	CLR  R6
; 0000 00E9                       break;
; 0000 00EA 
; 0000 00EB                   }
_0x10:
; 0000 00EC               }
; 0000 00ED               else if (key == 0) {
	RJMP _0x17
_0xB:
	TST  R5
	BRNE _0x18
; 0000 00EE                       first_num = false;
	CLR  R6
; 0000 00EF                       strcat(data, "0");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,10
	CALL _strcat
; 0000 00F0               }
; 0000 00F1               else if ( (key <= 4 && key >= 1) || (key == KEYPAD_HASH || key == KEYPAD_STAR)){
	RJMP _0x19
_0x18:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRLO _0x1B
	LDI  R30,LOW(1)
	CP   R5,R30
	BRSH _0x1D
_0x1B:
	LDI  R30,LOW(11)
	CP   R30,R5
	BREQ _0x1E
	LDI  R30,LOW(10)
	CP   R30,R5
	BRNE _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
	RJMP _0x1A
_0x1D:
; 0000 00F2                   switch (key) {
	MOV  R30,R5
	LDI  R31,0
; 0000 00F3                       case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x24
; 0000 00F4                       lcd_clear();
	RCALL _lcd_clear
; 0000 00F5                       lcd_puts("0:1, 1:+");
	__POINTW2MN _0x12,12
	RCALL _lcd_puts
; 0000 00F6 
; 0000 00F7                       while(keypad_input() == 255);
_0x25:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BREQ _0x25
; 0000 00F8                       index = keypad_input();
	CALL SUBOPT_0x1
; 0000 00F9 
; 0000 00FA                       if (index == 0) {
	BRNE _0x28
; 0000 00FB                           strcat(data, "1");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,21
	CALL _strcat
; 0000 00FC                           first_num = false;
	CLR  R6
; 0000 00FD                       } else if (index == 1) {
	RJMP _0x29
_0x28:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x2A
; 0000 00FE                           if (!first_num) {
	TST  R6
	BRNE _0x2B
; 0000 00FF                               strcat(data, "+");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,23
	CALL SUBOPT_0x2
; 0000 0100                               first_num = true;
; 0000 0101                           }
; 0000 0102                       }
_0x2B:
; 0000 0103 
; 0000 0104                       delay_ms(200);
_0x2A:
_0x29:
	RJMP _0x95
; 0000 0105                       break;
; 0000 0106 
; 0000 0107                       case 2:
_0x24:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2C
; 0000 0108                       lcd_clear();
	RCALL _lcd_clear
; 0000 0109                       lcd_puts("0:2, 1:-");
	__POINTW2MN _0x12,25
	RCALL _lcd_puts
; 0000 010A 
; 0000 010B                       while(keypad_input() == 255);
_0x2D:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BREQ _0x2D
; 0000 010C                       index = keypad_input();
	CALL SUBOPT_0x1
; 0000 010D 
; 0000 010E                       if (index == 0) {
	BRNE _0x30
; 0000 010F                           strcat(data, "2");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,34
	CALL _strcat
; 0000 0110                           first_num = false;
	CLR  R6
; 0000 0111 
; 0000 0112                       } else if (index == 1) {
	RJMP _0x31
_0x30:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x32
; 0000 0113                           if (!first_num) {
	TST  R6
	BRNE _0x33
; 0000 0114                               strcat(data, "-");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,36
	CALL SUBOPT_0x2
; 0000 0115                               first_num = true;
; 0000 0116                           }
; 0000 0117                       }
_0x33:
; 0000 0118 
; 0000 0119                       delay_ms(200);
_0x32:
_0x31:
	RJMP _0x95
; 0000 011A                       break;
; 0000 011B 
; 0000 011C                       case 3:
_0x2C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x34
; 0000 011D                       lcd_clear();
	RCALL _lcd_clear
; 0000 011E                       lcd_puts("0:3, 1:x");
	__POINTW2MN _0x12,38
	RCALL _lcd_puts
; 0000 011F 
; 0000 0120                       while(keypad_input() == 255);
_0x35:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BREQ _0x35
; 0000 0121                       index = keypad_input();
	CALL SUBOPT_0x1
; 0000 0122 
; 0000 0123                       if (index == 0) {
	BRNE _0x38
; 0000 0124                           strcat(data, "3");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,47
	CALL _strcat
; 0000 0125                           first_num = false;
	CLR  R6
; 0000 0126 
; 0000 0127                       } else if (index == 1) {
	RJMP _0x39
_0x38:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x3A
; 0000 0128                           if (!first_num) {
	TST  R6
	BRNE _0x3B
; 0000 0129                               strcat(data, "x");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,49
	CALL SUBOPT_0x2
; 0000 012A                               first_num = true;
; 0000 012B                           }
; 0000 012C                       }
_0x3B:
; 0000 012D 
; 0000 012E                       delay_ms(200);
_0x3A:
_0x39:
	RJMP _0x95
; 0000 012F                       break;
; 0000 0130 
; 0000 0131                       case 4:
_0x34:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3C
; 0000 0132                       lcd_clear();
	RCALL _lcd_clear
; 0000 0133                       lcd_puts("0:4, 1:/");
	__POINTW2MN _0x12,51
	RCALL _lcd_puts
; 0000 0134 
; 0000 0135                       while(keypad_input() == 255);
_0x3D:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BREQ _0x3D
; 0000 0136                       index = keypad_input();
	CALL SUBOPT_0x1
; 0000 0137 
; 0000 0138                       if (index == 0) {
	BRNE _0x40
; 0000 0139                           strcat(data, "4");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,60
	CALL _strcat
; 0000 013A                           first_num = false;
	CLR  R6
; 0000 013B 
; 0000 013C                       } else if (index == 1) {
	RJMP _0x41
_0x40:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x42
; 0000 013D                           if (!first_num) {
	TST  R6
	BRNE _0x43
; 0000 013E                               strcat(data, "/");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,62
	CALL SUBOPT_0x2
; 0000 013F                               first_num = true;
; 0000 0140                           }
; 0000 0141                       }
_0x43:
; 0000 0142 
; 0000 0143                       delay_ms(200);
_0x42:
_0x41:
	RJMP _0x95
; 0000 0144                       break;
; 0000 0145 
; 0000 0146                       case KEYPAD_HASH:
_0x3C:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x44
; 0000 0147                       lcd_clear();
	RCALL _lcd_clear
; 0000 0148                       lcd_puts("0:=, 1:.");
	__POINTW2MN _0x12,64
	RCALL _lcd_puts
; 0000 0149 
; 0000 014A                       while(keypad_input() == 255);
_0x45:
	RCALL _keypad_input
	CPI  R30,LOW(0xFF)
	BREQ _0x45
; 0000 014B                       index = keypad_input();
	CALL SUBOPT_0x1
; 0000 014C 
; 0000 014D                       if (index == 0) {
	BRNE _0x48
; 0000 014E 
; 0000 014F                           calculate();
	RCALL _calculate
; 0000 0150 
; 0000 0151                           calced = true;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0152 
; 0000 0153                       } else if (index == 1) {
	RJMP _0x49
_0x48:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x4A
; 0000 0154                           if (!first_num) {
	TST  R6
	BRNE _0x4B
; 0000 0155                               strcat(data, ".");
	CALL SUBOPT_0x0
	__POINTW2MN _0x12,73
	CALL SUBOPT_0x2
; 0000 0156                               first_num = true;
; 0000 0157                           }
; 0000 0158                       }
_0x4B:
; 0000 0159 
; 0000 015A                       delay_ms(200);
_0x4A:
_0x49:
	RJMP _0x95
; 0000 015B                       break;
; 0000 015C 
; 0000 015D                       case KEYPAD_STAR:
_0x44:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x23
; 0000 015E 
; 0000 015F                       data[0] = 0;
	LDI  R30,LOW(0)
	STS  _data,R30
; 0000 0160                       first_num = true;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0161                       calced = false;
	CLR  R7
; 0000 0162 
; 0000 0163                       delay_ms(200);
_0x95:
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0164                       break;
; 0000 0165                   }
_0x23:
; 0000 0166               }
; 0000 0167               lcd_clear();
_0x1A:
_0x19:
_0x17:
	RCALL _lcd_clear
; 0000 0168               lcd_puts(data);
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RCALL _lcd_puts
; 0000 0169           }
; 0000 016A       }
_0x6:
	RJMP _0x3
; 0000 016B }
_0x4D:
	RJMP _0x4D
; .FEND

	.DSEG
_0x12:
	.BYTE 0x4B
;
;unsigned char keypad_input(){
; 0000 016D unsigned char keypad_input(){

	.CSEG
_keypad_input:
; .FSTART _keypad_input
; 0000 016E 
; 0000 016F     unsigned char result = 255;
; 0000 0170         ////////////////////////  ROW1 ////////////////////////
; 0000 0171         KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0;
	ST   -Y,R17
;	result -> R17
	LDI  R17,255
	SBI  0x15,0
	CBI  0x15,1
	CALL SUBOPT_0x3
; 0000 0172         delay_ms(5);
; 0000 0173         if (KEYPAD_C1)
	SBIS 0x13,4
	RJMP _0x56
; 0000 0174         result = KEYPAD_NUM1;
	LDI  R17,LOW(1)
; 0000 0175         else if (KEYPAD_C2)
	RJMP _0x57
_0x56:
	SBIS 0x13,5
	RJMP _0x58
; 0000 0176         result = KEYPAD_NUM2;
	LDI  R17,LOW(2)
; 0000 0177         else if (KEYPAD_C3)
	RJMP _0x59
_0x58:
	SBIC 0x13,6
; 0000 0178         result = KEYPAD_NUM3;
	LDI  R17,LOW(3)
; 0000 0179 
; 0000 017A 
; 0000 017B         ////////////////////////  ROW2 ////////////////////////
; 0000 017C         KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0;
_0x59:
_0x57:
	CBI  0x15,0
	SBI  0x15,1
	CALL SUBOPT_0x3
; 0000 017D         delay_ms(5);
; 0000 017E         if (KEYPAD_C1)
	SBIS 0x13,4
	RJMP _0x63
; 0000 017F         result = KEYPAD_NUM4;
	LDI  R17,LOW(4)
; 0000 0180         else if (KEYPAD_C2)
	RJMP _0x64
_0x63:
	SBIS 0x13,5
	RJMP _0x65
; 0000 0181         result = KEYPAD_NUM5;
	LDI  R17,LOW(5)
; 0000 0182         else if (KEYPAD_C3)
	RJMP _0x66
_0x65:
	SBIC 0x13,6
; 0000 0183         result = KEYPAD_NUM6;
	LDI  R17,LOW(6)
; 0000 0184 
; 0000 0185 
; 0000 0186         ////////////////////////  ROW3 ////////////////////////
; 0000 0187         KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0;
_0x66:
_0x64:
	CBI  0x15,0
	CBI  0x15,1
	SBI  0x15,2
	CBI  0x15,3
; 0000 0188         delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0189         if (KEYPAD_C1)
	SBIS 0x13,4
	RJMP _0x70
; 0000 018A         result = KEYPAD_NUM7;
	LDI  R17,LOW(7)
; 0000 018B         else if (KEYPAD_C2)
	RJMP _0x71
_0x70:
	SBIS 0x13,5
	RJMP _0x72
; 0000 018C         result = KEYPAD_NUM8;
	LDI  R17,LOW(8)
; 0000 018D         else if (KEYPAD_C3)
	RJMP _0x73
_0x72:
	SBIC 0x13,6
; 0000 018E         result = KEYPAD_NUM9;
	LDI  R17,LOW(9)
; 0000 018F 
; 0000 0190 
; 0000 0191         ////////////////////////  ROW4 ////////////////////////
; 0000 0192         KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1;
_0x73:
_0x71:
	CBI  0x15,0
	CBI  0x15,1
	CBI  0x15,2
	SBI  0x15,3
; 0000 0193         delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 0194         if (KEYPAD_C1)
	SBIS 0x13,4
	RJMP _0x7D
; 0000 0195         result = KEYPAD_STAR;
	LDI  R17,LOW(10)
; 0000 0196         else if (KEYPAD_C2)
	RJMP _0x7E
_0x7D:
	SBIS 0x13,5
	RJMP _0x7F
; 0000 0197         result = KEYPAD_NUM0;
	LDI  R17,LOW(0)
; 0000 0198         else if (KEYPAD_C3)
	RJMP _0x80
_0x7F:
	SBIC 0x13,6
; 0000 0199         result = KEYPAD_HASH;
	LDI  R17,LOW(11)
; 0000 019A     return result;
_0x80:
_0x7E:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 019B }
; .FEND
;void calculate(){
; 0000 019C void calculate(){
_calculate:
; .FSTART _calculate
; 0000 019D 
; 0000 019E     char* ch;
; 0000 019F     bool flag = true;
; 0000 01A0     send_data(data);
	CALL __SAVELOCR4
;	*ch -> R16,R17
;	flag -> R19
	LDI  R19,1
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	RCALL _send_data
; 0000 01A1     strcat(data, "=");
	CALL SUBOPT_0x0
	__POINTW2MN _0x82,0
	CALL _strcat
; 0000 01A2     do {
_0x84:
; 0000 01A3         send_data("");
	__POINTW2MN _0x82,2
	RCALL _send_data
; 0000 01A4         *ch = read();
	RCALL _read
	MOVW R26,R16
	ST   X,R30
; 0000 01A5 
; 0000 01A6         if (*ch != '#') {
	LD   R26,X
	CPI  R26,LOW(0x23)
	BREQ _0x86
; 0000 01A7             strcat(data, ch);
	CALL SUBOPT_0x0
	MOVW R26,R16
	CALL _strcat
; 0000 01A8         } else {
	RJMP _0x87
_0x86:
; 0000 01A9             flag = false;
	LDI  R19,LOW(0)
; 0000 01AA         }
_0x87:
; 0000 01AB     } while(flag);
	CPI  R19,0
	BRNE _0x84
; 0000 01AC }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x82:
	.BYTE 0x3
;void send_data(char* d)
; 0000 01AE {

	.CSEG
_send_data:
; .FSTART _send_data
; 0000 01AF     int len = strlen(d);
; 0000 01B0     int i = 0;
; 0000 01B1 	for(; i < len; i++)
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*d -> Y+4
;	len -> R16,R17
;	i -> R18,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL _strlen
	MOVW R16,R30
	__GETWRN 18,19,0
_0x89:
	__CPWRR 18,19,16,17
	BRGE _0x8A
; 0000 01B2 	{
; 0000 01B3         SPDR = d[i];
	MOVW R30,R18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0xF,R30
; 0000 01B4         while((SPSR&(1<<SPIF))==0);
_0x8B:
	SBIS 0xE,7
	RJMP _0x8B
; 0000 01B5         delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 01B6     }
	__ADDWRN 18,19,1
	RJMP _0x89
_0x8A:
; 0000 01B7     SPDR = '#';
	LDI  R30,LOW(35)
	OUT  0xF,R30
; 0000 01B8     while((SPSR&(1<<SPIF))==0);
_0x8E:
	SBIS 0xE,7
	RJMP _0x8E
; 0000 01B9     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0000 01BA }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;char read()
; 0000 01BC {
_read:
; .FSTART _read
; 0000 01BD     while((SPSR&(1<<SPIF))==0);
_0x91:
	SBIS 0xE,7
	RJMP _0x91
; 0000 01BE     return SPDR;
	IN   R30,0xF
	RET
; 0000 01BF }
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
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
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
	RJMP _0x20E0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x20E0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R9,Y+1
	LDD  R8,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x4
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	MOV  R8,R30
	MOV  R9,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R9,R11
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R8
	MOV  R26,R8
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20E0001
_0x2000007:
_0x2000004:
	INC  R9
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20E0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
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
	LDD  R11,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	CALL SUBOPT_0x5
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
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
_0x20E0001:
	ADIW R28,1
	RET
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG
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
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND

	.CSEG

	.CSEG

	.DSEG
_data:
	.BYTE 0x14
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_data)
	LDI  R31,HIGH(_data)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	CALL _keypad_input
	MOV  R4,R30
	TST  R4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	CALL _strcat
	LDI  R30,LOW(1)
	MOV  R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CBI  0x15,2
	CBI  0x15,3
	LDI  R26,LOW(5)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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

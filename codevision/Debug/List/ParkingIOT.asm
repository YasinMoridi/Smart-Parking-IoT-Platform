
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	JMP  _usart_rx_isr
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

_0x0:
	.DB  0x66,0x75,0x6C,0x6C,0x0,0x61,0x76,0x61
	.DB  0x69,0x6C,0x61,0x62,0x6C,0x65,0x0,0x7B
	.DB  0x22,0x63,0x61,0x72,0x73,0x22,0x3A,0x25
	.DB  0x64,0x2C,0x22,0x63,0x61,0x70,0x61,0x63
	.DB  0x69,0x74,0x79,0x22,0x3A,0x25,0x64,0x2C
	.DB  0x22,0x61,0x76,0x61,0x69,0x6C,0x61,0x62
	.DB  0x6C,0x65,0x22,0x3A,0x25,0x64,0x2C,0x22
	.DB  0x73,0x74,0x61,0x74,0x75,0x73,0x22,0x3A
	.DB  0x22,0x25,0x73,0x22,0x2C,0x22,0x65,0x76
	.DB  0x65,0x6E,0x74,0x22,0x3A,0x22,0x25,0x73
	.DB  0x22,0x7D,0xD,0xA,0x0,0x52,0x58,0x3A
	.DB  0x0,0x6F,0x70,0x65,0x6E,0x5F,0x67,0x61
	.DB  0x74,0x65,0x5F,0x69,0x6E,0x0,0x6D,0x61
	.DB  0x6E,0x75,0x61,0x6C,0x5F,0x69,0x6E,0x0
	.DB  0x6F,0x70,0x65,0x6E,0x5F,0x67,0x61,0x74
	.DB  0x65,0x5F,0x6F,0x75,0x74,0x0,0x6D,0x61
	.DB  0x6E,0x75,0x61,0x6C,0x5F,0x6F,0x75,0x74
	.DB  0x0,0x43,0x61,0x72,0x73,0x3A,0x25,0x32
	.DB  0x64,0x2F,0x25,0x32,0x64,0x20,0x20,0x20
	.DB  0x20,0x0,0x2A,0x2A,0x2A,0x20,0x46,0x55
	.DB  0x4C,0x4C,0x20,0x2A,0x2A,0x2A,0x20,0x20
	.DB  0x20,0x0,0x46,0x72,0x65,0x65,0x3A,0x25
	.DB  0x32,0x64,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x65,0x6E,0x74,0x65,0x72,0x0
	.DB  0x64,0x65,0x6E,0x69,0x65,0x64,0x0,0x65
	.DB  0x78,0x69,0x74,0x0,0x53,0x6D,0x61,0x72
	.DB  0x74,0x20,0x50,0x61,0x72,0x6B,0x69,0x6E
	.DB  0x67,0x0,0x53,0x79,0x73,0x74,0x65,0x6D
	.DB  0x20,0x52,0x65,0x61,0x64,0x79,0x0,0x62
	.DB  0x6F,0x6F,0x74,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _0x12
	.DW  _0x0*2

	.DW  0x0A
	.DW  _0x12+5
	.DW  _0x0*2+5

	.DW  0x04
	.DW  _0x14
	.DW  _0x0*2+85

	.DW  0x03
	.DW  _0x14+4
	.DW  _0x0*2+82

	.DW  0x0D
	.DW  _0x14+7
	.DW  _0x0*2+89

	.DW  0x0A
	.DW  _0x14+20
	.DW  _0x0*2+102

	.DW  0x0E
	.DW  _0x14+30
	.DW  _0x0*2+112

	.DW  0x0B
	.DW  _0x14+44
	.DW  _0x0*2+126

	.DW  0x06
	.DW  _0x61
	.DW  _0x0*2+186

	.DW  0x07
	.DW  _0x61+6
	.DW  _0x0*2+192

	.DW  0x05
	.DW  _0x6B
	.DW  _0x0*2+199

	.DW  0x05
	.DW  _0x6F
	.DW  _0x0*2+231

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
	.ORG 0x160

	.CSEG
;/*****************************************************
;Project : Smart Parking Access Control System
;Version : 2.1 - ATmega16 Port
;Author  : Yasin Moridi
;
;Hardware:
;  - ATmega16 @ 8MHz
;  - PORTA.0 : Push Button Entry (active LOW)
;  - PORTA.1 : IR Sensor Exit   (active LOW)
;  - PORTB.0 : LED OK   (green)
;  - PORTB.1 : LED FULL (red)
;  - PORTB.2 : Gate IN
;  - PORTB.3 : Gate OUT
;  - PORTC   : LCD 16x2 (4-bit)
;  - PORTD.0 : RXD (UART)
;  - PORTD.1 : TXD (UART)
;*****************************************************/
;
;#include <mega16.h>      // <-- ATmega16
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;#include <stdlib.h>
;
;#pragma warn-
;
;/* ------------------------------------------------
;   LCD pins (PORTC, 4-bit)
;   ------------------------------------------------ */
;#define LCD_RS      PORTC.0
;#define LCD_RW      PORTC.1
;#define LCD_EN      PORTC.2
;#define LCD_D4      PORTC.4
;#define LCD_D5      PORTC.5
;#define LCD_D6      PORTC.6
;#define LCD_D7      PORTC.7
;
;#define LCD_RS_DIR  DDRC.0
;#define LCD_RW_DIR  DDRC.1
;#define LCD_EN_DIR  DDRC.2
;#define LCD_D4_DIR  DDRC.4
;#define LCD_D5_DIR  DDRC.5
;#define LCD_D6_DIR  DDRC.6
;#define LCD_D7_DIR  DDRC.7
;
;/* ------------------------------------------------
;   I/O pins
;   ------------------------------------------------ */
;#define SENSOR_ENTRY  PINA.0
;#define SENSOR_EXIT   PINA.1
;
;#define LED_OK        PORTB.0
;#define LED_FULL      PORTB.1
;#define GATE_IN       PORTB.2
;#define GATE_OUT      PORTB.3
;
;/* ------------------------------------------------
;   Config
;   ------------------------------------------------ */
;#define CAPACITY      10
;#define GATE_OPEN_MS  1500
;#define DEBOUNCE_MS   50
;
;/* ------------------------------------------------
;   UART - ATmega16 @ 8MHz -> 9600 baud
;   UBRR = (8000000 / (16 * 9600)) - 1 = 51
;   ------------------------------------------------ */
;#define UBRR_VAL    51
;#define RX_BUF_SIZE 32       // ATmega16: 1KB RAM, buffer òÊçòù —
;
;volatile char          rx_buffer[RX_BUF_SIZE];
;volatile unsigned char rx_index = 0;
;volatile unsigned char rx_ready = 0;
;
;volatile int cars = 0;
;
;/* ------------------------------------------------
;   UART - ATmega16
;   —ÃÌ” —Â« »« ATmega32 Ìò”«‰ «”  «„«
;   UCSRC »«Ìœ »« URSEL=1 ‰Ê‘ Â ‘Êœ (shared address »« UBRRH)
;   ------------------------------------------------ */
;void uart_init(void) {
; 0000 0052 void uart_init(void) {

	.CSEG
_uart_init:
; .FSTART _uart_init
; 0000 0053     UBRRH = 0;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0054     UBRRL = UBRR_VAL;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0055     UCSRB = (1 << RXCIE) | (1 << TXEN) | (1 << RXEN);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0056     // URSEL=1 »—«Ì ‰Ê‘ ‰ —ÊÌ UCSRC (‰Â UBRRH)
; 0000 0057     UCSRC = (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0); // 8N1
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0058 }
	RET
; .FEND
;
;interrupt [USART_RXC] void usart_rx_isr(void) {
; 0000 005A interrupt [12] void usart_rx_isr(void) {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 005B     char c = UDR;
; 0000 005C     if (rx_ready) return;
	ST   -Y,R17
;	c -> R17
	IN   R17,12
	LDS  R30,_rx_ready
	CPI  R30,0
	BRNE _0x7D
; 0000 005D     if (c == '\n' || c == '\r') {
	CPI  R17,10
	BREQ _0x5
	CPI  R17,13
	BRNE _0x4
_0x5:
; 0000 005E         if (rx_index > 0) {
	LDS  R26,_rx_index
	CPI  R26,LOW(0x1)
	BRLO _0x7
; 0000 005F             rx_buffer[rx_index] = '\0';
	LDS  R30,_rx_index
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0060             rx_ready = 1;
	LDI  R30,LOW(1)
	STS  _rx_ready,R30
; 0000 0061             rx_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_index,R30
; 0000 0062         }
; 0000 0063     } else {
_0x7:
	RJMP _0x8
_0x4:
; 0000 0064         if (rx_index < RX_BUF_SIZE - 1)
	LDS  R26,_rx_index
	CPI  R26,LOW(0x1F)
	BRSH _0x9
; 0000 0065             rx_buffer[rx_index++] = c;
	LDS  R30,_rx_index
	SUBI R30,-LOW(1)
	STS  _rx_index,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R17
; 0000 0066         else
	RJMP _0xA
_0x9:
; 0000 0067             rx_index = 0;
	LDI  R30,LOW(0)
	STS  _rx_index,R30
; 0000 0068     }
_0xA:
_0x8:
; 0000 0069 }
_0x7D:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void uart_send_char(char c) {
; 0000 006B void uart_send_char(char c) {
_uart_send_char:
; .FSTART _uart_send_char
; 0000 006C     while (!(UCSRA & (1 << UDRE)));
	ST   -Y,R26
;	c -> Y+0
_0xB:
	SBIS 0xB,5
	RJMP _0xB
; 0000 006D     UDR = c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 006E }
	RJMP _0x20A0006
; .FEND
;
;void uart_send_string(char *s) {
; 0000 0070 void uart_send_string(char *s) {
_uart_send_string:
; .FSTART _uart_send_string
; 0000 0071     while (*s) uart_send_char(*s++);
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0xE:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x10
	CALL SUBOPT_0x0
	RCALL _uart_send_char
	RJMP _0xE
_0x10:
; 0000 0072 }
	RJMP _0x20A0004
; .FEND
;
;void uart_send_state(char *event) {
; 0000 0074 void uart_send_state(char *event) {
_uart_send_state:
; .FSTART _uart_send_state
; 0000 0075     char buf[100];
; 0000 0076     char status[12];
; 0000 0077     int avail = CAPACITY - cars;
; 0000 0078 
; 0000 0079     if (cars >= CAPACITY)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,49
	ST   -Y,R17
	ST   -Y,R16
;	*event -> Y+114
;	buf -> Y+14
;	status -> Y+2
;	avail -> R16,R17
	CALL SUBOPT_0x1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R16,R30
	CALL SUBOPT_0x1
	SBIW R26,10
	BRLT _0x11
; 0000 007A         strcpy(status, "full");
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x12,0
	RJMP _0x79
; 0000 007B     else
_0x11:
; 0000 007C         strcpy(status, "available");
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x12,5
_0x79:
	CALL _strcpy
; 0000 007D 
; 0000 007E     sprintf(buf,
; 0000 007F         "{\"cars\":%d,\"capacity\":%d,\"available\":%d,\"status\":\"%s\",\"event\":\"%s\"}\r\n",
; 0000 0080         cars,
; 0000 0081         CAPACITY,
; 0000 0082         avail,
; 0000 0083         status,
; 0000 0084         event);
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x2
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,18
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETW1SX 134
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,20
	CALL _sprintf
	ADIW R28,24
; 0000 0085 
; 0000 0086     uart_send_string(buf);
	MOVW R26,R28
	ADIW R26,14
	RCALL _uart_send_string
; 0000 0087 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,53
	RET
; .FEND

	.DSEG
_0x12:
	.BYTE 0xF
;
;/* ------------------------------------------------
;   Command parser
;   {"cmd":"open_gate_in"}
;   {"cmd":"open_gate_out"}
;   ------------------------------------------------ */
;void parse_command(char *str) {
; 0000 008E void parse_command(char *str) {

	.CSEG
_parse_command:
; .FSTART _parse_command
; 0000 008F uart_send_string("RX:");
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
	__POINTW2MN _0x14,0
	RCALL _uart_send_string
; 0000 0090     uart_send_string(str);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _uart_send_string
; 0000 0091     uart_send_string("\r\n");
	__POINTW2MN _0x14,4
	RCALL _uart_send_string
; 0000 0092     if (strstr(str, "open_gate_in")) {
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x14,7
	CALL _strstr
	SBIW R30,0
	BREQ _0x15
; 0000 0093         GATE_IN = 1;
	CALL SUBOPT_0x3
; 0000 0094         delay_ms(GATE_OPEN_MS);
; 0000 0095         GATE_IN = 0;
; 0000 0096         uart_send_state("manual_in");
	__POINTW2MN _0x14,20
	RJMP _0x7A
; 0000 0097     } else if (strstr(str, "open_gate_out")) {
_0x15:
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x14,30
	CALL _strstr
	SBIW R30,0
	BREQ _0x1B
; 0000 0098         GATE_OUT = 1;
	CALL SUBOPT_0x4
; 0000 0099         delay_ms(GATE_OPEN_MS);
; 0000 009A         GATE_OUT = 0;
; 0000 009B         uart_send_state("manual_out");
	__POINTW2MN _0x14,44
_0x7A:
	RCALL _uart_send_state
; 0000 009C     }
; 0000 009D }
_0x1B:
	RJMP _0x20A0004
; .FEND

	.DSEG
_0x14:
	.BYTE 0x37
;
;/* ------------------------------------------------
;   LCD (4-bit mode)
;   ------------------------------------------------ */
;void lcd_pulse(void) {
; 0000 00A2 void lcd_pulse(void) {

	.CSEG
_lcd_pulse:
; .FSTART _lcd_pulse
; 0000 00A3     LCD_EN = 1;
	SBI  0x15,2
; 0000 00A4     delay_us(1);
	__DELAY_USB 3
; 0000 00A5     LCD_EN = 0;
	CBI  0x15,2
; 0000 00A6     delay_us(100);
	__DELAY_USW 200
; 0000 00A7 }
	RET
; .FEND
;
;void lcd_nibble(unsigned char n) {
; 0000 00A9 void lcd_nibble(unsigned char n) {
_lcd_nibble:
; .FSTART _lcd_nibble
; 0000 00AA     LCD_D4 = (n >> 0) & 1;
	ST   -Y,R26
;	n -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x24
	CBI  0x15,4
	RJMP _0x25
_0x24:
	SBI  0x15,4
_0x25:
; 0000 00AB     LCD_D5 = (n >> 1) & 1;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x26
	CBI  0x15,5
	RJMP _0x27
_0x26:
	SBI  0x15,5
_0x27:
; 0000 00AC     LCD_D6 = (n >> 2) & 1;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x28
	CBI  0x15,6
	RJMP _0x29
_0x28:
	SBI  0x15,6
_0x29:
; 0000 00AD     LCD_D7 = (n >> 3) & 1;
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x2A
	CBI  0x15,7
	RJMP _0x2B
_0x2A:
	SBI  0x15,7
_0x2B:
; 0000 00AE     lcd_pulse();
	RCALL _lcd_pulse
; 0000 00AF }
	RJMP _0x20A0006
; .FEND
;
;void lcd_byte(unsigned char b) {
; 0000 00B1 void lcd_byte(unsigned char b) {
_lcd_byte:
; .FSTART _lcd_byte
; 0000 00B2     lcd_nibble(b >> 4);
	ST   -Y,R26
;	b -> Y+0
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	MOV  R26,R30
	RCALL _lcd_nibble
; 0000 00B3     lcd_nibble(b & 0x0F);
	LD   R30,Y
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	RCALL _lcd_nibble
; 0000 00B4 }
	RJMP _0x20A0006
; .FEND
;
;void lcd_cmd(unsigned char c) {
; 0000 00B6 void lcd_cmd(unsigned char c) {
_lcd_cmd:
; .FSTART _lcd_cmd
; 0000 00B7     LCD_RS = 0;
	ST   -Y,R26
;	c -> Y+0
	CBI  0x15,0
; 0000 00B8     LCD_RW = 0;
	CBI  0x15,1
; 0000 00B9     lcd_byte(c);
	LD   R26,Y
	RCALL _lcd_byte
; 0000 00BA     delay_ms(2);
	LDI  R26,LOW(2)
	RJMP _0x20A0005
; 0000 00BB }
; .FEND
;
;void lcd_char(unsigned char c) {
; 0000 00BD void lcd_char(unsigned char c) {
_lcd_char:
; .FSTART _lcd_char
; 0000 00BE     LCD_RS = 1;
	ST   -Y,R26
;	c -> Y+0
	SBI  0x15,0
; 0000 00BF     LCD_RW = 0;
	CBI  0x15,1
; 0000 00C0     lcd_byte(c);
	LD   R26,Y
	RCALL _lcd_byte
; 0000 00C1     delay_ms(1);
	LDI  R26,LOW(1)
_0x20A0005:
	LDI  R27,0
	CALL _delay_ms
; 0000 00C2 }
_0x20A0006:
	ADIW R28,1
	RET
; .FEND
;
;void lcd_init(void) {
; 0000 00C4 void lcd_init(void) {
_lcd_init:
; .FSTART _lcd_init
; 0000 00C5     LCD_RS_DIR = 1; LCD_RW_DIR = 1; LCD_EN_DIR = 1;
	SBI  0x14,0
	SBI  0x14,1
	SBI  0x14,2
; 0000 00C6     LCD_D4_DIR = 1; LCD_D5_DIR = 1; LCD_D6_DIR = 1; LCD_D7_DIR = 1;
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
; 0000 00C7 
; 0000 00C8     delay_ms(50);
	CALL SUBOPT_0x5
; 0000 00C9     LCD_RS = 0; LCD_RW = 0; LCD_EN = 0;
	CBI  0x15,0
	CBI  0x15,1
	CBI  0x15,2
; 0000 00CA 
; 0000 00CB     lcd_nibble(0x03); delay_ms(5);
	LDI  R26,LOW(3)
	RCALL _lcd_nibble
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 00CC     lcd_nibble(0x03); delay_us(150);
	LDI  R26,LOW(3)
	RCALL _lcd_nibble
	__DELAY_USW 300
; 0000 00CD     lcd_nibble(0x03);
	LDI  R26,LOW(3)
	RCALL _lcd_nibble
; 0000 00CE     lcd_nibble(0x02);   // 4-bit mode
	LDI  R26,LOW(2)
	RCALL _lcd_nibble
; 0000 00CF 
; 0000 00D0     lcd_cmd(0x28);      // 4-bit, 2 line, 5x8
	LDI  R26,LOW(40)
	RCALL _lcd_cmd
; 0000 00D1     lcd_cmd(0x0C);      // display on, cursor off
	LDI  R26,LOW(12)
	RCALL _lcd_cmd
; 0000 00D2     lcd_cmd(0x06);      // entry mode: increment, no shift
	LDI  R26,LOW(6)
	RCALL _lcd_cmd
; 0000 00D3     lcd_cmd(0x01);      // clear
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 00D4     delay_ms(2);
	LDI  R26,LOW(2)
	RJMP _0x20A0003
; 0000 00D5 }
; .FEND
;
;void lcd_clear(void) {
; 0000 00D7 void lcd_clear(void) {
_lcd_clear:
; .FSTART _lcd_clear
; 0000 00D8     lcd_cmd(0x01);
	LDI  R26,LOW(1)
	RCALL _lcd_cmd
; 0000 00D9     delay_ms(2);
	LDI  R26,LOW(2)
	RJMP _0x20A0003
; 0000 00DA }
; .FEND
;
;void lcd_goto(unsigned char x, unsigned char y) {
; 0000 00DC void lcd_goto(unsigned char x, unsigned char y) {
_lcd_goto:
; .FSTART _lcd_goto
; 0000 00DD     if (y == 0)
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x48
; 0000 00DE         lcd_cmd(0x80 + x);
	LDD  R26,Y+1
	SUBI R26,-LOW(128)
	RJMP _0x7B
; 0000 00DF     else
_0x48:
; 0000 00E0         lcd_cmd(0xC0 + x);
	LDD  R26,Y+1
	SUBI R26,-LOW(192)
_0x7B:
	RCALL _lcd_cmd
; 0000 00E1 }
	RJMP _0x20A0004
; .FEND
;
;void lcd_puts(char *s) {
; 0000 00E3 void lcd_puts(char *s) {
_lcd_puts:
; .FSTART _lcd_puts
; 0000 00E4     while (*s) lcd_char(*s++);
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x4A:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x4C
	CALL SUBOPT_0x0
	RCALL _lcd_char
	RJMP _0x4A
_0x4C:
; 0000 00E5 }
	RJMP _0x20A0004
; .FEND
;
;void lcd_puts_f(flash char *s) {
; 0000 00E7 void lcd_puts_f(flash char *s) {
_lcd_puts_f:
; .FSTART _lcd_puts_f
; 0000 00E8     while (*s) lcd_char(*s++);
	ST   -Y,R27
	ST   -Y,R26
;	*s -> Y+0
_0x4D:
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x4F
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,1
	LPM  R26,Z
	RCALL _lcd_char
	RJMP _0x4D
_0x4F:
; 0000 00E9 }
_0x20A0004:
	ADIW R28,2
	RET
; .FEND
;
;/* ------------------------------------------------
;   Display & LEDs
;   ------------------------------------------------ */
;void update_leds(void) {
; 0000 00EE void update_leds(void) {
_update_leds:
; .FSTART _update_leds
; 0000 00EF     if (cars >= CAPACITY) {
	CALL SUBOPT_0x1
	SBIW R26,10
	BRLT _0x50
; 0000 00F0         LED_FULL = 1;
	SBI  0x18,1
; 0000 00F1         LED_OK   = 0;
	CBI  0x18,0
; 0000 00F2     } else {
	RJMP _0x55
_0x50:
; 0000 00F3         LED_FULL = 0;
	CBI  0x18,1
; 0000 00F4         LED_OK   = 1;
	SBI  0x18,0
; 0000 00F5     }
_0x55:
; 0000 00F6 }
	RET
; .FEND
;
;void display_status(void) {
; 0000 00F8 void display_status(void) {
_display_status:
; .FSTART _display_status
; 0000 00F9     char buf[17];
; 0000 00FA 
; 0000 00FB     lcd_goto(0, 0);
	SBIW R28,17
;	buf -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_goto
; 0000 00FC     sprintf(buf, "Cars:%2d/%2d    ", cars, CAPACITY);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,137
	CALL SUBOPT_0x2
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 00FD     lcd_puts(buf);
	MOVW R26,R28
	RCALL _lcd_puts
; 0000 00FE 
; 0000 00FF     lcd_goto(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_goto
; 0000 0100     if (cars >= CAPACITY) {
	CALL SUBOPT_0x1
	SBIW R26,10
	BRLT _0x5A
; 0000 0101         lcd_puts_f("*** FULL ***   ");
	__POINTW2FN _0x0,154
	RCALL _lcd_puts_f
; 0000 0102     } else {
	RJMP _0x5B
_0x5A:
; 0000 0103         sprintf(buf, "Free:%2d       ", CAPACITY - cars);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,170
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	SUB  R30,R26
	SBC  R31,R27
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0104         lcd_puts(buf);
	MOVW R26,R28
	RCALL _lcd_puts
; 0000 0105     }
_0x5B:
; 0000 0106 }
	ADIW R28,17
	RET
; .FEND
;
;/* ------------------------------------------------
;   Gate logic
;   ------------------------------------------------ */
;void handle_entry(void) {
; 0000 010B void handle_entry(void) {
_handle_entry:
; .FSTART _handle_entry
; 0000 010C     if (cars < CAPACITY) {
	CALL SUBOPT_0x1
	SBIW R26,10
	BRGE _0x5C
; 0000 010D         cars++;
	LDI  R26,LOW(_cars)
	LDI  R27,HIGH(_cars)
	CALL SUBOPT_0x6
; 0000 010E         GATE_IN = 1;
	CALL SUBOPT_0x3
; 0000 010F         delay_ms(GATE_OPEN_MS);
; 0000 0110         GATE_IN = 0;
; 0000 0111         display_status();
	CALL SUBOPT_0x7
; 0000 0112         update_leds();
; 0000 0113         uart_send_state("enter");
	__POINTW2MN _0x61,0
	RJMP _0x7C
; 0000 0114     } else {
_0x5C:
; 0000 0115         uart_send_state("denied");
	__POINTW2MN _0x61,6
_0x7C:
	RCALL _uart_send_state
; 0000 0116     }
; 0000 0117     while (SENSOR_ENTRY == 0);
_0x63:
	SBIS 0x19,0
	RJMP _0x63
; 0000 0118     delay_ms(200);
	RJMP _0x20A0002
; 0000 0119 }
; .FEND

	.DSEG
_0x61:
	.BYTE 0xD
;
;void handle_exit(void) {
; 0000 011B void handle_exit(void) {

	.CSEG
_handle_exit:
; .FSTART _handle_exit
; 0000 011C     if (cars > 0) {
	CALL SUBOPT_0x1
	CALL __CPW02
	BRGE _0x66
; 0000 011D         cars--;
	LDI  R26,LOW(_cars)
	LDI  R27,HIGH(_cars)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 011E         GATE_OUT = 1;
	CALL SUBOPT_0x4
; 0000 011F         delay_ms(GATE_OPEN_MS);
; 0000 0120         GATE_OUT = 0;
; 0000 0121         display_status();
	CALL SUBOPT_0x7
; 0000 0122         update_leds();
; 0000 0123         uart_send_state("exit");
	__POINTW2MN _0x6B,0
	RCALL _uart_send_state
; 0000 0124     }
; 0000 0125     while (SENSOR_EXIT == 0);
_0x66:
_0x6C:
	SBIS 0x19,1
	RJMP _0x6C
; 0000 0126     delay_ms(200);
_0x20A0002:
	LDI  R26,LOW(200)
_0x20A0003:
	LDI  R27,0
	CALL _delay_ms
; 0000 0127 }
	RET
; .FEND

	.DSEG
_0x6B:
	.BYTE 0x5
;
;/* ------------------------------------------------
;   Main
;   ------------------------------------------------ */
;void main(void) {
; 0000 012C void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 012D 
; 0000 012E     DDRA  = 0x00; PORTA = 0x03;   // PA0, PA1: input + pull-up
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDI  R30,LOW(3)
	OUT  0x1B,R30
; 0000 012F     DDRB  = 0x0F; PORTB = 0x00;   // PB0..PB3: output
	LDI  R30,LOW(15)
	OUT  0x17,R30
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0130     DDRC  = 0x00; PORTC = 0x00;   // LCD init handles DDRC
	OUT  0x14,R30
	OUT  0x15,R30
; 0000 0131     DDRD  = 0x02; PORTD = 0x00;   // PD1=TXD output, PD0=RXD input
	LDI  R30,LOW(2)
	OUT  0x11,R30
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0132 
; 0000 0133     uart_init();
	RCALL _uart_init
; 0000 0134     lcd_init();
	RCALL _lcd_init
; 0000 0135     lcd_clear();
	RCALL _lcd_clear
; 0000 0136 
; 0000 0137     lcd_goto(0, 0); lcd_puts_f("Smart Parking");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_goto
	__POINTW2FN _0x0,204
	RCALL _lcd_puts_f
; 0000 0138     lcd_goto(0, 1); lcd_puts_f("System Ready");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_goto
	__POINTW2FN _0x0,218
	RCALL _lcd_puts_f
; 0000 0139     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 013A     lcd_clear();
	RCALL _lcd_clear
; 0000 013B 
; 0000 013C     display_status();
	CALL SUBOPT_0x7
; 0000 013D     update_leds();
; 0000 013E     uart_send_state("boot");
	__POINTW2MN _0x6F,0
	RCALL _uart_send_state
; 0000 013F 
; 0000 0140     #asm("sei")
	sei
; 0000 0141 
; 0000 0142     while (1) {
_0x70:
; 0000 0143         if (rx_ready) {
	LDS  R30,_rx_ready
	CPI  R30,0
	BREQ _0x73
; 0000 0144             parse_command((char*)rx_buffer);
	LDI  R26,LOW(_rx_buffer)
	LDI  R27,HIGH(_rx_buffer)
	RCALL _parse_command
; 0000 0145             rx_ready = 0;
	LDI  R30,LOW(0)
	STS  _rx_ready,R30
; 0000 0146         }
; 0000 0147 
; 0000 0148         if (SENSOR_ENTRY == 0) {
_0x73:
	SBIC 0x19,0
	RJMP _0x74
; 0000 0149             delay_ms(DEBOUNCE_MS);
	CALL SUBOPT_0x5
; 0000 014A             if (SENSOR_ENTRY == 0)
	SBIS 0x19,0
; 0000 014B                 handle_entry();
	RCALL _handle_entry
; 0000 014C         }
; 0000 014D 
; 0000 014E         if (SENSOR_EXIT == 0) {
_0x74:
	SBIC 0x19,1
	RJMP _0x76
; 0000 014F             delay_ms(DEBOUNCE_MS);
	CALL SUBOPT_0x5
; 0000 0150             if (SENSOR_EXIT == 0)
	SBIS 0x19,1
; 0000 0151                 handle_exit();
	RCALL _handle_exit
; 0000 0152         }
; 0000 0153 
; 0000 0154         delay_ms(10);
_0x76:
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0155     }
	RJMP _0x70
; 0000 0156 }
_0x78:
	RJMP _0x78
; .FEND

	.DSEG
_0x6F:
	.BYTE 0x5
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x6
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x6
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x8
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x8
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x9
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xA
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x9
	CALL SUBOPT_0xC
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x8
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xA
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0xD
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0xD
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
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
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x20
_rx_index:
	.BYTE 0x1
_rx_ready:
	.BYTE 0x1
_cars:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R26,_cars
	LDS  R27,_cars+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_cars
	LDS  R31,_cars+1
	CALL __CWD1
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	SBI  0x18,2
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SBI  0x18,3
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	CALL _delay_ms
	CBI  0x18,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _display_status
	JMP  _update_leds

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

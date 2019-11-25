
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8/000000 MHz
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _validationCodeLength=R4
	.DEF _validationCodeLength_msb=R5
	.DEF _opened=R7
	.DEF _inputPressed=R6
	.DEF _resetPressed=R9
	.DEF _oneAdded=R8
	.DEF _oneAddedCount=R10
	.DEF _oneAddedCount_msb=R11
	.DEF _inputPressedCount=R12
	.DEF _inputPressedCount_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x4,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x1
_0x4:
	.DB  0x3F,0x0,0x6,0x0,0x40
_0x5:
	.DB  0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x07
	.DW  _validationCode
	.DW  _0x3*2

	.DW  0x05
	.DW  _digits
	.DW  _0x4*2

	.DW  0x08
	.DW  _input
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
	.ORG 0x160

	.CSEG
;/*
; * HasChangeCode.c
; *
; * Created: 13/10/2019 08:37:14 È.Ù
; * Author: Alireza
; */
;
;
;#include <io.h>
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
;#include <stdbool.h>
;#include <stdio.h>
;    int validationCode[] = {1, 1, 1, 1};

	.DSEG
;    int validationCodeLength = 4 ;
;    //,1,1, 0,0,0};
;    bool opened = false;
;    bool inputPressed = false;
;    bool resetPressed = false;
;    bool oneAdded = false;
;    int oneAddedCount = 0;
;    int inputPressedCount = 0;
;    int resetPressedCount = 0;
;    bool changeCodeMode = false;
;    int inputLength = 0;
;    unsigned int digits[4] = {0x3f, 0x06, 0b01000000};
;    int input[validationCodeLength] = {-1, -1, -1, -1};
;
;
;    void checkCode(){
; 0000 001C void checkCode(){

	.CSEG
_checkCode:
; .FSTART _checkCode
; 0000 001D     bool correct = true;
; 0000 001E     int a = 0;
; 0000 001F     //if (inputLength == validationCodeLength)
; 0000 0020     for (a = 0; a<validationCodeLength ; a++){
	CALL __SAVELOCR4
;	correct -> R17
;	a -> R18,R19
	LDI  R17,1
	__GETWRN 18,19,0
	__GETWRN 18,19,0
_0x7:
	__CPWRR 18,19,4,5
	BRGE _0x8
; 0000 0021         if (validationCode[a] != input[a])
	MOVW R30,R18
	LDI  R26,LOW(_validationCode)
	LDI  R27,HIGH(_validationCode)
	CALL SUBOPT_0x0
	LD   R0,X+
	LD   R1,X
	MOVW R30,R18
	CALL SUBOPT_0x1
	CALL __GETW1P
	CP   R30,R0
	CPC  R31,R1
	BREQ _0x9
; 0000 0022             correct = false;
	LDI  R17,LOW(0)
; 0000 0023     }// else correct = false;
_0x9:
	__ADDWRN 18,19,1
	RJMP _0x7
_0x8:
; 0000 0024         if (correct){
	CPI  R17,0
	BREQ _0xA
; 0000 0025           PORTC = digits[3];
	__GETB1MN _digits,6
	OUT  0x15,R30
; 0000 0026           PORTA.0 = 1;
	SBI  0x1B,0
; 0000 0027           opened = true;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0028         }
; 0000 0029     }
_0xA:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;    void changeCode(){
; 0000 002B void changeCode(){
_changeCode:
; .FSTART _changeCode
; 0000 002C     int a =0;
; 0000 002D         for (a = 0; a<validationCodeLength;a++)
	ST   -Y,R17
	ST   -Y,R16
;	a -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0xE:
	__CPWRR 16,17,4,5
	BRGE _0xF
; 0000 002E             validationCode[a] = input[a];
	MOVW R30,R16
	LDI  R26,LOW(_validationCode)
	LDI  R27,HIGH(_validationCode)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R16
	CALL SUBOPT_0x1
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	__ADDWRN 16,17,1
	RJMP _0xE
_0xF:
; 0000 002F inputPressedCount = 0;
	CALL SUBOPT_0x2
; 0000 0030         inputLength = 0;
; 0000 0031         a = 0;
; 0000 0032         for (a = 0; a<validationCodeLength; a++)
	__GETWRN 16,17,0
_0x11:
	__CPWRR 16,17,4,5
	BRGE _0x12
; 0000 0033         input[a] = -1;
	MOVW R30,R16
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
	__ADDWRN 16,17,1
	RJMP _0x11
_0x12:
; 0000 0034 PORTA.0 = 0;
	CBI  0x1B,0
; 0000 0035         opened = false;
	CLR  R7
; 0000 0036         changeCodeMode = false;
	LDI  R30,LOW(0)
	STS  _changeCodeMode,R30
; 0000 0037     }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;    interrupt [TIM0_OVF] void timer0_ovf_isr(void){
; 0000 0039 interrupt [10] void timer0_ovf_isr(void){
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x4
; 0000 003A         TCNT0=0xB2;
	LDI  R30,LOW(178)
	OUT  0x32,R30
; 0000 003B         if (inputPressed)
	TST  R6
	BREQ _0x15
; 0000 003C             inputPressedCount++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 003D         if (resetPressed)
_0x15:
	TST  R9
	BREQ _0x16
; 0000 003E             resetPressedCount++;
	LDI  R26,LOW(_resetPressedCount)
	LDI  R27,HIGH(_resetPressedCount)
	CALL SUBOPT_0x5
; 0000 003F             if (!changeCodeMode && inputPressed && inputPressedCount == 13){
_0x16:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BRNE _0x18
	TST  R6
	BREQ _0x18
	CALL SUBOPT_0x6
	BREQ _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 0040               PORTC = digits[0];
	CALL SUBOPT_0x7
; 0000 0041               input[inputLength] = 0;
	CALL SUBOPT_0x8
; 0000 0042               inputLength++;
; 0000 0043               PORTB.0 = 1;
	CALL SUBOPT_0x9
; 0000 0044               oneAdded = true;
; 0000 0045               oneAddedCount = 1;
; 0000 0046               checkCode();
; 0000 0047               }
; 0000 0048               if (!changeCodeMode && inputPressed && inputPressedCount == 22){
_0x17:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BRNE _0x1D
	TST  R6
	BREQ _0x1D
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 0049               PORTC = digits[1];
	CALL SUBOPT_0xA
; 0000 004A               input[inputLength-1] = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 004B               PORTB.0 = 1;
	CALL SUBOPT_0x9
; 0000 004C               oneAdded = true;
; 0000 004D               oneAddedCount = 1;
; 0000 004E               checkCode();
; 0000 004F               }
; 0000 0050 
; 0000 0051             if (changeCodeMode && inputPressed && inputPressedCount == 13){
_0x1C:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x22
	TST  R6
	BREQ _0x22
	CALL SUBOPT_0x6
	BREQ _0x23
_0x22:
	RJMP _0x21
_0x23:
; 0000 0052               PORTC = digits[0];
	CALL SUBOPT_0x7
; 0000 0053               input[inputLength] = 0;
	CALL SUBOPT_0x8
; 0000 0054               inputLength++;
; 0000 0055               PORTB.0 = 1;
	CALL SUBOPT_0xB
; 0000 0056               oneAdded = true;
; 0000 0057               oneAddedCount = 1;
; 0000 0058 
; 0000 0059               }
; 0000 005A               if (changeCodeMode && inputPressed && inputPressedCount == 22){
_0x21:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x27
	TST  R6
	BREQ _0x27
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x28
_0x27:
	RJMP _0x26
_0x28:
; 0000 005B               PORTC = digits[1];
	CALL SUBOPT_0xA
; 0000 005C               input[inputLength-1] = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 005D               PORTB.0 = 1;
	CALL SUBOPT_0xB
; 0000 005E               oneAdded = true;
; 0000 005F               oneAddedCount = 1;
; 0000 0060               if (inputLength == validationCodeLength)
	CALL SUBOPT_0xC
	BRNE _0x2B
; 0000 0061                 changeCode();
	RCALL _changeCode
; 0000 0062               }
_0x2B:
; 0000 0063               if (resetPressed && resetPressedCount == 15 && !changeCodeMode){
_0x26:
	TST  R9
	BREQ _0x2D
	LDS  R26,_resetPressedCount
	LDS  R27,_resetPressedCount+1
	SBIW R26,15
	BRNE _0x2D
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
; 0000 0064                  changeCodeMode = true;
	LDI  R30,LOW(1)
	STS  _changeCodeMode,R30
; 0000 0065               }
; 0000 0066               else if (resetPressed && resetPressedCount == 15 && changeCodeMode){
	RJMP _0x2F
_0x2C:
	TST  R9
	BREQ _0x31
	LDS  R26,_resetPressedCount
	LDS  R27,_resetPressedCount+1
	SBIW R26,15
	BRNE _0x31
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BRNE _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 0067                  changeCodeMode = false;
	LDI  R30,LOW(0)
	STS  _changeCodeMode,R30
; 0000 0068                  resetPressedCount = 0;
	CALL SUBOPT_0xD
; 0000 0069                  PORTA.0 = 0;
	CBI  0x1B,0
; 0000 006A               }
; 0000 006B               if (changeCodeMode)
_0x30:
_0x2F:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x35
; 0000 006C                 PORTA.0 = ~PORTA.0;
	SBIS 0x1B,0
	RJMP _0x36
	CBI  0x1B,0
	RJMP _0x37
_0x36:
	SBI  0x1B,0
_0x37:
; 0000 006D                 if (oneAdded && oneAddedCount > 0){
_0x35:
	TST  R8
	BREQ _0x39
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRLT _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 006E                 PORTB.0 = 0;
	CBI  0x18,0
; 0000 006F                 oneAddedCount--;
	MOVW R30,R10
	SBIW R30,1
	MOVW R10,R30
; 0000 0070                 }
; 0000 0071     }
_0x38:
	RJMP _0x5F
; .FEND
;
;    interrupt [EXT_INT0] void ext_int0_isr(void){
; 0000 0073 interrupt [2] void ext_int0_isr(void){
_ext_int0_isr:
; .FSTART _ext_int0_isr
	CALL SUBOPT_0x4
; 0000 0074     if (PIND.2 == 1){
	SBIS 0x10,2
	RJMP _0x3D
; 0000 0075         if (!changeCodeMode){
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x5D
; 0000 0076         inputPressed = true;
; 0000 0077         }else if (changeCodeMode) inputPressed = true;}
	CPI  R30,0
	BREQ _0x40
_0x5D:
	LDI  R30,LOW(1)
	MOV  R6,R30
_0x40:
; 0000 0078         else {
	RJMP _0x41
_0x3D:
; 0000 0079         if (!changeCodeMode){
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x5E
; 0000 007A         inputPressed = false;
; 0000 007B         inputPressedCount = 0;
; 0000 007C         PORTC = digits[2];
; 0000 007D         }else if (changeCodeMode){
	CPI  R30,0
	BREQ _0x44
; 0000 007E         if (inputPressedCount > 13)
	CALL SUBOPT_0x6
	BRGE _0x45
; 0000 007F             if (inputLength == validationCodeLength)
	CALL SUBOPT_0xC
	BRNE _0x46
; 0000 0080                 changeCode();
	RCALL _changeCode
; 0000 0081             inputPressed = false;
_0x46:
_0x45:
_0x5E:
	CLR  R6
; 0000 0082             inputPressedCount = 0;
	CLR  R12
	CLR  R13
; 0000 0083             PORTC = digits[2];
	__GETB1MN _digits,4
	OUT  0x15,R30
; 0000 0084         }
; 0000 0085             }
_0x44:
_0x41:
; 0000 0086 
; 0000 0087     }
_0x5F:
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
;
;    interrupt [EXT_INT1] void ext_int1_isr(void){
; 0000 0089 interrupt [3] void ext_int1_isr(void){
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008A     int b = 0;
; 0000 008B         if (PIND.3 == 1){
	ST   -Y,R17
	ST   -Y,R16
;	b -> R16,R17
	__GETWRN 16,17,0
	SBIS 0x10,3
	RJMP _0x47
; 0000 008C         if (!changeCodeMode){
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BRNE _0x48
; 0000 008D         resetPressed = true;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 008E         inputPressedCount = 0;
	CALL SUBOPT_0x2
; 0000 008F         inputLength = 0;
; 0000 0090         for (b = 0; b<validationCodeLength; b++)
_0x4A:
	__CPWRR 16,17,4,5
	BRGE _0x4B
; 0000 0091         input[b] = -1;
	MOVW R30,R16
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
	__ADDWRN 16,17,1
	RJMP _0x4A
_0x4B:
; 0000 0092 PORTA.0 = 0;
	CBI  0x1B,0
; 0000 0093         opened = false;
	CLR  R7
; 0000 0094         }
; 0000 0095         else if (changeCodeMode){
	RJMP _0x4E
_0x48:
	LDS  R30,_changeCodeMode
	CPI  R30,0
	BREQ _0x4F
; 0000 0096         resetPressed = true;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0097         resetPressedCount = 0;
	CALL SUBOPT_0xD
; 0000 0098         inputLength = 0;
	LDI  R30,LOW(0)
	STS  _inputLength,R30
	STS  _inputLength+1,R30
; 0000 0099         for (b = 0; b<validationCodeLength; b++)
	__GETWRN 16,17,0
_0x51:
	__CPWRR 16,17,4,5
	BRGE _0x52
; 0000 009A         input[b] = -1;
	MOVW R30,R16
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
	__ADDWRN 16,17,1
	RJMP _0x51
_0x52:
; 0000 009B }
; 0000 009C         }else if (PIND.3 == 0) {resetPressed = false;
_0x4F:
_0x4E:
	RJMP _0x53
_0x47:
	SBIC 0x10,3
	RJMP _0x54
	CLR  R9
; 0000 009D         resetPressedCount = 0;
	CALL SUBOPT_0xD
; 0000 009E         }
; 0000 009F     }
_0x54:
_0x53:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void main(void){
; 0000 00A1 void main(void){
_main:
; .FSTART _main
; 0000 00A2     DDRA = 0b00000001;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 00A3     DDRB = 0b00000001;
	OUT  0x17,R30
; 0000 00A4     DDRD = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00A5     DDRC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00A6     PORTC = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00A7     PORTC = digits[2];
	__GETB1MN _digits,4
	OUT  0x15,R30
; 0000 00A8     PORTA.0 = 0;
	CBI  0x1B,0
; 0000 00A9     PORTB.0 = 0;
	CBI  0x18,0
; 0000 00AA     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00AB     TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 00AC     OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00AD     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00AE     GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00AF     MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0000 00B0     MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00B1     GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00B2 
; 0000 00B3     #asm("sei");
	sei
; 0000 00B4 while (1){
_0x59:
; 0000 00B5 
; 0000 00B6     }
	RJMP _0x59
; 0000 00B7 }
_0x5C:
	RJMP _0x5C
; .FEND
;
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

	.CSEG

	.CSEG

	.DSEG
_validationCode:
	.BYTE 0x8
_resetPressedCount:
	.BYTE 0x2
_changeCodeMode:
	.BYTE 0x1
_inputLength:
	.BYTE 0x2
_digits:
	.BYTE 0x8
_input:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_input)
	LDI  R27,HIGH(_input)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _inputLength,R30
	STS  _inputLength+1,R30
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDS  R30,_digits
	OUT  0x15,R30
	LDS  R30,_inputLength
	LDS  R31,_inputLength+1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	LDI  R26,LOW(_inputLength)
	LDI  R27,HIGH(_inputLength)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	SBI  0x18,0
	LDI  R30,LOW(1)
	MOV  R8,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	JMP  _checkCode

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__GETB1MN _digits,2
	OUT  0x15,R30
	LDS  R30,_inputLength
	LDS  R31,_inputLength+1
	SBIW R30,1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	SBI  0x18,0
	LDI  R30,LOW(1)
	MOV  R8,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R26,_inputLength
	LDS  R27,_inputLength+1
	CP   R4,R26
	CPC  R5,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	STS  _resetPressedCount,R30
	STS  _resetPressedCount+1,R30
	RET


	.CSEG
__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

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

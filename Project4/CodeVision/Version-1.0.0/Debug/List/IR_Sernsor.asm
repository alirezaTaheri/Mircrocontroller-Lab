
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
	.DEF _selectedItem=R4
	.DEF _selectedItem_msb=R5
	.DEF _showingItem=R6
	.DEF _showingItem_msb=R7
	.DEF _adcSelectedItem=R8
	.DEF _adcSelectedItem_msb=R9
	.DEF _adcShowingItem=R10
	.DEF _adcShowingItem_msb=R11
	.DEF _calibrationSelectedItem=R12
	.DEF _calibrationSelectedItem_msb=R13

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFF,0xFF,0x0,0x0
	.DB  0xFF,0xFF,0x0,0x0
	.DB  0xFF,0xFF

_0x4:
	.DB  LOW(_0x3),HIGH(_0x3),LOW(_0x3+15),HIGH(_0x3+15),LOW(_0x3+27),HIGH(_0x3+27)
_0x6:
	.DB  LOW(_0x5),HIGH(_0x5),LOW(_0x5+6),HIGH(_0x5+6),LOW(_0x5+12),HIGH(_0x5+12)
_0x8:
	.DB  LOW(_0x7),HIGH(_0x7),LOW(_0x7+6),HIGH(_0x7+6),LOW(_0x7+12),HIGH(_0x7+12)
_0xA:
	.DB  LOW(_0x9),HIGH(_0x9),LOW(_0x9+6),HIGH(_0x9+6),LOW(_0x9+12),HIGH(_0x9+12)
_0xB:
	.DB  0x2C,0x1,0x2C,0x1,0x2C,0x1
_0x0:
	.DB  0x53,0x68,0x6F,0x77,0x20,0x41,0x44,0x43
	.DB  0x20,0x56,0x61,0x6C,0x75,0x65,0x0,0x43
	.DB  0x61,0x6C,0x69,0x62,0x72,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x0,0x53,0x68,0x6F,0x77,0x20
	.DB  0x41,0x44,0x43,0x20,0x56,0x6F,0x6C,0x74
	.DB  0x61,0x67,0x65,0x0,0x41,0x44,0x43,0x20
	.DB  0x31,0x0,0x41,0x44,0x43,0x20,0x32,0x0
	.DB  0x41,0x44,0x43,0x20,0x33,0x0,0x50,0x6C
	.DB  0x65,0x61,0x73,0x65,0x20,0x53,0x65,0x6C
	.DB  0x65,0x63,0x74,0x0,0x56,0x61,0x6C,0x75
	.DB  0x65,0x3A,0x0,0x43,0x6F,0x6E,0x66,0x69
	.DB  0x72,0x6D,0x20,0x54,0x6F,0x20,0x53,0x61
	.DB  0x76,0x65,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0F
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x0C
	.DW  _0x3+15
	.DW  _0x0*2+15

	.DW  0x11
	.DW  _0x3+27
	.DW  _0x0*2+27

	.DW  0x06
	.DW  _menuItems
	.DW  _0x4*2

	.DW  0x06
	.DW  _0x5
	.DW  _0x0*2+44

	.DW  0x06
	.DW  _0x5+6
	.DW  _0x0*2+50

	.DW  0x06
	.DW  _0x5+12
	.DW  _0x0*2+56

	.DW  0x06
	.DW  _adcMenuItems
	.DW  _0x6*2

	.DW  0x06
	.DW  _0x7
	.DW  _0x0*2+44

	.DW  0x06
	.DW  _0x7+6
	.DW  _0x0*2+50

	.DW  0x06
	.DW  _0x7+12
	.DW  _0x0*2+56

	.DW  0x06
	.DW  _0x9
	.DW  _0x0*2+44

	.DW  0x06
	.DW  _0x9+6
	.DW  _0x0*2+50

	.DW  0x06
	.DW  _0x9+12
	.DW  _0x0*2+56

	.DW  0x06
	.DW  _calibrationMenuItems
	.DW  _0xA*2

	.DW  0x06
	.DW  _floorValues
	.DW  _0xB*2

	.DW  0x0E
	.DW  _0x21
	.DW  _0x0*2+62

	.DW  0x07
	.DW  _0x21+14
	.DW  _0x0*2+76

	.DW  0x0E
	.DW  _0x21+21
	.DW  _0x0*2+62

	.DW  0x10
	.DW  _0x21+35
	.DW  _0x0*2+83

	.DW  0x0E
	.DW  _0x2F
	.DW  _0x0*2+62

	.DW  0x11
	.DW  _0x3D
	.DW  _0x0*2+99

	.DW  0x11
	.DW  _0x3E
	.DW  _0x0*2+99

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
	.ORG 0x160

	.CSEG
;/*
; * IR_Sernsor.c
; *
; * Created: 27/10/2019 08:32:34 È.Ù
; * Author: Alireza
; */
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
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdlib.h>
;#include <string.h>
;#include <stdbool.h>
;#include <mega16.h>
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;char *menuItems[] = {"Show ADC Value", "Calibration", "Show ADC Voltage"};

	.DSEG
_0x3:
	.BYTE 0x2C
;char *adcMenuItems[] = {"ADC 1", "ADC 2", "ADC 3"};
_0x5:
	.BYTE 0x12
;char *voltageMenuItems[] = {"ADC 1", "ADC 2", "ADC 3"};
_0x7:
	.BYTE 0x12
;char *calibrationMenuItems[] = {"ADC 1", "ADC 2", "ADC 3"};
_0x9:
	.BYTE 0x12
;int floorValues[3] = {300, 300, 300};
;int adcLastValue[3] = {0, 0, 0};
;int selectedItem = -1;
;int showingItem = 0;
;int adcSelectedItem = -1;
;int adcShowingItem = 0;
;int calibrationSelectedItem = -1;
;int calibrationShowingItem = 0;
;int nextKeyPressedCount = 0;
;bool nextKeyPressed = false;
;int confirmKeyPressedCount = 0;
;bool confirmKeyPressed = false;
;
;void init();
;void showADCValue(int);
;void showStringOnRow(int, char *string);
;void handleLED(int channel);
;bool isNextKeyDebounced();
;bool isConfirmKeyDebounced();
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002D {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
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
; 0000 002E // Reinitialize Timer 0 value
; 0000 002F TCNT0=0x64;
	LDI  R30,LOW(100)
	OUT  0x32,R30
; 0000 0030 // Place your code here
; 0000 0031 if (nextKeyPressed) nextKeyPressedCount++;
	LDS  R30,_nextKeyPressed
	CPI  R30,0
	BREQ _0xC
	LDI  R26,LOW(_nextKeyPressedCount)
	LDI  R27,HIGH(_nextKeyPressedCount)
	CALL SUBOPT_0x0
; 0000 0032 if (confirmKeyPressed) confirmKeyPressedCount++;
_0xC:
	LDS  R30,_confirmKeyPressed
	CPI  R30,0
	BREQ _0xD
	LDI  R26,LOW(_confirmKeyPressedCount)
	LDI  R27,HIGH(_confirmKeyPressedCount)
	CALL SUBOPT_0x0
; 0000 0033 if (isNextKeyDebounced()){
_0xD:
	RCALL _isNextKeyDebounced
	CPI  R30,0
	BRNE PC+2
	RJMP _0xE
; 0000 0034    switch (selectedItem){
	MOVW R30,R4
; 0000 0035     case -1 :
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x12
; 0000 0036     showingItem++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0037     if (showingItem > 2) showingItem = 0;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x13
	CLR  R6
	CLR  R7
; 0000 0038     showStringOnRow(1, menuItems[showingItem]);
_0x13:
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	RCALL _showStringOnRow
; 0000 0039     break;
	RJMP _0x11
; 0000 003A     case 0:
_0x12:
	SBIW R30,0
	BRNE _0x14
; 0000 003B     adcShowingItem++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 003C     if (adcShowingItem > 2) adcShowingItem = 0;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x15
	CLR  R10
	CLR  R11
; 0000 003D     showStringOnRow(1, adcMenuItems[adcShowingItem]);
_0x15:
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
; 0000 003E 
; 0000 003F     break;
	RJMP _0x11
; 0000 0040     case 1:
_0x14:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16
; 0000 0041     calibrationShowingItem++;
	LDI  R26,LOW(_calibrationShowingItem)
	LDI  R27,HIGH(_calibrationShowingItem)
	CALL SUBOPT_0x0
; 0000 0042     if (calibrationShowingItem > 2) calibrationShowingItem = 0;
	LDS  R26,_calibrationShowingItem
	LDS  R27,_calibrationShowingItem+1
	SBIW R26,3
	BRLT _0x17
	LDI  R30,LOW(0)
	STS  _calibrationShowingItem,R30
	STS  _calibrationShowingItem+1,R30
; 0000 0043     showStringOnRow(1, calibrationMenuItems[calibrationShowingItem]);
_0x17:
	CALL SUBOPT_0x1
	LDS  R30,_calibrationShowingItem
	LDS  R31,_calibrationShowingItem+1
	LDI  R26,LOW(_calibrationMenuItems)
	LDI  R27,HIGH(_calibrationMenuItems)
	CALL SUBOPT_0x4
; 0000 0044 
; 0000 0045     break;
; 0000 0046     case 2:
_0x16:
; 0000 0047     break;
; 0000 0048     default:break;
; 0000 0049     }
_0x11:
; 0000 004A } if (isConfirmKeyDebounced()){
_0xE:
	RCALL _isConfirmKeyDebounced
	CPI  R30,0
	BRNE PC+2
	RJMP _0x1A
; 0000 004B    switch (selectedItem){
	MOVW R30,R4
; 0000 004C     case -1 :
	CPI  R30,LOW(0xFFFFFFFF)
	LDI  R26,HIGH(0xFFFFFFFF)
	CPC  R31,R26
	BRNE _0x1E
; 0000 004D     selectedItem = showingItem;
	MOVW R4,R6
; 0000 004E     showStringOnRow(0, menuItems[selectedItem]);
	CALL SUBOPT_0x5
	MOVW R30,R4
	LDI  R26,LOW(_menuItems)
	LDI  R27,HIGH(_menuItems)
	CALL SUBOPT_0x4
; 0000 004F     showStringOnRow(1, adcMenuItems[adcShowingItem]);
	CALL SUBOPT_0x1
	CALL SUBOPT_0x3
; 0000 0050     break;
	RJMP _0x1D
; 0000 0051     case 0:
_0x1E:
	SBIW R30,0
	BRNE _0x1F
; 0000 0052     if (adcSelectedItem != -1){
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x20
; 0000 0053         adcSelectedItem = -1;
	MOVW R8,R30
; 0000 0054         adcShowingItem = 0;
	CLR  R10
	CLR  R11
; 0000 0055         selectedItem = -1;
	CALL SUBOPT_0x6
; 0000 0056         showingItem = 0;
; 0000 0057         showStringOnRow(0, "Please Select");
	__POINTW2MN _0x21,0
	CALL SUBOPT_0x7
; 0000 0058         showStringOnRow(1, menuItems[showingItem]);
	CALL SUBOPT_0x2
	RJMP _0x5D
; 0000 0059     }
; 0000 005A     else{
_0x20:
; 0000 005B     adcSelectedItem = adcShowingItem;
	MOVW R8,R10
; 0000 005C     showStringOnRow(0,"Value:");
	CALL SUBOPT_0x5
	__POINTW2MN _0x21,14
_0x5D:
	RCALL _showStringOnRow
; 0000 005D     }
; 0000 005E     break;
	RJMP _0x1D
; 0000 005F     case 1:
_0x1F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x23
; 0000 0060     if (calibrationSelectedItem != -1){
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x24
; 0000 0061         floorValues[calibrationSelectedItem] = adcLastValue[calibrationSelectedItem];
	MOVW R30,R12
	CALL SUBOPT_0x8
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R12
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0062         calibrationSelectedItem = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R12,R30
; 0000 0063         calibrationShowingItem = 0;
	LDI  R30,LOW(0)
	STS  _calibrationShowingItem,R30
	STS  _calibrationShowingItem+1,R30
; 0000 0064         selectedItem = -1;
	CALL SUBOPT_0x6
; 0000 0065         showingItem = 0;
; 0000 0066         showStringOnRow(0, "Please Select");
	__POINTW2MN _0x21,21
	CALL SUBOPT_0x7
; 0000 0067         showStringOnRow(1, menuItems[showingItem]);
	CALL SUBOPT_0x2
	RJMP _0x5E
; 0000 0068         }else{
_0x24:
; 0000 0069     calibrationSelectedItem = calibrationShowingItem;
	__GETWRMN 12,13,0,_calibrationShowingItem
; 0000 006A     showStringOnRow(0,"Confirm To Save");
	CALL SUBOPT_0x5
	__POINTW2MN _0x21,35
_0x5E:
	RCALL _showStringOnRow
; 0000 006B               }
; 0000 006C     break;
; 0000 006D     case 2:
_0x23:
; 0000 006E     break;
; 0000 006F     default:break;
; 0000 0070     }
_0x1D:
; 0000 0071 }
; 0000 0072 }
_0x1A:
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
_0x21:
	.BYTE 0x33
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0076 {   if(PIND.2 == 1){

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	SBIS 0x10,2
	RJMP _0x28
; 0000 0077     nextKeyPressed = true;
	LDI  R30,LOW(1)
	STS  _nextKeyPressed,R30
; 0000 0078 
; 0000 0079     }else{
	RJMP _0x29
_0x28:
; 0000 007A     nextKeyPressed = false;
	LDI  R30,LOW(0)
	STS  _nextKeyPressed,R30
; 0000 007B     nextKeyPressedCount = 0;
	STS  _nextKeyPressedCount,R30
	STS  _nextKeyPressedCount+1,R30
; 0000 007C     }
_0x29:
; 0000 007D }
	RJMP _0x5F
; .FEND
;
;
;    char title[16];
;    char adcselectedString[1];
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0084 {   if (PIND.3 == 1){
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R30
	SBIS 0x10,3
	RJMP _0x2A
; 0000 0085    confirmKeyPressed = true;
	LDI  R30,LOW(1)
	STS  _confirmKeyPressed,R30
; 0000 0086 
; 0000 0087     }else{
	RJMP _0x2B
_0x2A:
; 0000 0088     confirmKeyPressed = false;
	LDI  R30,LOW(0)
	STS  _confirmKeyPressed,R30
; 0000 0089     confirmKeyPressedCount = 0;
	STS  _confirmKeyPressedCount,R30
	STS  _confirmKeyPressedCount+1,R30
; 0000 008A     }
_0x2B:
; 0000 008B }
_0x5F:
	LD   R30,Y+
	RETI
; .FEND
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 008E {
_read_adc:
; .FSTART _read_adc
; 0000 008F ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0090 // Delay needed for the stabilization of the ADC input voltage
; 0000 0091 delay_us(10);
	__DELAY_USB 27
; 0000 0092 // Start the AD conversion
; 0000 0093 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0094 // Wait for the AD conversion to complete
; 0000 0095 while ((ADCSRA & (1<<ADIF))==0);
_0x2C:
	SBIS 0x6,4
	RJMP _0x2C
; 0000 0096 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0097 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20C0001
; 0000 0098 }
; .FEND
;
;void main(void)
; 0000 009B {
_main:
; .FSTART _main
; 0000 009C   init();
	RCALL _init
; 0000 009D   showStringOnRow(0, "Please Select");
	CALL SUBOPT_0x5
	__POINTW2MN _0x2F,0
	CALL SUBOPT_0x7
; 0000 009E   showStringOnRow(1, menuItems[showingItem]);
	CALL SUBOPT_0x2
	RCALL _showStringOnRow
; 0000 009F // Global enable interrupts
; 0000 00A0 #asm("sei")
	sei
; 0000 00A1 while (1)
_0x30:
; 0000 00A2     {
; 0000 00A3     switch(selectedItem){
	MOVW R30,R4
; 0000 00A4     case 0 :
	SBIW R30,0
	BRNE _0x36
; 0000 00A5     if (adcSelectedItem != -1){
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R8
	CPC  R31,R9
	BREQ _0x37
; 0000 00A6         showADCValue(adcSelectedItem);
	MOVW R26,R8
	RCALL _showADCValue
; 0000 00A7         }
; 0000 00A8     break;
_0x37:
	RJMP _0x35
; 0000 00A9     case 1 :
_0x36:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x38
; 0000 00AA     if (calibrationSelectedItem != -1){
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R12
	CPC  R31,R13
	BREQ _0x39
; 0000 00AB         showADCValue(calibrationSelectedItem);
	MOVW R26,R12
	RCALL _showADCValue
; 0000 00AC         }
; 0000 00AD     break;
_0x39:
; 0000 00AE     case 2 :
_0x38:
; 0000 00AF     break;
; 0000 00B0     default:break;
; 0000 00B1     }
_0x35:
; 0000 00B2     }
	RJMP _0x30
; 0000 00B3     }
_0x3C:
	RJMP _0x3C
; .FEND

	.DSEG
_0x2F:
	.BYTE 0xE
;    void showADCValue(int channel){
; 0000 00B4 void showADCValue(int channel){

	.CSEG
_showADCValue:
; .FSTART _showADCValue
; 0000 00B5     char string[5];
; 0000 00B6     lcd_gotoxy(0, 1);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,5
;	channel -> Y+5
;	string -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 00B7     lcd_puts("                ");
	__POINTW2MN _0x3D,0
	RCALL _lcd_puts
; 0000 00B8     adcLastValue[channel] = read_adc(channel);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDD  R26,Y+5
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 00B9     itoa(adcLastValue[channel], string);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
; 0000 00BA     showStringOnRow(1, string);
	CALL SUBOPT_0x1
	MOVW R26,R28
	ADIW R26,2
	RCALL _showStringOnRow
; 0000 00BB     handleLED(channel);
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RCALL _handleLED
; 0000 00BC     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00BD     }
	ADIW R28,7
	RET
; .FEND

	.DSEG
_0x3D:
	.BYTE 0x11
;
;    void showStringOnRow(int row, char *string){
; 0000 00BF void showStringOnRow(int row, char *string){

	.CSEG
_showStringOnRow:
; .FSTART _showStringOnRow
; 0000 00C0         lcd_gotoxy(0, row);
	ST   -Y,R27
	ST   -Y,R26
;	row -> Y+2
;	*string -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _lcd_gotoxy
; 0000 00C1         lcd_puts("                ");
	__POINTW2MN _0x3E,0
	RCALL _lcd_puts
; 0000 00C2         lcd_gotoxy(0, row);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _lcd_gotoxy
; 0000 00C3         lcd_puts(string);
	LD   R26,Y
	LDD  R27,Y+1
	RCALL _lcd_puts
; 0000 00C4     }
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x3E:
	.BYTE 0x11
;    void handleLED(int channel){
; 0000 00C5 void handleLED(int channel){

	.CSEG
_handleLED:
; .FSTART _handleLED
; 0000 00C6        switch(channel){
	ST   -Y,R27
	ST   -Y,R26
;	channel -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 00C7         case 0:
	SBIW R30,0
	BRNE _0x42
; 0000 00C8         if (adcLastValue[channel] > floorValues[channel])
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CP   R30,R0
	CPC  R31,R1
	BRGE _0x43
; 0000 00C9             PORTC.0 = 1; else PORTC.0 = 0;
	SBI  0x15,0
	RJMP _0x46
_0x43:
	CBI  0x15,0
; 0000 00CA         break;
_0x46:
	RJMP _0x41
; 0000 00CB         case 1:
_0x42:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x49
; 0000 00CC         if (adcLastValue[channel] > floorValues[channel])
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CP   R30,R0
	CPC  R31,R1
	BRGE _0x4A
; 0000 00CD             PORTC.1 = 1; else PORTC.1 = 0;
	SBI  0x15,1
	RJMP _0x4D
_0x4A:
	CBI  0x15,1
; 0000 00CE         break;
_0x4D:
	RJMP _0x41
; 0000 00CF         case 2:
_0x49:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x41
; 0000 00D0         if (adcLastValue[channel] > floorValues[channel])
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	CALL SUBOPT_0xA
	CP   R30,R0
	CPC  R31,R1
	BRGE _0x51
; 0000 00D1             PORTC.2 = 1; else PORTC.2 = 0;
	SBI  0x15,2
	RJMP _0x54
_0x51:
	CBI  0x15,2
; 0000 00D2         break;
_0x54:
; 0000 00D3        }
_0x41:
; 0000 00D4     }
	RJMP _0x20C0002
; .FEND
;
;    bool isNextKeyDebounced(){
; 0000 00D6 _Bool isNextKeyDebounced(){
_isNextKeyDebounced:
; .FSTART _isNextKeyDebounced
; 0000 00D7         return nextKeyPressed && nextKeyPressedCount == 20;
	LDS  R30,_nextKeyPressed
	CPI  R30,0
	BREQ _0x57
	LDS  R26,_nextKeyPressedCount
	LDS  R27,_nextKeyPressedCount+1
	SBIW R26,20
	BRNE _0x57
	LDI  R30,1
	RJMP _0x58
_0x57:
	LDI  R30,0
_0x58:
	RET
; 0000 00D8     }
; .FEND
;
;    bool isConfirmKeyDebounced(){
; 0000 00DA _Bool isConfirmKeyDebounced(){
_isConfirmKeyDebounced:
; .FSTART _isConfirmKeyDebounced
; 0000 00DB         return confirmKeyPressed && confirmKeyPressedCount == 20;
	LDS  R30,_confirmKeyPressed
	CPI  R30,0
	BREQ _0x59
	LDS  R26,_confirmKeyPressedCount
	LDS  R27,_confirmKeyPressedCount+1
	SBIW R26,20
	BRNE _0x59
	LDI  R30,1
	RJMP _0x5A
_0x59:
	LDI  R30,0
_0x5A:
	RET
; 0000 00DC     }
; .FEND
;
;    void init(){
; 0000 00DE void init(){
_init:
; .FSTART _init
; 0000 00DF     DDRC = 0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00E0 
; 0000 00E1 DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 00E2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00E3 PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00E4     PORTD.0 = 1;
	SBI  0x12,0
; 0000 00E5 // ADC initialization
; 0000 00E6 // ADC Clock frequency: 125/000 kHz
; 0000 00E7 // ADC Voltage Reference: AREF pin
; 0000 00E8 // ADC Auto Trigger Source: ADC Stopped
; 0000 00E9 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 00EA ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 00EB SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00EC //ADCSRA = 0x86;
; 0000 00ED //ADMUX = ADC_VREF_TYPE & 0xff;
; 0000 00EE 
; 0000 00EF // External Interrupt(s) initialization
; 0000 00F0 // INT0: On
; 0000 00F1 // INT0 Mode: Any change
; 0000 00F2 // INT1: On
; 0000 00F3 // INT1 Mode: Any change
; 0000 00F4 // INT2: Off
; 0000 00F5 GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00F6 MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0000 00F7 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00F8 GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00F9     // Timer/Counter 0 initialization
; 0000 00FA // Clock source: System Clock
; 0000 00FB // Clock value: 31/250 kHz
; 0000 00FC // Mode: Normal top=0xFF
; 0000 00FD // OC0 output: Disconnected
; 0000 00FE // Timer Period: 4/992 ms
; 0000 00FF TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0100 TCNT0=0x64;
	LDI  R30,LOW(100)
	OUT  0x32,R30
; 0000 0101 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0102 
; 0000 0103 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0104 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0105 
; 0000 0106 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0107     }
	RET
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,2
	__DELAY_USB 13
	CBI  0x18,2
	__DELAY_USB 13
	RJMP _0x20C0001
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
	RJMP _0x20C0001
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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xD
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0001
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
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
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
_0x20C0001:
	ADIW R28,1
	RET
; .FEND
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
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_menuItems:
	.BYTE 0x6
_adcMenuItems:
	.BYTE 0x6
_calibrationMenuItems:
	.BYTE 0x6
_floorValues:
	.BYTE 0x6
_adcLastValue:
	.BYTE 0x6
_calibrationShowingItem:
	.BYTE 0x2
_nextKeyPressedCount:
	.BYTE 0x2
_nextKeyPressed:
	.BYTE 0x1
_confirmKeyPressedCount:
	.BYTE 0x2
_confirmKeyPressed:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2:
	MOVW R30,R6
	LDI  R26,LOW(_menuItems)
	LDI  R27,HIGH(_menuItems)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	MOVW R30,R10
	LDI  R26,LOW(_adcMenuItems)
	LDI  R27,HIGH(_adcMenuItems)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	JMP  _showStringOnRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R30
	JMP  _showStringOnRow

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
	CLR  R6
	CLR  R7
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _showStringOnRow
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_floorValues)
	LDI  R27,HIGH(_floorValues)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_adcLastValue)
	LDI  R27,HIGH(_adcLastValue)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LD   R30,Y
	LDD  R31,Y+1
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	ADD  R26,R30
	ADC  R27,R31
	LD   R0,X+
	LD   R1,X
	LD   R30,Y
	LDD  R31,Y+1
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:

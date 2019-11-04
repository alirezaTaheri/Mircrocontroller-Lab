
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
	.DEF _increasePressedCount=R4
	.DEF _increasePressedCount_msb=R5
	.DEF _decreasePressedCount=R6
	.DEF _decreasePressedCount_msb=R7
	.DEF _bothPressedCount=R8
	.DEF _bothPressedCount_msb=R9
	.DEF _increasePressed=R11
	.DEF _decreasePressed=R10
	.DEF _reversed=R13
	.DEF _configureMode=R12

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

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x3C
_0x0:
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x53,0x74,0x65,0x70,0x20,0x53,0x69
	.DB  0x7A,0x65,0x3A,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _stepSize
	.DW  _0x3*2

	.DW  0x11
	.DW  _0x34
	.DW  _0x0*2

	.DW  0x0B
	.DW  _0x35
	.DW  _0x0*2+17

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

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
; * PWM_DC_Motor.c
; *
; * Created: 31/10/2019 02:35:49 È.Ù
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
;#include <delay.h>
;#include <stdbool.h>
;#include <alcd.h>
;#include <string.h>
;#include <stdio.h>
;#include <stdlib.h>
;
;#define DEBOUNCE_TIME 2
;int increasePressedCount;
;int decreasePressedCount;
;int bothPressedCount = 0;
;bool increasePressed;
;bool decreasePressed;
;
;void enterConfigureMode();
;void exitConfigureMode();
;void clearNCharOnXY(int n, int x, int y);
;void showStringOnXY(int x, int y, char *string);
;char* toString(unsigned long x);
;bool reversed = false;
;bool configureMode = false;
;int stepSize = 60;

	.DSEG
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0020 {

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
; 0000 0021    if (increasePressed)
	TST  R11
	BREQ _0x4
; 0000 0022        increasePressedCount++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0023 
; 0000 0024    if (decreasePressed)
_0x4:
	TST  R10
	BREQ _0x5
; 0000 0025        decreasePressedCount++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0026 
; 0000 0027    if (increasePressed && decreasePressed)
_0x5:
	TST  R11
	BREQ _0x7
	TST  R10
	BRNE _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 0028        bothPressedCount++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0029    else bothPressedCount = 0;
	RJMP _0x9
_0x6:
	CLR  R8
	CLR  R9
; 0000 002A 
; 0000 002B    if (increasePressed && decreasePressed && bothPressedCount == DEBOUNCE_TIME && configureMode){
_0x9:
	TST  R11
	BREQ _0xB
	TST  R10
	BREQ _0xB
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xB
	TST  R12
	BRNE _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 002C        configureMode = false;
	CLR  R12
; 0000 002D        exitConfigureMode();
	RCALL _exitConfigureMode
; 0000 002E        bothPressedCount++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 002F 
; 0000 0030        }
; 0000 0031 
; 0000 0032    if (increasePressed && decreasePressed && bothPressedCount == DEBOUNCE_TIME && !configureMode){
_0xA:
	TST  R11
	BREQ _0xE
	TST  R10
	BREQ _0xE
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0xE
	TST  R12
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 0033        configureMode = true;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0034        enterConfigureMode();
	RCALL _enterConfigureMode
; 0000 0035        }
; 0000 0036 
; 0000 0037    if (!configureMode && increasePressed && increasePressedCount >= DEBOUNCE_TIME){
_0xD:
	TST  R12
	BRNE _0x11
	TST  R11
	BREQ _0x11
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 0038    if (!reversed){
	TST  R13
	BRNE _0x13
; 0000 0039       if (OCR1A + stepSize <= 511){
	CALL SUBOPT_0x0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	BRSH _0x14
; 0000 003A          OCR1A += stepSize;
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x36
; 0000 003B       }else {
_0x14:
; 0000 003C          OCR1A  = 511;
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
_0x36:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 003D       }
; 0000 003E    }else{
	RJMP _0x16
_0x13:
; 0000 003F      if (OCR1B - stepSize <= OCR1B)
	CALL SUBOPT_0x1
	MOVW R26,R30
	IN   R30,0x28
	IN   R31,0x28+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x17
; 0000 0040          OCR1B -= stepSize;
	CALL SUBOPT_0x1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0041       else {
	RJMP _0x18
_0x17:
; 0000 0042          OCR1B  = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0043          reversed = false;
	CLR  R13
; 0000 0044       }
_0x18:
; 0000 0045    }
_0x16:
; 0000 0046    clearNCharOnXY(0,0,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0047    showStringOnXY(0,0,toString(OCR1A));
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4
; 0000 0048    delay_ms(10);
; 0000 0049    clearNCharOnXY(0,0,1);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 004A    showStringOnXY(0,1,toString(OCR1B));
	CALL SUBOPT_0x6
; 0000 004B    }
; 0000 004C     if (!configureMode && decreasePressed && decreasePressedCount >= DEBOUNCE_TIME){
_0x10:
	TST  R12
	BRNE _0x1A
	TST  R10
	BREQ _0x1A
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 004D         if (!reversed){
	TST  R13
	BRNE _0x1C
; 0000 004E       if (OCR1A - stepSize <= OCR1A)
	CALL SUBOPT_0x0
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	IN   R30,0x2A
	IN   R31,0x2A+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x1D
; 0000 004F          OCR1A -= stepSize;
	CALL SUBOPT_0x0
	SUB  R30,R26
	SBC  R31,R27
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0050       else {
	RJMP _0x1E
_0x1D:
; 0000 0051          OCR1A  = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0052          reversed = true;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0053       }
_0x1E:
; 0000 0054    }else{
	RJMP _0x1F
_0x1C:
; 0000 0055      if (OCR1B + stepSize <= 511)
	CALL SUBOPT_0x7
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x200)
	LDI  R30,HIGH(0x200)
	CPC  R27,R30
	BRSH _0x20
; 0000 0056          OCR1B += stepSize;
	CALL SUBOPT_0x7
	ADD  R30,R26
	ADC  R31,R27
	RJMP _0x37
; 0000 0057       else {
_0x20:
; 0000 0058          OCR1B  = 511;
	LDI  R30,LOW(511)
	LDI  R31,HIGH(511)
_0x37:
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 0059       }
; 0000 005A    }
_0x1F:
; 0000 005B    clearNCharOnXY(0,0,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 005C    showStringOnXY(0,0,toString(OCR1A));
	CALL SUBOPT_0x2
	CALL SUBOPT_0x4
; 0000 005D    delay_ms(10);
; 0000 005E    clearNCharOnXY(0,0,1);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 005F    showStringOnXY(0,1,toString(OCR1B));
	CALL SUBOPT_0x6
; 0000 0060     }
; 0000 0061 
; 0000 0062     if (configureMode && increasePressed && increasePressedCount >= DEBOUNCE_TIME){
_0x19:
	TST  R12
	BREQ _0x23
	TST  R11
	BREQ _0x23
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x24
_0x23:
	RJMP _0x22
_0x24:
; 0000 0063         stepSize++;
	LDI  R26,LOW(_stepSize)
	LDI  R27,HIGH(_stepSize)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0064         clearNCharOnXY(0,0,1);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 0065         showStringOnXY(0,1,toString(stepSize));
	CALL SUBOPT_0x8
; 0000 0066     }
; 0000 0067 
; 0000 0068     if (configureMode && decreasePressed && decreasePressedCount >= DEBOUNCE_TIME){
_0x22:
	TST  R12
	BREQ _0x26
	TST  R10
	BREQ _0x26
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 0069         stepSize--;
	LDI  R26,LOW(_stepSize)
	LDI  R27,HIGH(_stepSize)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 006A         clearNCharOnXY(0,0,1);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x5
; 0000 006B         showStringOnXY(0,1,toString(stepSize));
	CALL SUBOPT_0x8
; 0000 006C     }
; 0000 006D     /*
; 0000 006E    if (increasePressed && increasePressedCount >= DEBOUNCE_TIME){
; 0000 006F     if (increasePressedCount % DEBOUNCE_TIME == DEBOUNCE_TIME -1){
; 0000 0070        if (OCR1AL + 10 <= 254){
; 0000 0071        OCR1AL+=10;
; 0000 0072        clearNCharOnXY(6,0, 1);
; 0000 0073        showStringOnXY(0, 1, toString(OCR1AL));
; 0000 0074        }
; 0000 0075        else {OCR1AL = 254;
; 0000 0076        clearNCharOnXY(6,0, 1);
; 0000 0077        showStringOnXY(0, 1, toString(OCR1AL));
; 0000 0078        OCR1AL = 0;
; 0000 0079        }
; 0000 007A 
; 0000 007B        }
; 0000 007C        else if (increasePressedCount == DEBOUNCE_TIME){
; 0000 007D        if (OCR1AL + 10 <= 254){
; 0000 007E        OCR1AL+=10;
; 0000 007F        clearNCharOnXY(6,0, 1);
; 0000 0080        showStringOnXY(0, 1, toString(OCR1AL));
; 0000 0081        }
; 0000 0082        else {OCR1AL = 254;
; 0000 0083        clearNCharOnXY(6,0, 1);
; 0000 0084        showStringOnXY(0, 1, toString(OCR1AL));
; 0000 0085        OCR1AL = 0;
; 0000 0086        }
; 0000 0087        clearNCharOnXY(16,0,0);
; 0000 0088        showStringOnXY(0, 0, "Increasing...");
; 0000 0089        clearNCharOnXY(16,0, 1);
; 0000 008A        showStringOnXY(0, 1, toString(OCR1AL));
; 0000 008B        }
; 0000 008C        }
; 0000 008D    if (decreasePressed && decreasePressedCount > DEBOUNCE_TIME){
; 0000 008E        OCR2--;
; 0000 008F        clearNCharOnXY(16,0,0);
; 0000 0090        showStringOnXY(0, 0, "Decreasing...");
; 0000 0091        clearNCharOnXY(16,0, 1);
; 0000 0092        showStringOnXY(0, 1, toString(OCR2));
; 0000 0093        }
; 0000 0094        */
; 0000 0095 }
_0x25:
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
;	//unsigned char duty;
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0098 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0099     if (PIND.2 == 0){
	SBIC 0x10,2
	RJMP _0x28
; 0000 009A         increasePressed = true;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 009B     }else{
	RJMP _0x29
_0x28:
; 0000 009C         increasePressedCount = 0;
	CLR  R4
	CLR  R5
; 0000 009D         increasePressed = false;
	CLR  R11
; 0000 009E     }
_0x29:
; 0000 009F }
	RJMP _0x38
; .FEND
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 00A3 {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A4      if (PIND.3 == 0){
	SBIC 0x10,3
	RJMP _0x2A
; 0000 00A5         decreasePressed = true;
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 00A6      }else{
	RJMP _0x2B
_0x2A:
; 0000 00A7         decreasePressed = false;
	CLR  R10
; 0000 00A8         decreasePressedCount = 0;
	CLR  R6
	CLR  R7
; 0000 00A9      }
_0x2B:
; 0000 00AA }
_0x38:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00AD {
_main:
; .FSTART _main
; 0000 00AE lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00AF // Timer/Counter 0 initialization
; 0000 00B0 // Clock source: System Clock
; 0000 00B1 // Clock value: 7/813 kHz
; 0000 00B2 // Mode: Normal top=0xFF
; 0000 00B3 // OC0 output: Disconnected
; 0000 00B4 // Timer Period: 14/976 ms
; 0000 00B5 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00B6 TCNT0=0x8B;
	LDI  R30,LOW(139)
	OUT  0x32,R30
; 0000 00B7 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 00B8 
; 0000 00B9 // Timer/Counter 1 initialization
; 0000 00BA // Clock source: System Clock
; 0000 00BB // Clock value: 125/000 kHz
; 0000 00BC // Mode: Ph. correct PWM top=0x01FF
; 0000 00BD // OC1A output: Non-Inverted PWM
; 0000 00BE // OC1B output: Non-Inverted PWM
; 0000 00BF // Noise Canceler: Off
; 0000 00C0 // Input Capture on Falling Edge
; 0000 00C1 // Timer Period: 8/176 ms
; 0000 00C2 // Output Pulse(s):
; 0000 00C3 // OC1A Period: 8/176 ms Width: 0 us
; 0000 00C4 // OC1B Period: 8/176 ms Width: 0 us
; 0000 00C5 // Timer1 Overflow Interrupt: Off
; 0000 00C6 // Input Capture Interrupt: Off
; 0000 00C7 // Compare A Match Interrupt: Off
; 0000 00C8 // Compare B Match Interrupt: Off
; 0000 00C9 TCCR1A=(1<<COM1A1) | (0<<COM1A0) | (1<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(162)
	OUT  0x2F,R30
; 0000 00CA TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 00CB TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00CC TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00CD ICR1H=0x00;
	OUT  0x27,R30
; 0000 00CE ICR1L=0x00;
	OUT  0x26,R30
; 0000 00CF /*
; 0000 00D0 OCR1AH=0x00;
; 0000 00D1 OCR1AL=0x00;
; 0000 00D2 OCR1BH=0x00;
; 0000 00D3 OCR1BL=0x00;
; 0000 00D4 */
; 0000 00D5 //OCR1A = 65000;
; 0000 00D6 OCR1A = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00D7 OCR1B = 0;
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 00D8 // Port D initialization
; 0000 00D9 // Function: Bit7=Out Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00DA DDRD=(1<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(176)
	OUT  0x11,R30
; 0000 00DB PORTD.2 = 1;
	SBI  0x12,2
; 0000 00DC PORTD.3 = 1;
	SBI  0x12,3
; 0000 00DD 
; 0000 00DE // External Interrupt(s) initialization
; 0000 00DF // INT0: On
; 0000 00E0 // INT0 Mode: Any change
; 0000 00E1 // INT1: On
; 0000 00E2 // INT1 Mode: Any change
; 0000 00E3 // INT2: Off
; 0000 00E4 GICR|=(1<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
; 0000 00E5 MCUCR=(0<<ISC11) | (1<<ISC10) | (0<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(5)
	OUT  0x35,R30
; 0000 00E6 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00E7 GIFR=(1<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 00E8 
; 0000 00E9 
; 0000 00EA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00EB TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00EC 
; 0000 00ED // Global enable interrupts
; 0000 00EE #asm("sei")
	sei
; 0000 00EF 
; 0000 00F0    clearNCharOnXY(0,1,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x9
; 0000 00F1    showStringOnXY(0,1,toString(OCR1B));
	CALL SUBOPT_0x6
; 0000 00F2    clearNCharOnXY(0,0,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 00F3    showStringOnXY(0,0,toString(OCR1A));
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
	RCALL _showStringOnXY
; 0000 00F4 while (1)
_0x30:
; 0000 00F5     {
; 0000 00F6 
; 0000 00F7     }
	RJMP _0x30
; 0000 00F8 }
_0x33:
	RJMP _0x33
; .FEND
;void clearNCharOnXY(int n, int x, int y){
; 0000 00F9 void clearNCharOnXY(int n, int x, int y){
_clearNCharOnXY:
; .FSTART _clearNCharOnXY
; 0000 00FA         /*char *blank = "";
; 0000 00FB         int a;
; 0000 00FC         lcd_gotoxy(x, y);
; 0000 00FD         for (a = 0; a< n;a++)
; 0000 00FE             strcat(blank, " ");
; 0000 00FF             */
; 0000 0100             lcd_gotoxy(0, y);
	ST   -Y,R27
	ST   -Y,R26
;	n -> Y+4
;	x -> Y+2
;	y -> Y+0
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+1
	RCALL _lcd_gotoxy
; 0000 0101         lcd_puts("                ");
	__POINTW2MN _0x34,0
	RJMP _0x20C0003
; 0000 0102 }
; .FEND

	.DSEG
_0x34:
	.BYTE 0x11
;
;void showStringOnXY(int x, int y, char *string){
; 0000 0104 void showStringOnXY(int x, int y, char *string){

	.CSEG
_showStringOnXY:
; .FSTART _showStringOnXY
; 0000 0105         lcd_gotoxy(x, y);
	ST   -Y,R27
	ST   -Y,R26
;	x -> Y+4
;	y -> Y+2
;	*string -> Y+0
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _lcd_gotoxy
; 0000 0106         lcd_puts(string);
	LD   R26,Y
	LDD  R27,Y+1
_0x20C0003:
	RCALL _lcd_puts
; 0000 0107     }
	ADIW R28,6
	RET
; .FEND
;
;char* toString(unsigned long x){
; 0000 0109 char* toString(unsigned long x){
_toString:
; .FSTART _toString
; 0000 010A     char string[55];
; 0000 010B     ltoa(x,string);
	CALL __PUTPARD2
	SBIW R28,55
;	x -> Y+55
;	string -> Y+0
	__GETD1S 55
	CALL __PUTPARD1
	MOVW R26,R28
	ADIW R26,4
	CALL _ltoa
; 0000 010C     return string;
	MOVW R30,R28
	ADIW R28,59
	RET
; 0000 010D }
; .FEND
;
;void enterConfigureMode(){
; 0000 010F void enterConfigureMode(){
_enterConfigureMode:
; .FSTART _enterConfigureMode
; 0000 0110    clearNCharOnXY(0,1,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x9
; 0000 0111    showStringOnXY(0,1,toString(stepSize));
	CALL SUBOPT_0x8
; 0000 0112    clearNCharOnXY(0,0,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0113    showStringOnXY(0,0,"Step Size:");
	CALL SUBOPT_0x2
	__POINTW2MN _0x35,0
	RJMP _0x20C0002
; 0000 0114 }
; .FEND

	.DSEG
_0x35:
	.BYTE 0xB
;
;void exitConfigureMode(){
; 0000 0116 void exitConfigureMode(){

	.CSEG
_exitConfigureMode:
; .FSTART _exitConfigureMode
; 0000 0117    clearNCharOnXY(0,1,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x9
; 0000 0118    showStringOnXY(0,1,toString(OCR1B));
	CALL SUBOPT_0x6
; 0000 0119    clearNCharOnXY(0,0,0);
	CALL SUBOPT_0x2
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 011A    showStringOnXY(0,0,toString(OCR1A));
	CALL SUBOPT_0x2
	CALL SUBOPT_0xA
_0x20C0002:
	RCALL _showStringOnXY
; 0000 011B }
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
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0xB
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xB
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
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
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

	.CSEG
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
_ltoa:
; .FSTART _ltoa
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x3B9ACA00
	__PUTD1S 2
	LDI  R16,LOW(0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060003
	__GETD1S 8
	CALL __ANEGD1
	__PUTD1S 8
	CALL SUBOPT_0xD
	LDI  R30,LOW(45)
	ST   X,R30
_0x2060003:
_0x2060005:
	CALL SUBOPT_0xE
	CALL __DIVD21U
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2060008
	CPI  R16,0
	BRNE _0x2060008
	__GETD2S 2
	__CPD2N 0x1
	BRNE _0x2060007
_0x2060008:
	CALL SUBOPT_0xD
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	LDI  R16,LOW(1)
_0x2060007:
	CALL SUBOPT_0xE
	CALL __MODD21U
	__PUTD1S 8
	__GETD2S 2
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 2
	CALL __CPD10
	BRNE _0x2060005
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET
; .FEND

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_stepSize:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDS  R26,_stepSize
	LDS  R27,_stepSize+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	IN   R30,0x28
	IN   R31,0x28+1
	LDS  R26,_stepSize
	LDS  R27,_stepSize+1
	SUB  R30,R26
	SBC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(0)
	LDI  R27,0
	CALL _clearNCharOnXY
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	IN   R30,0x2A
	IN   R31,0x2A+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	CALL _toString
	MOVW R26,R30
	CALL _showStringOnXY
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _clearNCharOnXY
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,0x28
	IN   R31,0x28+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	CALL _toString
	MOVW R26,R30
	JMP  _showStringOnXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	IN   R30,0x28
	IN   R31,0x28+1
	LDS  R26,_stepSize
	LDS  R27,_stepSize+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_stepSize
	LDS  R27,_stepSize+1
	CALL __CWD2
	CALL _toString
	MOVW R26,R30
	JMP  _showStringOnXY

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	IN   R30,0x2A
	IN   R31,0x2A+1
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	CALL _toString
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	__GETD1S 2
	__GETD2S 8
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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

;END OF CODE MARKER
__END_OF_CODE:

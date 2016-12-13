; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso básico de microcontroladores en ensamblador	    
;
;   Práctica 2: Iniciar y escribir un caracter en la LCD
;   Objetivo: Entender la secuencia de inicialización de la LCD
;   y mostrar un caracter en la pantalla
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hernández Rodríguez
; ************************************************************
    
LIST    P = 18F4550	;PIC a utilizar
INCLUDE <P18F4550.INC>

;************************************************************
;Configuración de fusibles
CONFIG  FOSC = HS   
CONFIG  PWRT = ON
CONFIG  BOR = OFF
CONFIG  WDT = OFF
CONFIG  MCLRE = ON
CONFIG  PBADEN = OFF
CONFIG  LVP = OFF
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***********************************************************
;Código
#define	    LCD_EN  PORTD,4	;Ubicación de pin EN en Miuva
#define	    LCD_RS  PORTD,5	;Ubicación de pin RS en Miuva

CBLOCK  0x000
    Ret1	;Variables para los retardos
    Ret2
ENDC
    
;Código
ORG 0x0000	    ;Vector de reset
    GOTO START
    
START
    movlw   0x00    ;Puerto D como salida
    movwf   TRISD
    
;*****************************************************************************;
;Ejemplo de envío de instrucción					      ;
;									      ;
;   RS	    _________________________	1: DATOS | 0: INSTRUCCIONES	      ;
;									      ;   
;   RW	    _________________________	1: LECTURA  |	0: ESCRITURA          ;
;		  ___      ___                                                ;
;   EN	    _____/   \____/   \______	LEE EN FLANCOS DE BAJADA              ;
;									      ;
;	    _________________________					      ;
;   D7:D4   ___/_4 MSB_\/_4_LSB_\____	PARA ENVIAR LOS 8 BITS DE INSTRUCCION ;
;					PRIMERO SE ENVIAN LOS 4 MÁS           ;
;					SIGNIFICATIVOS Y POSTERIORMENTE LOS   ;
;					4 MENOS SIGNIFICATIVOS                ;
;									      ;
;*****************************************************************************;
;Se carga D7:D4 de la LCD en los bits D3:D0 de Miuva    
;INICIALIZACIÓN
    bcf	    LCD_EN
    call    retardo15ms
    bcf	    LCD_RS
    ;Inicia secuencia de inicialización
    ;Función set
    movlw   b'00000011'	
    movwf   PORTD	
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN
    call    retardo4_1ms
    
    ;Función set
    movlw   b'00000011'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	LCD_EN
    call    retardo100us
    
    ;Función set
    movlw   b'00000011'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	LCD_EN
    call    retardo4_1ms
    
    ;Función set
    movlw   b'00000010'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	LCD_EN
    call    retardo4_1ms
    
    ;Función set en configuración de 4 bits
    movlw   b'00000010'	
    movwf   PORTD	
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN
    call    retardo4_1ms
    movlw   b'00001110'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN
    call    retardo4_1ms
    
    ;Función DISPLAY OFF
    movlw   b'00000000'	;MSB Funcion display
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    movlw   b'00001000'	;LSB Funcion display
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    
    ;Funcion DISPLAY CLEAR
    movlw   b'00000000'	;MSB Funcion clear
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    movlw   b'00000001'	;LSB Funcion clear
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    
    ;Funcion ENTRY MODE SET
    movlw   b'00000000'	;MSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    movlw   b'00000110'	;LSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    
    ;Función DDRAM ACCESS
    movlw   b'00001000'	;MSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    movlw   b'00000000'	;LSB Funcion mode set
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    
    ;Función DISPLAY ON
    movlw   b'00000000'	;MSB Display ON
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    movlw   b'00001100'	;LSB Display ON
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN	
    call    retardo4_1ms
    

    ;MANDAR LETRA I
    bsf	    LCD_RS
    movlw   b'00100100'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN
    call    retardo4_1ms
    movlw   b'00101001'
    movwf   PORTD
    bsf	    LCD_EN
    call    retardo100us
    bcf	    LCD_EN
    call    retardo4_1ms
    
    
    BUCLE
    goto    BUCLE
    
    ;FUNCIONES PARA LOS RETARDOS A DIFERENTES TIEMPOS
    retardo15ms
    movlw   D'255'
    movwf   Ret1
    movlw   D'40'
    movwf   Ret2
    retardo15msINICIO
    decfsz  Ret1, F
    goto    retardo15msINICIO
    decfsz  Ret2,   F
    goto    retardo15msINICIO
    return
    
    retardo40ms
    movlw   D'255'
    movwf   Ret1
    movlw   D'105'
    movwf   Ret2
    retardo40msINICIO
    decfsz  Ret1, F
    goto    retardo40msINICIO
    decfsz  Ret2, F
    goto    retardo40msINICIO
    return
    
    retardo5ms
    movlw   D'255'
    movwf   Ret1
    movlw   D'14'
    movwf   Ret2
    retardo5msINICIO
    decfsz  Ret1, F
    goto    retardo5msINICIO
    decfsz  Ret2, F
    goto    retardo5msINICIO
    return
    
    retardo4_1ms
    movlw   D'255'
    movwf   Ret1
    movlw   D'11'
    movwf   Ret2
    retardo4_1msINICIO
    decfsz  Ret1, F
    goto    retardo4_1msINICIO
    decfsz  Ret2, F
    goto    retardo4_1msINICIO
    return
    
    retardo100us
    movlw   D'67'
    movwf   Ret1
    retardo100usINICIO
    decfsz  Ret1, F
    goto    retardo100usINICIO
    return
    
    retardo40us
    movlw   D'27'
    movwf   Ret1
    retardo40usINICIO
    decfsz  Ret1, F
    goto    retardo40usINICIO
    return

    END
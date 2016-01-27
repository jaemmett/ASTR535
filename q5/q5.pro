FUNCTION lambda2nu,lambda
;Converts wavelength [A] to frequency [Hz]
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
	 	nu=c/lambda
		return,nu
END

FUNCTION nu2lambda,nu
;Converts frequency [Hz] to wavelength [A]
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
	 	lambda=c/nu
		return,lambda
END

FUNCTION lambda2energy,lambda
;Converts wavelength [A] to energy [erg]
	;CONSTANTS
		c=2.99792458e18  ;A/s
		h=6.6260755e-27  ;erg*s
	;CONVERSION
	 	energy=h*c/lambda
		return,energy
END

FUNCTION nu2energy,nu
;Converts frequency [Hz] to energy [erg]
	;CONSTANTS
		h=6.6260755e-27  ;erg*s
	;CONVERSION
	 	energy=h*nu
		return,energy
END

FUNCTION flambda2fnu,flambda,nu
;Converts wavelength flux [erg/cm2/s/A] to frequency flux [erg/cm2/s/Hz]
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
		fnu=flambda*c/((nu)^2)
		return,fnu
END

FUNCTION fnu2flambda,fnu,lambda
;Converts wavelength flux [erg/cm2/s/A] to frequency flux [erg/cm2/s/Hz]
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
		flambda=fnu*c/((lambda)^2)
		return,flambda
END

FUNCTION stmag2abnu,stmag,lambda
;Converts a monochromatic magnitude in the STMAG system to its equivalent in the ABNU system,
;given an STMAG magnitude (stmag) and wavelength (lambda) in angstroms
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
		abnu=stmag+21.1-2.5*alog10((lambda^2)/c)-48.6
		return,abnu
END

pro q5

;Use the routines to determine frequency and energy at 5500A.
        print,''
	;Frequency
		nu5500=lambda2nu(5500)
		print,'Frequency   at 5500 A ',nu5500,' [Hz]'
	;Energy
		energy5500=lambda2energy(5500)
		print,'Energy      at 5500 A ',energy5500,' [erg]'

;Use the routines to determine the conversion factor between flambda
;and fnu at 3000A, 5500A, and 8000A.
	;3000A
		factor3000=fnu2flambda(1.0,3000.0)
		print,'flambda/fnu at 3000 A ',factor3000,' X'
	;5500A
		factor5500=fnu2flambda(1.0,5500.0)
		print,'flambda/fnu at 5500 A ',factor5500,' X'
	;8000A
		factor8000=fnu2flambda(1.0,8000.0)
		print,'flambda/fnu at 8000 A ',factor8000,' X'

;Add a function to the module that converts STMAG to ABNU
                print,''
                print,'    Wavelength(A)','   STMAG','         ABNU'
	        for stmag=-10.,10. do begin
                	for lambda=3000.,6000.,500. do begin
				abnu=stmag2abnu(stmag,lambda)
				print,lambda,stmag,abnu
			endfor
		endfor

end

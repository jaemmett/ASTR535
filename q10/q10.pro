FUNCTION circle_area,radius
;Calculates the area of a circle 
;given a radius (radius).
	area=!pi*radius^2.0
	return,area
END

FUNCTION fnu2flambda,fnu,lambda
;Converts frequency flux [erg/cm2/s/Hz] to wavelength flux [erg/cm2/s/A]
;given a frequency flux (fnu) [erg/cm2/s/Hz]  and wavelength (lambda) [A].
	;CONSTANTS
		c=2.99792458e18  ;A/s
	;CONVERSION
		flambda=fnu*c/((lambda)^2)
		return,flambda
END

FUNCTION maglambda2flambda,mag,lambda
;Converts magnitude to wavelength flux [erg/cm2/s/A]
;given a magnitude (mag) and wavelength (lambda) [A].
	fnu=(3.64e-20)*10.0^(-mag/2.5)
	flambda=fnu2flambda(fnu,lambda)
	return,flambda	
END

FUNCTION lambda2efficiency,lambda
;Calculates total instrumental efficiency (%)
;given a wavelength (lambda) [A].
	q=0.5
	return,q
END

FUNCTION lambda2transmission,lambda
;Calculates total instrumental transmission (%)
;given a wavelength (lambda) [A].
	a=0.8
	return,a
END

FUNCTION exposure_time,counts,radius,lambda,bandwidth
;Calculates the exposure time needed to collect (counts) photons
;given a telescope aperture radius (radius) [cm], central wavelength (lambda) [A],
;and bandwidth (bandwidth) [A].
	;CONSTANTS
		c=2.99792458e18  ;[A/s]
		h=6.6260755e-27  ;[erg*s]
	;FUNCTION
       		k=circle_area(radius)*lambda2efficiency(lambda)*lambda2transmission(lambda)*maglambda2flambda(22.0,5500.0)/(h*c)
		lambda1=lambda-(bandwidth/2.0)
		lambda2=lambda+(bandwidth/2.0)
		t=counts/(k*0.5*(lambda2^2.0-lambda1^2.0))
		return,t
END

FUNCTION count_rate,radius,lambda,bandwidth
;Calculates a count rate [photons/s] 
;given a telescope aperture radius (radius) [cm], central wavelength (lambda) [A]
;and bandwidth (bandwidth) [A].
	;CONSTANTS
		c=2.99792458e18  ;A/s
		h=6.6260755e-27  ;erg*s
	;FUNCTION
		k=circle_area(radius)*lambda2efficiency(lambda)*lambda2transmission(lambda)*maglambda2flambda(22.0,5500.0)/(h*c)
		lambda1=lambda-(bandwidth/2.0)
		lambda2=lambda+(bandwidth/2.0)
		rate=(k*0.5*(lambda2^2.0-lambda1^2.0))
		return,rate
END

pro q10
	;Calculate the exposure time needed to collect 5 photons for
	;radius=50 [cm], central wavelength=5500 [A],
	;bandwidth=1000 [A]
		time=exposure_time(5.0,50.0,5500.0,1000.0)
		print,'exposure time [s]',time
	;Calculate the photon count rate for
	;radius=50 [cm], central wavelength=5500 [A],
	;bandwidth=1000 [A].
		rate=count_rate(50.0,5500.0,1000.0)
		print,'count rate [ph/s]',rate
end

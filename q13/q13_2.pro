FUNCTION lambda2flambda_vega,lambda
	flambda_vega=(3.6e-9)*(lambda/5500.0)^(-2.0)
	return,flambda_vega
END

FUNCTION lambda2maglambda,lambda,magnitude
	maglambda=magnitude
	return,maglambda
END

FUNCTION maglambda2flambda,maglambda,lambda
	flambda_vega=lambda2flambda_vega(lambda)
	flambda=flambda_vega*10.0^(-0.4*maglambda)
	return,flambda
END

FUNCTION lambda2energy,lambda
	;CONSTANTS
		c=2.99792458e18  ;A/s
		h=6.6260755e-27  ;erg*s
	energy=(h*c)/lambda
	return,energy
END

FUNCTION lambda2efficiency,lambda
	efficiency=0.5
	return,efficiency
END

FUNCTION lambda2transmission,lambda
	transmission=0.8
	return,transmission
END

FUNCTION circle_area,radius
	area=!pi*radius^2.0
	return,area
END

FUNCTION sky_signal,sky_brightness,sky_radius,zero_point
	sky_area=circle_area(sky_radius)
	count_rate_per_area=10.0^((sky_brightness-zero_point)/2.5)
	signal=sky_area*count_rate_per_area
	return,signal
END

FUNCTION read_signal,read_noise,sky_radius,pixel_scale
	sky_area=circle_area(sky_radius)
	n_pixels=sky_area/pixel_scale
	signal=n_pixels*(read_noise^2.0)
	return,signal
END

pro q13_2

        jump1:
        restore,'exposure_config.sav'

	;radius=50.0
	;lr=[5000.0,6000.0,0.0001]
	;sky_brightness=21.0
	;sky_radius=0.5
	;read_noise=5.0
	;pixel_scale=0.5
	;magnitude=22.0

	;exposure_time=515.0

	zero_point=23.5

        print,''
	print,'S/N CALCULATOR'
	print,'Parameters:'
	print,'1. Telescope Aperture Radius [cm]     ',radius
	print,'2. Sky Area Radius           [sq"]     ',sky_radius
	print,'3. Sky Brightness            [mag/sq"]',sky_brightness
	print,'4. Read-Out Noise            [e-/pix] ',read_noise
        print,'5. Pixel Scale               ["/pix]   ',pixel_scale
        print,'6. Exposure Time             [s]      ',exposure_time  
	print,'7. Magnitude                 [mag]    ',magnitude
	print,'8. Min. Wavelength           [A]      ',lr1
	print,'9. Max. Wavelength           [A]      ',lr2
	print,'10. Wavelength Interval      [A]      ',lr3
	print,'11. Zero Point Magnitude     [mag]    ',zero_point
        print,''

        read,param_num,prompt='Enter parameter # to change or enter 0 to continue: '
        if param_num eq 0 then goto, jump2
	if param_num eq 1 then read,radius,prompt='Telescope Aperture Radius [cm]: '
	if param_num eq 2 then read,sky_radius,prompt='Sky Area Radius [sq"]: '
	if param_num eq 3 then read,sky_brightness,prompt='Sky Brightness [mag/sq"]: '
	if param_num eq 4 then read,read_noise,prompt='Read-Out Noise [e-/pix]: '
	if param_num eq 5 then read,pixel_scale,prompt='Pixel Scale ["/pix]: '
	if param_num eq 6 then read,exposure_time,prompt='Exposure Time [s]: '
	if param_num eq 7 then read,magnitude,prompt='Magnitude [mag]: '
	if param_num eq 8 then read,lr1,prompt='Min. Wavelength [A]: '
	if param_num eq 9 then read,lr2,prompt='Max. Wavelength [A]: '
	if param_num eq 10 then read,lr3,prompt='Wavelength Interval [A]: '
	if param_num eq 10 then read,zero_point,prompt='Zero Point Magnitude [mag]: '
	save,radius,sky_radius,sky_brightness,read_noise,exposure_time,magnitude,lr1,lr2,lr3,pixel_scale,filename='exposure_config.sav'
        goto, jump1

        jump2:

	lr=[lr1,lr2,lr3]
	lambda=lr[0]+lr[2]*findgen(((lr[1]-lr[0])/lr[2])+1)

	maglambda=lambda2maglambda(lambda,magnitude)
	flambda=maglambda2flambda(maglambda,lambda)
	energy=lambda2energy(lambda)
	efficiency=lambda2efficiency(lambda)
	transmission=lambda2transmission(lambda)
	telescope_area=circle_area(radius)

	rate=telescope_area*flambda*efficiency*transmission/energy

	total_count_rate=total(rate)*lr[2]

	signal=exposure_time*total_count_rate
	sky_signal=sky_signal(sky_brightness,sky_radius,zero_point)
	read_signal=read_signal(read_noise,sky_radius,pixel_scale)

	signal_to_noise=signal/sqrt(signal+sky_signal+read_signal)

	print,''
	print,'S/N: ',signal_to_noise

	;print,total_count_rate
	;print,signal_to_noise

end

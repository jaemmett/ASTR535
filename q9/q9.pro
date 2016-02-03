FUNCTION binary_mag,m1,m2
;Given the magnitudes of individual stars in a binary system (m1 and m2),
;calculates the total observed magnitude of the system (m12).
	m12=m1-2.5*alog10(1.0+10.0^((m1-m2)/2.5))
	return,m12
END

pro q9

	m12=binary_mag(17.0,18.0)
	print,m12

end

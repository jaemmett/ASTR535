pro reduce_dis

;Calibration lamp spectra are plotted with detected peaks numbered.
;User assigns wavelengths to peak numbers in the 'line_numbers' and 'line_lambdas' arrays below.
;A linear fit converts pixel coordinate to wavelength (A) using the peak number/wavelength settings.

;IDL's having array dimension problems when reading in science fits images in a loop, so trying a basic reduction
;with only the first b and r science images and flats

;WAVELENGTH CALIBRATION SETTINGS
  
  ;Set threshold for line detection
  threshold_percent=4.5
  ;Set blue line numbers and wavelengths to use for blue wavelength calibration + interpolation
  line_numbers_b=[0,1,2]
  line_lambdas_b=[3888.65,4471.48,5015.68]
  ;Set red line numbers and wavelengths to use for red wavelength calibration + interpolation
  line_numbers_r=[3,6,12,16,24,28]
  line_lambdas_r=[8424.65,8115.31,7635.11,7245.17,6402.25,5875.62]

array_dimensions=[2098,1078]
overscan_range=[2060,2090]

;Directory with science_b fits files
  science_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\science_b\*')
;Directory with science_r fits files
  science_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\science_r\*')

;Subtract average of overscan region from first b and r science images

  science_b_1=mrdfits(science_b_files[0],/silent)+32768.0
  oscan_avg=mean(science_b_1[overscan_range[0]:overscan_range[1],*])
  science_b_1=science_b_1-oscan_avg

  science_r_1=mrdfits(science_r_files[0],/silent)+32768.0
  oscan_avg=mean(science_r_1[overscan_range[0]:overscan_range[1],*])
  science_r_1=science_r_1-oscan_avg
  
;Directory with BrQrtz_b (blue flats) fits files
  brqrtz_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\BrQrtz_b\*')
;Directory with BrQrtz_r (red flats) fits files
  brqrtz_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\BrQrtz_r\*')
  
;Subtract average of overscan region from first b and r brqrtz images (flats)

  brqrtz_b_1=mrdfits(brqrtz_b_files[0],/silent)+32768.0
  oscan_avg=mean(brqrtz_b_1[overscan_range[0]:overscan_range[1],*])
  brqrtz_b_1=brqrtz_b_1-oscan_avg

  brqrtz_r_1=mrdfits(brqrtz_r_files[0],/silent)+32768.0
  oscan_avg=mean(brqrtz_r_1[overscan_range[0]:overscan_range[1],*])
  brqrtz_r_1=brqrtz_r_1-oscan_avg
  
;Normalize first b and r brqrtz images

  brqrtz_b_1=brqrtz_b_1/max(brqrtz_b_1)
  brqrtz_r_1=brqrtz_r_1/max(brqrtz_r_1)
  
;Divide first b and r science images by first b and r brqrtz images (flats)

  science_b_1=science_b_1/brqrtz_b_1
  science_r_1=science_r_1/brqrtz_r_1
  
;;;HIGH RES CALIBRATION;;;
;Directory with Ar_b calibration fits files
  Ar_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\Ar_b\*')
;Directory with Ar_r calibration fits files
  Ar_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\Ar_r\*')
  
;Directory with He_b calibration fits files
  He_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\He_b\*')
;Directory with He_r calibration fits files32768
  He_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\He_r\*')
  
;Directory with Ne_b calibration fits files
  Ne_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\Ne_b\*')
;Directory with Ne_r calibration fits files
  Ne_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\Ne_r\*')

;;;LOW RES CALIBRATION;;;
;Directory with LoResAr_b calibration fits files
  LoResAr_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResAr_b\*')
;Directory with LoResAr_r calibration fits files
  LoResAr_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResAr_r\*')
  
;Directory with LoResHe_b calibration fits files
  LoResHe_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResHe_b\*')
;Directory with LoResHe_r calibration fits files32768
  LoResHe_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResHe_r\*')
  
;Directory with LoResNe_b calibration fits files
  LoResNe_b_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResNe_b\*')
;Directory with LoResNe_r calibration fits files
  LoResNe_r_files=file_search('C:\Users\Jeremy\Desktop\UT160328\LoResNe_r\*')
  
  window,0,xsize=1000,ysize=600
  !P.MULTI=[0,2,1]
  !P.Color='000000'xL
  !P.Background='FFFFFF'xL
  device,decomposed=0
  
  ;PLOT BLUE SPECTRUM + BLUE LINE NUMBERS
  
    loadct,39,/silent
    i=indgen(array_dimensions[0])
    fits_he_b=mrdfits(LoResHe_b_files[0],/silent)+32768.0
    fits_ne_b=mrdfits(LoResNe_b_files[0],/silent)+32768.0
    fits_ar_b=mrdfits(LoResAr_b_files[0],/silent)+32768.0
    fits=fits_he_b+fits_ne_b+fits_ar_b
    xsection=fits[*,1078/2]
    ;plot,/nodata,findgen(array_dimensions[0]),xsection,psym=-3,xstyle=1,ystyle=1,title='BLUE',xtitle='pix'
    peak_idx=where(xsection gt threshold_percent*mean(xsection) and (xsection[i] gt xsection[i-1]) and (xsection[i] gt xsection[i+1]))

    line_pixels_b=((findgen(array_dimensions[0]))[peak_idx])[line_numbers_b]
    interp_coeffs_b=linfit(line_pixels_b,line_lambdas_b)
    plot,interp_coeffs_b[0]+interp_coeffs_b[1]*findgen(array_dimensions[0]),xsection,psym=-3,xstyle=1,ystyle=1,title='BLUE',xtitle='wavelength (A)'
    for i=0,n_elements(peak_idx)-1 do begin
      xyouts,interp_coeffs_b[0]+interp_coeffs_b[1]*((findgen(array_dimensions[0]))[peak_idx])[i],(xsection[peak_idx])[i],i,/data,charsize=0.75,alignment=0.5
    endfor
  ;PLOT RED SPECTRUM + RED LINE NUMBERS
  
    loadct,39,/silent
    i=indgen(array_dimensions[0])
    fits_he_r=mrdfits(LoResHe_r_files[0],/silent)+32768.0
    fits_ne_r=mrdfits(LoResNe_r_files[0],/silent)+32768.0
    fits_ar_r=mrdfits(LoResAr_r_files[0],/silent)+32768.0
    fits=fits_he_r+fits_ne_r+fits_ar_r
    xsection=fits[*,1078/2]
    ;plot,/nodata,findgen(array_dimensions[0]),xsection,psym=-3,xstyle=1,ystyle=1,title='RED',xtitle='pix'
    peak_idx=where(xsection gt threshold_percent*mean(xsection) and (xsection[i] gt xsection[i-1]) and (xsection[i] gt xsection[i+1]))

    line_pixels_r=((findgen(array_dimensions[0]))[peak_idx])[line_numbers_r]
    interp_coeffs_r=linfit(line_pixels_r,line_lambdas_r)
    plot,interp_coeffs_r[0]+interp_coeffs_r[1]*findgen(array_dimensions[0]),xsection,psym=-3,xstyle=1,ystyle=1,title='RED',xtitle='wavelength (A)'
    for i=0,n_elements(peak_idx)-1 do begin
      xyouts,interp_coeffs_r[0]+interp_coeffs_r[1]*((findgen(array_dimensions[0]))[peak_idx])[i],(xsection[peak_idx])[i],i,/data,charsize=0.75,alignment=0.5
    endfor
    
    xsection_b_1=science_b_1[*,1078/2]
    xsection_r_1=science_r_1[*,1078/2]

end
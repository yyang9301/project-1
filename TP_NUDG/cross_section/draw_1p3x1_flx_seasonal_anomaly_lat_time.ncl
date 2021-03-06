;***************************************************************************
;filename:      draw_1p3x1_preci_seasonal_anomaly_lat_time.ncl
;read the 27 years PRECC and PRECL of three cases at East Asia(20N��45N��107-130E)
;then calculate the anomalous rainfall var(ncase,nlat,ntime)
;                                            by Ql_Ren
;                                           2018/03/16
;******************************************************************************
begin
path    = "/users/yangsong3/renql/project/TP_NUDG"
filein  = path +(/"/data/AMIP-CTRL/AMIP_C5PM.cam.h1.YEAR.",\
                  "/data/TP-NUDG-24h/AMIP_C5PM_TP_NUDG.cam.h1.YEAR.",\
                  "/data/TP-NUDG-6h/AMIP_C5PM_TP_NUDG.cam.h1.YEAR."/)
var_name = (/"SHFLX","LHFLX"/)
unit     = (/"W/m~S~2~N~","W/m~S~2~N~"/)   ;this can be used as right string 
years    = ispan(1979,2005,1)   ;the calculate time
nctrl = 1
nv = 1
    
minlvl = (/-18  ,-18  /)
maxlvl = (/ 18  , 18  /)
spacig = (/  1  ,  1  /)

fig_name   = path + "/cross_section/fig/1p3X1_" + var_name(nv) + "_seasonal_anomaly" + (/"_","-ctrl_"/) + "lat_time"
fig_title  = "Anomalous " + var_name(nv) + " in JJA"
    case   = (/"(a) AMIP_CTRL","(b) NUDG24h","(c) NUDG6h"/);this can be used as left string
fig_out    ="pdf";"x11"

;area:   TP , east Asia
lats = (/25 , 20/) ;-20
latn = (/40 , 45/)  ;60
lonl = (/70 ,107/)  ;20
lonr = (/105,122/);130 ;220
lat_spacing = 5
na = 0

;define the thickness and height of the title,tick and label
   tick_font      = 0.02
   subtitle_font  = 0.02
   title_font     = 0.03
   tick_thick     = 5.0
   subtitle_thick = 5.0  ;not have this attribute
   title_thick    = 5.0
   mp_thick       = 5.0

;==========================================================
;create an array(nvar,ncase,nyear) to store the data
;============================================================
f    = addfile(filein(0)+years(0)+".daily."+var_name(0)+".nc","r")
vars:= f->$var_name(0)$(:,{lats(na):latn(na)},{lonl(na):lonr(na)})
time        = cd_calendar(f->time,0)
select_time = ind(time(:,1).ge.6.and.time(:,1).le.8)
nlat  = dimsizes(vars&lat)
nlon  = dimsizes(vars&lon)
nyear = dimsizes(years)
nvar  = dimsizes(var_name)
ncase = dimsizes(filein)
var   = new((/ncase,nlat,nyear/),float)
plot  = new((/ncase/),graphic)

;---------------------------------------------------------------
;read the data
;--------------------------------------------------------------
do nc = 0 , ncase-1,1
do nt = 0,nyear-1,1
    f     = addfile(filein(nc)+years(nt)+".daily."+var_name(nv)+".nc","r")
    temp := f->$var_name(nv)$(select_time,{lats(na):latn(na)},{lonl(na):lonr(na)})
    temp := dim_avg_n_Wrap(temp,2)
    var(nc,:,nt) = dim_avg_n_Wrap(temp,0)
end do   ;the loop of 27 years
end do   ;the loop of 3 cases 

if (nctrl.eq.1) then 
    ave = dim_avg_n_Wrap(var(0,:,:),1)
    do nc = 0 , ncase-1,1
        do nt = 0, nyear-1, 1
            var(nc,:,nt)  = var(nc,:,nt) - ave
        end do
    end do   ;the loop of 3 cases 
else
    var  = dim_rmvmean_n_Wrap(var,2)
end if

copy_VarMeta(temp(0,:),var(0,:,0))
printVarSummary(var)

;==============================================================
;draw figure in twelve months (one month is a fgure)
;==================================================================
    wks = gsn_open_wks(fig_out,fig_name(nctrl) +lonl(na)+"-"+lonr(na))
    gsn_define_colormap(wks,"GMT_polar") 
    ;blue and red, has 20 colors, 2-11 is bule, 12-21 is red
    ;gsn_define_colormap(wks,"matlab_jet") 
    ;has 64 colors blue green yellow,red

    res                  = True
    res@gsnFrame         = False
    res@gsnDraw          = False
    res@gsnMaximize      = True
    res@gsnAddCyclic     = False
    res@gsnPaperOrientation = "portrait"
    ;res@vpHeightF        = 0.25
    ;res@vpWidthF         = 0.8

;--------set the form of the coordinate-----------------
    res@tiXAxisString   = "Year"
    res@tiYAxisString   = "Latitude(N)"

    res@tmXBMode        = "Explicit"
    res@tmXBValues      = ispan(0,26,3)
    res@tmXBLabels      = ispan(1979,2005,3)

    res@tmYLMode        = "Manual"
    res@tmYLTickStartF  = lats(na)
    res@tmYLTickEndF    = latn(na)
    res@tmYLTickSpacingF= lat_spacing

    res@tmXBLabelFontHeightF     = tick_font
    ; res@tmXBLabelFontAspectF   = 1.6
    res@tmXBLabelFontThicknessF  = tick_thick
    res@tmYLLabelFontHeightF     = tick_font
    ; res@tmYLLabelFontAspectF   = 1.3
    res@tmYLLabelFontThicknessF  = tick_thick
    
    ;  res@tmXBMajorOutwardLengthF = -0.
    ;  res@tmYLMajorOutwardLengthF = -0.
    ;  res@tmYRMajorOutwardLengthF = -0.
      
    ;  res@tmXBMinorOutwardLengthF = -0.
    ;  res@tmYLMinorOutwardLengthF = -0.
    ;  res@tmYRMinorOutwardLengthF = -0.

;---------set the attribute of the contour-----------------
    res@cnFillOn         = True
    res@cnLinesOn        = False ;True
    res@cnLineLabelsOn   = False
    res@cnInfoLabelOn    = False
   
    ;res@cnLevelSelectionMode = "AutomaticLevels"   ; set manual contour levels
    ;res@cnLevelSelectionMode = "ExplicitLevels"   ; set manual contour levels
    ;res@cnLevels             = (/-5,-4.5,-4,-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5/)
    ;res@cnLevels             = ispan(0,60,10)
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnLevelSpacingF       = spacig(nv)        ; set contour interval
    res@cnMaxLevelValF        = maxlvl(nv) ;32    ; set max contour level
    res@cnMinLevelValF        = minlvl(nv)       ; set min contour level

    res@gsnSpreadColors      = True              ; turn of the full color map
    res@gsnSpreadColorStart  = 2                ; start at color 17
    res@gsnSpreadColorEnd    = 21                ; end at color 200
    
    res@lbLabelBarOn         = False   ; the label bar
    res@lbOrientation        = "vertical"
    res@lbLabelFontHeightF   = tick_font              ; make labels smaller
    res@lbLabelStride        = 2

;------------------------------------------------------------------
;draw the subgraph and change the left and right titles
;-----------------------------------------------------------------------
   ; res@tiMainString         = fig_title + "in" + months(m)
    ;res@tiMainFontHeightF    = 0.04
   ; res@tiMainFontColor      = "black"
    res@gsnCenterString      = ""
    res@gsnRightStringFontHeightF = subtitle_font
    res@gsnLeftStringFontHeightF  = subtitle_font
    res@gsnRightString  = unit(nv)   ;"siglvl: " + siglvl

    resp  = True    
    resp@gsnMaximize   = True
    resp@gsnPaperOrientation = "landscape";"portrait"
    resp@gsnPanelLabelBar = True
    resp@lbOrientation    = "Horizontal"
    resp@lbLabelStride    = 2
    ;resp@pmLabelBarWidthF  = 0.5
    ;resp@pmLabelBarHeightF = 0.05
    ;resp@lbLabelFontHeightF = tick_font
    ;resp@lbLabelFontThicknessF = tick_thick
    resp@txFontHeightF = title_font 
    resp@txFontThicknessF = title_thick

    do nc = 0, ncase-1,1
        res@gsnLeftString   = case(nc)
        plot(nc)     = gsn_csm_lat_time(wks,var(nc,:,:),res)
        print(max(var(nc,:,:)))
        print(min(var(nc,:,:)))
    end do 

    resp@txString      = fig_title + " (" + lonl(na) + " - " + lonr(na) + "E)"
    gsn_panel(wks,plot,(/1,3/),resp)
end



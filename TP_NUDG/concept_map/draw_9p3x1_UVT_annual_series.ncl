;***************************************************************************
;filename:      draw_1p3x1_annual_series_T.ncl
;plot the every year's annual cycle(365day) of TP average UVT(27 curves) 
;then overlaying the climate annual cycle(black bold curve)
;and one panel has three plots.
;                                            by Ql_Ren
;                                           2017/03/19
;******************************************************************************
begin
;the path of the file
path     = "/users/yangsong3/renql/project/TP_NUDG"
filename = path + "/concept_map/mdata/" + (/"CTRL","NUDG24h","NUDG6h"/) + "-UVT_TP_annual_series.nc"
case     = (/"AMIP_CTRL","NUDG24h","NUDG6h"/);this can be used as left string
var_name = (/"series","ave"/)
draw_var = (/"U","V","T"/)
unit     = (/"m/s","m/s","~S~o~N~C"/)   ;this can be used as right string 
years    = ispan(1979,2005,1)   ;the calculate time

;area of TP 
lats = 25 
latn = 40
lonl = 70
lonr = 105
lev  = (/850,500,200/)
nl = 2
nv = 1

fig_name   = path + "/concept_map/fig/1p3X1_annual_cycle"; + lev(nl) + draw_var(nv)
fig_title  = "Annual Cycle of " ; + lev(nl) + "hPa " + draw_var(nv) 
fig_out    ="pdf";"x11"

;define the thickness and height of the title,tick and label
   tick_font      = 0.02
   subtitle_font  = 0.02
   title_font     = 0.03
   label_font     = 0.015
   tick_thick     = 5.0
   subtitle_thick = 5.0  ;not have this attribute
   title_thick    = 5.0
   label_thick    = 1.5
   mp_thick       = 5.0

;==========================================================
;create an array(nvar,ncase,nyear) to store the data
;============================================================
nyear = dimsizes(years)
ncase = dimsizes(case)
nvar  = dimsizes(draw_var)
nlev  = dimsizes(lev)
var         = new((/ncase,nvar,nyear,365,nlev/),float)
ave         = new((/ncase,nvar,      365,nlev/),float)
plot        = new((/ncase/),graphic)
plot2       = new((/ncase/),graphic)

;---------------------------------------------------------------
;read the data, then calculate the area and season average
;--------------------------------------------------------------
do nc = 0,ncase-1,1
    f    = addfile(filename(nc),"r")
    var(nc,:,:,:,:)  = f->$var_name(0)$     ;(nv,:,:,nl)
    ave(nc,:,:,:)    = f->$var_name(1)$     ;(nv,:,nl)
end do   ;the loop of the three cases

var(:,2,:,:,:) = var(:,2,:,:,:) - 273.15   ;convert unit from k to c
ave(:,2,:,:)   = ave(:,2,:,:)   - 273.15
printVarSummary(var)
printVarSummary(ave)

;===============================================
;draw the figure
;=============================================
wks = gsn_open_wks(fig_out,fig_name)

    gsn_define_colormap(wks,"matlab_jet") 
    ;has 64 colors blue green yellow,red

    resxy     = True
    resxy@vpWidthF  = 0.9
    resxy@vpHeightF = 0.25
    resxy@gsnFrame      = False
    resxy@gsnDraw       = False
    resxy@gsnMaximize   = True
    resxy@gsnPaperOrientation = "portrait"
    
    resxy@xyDashPatterns    = 0 ;(/0,0,0/)
    resxy@xyLineThicknesses = 2.0;(/2.0, 2.0,2.0/)   ; make second line thicker
    resxy@xyLineColors      = ispan(4,56,2)
    resxy@tiXAxisOn = False
    resxy@tiYAxisOn = False
    ;resxy@trYMinF = floor(min(var))
    ;resxy@trYMaxF = ceil(max(var))
    
    ;resxy@tmXBLabelFontHeightF     = tick_font-0.01
    ;resxy@tmXBLabelFontThicknessF  = tick_thick-1.0 
    ;resxy@tmYRLabelFontHeightF     = tick_font
    ;resxy@tmYRLabelFontThicknessF  = tick_thick

    resxy@tmXBMinorOn          = False ; Turn off x-axis (bottom) minor ticks
    resxy@tmXTMinorOn          = False ; Turn off x-axis (tottom)minor ticks
    resxy@tmXTOn               = False ; Turn off x-axis (top) major ticks
    resxy@tmYRMinorOn          = False ; Turn off y-axis (right) minor ticks
    resxy@tmYLMinorOn          = False ; Turn off y-axis (left) minor ticks
    resxy@tmYROn               = False ; Turn off y-axis (right) major ticks
    
    ;resxy@tmXBMajorLengthF = 0.01
    ;resxy@tmYRMajorLengthF = 0.01
    ;resxy@tmXBMode           = "Manual"
    ;resxy@tmXBTickSpacingF   = 30
    ;resxy@tmXBTickStartF     = 0
    ;resxy@tmXBTickEndF       = 365
    resxy@tmXBMode            = "Explicit"
    resxy@tmXBValues          = ispan(0,360,30)
    resxy@tmXBLabels          = ispan(0,360,30)
    
    resxy@tmXMajorGrid                   = True
    resxy@tmXMajorGridLineDashPattern    = 2
    resxy@tmXMajorGridLineColor          = "gray"
    resxy@tmXMajorGridThicknessF         = 2.0
                             
    resxy@gsnCenterStringFontHeightF = subtitle_font-0.005
    resxy@gsnRightStringFontHeightF  = subtitle_font
    resxy@gsnLeftStringFontHeightF   = subtitle_font
    resxy@gsnCenterString  = "";lev(nl) + " hPa" 

    resxy2 = resxy
    resxy2@xyMonoLineColor  = True
    resxy2@xyMonoLineThickness = True
    resxy2@xyLineThicknessF = 6.0;(/2.0, 2.0,2.0/)   ; make second line thicker
    resxy2@xyLineColor      = "black"

do nv = 0,nvar-1,1
do nl = 0,nlev-1,1
do nc = 0, ncase-1,1
    resxy@gsnLeftString    = case(nc)
    resxy@gsnRightString   = unit(nv)
    resxy@trYMinF = floor(min(var(:,nv,:,:,nl)))
    resxy@trYMaxF =  ceil(max(var(:,nv,:,:,nl)))
    plot(nc)  = gsn_csm_xy(wks,var&day,(/var(nc,nv,:,:,nl)/),resxy)
    plot2(nc) = gsn_csm_xy(wks,var&day,(/ave(0,nv,:,nl)/),resxy2)
    overlay(plot(nc),plot2(nc))
end do
    
    resp  = True    
    resp@gsnMaximize   = True
    resp@txString      = fig_title + lev(nl) + "hPa " + draw_var(nv)
    resp@txFontHeightF = title_font 
    resp@txFontThicknessF = title_thick
   gsn_panel(wks,plot,(/3,1/),resp)
end do
end do
end

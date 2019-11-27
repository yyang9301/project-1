;*********************************************************************
;Draw the vertical section of monthly EKE (shaded)
;                                                     by Ql Ren
;                                                    2019/08/12
;*********************************************************************************
begin
month_option = True 
year_option = True   ;False;calc yearly DJF 
var_option = 2  ;0 means Qd; 1 means f_Qd; 2 means dzdt; 3 means duTdx; 4 means dzdt induced by b1
na = 2 ; "TP","EA","NH"

if(var_option.eq.0) then 
    draw_var = (/"Qd"   ,"Qeddy","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"Qd"   ,"Qeddy"/)  ;use to read variables
    unit     = (/"K/Day","K/Day","K/day"/)  ;this can be used as right string 
end if
if(var_option.eq.1) then 
    draw_var = (/"fQd" ,"fQeddy","A","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"f_Qd","f_Qeddy","A","total"/)  ;use to read variables
    unit     = "10~S~-11~N~" + (/"s~S~-2~N~","s~S~-2~N~","s~S~-2~N~","s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.2) then 
    draw_var = (/"fQd" ,"fQeddy","A","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"dzdt","dudt","dTdt","dbdt"/)  ;
    unit     = (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-6~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)"/)  ;this can be used as right string 
    nnv = 0 ;used to read dzdt induced by different forcing
    select = (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.3) then
    var_name = (/"Qeddy","A"/)  ;
    unit     = (/"K/Day","10~S~-10~N~s~S~-2~N~"/)
    nnv = 1 ;used to read dzdt induced by different forcing
    if(nnv.eq.0) then 
        draw_var = (/"-duTdx", "-dvTdy", "-dwTdz", "wT", "Qeddy"/)  ;this is the variable used to draw, can used as center string
        select   = (/0,1,2,3/)
    else
        draw_var = (/"-duVdx", "-dvVdy", "A"/)  ;this is the variable used to draw, can used as center string
        select   = (/0,1/)
    end if
end if
if(var_option.eq.4) then 
    draw_var = (/"b1","b2","b3","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"dzdt","dudt","dTdt","dbdt"/)  ;
    unit     = (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-5~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)"/)  ;this can be used as right string 
    nnv = 0 ;used to read dzdt induced by different forcing
    select = (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.5) then
    var_name = (/"Qeddy","A"/)  ;
    unit     = (/"K*m/s","m/s~S~2~N~"/)
    nnv = 0 ;used to read dzdt induced by different forcing
    if(nnv.eq.0) then 
        draw_var = (/"uT", "vT", "wT", "total"/)  ;this is the variable used to draw, can used as center string
        select   = (/0,1,2/)
    else
        draw_var = (/"uS", "vS", "wS", "total"/)  ;this is the variable used to draw, can used as center string
        select   = (/0,1,2/)
    end if
end if
months   = (/"DJF"/)
;lev  = (/1000, 925, 850, 700, 600, 500, 400, 300, 250, 200, 150, 100/) 
;months   = (/"JF","MA","MJ","JA"/)
;lev  = (/1000,975,950,925,900,875,850,825,800,775,750,700,650,600,550,500,450,400,350,300,250,225,200,175,150,125,100/)
lev  = (/800,750,700,650,600,550,500,450,400,350,300,250,200,150,100/)

;area: east Asia
area = (/"TP","EA","NH"/)
lats = (/15  ,15  , 0  /);20 ;-20
latn = (/55  ,55  , 89 /) ;55 ;60
lonl = (/70  ,110 , 1  /) ;30 ;20
lonr = (/105 ,130 ,359 /) ;150;220
month_s = 1
month_e = 8

;the path of the file
path   = "/home/ys17-19/renql/project/TP_NUDG/observation-20190127/"
gtopfile = "/home/ys17-19/data-observation/ERA-interim/gtopo_1.5x1.5.nc"
;case   = "ERA-Interim"
case   = "NCEP1"

if(var_option.le.1)
    if(month_option) then
    filename = path + "mdata/" + case + "_Clim_month_Qd_Qeddy_A.nc"
    else
    filename = path + "mdata/" + case + "_Clim_daily_Qd_Qeddy_A.nc"
    end if
    if(year_option) then
    filename = path + "mdata/" + case + "_DJF_Qd_Qeddy_A.nc"
    end if
    fig_name = path + "fig/1p2x3_height_lat_" + var_name(0) + area(na)
end if
if(var_option.eq.2)
    if(month_option) then
    filename = path + "mdata/" + case + "_DJF_dzdt_19.nc"
    else
    filename = path + "mdata/" + case + "_Clim_daily_dzdt.nc"
    end if
    fig_name = path + "fig/1p2x3_height_lat_" + var_name(nnv) + area(na)
end if
if(var_option.eq.3)
    filename = path + "mdata/" + case + "_Clim_month_eddy_flux.nc"
    fig_name = path + "fig/1p2x3_height_lat_eddy_flux_" + var_name(nnv) + area(na)
end if
if(var_option.eq.4)
    filename = path + "mdata/" + case + "_Clim_dzdt_monthly_advection.nc"
    fig_name = path + "fig/1p2x3_height_lat_advect_" + var_name(nnv) + area(na)
end if
if(var_option.eq.5)
    filename = path + "mdata/" + case + "-Clim_month_eddy_flux2.nc"
    fig_name = path + "fig/1p2x3_height_lat_eddy_flux2_" + var_name(nnv) + area(na)
end if

;fig_title  = "Seasonal " + draw_var(nv) + " variance in " ;+season
pre_case   = (/"(a","(b","(c","(d","(e","(f","(g","(h","(i","(j","(k","(l","(m","(n","(o","(p","(q","(r","(s","(t","(u"/)
fig_out    ="pdf";"x11"

f = addfile(filename,"r")
if(var_option.le.1)
    vars = f->$var_name(0)$(0,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
else
    vars = f->$var_name(nnv)$(0,0,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
end if
nmonth = dimsizes(months)
nlat   = dimsizes(vars&lat)
nlon   = dimsizes(vars&lon)
nlev   = dimsizes(lev)
nvar   = dimsizes(draw_var)
ncase  = dimsizes(case)
if(.not.(month_option)) then 
    time = cd_calendar(f->time,0)
    select_time = ind(time(:,1).ge.month_s.and.time(:,1).le.month_e)
    ntime = dimsizes(select_time)
    var   = new((/nvar,ntime,nlev,nlat,nlon/),double)
end if
;var_m = new((/nvar,nmonth,nlev,nlat,nlon/),double)
var_m = new((/nvar,nmonth,nlev,nlat,nlon/),float)

;the number of the panel plot
    plot     = new((/nvar*nmonth/),graphic)

;define the thickness and height of the title,tick and label
   tick_font      = 0.03
   subtitle_font  = 0.03
   title_font     = 0.03
   tick_thick     = 8.0
   subtitle_thick = 8.0  ;not have this attribute
   title_thick    = 5.0
   mp_thick       = 3.0
   font_index     = 22

;================================================================
;read data
;====================================================================
if(month_option) then
    f = addfile(filename,"r")
    if(var_option.le.1)
        do nv = 0, nvar-2,1
        if(year_option) then 
        var_m(nv,0,:,:,:)  = dim_avg_n_Wrap(f->$var_name(nv)$(:,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}),0) ;get an array (ncase,nmonth,nlat,nlon)
        else
        var_m(nv,:,:,:,:)  = f->$var_name(nv)$(:,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end if
        end do
    else
        var_m(0:(nvar-2),:,:,:,:)  = f->$var_name(nnv)$(select,:,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
    end if
else
    f = addfile(filename,"r")
    if(var_option.le.1)
        do nv = 0, nvar-2,1
        var(nv,:,:,:,:)  = f->$var_name(nv)$(select_time,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end do
    else
        var(0:(nvar-2),:,:,:,:)  = f->$var_name(nnv)$(select,select_time,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
    end if
    ;calc ealy(56) and late(78) stage of the summer 
    select_time := ind(time(:,1).ge.5.and.time(:,1).le.6)
    var_m(:,0,:,:,:) = dim_avg_n(var(:,select_time,:,:,:),1)
    select_time := ind(time(:,1).ge.7.and.time(:,1).le.8)
    var_m(:,1,:,:,:) = dim_avg_n(var(:,select_time,:,:,:),1)
end if
var_m := dim_avg_n(var_m,4)
var_m(nvar-1,:,:,:) = dim_sum_n(var_m(0:(nvar-2),:,:,:),0)
copy_VarMeta(vars(:,:,0),var_m(0,0,:,:))
printVarSummary(var_m)

if(var_option.eq.0) then 
    var_m = var_m*24*3600 ;convert units of Q from K/s to K/Day 
end if

if(var_option.eq.1) then 
    var_m = var_m*10^11
end if

if((var_option.eq.2).or.(var_option.eq.4)) then
if(nnv.eq.0) then
    var_m = var_m*10^3
end if
if(nnv.eq.1) then
    var_m = var_m*10^6
end if
if(nnv.eq.2) then
    var_m = var_m*10^6
end if
if(nnv.eq.3) then
    var_m = var_m*10^12
end if
end if

if(var_option.eq.3) then
if(nnv.eq.0) then
    var_m = var_m*24*3600 ;convert units of Q from K/s to K/Day 
else
    var_m = var_m*10^10
end if
end if

;if(var_option.eq.5) then
;if(nnv.eq.0) then
;    var_m = var_m*24*3600 ;convert units of Q from K/s to K/Day 
;else
;    var_m = var_m*10^10
;end if
;end if
printVarSummary(var_m)

;==============================================================
;draw figure in twelve months (one month is a fgure)
;==================================================================
    wks = gsn_open_wks(fig_out,fig_name)
    gsn_define_colormap(wks,"BlueDarkRed18")
    ;blue and red, has 18 colors,2-10 is blue
    ;gsn_define_colormap(wks,"GMT_polar") 
    ;blue and red, has 20 colors, 2-11 is bule, 12-21 is red
    ;gsn_define_colormap(wks,"matlab_jet") 
    ;has 64 colors blue green yellow,red

    res                  = True
    res@gsnFrame         = False
    res@gsnDraw          = False
    res@gsnMaximize      = True
    res@gsnAddCyclic     = False
    res@gsnPaperOrientation = "portrait"
    res@vpHeightF        = 0.6
    res@vpWidthF         = 0.8

;--------set the form of the coordinate-----------------
    res@tmBorderThicknessF  = mp_thick
    res@tmXBLabelFont   = font_index
    res@tmYLLabelFont   = font_index
    res@tmXBLabelFontHeightF     = tick_font
    ; res@tmXBLabelFontAspectF   = 1.6
    res@tmXBLabelFontThicknessF  = tick_thick
    res@tmYLLabelFontHeightF     = tick_font
    ; res@tmYLLabelFontAspectF   = 1.3
    res@tmYLLabelFontThicknessF  = tick_thick
    
    res@tmXBMajorThicknessF     = mp_thick
    res@tmYLMajorThicknessF     = mp_thick
    ;  res@tmXBMajorOutwardLengthF = -0.
    ;  res@tmYLMajorOutwardLengthF = -0.
    ;  res@tmYRMajorOutwardLengthF = -0.
      
    res@tmXBMinorThicknessF     = mp_thick
    res@tmYLMinorThicknessF     = mp_thick
    ;  res@tmXBMinorOutwardLengthF = -0.
    ;  res@tmYLMinorOutwardLengthF = -0.
    ;  res@tmYRMinorOutwardLengthF = -0.

;---------set the attribute of the contour-----------------
    res@cnFillOn         = True
    res@cnLinesOn        = False
    res@cnLineLabelsOn   = False
    res@cnInfoLabelOn    = False
;    res@cnLineThicknessF = 1.0

    res@gsnSpreadColors      = False              ; turn of the full color map
    res@gsnSpreadColorStart  = 9    ;This resource only takes effect if gsnSpreadColors is set to True 
    res@gsnSpreadColorEnd    = 0                ; end at color 200
    
    res@lbLabelBarOn         = True   ; the label bar
    res@lbOrientation        = "Horizontal"
    res@lbLabelFontHeightF   = tick_font              ; make labels smaller
    res@lbLabelFont          = font_index              ; make labels smaller
    res@lbLabelStride        = 1
    res@lbBoxLineThicknessF  = mp_thick-1

    res@pmLabelBarZone               = 0
    res@pmLabelBarOrthogonalPosF     = 0
    res@pmLabelBarParallelPosF       = 0.5

;------------------------------------------------------------------
;draw the subgraph and change the left and right titles
;-----------------------------------------------------------------------
    res@gsnCenterString      = ""
    res@gsnStringFont        = font_index
    res@gsnStringFontHeightF = subtitle_font
    
    res@gsnPresHgtHeightLabelOn = False
    res@tiYAxisOn = False
    res@tmYRLabelsOn = False
    res@tmXBMode = "Manual"
    res@tmXBTickSpacingF   = 10
    res@tmXBTickStartF     = lats(na)
    res@tmXBTickEndF       = latn(na)

;---------set the attribute of the contour-----------------
    res_line = res
    res_line@cnFillOn         = False
    res_line@cnLinesOn        = True
    res_line@cnLineLabelsOn   = True
    res_line@cnInfoLabelOn    = False
    res_line@cnLineThicknessF = 3.0
    res_line@cnLineColor      = "black"
   
    res_line@cnLevelSelectionMode = "AutomaticLevels"   ; set manual contour levels
    res_line@cnLevelSpacingF       = 10        ; set contour interval

    resp  = True    
    resp@gsnMaximize   = True
    resp@gsnPaperOrientation = "landscape";"portrait"
    ;resp@gsnPanelLabelBar = True
    ;resp@pmLabelBarWidthF  = 0.5
    ;resp@pmLabelBarHeightF = 0.05
    ;resp@lbLabelFontHeightF = tick_font
    ;resp@lbLabelFontThicknessF = tick_thick
    resp@txFontHeightF = title_font 
    resp@txFontThicknessF = title_thick

if(var_option.eq.0) then 
    minlvl = (/-2.4,-2.4,-2.4/);
    maxlvl = (/ 2.4, 2.4, 2.4/);
    spacig = (/ 0.3, 0.3, 0.3/);
end if

if(var_option.eq.1) then
    minlvl = (/-14,-14,-14,-14/);-8,-8,-8,-8,
    maxlvl = (/ 14, 14, 14, 14/); 8, 8, 8, 8,
    spacig = (/ 2 , 2 , 2 , 2 /); 1, 1, 1, 1,
end if
    
if((var_option.eq.2).or.(var_option.eq.4)) then
if(nnv.eq.0) then   ;dzdt
    minlvl = (/-3.5,-3.5,-3.5,-3.5/);
    maxlvl = (/ 3.5, 3.5, 3.5, 3.5/);
    spacig = (/ 0.5, 0.5, 0.5, 0.5/);
end if
if(nnv.eq.1) then ;dudt
    minlvl = (/-21,-21,-21,-21/);-8,-8,-8,-8,
    maxlvl = (/ 21, 21, 21, 21/); 8, 8, 8, 8,
    spacig = (/ 3 , 3 , 3 , 3 /); 1, 1, 1, 1,
end if
if(nnv.eq.2) then ;dTdt
    minlvl = (/-16,-16,-16,-16/);
    maxlvl = (/ 16, 16, 16, 16/);
    spacig = (/  2,  2,  2,  2/);
end if
if(nnv.eq.3) then ;dbdt
    minlvl = (/-24,-24,-24,-24/);
    maxlvl = (/ 24, 24, 24, 24/);
    spacig = (/  3,  3,  3,  3/);
end if
end if

if(var_option.eq.3) then 
if(nnv.eq.0) then
    minlvl = (/-1.6,-1.6,-1.6,-1.6,-1.6/);-2.4,-2.4,-2.4,-2.4,-2.4/);-0.8,-0.8,-0.8,-0.8,-0.8/);
    maxlvl = (/ 1.6, 1.6, 1.6, 1.6, 1.6/); 2.4, 2.4, 2.4, 2.4, 2.4/); 0.8, 0.8, 0.8, 0.8, 0.8/);
    spacig = (/ 0.2, 0.2, 0.2, 0.2, 0.2/); 0.3, 0.3, 0.3, 0.3, 0.3/); 0.1, 0.1, 0.1, 0.1, 0.1/);
else
    minlvl = (/-0.8,-0.8,-0.8/);
    maxlvl = (/ 0.8, 0.8, 0.8/);
    spacig = (/ 0.1, 0.1, 0.1/);
end if
end if

if(var_option.eq.5) then 
if(nnv.eq.0) then
    minlvl = (/-24,-8,-0.16,-24/);
    maxlvl = (/ 24, 8, 0.16, 24/);
    spacig = (/  3, 1, 0.02,  3/);
else
    minlvl = (/-0.8,-0.8,-0.8,-0.8/);
    maxlvl = (/ 0.8, 0.8, 0.8, 0.8/);
    spacig = (/ 0.1, 0.1, 0.1, 0.1/);
end if
end if

    ;res@cnFillPalette = "BlueDarkRed18"
   ;blue and red, has 18 colors,2-10 is blue
    res@cnFillColors  = (/2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19/)
do nm = 0,nmonth-1,1
do nv = 0,nvar-1,1
    np = nm*nvar + nv
    res@gsnLeftString   = pre_case(np) + ") " + case + " " + months(nm) 
    if(var_option.ge.2) then 
    res@gsnRightString  = lonl(na) + "-" + lonr(na) + "E " + draw_var(nv) + " (" + unit(nnv) + ")"
    else
    res@gsnRightString  = lonl(na) + "-" + lonr(na) + "E " + draw_var(nv) + " (" + unit(nv) + ")"
    end if
    ;res@gsnSpreadColors       = False              ; turn of the full color map
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnLevelSpacingF       := spacig(nv)        ; set contour interval
    res@cnMaxLevelValF        := maxlvl(nv) ;32    ; set max contour level
    res@cnMinLevelValF        := minlvl(nv)       ; set min contour level
    plot(np) = gsn_csm_pres_hgt(wks,var_m(nv,nm,:,:),res)
    print(max(var_m(nv,nm,:,:)))
    print(min(var_m(nv,nm,:,:)))
end do 
end do 

;    resp@txString      = fig_title
    gsn_panel(wks,plot,(/nmonth,nvar/),resp)
end
